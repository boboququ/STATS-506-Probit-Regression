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


# print(Y)
#print(Y.dtypes)
# #can drop from tabled based on column name

#print(X.dtypes)

# X = X.drop(X.columns[0], axis = 1)

# print("y types:")
# print(Y.dtypes)
# print("x types:")
# print(X.dtypes)

#describe X and Y

print(Y.describe())
print(X.describe())

# X["k5"] = X["k5"].astype('float')
# X["k618"] = X["k618"].astype('float')
# X["age"] = X["age"].astype('float')

# Y = Y == "yes"
# print(Y)

#select data for training and testing

# Xtrain, Xtest, Ytrain, Ytest = train_test_split(X, Y, test_size = 0.2, random_state = 0)

# print(Ytrain)
# print(Xtrain)
# print(Xtrain.dtypes)
# print(Ytrain.dtypes)


model = Probit(Y, X.astype(float))
result = model.fit()
print(result.summary())


if __name__ == "__main__":
	print("running probit regression")