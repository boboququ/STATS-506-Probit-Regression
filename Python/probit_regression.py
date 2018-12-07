import pandas as pd
import numpy as np
import statsmodels.api as sm
import statsmodels.formula.api as smf
from sklearn.model_selection import train_test_split
from statsmodels.discrete.discrete_model import Probit


#Read Data

data = pd.read_csv('https://vincentarelbundock.github.io/Rdatasets/csv/carData/Mroz.csv')

#look at head

print(data.head())

print(data.shape)

#We will predict the binary variable infl (labor force in 1975) with the other variables in the data set

data = data.drop(data.columns[0], axis = 1)
data["lfp"] = data["lfp"] == "yes"
data["wc"] = data["wc"] == "yes"
data["hc"] = data["hc"] == "yes"

print(data.head())

print(data.describe())
Y = data["lfp"]
X = data.drop(["lfp"], 1)

#Transform into response and predictor variables

#add intercept term

print(Y.describe())
print(X.describe())

X = sm.add_constant(X)

model = Probit(Y, X.astype(float))
probit_model = model.fit()
print(probit_model.summary())

#get marginal effects

mfx = probit_model.get_margeff()
print(mfx.summary())

#use pandas to generate table

print(pd.crosstab(data["lfp"], data["hc"], margins = True))

#calculate adjusted predictions of lfp and two levels of wc variable keeping other variables at mean
#group by WC
hc_data0 = np.column_stack((
	1,
	np.mean(data["k5"]),
	np.mean(data["k618"]),
	np.mean(data["age"]),
	np.mean(data["wc"]),
	0,
	np.mean(data["lwg"]),
	np.mean(data["inc"])
	))

hc_data1 = np.column_stack((
	1,
	np.mean(data["k5"]),
	np.mean(data["k618"]),
	np.mean(data["age"]),
	np.mean(data["wc"]),
	1,
	np.mean(data["lwg"]),
	np.mean(data["inc"])
	))

print(probit_model.predict(hc_data0))
print(probit_model.predict(hc_data1))

#group by wc
print(pd.crosstab(data["lfp"], data["wc"], margins = True))

wc_data0 = np.column_stack((
	1,
	np.mean(data["k5"]),
	np.mean(data["k618"]),
	np.mean(data["age"]),
	0,
	np.mean(data["hc"]),
	np.mean(data["lwg"]),
	np.mean(data["inc"])
	))

wc_data1 = np.column_stack((
	1,
	np.mean(data["k5"]),
	np.mean(data["k618"]),
	np.mean(data["age"]),
	1,
	np.mean(data["hc"]),
	np.mean(data["lwg"]),
	np.mean(data["inc"])
	))

print(probit_model.predict(wc_data0))
print(probit_model.predict(wc_data1))

#group by wc and age


wc_data0 = np.column_stack((
	np.repeat(1,4),
	np.repeat(np.mean(data["k5"]),4),
	np.repeat(np.mean(data["k618"]), 4),
	(30,40,50,60),
	np.repeat(0,4),
	np.repeat(np.mean(data["hc"]),4),
	np.repeat(np.mean(data["lwg"]),4),
	np.repeat(np.mean(data["inc"]),4)
	))

wc_data1 = np.column_stack((
	np.repeat(1,4),
	np.repeat(np.mean(data["k5"]),4),
	np.repeat(np.mean(data["k618"]), 4),
	(30,40,50,60),
	np.repeat(1,4),
	np.repeat(np.mean(data["hc"]),4),
	np.repeat(np.mean(data["lwg"]),4),
	np.repeat(np.mean(data["inc"]),4)
))

print(probit_model.predict(wc_data0))
print(probit_model.predict(wc_data1))


#group by k5

print(pd.crosstab(data["lfp"], data["k5"], margins = True))

k5_data = np.column_stack((
	np.repeat(1,4),
	(0,1,2,3),
	np.repeat(np.mean(data["k618"]), 4),
	np.repeat(np.mean(data["age"]),4),
	np.repeat(np.mean(data["wc"]),4),
	np.repeat(np.mean(data["hc"]),4),
	np.repeat(np.mean(data["lwg"]),4),
	np.repeat(np.mean(data["inc"]),4)
	))

print(probit_model.predict(k5_data))

if __name__ == "__main__":
	print("running probit regression")