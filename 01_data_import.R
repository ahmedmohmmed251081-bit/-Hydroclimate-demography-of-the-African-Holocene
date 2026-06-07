# 01_data_import.R
# Import and clean archaeological and proxy datasets

library(readxl)
library(dplyr)
library(tidyr)
library(zoo)

data_file <- "E.xlsx"

# Import sheets
proxy_raw <- read_excel(data_file, sheet = "Proxy", col_names = FALSE)
arch_raw  <- read_excel(data_file, sheet = "Archeology", col_names = FALSE)

# -------------------------------
# Archaeological data restructuring
# -------------------------------

region_names <- as.character(unlist(arch_raw[1, ]))
arch <- arch_raw[-1, ]
lon_cols <- which(arch[1, ] == "Lon")

arch_list <- list()

for(i in seq_along(lon_cols)){
  
  col_start <- lon_cols[i]
  region <- region_names[col_start]
  
  temp <- arch[-1, col_start:(col_start+3)]
  colnames(temp) <- c("Lon","Lat","Age","Error")
  temp$Region <- region
  
  arch_list[[i]] <- temp
}

arch_tidy <- bind_rows(arch_list) %>%
  mutate(
    Lon = as.numeric(Lon),
    Lat = as.numeric(Lat),
    Age = as.numeric(Age),
    Error = as.numeric(Error)
  ) %>%
  filter(!is.na(Lon), !is.na(Lat), !is.na(Age), !is.na(Error)) %>%
  filter(Age >= 0, Age <= 16000)

# -------------------------------
# Proxy data restructuring
# -------------------------------

region_row <- as.character(unlist(proxy_raw[1, ]))
site_row   <- as.character(unlist(proxy_raw[2, ]))
var_row    <- as.character(unlist(proxy_raw[3, ]))

region_row <- zoo::na.locf(region_row, na.rm = FALSE)

proxy_data <- proxy_raw[-c(1:3), ]
age_cols <- which(var_row == "Age")

proxy_list <- list()

for(i in seq_along(age_cols)){
  
  col_age <- age_cols[i]
  col_proxy <- col_age + 1
  
  temp <- proxy_data[, c(col_age, col_proxy)]
  colnames(temp) <- c("Age","Proxy")
  
  temp$Region <- region_row[col_age]
  temp$Site   <- site_row[col_age]
  
  proxy_list[[i]] <- temp
}

proxy_all <- bind_rows(proxy_list) %>%
  mutate(
    Age = as.numeric(Age),
    Proxy = as.numeric(Proxy)
  ) %>%
  filter(!is.na(Age), !is.na(Proxy)) %>%
  filter(Age >= 0, Age <= 16)

# Save objects for downstream scripts
save(arch_tidy, proxy_all, file = "01_imported_data.RData")
Add data import script
Commit new file
