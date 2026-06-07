# 04_spd_analysis.R
# Regional SPDn computation

library(dplyr)
library(rcarbon)

load("02_calibrated_data.RData")

regions_5 <- c(
  "Western Sahara–Mauritania margin",
  "East African Rift–Horn",
  "Northern Sahara–Maghreb",
  "Central Sahara–Sahel",
  "West central tropical Africa"
)

spd_list <- list()

for(r in regions_5){
  
  region_data <- arch_corrected %>%
    filter(Region == r)
  
  cal_curve <- ifelse(mean(region_data$Lat) >= 0,
                      "intcal20", "shcal20")
  
  cal_r <- calibrate(
    x = region_data$Age,
    errors = region_data$Error,
    calCurves = cal_curve
  )
  
  bins_r <- binPrep(
    sites = paste(region_data$Lon, region_data$Lat),
    ages = region_data$Age,
    h = 100
  )
  
  spd_r <- spd(cal_r,
               bins = bins_r,
               timeRange = c(16000, 0),
               spdnormalised = TRUE)
  
  spd_list[[r]] <- spd_r
}

print(spd_list[[1]])
