## =============================================================================
## WC 2014 Analysis and Predictions
## =============================================================================

## Initiate
setwd("/media/SUPPORT/Repo/wc2014")
suppressMessages(library(xlsx))
suppressMessages(library(caret))
suppressMessages(library(e1071))
suppressMessages(library(randomForest))
suppressMessages(library(Cubist))
suppressMessages(library(earth))
suppressMessages(library(kknn))
suppressMessages(library(reshape2))
suppressMessages(library(ggplot2))
suppressMessages(library(gridExtra))
suppressMessages(library(extrafont))

## Set seed
set.seed(1234)


## =============================================================================
## Load Data
## =============================================================================

dat <- read.xlsx(file = './data/data_wc2014.xlsx', sheetName = 'Data')


## =============================================================================
## Normalise Data
## =============================================================================

## Keep a copy
dat_raw <- dat

## Pre-process predictors
pp <- preProcess(dat[,4:15], method = c("center", "scale", "BoxCox"))
dat[, 4:15] <- predict(pp, dat[, 4:15])


## =============================================================================
## Split Train/Test
## =============================================================================

## Define Training Set Here!
#rng_train <- -2:-4   ## using others' predictions for future fixtures as train
rng_train <- -2:-4

## Split train/test
x_train <- dat[rng_train, 4:15]
x_test <- dat[-rng_train, 4:15]

## Pred
dat_pred <- data.frame(dat_raw[-rng_train, 2:3], Match = NA)
for (n in 1:nrow(dat_pred)) {
  dat_pred[n, 3] <- paste0(dat_pred[n, 1], "_v_", dat_pred[n, 2])
}


## =============================================================================
## Train Models
## =============================================================================

for (n_round in 1:3) {
  
  ## Empty Shell
  tmp_yy <- matrix(NA, nrow = nrow(x_test), ncol = 5)
  
  ## Get y_train
  y_train <- dat[rng_train, (15+n_round)]
  
  ## Train SVM
  model <- svm(x_train, y_train)
  tmp_yy[, 1] <- predict(model, x_test)

  ## Train RF
  model <- randomForest(x_train, y_train)
  tmp_yy[, 2] <- predict(model, x_test)
  
  ## Train Cubist
  model <- cubist(x_train, y_train, committees = 100)
  tmp_yy[, 3] <- predict(model, x_test)
  
  ## Train Earth
  model <- earth(x_train, y_train)
  tmp_yy[, 4] <- predict(model, x_test)
  
  ## Train knn
  tmp_df <- data.frame(x_train, y=y_train)
  model <- kknn(y~., tmp_df, x_test)
  tmp_yy[, 5] <- model$fitted.values
  
  ## Save
  if (n_round == 1) yy_HG <- data.frame(Match = dat_pred$Match, Team = "Home", tmp_yy)
  if (n_round == 2) yy_AG <- data.frame(Match = dat_pred$Match, Team = "Away", tmp_yy)
  if (n_round == 3) yy_DF <- data.frame(Match = dat_pred$Match, Team = "Diff", tmp_yy)
  
}

## =============================================================================
## Create a ggplot object
## =============================================================================

yy_all <- rbind(melt(yy_HG),
                melt(yy_AG),
                melt(yy_DF))
colnames(yy_all) <- c("Match", "Team", "Variable", "Goals")

g <- ggplot(yy_all, aes(x = Team, y = Goals, fill = Team)) + 
  geom_boxplot() +
  scale_fill_manual(name = "Team", values = c("#34B2CF", "#FCCB05", "#FB0101")) +
  facet_grid(~ Match)  +
  theme(title = element_text(size = 16),
        strip.text = element_text(size = 18),
        axis.text = element_text(size = 12),
        legend.text = element_text(size = 12))


## =============================================================================
## Create Output Data Frame
## =============================================================================

## Train/Test, Date and Teams
output <- data.frame(matrix(NA, nrow = nrow(dat_raw), ncol = 10))
output[rng_train, 1] <- "Training Set"
output[-rng_train, 1] <- "Predictions"
output[, 2:4] <- dat_raw[, 1:3]

## Real Data
output[rng_train, 5:7] <- dat_raw[rng_train, c("RES_H", "RES_A", "DIFF")]

## Predictions (Previous)
output[rng_train, 8:10] <- dat_raw[rng_train, c("PRED_H", "PRED_A", "PRED_DIFF")]

## Predictions (Current)
output[-rng_train, 8] <- round(apply(yy_HG[,-1:-2], 1, median), 1)
output[-rng_train, 9] <- round(apply(yy_AG[,-1:-2], 1, median), 1)
output[-rng_train, 10] <- round(apply(yy_DF[,-1:-2], 1, median), 1)

## Rename columns
colnames(output) <- c("Data", "Date", "Home", "Away", 
                      "Real_Home", "Real_Away", "Real_Diff",
                      "Pred_Home", "Pred_Away", "Pred_Diff")


## =============================================================================
## Create Output Data Frame
## =============================================================================

## Generate File Name
now <- Sys.time()
now <- gsub(":", "",now)
now <- gsub(" ", "_",now)
tmp_name <- paste0("./output/",now, "_pred.pdf")

## Load Extra Fonts
suppressMessages(loadfonts())

## Define output size
row_max <- max(which(output$Data == "Predictions"))
pdf_h <- min(c(max(c(row_max * 0.4, 7)), 28))
pdf_w <- 14

## Print PDF
pdf(file = tmp_name, height = pdf_h, width = pdf_w, 
    family = "Ubuntu", title = "WC2014 Predictions by Jo-fai Chow")
grid.table(output[1:row_max,], show.rownames = F)
print(g)
dev.off()
