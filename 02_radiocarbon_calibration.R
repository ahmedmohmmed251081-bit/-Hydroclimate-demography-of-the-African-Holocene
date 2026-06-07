# 02_radiocarbon_calibration.R
# Hemispherically appropriate radiocarbon calibration

library(dplyr)
library(rcarbon)

# Load imported data
load("01_imported_data.RData")

# Separate by hemisphere
north_data <- arch_tidy %>% filter(Lat >= 0)
south_data <- arch_tidy %>% filter(Lat < 0)

# Calibrate Northern Hemisphere samples
cal_north <- calibrate(
  x = north_data$Age,
  errors = north_data$Error,
  calCurves = "intcal20",
  ids = paste0("N_", 1:nrow(north_data))
)

# Calibrate Southern Hemisphere samples
cal_south <- calibrate(
  x = south_data$Age,
  errors = south_data$Error,
  calCurves = "shcal20",
  ids = paste0("S_", 1:nrow(south_data))
)

# Extract calibrated medians
north_data$CalMedian <- medCal(cal_north)
south_data$CalMedian <- medCal(cal_south)

# Combine corrected dataset
arch_corrected <- bind_rows(north_data, south_data)

# Save for downstream analyses
save(arch_corrected, proxy_all,
     file = "02_calibrated_data.RData")
