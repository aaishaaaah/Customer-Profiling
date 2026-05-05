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
  

