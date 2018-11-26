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

proc logistic data=mroz descending;
  class lfp wc hc / param=ref ;
  model lfp = k5 k618 age lwg inc wc hc /link=probit;
run;

proc logistic data=mroz descending plots=EFFECT;
  class lfp wc hc / param=ref ;
  model lfp = k5 k618 age lwg inc wc hc /link=probit;
  output out=estimated predicted=estprob l=lower95 u=upper95;
run;

proc sgplot data=mroz;
 reg x=k5 y=lfp / CLM CLI;
 run;

