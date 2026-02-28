#--------------------------------#
#INSTALL NECESSARY PACKAGES -----
#--------------------------------#
#We had packages that handle data importing and visualisations

install.packages("here")    #used for relative file paths
library("here")          
here()                      #file path must be root of folder 
list.files(here("dataset")) #expect to see Digital_Payment_Fraud_Detection_Dataset.csv

install.packages("tidyverse") #visualisation suite 
library("tidyverse")

iiinstall.packages("patchwork") #putting together visualisations in EDA
library("patchwork")

#-------------------------------------#
#IMPORT AND CLEANING THE DATASET -----
#------------------------------------#

fraud <- read.csv(here("dataset", "Digital_Payment_Fraud_Detection_Dataset.csv"))

fraud$fraud_label <- factor(fraud$fraud_lab)
fraud$is_international <- factor(fraud$is_international)
summary(fraud) #our fraud label has been transformed into factor of two levels 0 no fraud, 1 fraud 
#Time to install necessary packages 


#Looking at our data in Rstudio 
View(fraud)

# Now we can start with our visualisations 

# 1 - How many transactions are of each payment type 
p1 <- ggplot( data = fraud, aes(x = ip_risk_score, 
                          y = after_stat(density), 
                          fill = fraud_label, 
                          alpha = fraud_label)) +
    geom_density() +
    scale_alpha_manual(values = c("0" = 1, "1" = 0.5)) +
    geom_vline(xintercept = 0.51) +
    geom_vline(xintercept = 0.86) +
    scale_fill_manual(values = c( "0"= "green4", "1" = "red2")) +
    labs( title = "Density of IP Risk score by Fraud prevalence",
          x = "Ip risk score" ,
          y = " Density") +
    theme_minimal()
  





ggplot(data = fraud , aes(x = login_attempts_last_24h, fill = fraud_label))+
  geom_histogram()
# 2 - How does transaction amount vary with average transaction in terms of predicting fraud


 ggplot( data = fraud, aes(x = transaction_amount, y = account_age_days, colour = fraud_label)) +
  geom_point() +
  labs( title = "Transaction amount vs average transaction amount",
        x = "Transaction amount",
        y = "Account age in days")


# 4- What proportion of international transactions are fraudulent 

fraud.international <- fraud %>% 
group_by( is_international, fraud_label) %>% 
  summarise(
    count = n()) 

fraud_0 <-subset(fraud.international, is_international == 0)
fraud_1 <- subset(fraud.international, is_international == 1)

prop0 <- prop.table(fraud_0$count)
prop1 <- prop.table(fraud_1$count)

display0 <-  paste0(round(prop0[2],3)*100,"% of transactions are fraud")
display1 <- paste0(round(prop1[2],3)*100,"% of transactions are fraud")

ggplot(data = fraud , aes(x = is_international, fill = fraud_label))+
  geom_bar()  +
  labs( title = "Proportion of international transactions with fraud",
        x = "Is transaction international?",
        y = "Frequency of transactions") +
  annotate("text",
           x = 1,
           y = 7000,
           label = display0,
           family = "serif", 
           fontface = "bold") +
  annotate("text",
           x = 2.03,
           y = 1500,
           label  = display1,
           family = "serif", 
           fontface = "bold") +
  theme_classic()
  
# 5 - How does location impact fraud 

fraud.location <- fraud %>% 
  group_by( device_location, fraud_label) %>% 
  summarise(
    count = n()) 

location_b <-subset(fraud.location, device_location == "Bangalore")
location_c <-subset(fraud.location, device_location == "Chennai")
location_d <-subset(fraud.location, device_location == "Delhi")
location_h <-subset(fraud.location, device_location == "Hyderabad")
location_m <-subset(fraud.location, device_location == "Mumbai")

prop.b <- prop.table(location_b$count)
prop.c <- prop.table(location_c$count)
prop.d <- prop.table(location_d$count)
prop.h <- prop.table(location_h$count)
prop.m <- prop.table(location_m$count)


displayb <-  paste0(round(prop.b[2],3)*100,"%  fraud")
displayc <- paste0(round(prop.c[2],3)*100,"%  fraud")
displayd <-  paste0(round(prop.d[2],3)*100,"%  fraud")
displayh <- paste0(round(prop.h[2],3)*100,"%  fraud")
displaym <-  paste0(round(prop.m[2],3)*100,"%  fraud")

ann <- data.frame(
  x =c(1,2,3,4,5),
  y = c(1600, 1500, 1590, 1690, 1500), 
  label = c( displayb, displayc, displayd, displayh, displaym), 
  fontface = rep("bold", times = 5),
  fontfamily = rep("serif", times = 5)
)
ggplot(data = fraud , aes(x = device_location , fill = fraud_label)) +
  geom_bar(width = 0.8) +
  theme_classic() +
geom_text( data = ann,
          aes( x= x,
           y = y, 
           label = label,
           fontface = fontface,
           family = fontfamily),
           inherit.aes = FALSE) +
  labs(
    title = "Distribution of Fraud per location",
    x = "Device locations",
    y = "Number of transactions"
  )

# 6 - g
geom_


