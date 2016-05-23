---
title: "README.md"
author: "BCG"
date: "May 22, 2016"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:

This is the course project for the Getting and Cleaning Data section of the Data Science Specialization for Coursera. The R script, run_analysis.R, does the following:

    Downloads the dataset if it does not already exist into the working directory
    Loads the activity and feature info
    Loads both the training and test datasets, keeping only those columns which reflect a mean or standard deviation
    Loads the activity and subject data for each dataset, and merges those columns with the dataset
    Merges the two datasets
    Converts the activity and subject columns into factors
    Creates a tidy dataset that consists of the average (mean) value of each variable for each subject and activity pair.

The end result is shown in the file tidy.txt.