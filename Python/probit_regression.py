import pandas as pd
import statsmodels.api as sm
from sklearn.model_selection import train_test_split
from statsmodels.discrete.discrete_model import Probit


#Read Data

data = pd.read_table("MROZ.shd", delim_whitespace=True)

#look at head

print(data.head())

#confirm that there are 752 observations of 22 variables

print(data.shape)

#lets add some column names
#detailed legend can be found at
#http://www.econometrics.com/comdata/wooldridge/mrozD.text

data.columns =  ["inlf", "hours", "kidslt6", "kidsge6", "age", "educ", "wage", "repwage", "hushrs",
				"husage", "huseduc", "huswage", "faminc", "mtr", "motheduc", "fatheduc", "unem", "city", 
				"exper", "nwifeinc", "lwage", "expersq"]


data = data[pd.notnull(data['inlf'])]

#We will predict the binary variable infl (labor force in 1975) with the other variables in the data set

print("Printing Data Frame with Column Labels")
print(data.head())

Y = data["inlf"]
X = data.drop(["inlf"], 1)


#select data for training and testing

Xtrain, Xtest, Ytrain, Ytest = train_test_split(X, Y, test_size = 0.2, random_state = 0)

#print(Ytrain)

model = Probit(Ytrain, Xtrain)


if __name__ == "__main__":
	print("running probit regression")