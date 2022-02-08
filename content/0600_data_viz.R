library(tidyverse)

set.seed(1337)
imgsize <- 400**2
ad_metadata <- tibble(
  ID=c(vapply(1:10,function(x) { str_c('A',x)},'a'), vapply(1:10,function(x) { str_c('C',x)},'a')),
  condition=as.factor(c(rep('AD',10),rep('Control',10))),
  tau=c(round(runif(10,0.2,0.9)*imgsize),round(runif(10,0.0,0.4)*imgsize)),
  abeta=round(tau+tau*rnorm(20,0,0.8)),
  iba1=round(tau+tau*rnorm(20,0,0.5)),
  gfap=c(round(runif(10,0.1,0.9)*imgsize),round(runif(10,0.1,0.9)*imgsize)),
  braak_stage=round((tau - min(tau))/(max(tau)-min(tau))*6),
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
readr::write_tsv(ad_metadata,"ad_metadata.tsv")