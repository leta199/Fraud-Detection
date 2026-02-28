#--------------------------------#
#INSTALL NECESSARY PACKAGES ------
#--------------------------------#
#we have packages that handle data importing and visualisations

install.packages("here")    #used for relative file paths
library("here")          
here()                      #file path must be root of folder 
list.files(here("dataset")) #expect to see Digital_Payment_Fraud_Detection_Dataset.csv

install.packages("tidyverse") #visualisation suite 
library("tidyverse")

install.packages("patchwork") #putting together visualisations in EDA
library("patchwork")

#------------------------------------#
#IMPORT AND CLEANING THE DATASET -----
#------------------------------------#

fraud <- read.csv(here("dataset", "Digital_Payment_Fraud_Detection_Dataset.csv"))

fraud$fraud_label <- factor(fraud$fraud_lab)              #fraud_label from numeric to factor (categorical)
fraud$is_international <- factor(fraud$is_international)  #is_international from numeric to factor (categorical)
summary(fraud) #our fraud label has been transformed into factor of two levels: 0 no fraud, 1 fraud 

View(fraud) #looking at our data in RStudio 
table(fraud$fraud_label) #large prevalence of fraud: 6.52% fraud vs 93.48% not fraud

# Now we can start with our visualisations 

#------------------------------------#
#EXPLORATORY DATA ANALYSIS -----------
#------------------------------------#

# Q1 - What is the breakdown of IP Risk Score by fraud label using densities ----
p1 <- ggplot( data = fraud, aes(x = ip_risk_score, 
                          fill = fraud_label,
                          alpha = fraud_label)) +
    geom_density() +
    scale_alpha_manual(values = c("0" = 1, "1" = 0.5), guide = "none") +
    geom_vline(xintercept = 0.51, color = "gray2") +
    geom_vline(xintercept = 0.86, colour = "gray2") +
    labs( title = "Density of IP Risk score by Fraud prevalence",
          x = "Ip risk score",
          y = " Density") +
    theme_minimal() +
    scale_fill_manual(name = "Fraud Label", 
                      values = c("0" = "green4", "1" = "red2"),
                      labels = c("Non fraud (0)", "Fraud (1)"))
  
# Our density curves follow each other fairly closely until the IP score of 0.51 until 0.86
# Since density is a description of the probability distribution of IP score broken down by fraud and not fraud- 
# this tells us that this range of IP scores has a lower probability of Non Fraud cases than Fraud cases.  
#Also I will keep the same colour scheme so let us use it:
s <- scale_fill_manual(name = "Fraud Label", 
                  values = c("0" = "green4", "1" = "red2"),
                  labels = c("Non fraud (0)", "Fraud (1)"), guide = "none")
# Q2 - How is fraud distributed in  other variables (mainly discrete )
p2 <- ggplot(data = fraud , aes(x = login_attempts_last_24h, fill = fraud_label))+
  geom_bar() + s +ggtitle("Fraud by Number of login attempts") +
  labs( x= "Number of login attempts") +
  scale_x_discrete( limits = c(0: 8))
p3 <- ggplot(data = fraud , aes(x = payment_mode, fill = fraud_label))+
  geom_bar() + s + ggtitle("Fraud by Payment modes") +
  labs( x= "Payment mode")
p4 <- ggplot(data = fraud , aes(x = device_type, fill = fraud_label))+
  geom_bar() + s + ggtitle("Fraud by Payment modes") +
  labs( x= "Device type")
p5 <- ggplot(data = fraud , aes(x = transaction_type, fill = fraud_label))+
  geom_bar() + s + ggtitle("Fraud by Transaction types") +
  labs( x= "Transaction type")
p6 <- ggplot(data = fraud , aes(x = transaction_hour, fill = fraud_label))+
  geom_bar() + s + ggtitle("Fraud by Transaction hour") + 
  scale_x_discrete( limits = c(0: 23)) +
  labs( x= "Time of transaction")
p7 <- ggplot(data = fraud , aes(x = previous_failed_attempts, fill = fraud_label))+
  geom_bar() +s  + ggtitle("Fraud by Numer of failed attempts") +
  labs( x= "Number of previous failed attempts")

annotations.patchwork <- data.frame(
  anotations = c("3) Fraud does not seem to vary too much with other vraibles ")) 


# creating a patchwork of categroical and discrete numeric variables broken down by fraud
p6/ (p2 + p3 + p4 + p5 + p7 + grid::textGrob("2) Fraud seem to increase slightly after 5 attempted logins")) +
  plot_annotation(title = "How are our categorical and discrete variables broken down by Fraud?",
                  subtitle = " 1) We see that the hours of 5:00 a.m.,08:00 a.m., 13:00 p.m. and 18:00 p.m.
      have a higher prevalence of fraud than other times.")

### 2 - How does transaction amount vary with average transaction in terms of predicting fraud

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


