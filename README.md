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
We have multiple predictor fields:  

`transaction_id` - identifier to each transaction   
`user_id` - identifier for each user.   
`transaction_amount` - amount for each transaction.   
`transaction_type` - how funds were exchanged e.g "payment" or "bank transfer".   
`payment_mode` - wallet, card, UPI etc.   
`device_type` - device transaction was made from e.g iOS.   
`device_location` - location of the device used to make transaction.   
`account_age_days` - age of the account     
`transaction_hour` - time of transaction in 24 hour notation.    
`previous_failed_attempts` - if there were previous attempts to make fraudulent transactions   
`avg_transaction_amount` - avg amount each account usually makes   
`is_international` - is the trasnaction international    
`ip_risk_score` - a numerical value  that quantifies the likelihood an IP address is involved in malicious activity, such as fraud, spam, or cyberattacks. 
`login_attempts_last_24h` - number of login attempts to the account in the last 24 hours   
`fraud_label` - is the transaction fraud or not 


**DATA EXPLORATION**
We did preliminary exploratory with the raw data using `.head()`, `.shape()`, `.nunique()`, and `.keys()`.  
In this we managed to find that our dataset is highly skewed in favour of the non-fraud transactions: 

<img width="126" height="76" alt="Image" src="https://github.com/user-attachments/assets/ad18a307-faef-48a7-b924-6f7f53e3cdd0" />

We moved into visualisations that allow us to carry out 
Exploratory Data Analysis and Data Mining.

[INSERT THE PICTURES AND ANALYSIS HERE]

**DATA PREPARAION AND PRE-PROCESSING**   
Since our ID variables are identifiers, we dropped the ID columns.  

**Feature engineering**
`get_dummies()` - is a pandas function that helps transform categorical variables into numerical values that can be used in binary classification.  
We apply the get dummies function to the categorical fields of `transaction_type`, `payment_mode`, `device_type`, `device_location`.

**MODELLING**
For our first binary classification task we will use Logistic Regression to act as a baseline 


SMOTE 

https://www.geeksforgeeks.org/machine-learning/smote-for-imbalanced-classification-with-python/
 ## PROJECT STRUCTURE      

  
## AUTHORS   
[leta199](https://github.com/leta199)