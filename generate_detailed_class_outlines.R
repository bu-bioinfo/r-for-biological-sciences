# the detailed course schedule is generated from detailed_schedule.csv

library(kableExtra)
library(tidyverse)

sink("content/detailed_class_outlines.Rmd")

cat("---\n",  append=F)
cat("output: html_document\n")
cat("---\n\n")

cat("# Detailed Class Schedule\n\n")


# change these to the semester dates
lecture_dates <- c(
  "1/23",
  "1/25",
  "1/30",
  "2/1",
  "2/6",
  "2/8",
  "2/13",
  "2/15",
  "2/21",
  "2/22",
  "2/27",
  "3/1",
  "3/13",
  "3/15",
  "3/20",
  "3/22",
  "3/27",
  "3/29",
  "4/3",
  "4/5",
  "4/10",
  "4/12",
  "4/19",
  "4/24",
  "4/26",
  "5/1",
  "5/3"
)

sched <- readr::read_csv("detailed_schedule.csv")

#tibble [1 × 8] (S3: tbl_df/tbl/data.frame)
# $ Lecture No        : num 1
# $ Topic             : chr NA
# $ Section           : chr "Course Intro & Details"
# $ Book Page         : chr NA
# $ Book Section      : chr NA
# $ Slides Link       : chr NA
# $ Slides Section    : chr NA
# $ Weekly Slides Link: logi NA

dplyr::group_by(sched, Week) %>%
  dplyr::group_map(function(g, x) {
    cat(str_c("## Week ",x$Week,"\n\n"))
    cat(str_c("[Week ",x$Week," slides](slides/week_",x$Week,"_slides.html)\n\n"))
    
    cat(str_c("|Lecture|Date|Topic|Section|Slides|\n"))
    cat(str_c("|-------|----|-----|-------|------|\n"))
    
    dplyr::group_by(g, row_number()) %>%
      dplyr::group_map(function(r, x1){
        r <- c(
          r$`Lecture No`,
          lecture_dates[r$`Lecture No`],
          r$Topic,
          str_c("[",r$Section,"]"),
          if(is.na(r$`Slides Link`)) ""
          else str_c("[slides](slides/",r$`Slides Link`,"#",r$`Slides Section`,")")
        )
        cat(paste0("| ", r))
        cat(" |\n")
      })
    cat("\n\n")
  })
sink()