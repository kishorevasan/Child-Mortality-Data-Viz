library(dplyr)
library(tidyr)

data <- read.csv("data/Sex-specific U5MR estimates-Table 1.csv",stringsAsFactors = FALSE)
countries <- unique(data$X[8:592])
countries.m <- list("m1990"=as.numeric(data$X.2[8:592][seq(2,584,3)]),"m2000"=data$X.3[8:592][seq(2,584,3)],"m2010"=data$X.4[8:592][seq(2,584,3)],"m2015"=data$X.5[8:592][seq(2,584,3)])
countries.f<- list("f1990"=as.numeric(data$X.6[8:592][seq(2,584,3)]),"f2000"=data$X.7[8:592][seq(2,584,3)],"f2010"=data$X.8[8:592][seq(2,584,3)],"f2015"=data$X.9[8:592][seq(2,584,3)])
countries.sexratio <- list("sexratio1990"=data$X.10[8:592][seq(2,584,3)],"sexratio2000"=data$X.11[8:592][seq(2,584,3)],"sexratio2010"=data$X.12[8:592][seq(2,584,3)],"sexratio2015"=data$X.13[8:592][seq(2,584,3)])
countries.iso <- data$Child.Mortality.Estimates[8:592][seq(2,584,3)]

cleaned.data <- data.frame(countries.iso,countries,countries.m,countries.f,countries.sexratio)
cleaned.data <- mutate(cleaned.data,avg.1990=((m1990+f1990)/2),avg.2000=((m2000+f2000)/2),avg.2010=((m2010+f2010)/2),avg.2015=((m2015+f2015)/2))

measles.data <- read.csv("measles/WHS8_110.csv")
cols <- colnames(measles.data)
measles.data <- measles.data[,cols[c(1,2,7,17,27)]]
colnames(measles.data)<- c("Country","x2015","x2010","x2000","x1990")
measles.data <- measles.data[2:195,]

dpt.data <- read.csv("dpt/WHS4_100.csv")
cols <- colnames(dpt.data)
dpt.data <- dpt.data[,cols[c(1,2,7,17,27)]]
colnames(dpt.data) <- c("Country","x2015","x2010","x2000","x1990")
dpt.data <- dpt.data[2:195,]

country.wise.mort <- read.csv("mort_data/country_wise_mort.csv")
country.wise.mort <- select(country.wise.mort,c(1,2,35:60))
country.wise.mort <- gather(country.wise.mort,key=year,value=mort,c(3:28))%>%filter(!is.na(mort))
colnames(country.wise.mort)<- c("Country","Code","year","mort")

measles.data2 <- read.csv("measles/WHS8_110.csv")
measles.data2<- select(measles.data2,1:26)
measles.data2<- gather(measles.data2,key=year,value=measles,c(2:26))

dpt.data2 <- read.csv("dpt/WHS4_100.csv")
dpt.data2<- select(dpt.data2,1:27)
dpt.data2 <- gather(dpt.data2,key=year,value=dpt,c(2:27))

gdp.per.capita <- read.csv("gdp_data/gdp.per.capita2.csv")
gdp.per.capita<- select(gdp.per.capita,c(1,2,35:60))
gdp.per.capita <- gather(gdp.per.capita,key=year,value=gdp,c(3:28))%>%filter(!is.na(gdp))
colnames(gdp.per.capita) <- c("Country","Code","year","gdp")

scatter.plot <- left_join(dpt.data2,measles.data2)%>%left_join(gdp.per.capita)%>%left_join(country.wise.mort)
