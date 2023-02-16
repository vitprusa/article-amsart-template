#!/bin/bash

# ENTER PROJECT NAME HERE
project_name=""

function compile_project {

pdflatex ${project_name}.tex
bibtex ${project_name}
pdflatex ${project_name}.tex
pdflatex ${project_name}.tex

mv ${project_name}.pdf ${project_name}-$(date +%Y-%m-%d).pdf

evince ${project_name}-$(date +%Y-%m-%d).pdf
}

function archive_project {
git archive -o ${project_name}-$(date +%Y-%m-%d-at-%H-%M-%S).zip HEAD
}

function upload_project {
    # GENERATE PPASSWORD PROTECTED PDF FILE AND UPLOAD IT
    # ADD PDF PASSWORD HERE
    pdftk ${project_name}.pdf output ${project_name}-lock.pdf user_pw #_PASSWORD_
    # ADD TARGET DIRECTORY
    scp ${project_name}-lock.pdf prusv@hill.karlin.mff.cuni.cz:public_html/download/gacr/${project_name}-$(date +%Y-%m-%d-at-%H-%M-%S)-lock.pdf
    rm ${project_name}-lock.pdf
}

function diff_visualization {
    # CHANGES VISUALISATION VIA LATEXDIFF, ALL INCLUDED LATEX FILES VIA \INPUT{} ARE ASSUMED TO BE STORED IN TEXT DIRECTORY AND NOWHERE ELSE
    # SPECIFY THE "OLD" MANUSCRIPT VERSION HERE
    history=1
    gitobject=HEAD~${history}
    # gitobject=v0.51
    # also show changes in the included LaTeX files \input{} 

    git show ${gitobject}:${project_name}.tex > ${project_name}-${gitobject}.tex
    latexdiff ${project_name}-${gitobject}.tex ${project_name}.tex  > ${project_name}-diff.tex
    
    # search text subdirectory for included files and do latexdiff for these files
    for sections in text/*.tex;
    do
	sections=$(echo ${sections} | sed -e "s/text\///")
	echo "Processing section ${sections}..."
	git show ${gitobject}:text/${sections} > text/${sections%%.tex}-${gitobject}.tex
	latexdiff text/${sections%%.tex}-${gitobject}.tex text/${sections}  > text/${sections%%.tex}-diff.tex
	rm text/${sections%%.tex}-${gitobject}.tex

	# change the name of the included file to its *-diff version
	sed -e "s/\\input{text\/${sections%%.tex}}/\\input{text\/${sections%%.tex}-diff}/" ${project_name}-diff.tex > ${project_name}.temp
	mv ${project_name}.temp ${project_name}-diff.tex
    done

    rm ${project_name}-${gitobject}.tex
}

compile_project
#upload_project
#archive_project

diff_visualization
project_name="${project_name}-diff"
compile_project
rm text/*-diff.tex
rm *-diff.{tex,aux,bbl,blg,log,dvi,out,ps}

rm ${project_name}.pdf
