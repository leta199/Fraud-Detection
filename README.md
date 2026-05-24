# Fraud Detection 

A classic problem in financial environments. We will take a look at classifying transactions into fraud and not fraud using scikit-learn packages.  
The dataset is obtained from Kaggle here: [Digital Payment Fraud Detecton](https://www.kaggle.com/datasets/jayjoshi37/digital-payment-fraud-detection/data)
This project will go over using scikit-learn in binary classification  for this dataset and we will cover:   

1. Data pre - processing and cleaning 
2. Exploratory Data Analysis and Data mining 
3. Modelling and evaluation 
4. Evaluation and testing 
 
## HOW IT'S MADE 
Languages used: Python (version 3.14.3),  R  (version 4.5.2)     
Environment: VSCode, RStudio 

![Python](https://img.shields.io/badge/Python-3.14-blue)
[![Language: R](https://img.shields.io/badge/Language-R-276DC3.svg?style=flat-square)](https://www.r-project.org/)
[![Built with RStudio](https://img.shields.io/badge/IDE-RStudio-75AADB?style=for‐the‐badge&logo=rstudio&logoColor=white)](https://www.rstudio.com/)
![Jupyter](https://img.shields.io/badge/Notebook-Jupyter-orange)
![Status](https://img.shields.io/badge/Status-Completed-lightgrey)

## METHODS AND TECHNIQUES  

### DATA PRE-PROCESSING AND CLEANING ###   
We mimicked a real life data science workflow by separating the dataset into train and test sets before any EDA to mimic new transactions.   
We separated our predictor variables and response variable into x and y respectively.   
We created a 70/30  train/test split while stratifying across y to ensure we had an equal ditribution of fraud and not fraud in the train data compared to the test data.   
Our data was relatively clean so there was not too much pre-processing to be done. 

### EXPLORATORY DATA ANALYSIS AND DATA MINING ###    

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
<img width="1728" height="1085" alt="Image" src="https://github.com/user-attachments/assets/5bfa6365-488b-429e-8b4d-ab061a1f0b70" />

*Categorical and numeric variables by Fraud*
1) We see that the hours of 02:00 a.m., 03:00 a.m., 5:00 a.m., 07:00 a.m.,  08:00 a.m.,11:00 a.m., 13:00 p.m., 18:00 p.m., 19:00 p.m., and 21:00 p.m.
      have a higher prevalence of fraud than other times.
2) Fraud seems to increase slightly after 5 attempted logins.
3) Fraud does not seem to vary too much with other variables
<img width="1728" height="1085" alt="Image" src="https://github.com/user-attachments/assets/9e5ace9f-420a-4ef8-a337-a50cdd6db1a7" />

*Account days and average transaction amount by Fraud*  
There is little relationship between transaction amounts and average age of accounts in days.
The fraudulent data points are visible in the entire range across the y and x axis. 
<img width="1728" height="1085" alt="Image" src="https://github.com/user-attachments/assets/904426b0-f25c-4302-a448-6aa36e56c4d0" />

*International transactions by Fraud*   
Local transactions tend too be more fraudulent than international ones 6.7% vs 4.6%. 
<img width="1728" height="1085" alt="Image" src="https://github.com/user-attachments/assets/4bc6f03a-59cb-4601-8d02-0bae18133276" />

*Location by Fraud*     
Hyderabad and Mumbai have a higher prevalence of fraud than other dice locations. 
<img width="1728" height="1085" alt="Image" src="https://github.com/user-attachments/assets/2b289a0c-3819-404f-a20a-c9db14cc8921" />

### MODELLING, EVALUATION AND TESTING ### 

#### FEATURE ENGINEERING & ETL ####

To handle the data cleaning and preparation, I developed two ETL systems using custom Python classes that created an automated method of handling both numerical and categorical variables.    
This incororated the use of `BaseEstimator` and `TranformerMixin` as agruments to implement these classes into scikit-learn pipelines. 
This allowed for reproducible `fit` and `transform` operations across training and testing sets.  
These classes were called `ETL_numeric` and `ETL_categorical`.  

For the custom ETL pipeline I created a dedicated class to store the transformation logic. This ensured that any cleaning applied to the training data—such as handling missing values or renaming columns was identically applied to the test data.

### FIT LOGIC ###
This is what allows us to create features based on "historical" user data (data from the train set) that we can use to determine if transactions from tne test set are suspicious.  
It is implimented using the `.fit()` function on the train set and makes a profile for each user from the train set that we can use to compare to the test data (simluated incoming transcations) to see if whether or not they are fraud. 

#### ETL Numeric ####   
Involved calculating numeric interactions such as:  

`Z-scores`   
We aim to calculate z scores from each transaction amount. In order to do this we assume that transcations amounts follow a Guassian distribution. Using the transaction amount and avg transcation amount fields we calculate z scoes with the following methodology:
We will create a weighted standard devation score made up of two parts: user standard devation and group standard deviation. 

$$\sigma_{\text{final}} = \frac{n}{n+k} \sigma_{\text{user}} + \frac{k}{n+k} \sigma_{\text{group}}$$ 

Where k is an adjustible parameter that corresponds to number of users and n is a number of smoothing parameter.     
This allows us to create a standard devation that is non zero so we dont have an undefined z score. 
We can then get each user's z scores with the formula:

$$Z-score = \frac{\text{Transaction Amount} - \text{Avg Transaction Amount}}{\sigma_{\text{final}}}$$

This allows us to consider how unusual the transaction amount is for the group the user belongs to and for the user based on historical transaction in the train set. 

#### ETL Categorical ####     

`Location rarity`  and `Global rarity`  

Is a score that we define based on historical data for each user (users in  the test set) on how common (or uncommon) transactions from the 5 locations are.     
This metric has two main interpretations: 
- higher score means rarer location
- lower score means more common location

We calculate this rarity metric as:   

$$\text{user location rarity} = 1 - \frac{\text{number of locations transactions} + \alpha}{\text{total number of transactions } + \alpha \cdot K}$$

- $\text{number of location transactions}$ - number of transcations for each user in 1 of the 5 locations.
- $\alpha$ - smoothing parameter to prevent null entries
- $\text{total number of transactions}$ - total number of transcations performed by user in train set  
- $K$ - number of locations in the data
  
In addition to the user specific rarity we also have global rarities that will be applied to new users that do not appear in the training set.  

$$\text{global rarity} = 1 - \frac{\text{total number of transcations in location} + \alpha}{\text{total number of transactions} + \alpha \cdot K}$$

- $\text{total number of transcations in location}$ - total number of transcations for every user in 1 of the 5 locations in the train set
- $\alpha$ - smoothing parameter to prevent null entries
- $\text{total number of transactions}$ - total number of transcations performed by all users in train set  
- $K$ - number of locations in the data

Once we applied this method to the categorical features of location we then extended the rationale to other categorical fetaures such as: payment mode, device type and transaction type.  
After we run of fit duntion we creat a dictionary of specific user inofrmstion and global information which consists of:
1. How common each location is for each user
2. How common each categorical values is for each user such as "how often does User ID 123 use mobile phones in the past

### TRANSFORM LOGIC ###  
Once we have information about the history of each user in regards to categorical features we can now apply transformations on the test set to make predictions.   
We engineeer a few more features that can help augment the calssification problem for each user. These features include: 

`Login aggression`    
Tells us  the avrage number of logins per day in account age which correpsonds tp how aggressive any particular user is being in trying to log into their account.   
- Newer accounts as well as hacked accounts are likely to have a larger number of login attempts.

$$\text{login aggression} = \frac{\text{login attempts last 24h}}{\text{account age days} + \text{aggr smooth}}$$ 
- $\text{aggr smooth}$ - a smootihg factor that can account for newe accounts with an age of 0 so we do not divide by 0.

`Failed login aggression`  
Tells us average number of failed login attempts per day. 
- A higher rate of error is likely to correlate with fraudulent cases. 

$$\text{failed login aggression} = \frac{\text{previous failed attempts}}{\text{account age days} + \text{failed aggr smooth}}$$
- $\text{failed aggr smooth}$ - a smootihg factor that can account for newe accounts with an age of 0 so we do not divide by 0.

`ATO score`   
Tells us the average risk score and login attempts per day in account age
- We expect fraudulent new accounts to have a high number of logins in a short amount of time which will lead to a low ATO score. This is referred to as our velocty metric.

$$\text{ATO score} = \frac{\text{IP Risk Score} + \text{login attempts last 24h}}{\text{Account Age} + \text{ATO smooth}}$$

- $\text{ATO smooth}$ - acts as our smoothing values to prevent division by 0.

`Failure rate`  
Percentage of total login attempts that were failed.
- We expect that accounts that have fraudsters in them have a high failure rate 

$$\text{failure rate} = \frac{\text{previous failed attempts}}{\text{login attempts last 24h}}$$

`Cost per failure`    
The average amount of money associated with a failed transaction.   
- A higher value indicates that a certain accounts has large amounts of money being moved around per fialure that could indicate fraudlent activity. 

$$\text{cost per failure} = \frac{\text{transaction amount}}{\text{previous failed attempts} + \text{cpf smooth}}$$

- $\text{cpf smooth}$ - acts as our smoothing values to prevent division by 0.

`IP age pressure`  
Ratio of IP score to account  age.   
- A new high value corresponds to a high risky new account that may indicate fraud.

$$\text{ip age pressure} = \frac{\text{ip risk score}}{\text{account age days} + \text{ip age pressure smooth}}$$

- $\text{ip age pressure smooth}$ - acts as our smoothing values to prevent division by 0.

`Transaction amount average ratio`  
The percentage of each users average transaction amount that any new transaction is.    
- The higher this ratio the greater suspicion of fraud in that transaction. 

$$\text{trans amount average ratio} = \frac{\text{transaction amount}}{\text{avg transaction amount}}$$

Finally we will scale the raw numerical values and apply dummy variables to categorical features.  
We implemented `OneHotEncoder` and `StandardScaler` using  ColumnTransformer to handle categorical and numerical features in a single pass.

#### PIPELINES ####
Once we finish engineering the above features, we not need to automate the modelling process to apply the fir and trasnform methods we designed.   
This will be done using `imblearn` library and the SMOTE ENN procedure. 

`Pipeline`  
Combined custom transformers into a streamlined  automation to ensure all pre-processing steps are applied atomically during both training and inference.   
This architecture prevents data leakage by encapsulating the fit() and transform() logic within a single executable object.

**PipeLine #5**   
After experimenting with multiple pipelines \ using Logistic regression,our ETL categorical and numeric classes, the best pipeline that detetcted the most fraud was #5.

| Logistic regression | Metric |
| :--- | :---: |
| Balanced accuracy | 51.45% |
| Precision | 6.83% |
| Recall | 62.58% |

1. We can see that the balanced accuracy is close to 50% indicating that the model is not much better than random guessing.
2. We are able to detect a majority of fraud cases
3. We have many false postiives in an effort to get a high recall so we have a very low precision.
Overall, our pipeline seems to have a diffuclt time findign a string signla for fraud. Therefore we will investigate if the imbalanced neature of fraud may be the cause of our struggling model.


`SMOTE-ENN`:   
Courtesy of Geekforgeeks, there is a method we can use for highly unbalanced datasets called SMOTE.  
This is a resampling technique that generates synthetic data for our minority non fraud class.   
It interpolates between existing data to create  completely new data points.  
It helps prevent overfitting and allows models to learn patterns that predict minority class. 

We made sure to generate data points using `k-neighbors` = 2 i.e generate data points based on the two closest neighbos to ensure that fraud signal is not diluted by many data points.   
We implemented `n_neighbors` = 1 to generate one new data points from these two neighbors.  
Finally we then got followed the fit 

`GridSearchCV` and `RandomizedSearchCV`
After implementing SMOTE ENN, we aim to identify what parameters help us best detect fraud from the custom classes we created as well as from the SMOTE ENN procdure. We implemented Randomizsed search to idenitfy tehe best parameters of:


**Weird Distribution Analysis**   
`Q-Q Plot`    

compared the transaction amounts against a theoretical normal distribution.
The result was a perfectly linear relationship, indicating the data follows a Uniform Distribution U(a,b).  
- The gradient of the values plotted is greater than our y = x trend line whihch means that the varaince of the sample data is greater than for a standrd nomral equation. 
<img width="1728" height="1085" alt="Image" src="https://github.com/user-attachments/assets/48bdb731-a206-45ce-970c-8cecc9ab6df9" />

<img width="1728" height="1085" alt="Image" src="https://github.com/user-attachments/assets/4d74ff65-13d5-4054-9a9f-32ccf92cad4e" />

In real-world finance, transaction amounts are typically right skewed (transactions of smaller amounts are more frequent thn larger amounts); this perfect uniformity suggested the data was stochastically generated from a uniform distribution.

 `Correlation Plot` 
 
 Revealed what features may have been most important but all the features were very minimally correlated with each other 
- This suggested that the features may have been generated independently and stitched with fraud labels applied randomly.
<img width="1025" height="1085" alt="Image" src="https://github.com/user-attachments/assets/1818727d-e772-4e72-9b3f-bc2a08b14630" />

## FINAL INSIGHTS

<img width="273" height="112" alt="Image" src="https://github.com/user-attachments/assets/7816cc82-3b37-47c3-a135-0b4d057548ed" />

Despite the modular ETL classes and optimized pipelines, the model performance confirmed the findings of the R-based audit.

Interpretation of Output
Signal Integrity: My custom transformers and engineering steps were unable to extract a signal because the fraud labels were stochastically independent of the features.

Performance: Precision and Recall metrics remained consistent with a "Zero-Signal" environment.

**Final Verdict**   
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
|  ├──[test_data](https://github.com/leta199/Fraud-Detection/blob/main/dataset/test_data.csv)  
│  ├──[train_data](https://github.com/leta199/Fraud-Detection/blob/main/dataset/train_data.csv)   
│  └──[whole_dataset](https://github.com/leta199/Fraud-Detection/blob/main/dataset/whole_dataset.csv)  
│    
|├──[modelling](https://github.com/leta199/Fraud-Detection/tree/main/modelling)  
│  ├──[fraud_detection](https://github.com/leta199/Fraud-Detection/blob/main/modelling/fraud_detection.ipynb)      
│  └──[train_test_split](https://github.com/leta199/Fraud-Detection/blob/main/modelling/train_test_split.ipynb)      
│    
|├──[visualisations](https://github.com/leta199/Fraud-Detection/tree/main/visualisations)    
│  ├──[account_age_fraud](https://github.com/leta199/Fraud-Detection/blob/main/visualisations/account_age_fraud.png)   
│  ├──[amounts_fraud](https://github.com/leta199/Fraud-Detection/blob/main/visualisations/amounts_fraud.png)    
│  ├──[amount_density_fraud](https://github.com/leta199/Fraud-Detection/blob/main/visualisations/amt_fraud_density.png)    
│  ├──[amount_qqplot](https://github.com/leta199/Fraud-Detection/blob/main/visualisations/amt_fraud_qq.png)    
│  ├──[average_amount_density_fraud](https://github.com/leta199/Fraud-Detection/blob/main/visualisations/avg_amt_fraud_denisty.png)    
│  ├──[average_amount_qqplot](https://github.com/leta199/Fraud-Detection/blob/main/visualisations/avg_amt_fraud_qq.png)    
│  ├──[categorical_fraud](https://github.com/leta199/Fraud-Detection/blob/main/visualisations/categorical_fraud.png)    
│  ├──[correlation_fraud](https://github.com/leta199/Fraud-Detection/blob/main/visualisations/correlation_fraud.png)    
│  ├──[final_pipeline_metrics](https://github.com/leta199/Fraud-Detection/blob/main/visualisations/final_pipeline.png)    
│  ├──[international_fraud](https://github.com/leta199/Fraud-Detection/blob/main/visualisations/international_fraud.png)    
│  ├──[ip_risk_fraud](https://github.com/leta199/Fraud-Detection/blob/main/visualisations/ip_risk_fraud.png)    
│  ├──[location_fraud](https://github.com/leta199/Fraud-Detection/blob/main/visualisations/location_fraud.png)    
│  └──[r-visualisations](https://github.com/leta199/Fraud-Detection/blob/main/visualisations/r-visualisations.R)  
|    
|├──[License](https://github.com/leta199/Linear-Regression/blob/main/LICENSE)  
|├──[R.history](https://github.com/leta199/Fraud-Detection/blob/main/.Rhistory)   
|├──[requirements](https://github.com/leta199/Fraud-Detection/blob/main/requirements.txt)  
|└──[README](https://github.com/leta199/Fraud-Detection/blob/main/README.md)

## USEFUL EDUCATIONAL RESOURCES    
[Geekforgeeks - SMOTE](https://www.geeksforgeeks.org/machine-learning/smote-for-imbalanced-classification-with-python/)

## WHAT DOES THE FUTURE HOLD?   
1) Carry out EDA to discovery what variables have the most relevance to fraud ✅
2) Create custom fit and transform classes ✅
3) Create custom pipelines to automate the modelling process ✅
4) Create custom column transformer to apply one hot encoding and feature scaling ✅     
5) Use qq-plots to look into distribution of variables ✅   


## AUTHORS   
[leta199](https://github.com/leta199)
