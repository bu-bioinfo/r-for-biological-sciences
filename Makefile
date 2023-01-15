packages:
	Rscript install_R_packages.R
	
slides: packages
	Rscript build_slides.R	
	
book: packages
	Rscript build_bookdown.R
	
all: slides book