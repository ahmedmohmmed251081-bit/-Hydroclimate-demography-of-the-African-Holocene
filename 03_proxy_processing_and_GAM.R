# 03_proxy_processing_and_gam.R
# Proxy interpolation and site-level GAM modeling

library(dplyr)
library(tidyr)
library(mgcv)

load("02_calibrated_data.RData")

# Interpolate proxies to 0.05 kyr grid (visualization only)
time_grid <- seq(0, 16, by = 0.05)

proxy_interp <- proxy_all %>%
  group_by(Region, Site) %>%
  arrange(Age) %>%
  summarise(
    Age_interp = list(time_grid),
    Proxy_interp = list(approx(Age, Proxy, xout = time_grid, rule = 2)$y),
    .groups = "drop"
  ) %>%
  unnest(cols = c(Age_interp, Proxy_interp)) %>%
  rename(Age = Age_interp,
         Proxy = Proxy_interp)

# Z-transform per site
proxy_interp <- proxy_interp %>%
  group_by(Site) %>%
  mutate(Proxy_z = scale(Proxy)[,1]) %>%
  ungroup()

# Example GAM fit (per site)
gam_results <- list()

for(s in unique(proxy_interp$Site)){
  temp <- proxy_interp %>% filter(Site == s)
  gam_model <- gam(Proxy_z ~ s(Age, bs = "cs"),
                   data = temp,
                   method = "REML")
  gam_results[[s]] <- summary(gam_model)
}

print(gam_results[[1]])
