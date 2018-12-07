<<<<<<< HEAD
proc import datafile = 'C:\Users\lanshi\Desktop\Mroz.csv'
 out = work.mroz
 dbms = CSV
 ;
run;

proc means data=mroz;
 var k5 k618 age lwg inc;
run;

proc freq data=mroz;
 tables lfp wc hc lfp*wc lfp*hc;
run;

=======
/*Import the dataset.*/
proc import datafile = 'Mroz.csv' out=mroz;
/*Display the first 10 rows.*/
proc print data=mroz(obs=10);
run;

/*Transfer character form ("yes/no") variables (lfp, wc, hc) into binary form (0/1).*/
proc format;
	invalue L
		'yes'=1 'no'=0;
run;
data mroz;
	set mroz;
	lfp1 = input(lfp,L.);
	wc1 = input(wc,L.);
	hc1 = input(hc,L.);
run;
data mroz;
	set mroz (drop = lfp wc hc);
run;
data mroz;
	set mroz (rename=(lfp1=lfp hc1=hc wc1=wc));
run;
/*The transfered dataset*/
proc print data=mroz(obs=10);
run;

/*Data Summary*/
/*1.For non-binary variables*/
*within each group of lfp*;
proc means data=mroz;
	var k5 k618 age lwg inc;
 	class lfp;
run;
*overall*;
proc means data=mroz;
 	var k5 k618 age lwg inc;
run;

/*2.For binary variables*/
proc freq data=mroz;
 	tables lfp wc hc lfp*wc lfp*hc;
run;

/*Probit regression*/
>>>>>>> sas completed
proc logistic data=mroz descending;
  class lfp wc hc / param=ref ;
  model lfp = k5 k618 age lwg inc wc hc /link=probit;
run;

<<<<<<< HEAD
=======
/*Marginal effects*/
/*Marginal effects plot with 95%CI for wc, at means*/
* k5=0.238 k618=1.353 age=42.54 lwg=1.097 inc=20.13 hc=0.392*;
*In this plot, actually we only need the 2 points on the curve: where wc=0 and wc=1*;
proc logistic data=mroz descending plots=EFFECT;
  class lfp / param=ref ;
  model lfp = k5 k618 age lwg inc wc hc /link=probit;
  output out=estimated predicted=estprob l=lower95 u=upper95;
run;

/*Marginal effects plot with 95%CI for hc, at means*/
* k5=0.238 k618=1.353 age=42.56 lwg=1.097 inc=20.13 wc=0.282*;
*In this plot, actually we only need the 2 points on the curve: where hc=0 and hc=1*;
proc logistic data=mroz descending plots=EFFECT;
  class lfp / param=ref ;
  model lfp = k5 k618 age lwg inc wc hc /link=probit;
  output out=estimated predicted=estprob l=lower95 u=upper95;
run;

/*Marginal effects plot for wc*hc, at means*/
* k5=0.238 k618=1.353 age=42.56 lwg=1.097 inc=20.13*;
>>>>>>> sas completed
proc logistic data=mroz descending plots=EFFECT;
  class lfp wc hc / param=ref ;
  model lfp = k5 k618 age lwg inc wc hc /link=probit;
  output out=estimated predicted=estprob l=lower95 u=upper95;
run;

<<<<<<< HEAD
proc sgplot data=mroz;
 reg x=k5 y=lfp / CLM CLI;
 run;
=======
/*
proc sgplot data=mroz;
 reg x=k5 y=lfp / CLM CLI;
 run;
*/
>>>>>>> sas completed

