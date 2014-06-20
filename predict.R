## =============================================================================
## WC 2014 Analysis and Predictions
## =============================================================================

## Initiate
rm(list=ls())
#setwd("D:/Repo/wc2014")
setwd("/media/SUPPORT/Repo/wc2014")

## Core Paramemters
n_each <- 200
n_core <- 7
threshold_R2 <- 0.4

## Set seed
set.seed(1234)


## =============================================================================
## Load Packages
## =============================================================================

suppressMessages(library(bib))
suppressMessages(library(xlsx))
suppressMessages(library(caret))
suppressMessages(library(reshape2))
suppressMessages(library(ggplot2))
suppressMessages(library(grid))
suppressMessages(library(gridExtra))
suppressMessages(library(extrafont))


## =============================================================================
## Load Data
## =============================================================================

dat <- read.xlsx(file = './data/data_wc2014.xlsx', sheetName = 'Data')


## =============================================================================
## Double Up Data (Swap Position)
## =============================================================================

## Keep a copy
dat_raw <- dat

## Extract Train, Predict and Future
dat_train <- dat[which(dat$Type == 'train'),]
dat_predict <- dat[which(dat$Type == 'predict'),]
dat_future <- dat[which(dat$Type == 'future'),]

## Swap Home and Away position
col_swap <- c('Date', 'TEAM_A', 'TEAM_H', 'FTE_L', 'FTE_W', 'FTE_D',
              'BF_2', 'BF_X', 'BF_1', 'SPI_A', 'OFF_A', 'DEF_A',
              'SPI_H', 'OFF_H', 'DEF_H', 'RES_A', 'RES_H', 'DIFF',
              'PRED_A', 'PRED_H', 'PRED_DIFF', 'Type')

dat_train_swap <- dat_train[, col_swap]
dat_train_swap$DIFF <- dat_train_swap$DIFF * -1
dat_train_swap$PRED_DIFF <- dat_train_swap$PRED_DIFF * -1
colnames(dat_train_swap) <- colnames(dat)

dat_predict_swap <- dat_predict[, col_swap]
dat_predict_swap$DIFF <- dat_predict_swap$DIFF * -1
dat_predict_swap$PRED_DIFF <- dat_predict_swap$PRED_DIFF * -1
colnames(dat_predict_swap) <- colnames(dat)

dat_future_swap <- dat_future[, col_swap]
dat_future_swap$DIFF <- dat_future_swap$DIFF * -1
dat_future_swap$PRED_DIFF <- dat_future_swap$PRED_DIFF * -1
colnames(dat_future_swap) <- colnames(dat)

## Combine
dat_combine <- rbind(dat_train, 
                     dat_predict,
                     dat_future,
                     dat_train_swap,
                     dat_predict_swap,
                     dat_future_swap)

## =============================================================================
## Normalise Data
## =============================================================================

## Pre-process predictors
pp <- preProcess(dat_combine[,4:15], method = c("center", "scale", "BoxCox"))
dat_combine[, 4:15] <- predict(pp, dat_combine[, 4:15])


## =============================================================================
## Split Train/Test
## =============================================================================

## Define Training Set Here!
row_train <- which(dat$Type == 'train')
row_predict <- which(dat$Type == 'predict')
row_future <- which(dat$Type == 'future')

## Pred
dat_pred <- data.frame(dat_raw[row_predict, 2:3], Match = NA)
for (n in 1:nrow(dat_pred)) {
  dat_pred[n, 3] <- paste0(dat_pred[n, 1], "_v_", dat_pred[n, 2])
}



## =============================================================================
## Testing ....
## =============================================================================

##

if (FALSE) {
  x_train <- dat_combine[which(dat_combine$Type == 'train'), 4:15]
  y_train <- dat_combine[which(dat_combine$Type == 'train'), 16]
  y_max <- max(y_train)
  y_train <- y_train / y_max
  activate_core(7)
  model <- train(x_train, y_train, method = "RRFglobal",
                 trControl = ctrl,
                 tuneLength = 5)
  yy_train <- predict(model, x_train)
  print(nse(yy_train, y_train))
}



## =============================================================================
## Prepare for training
## =============================================================================

## Activate
activate_core(n_core)

## Global variables
ctrl <- trainControl(method = "adaptive_cv",
                     repeats = 1,
                     number = 10,
                     allowParallel = FALSE)

## Train Function
train_caret <- function(dat_combine, pred_type, ctrl, lst_model, n_model, p_train = 0.75) {
  
  ## Extract
  x_train <- dat_combine[which(dat_combine$Type == 'train'), 4:15]
  x_test <- dat_combine[which(dat_combine$Type == 'predict'), 4:15]
  
  if (pred_type == 'Goal') {
    y_train <- dat_combine[which(dat_combine$Type == 'train'), 'RES_H']
  } else {
    y_train <- dat_combine[which(dat_combine$Type == 'train'), 'DIFF']
  }
    
  ## Sub-sample
  row_use <- createDataPartition(y_train, p = p_train, list = FALSE)
  
  ## Train caret model
  model <- train(x_train[row_use, ], y_train[row_use], 
                 trControl = ctrl, 
                 tuneLength = 5,
                 method = lst_model[n_model])
  
  ## Eval
  yy_train <- predict(model, x_train)
  chk_R2 <- R2(yy_train, y_train)
    
  ## Return 
  if (pred_type == 'Goal') {
    if (chk_R2 > threshold_R2) return(predict(model, x_test))
  } else {
    if (chk_R2 > threshold_R2) return(predict(model, x_test))
  }
  
  
}

## List of Models
# lst_model <- rep(c("svmRadial", "rf", "earth", "dnn", "cubist",
#                    "superpc", "relaxo", "pcr", "penalized", "neuralnet", 
#                    "lars", "lars2", "rvmRadial", "foba", "icr", 
#                    "ridge", "M5", "krlsRadial", "spls", "pcaNNet", "nnet", 
#                    "avNNet", "glmboost", "kknn", "gaussprRadial", "glmnet",
#                    "bayesglm", "RRFglobal", "knn"), n_each)  

#lst_model <- rep(c("rf", "earth", "neuralnet"), n_each)

lst_model <- rep(c("rf", "earth", "cubist", "neuralnet", "svmRadial"), n_each)

# lst_model <- rep(c("rf", "earth", "cubist", "svmRadial", "dnn", "bayesglm", "RRFglobal",
#                    "foba", "icr", "ridge", "M5", "spls"), n_each)


## =============================================================================
## Train Models for Goals
## =============================================================================

## Timer
tt <- start_timer()

## Display
cat("Now training models for Goals prediction ...")

## Parallelised Train
tmp_yy <- foreach(n_model = 1:length(lst_model),
                  .combine = cbind,
                  .multicombine = TRUE,
                  .errorhandling = 'remove',
                  .packages = 'caret') %dopar%
  train_caret(dat_combine, pred_type = 'Goal', ctrl, lst_model, n_model)

## Split into Home/Away
tmp_yy <- data.frame(Match = dat_pred$Match, Team = rep(c('Team1','Team2'), each = nrow(dat_predict)), tmp_yy)
#colnames(tmp_yy) <- c("Match", "Team", lst_model[1:dim(tmp_yy)[2]])
yy_HG <- tmp_yy[1:nrow(dat_predict), ]
yy_AG <- tmp_yy[-1:-nrow(dat_predict), ]

## Timer
tt <- stop_timer(tt)

## Disp
cat(" Done! ... Duration:", round(tt), "seconds.\n")


## =============================================================================
## Train Models for Goal Difference
## =============================================================================

## Timer
tt <- start_timer()

## Display
cat("Now training models for Goals Difference Prediction ...")

## Parallelised Train
tmp_yy <- foreach(n_model = 1:length(lst_model),
                  .combine = cbind,
                  .multicombine = TRUE,
                  .errorhandling = 'remove',
                  .packages = 'caret') %dopar%
  train_caret(dat_combine[1:48,], pred_type = 'Diff', ctrl, lst_model, n_model)

## Split into Home/Away
tmp_yy <- data.frame(Match = dat_pred$Match, Team = 'Pred_Diff', tmp_yy)
#colnames(tmp_yy) <- c("Match", "Team", lst_model[1:dim(tmp_yy)[2]])

## Convert Away Goal Diff to Home Goal Diff
#tmp_yy[-1:-nrow(dat_predict), -1:-2] <- tmp_yy[-1:-nrow(dat_predict), -1:-2] * -1
#avg_diff <- (tmp_yy[1:nrow(dat_predict), -1:-2] + tmp_yy[-1:-nrow(dat_predict), -1:-2]) / 2
#yy_DF <- tmp_yy[1:nrow(dat_predict),]
#yy_DF$Team <- 'Pred_Diff'

## 
yy_DF <- tmp_yy

## Timer
tt <- stop_timer(tt)

## Disp
cat(" Done! ... Duration:", round(tt), "seconds.\n")


## =============================================================================
## Create a ggplot object
## =============================================================================

yy_all <- rbind(melt(yy_HG),
                melt(yy_AG))
                #melt(yy_DF))

colnames(yy_all) <- c("Match", "Team", "Variable", "Goals")
yy_all$Goals <- round(yy_all$Goals, 3)

axis_max <- 3 #round(max(yy_all$Goals))
axis_min <- 0 #round(min(yy_all$Goals))

g_density <- ggplot(yy_all, aes(x = Goals, colour = Team, fill = Team)) + 
  geom_density() +
  facet_grid(Team ~ Match) +
  scale_colour_manual(name = "Team", values = c("dodgerblue4", "darkorange4")) +
  scale_fill_manual(name = "Team", values = c("dodgerblue", "darkorange")) +
  theme(title = element_text(size = 18, vjust = 2),
        strip.text = element_text(size = 16),
        axis.text = element_text(size = 12),
        axis.title.y = element_text(vjust = 0.75),
        axis.title.x = element_text(vjust = -0.5),
        legend.text = element_text(size = 12)) +
  ggtitle("Distribution of Predicted Outcomes (Goals) for Each Team") +
  xlim(axis_min, axis_max) + 
  geom_vline(xintercept = 1, linetype = "dotted", size = 0.5) +
  geom_vline(xintercept = 2, linetype = "dotted", size = 0.5) 
  #geom_vline(xintercept = 3, linetype = "dotted", size = 0.5)


g_boxplot <- ggplot(yy_all, aes(x = Team, y = Goals, colour = Team, fill = Team)) + 
  geom_boxplot() +
  scale_colour_manual(name = "Team", values = c("dodgerblue4", "darkorange4")) +
  scale_fill_manual(name = "Team", values = c("dodgerblue", "darkorange")) +
  facet_grid(~ Match)  +
  theme(title = element_text(size = 18, vjust = 2),
        strip.text = element_text(size = 16),
        axis.text = element_text(size = 12),
        axis.title.y = element_text(vjust = 0.75),
        axis.title.x = element_text(vjust = -0.5),
        legend.text = element_text(size = 12)) +
  ggtitle("Boxplots of Predicted Outcomes (Goals) for Each Team") +
  ylim(axis_min, axis_max) +
  geom_hline(yintercept = 1, linetype = "dotted", size = 0.5) +
  geom_hline(yintercept = 2, linetype = "dotted", size = 0.5) 
  #geom_hline(yintercept = 3, linetype = "dotted", size = 0.5)



## =============================================================================
## Create Output Data Frame
## =============================================================================

## Train/Test, Date and Teams
output <- data.frame(matrix(NA, nrow = nrow(dat_raw), ncol = 10))
output[-row_predict, 1] <- "Training Set"
output[row_predict, 1] <- "Predictions"
output[, 2:4] <- dat_raw[, 1:3]

## Real Data
output[row_train, 5:7] <- dat_raw[row_train, c("RES_H", "RES_A", "DIFF")]

## Predictions (Previous)
output[row_train, 8:10] <- dat_raw[row_train, c("PRED_H", "PRED_A", "PRED_DIFF")]

## Predictions (Current)
output[row_predict, 8] <- round(apply(yy_HG[,-1:-2], 1, median), 2)
output[row_predict, 9] <- round(apply(yy_AG[,-1:-2], 1, median), 2)
output[row_predict, 10] <- round(apply(yy_DF[,-1:-2], 1, median), 2)

## Rename columns
colnames(output) <- c("Data", "Date", "Home", "Away", 
                      "Real_H", "Real_A", "Real_Df",
                      "Pred_H", "Pred_A", "Pred_Df")


## =============================================================================
## Create Output Data Frame
## =============================================================================

## Generate File Name
now <- Sys.time()
now <- gsub(":", "",now)
now <- gsub(" ", "_",now)
name_box <- paste0("./output/",now, "_boxplot.png")
name_dis <- paste0("./output/",now, "_dist.png")
name_tab <- paste0("./output/",now, "_summary.png")
name_pdf <- paste0("./output/",now, "_pred.pdf")

## Load Extra Fonts
suppressMessages(loadfonts())

## Define output size
row_max <- max(which(output$Data == "Predictions"))
pdf_w <- 10
pdf_h <- 14

## Print PDF
pdf(file = name_pdf, height = pdf_h, width = pdf_w,
    family = "Ubuntu", title = "WC2014 Predictions by Jo-fai Chow")

## Print Summary Table
grid.newpage()
g_table <- grid.table(output[1:row_max,], show.rownames = F)

## Print boxplot and density
grid.newpage()
pushViewport(viewport(layout = grid.layout(1000, 1000)))
vplayout <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)
print(g_boxplot, vp = vplayout(1:500, 1:1000))
print(g_density, vp = vplayout(501:1000, 1:1000))


## Close and save
dev.off()

if (Sys.info()[1] == "Linux") embed_fonts(name_pdf)
