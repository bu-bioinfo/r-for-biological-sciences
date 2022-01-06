#!/usr/bin/bash
Help()
{
  echo "BF591 Autograding Script. Written by Taylor Falk (tfalk@bu.edu)"
  echo "Usage: ./run_all.sh students_dir/ assignment_name"
  echo "	-h --help Display this menu"
}

# Get the options
while getopts ":h" option; do
   case $option in
      h) # display Help
         Help
         exit;;
   esac
done

DIRECTORY=$1
ASSIGNMENT=$2

echo "The directory is ${1} and the assignment name is ${2}."

# scan all names in dir for assignment name, create CSV of missing/present
students=0
repos=0
statuscsv=${ASSIGNMENT}_status.csv
touch $statuscsv
echo "student_folder,folder_exists,test_exists" >> $statuscsv
for i in $DIRECTORY*/; do
  ((students++))
  gitfolder=false
  testfile=false
  if [ -d "${i}${ASSIGNMENT}" ]; then
    gitfolder=true
    ((repos++))
  fi
  [ -f "${i}${ASSIGNMENT}/test_main.R" ] && testfile=true
  echo "$i,$gitfolder,$testfile" >> $statuscsv 
done
echo "${students} student dirs found, ${repos} assignment repos found therein."

# run_test.R on each and pipe output to csv
module load R
module load pandoc
testcsv=${ASSIGNMENT}_tests.csv
touch $testcsv
echo "student_dir, test_result" >> tmp.csv
for i in $DIRECTORY*/; do
  if [ -f "${i}${ASSIGNMENT}/test_main.R" ]; then
    echo "Testing ${i}${ASSIGNMENT}/test_main.R..."
    echo "${i},"$(Rscript --vanilla run_test.R ${i}${ASSIGNMENT}/test_main.R) >> tmp.csv
  fi
done
sed -r "s/\x1B\[(([0-9]+)(;[0-9]+)*)?[m,K,H,f,J]//g" tmp.csv > $testcsv
rm tmp.csv

# Rmd script to parse these two CSVs and output an html file
Rscript -e "rmarkdown::render('markdown.Rmd',params=list(status='${statuscsv}', tests='${testcsv}'))"

