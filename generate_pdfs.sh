#!/bin/bash

for day in 1 2 3 4 5; do
  if [ -d "HolcombeGrammarSchool/Day${day}/Source" ]; then
    mkdir -p HolcombeGrammarSchool/Day${day}/Day${day}_PDFs/
    cd HolcombeGrammarSchool/Day${day}/Source/
    for file in *.tex; do
      base=$(basename "$file" .tex)
      newname="${base/Day${day}/Day ${day}}"
      latexmk -pdf -outdir=../Day${day}_PDFs/ -jobname="$newname" "$file"
    done
    cd ../../../
  else
    echo "Source directory for Day${day} does not exist, skipping."
  fi
done
