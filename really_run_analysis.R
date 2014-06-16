# This file generates the files:
# "run_analysis.md"
# "Codebook.txt"
# "README.txt"

# It uses "analysis.Rmd" as input.
# It is not required for the assignment and nothing here should concern you.

library("knitr")

knit("analysis.Rmd", output="README.md")
purl("analysis.Rmd", output="Run_analysis.R")
