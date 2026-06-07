# 07_random_forest_rolling_validation.R
# Rolling Random Forest validation (regional)

library(dplyr)
library(randomForest)

load("02_calibrated_data.RData")

regions_5 <- c(
  "Western Sahara–Mauritania margin",
  "East African Rift–Horn",
  "Northern Sahara–Maghreb",
  "Central Sahara–Sahel",
  "West central tropical Africa"
)

rf_predictions <- data.frame()

for(r in regions_5){
  
  arch_r <- arch_corrected %>%
    filter(Region == r) %>%
    mutate(Bin100 = floor(CalMedian/100)*100) %>%
    group_by(Bin100) %>%
    summarise(SiteCount = n(), .groups="drop") %>%
    arrange(desc(Bin100))
  
  if(nrow(arch_r) < 30) next
  
  arch_r$Z <- scale(arch_r$SiteCount)[,1]
  
  n_total <- nrow(arch_r)
  start_train <- floor(0.5*n_total)
  
  for(i in start_train:(n_total-1)){
    
    train_set <- arch_r[1:i,]
    test_set  <- arch_r[i+1,,drop=FALSE]
    
    rf_model <- randomForest(Z ~ Bin100,
                             data=train_set,
                             ntree=500)
    
    pred <- predict(rf_model,newdata=test_set)
    
    rf_predictions <- rbind(
      rf_predictions,
      data.frame(
        Observed=test_set$Z,
        Predicted=pred,
        Region=r
      )
    )
  }
}

print(head(rf_predictions))
