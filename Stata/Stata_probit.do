*Importing data 
import delimited https://vincentarelbundock.github.io/Rdatasets/csv/carData/Mroz.csv, clear
save mroz,replace
use mroz,clear
*List the first six rows 
list if v1<=6

*Change variables with values yes/no to 1/0
gen lfpart =1 if lfp == "yes"
replace lfpart =0 if lfp == "no"
gen wifec =1 if wc == "yes"
replace wifec =0 if wc == "no"
gen husbc =1 if hc == "yes"
replace husbc =0 if hc == "no"
drop lfp wc hc
rename lfpart lfp
rename wifec wc
rename husbc hc
*Get the summary of the data
summ

tab lfp wc
tab lfp k618
probit lfp k5 k618 age lwg inc i.wc i.hc
