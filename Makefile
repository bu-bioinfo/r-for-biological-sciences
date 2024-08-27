slides: 
	Rscript build_slides.R	
	
detailed_schedule: 
	Rscript generate_detailed_class_outlines.R
	
book: detailed_schedule
	Rscript build_bookdown.R
	
all: slides book
