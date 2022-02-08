if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install(c("SummarizedExperiment","affydata"), update=FALSE, ask=FALSE)
library(tidyverse)
library(patchwork)
