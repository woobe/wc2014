## =============================================================================
## WC 2014 Analysis and Predictions
## =============================================================================

## Initiate
setwd("/media/SUPPORT/Repo/wc2014")
suppressMessages(library(bib))
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

library(grid)
library(gridExtra)
library(EBImage)
library(ggplot2)
library(rPlotter)
library(extrafont) ## Note: Run font_import() if it has not been done yet


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
rng_train <- -2:-4 # for 13 June


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

ctrl <- trainControl(method = "boot",
                     number = 20)

activate_core(4)

for (n_round in 1:3) {
  
  ## Get y_train
  y_train <- dat[rng_train, (15+n_round)]
  
  ## List of Models
  lst_model <- c("svmRadial", "svmLinear", "rf", "superpc", "relaxo", "pcr", 
                 "penalized", "neuralnet", "lars", "lars2", "rvmRadial",
                 "rvmLinear", "foba", "icr", "ridge", "M5", "krlsRadial", 
                 "cubist", "spls", "pcaNNet", "nnet", "avNNet",
                 "glmboost", "xyf", "kknn", "gaussprRadial", "glmnet",
                 "earth", "dnn", "bayesglm", "RRFglobal",
                 "knn")
  
  ## Empty Shell
  tmp_yy <- matrix(NA, nrow = nrow(x_test), ncol = length(lst_model))
  
  ## Main Loop
  for (n_model in 1:length(lst_model)) {
    
    ## Display
    cat("Now training round", n_round, "model", n_model, lst_model[n_model], "...\n")
    
    ## Train caret model
    suppressWarnings(
      model <- train(x_train, y_train, trControl = ctrl, tuneLength = 5,
                     method = lst_model[n_model]))
    
    ## Use model
    tmp_yy[, n_model] <- predict(model, x_test)    
    
  }  
  
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

g_density <- ggplot(yy_all, aes(x = Goals, fill = Team)) + 
  geom_density() +
  facet_grid(Team ~ Match) +
  scale_fill_manual(name = "Team", values = c("#34B2CF", "#FCCB05", "#FB0101")) +
  theme(title = element_text(size = 18, vjust = 2),
        strip.text = element_text(size = 16),
        axis.text = element_text(size = 12),
        axis.title.y = element_text(vjust = 0.75),
        axis.title.x = element_text(vjust = -0.5),
        legend.text = element_text(size = 12)) +
  ggtitle("Distribution of Predicted Outcomes (Goals) for Each Team")

g_boxplot <- ggplot(yy_all, aes(x = Team, y = Goals, fill = Team)) + 
  geom_boxplot() +
  scale_fill_manual(name = "Team", values = c("#34B2CF", "#FCCB05", "#FB0101")) +
  facet_grid(~ Match)  +
  theme(title = element_text(size = 18, vjust = 2),
        strip.text = element_text(size = 16),
        axis.text = element_text(size = 12),
        axis.title.y = element_text(vjust = 0.75),
        axis.title.x = element_text(vjust = -0.5),
        legend.text = element_text(size = 12)) +
  ggtitle("Boxplots of Predicted Outcomes (Goals) for Each Team")


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
name_box <- paste0("./output/",now, "_boxplot.png")
name_dis <- paste0("./output/",now, "_dist.png")
name_tab <- paste0("./output/",now, "_summary.png")
name_pdf <- paste0("./output/",now, "_pred.pdf")

## Load Extra Fonts
suppressMessages(loadfonts())

## Define output size
row_max <- max(which(output$Data == "Predictions"))
pdf_w <- 12
pdf_h <- 12

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
