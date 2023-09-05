library(rmarkdown)

# can't figure out how to change the template any other way
output_format <- ioslides_presentation(
  template=normalizePath("templates/default.html"),
  css=normalizePath("templates/style.css")
)
#output_format$pandoc$args <- c(head(output_format$pandoc$args,-1), template_path)

#rmd_list <- list.files("content/slides", pattern="*.Rmd", full.names=TRUE)
rmd_list <-  c(
  "week_1_slides.Rmd"
)
c(
  "week_2_slides.Rmd",
  "week_3_slides.Rmd",
  "week_4_slides.Rmd",
  "week_5_slides.Rmd",
  "0000_introduction.Rmd",
  "0100_data_in_biology.Rmd",
  "0200_preliminaries.Rmd",
  "0300_r_programming.Rmd",
  "0400_data_wrangling.Rmd",
  "0500_data_sci.Rmd",
  "0600_data_viz.Rmd",
  "0700_bioinfo.Rmd",
  "0800_engineeRing.Rmd",
  "1000_communication.Rmd"
)

for(rmd in rmd_list) {
  rmarkdown::render(
    paste0("content/slides/",rmd),
    output_dir="docs/slides",
    output_format=output_format
  )
}
