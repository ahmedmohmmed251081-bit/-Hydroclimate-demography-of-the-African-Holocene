# 10_spatiotemporal_mapping.R
# Time-slice settlement mapping

library(dplyr)

load("02_calibrated_data.RData")

arch_corrected$Age_kyr <- arch_corrected$CalMedian / 1000

time_slices <- list(
  c(13.5,16),
  c(11,13.5),
  c(8.5,11),
  c(6,8.5),
  c(4.5,6),
  c(1,3.5)
)

for(slice in time_slices){
  
  slice_data <- arch_corrected %>%
    filter(Age_kyr >= slice[1] &
           Age_kyr <= slice[2])
  
  print(summary(slice_data))
}
