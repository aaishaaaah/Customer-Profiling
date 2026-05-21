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
 
####Compare K=2 and K=4 #### 
improvement <- data.frame(
  From_K = 1:9,
  To_K = 2:10,
  WCSS_Improvement = -diff(WCSS),
  Pct_Improvement = -diff(WCSS) / WCSS[1:9] * 100
)
 improvement

 cat("\n=== Interpretation ===\n")
 for(i in 1:nrow(improvement)) {
   cat(sprintf("K=%d → K=%d: Improvement = %.1f (%.1f%%)\n", 
               improvement$From_K[i], 
               improvement$To_K[i],
               improvement$WCSS_Improvement[i],
               improvement$Pct_Improvement[i]))
 }


####Kmeans Clustering####
k <- 4
 
result <- kmeans(rfmSTD, centers = k , nstart = 25)

rfmfinal <- rfmlog %>%
  mutate(cluster = as.factor(result$cluster))

table(rfmfinal$cluster)

####Interpretation and Segmentation####
clusterprofile <- rfmfinal %>%
  group_by(cluster) %>%
  summary(count = n(), recencyavg = mean(recency), frequencyavg = mean(frequency), monetaryavg = mean(monetary))

print(clusterprofile)

ggplot(rfmfinal, aes(x = cluster, y = monetary, fill = cluster)) +
  geom_boxplot() +
  scale_y_log10(labels = label_currency(prefix = "£")) +
  labs(title = "Monetary Value Distribution by Customer Segment",
       y = "Total Spent (Log Scale)") +
  theme_minimal()







  
  