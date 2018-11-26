## Stats 506 Homework 1
##
## The Mroz Data used in this script can be found at the link below: 
##  https://vincentarelbundock.github.io/Rdatasets/datasets.html
##
## Author: Roya Talibova (talibova@umich.edu)
## Updated: November 27, 2018

# 80: -------------------------------------------------------------------------


# Libraries: ------------------------------------------------------------------
#install.packages(c("effects", "tidyverse"))
library(effects)

##Set the working directory
setwd("/Users/royatalibova/Desktop/UMICH Classes/Stats 506/Group project")

# Obtain Women's labor force data: --------------------------------------------
mroz = read.csv('./mroz.csv')

# Explore the data: -----------------------------------------------------------
head(mroz)
summary(mroz)
names(mroz)

# Change the values of some variables -----------------------------------------
mroz$lfp = ifelse(mroz$lfp=="yes", 1, 0)
mroz$lfp
mroz$wc = ifelse(mroz$wc=="yes", 1, 0)
mroz$wc
mroz$hc = ifelse(mroz$hc=="yes", 1, 0)
mroz$hc

# Factorize some variables ----------------------------------------------------
mroz$lfp = factor(mroz$lfp)
mroz$wc = factor(mroz$wc)
mroz$hc = factor(mroz$hc)

# Run the probit regression ---------------------------------------------------
mroz.probit <- glm(lfp ~ k5 + k618 + age + wc + hc + lwg + inc, 
                  data = mroz,
                  family = binomial(link = "probit"))
summary(mroz.probit)

# Check the confidence intervals ----------------------------------------------
confint(mroz.probit)

# Plot the effects ------------------------------------------------------------
plot(age ~ inc, data = mroz,
     xlab = "Income (in USD 1000)",
     ylab = "Age")

all.effects <- allEffects(mod = mroz.probit)
plot(all.effects, type="response", ylim=c(0,1))
