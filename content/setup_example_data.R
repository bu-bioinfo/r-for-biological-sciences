library(tidyverse)
library(SummarizedExperiment)

set.seed(1337)

imgsize <- 400 ** 2
ad_metadata <- tibble(
  ID=c(str_c('A',1:10),str_c('C',1:10)),
  condition=as.factor(c(rep('AD',10),rep('Control',10))),
  tau=c(round(runif(10,0.2,0.9)*imgsize),round(runif(10,0.0,0.4)*imgsize)),
  abeta=round(tau+tau*rnorm(20,0,0.8)),
  iba1=round(tau+tau*rnorm(20,0,0.5)),
  gfap=c(round(runif(10,0.1,0.9)*imgsize),round(runif(10,0.1,0.9)*imgsize)),
  braak_stage=as.factor(round((tau - min(tau))/(max(tau)-min(tau))*6)),
  age_at_death=round(rnorm(20,mean=75,sd=5))+round((tau - min(tau))/(max(tau)-min(tau))*10)-2
) %>% dplyr::select(
    ID,
    age_at_death,
    condition,
    tau,
    abeta,
    iba1,
    gfap,
    braak_stage
)
ad_metadata[ad_metadata<0] <- 0

# relevel condition so Control is the reference class
ad_metadata$condition <- relevel(ad_metadata$condition, ref="Control")
library(here)
print(here())
readr::write_tsv(ad_metadata,"ad_metadata.tsv")
  

# intensities
intensities <- read_delim("example_intensity_data.csv", delim=" ") %>%
  dplyr::select(1:(nrow(ad_metadata)+1))

colnames(intensities) <- c("probeset_id",ad_metadata$ID)
intensities


# summarized experiment
exprs <- as.data.frame(dplyr::select(intensities,-c(probeset_id)))
rownames(exprs) <- intensities$probeset_id

ad_se <- SummarizedExperiment(
  assays=list(intensities=exprs),
  colData=ad_metadata,
  rowData=list(probeset_id=intensities$probeset_id)
)