#!/bin/bash

#
# Prepare submission to arXiv
#

echo "******"
echo "Rename all *-eps-converted-to.pdf to *.pdf." 
echo "******"

# Dry run
#find ./ -name "*-eps-converted-to.pdf" -execdir rename -n 's/-eps-converted-to.pdf/.pdf/' '{}' \;

find ./ -name "*-eps-converted-to.pdf" -execdir rename 's/-eps-converted-to.pdf/.pdf/' '{}' \;


echo "******"
echo "Remove all *.gp, *.sh, *.fig, *.bak, *.tex files from directories with figures." 
echo "******"

cd figures

find ./ -name "*.gp" -execdir rm '{}' \;
find ./ -name "*.fig" -execdir rm '{}' \;
find ./ -name "*.bak" -execdir rm '{}' \;
find ./ -name "*.sh" -execdir rm '{}' \;
find ./ -name "*.csv" -execdir rm '{}' \;
find ./ -name "*.eps" -execdir rm '{}' \;
find ./ -name "*.tex" -execdir rm '{}' \;
find ./ -name "*.dat" -execdir rm '{}' \;

echo "******"
echo "Remove all empty directiories."
echo "******"

cd ..
find . -type d -empty -delete


echo "******"
echo "Remove *.png that are not used."
echo "******"

find ./figures -type f -a \! -name "*-crop.png"  -a \! -name "*.pdf"

