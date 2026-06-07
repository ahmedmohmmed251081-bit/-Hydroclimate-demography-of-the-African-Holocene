# 08_hidden_markov_modeling.R
# Hidden Markov modeling with model selection

library(dplyr)
library(depmixS4)

load("02_calibrated_data.RData")

hmm_results <- data.frame()

for(r in unique(arch_corrected$Region)){
  
  settlement_r <- arch_corrected %>%
    filter(Region == r) %>%
    mutate(Bin100 = floor(CalMedian/100)*100) %>%
    group_by(Bin100) %>%
    summarise(SiteCount = n(), .groups="drop") %>%
    arrange(desc(Bin100))
  
  if(nrow(settlement_r) < 30) next
  
  settlement_r$Z <- scale(settlement_r$SiteCount)[,1]
  
  for(k in 2:4){
    
    model <- depmix(Z ~ 1,
                    data=settlement_r,
                    nstates=k,
                    family=gaussian())
    
    fit_model <- fit(model, verbose=FALSE)
    
    hmm_results <- rbind(
      hmm_results,
      data.frame(
        Region=r,
        States=k,
        BIC=BIC(fit_model)
      )
    )
  }
}

print(hmm_results)
