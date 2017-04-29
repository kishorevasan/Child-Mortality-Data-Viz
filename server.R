source("finalproject.R")
library(shiny)
library(shinythemes)
library(dplyr)
library(ggplot2)
library(plotly)
library(maps)
library(stringr)
library(mgcv)


server<- function(input,output){
  
  output$result <- renderText({
    if(input$gender == "Either"){
      gender <- ""
      col <- paste0("avg.", input$year2)
    } else {
      gender <-tolower(input$gender)
      col <- paste0((substr(gender, 1, 1)), input$year2)
    }
    rate <- cleaned.data[[col]][min(which(countries == input$country2))]
    total = round(1000*(1/rate))
    result <- paste0("For every ",total," ",gender," children born in ",input$country2," in ",input$year2,", one did not live past the age of five.")
    return(result)
  })
  
  selectedData <- reactive({
    year <- c("1990","2000","2010","2015")
    country.specific<-filter(cleaned.data,countries==input$country2)
    m.data <- c(country.specific$"m1990",country.specific$"m2000",country.specific$"m2010",country.specific$"m2015")
    f.data <- c(country.specific$"f1990",country.specific$"f2000",country.specific$'f2010',country.specific$"f2015")
    return(data.frame(year,m.data,f.data))
  })
  
  
  
  scatterData <- reactive({

    if(input$showall){
      return(scatter.plot)
    }else{
      return(scatter.plot %>% filter(year==paste0("X", input$slider)))
    }

  })
  
  mapData <- reactive ({
    world <- map_data("world")
    world <- mutate (world, ISO3 = iso.alpha(region, n = 3))
    world <- world[world$region != "Antarctica",]
    world <- left_join (world, cleaned.data, by = c("ISO3" = "countries.iso"))
    return(world)
  })

  output$map <- renderPlot ({
  ggplot() + 
      geom_map(data=mapData(), map=mapData(), aes_string(x = "long", y = "lat", map_id="region", fill=paste0("avg.", input$year2))) +
      scale_fill_gradient2(low = "green", mid="yellow", high = "red", na.value="white",limits=c(0,332), name = "U5 deaths out of 1000")+
      theme(panel.background = element_rect(color = "black", fill = "white"))+
      labs (x = "", y = "") + 
      theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank()) + 
      theme(axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank())
  })
  
  output$plot1 <- renderPlotly({
    plot_ly(selectedData(),x=selectedData()$year,type="scatter",y=selectedData()$m.data,name="Male",mode="lines+Markers")%>%
      add_trace(y=selectedData()$f.data,name="Female")%>%
      layout(xaxis=list(title="Year"),
             yaxis=list(title="Mortality Rates"))
  })
 
  
  output$dpt <- renderPlot({
    dpt <- ggplot(data=scatterData(), mapping=aes(x=dpt, y=mort)) + geom_point() + geom_smooth() + 
    labs(title = "Mortality Rate vs. DPT Vaccination", x = "DPT Vaccination %", y = "Mortality Rate" )
    return(dpt)
  })
  output$measles <- renderPlot({
    measles <- ggplot(data=scatterData(), mapping=aes(x=measles, y=mort)) + geom_point() + geom_smooth() +
    labs(title = "Mortality Rate vs Measles Vaccination", x = "Measles Vaccination %", y = "Mortality Rate")  
    return(measles)
  })
  
  output$scatter3d <- renderPlotly({
    plot_ly(scatterData(),text=~paste(scatterData()$Country, substr(scatterData()$year, 2, 5)),x= (scatterData()$dpt*10),y= (scatterData()$measles*10),z= (scatterData()$mort/10), size=I(2),
        color=(scatterData()$gdp)^(1/10))%>%
      add_markers()%>%
      layout(scene=list(
        xaxis = list(title="DPT Vaccinations (out of 1000)", width=I(3)),
        yaxis = list(title="Measles Vaccinations (out of 1000)", width=90),
        zaxis = list(title="Child Mortality %"))
      ) %>% hide_colorbar()
  })
}