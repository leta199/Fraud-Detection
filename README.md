# Fraud Detection 

A classic problem in financial environments. We will take a look at classifying transactions into fraud and not fraud using scikit-learn packages.  
The dataset is obtained from Kaggle here: [Digital Payment Fraud Detecton](https://www.kaggle.com/datasets/jayjoshi37/digital-payment-fraud-detection/data)
This project will go over using scikit-learn in binary classification  for this dataset and we will cover:   

1. Exploratory Data Analysis and Data mining 
2. Data pre - processing and cleaning 
2. Modelling and evaluation 
3. Evaluation and testing 
 
## HOW IT'S MADE 
Languages used: Python (version 3.14.3),  R  (version 4.5.2)
Environment: VSCode, RStudio 

[![Version: Python 3.14.3](https://img.shields.io/badge/Python-3.14.3-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![Language: R](https://img.shields.io/badge/Language-R-276DC3.svg?style=flat-square)](https://www.r-project.org/)
[![Built with RStudio](https://img.shields.io/badge/IDE-RStudio-75AADB?style=for‐the‐badge&logo=rstudio&logoColor=white)](https://www.rstudio.com/)
![Jupyter](https://img.shields.io/badge/Notebook-Jupyter-orange)
![Status](https://img.shields.io/badge/Status-Completed-lightgrey)

## METHODS AND TECHNIQUES  

*DATA PRE-PROCESSING AND CLEANING*   
Mimicked a real life data science workflow by separating the dataset into train and test sets before any EDA to mimic new transactions.   
Separated our predictor variables and response variable into x and y respectively. 

**EXPLORATORY DATA ANALYSIS AND DATA MINING**   

To identify how well the data could be modeled, I started with an Exploratory Data Analysis (EDA) in R.      
I utilized density plots, bar charts and histograms, Q-Q plots and scatter matrices to test the underlying assumptions of the dataset.

*IP Risk Score by Fraud*  
This density curve tells us the  probability of finding fraud and non fraud transaction in the relevant ranges (through area under curve).
Our density curve can be broken down into 5 main regions/ ranges:
- 0.00 ~ 0.09 : transactions are relatively equal share of fraud and non fraud.
- 0.09 ~ 0.25 : the density of fraud cases is much larger than that of non fraud.
- 0.25 ~ 0.48 : the density of non fraud cases is much larger than that of  fraud.
- 0.51 ~ 0.885 : the density of non fraud cases is much larger than that of  fraud.
- 0.885 ~ 1.00 : fraud cases are marginally more probable. 

*Categorical and numeric variables by Fraud*
1) We see that the hours of 02:00 a.m., 03:00 a.m., 5:00 a.m., 07:00 a.m.,  08:00 a.m.,11:00 a.m., 13:00 p.m., 18:00 p.m., 19:00 p.m., and 21:00 p.m.
      have a higher prevalence of fraud than other times.
2) Fraud seems to increase slightly after 5 attempted logins.
3) Fraud does not seem to vary too much with other variables

*Account days and average transaction amount by Fraud*  
There is little relationship between transaction amounts and average age of accounts in days.
The fraudulent data points are visible in the entire range across the y and x axis. 

*International transactions by Fraud*   
Local transactions tend too be more fraudulent than international ones 6.7% vs 4.6%. 

*Location by Fraud*     
Hyderabad and Mumbai have a higher prevalence of fraud than other dice locations. 

**Weird Distribution Analysis**
I used a `Q-Q Plot` to compare the transaction amounts against a theoretical normal distribution.
The result was a perfectly linear relationship, indicating the data follows a Uniform Distribution U(a,b).

In real-world finance, transaction amounts are typically skewed; this perfect uniformity suggested the data was stochastically generated from a uniform distribution.

I also used `Correlation heat map` to see what features may have been most important but all the features were very minimally correlated with each other and
<img width="1025" height="1085" alt="Image" src="https://github.com/user-attachments/assets/1818727d-e772-4e72-9b3f-bc2a08b14630" />

This suggested that the features may have been generated independently and stitched with fraud labels applied randomly.

*MODELLING AND EVALUATION*

FEATURE ENGINEERING & ETL
AUTOMATED PIPELINES

To handle the data cleaning and preparation, I developed two ETL system using custom Python classes that created an automated method of hadnling both numerical and categorical variables   
This allowed for reproducible "fit" and "transform" operations across training and testing sets.  
These classes were called `ETL_numeric` and `ETL_categorical`.  
Custom ETL Classes I created a dedicated class to store the transformation logic. This ensured that any cleaning applied to the training data—such as handling missing values or renaming columns—was identically applied to the test data.

**The fit() and transform() Logic**    
By following the Scikit-Learn API structure, I implemented:

fit(): Calculated the necessary statistics from the training data. 
`ETL_numeric` - involved calculating numeric interactions such as:  
`ATO score` = (ip risk score + login attempts)/ account age (velocity metric)       
`z-scores` using using linear transformations of variances each  user's average transaction amount average of their average transaction amount group.  

`ETL_categorical` - involved calculating the rarities of categorical features based on each user's historical transaction data. 

transform(): Applied those calculated values to both the training and test datasets. This prevents Data Leakage, ensuring the model doesn't "see" information from the future during training.

Encoding: Implemented OneHotEncoder and StandardScaler within a ColumnTransformer to handle categorical and numerical features in a single pass.

`Pipeline` - Combined custom transformers into a streamlined  automation to ensure all pre-processing steps are applied atomically during both training and inference.   
This architecture prevents data leakage by encapsulating the fit() and transform() logic within a single executable object.

With the features engineered, I utilized advanced resampling and optimization techniques to handle the imbalanced nature of fraud.

`SMOTE-ENN`:   
Courtesy of Geekforgeeks there is a method we can use for highly unbalanced datasets called SMOTE.  
This is a resampling technique that generates synthetic data for our minority non fraud class.   
It interpolates between existing data to create  completely new data points.  
It helps prevent overfitting and allows models to learn patterns that predict minority class. 

I then generated synthetic fraud cases to balance the classes.    
As the data was diffcult to get a signal from ENN allowed elimination of neighbours that were to similar to non fraud categories. 

`GridSearchCV`: Automated the search for optimal hyperparameters (e.g., max_depth, n_estimators) for Logistic regression mode using 50 iterations of RandomizedSerachCV.

## FINAL INSIGHTS

<img width="273" height="112" alt="Image" src="https://github.com/user-attachments/assets/7816cc82-3b37-47c3-a135-0b4d057548ed" />

Despite the modular ETL classes and optimized pipelines, the model performance confirmed the findings of the R-based audit.

Interpretation of Output
Signal Integrity: My custom transformers and engineering steps were unable to extract a signal because the fraud labels were stochastically independent of the features.

Performance: Precision and Recall metrics remained consistent with a "Zero-Signal" environment.

**Final Verdict**:   
The project was a successful exercise in Adversarial Discovery.   

I did learn though that no matter what model you use, the old adage stays true: "Garbage in, garbage out".   
Our recall improved drastically after we engineered good features with great predictive power.   
After conducting further EDA particularly the qq plots, I think there may have also been a bottleneck in data quality.   
Both transactions following a uniform distribution with such low correlations between all features suggested the data may have been independently generted column by column with fraud labels added later. It is highly unlikely that every transactin amount range is equally as dense as transactions tend to be right skewed or log normal.   

The main limitations were therefore:
- data quality 
- highly unbalanced dataset 

I did learn a lot form this project even with the underwhelming results, mainly:

- `feature engineering`.
- various `scikit-learn` and `imbalanced-learn` tools like Logistic regression, SMOTE, Pipelines, Grid search and Randomised Search and  Columntransformer and Function transformer to create your own transformers and fitters.
- `numpy`  like arrays that can vectorise calculations. 
- `pandas` functionality like groupby and getting dummies. 
- basic python functionality like dictionaries. 
- overall project structure. 

I would say this was a very good learning opportunity and I got to grow a lot for 1 weeks work. 
It proved that while the engineering was sound, the high Bayes Error Rate of the dataset made predictive modeling a lost cause.  

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

## USEFUL EDUCATIONAL RESOURCES    
[Geekforgeeks - SMOTE](https://www.geeksforgeeks.org/machine-learning/smote-for-imbalanced-classification-with-python/)

## WHAT DOES THE FUTURE HOLD?   
1) Carry out EDA to discovery what variables have the most relevance to fraud 
2) Create custom fit and transform classes   
3) Create custom pipelines to automate the modelling process 
4) Create custom column transformer to apply one hot encoding and feature scaling      
5) Use qq-plots to look into distribution of variables     


## AUTHORS   
[leta199](https://github.com/leta199)