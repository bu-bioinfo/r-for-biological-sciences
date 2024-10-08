if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install(c("SummarizedExperiment","affydata","limma"), update=FALSE, ask=FALSE)
library(tidyverse)
library(patchwork)
library(limma)

source("setup_example_data.R")
