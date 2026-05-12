library(tidyverse)
library(lubridate)
library(cluster)
library(scales)
library(dplyr)

glimpse(data)

###clean the data###
cleandata <- data %>%
  filter(!grepl("^C", Invoice)) %>%
  filter(Quantity>0, Price>0) %>%
  filter(!is.na(`Customer ID`))

cleandata <- mutate(cleandata, sales = Quantity*Price)

UKdata <- filter(cleandata, Country == "United Kingdom")
  
###RFM scores###
analysisdata <- as.Date("2011-12-09")

rfm <-UKdata %>%
  group_by(`Customer ID`) %>%
  summarise(recency = as.numeric(analysisdata - max(as.Date(InvoiceDate))), 
            frequency = n_distinct(Invoice), 
            monetary = sum(sales))%>%
  ungroup()

summary(rfm)  

n_distinct(cleandata$`Customer ID`)  
  
###EDA###
ggplot(data = rfm , aes(x = monetary)) +
  geom_histogram(bins = 50, fill = "pink", colour = "lightblue") +
  scale_x_log10(labels = label_currency(prefix = "£")) +
  labs(title = "Distribution of Customer Monetary Value", x = "Total Spent (log)", y = "Number of Customers")+
  theme_minimal()
  
  
  
  
  
  
  
  