# Fraud Detection Project

A classic problem in financial environments. We will take a look at classifying transactions into fraud and not fraud using scikit-learn packages.  
The dataset is obtained from Kaggle here: [Digital Payment Fraud Detecton](https://www.kaggle.com/datasets/jayjoshi37/digital-payment-fraud-detection/data)
This project will go over using scikit-learn in binary classification  for this dataset and we will cover:   

1. Data Exploration 
2. Data prepartion and pre-processing 
3. Modelling 
4. Evaluation and testing 
 
## HOW IT'S MADE 
Languages used: Python (version 3.14.3)    
Environment: VSCode

[![Version: Python 3.14.3](https://img.shields.io/badge/Python-3.14.3-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
![Status](https://img.shields.io/badge/Status-In%20Progress-yellow)

## METHODS AND TECHNIQUES  
After importing our data we took a look into what variables we have.  

The predicted variables is the "fraud label" field.   

**EXPLORATORY DATA ANALYSIS AND DATA MINING**   
We did preliminary exploratory with the raw data using `.head()`, `.shape()`, `.nunique()`, and `.keys()`.  
In this we managed to find that our data-set is highly skewed in favour of the non-fraud transactions: 

<img width="126" height="76" alt="Image" src="https://github.com/user-attachments/assets/ad18a307-faef-48a7-b924-6f7f53e3cdd0" />

We moved into visualisations in R that allow us to carry out Exploratory Data Analysis and Data Mining.

*IP Risk Score by Fraud*  
1) Our density curves of IP risk score  follow each other fairly closely until the IP score of 0.51 until 0.86
2) Since density is a description of the probability distribution of IP score broken down by fraud and not fraud- this tells us that this range of IP scores has a lower probability of  Fraud cases than Non Fraud cases.  

*Categorical and numeric variables by Fraud*
1) We see that the hours of 02:00 a.m., 5:00 a.m., 08:00 a.m., 13:00 p.m. and 18:00 p.m.
      have a higher prevalence of fraud than other times."
2) Fraud seems to increase slightly after 5 attempted logins
3) Fraud does not seem to vary too much with other variables 

*Account days and average transaction amount by Fraud*  
1) There is little relationship between transaction amounts and average age of accounts in days.  
2) The fraudulent data points are visible in the entire range across the y and x axis. 

*International transactions by Fraud*   
1) Local transactions tend too be more fraudulent that international ones.  

*Location by Fraud*     
1) Hyderabad and Mumbai have a higher prevalence of fraud than other dice locations. 


**DATA PREPARAION AND PRE-PROCESSING**     
Since our ID variables are identifiers, we dropped the ID columns.  

**Feature engineering** 
`get_dummies()` - is a pandas function that helps transform categorical variables into numerical values that can be used in binary classification.  
We apply the get dummies function to the categorical fields of `transaction_type`, `payment_mode`, `device_type`, `device_location`.




**EVAULATION AND TESTING**   

**SMOTE**   
Courtesy of Geekforgeeks there sis a method we can use for highly unbalanced datasets called SMOTE.  
This is a resampling technique that generates synthetic data for our minority non fraud class.   
It interpolates between existing data to create  completely new data points.  
It helps prevent overfitting and allows models to learn patterns that predict minority class.   

Caution - it is important to only use re-smpling on the train data to prevent data leakage. 

[Geekforgeeks - SMOTE](https://www.geeksforgeeks.org/machine-learning/smote-for-imbalanced-classification-with-python/)


## PROJECT STRUCTURE      
|[dataset](https://github.com/leta199/Fraud-Detection/tree/main/dataset)  
|├──[]()  
│  ├──[]()   
│  └──[]()  
│    
|├──[modelling](https://github.com/leta199/Fraud-Detection/tree/main/modelling)  
│  ├──[]()      
│  ├──[]()      
│  ├──[]()      
│  └──]()     
│    
|├──[visualisations](https://github.com/leta199/Fraud-Detection/tree/main/visualisations)    
│  ├──[]()  
│  └──[]()  
|    
|├──[License](https://github.com/leta199/Linear-Regression/blob/main/LICENSE)  
|└──[R.history](https://github.com/leta199/Fraud-Detection/blob/main/.Rhistory)
|├──[requirements](https://github.com/leta199/Fraud-Detection/blob/main/requirements.txt)  
|└──[README](https://github.com/leta199/Fraud-Detection/blob/main/README.md)


  
## AUTHORS   
[leta199](https://github.com/leta199)