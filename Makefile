packages:
	Rscript install_R_packages.R
	
all: packages
	Rscript build_bookdown.R
	
	
	