#Let's start by setting out working directory 
setwd('/Users/leta/Desktop/Data Science Career /Python/Python Projects/Fraud Detection ')
#[don't forget to change this]
#Now let us import our data 
fraud <- read.csv('/Users/leta/Desktop/Data Science Career /Python/Python Projects/Fraud Detection /dataset/Digital_Payment_Fraud_Detection_Dataset.csv')

#Our fraud label is catgeorical so we must transform it 

fraud$fraud_label <- factor(fraud$fraud_lab)
fraud$is_international <- factor(fraud$is_international)
summary(fraud) #our fraud label has been transformed into factor of two levels 0 no fraud, 1 fraud 
#Time to install necessary packages 
install.packages("tidyverse")
library("tidyverse")

#Looking at our data in Rstudio 
View(fraud)

# Now we can start with our visualisations 

# 1 - How many transactions are of each payment type 

ggplot(data = fraud, aes(x=payment_mode), stat = "count")+ #plotting our count of payment methods
  geom_bar() +
  labs(title = "Frequency of payment method",              #labels for all of our axes 
       x = "Payment method",
       y = "Frequency") +
  theme_classic()                                          #nice theme with no excess lines 
#We have a relatively even split of payment methods 

# 2 - How does transaction amount vary with average transaction in terms of predicting fraud

fraud
ggplot( data = fraud, aes(x = transaction_amount, y = account_age_days, colour = fraud_label)) +
  geom_point() +
  labs( title = "Transaction amount vs average transaction amount",
        x = "Transaction amount",
        y = "Account age in days")

# 3 - Correlation between Fraud label and other predictors 

install.packages("reshape")
library(reshape)

fraud.numeric <- fraud[, sapply(fraud, is.numeric)]

cor.matrix <- round(cor(fraud.numeric),5)
cor.matrix[upper.tri(cor.matrix)] <-NA

cor.intermediate <- melt(cor.matrix, na.rm = TRUE)
head(cor.intermediate)


#Plotting the correlation heatmap 
ggplot( data = cor.intermediate, 
        aes(x = X1, y = X2, fill = value))+
  geom_tile() +
  theme_classic()

# What proportion of international transactions are fraudulent 

fraud %>% 
group_by( is_international) %>% 
  summarise(
    count = n()) 



            
ggplot(data = fraud , aes(x = is_international, fill = fraud_label))+
  geom_bar()

?group_by
