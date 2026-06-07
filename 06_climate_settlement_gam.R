# 06_climate_settlement_gam.R
# Regional GAM climate–settlement relationships

library(dplyr)
library(mgcv)

load("02_calibrated_data.RData")

gam_models <- list()

for(r in unique(arch_corrected$Region)){
  
  arch_r <- arch_corrected %>%
    filter(Region == r) %>%
    mutate(Bin100 = floor(CalMedian/100)*100) %>%
    group_by(Bin100) %>%
    summarise(SiteCount = n(), .groups="drop")
  
  if(nrow(arch_r) < 30) next
  
  arch_r$Z <- scale(arch_r$SiteCount)[,1]
  
  gam_model <- gam(Z ~ s(Bin100, bs="cs"),
                   data = arch_r,
                   method = "REML")
  
  gam_models[[r]] <- summary(gam_model)
}

print(gam_models[[1]])
