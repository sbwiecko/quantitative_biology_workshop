# ---
# data structure

myvec=c(1,5,6,223,5,16)
sort(myvec)
rev(myvec)
duplicated(myvec)
myvec[4]
sort(myvec)[4]


# ---
# coercion

multiples = c(6.5,TRUE,"apple")
typeof(multiples)
multi = c(17L, 16+4i, 84.2, FALSE)
typeof(multi)


# ---
# matrices

mymat=matrix(myvec,nrow=3)
tmat=t(mymat)
summat=mymat+mymat
summat[1,1]

prodmat=mymat %*% tmat # operator syntax
prodmat[3,1]


# ---
# Dimensionality and Heterogeneity
## Lists

test.list = list("cat", 23, FALSE, 3+2i)
test.list[[1]]
test.list[1] # returns a list that contains the indexed element
typeof(test.list[[3]])

## Dataframes
# ~list of equal length vectors

D = data.frame(x = 1:100, y = rnorm(100) , id = letters[1:2])
D$id # id is a factor with levels "a" and "b"
typeof(D[2])
# Indexing the dataframe, D with single brackets returns a list of y values
# Indexing with double brackets returns a numeric vector, as does using $
D$y
D[["y"]]
D["y"]

## subsetting
D.sub = subset(D, D$y>0)
subset(D, D$id == 'a')
