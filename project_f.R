library(data.table)
library(ggplot2)
library(sqldf)
library(MASS)
library(dplyr)


# Exploratory Data and Analysis
## Load and exploratory data 
require(data.table); require(ggplot2); require(sqldf)
data(mtcars)
dim(mtcars)
sqldf('select sum(case when am=1 then 1 else 0 end) as manual , 
                        sum(case when am=0 then 1 else 0 end) as automatic
                        from mtcars')
summary(mtcars)
mtcars$am <- as.factor(mtcars$am)
levels(mtcars$am) <-c("Automatic","Manual")

## t.test
mpg.Automatic <- mtcars[mtcars$am == "Automatic",]$mpg
mpg.Manual <- mtcars[mtcars$am == "Manual",]$mpg
t.test(mpg.Automatic, mpg.Manual) 


#### read above t.test result: The automatic and manual transmissions are from different populations.
### the null hypothesis is rejected due to p-value is 0.00137, 
#### the mean for MPG of manual transmitted cars is 7.245 miles more than that of automatic transmitted cars.

### plots:

## Histgram of by Transmission type
ggplot( data = mtcars, aes(mpg, fill=am)) + 
        geom_histogram() + 
        facet_grid(.~am) + 
        labs ( x = "MPG", y = "Frequency", title = "Histogram: MPG Distribution by Transmission Type") +
        theme(plot.title = element_text(color="grey25", face="bold", hjust=0.5))


## Box Plot by Transmission Type
ggplot(aes(x = am, y = mpg), data = mtcars)  +
        geom_boxplot(aes(fill = am)) +
        labs(x = "Transmission Type", y = "MPG", title = "Boxplot: MPG by Transmission Type") +
        theme(plot.title = element_text(color="grey25", face="bold",hjust=0.5))


## Linear regression
fit <- lm(mpg ~ am, data = mtcars)
summary(fit)

## Multivariable regression
# fit with all variables
fit1 <- lm(mpg ~ . , data = mtcars)
summary(fit1)

# Choose a model by AIC in a Stepwise Algorithm
fit2 <- stepAIC(fit1, direction="both", trace=FALSE)
summary(fit2)

# Anova test
anova(fit, fit1, fit2)
anova(fit, fit2)



#Residual Plots
par(mfrow = c(2,2))
plot(fit2)


