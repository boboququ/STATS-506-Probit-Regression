setwd("/Users/royatalibova/Desktop/UMICH Classes/Stats 506/Group project")

# Obtain Women's labor force data: --------------------------------------------
mroz = read.csv('./mroz.csv')
mroz

variable=names(mroz)[-1]
description = c('Labor-force participation of the married white woman', 'Number of children younger than 6 years old', 'Number of children aged 6-18', 'Age in years', 'Wife`s college attendance', 'Husband`s college attendance', 'Log expected wage rate for women in the labor force', 'Family income without the wife`s income')
type = c('Categorical: 0/1', 'Positive integer', 'Positive integer', 'Positive integer', 'Categorical: 0/1', 'Categorical: 0/1', 'Numerical', 'Numerical')
var_sum = cbind(variable, description, type)