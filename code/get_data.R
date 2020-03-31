# ============================================= #
# script: get_data.R
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
# This R script is for loading and formating 
#   the data file for use in analyses.
#
# The output is a data.frame (tibble) object
# ============================================= #


sim_results <- as_tibble(read.table('data/compiled_para_results.txt', header=T,sep='\t'))

## Next, turn condition into a factor for plotting
sim_results$Condition <- as.factor(sim_results$Condition)

## level-1 Sample size
ss_l1 <- c(5, 10, 30) ## 6 conditions each
ss_l2 <- c(30, 50, 100, 200) ## 18 condition each
icc_ov <- c(.1, .3, .5) ## 2 conditions each
icc_lv <- c(.1, .5) ## every other condition
nCon <- 72 # number of conditions
nRep <- 500 # number of replications per condition
nMod <- 3 ## numberof estimated models per conditions
## Total number of rows: 108,000
ss_l2 <- c(rep(ss_l2[1], 18*nRep*nMod), rep(ss_l2[2], 18*nRep*nMod), 
           rep(ss_l2[3], 18*nRep*nMod), rep(ss_l2[4], 18*nRep*nMod))
ss_l1 <- rep(c(rep(ss_l1[1],6*nRep*nMod), rep(ss_l1[2],6*nRep*nMod), rep(ss_l1[3],6*nRep*nMod)), 4)
icc_ov <- rep(c(rep(icc_ov[1], 2*nRep*nMod), rep(icc_ov[2], 2*nRep*nMod), rep(icc_ov[3], 2*nRep*nMod)), 12)
icc_lv <- rep(c(rep(icc_lv[1], nRep*nMod), rep(icc_lv[2], nRep*nMod)), 36)
## Force these vectors to be column vectors
ss_l1 <- matrix(ss_l1, ncol=1)
ss_l2 <- matrix(ss_l2, ncol=1)
icc_ov <- matrix(icc_ov, ncol=1)
icc_lv <- matrix(icc_lv, ncol=1)
## Add the labels to the results data frame
sim_results <- sim_results[order(sim_results$Condition),]
sim_results <- cbind(sim_results, ss_l1, ss_l2, icc_ov, icc_lv)

## Set up iterators for remainder of script
ests <- c('MLR', 'ULSMV', 'WLSMV')

# Add in true parameter values
## Loadings (0.6) forall conditions
sim_results$lambdaT <- 0.6
## level-1 factor covariance
sim_results$psiW12T <- 0.3
## level-2 factor (co)variance
lv_var <- c(.111, 1)
sim_results$psiB1T <- rep(c(rep(lv_var[1], nRep*nMod), rep(lv_var[2], nRep*nMod)), 36)
sim_results$psiB2T <- rep(c(rep(lv_var[1], nRep*nMod), rep(lv_var[2], nRep*nMod)), 36)
lv_cov <- c(.0333, .3)
sim_results$psiB12T <- rep(c(rep(lv_cov[1], nRep*nMod), rep(lv_cov[2], nRep*nMod)), 36)
## level-2 observed variable residual variance 
ob_var <- c(.111, .43, 1 )
sim_results$thetaBT <- rep(c(rep(ob_var[1], 2*nRep*nMod), rep(ob_var[2], 2*nRep*nMod), rep(ob_var[3], 2*nRep*nMod)), 12)

# Compute ICC estimates
# latent variables
sim_results$icc_lv1_est <- sim_results$psiB1/(sim_results$psiB1+1)
sim_results$icc_lv2_est <- sim_results$psiB2/(sim_results$psiB2+1)
#observed variables
i <- 1
for(i in 1:10){
  varb <- paste0('thetaB',i)
  varw <- paste0('thetaW',i)
  
  icc_est <- ifelse(sim_results$Estimator=="MLR", 
                    sim_results[, varb]/( sim_results[, varb] + sim_results[, varw]),
                    sim_results[, varb]/( sim_results[, varb] + 1))
  
  sim_results$icc_est <- icc_est
  colnames(sim_results)[ncol(sim_results)] <- paste0('icc_ov', i,'_est')
}

# remove unnecessary items
remove(lv_var, lv_cov, ob_var, icc_lv, icc_ov, ss_l1,ss_l2, nCon, nMod, nRep, new.packages, packages)
