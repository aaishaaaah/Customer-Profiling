library(tidyverse)
library(lubridate)
library(cluster)
library(scales)
library(dplyr)
library(ggplot2)
library(factoextra)

glimpse(data)

####clean the data####
cleandata <- data %>%
  filter(!grepl("^C", Invoice)) %>%
  filter(Quantity>0, Price>0) %>%
  filter(!is.na(`Customer ID`))

cleandata <- mutate(cleandata, sales = Quantity*Price)

UKdata <- filter(cleandata, Country == "United Kingdom")
  
####RFM scores####
analysisdata <- as.Date("2011-12-09")

rfm <-UKdata %>%
  group_by(`Customer ID`) %>%
  summarise(recency = as.numeric(analysisdata - max(as.Date(InvoiceDate))), 
            frequency = n_distinct(Invoice), 
            monetary = sum(sales))%>%
  ungroup()

summary(rfm)  

n_distinct(cleandata$`Customer ID`)  
  
####EDA####
ggplot(data = rfm , aes(x = monetary)) +
  geom_histogram(bins = 50, fill = "pink", colour = "lightblue") +
  scale_x_log10(labels = label_currency(prefix = "£")) +
  labs(title = "Distribution of Customer Monetary Value", x = "Total Spent (log)", y = "Number of Customers")+
  theme_minimal()
  
####Fix skewness####
rfmlog <- rfm %>%
  mutate(
    recencylog = log(recency + 1),
    frequencylog = log(frequency + 1),
    monetarylog = log(monetary + 1)
  )
   

####Standardise####
rfmSTD <- scale(rfmlog[c("recencylog", "frequencylog", "monetarylog" )])

####Number of Clusters (K)####  
set.seed(2026)

WCSS <- numeric(10)
for(k in 1:10){
  km <- kmeans(rfmSTD, centers = k, nstart = 25)
  WCSS[k] <- km$tot.withinss
}

plot( 1:10, WCSS, type = "b", pch = 19, col = "pink", lwd = 2, xlab = "Number of Clusters (K)", ylab = "WCSS", main = "Elbow Method")  
  
  
  