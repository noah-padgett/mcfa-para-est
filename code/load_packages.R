# ============================================= #
# script: load_packages.R
# Project: ML-CFA Parameter Recovery
# Author(s): R.N. Padgett & G.B. Morgan           
# ============================================= #
# Data Created: 2019-10-16
# Date Modified: 2019-10-16
# By: R. Noah Padgett                   
# ============================================= #
# Stems from Padgett's MA thesis                   
# ============================================= #
# Purpose:
# This R script is for loading all necessary
#   R packages
#
# No output - just loading packages into the 
#   environment
# ============================================= #
# Set up directory and libraries
rm(list=ls())
# list of packages
packages <- c("tidyverse", "readr", "patchwork",
              "tidyr","data.table", "dplyr","ggplot2",
              "MplusAutomation", "cowplot",
              "kableExtra", "xtable")   
new.packages <- packages[!(packages %in% installed.packages()[,"Package"])] 
if(length(new.packages)) install.packages(new.packages) 
# Load packages
lapply(packages, library, character.only = TRUE)

w.d <- getwd()

