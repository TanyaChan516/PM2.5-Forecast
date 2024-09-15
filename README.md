## PM2.5-Forecast

### Context
The project is interested in finding the best approach in forecasting PM 2.5 in Beijing, by focusing on natural factor in this dataset. 

### Content 
This hourly data set contains the PM2.5 data of US Embassy in Beijing. Meanwhile, meteorological data from Beijing Capital International Airport are also included. Regression is the major machine tasks in forecasting PM2.5

### Ordinary Least Squred 
|       |  Estimate |  Std. Error  |  t value  |  p value  |  remarks  |
|  :-----:  |  :--------:  |  :-----:  |  :------:  |  :------: | :------: |
|  Intercept  |   -6.490e+06  |  1.823e+06  |  -3.561  |  0.000372  |  ***  |
|  row number  |   -3.699e-01  |  1.035e-01  |  -3.573  |  0.000355  |  ***  |
|  year        |   3.229e+03  |  9.068e+02  |   3.561  | 0.000371  |  ***  |
|  month       |   2.664e+02  |  7.548e+01  |  3.529  |  0.000419  |  ***  |
|  day         |  9.368e+00  |  2.479e+00   |  3.779  |  0.000158  |  ***  |
|  hour        |   2.509e+00  |  1.553e-01  |  16.153  | < 2e-16  |  ***  |
|  season      |   9.168e+00  |  1.682e+00  |  5.451  | 5.12e-08  |  ***  |
|  dew point   |   3.722e-01  |  3.195e-01  |  1.165  | 0.243981  |  
|  humidity    |   1.299e+00  |  1.095e-01  |  11.867 |  < 2e-16  |  *** |
|  pressure    |  -6.643e-01  |  1.462e-01  |   -4.545| 5.55e-06  | ***  |
|  temperature |  -2.772e+00  |  3.196e-01  |  -8.675  |  < 2e-16  | ***  |
|  combined wind direction|   1.901e-01  |  6.771e-01  |   0.281  | 0.778938  |  
|  accumulated wind speed |  -2.476e-01  |  1.765e-02  | -14.029  |  < 2e-16  | ***  |
|  precipitation  | -2.089e+00  |  1.379e+00  |  -1.515  | 0.129794  |    
|  accumulated precipitation |  -3.449e+00  |  4.120e-01  |  -8.371  |  < 2e-16  | ***  |

> RSE = 73.98 <br>
Any prediction on PM 2.5 would possibly be off by 73.98 on average <br>

> R squared = 0.2781 <br>
Barely 27.81% variability in PM 2.5 can be explained by linear regression model

### Best Subset Selection
> RSS, adjusted R-squared, Cp, and BIC are minimized <br>

<img src="https://github.com/user-attachments/assets/6de2027a-0b0f-4117-b10c-093ce1f5b6ca" width="500" height="500" /> <br>

### Lasso Regulation
> Coefficient of Year and Dew Point is set to be zero <br>

<img src="https://github.com/user-attachments/assets/aaddd7f6-9507-473d-bcf1-10473893dd20" width="500" height="500" /> <br>

### Regression Tree
> 9 variables are used to construct the regression tree into 13 groups: <br>
humidity, wind direction, wind speed, temperature, season, pressure, dew point, month, time
> 
<img src="https://github.com/user-attachments/assets/6f44f785-fa4d-4db0-97b2-4669781560bc" width="500" height="500" /> <br>

### Bagging and Boosting Tree
> Humidity and time are two most important features <br>

<img src="https://github.com/user-attachments/assets/3844567f-0e48-455d-86e3-a223b26e2405" width="500" height="500" /> <br>


### Principal Component Regression
<img src="https://github.com/user-attachments/assets/d2bc260b-50f3-4cfb-a6b4-a741f9225807" width="500" height="500" /> <br>

### Summary
1. Linear regression with best subset selection and Lasso regulation
  > - captures the linear relationship between predictors and PM2.5 <br>
  > - best subset selection select best model that minimize RSS by considering all combinations <br>
  > - Lasso works best with small no. of predictors (14) with high predictive power and interpredibility <br>
2. Regression tree with bagging and boosting
  > - handle the highly non linearity and complexity between predictors and PM2.5 with high interpredability <br>
  > - improve predition accuracy <br>
3. PCR
  > - multivariable regression with possible mulitcollinearity that could increase variance <br>
  
|  Regression Approach  |  Test Mean Squared Error  |
|  :-----------------:  |  :------:  |
|          Ordinary Least Squred          |  5220.767  |
|  Regression with Best Subset Selection  |  5219.028 |
|  Regression with Lasso Regulation  |  5450.119  |
|  Regression Tree  |  4604.858  |
|  Bagging Tree  |  11291.019  |
|  Boosting Tree  |  1361.898  |
|  Principal Component Regression |  5370.254  |
