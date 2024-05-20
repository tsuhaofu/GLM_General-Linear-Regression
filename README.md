# Analysis of the `Car93` Dataset Using Linear Regression Models

This project segment focuses on the analysis of the `Car93` dataset from the `MASS` package in R, specifically examining the fuel consumption of cars. The aim is to identify significant predictors of the average fuel consumption, calculated as the average of `MPG.city` and `MPG.highway`.

## Dataset Introduction

The [Car93 dataset](https://www.rdocumentation.org/packages/MASS/versions/7.3-60.0.1/topics/Cars93) contains detailed information about 93 cars from the 1993 model year, covering a range of features, specifications, and manufacturer details. Here is an overview of the variables:

- **Manufacturer:** The name of the car manufacturer.
- **Model:** The specific model of the car.
- **Type:** The type or category of the car (e.g., Small, Midsize, Compact).
- **Min.Price:** The minimum price of the car (in thousands of dollars).
- **Price:** The midrange price of the car (in thousands of dollars).
- **Max.Price:** The maximum price of the car (in thousands of dollars).
- **MPG.city:** The fuel efficiency of the car in city driving (miles per gallon).
- **MPG.highway:** The fuel efficiency of the car in highway driving (miles per gallon).
- **AirBags:** Information about the availability of airbags (None, Driver only, Driver & Passenger).
- **DriveTrain:** The type of drivetrain (Front-wheel, Rear-wheel, 4WD).
- **Cylinders:** The number of cylinders in the car's engine.
- **EngineSize:** The size of the engine (in liters).
- **Horsepower:** The power output of the car's engine (in horsepower).
- **RPM:** The revolutions per minute at which the engine produces its maximum horsepower.
- **Rev.per.mile:** The engine revolutions per mile at cruising speed.
- **Man.trans.avail:** Indicates if a manual transmission is available (Yes or No).
- **Fuel.tank.capacity:** The capacity of the car's fuel tank (in gallons).
- **Passengers:** The number of passengers the car can comfortably accommodate.
- **Length:** The overall length of the car (in inches).
- **Wheelbase:** The distance between the front and rear axles (in inches).
- **Width:** The overall width of the car (in inches).
- **Turn.circle:** The diameter of the smallest U-turn the car can make (in feet).
- **Rear.seat.room:** The legroom in the rear seat (in inches).
- **Luggage.room:** The space available in the car's trunk (in cubic feet).
- **Weight:** The total weight of the car (in pounds).
- **Origin:** The country or region where the car was manufactured (USA or non-USA).
- **Make:** A combination of the manufacturer and model names.

## Objective

The goal is to determine the most significant predictors of fuel consumption using linear regression models, with a focus on methodological rigor and addressing potential statistical challenges like multicollinearity.

## Methodology

### Exploratory Data Analysis (EDA)
1. **Preliminary Variable Selection:** Based on correlations and relevance, variables like `Min.Price`, `Max.Price`, and `Price` were highly correlated, leading to the use of just `Price` as a predictor. The `Cylinders` variable was adjusted from categorical to numeric after removing an outlier.
2. **Handling Missing Values:** Variables like `Rear.seat.room` and `Luggage.room` were removed due to their minor correlation with target variables and presence of missing values, maintaining data integrity in the small sample size.
3. **Multicollinearity:** Initial correlations indicated potential issues, which were later addressed using Variance Inflation Factor (VIF) tests.

### Model Development
1. **Transformation for Normality:** A Box-Cox transformation was applied to address the right skewness of the average MPG, improving model fit and residuals distribution.
2. **Stepwise Regression:** Both forward and backward stepwise regressions using AIC and BIC identified the optimal set of predictors.
3. **Multicollinearity Check:** VIF tests ensured that multicollinearity did not unduly influence the model's estimates.

## Results

- **Model Choice:** The final model selected through the Forward BIC approach includes `Weight`, `Length`, `Fuel.tank.capacity`, and `Origin` as predictors.
- **Significance of Predictors:** All predictors were found to be significant, with weight and fuel tank capacity showing a negative relationship with fuel consumption, while length and origin (non-USA, particularly Japanese cars) were associated with better fuel economy.

## Conclusion 

The analysis demonstrated the importance of methodical variable selection and transformation to handle data complexities. The selected model highlights the influence of physical attributes and manufacturer origin on fuel efficiency. Challenges like multicollinearity were addressed, but further exploration with methods like Lasso regression or random forest might provide deeper insights.
