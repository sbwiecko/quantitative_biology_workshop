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

# ---
# Generating data and ploting

y = rnorm(25)
plot(y)

head(y)

x = 1:25
x

hist(y)


# ---
# Descriptive statistics
## mean

y
sum(y) / 25
mean(y)

## ploting the average
hist(y)
abline(v=mean(y), col="red")

y = rnorm(25)
plot(y, ylab="y-axis label goes here")
abline(h=mean(y), col="green")

## variation
sd(y)

sdabove = mean(y)+sd(y)
sdbelow = mean(y)-sd(y)
abline(h=sdabove, col="orange")
abline(h=sdbelow, col="orange")

y=rnorm(1000)
plot(y, ylab="y-axis label goes here")
sdabove = mean(y)+sd(y)
sdbelow = mean(y)-sd(y)
abline(h=sdabove, col="orange")
abline(h=sdbelow, col="orange")


source('qbwRModule.R') # first open folder working directory at source
count(y, sdbelow, sdabove)
count(y, sdbelow, sdabove)/1000



# In matrices, we use apply() in the general format:
# apply(matrix_name, margin, function)
# Where the margin specifies whether the function is applied to rows or columns.
#
# In dataframes, we use tapply() in the general format:
# tapply(object_name, index, function)
# Where the object is often a vector (like a column in a dataframe),
# the index specifies as the grouping variable of that object, and
# the function is applied to the object split by the index.

mymat.means = apply(mymat, 2, mean)
# 1 refers to rows and 2 refers to columns

D = data.frame(x = 1:100, y = rnorm(100) , id = letters[1:2])

# return y value means for groups a and b
D.means = tapply(D$y, D$id, mean)
