## Stats 506 Homework 1
##
## The Mroz Data used in this script can be found at the link below: 
##  https://vincentarelbundock.github.io/Rdatasets/datasets.html
##
## Author: Roya Talibova (talibova@umich.edu)
## Updated: December 6, 2018

# 80: -------------------------------------------------------------------------


# Libraries: ------------------------------------------------------------------
#install.packages(c("effects", "tidyverse"))
library(effects)
library(ggplot2)

##Set the working directory
setwd("/Users/royatalibova/Desktop/UMICH Classes/Stats 506/Group project")

# Obtain Women's labor force data: --------------------------------------------
mroz = read.csv('./mroz.csv')
mroz

# Explore the data: -----------------------------------------------------------
head(mroz)


# Change the values of some variables -----------------------------------------
mroz$lfp = ifelse(mroz$lfp=="yes", 1, 0)
mroz$lfp
mroz$wc = ifelse(mroz$wc=="yes", 1, 0)
mroz$wc
mroz$hc = ifelse(mroz$hc=="yes", 1, 0)
mroz$hc

# Run the probit regression ---------------------------------------------------
mroz.probit <- glm(lfp ~ k5 + k618 + age + wc + hc + lwg + inc, 
                  data = mroz,
                  family = binomial(link = "probit"))
summary(mroz.probit)

# Check the confidence intervals ----------------------------------------------
confint(mroz.probit)

## Frequency tables and adjusted predictions of lfp for two levels of hc variable
addmargins(table(mroz$lfp, mroz$hc, deparse.level=2))

hc_data0 = data.frame(k5 = mean(mroz$k5), k618 = mean(mroz$k618), age=mean(mroz$age), 
                      lwg= mean(mroz$lwg), inc=mean(mroz$inc), hc=0, wc=mean(mroz$wc))
hc_data1 = data.frame(k5 = mean(mroz$k5), k618 = mean(mroz$k618), age=mean(mroz$age), 
                      lwg= mean(mroz$lwg), inc=mean(mroz$inc), hc=1, wc=mean(mroz$wc))

h0 = predict(mroz.probit, hc_data0, type="response", se=TRUE)
h1 = predict(mroz.probit, hc_data1, type="response", se=TRUE)

hc_fit = data.frame(Margin = c(h0$fit[1], h1$fit[1]), se=c(h0$se.fit[1], h1$se.fit[1]))
hc_fit

## Frequency tables and adjusted predictions of lfp for two levels of wc variable
addmargins(table(mroz$lfp, mroz$wc, deparse.level=2))

wc_data0 = data.frame(k5 = mean(mroz$k5), k618 = mean(mroz$k618), age=mean(mroz$age), 
                      lwg= mean(mroz$lwg), inc=mean(mroz$inc), hc = mean(mroz$hc), wc=0)
wc_data1 = data.frame(k5 = mean(mroz$k5), k618 = mean(mroz$k618), age=mean(mroz$age), 
                      lwg= mean(mroz$lwg), inc=mean(mroz$inc), hc = mean(mroz$hc), wc=1)

w0 = predict(mroz.probit, wc_data0, type="response", se=TRUE)
w1 = predict(mroz.probit, wc_data1, type="response", se=TRUE)

wc_fit = data.frame(Margin = c(w0$fit[1], w1$fit[1]), se=c(w0$se.fit[1], w1$se.fit[1]))
wc_fit

##Grouped by age and wc
wc_data0_age=data.frame(k5=rep(mean(mroz$k5), 4), k618=rep(mean(mroz$k618), 4), 
                        age=c(30, 40, 50, 60), lwg=rep(mean(mroz$lwg), 4), 
                        inc=rep(mean(mroz$inc), 4), wc=rep(0, 4), 
                        hc=rep(mean(mroz$hc), 4))

wc_data1_age=data.frame(k5=rep(mean(mroz$k5), 4), k618=rep(mean(mroz$k618), 4), 
                        age=c(30, 40, 50, 60), lwg=rep(mean(mroz$lwg), 4), 
                        inc=rep(mean(mroz$inc), 4), wc=rep(1, 4), 
                        hc=rep(mean(mroz$hc), 4))

m0=predict(mroz.probit, wc_data0_age, type="response", se=TRUE)
m1=predict(mroz.probit, wc_data1_age, type="response", se=TRUE)

wc_fit_age = data.frame(Margin_wc0=m0$fit, Margin_wc1=m1$fit, se_wc0=m0$se.fit, se_wc1=m1$se.fit)
wc_fit_age

##Grouped by K5
addmargins(table(mroz$lfp, mroz$k5, deparse.level=2))
k_data=data.frame(k5=c(0,1,2,3), k618=rep(mean(mroz$k618), 4), age=rep(mean(mroz$age), 4), 
                  lwg=rep(mean(mroz$lwg), 4), inc=rep(mean(mroz$inc), 4), 
                  wc = rep(mean(mroz$wc), 4), hc=rep(mean(mroz$hc), 4))

k0=predict(mroz.probit, k_data, type="response", se=TRUE)

k_fit = data.frame(Margin_k=k0$fit, se_k=k0$se.fit)
k_fit

##Marginal plots
Age=c(30, 40, 50, 60)
ggplot(data=wc_fit_age,aes(y=Age)) +
  geom_line(aes( x= Margin_wc0), colour="blue") +
  geom_errorbarh(aes(xmin=Margin_wc0-2*se_wc0, xmax=Margin_wc0+2*se_wc0), height=.1,colour="blue")+
  geom_line(aes(x = Margin_wc1), colour="red")+
  geom_errorbarh(aes(xmin=Margin_wc1-2*se_wc1, xmax=Margin_wc1+2*se_wc1),
                 height=.1,colour="red")+
  coord_flip()+xlab('Probability(Lfp)') +
  ylab("Age")

##Plot the marginal effects ------------------------------------------------------------

all.effects <- allEffects(mod = mroz.probit)
plot(all.effects, type="response", ylim=c(0,1))

