# 09_chronological_network_analysis.R
# Chronological connectivity network metrics

library(dplyr)

load("02_calibrated_data.RData")

region_summary <- arch_corrected %>%
  group_by(Region) %>%
  summarise(
    MeanCalAge = mean(CalMedian, na.rm=TRUE),
    MeanLon = mean(Lon, na.rm=TRUE),
    MeanLat = mean(Lat, na.rm=TRUE),
    .groups="drop"
  )

edges <- expand.grid(
  Source = region_summary$Region,
  Target = region_summary$Region
) %>%
  filter(Source != Target) %>%
  left_join(region_summary,
            by=c("Source"="Region")) %>%
  rename(SourceAge = MeanCalAge) %>%
  left_join(region_summary,
            by=c("Target"="Region")) %>%
  rename(TargetAge = MeanCalAge) %>%
  mutate(
    AgeDiff = TargetAge - SourceAge,
    AbsDiff = abs(AgeDiff)
  )

print(head(edges))
