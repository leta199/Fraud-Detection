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

**MODELLING**.   
We begin by partitioning our data into our predictor and predicted variables.  
Our new dummy variables and other numeric predictors are called `x` and the "fraud_label"  is y.  

`train_test_split` - is used for data partitioning, which split data into 70/30 train/ test split.  
`stratify`- was used in order to make sure each split has an equal amount of minor splits (class 0 - not fraud).  



**EVAULATION AND TESTING**   
Once we test our data on the test set using `predict` we will use the following metrics to evaluate how well the model works:  
`accuracy score` - how many of our predicted classes were correct out of the total predictions.  
`balanced accuracy` - how many predicted classes were correct taking into account the proportion of our binary classes.  
`precision_score` - how many of identified fraud cases were actually fraud.  
`recall_score` - out of fraud cases  how many did our model catch.

Recall will prove to be the most useful metrics as we need to catch all fraud cases to prevents as much damage to customers as possible however, we must balance recall with 
precision as flagging too many non -fraud transactions as fraud will disrupt user experience and convenience.

`LogisticRegression`   
Acts as a baseline uses log odds to predict outcome by putting trasnactions in classes based on being above certain threshold usually 50%. 
We then fit our model to the train data. 

Once we test our model using these scores:   
accuracy score - is very high at 93.5%.   
balanced accuracy score - is only at 50% therefore at most we only predicted a few fraud cases accurately that averages out the accuracy to 50%.   
precision score - is 0% meaning that our mode predicted no fraud cases.   
recall score - is also 0 since the model did not predict any fraud cases.   

These are not promising results but this mostly happens due to the the highly unbalanced dataset.   
Therefore, our model learns that it can reduce error by always predicting non fraud.  

<img width="515" height="455" alt="Image" src="https://github.com/user-attachments/assets/68fbf79f-9938-47fc-83eb-19247ba81916" />


`RandomForestClassifier`   
Creates and combines mulitple trees to get the most stable result with the highest accuracy. 
- We trained our model on the train data
- We used this model on our test data and it did not fair much better with balanced accuracy of 50%, precision and recall of 0%. 

<img width="515" height="455" alt="Image" src="https://github.com/user-attachments/assets/839c9038-8a0b-4d4c-9bc4-7f5e99dcc76b" />

*Methods of Improvement*

**Class_weights** - is another way to change the weight and significance of each class.  
We use the "balanced" argument to ensure that each class is weihed equally.  

However this only still has a low balanced accuracy of 52.5%.   
Our precision is much higher at 7.14% and recall is 55.8%.  
Therefore, we can catch way more fraud cases but still not all of them.   
This model deos not seem to work well in such unbalanced data. 

**Probability thresholds**   
Finally we tried to use different thresholds for our probability acceptance.  
We created a dataframe that that contains all of our metrics and with model names.   
 `predict_proba`  - was utilised to set acceptance probability to our threshold of 10%. This means if there is a 10% chance of fraud the model predicts fraud.   
 
Our balanced accuracy and for both models still ends up being not much better than random chance.  
Our recall is very high for Logistic regression (100%) however, precision was very low (6.53%) therefore our model over-predicts transaction as fraud.  
Recall was very low for Random forest at 21.8% with similarly low precsion at 7.57%. This models over-predicts transactions as fraud but also does not catch all fraud cases.

<img width="466" height="110" alt="Image" src="https://github.com/user-attachments/assets/27ed879d-4c95-4aeb-878d-32855124c1bd" />

Therefore our precision is much too low to justify both models and recall is very low for Random Forest so we need differencet approach. 

**SMOTE**   
Courtesy of Geekforgeeks there sis a method we can use for highly unbalanced datasets called SMOTE.  
This is a resampling technique that generates synthetic data for our minority non fraud class.   
It interpolates between existing data to create  completely new data points.  
It helps prevent overfitting and allows models to learn patterns that predict minority class.   

Caution - it is important to only use reasmpling on the train data to prevent data leakage. 

[Geekforgeeks - SMOTE](https://www.geeksforgeeks.org/machine-learning/smote-for-imbalanced-classification-with-python/)
 
 
## PROJECT STRUCTURE      

  
## AUTHORS   
[leta199](https://github.com/leta199)