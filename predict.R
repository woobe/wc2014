## Analysis and Prediction

rm(list=ls())

library(xlsx)
library(e1071)
library(caret)
library(randomForest)
library(gridExtra)

## =============================================================================
## Load Data
## =============================================================================

dat <- read.xlsx(file = './data/data_wc2014.xlsx', sheetName = 'Data')

## =============================================================================
## Normalise Data
## =============================================================================

dat_raw <- dat
pp <- preProcess(dat[,3:14])
dat[, 3:14] <- predict(pp, dat[,3:14])

## =============================================================================
## Train
## =============================================================================

rng_train <- -2:-4
x_train <- dat[rng_train, 3:14]

y_train_HG <- dat[rng_train, 15]
y_train_AG <- dat[rng_train, 16]
y_train_DF <- dat[rng_train, 17]

x_test <- dat[-rng_train, 3:14]

model_HG <- svm(x_train, y_train_HG, cost = 100)
model_AG <- svm(x_train, y_train_AG, cost = 100)
model_DF <- svm(x_train, y_train_DF, cost = 100)

yy_HG <- predict(model_HG, x_test)
yy_AG <- predict(model_AG, x_test)
yy_DF <- predict(model_DF, x_test)

output <- data.frame(dat_raw[-rng_train, c(1,2,6,7,8)], 
                     Home_Goal = round(yy_HG,0), 
                     Away_Goal = round(yy_AG,0),
                     Goal_Diff = round(yy_DF,1))

grid.table(output, show.rownames = F)
