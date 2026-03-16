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
raud-Detection
Built a modular fraud detection pipeline to classify financial transactions using Python and R. This project focuses on the intersection of Object-Oriented Programming (OOP), automated ETL processes, and rigorous statistical auditing to identify signal integrity in financial data.

The project will:

Conduct a Statistical Audit in R to identify data distribution patterns.

Implement custom Python Classes for ETL and automated feature engineering.

Build a robust pipeline using Scikit-Learn's fit and transform logic.

Optimize high-dimensional data via SMOTE and GridSearchCV.

Conclude with an adversarial "Post-Mortem" on the dataset's synthetic limitations.

HOW IT'S MADE
Languages used: Python, R

Packages and modules: numpy, pandas, scikit-learn, imbalanced-learn, tidyverse

Environment: VS Code and RStudio

STATISTICAL AUDIT (R-INSIGHTS)
THE DISCOVERY

**EXPLORATORY DATA ANALYSIS AND DATA MINING**   

*IP Risk Score by Fraud*  

*Categorical and numeric variables by Fraud*


*Account days and average transaction amount by Fraud*  


*International transactions by Fraud*   


*Location by Fraud*     

To identify how well the data could be modeled, I started with an Exploratory Data Analysis (EDA) in R. I utilized Q-Q plots and scatter matrices to test the underlying assumptions of the dataset.

Distributional Analysis I used a Q-Q Plot to compare the transaction amounts against a theoretical normal distribution.

The result was a perfectly linear relationship, indicating the data follows a Uniform Distribution U(a,b).

Insight: In real-world finance, transaction amounts are typically skewed; this perfect uniformity suggested the data was stochastically generated.

FEATURE ENGINEERING & ETL
AUTOMATED PIPELINES

To handle the data cleaning and preparation, I developed a modular ETL system using custom Python classes. This allowed for reproducible "fit" and "transform" operations across training and testing sets.

Custom ETL Classes I created a dedicated class to store the transformation logic. This ensured that any cleaning applied to the training data—such as handling missing values or renaming columns—was identically applied to the test data.

The fit() and transform() Logic
By following the Scikit-Learn API structure, I implemented:

fit(): Calculated the necessary statistics from the training data (e.g., mean, mode, or category mappings).

transform(): Applied those calculated values to both the training and test datasets. This prevents Data Leakage, ensuring the model doesn't "see" information from the future during training.

Feature Engineering Steps
Beyond standard cleaning, I engineered new features to extract hidden signals:

Risk Ratios: Calculated the ratio of international transactions to account age.

Velocity Metrics: Created rolling averages for transaction frequency.

Encoding: Implemented OneHotEncoder and StandardScaler within a ColumnTransformer to handle categorical and numerical features in a single pass.

MODELLING & OPTIMISATION
ARCHITECTURE

With the features engineered, I utilized advanced resampling and optimization techniques to handle the imbalanced nature of fraud.

SMOTE: Generated synthetic fraud cases to balance the classes.

GridSearchCV: Automated the search for optimal hyperparameters (e.g., max_depth, n_estimators) for Random Forest and XGBoost.

FINAL INSIGHTS: THE "LOST CAUSE" CONCLUSION
Despite the modular ETL classes and optimized pipelines, the model performance confirmed the findings of the R-based audit.

Interpretation of Output

Signal Integrity: My custom transformers and engineering steps were unable to extract a signal because the fraud labels were stochastically independent of the features.

Performance: R 
2
  and Precision-Recall metrics remained consistent with a "Zero-Signal" environment.

Final Verdict: The project was a successful exercise in Adversarial Discovery. It proved that while the engineering was sound, the high Bayes Error Rate of the dataset made predictive modeling a lost cause.  




**DATA PREPARAION AND PRE-PROCESSING**     


**Feature engineering** 
set
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