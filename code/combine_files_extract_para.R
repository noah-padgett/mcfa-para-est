# ============================================= #
#      ML-CFA Parameter Recovery Project  
#             Padgett & Morgan               
# ============================================= #
# Data Created: 2019-06-14
# Date Modified: 2019-06-14
# By: R. Noah Padgett                   
# ============================================= #
# ============================================= #
# Purpose:
# This R script is for extracting the parameter
#   estimates and the summary information from 
#   all 15 results files
#   to create one parsed down data file with
#   with the fit information and identification
#   information.
#
# The output will be a single file that I 
#   will use for all data analyses.
# ============================================= #

library(dplyr)

## Variables to extract from simulation
var.names <- c(
    'Condition', 'Replication',
    'Model', 'Estimator', 'Converge', 'Admissible', 'chisqu_value', 'chisqu_df', 
    'chisqu_pvalue', 'CFI', 'TLI', 'RMSEA', 'SRMRW', 'SRMRB',
    "lambda11", "lambda12", "lambda13", "lambda14", "lambda15", "lambda16", 
    "lambda26", "lambda27", "lambda28", "lambda29", "lambda210", 
    "thetaW1", "thetaW2", "thetaW3", "thetaW4", "thetaW5", 
    "thetaW6", "thetaW7", "thetaW8", "thetaW9", "thetaW10", 
    "psiW12", 
    "nu1", "nu2", "nu3", "nu4", "nu5", "nu6", "nu7", "nu8", "nu9", "nu10", 
    "thetaB1", "thetaB2", "thetaB3", "thetaB4", 
    "thetaB5", "thetaB6", "thetaB7", "thetaB8", "thetaB9", "thetaB10", 
    "psiB1", "psiB12", "psiB2", 
    "tau11", "tau12", "tau13", "tau14", "tau21", "tau22", "tau23", "tau24", 
    "tau31", "tau32", "tau33", "tau34", "tau41", "tau42", "tau43", "tau44", 
    "tau51", "tau52", "tau53", "tau54", "tau61", "tau62", "tau63", "tau64", 
    "tau71", "tau72", "tau73", "tau74", "tau81", "tau82", "tau83", "tau84", 
    "tau91", "tau92", "tau93", "tau94", "tau101", "tau102", "tau103", "tau104",
    
    "selambda11", "selambda12", "selambda13", "selambda14", 
    "selambda15", "selambda16", "selambda26", "selambda27", "selambda28", 
    "selambda29", "selambda210", "sethetaW1", "sethetaW2", "sethetaW3", 
    "sethetaW4", "sethetaW5", "sethetaW6", "sethetaW7", "sethetaW8", "sethetaW9", 
    "sethetaW10", "sepsiW12", "senu1", "senu2", "senu3", "senu4", "senu5", 
    "senu6", "senu7", "senu8", "senu9", "senu10", "sethetaB1", "sethetaB2", 
    "sethetaB3", "sethetaB4", "sethetaB5", "sethetaB6", "sethetaB7", "sethetaB8", 
    "sethetaB9", "sethetaB10", "sepsiB1", "sepsiB12", "sepsiB2",
    "setau11", "setau12", "setau13", "setau14", "setau21", "setau22", "setau23", 
    "setau24", "setau31", "setau32", "setau33", "setau34", "setau41", "setau42", 
    "setau43", "setau44", "setau51", "setau52", "setau53", "setau54", "setau61", 
    "setau62", "setau63", "setau64", "setau71", "setau72", "setau73", "setau74", 
    "setau81", "setau82", "setau83", "setau84", "setau91", "setau92", "setau93", 
    "setau94", "setau101", "setau102", "setau103", "setau104")
    
## initialize dataframe (helps with speed i think)
mydata <- as.data.frame(matrix(NA, ncol=length(var.names)))
colnames(mydata) <- var.names
#mydata$Model <- as.factor(mydata$Model)
#mydata$Estimator <- as.factor(mydata$Estimator)
## Set up iterations
EST <- c('MLR', 'ULSMV', 'WLSMV')
MOD <- c('C')
CON <- c('1t18', '19t36', '37t54', '55t71', '72')

## Run loop to extract and combine data into one file
for(est in EST){
  for(m in MOD){
    for(c in CON){
      ## Read in specified data file
      dat <- read.table(
        paste0('Results/output_results_',est,'_',m,'_Con',c,'.txt'),
        header = T, sep = "\t", fill= T
      )
      ## ~~ 
      ## subset to the variables of interest 
      dat <- dat[, colnames(dat) %in% var.names]
      ## merge data into one dataset 
      mydata <- merge(mydata, dat, all=T)
      cat('.')
    } ## End conditions
  } ## End Model specification
} ## End Estimator
mydata <- mydata[-108001, ]
mydata <- mydata[, var.names]

## Write out Results text file
write.table( x = mydata,
             file = paste0('Results/compiled_parameter_results.txt'),
             sep = '\t',row.names = F
) ## End write data.table
