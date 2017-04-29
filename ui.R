source("server.R")


ui = fluidPage(theme=shinytheme("superhero"),
  titlePanel("Child Mortality and Vaccinations"),
  h4("This report deals with child mortality rates for children under five (U5).  On average, twenty-one children under the age of five die each minute. Although this number has decreased 
    by almost half since 1990, the world still has a long way to go in reducing the rate of child
    mortality. However, two thirds of child deaths are preventable. By giving children vaccines, oral rehydration
    therapy, and improved education in developing countries, many children would be saved at a low cost. Our goal is 
    to bring awareness to child mortality and what you can do to help prevent the deaths of children throughout the world,
     as well as the ways that vaccinations have brought down child deaths."),
  br(),
  sidebarLayout(
    sidebarPanel(
      h3(textOutput("result")),
      br(),
      selectInput("gender","Gender", choices=list("Male", "Female", "Either")),
      selectInput("country2", "Country", choices=countries),
      selectInput("year2", "Year", choices=list(1990,2000,2010,2015))
      
    ), mainPanel(
      
      h2("Male and Female U5 Mortality Rates:"),
      plotlyOutput("plot1"),
      h5("This line graph shows the child mortality rates for females and males in a given country throughout
         the last 25 years. Each country has a general trend of a decline in deaths from 1990 to 2015,
         which could be caused by increased vaccinations and treatment for pneumonia, among other factors.")
      
    )
  ),
  
  plotOutput ("map"),
  h5("This world map shows the child mortality rate per country in a given year. In 1990, some countries
     had u5 child deaths reach numbers as high as 332 per every 1000 children. However, 
     as the year of the map gets closer to the present, one can see that child mortality overall
     decreases by a substantial amount.  (Select the year using the dropdown above.)"),
  
  
  br(),



  h4("Data shows that access to immunizations lead to fewer U5 child deaths. This is one reason why child mortality
     is steadily decreasing, as more infants are immunized now than ever before. According to PRB, or the
     Population Reference Bureau, 106 million infants were immunized in 2008. In recent years, developing countries have 
     seen a growth of manufactures of vaccines, allowing for better and easier immunization coverage in these countries.
     However, the availability of these vaccines in developing countries is still much lower than the availability in developed countries.
     UNICEF has stated that with 1 billion dollars, vaccines could be available for all children in the 72 poorest countries."),
     
  
  sidebarLayout(
    sidebarPanel(
      checkboxInput("showall","Show All Years?",value=TRUE),
      sliderInput("slider", label="Year", min=1991, max=2015, value=1990),
      plotOutput("measles"), 
      plotOutput("dpt"),
      h5("These scatter plots show the relationship between Measles/DPT vaccination rates, mortality rates.")
      
    ),
   
    mainPanel(
      plotlyOutput("scatter3d", height=700, width="100%"),
      h5("This 3d scatter plot shows the relationship between measles vaccination rates, DPT vaccination rates, and child mortality rates over various years.
       Color is used to represent GDP, with lighter colors representing higher GDP.  Selecting Show All Years shows the trend across years.")
      
    )
  ),
  h4("There is a general trend that shows that in countries that have higher
  vaccine rates, the mortality rate is lower, and countries with a lower vaccine rate have a higher mortality rate. Also, countries 
  have a higher income are mostly at the point on the graph where there is a high vaccine rate and a low mortality rate.
  The high concentration of countries in the lower right hand corner of each graph could be developed countries, 
  where citizens are more likely to have access to these vaccines and other solutions to child mortality."),
  br(),
  
  h2("Conclusion"),
  h4("While child mortality rates have decreased tremendously in the last 25 years, there is more work 
  to be done. Many of these deaths could be completely preventable if the family and community of these
  children were given the proper resources. Organizations like World Vision and UNICEF seek to help end child mortality
  by working with communities to improve the resources governments give to families and hoispitals, as well as
  educating families  to be aware of the signs of diseases and how to prevent them altogether. If you feel compelled to
  donate to UNICEF to help end child mortality due to preventable causes, please click the link below."),
  h4(a("Donate here", href="https://www.unicefusa.org/donate/help-save-childrens-lives/29161")),
  
  p("Sources:"),
  a("http://childmortality.org/", href="http://childmortality.org/"),
  p(),
  a("http://www.who.int/mediacentre/factsheets/fs286/en/", href="http://www.who.int/mediacentre/factsheets/fs286/en/"),
  p(),
  a("http://www.prb.org/Publications/Articles/2009/childmortality.aspx", href="http://www.prb.org/Publications/Articles/2009/childmortality.aspx"),
  p(),
  a("http://www.who.int/mediacentre/factsheets/fs178/en/", href="http://www.who.int/mediacentre/factsheets/fs178/en/")
  
)

shinyApp(ui,server, options=list(height=2900))
