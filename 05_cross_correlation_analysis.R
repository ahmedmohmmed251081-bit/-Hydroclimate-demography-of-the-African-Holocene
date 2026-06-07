# 05_cross_correlation_analysis.R
# Detrended cross-correlation analysis

library(dplyr)

load("02_calibrated_data.RData")

ccf_results <- list()

for(r in unique(arch_corrected$Region)){
  
  arch_r <- arch_corrected %>%
    filter(Region == r) %>%
    mutate(Bin100 = floor(CalMedian/100)*100) %>%
    group_by(Bin100) %>%
    summarise(SiteCount = n(), .groups="drop")
  
  if(nrow(arch_r) < 30) next
  
  arch_r$Z <- scale(arch_r$SiteCount)[,1]
  
  arch_r$Z_detrended <- resid(lm(Z ~ Bin100, data = arch_r))
  
  ccf_out <- ccf(arch_r$Z_detrended,
                 arch_r$Z_detrended,
                 plot = FALSE)
  
  ccf_results[[r]] <- ccf_out
}

print(ccf_results[[1]])
