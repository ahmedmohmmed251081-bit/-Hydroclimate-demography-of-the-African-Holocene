African Holocene Climate–Demography Analysis
This repository provides fully reproducible R scripts for modeling climate–settlement dynamics across African macro-regions during the Holocene. The analytical workflow integrates radiocarbon calibration, demographic reconstruction, generalized additive modeling, cross-correlation analysis, Random Forest validation, Hidden Markov modeling, chronological network construction, and spatiotemporal mapping.

Analytical Workflow
1. Data Import
a)	Load archaeological and proxy datasets from E.xlsx
b)	Restructure and clean raw data
c)	Standardize variables
2. Radiocarbon Calibration
a)	Hemispherically appropriate calibration
b)	IntCal20 for Northern Hemisphere samples
c)	SHCal20 for Southern Hemisphere samples
d)	Extraction of calibrated median ages
e)	Construction of corrected archaeological dataset
3. Proxy Processing and Site-Level Modeling
a)	Linear interpolation (for visualization only)
b)	Z-score standardization
c)	Penalized cubic regression splines (REML)
4. Summed Probability Density (SPDn)
a)	Site-based 100-year binning
b)	Regional normalized SPDs
c)	Demographic trajectory reconstruction
5. Cross-Correlation Analysis
a.	100-year binned climate and settlement series
b.	Detrending of standardized time series
c.	Lagged correlation assessment
6. Climate–Settlement GAM Modeling
a.	Regional nonlinear smoothing
b.	Confidence interval estimation
c.	Climate–demography relationship evaluation
7. Random Forest Modeling (Rolling Validation)
a.	Regional time-series modeling
b.	Expanding-window (rolling origin) cross-validation
c.	No chronological age predictor
d.	Performance metrics: R², RMSE, MAE
e.	Variable importance assessment
8. Hidden Markov Modeling
a.	Gaussian HMM applied to standardized settlement intensity
b.	Separate models per macro-region
c.	Model selection using AIC and BIC
d.	Robustness checks with alternative state numbers
e.	Sensitivity testing using 50-year binning
9. Chronological Network Analysis
a.	Regional mean calibrated ages
b.	Directed age-difference (AgeDiff) computation
c.	Geodesic centroid distances
d.	Inter-regional chronological gradients
10. Spatiotemporal Mapping
a.	Time-slice mapping of settlement distributions
b.	Calibrated median ages
c.	Holocene expansion and contraction visualization

R session information used for the analyses is provided in:
session_info.txt

Computational Transparency
AI-assisted tools were used exclusively for syntax debugging and code verification. All analytical decisions and statistical modeling steps were independently designed and manually verified.

License
MIT License

