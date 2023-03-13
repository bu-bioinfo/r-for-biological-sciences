# CRAN packages
#https://stackoverflow.com/questions/4090169/elegant-way-to-check-for-missing-packages-and-install-them
list.of.packages <- c(
  "tidyverse",
  "ggdendro",
  "dynamicTreeCut",
  "fastcluster",
  "WGCNA",
  "threejs",
  "kableExtra",
  "statip"
)
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, repos='http://cran.us.r-project.org')

# Bioconductor packages
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install(c("affy", "affydata", "hgu95av2cdf", "fgsea", "GO.db", "impute"))