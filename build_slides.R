library(rmarkdown)

# can't figure out how to change the template any other way
output_format <- ioslides_presentation(
  template=normalizePath("templates/default.html"),
  css=normalizePath("templates/style.css")
)
#output_format$pandoc$args <- c(head(output_format$pandoc$args,-1), template_path)

#rmd_list <- list.files("content/slides", pattern="*.Rmd", full.names=TRUE)
rmd_list <- c("0000_introduction.Rmd", "0100_data_in_biology.Rmd")

for(rmd in rmd_list) {
  rmarkdown::render(
    paste0("content/slides/",rmd),
    output_dir="docs/slides",
    output_format=output_format
  )
}
