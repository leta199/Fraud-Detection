#--------------------------------#
#INSTALL NECESSARY PACKAGES ------
#--------------------------------#
#we have packages that handle data importing and visualisations
install.packages("here")    # used for relative file paths
library("here")  
here()                      # file path must be root of folder 
list.files(here("dataset")) # expect to see train_data.csv

install.packages("tidyverse") # visualisation suite 
library("tidyverse")

install.packages("patchwork") # putting together visualisations in EDA
library("patchwork")

install.packages("corrplot") # creating our correlation plots 
library(corrplot)


#------------------------------------#
#IMPORT AND CLEANING THE DATASET -----
#------------------------------------#

fraud <- read.csv(here("dataset", "train_data.csv"))

fraud$fraud <- factor(fraud$fraud)              #fraud from numeric to factor (categorical)
fraud$is_international <- factor(fraud$is_international)  #is_international from numeric to factor (categorical)
summary(fraud) #our fraud label has been transformed into factor of two levels: 0 no fraud, 1 fraud 

View(fraud) #looking at our data in RStudio 
table(fraud$fraud) #large prevalence of fraud: 6.51% fraud vs 93.48% not fraud
# Now we can start with our visualisations 

#------------------------------------#
#EXPLORATORY DATA ANALYSIS -----------
#------------------------------------#
# Let us create repeatable code for the theme and legend
s1 <- scale_fill_manual(name = "Fraud Label", 
                        values = c("0" = "green4", "1" = "red2"),
                        labels = c("Non fraud (0)", "Fraud (1)"))
s2 <- scale_fill_manual(name = "Fraud Label", 
                        values = c("0" = "green4", "1" = "red2"),
                        labels = c("Non fraud (0)", "Fraud (1)"), guide = "none")
t <- theme_bw()


# Q1 - What is the breakdown of IP Risk Score by fraud label using densities --------------------------------------------
p1 <- ggplot( data = fraud, aes(x = ip_risk_score, 
                          fill = fraud,
                          alpha = fraud)) +
    geom_density() +
    scale_alpha_manual(values = c("0" = 1, "1" = 0.5), guide = "none") +
    geom_vline(xintercept = 0.51, color = "gray2") +
    geom_vline(xintercept = 0.885, colour = "gray2") +
  geom_vline(xintercept = 0.25, color = "gray2") +
  geom_vline(xintercept = 0.48, colour = "gray2") +
  geom_vline(xintercept = 0.09, colour = "red4") +
    labs( title = "Density of IP Risk score by Fraud prevalence",
          x = "Ip risk score",
          y = " Density") +
    t + s1
# This density curve tells us the  probability of finding fraud and non fraud transaction in the relevant ranges (through area under curve).
# Our density curve can be broken down into 5 main regions/ ranges:
# 0.00 - 0.09 - transactions are relatively equal share of fraud and non fraud.
# 0.09 - 0.25 - the density of fraud cases is much larger than that of non fraud.
# 0.25- 0.48 - the density of non fraud cases is much larger than that of  fraud.
# 0.51 - 0.885 - the density of non fraud cases is much larger than that of  fraud.
# 0.885 - 1.00 - fraud cases are marginally more probable. 

# Q2 - How is fraud distributed in  other variables (mainly discrete ) --------------------------------------------
p2 <- ggplot(data = fraud , aes(x = login_attempts_last_24h, fill = fraud))+ 
  geom_bar() + s1 +ggtitle("Fraud by Number of login attempts") +
  labs( x= "Number of login attempts") + t
  scale_x_discrete( limits = c(0: 8)) 
p3 <- ggplot(data = fraud , aes(x = payment_mode, fill = fraud))+
  geom_bar() + s1 + ggtitle("Fraud by Payment modes") +
  labs( x= "Payment mode") + t
p4 <- ggplot(data = fraud , aes(x = device_type, fill = fraud))+
  geom_bar() + s1 + ggtitle("Fraud by Payment modes") +
  labs( x= "Device type") + t
p5 <- ggplot(data = fraud , aes(x = transaction_type, fill = fraud))+
  geom_bar() + s1 + ggtitle("Fraud by Transaction types") +
  labs( x= "Transaction type") + t
p6 <- ggplot(data = fraud , aes(x = transaction_hour, fill = fraud))+
  geom_bar() + s1 + ggtitle("Fraud by Transaction hour") + 
  scale_x_discrete( limits = c(0: 23)) +
  labs( x= "Time of transaction") + t
p7 <- ggplot(data = fraud , aes(x = previous_failed_attempts, fill = fraud))+
  geom_bar() + s1  + ggtitle("Fraud by Numer of failed attempts") +
  labs( x= "Number of previous failed attempts") + t

# creating a patchwork of categorical and discrete numeric variables broken down by fraud
p6/ (p2 + p3 + p4 + p5 + p7 + grid::textGrob("2) Fraud seems to increase slightly after 5 attempted logins\n3) Fraud does not seem to vary too much with other variables ")) +
  plot_annotation(title = "How are our categorical and discrete variables broken down by Fraud?",
                  subtitle = " 1) We see that the hours of 02:00 a.m., 03:00 a.m., 5:00 a.m., 07:00 a.m.,  08:00 a.m.,11:00 a.m., 13:00 p.m., 18:00 p.m., 19:00 p.m., and 21:00 p.m.
      have a higher prevalence of fraud than other times.")

### Q3 - How does transaction amount vary with average transaction in terms of predicting fraud ------------------------
p8 <- ggplot( data = fraud, aes(x = transaction_amount, y = account_age_days, colour = fraud)) + 
  geom_point() +
  labs( title = "Transaction amount vs average transaction amount",
        x = "Transaction amount",
        y = "Account age in days") + scale_colour_manual(name = "Fraud Label", 
                                                       values = c("0" = "green4", "1" = "red2"),
                                                       labels = c("Non fraud (0)", "Fraud (1)")) + t

# There is little relationship between transaction amounts and average age of accounts in days.
# The fraudulent data points are visible in the entire range across the y and x axis. 

# Q4- What proportion of international transactions are fraudulent --------------------------------------------
fraud.international <- fraud %>%              #begin by group our transaction by international or not 
group_by( is_international, fraud) %>% 
  summarise(
    count = n()) 

fraud_0 <-subset(fraud.international, is_international == 0)  #getting the subset of local (0)  transactions
fraud_1 <- subset(fraud.international, is_international == 1) # getting the subset of international (1) transactions   

prop0 <- prop.table(fraud_0$count) #getting proportion 
prop1 <- prop.table(fraud_1$count)

display0 <-  paste0(round(prop0[2],3)*100,"% of transactions are fraud") #getting percentage of international transactions rounded  to 3 s.f
display1 <- paste0(round(prop1[2],3)*100,"% of transactions are fraud")


p9 <- ggplot(data = fraud , aes(x = is_international, fill = fraud))+
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
           fontface = "bold") + t + s1
# Local transactions tend too be more fraudulent than international ones 6.7% vs 4.6%. 

# Q5 - How does location impact fraud ----------------------------------------------------------------
fraud.location <- fraud %>%                   #begin by grouping our transactions by device location into a dataframe 
  group_by( device_location, fraud) %>% 
  summarise(
    count = n()) 

location_b <-subset(fraud.location, device_location == "Bangalore") #get the subset of the dataframe for each location
location_c <-subset(fraud.location, device_location == "Chennai")
location_d <-subset(fraud.location, device_location == "Delhi")
location_h <-subset(fraud.location, device_location == "Hyderabad")
location_m <-subset(fraud.location, device_location == "Mumbai")

prop.b <- prop.table(location_b$count) #get the subset as proportions 
prop.c <- prop.table(location_c$count)
prop.d <- prop.table(location_d$count)
prop.h <- prop.table(location_h$count)
prop.m <- prop.table(location_m$count)


displayb <-  paste0(round(prop.b[2],3)*100,"%  fraud") #get the percentage of fraudulent transactions by location 
displayc <- paste0(round(prop.c[2],3)*100,"%  fraud")
displayd <-  paste0(round(prop.d[2],3)*100,"%  fraud")
displayh <- paste0(round(prop.h[2],3)*100,"%  fraud")
displaym <-  paste0(round(prop.m[2],3)*100,"%  fraud")

ann <- data.frame(                                     #let us create a dataframe for the x and y axis coordinates as well as the font and percentages rounded to 3 s.f
  x =c(1,2,3,4,5),
  y = c(1600, 1500, 1590, 1690, 1500), 
  label = c( displayb, displayc, displayd, displayh, displaym), 
  fontface = rep("bold", times = 5),
  fontfamily = rep("serif", times = 5)
)


p10 <- ggplot(data = fraud , aes(x = device_location , fill = fraud)) +
  geom_bar(width = 0.8) +
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
  ) + t + s1

# Hyderabad and Mumbai have a higher prevalence of fraud than other dice locations. 

# Q6 - How does account age in days impact fraud ----------------------------------------------------------------
options(scipen = 100)
p11 <- ggplot(data = fraud , aes(x = account_age_days, fill = fraud, alpha = fraud))+
  geom_density()  +
  labs( title = "Density of fraud by account age in days",
        x = "Account age (days)",
        y = "Density") + s1 +
  scale_alpha_manual(values = c("0" = 1, "1" = 0.5), guide = "none") +
  t +
  geom_vline(xintercept = 1017, color = "gray2") +
  geom_vline(xintercept = 1845, colour = "gray2") 

# Accounts that are between 1017 and 1845 days old have a much higher prevalence of fraud than those outside that age range

#Q7 - what is the distribution of our transaction amounts -------------------------------------------------------------
p12 <- ggplot(data = fraud , aes(x = avg_transaction_amount) )+
  geom_density()  +
  labs( title = "Density of fraud by average transaction amount",
        x = "Average transaction amount (Rupee)",
        y = "Density") + s1 
# Average transaction seem to follow a normal distribution. 
p13 - ggplot(data = fraud , aes(x = transaction_amount))+
  geom_density()  +
  labs( title = "Density of fraud by  transaction amount",
        x = "Transaction amount (Rupee)",
        y = "Density") + s1 
# Transaction seem to follow a normal distribution. 
max_amt <- max(fraud$avg_transaction_amount)
min_amt <- min(fraud$avg_transaction_amount)
amounts_avg <- fraud$avg_transaction_amount
amounts_daily <- fraud$transaction_amount

n <- 5250
sample_quantiles_avg <- amounts_avg/n
sample_quantiles_daily <- amounts_daily/n

uniform_samples <- runif(n, min = min_amt, max = max_amt)
theoretical_quantiles <- 1:n / n+1

qqplot(theoretical_quantiles, sample_quantiles_avg, col = "green4",
    main = "QQ plot of sample quantiles vs uniform quantiles (avg transaction amount)",
    xlab = "theoretical uniform quantiles",
    ylab = "Average transaction sample quantiles")
abline(0,1)

qqplot(theoretical_quantiles, sample_quantiles_daily, col = "pink",
       main = "QQ plot of sample quantiles vs uniform quantiles (transaction amount)",
       xlab = "theoretical uniform quantiles",
       ylab = "Transaction sample quantiles")

abline(0,1)

# Both the average transaction amount and the transaction amount follow a normal distribution. 
# Both variables have a wider variance due the greater slope in our qqplots.


# Q8 - What are the correlations between our variables?  ----------------------------------------------------------------

corr_data <- fraud %>%
  mutate(fraud_label = as.numeric(as.factor(fraud)) - 1) %>% 
  select(where(is.numeric))

correlation_plot <- cor(corr_data, use = "complete.obs")
colours <- colorRampPalette(c("green","brown","red"))(200)

corrplot(correlation_plot, method = "number", type = "lower", col = colours ,
         main= "Lower correlation plot",
         mar = c(0,0,2,0)
         )
         
dev.off()

# Our numeric variables od not have a very high correlation with the Fraud label.
# The numeric variables also do not have high correlation with each other.
