#Let's start by setting out working directory 
setwd('/Users/leta/Desktop/Data Science Career /Python/Python Projects/Fraud Detection ')

#Now let us import our data 
fraud <- read.csv('/Users/leta/Desktop/Data Science Career /Python/Python Projects/Fraud Detection /dataset/Digital_Payment_Fraud_Detection_Dataset.csv')

#Time to install necessary packages 
install.packages("tidyverse")
library("tidyverse")

#Looking at our data in Rstudio 
View(fraud)

# Now we can start with our visualisations 
#How many transactions are of each payment type 

ggplot(data = fraud, aes(x=payment_mode), stat = "count")+
  geom_bar() +
  labs(title = "Frequency of payment method",
       x = "Payment method",
       y = "Frequency") +
  theme_classic()
#We have a relatively even split of payment methods


