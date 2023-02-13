packages:
	Rscript install_R_packages.R
	
slides: packages
	Rscript build_slides.R	
	
detailed_schedule: packages
	Rscript generate_detailed_class_outlines.R
	
book: packages detailed_schedule
	Rscript build_bookdown.R
	
all: slides book