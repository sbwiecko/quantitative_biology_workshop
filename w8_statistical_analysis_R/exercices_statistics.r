# load modules and the dataset
source('qbwRModule.R')

# Now that you have become comfortable with simulated data, we have some real 
# experimental results to evaluate.
# Say you are interested in the effects of temperature on organismal development, 
# and you are focusing on the following question:
# Do individuals raised outside their optimal temperature range look different from 
# those raised at the normal temperature?
# To study this question, you measure body length in the fruit fly Drosophila 
# melanogaster (the most common insect model organism), and to compare flies grown 
# at the normal temperature of 25 °C compared to a lower temperature of 16.5 °C you 
# collect several dozen flies grown at each temperature, and measure thorax length 
# (this is the middle part between the head and the abdomen).
# The class module contains values for these measurements in a dataframe. The 
# dataframe (called expt) contains 88 rows, one for every fly measured, and 
# 2 columns. The first column contains thorax_length (these data are based on 
# real measurements in millimeters), and the second column contains the 
# temperature treatment (factors, low or high). 


# quick overlook
head(expt)

expt$treatment

# calculate the mean for each condition
mean(subset(expt$thorax_length, expt$treatment == 'low'))
mean(subset(expt$thorax_length, expt$treatment == 'high'))

# easier using tapply!
tapply(expt$thorax_length, expt$treatment, mean)


# Visualizing the Data
# Remember that about 2/3 of the data points are within ± 1 standard deviation of the mean—
# this is an assessment of the variation in the measurements, and includes both 
# experimental error (i.e., inability to perfectly measure the thoracic length) 
# and natural variation (i.e., some individuals are larger than others).
# Let’s use the function plot() to create a scatterplot of all the data points 
# colored by which treatment they are in:

plot(
    expt$thorax_length,
    col=as.factor(expt$treatment),
    ylab="thorax length (mm)",
    xlab="specimen number"
)

# This command plots all the points in low in blue and all the points from high 
# in red, with the specimen number labeled on the x-axis and the y-axis labeled 
# as “thorax length (mm)”. A more standard way to show this kind of data is with 
# a box-and-whisker plot (usually known simply as a boxplot). Here is how you would 
# make a box-plot of the low temperature and high temperature thorax length measurements:

boxplot(
    expt$thorax_length ~ expt$treatment,
    ylab="thorax length (mm)",
    xlab = "treatment"
)

# This command plots thorax_length according to treatment, so two boxes are shown. 
# The thick black line in the box is the median (or 50th percentile), and the box 
# outlines represent the 25th (lower quartile) and 75th (upper quartile) percentiles 
# of the measurements. The whiskers of the boxplot can be customized to extend in 
# different ways, but as a default, R uses a calculation based on the quartile range 
# of the observations. One of the benefits of R is the ability to plot the same 
# data in many formats by changing a basic function call.


# CONFIDENCE INTERVALS
# R does not have a built in SEM function, but one called sem() is included in the course module.
# The sem() function essentially does the following calculation:

# sd(data)/sqrt(n)

# The formula for the SEM has some very nice theoretical properties, which we will not go into 
# in too much detail, but here is the idea: remember when we said that 2/3 of the data points 
# are within one standard deviation of the mean, and 95% are within two standard deviations?
# Well, the SEM has a similar relationship to estimates of the mean. If you were to take many, 
# equally-sized samples and measure each of the means independently, about 95% of the time 
# you would get a measurement of the mean within 2 SEMs of the original measurement.

# Now let’s simulate a dataset with 200 values using the sim() function from the course module
data.sim = sim(1, 200)

# The sim() function is an expanded version of the rnorm command that produces more than 
# one simulated dataset if the first argument is greater than 1.  The command returns a list 
# containing two vectors, each with a name that can be accessed through the names function:

names(data.sim)

head(data.sim$xvals)
head(data.sim$yvals)

plot(data.sim$xvals, data.sim$yvals)
plot(jitter(data.sim$xvals), data.sim$yvals, col="grey")

m = mean(data.sim$yvals)
s = sem(data.sim$yvals)

points(1, m, pch="x")

below = m-2*s
above = m+2*s
errorbars(above, below)

# Now, more than likely, the mean is very close to 0, and the error bars will extend slightly 
# above and below zero. These error bars represent what are called 95% confidence intervals: 
# we are 95% confident that the true mean falls somewhere along the error bars.



# Using Simulations to Estimate Confidence
# In real biology, you do your best to get a large sample size but you generally have to make 
# do with whatever you can get. You are going to take advantage of the fact that we are 
# simulating data to see what would happen if you repeated the experiment over and over again.

# You will follow the same steps of simulating data, plotting it, calculating the confidence 
# intervals, and then adding those on top of the plotted data. This time, though, you are going 
# to do it with multiple data sets simultaneously. Create a new script document that you can 
# use to type in commands. Use the sim() function to simulate 100 datasets each of size 25. 
# Type these lines into the new script document:

nsamples = 100
samplesize = 25
datasets = sim(nsamples, samplesize)

datasets$yvals

# You will notice that the data are organized into 100 columns (each representing a dataset) 
# of 25 values each (the data points). The x-values are basically just groupings for the 
# 100 different datasets, as you will see when you plot the simulated data:

plot(datasets$xvals, datasets$yvals, col="grey")

col.means = colMeans(datasets$yvals)
col.sems = sem(datasets$yvals)

points(1:nsamples, col.means, pch="x")

# Run the script to see the points plotted. Now, we’ll use the means and SEMs to calculate 
# error bars. As we did before, we are going to take the mean values and add the SEMs to them, 
# and here we are taking advantage of the capabilities of the matrix variable type: 
# subtraction of equally-sized matrices performs element-wise subtraction. Add the following:

col.lowers = col.means-2*col.sems
col.uppers = col.means+2*col.sems

colors = errorbarcolors(col.uppers, col.lowers) # function from the course module
errorbars(col.uppers, col.lowers, col=colors)
abline(h=0, col="red")

# About 95% of the confidence intervals should include zero—that is, on average, 95 out of the 
# 100 datasets you sampled. 

print(count(0, col.lowers, col.uppers)/nsamples)


# Standard Error in Real Data
# Let’s return to our Drosophila experiment. As a reminder, we had raised fruit flies at two 
# different temperatures (the low temperature, and the higher temperature typical of normal 
# development) and measured thorax lengths of a number of flies. You are going to plot the means 
# and approximate confidence intervals so we can make an informed comparison between the two means. 
# Calculate the two means and SEMs by creating vectors of these values at the command prompt:

fly.means = tapply(expt$thorax_length, expt$treatment, mean)
fly.sems = tapply(expt$thorax_length, expt$treatment, sem)

fly.lower = fly.means-2*fly.sems
fly.upper = fly.means+2*fly.sems

plot(fly.means, xaxt="n", ylim=c(0.9,1.2), xlim=c(0,3), ylab="mean thorax length (mm)")
errorbars(fly.lower, fly.upper)
axis(1,at=1:2,labels=levels(expt$treatment))

# You can verify your graphical intuition by printing out the values of fly.lower and fly.upper. 
# Generally, if two 95% confidence intervals overlap slightly, the two means are somewhat 
# significantly different, and if the two confidence intervals don’t overlap at all, they will 
# be very significantly different.


## HYPOTHESIS TESTING

# • null hypothesis (the assumed, but unexciting result): mean thorax length is the same 
# whether fruit flies are raised at a low temperature (16.5℃) or a higher temperature (25℃).
# • alternative hypothesis (the opposite, interesting result): mean thorax length differs 
# between fruit flies raised at a lower temperature (16.5 ℃) and a higher temperature (25℃).

# Notice that the hypothesis specifically includes the measure that we are comparing: the mean. 
# Now to test this, we will use the t-test, which makes the assumption that the sample points 
# have a normal distribution. That is, the sample points are not bi-modal (where there is more 
# than one maximum value) or logarithmic (the values do not span multiple orders of magnitude, 
# for example 1,10,100,1000). For most real data, this is an assumption that can be verified 
# relatively easily just by looking at the histogram and seeing if it appears to be bell-shaped.

hist(subset(expt$thorax_length, expt$treatment=="low"), main= "low temperature distribution", xlab="thorax length")
hist(subset(expt$thorax_length, expt$treatment=="high"), main= "high temperature distribution", xlab="thorax length")


# Output of T-Tests
# Before moving on to performing the actual t-test, it is important to summarize what the test does. 
# The output for a t-test in R gives values for t, df and p.

# t: The t-test will take your sample, calculate the mean, standard deviation and standard error, 
# and from these, produce a value for t, which is basically the difference between the sample means 
# divided by (normalized by) the SEM.
# df: The degrees of freedom is calculated from n (the larger the number of data points, the larger 
# the number of degrees of freedom and the more exact your result).
# p: And finally, the p-value tells you the certainty with which you can “reject” the null hypothesis 
# in favor of the alternative hypothesis. The calculation of the exact p-value depends on the 
# sample size (n), and the degrees of freedom (df). Often times a p-value is used by biologists 
# to determine if an event is scientifically interesting. If an experiment produces data 
# that rejects the null hypothesis with a p-value less than a threshold of 0.05, then we stay 
# that this result is "Statistically Significant".

t.test(expt$thorax_length ~ expt$treatment)


# Using the One-Sample T-Test 
# Maybe instead of comparing the two different temperature treatments to each other, you might 
# wish to know if the average thorax lengths produced by raising D. melanogaster at 25 ℃  
# or 16.5 ℃  are significantly different from 1.0 mm. This is called a one sample t- test. 
# In this example, the hypotheses would be:
# • null hypothesis: the mean thorax length of flies (raised at either 25 ℃  or 16.5 ℃) 
# is not significantly different from 1.0 mm. 
# • alternative hypothesis: the mean thorax length of flies (raised at either 25 ℃  or 16.5 ℃) 
# is significantly greater or significantly less than 1.0 mm. 
# The built-in t.test() function in R can run a one-sample comparison (where mu is the value 
# to compare against):

t.test(subset(expt$thorax_length, expt$treatment=="low"), mu=1)
t.test(subset(expt$thorax_length, expt$treatment=="high"), mu=1)

# You will note that the result will specify that you are performing a one sample t-test, and will show you the alternative hypothesis being tested.
# Note that the one sample t-test will give confidence intervals (these confidence intervals 
# do not depend on the value of mu). They should be very close to the confidence intervals 
# we calculated in fly.lower and fly.upper, although using the t.test() function will give 
# a narrower, more exact result. 


# In this case, the one-sample t-test p-value is greater than 0.05 in the high temperature 
# group (p-value = 0.1715) indicating that the mean thorax length is not statistically 
# significantly different than 1.0 mm. However, the one-sample t-test p-value is much less 
# than 0.05 in the low temperature group (p-value = 8.243e-09) indicating that the mean 
# thorax length is statistically significantly different than 1.0 mm. While 0.05 is 
# the generally accepted threshold, this does not account for multiple hypothesis testing. 
# That is, given 20 experiments, you are bound to get a p-value less than 0.05 at least once. 
# There are ways to account for this that are outside the scope of this lecture. 
# This comic from XKCD sums this up!


# P-Value Simulation
# We are going to return to simulating data to gain an intuitive understanding of how the 
# p-value is calculated. Here is a definition of p-value: the probability, if the null hypothesis 
# were true, that a more extreme value of the measure would be gotten purely by chance. 
# Let's extend our fly temperature scenario with a different set of hypotheses for this simulation:

# • null hypothesis: the mean thorax length of flies raised at 27 ℃ is not significantly 
# different from the mean thorax length of flies raised at 25 ℃.
# • alternative hypothesis: the mean thorax length of flies raised at 27 ℃ is significantly 
# less than the mean thorax length of flies raised at 25 ℃.
# First, simulate some data as if a null hypothesis were true. Let's say that at 25 ℃ the 
# average thorax length of D. melanogaster is 1.02 mm. Let’s sample a whole bunch of 
# data points with an average value of about 1.02 mm and a standard deviation of 0.08 mm 
# (put these commands in a new script file):

nsim = 1000
samplesize = 50
twentyfive.mean = 1.02
twentyfive.sd = 0.08
twentyfive = sim(nsim, samplesize, twentyfive.mean, twentyfive.sd)

# And calculate the empirical means of the 1000 simulated datasets:
twentyfive.col.means = colMeans(twentyfive$yvals)

# Now let’s say that flies raised at 27 ℃ have a true mean thorax length of 1.0 mm 
# and a similar standard deviation:
twentyseven = rnorm(samplesize, mean=1, sd=twentyfive.sd)

# Let’s print out whether the mean thorax length of the flies raised at 27 ℃ is 
# less than those raised at 25 ℃:
print(mean(twentyseven) < 1.02)
print(t.test(twentyseven, mu=1.02, alternative="less")$p.value)

# The alternative option means we’re assuming that the flies raised at 27 ℃ have a 
# shorter thorax on average than flies raised at 25 ℃ , if in fact it’s different 
# from the flies raised at 25 ℃. By specifying the direction of the hypothesized 
# difference, this is a one-tailed t-test. A two-tailed t-test would be if we 
# hypothesized that the flies raises at 27 ℃ have thoraxes either significantly 
# shorter or significantly longer than the flies raised at 25 ℃.
# Finally, let’s calculate the p-value directly ourself. To do this, let’s see what 
# proportion of the means of flies raised at 25 ℃ are smaller than the mean thorax 
# length of flies raised at 27 ℃ (that is, between 0 and the mean of flies raised 
# at 27 ℃) just by chance:

print(count(twentyfive.col.means, 0, mean(twentyseven))/nsim)

# Where the TRUE indicates that the mean thorax length of flies raised at 27℃ 
# was in fact shorter than 1.02 mm, the 0.01850279 is the p-value calculated using 
# the t.test() function, and the 0.019 value is the p-value calculated by comparing 
# the simulated mean thorax lengths of flies raised at 25℃ to the mean of flies 
# raised at 27℃. You’ll see that some of the p-values are quite close, and others 
# aren’t quite so close, but they should generally be within a factor of 2x 
# (except for the really really small ones). If you want a better estimate, you can 
# change the nsim to 10,000 or 100,000, although you will have to wait a little while 
# for it to finish running. 


# In many cases, a one-tailed test can be more precise than a two-tailed test.
t.test(twentyfive.col.means,twentyseven)$p.value
# By default this is a two-tailed t-test, which means that the difference between the 
# means is hypothesized to be significant without specifying direction (greater or less than).

t.test(twentyfive.col.means,twentyseven,alternative = "less")$p.value
t.test(twentyfive.col.means,twentyseven,alternative = "greater")$p.value


### Statistical Analysis of Patient Data
# Predicting Disease Prognosis from Data
# Many of the straightforward statistics applied earlier can be used to better understand 
# molecular patterns in human disease such as cancer.  

# Using high throughput sequencing or microarray technologies, we can identify RNA levels 
# of every gene across a large number of cancer patients.  While Python excels at mapping 
# sequence-level changes to genes as we did earlier, R is useful for analysing and 
# visualizing these changes across a patient cohort.
# The Data
# For the purposes of this exercise we are going to use data from 92 breast cancer tumors, 
# each measuring genome wide mRNA expression levels. Because there are 13,654 genes on the 
# array in question, we can analyze this data using a matrix with 13,654 rows and 92 columns:

mrna.data = getMrnaData()
dim(mrna.data)

patient.data = getPatientData()
dim(patient.data)
head(patient.data)

# Each of the 92 rows represents an individual tumor from a single patient. The first 
# column represents the 'subtype' of the breast cancer. Breast cancer is usually viewed 
# as a collection of distinct diseases each with its own molecular pattern. These subtypes 
# have different treatment regimens and survival rates. The second column represents whether 
# or not the patient is alive, dead from their cancer or dead for another reason. The third 
# column represents how many months post-diagnosis the patient has been observed. Higher 
# values are good, as it means that the patient has lived a long time.

# Assessing Variation Across Patients
# Now to get to the statistics. In any disease tissue, some genes are up-regulated relative 
# to a normal tissue and some are down-regulated. The array values represent how much mRNA 
# was measured for a particular gene for a particular patient. # We can assume that most 
# genes exhibit some natural variation between patients as not all # patients react to a 
# disease in the same way. We can measure that variation using the # summary statistic 
# standard deviation. In R, standard deviation is measured with the function sd():

sd(mrna.data[1,])

all.sds = apply(mrna.data,1,sd)
head(all.sds)

# Since we are interested in which genes vary the most, we sort the genes by standard deviation:
sorted.sds = sort(all.sds,decreasing=T)
head(sorted.sds)

sorted.sds[2000]

# Data Visualization
# R has many sorting functions, including one that simply returns the indexes of the array 
# in a sorted order. This way we can use the order of standard deviation values to sort the matrix.

sorted.order = order(all.sds,decreasing=T)
sorted.matrix=mrna.data[sorted.order,]

# This matrix keeps the most changing genes at the top.

# Now that we have a sense of what genes are changing the most across breast cancer, we want 
# to determine if those changes are relevant to the disease. The most common way to do that is 
# to use heatmaps. Heatmaps are visual representations of a matrix such that each value in the 
# matrix has a specific color associated with it. In R we are using the ‘pretty heatmap’ 
# function called pheatmap().

m = matrix(c(1,2,3,4,5,6),nrow=2)
m
pheatmap(m)

m = matrix(seq(1,25),nrow=5)
pheatmap(m)

# In addition the visualization, heatmaps can also be used to illustrate clustering. By default, 
# the pheatmap program places the rows and columns that are closest adjacent to each other. 
# For example, the values 1–5 (most blue) are adjacent to the values 6–10 (lighter shade of blue).

# Biologically, this becomes more interesting when we cluster genes across patients. Genes that 
# cluster together have been found to be part of similar biological processes such as cell 
# division and cell death. Patients that cluster together often have similar disease characteristics.

pheatmap(sorted.matrix[1:10,],scale='row')

# The ‘scale’ option normalizes the values of the matrix such that each row (gene) has a mean 
# around 0. Thus, any gene that is 'up' is more red, and those genes that are more down-regulated 
# are more blue. To get a better sense of how these 10 genes vary across patients we include 
# the patient variables that we scanned in earlier. First we get variable of interest, 
# such as tumor subtype.

ts=subset(patient.data,select='Tumor.subtype')
pheatmap(sorted.matrix[1:10,],annotation=ts,scale='row')

# Now when we cluster the same genes we see the basal patients clustering together. This 
# means that these 10 genes behave different in the basal subtype than the other types of 
# breast cancer. By modifying how many genes we use we can get more separation between 
# cancer subtypes. To further explore this, try plotting the heatmap with more than 20, 
# then 50, then 100 of the most variable genes.


# Using Gene Expression to Evaluate Patient Prognosis
# It is interesting that a set of genes, sorted by standard deviation, can distinguish 
# different types of disease in breast cancer patients. Even more interesting would be to 
# identify a specific set of genes that were specifically involved in a causing a 
# particular cancer subtype.  Or genes that are correlated with patient survival!
# To do this, we need more statistics. Pearson correlation summarizes the similarity 
# between two vectors. A correlation value of 1 implies that the two vectors are high 
# in the same patients and low in the same patients. A value of –1 implies that when 
# one sample is up, the other is down. In R the correlation is computed via the 
# function cor(). We can use the correlation statistic to identify genes in the array 
# that best correlate with a patient's likelihood of survival. First, we create a 
# numeric vector representing the patients in the study. A ‘1’ means the patient has 
# survived with the cancer and a ‘0’ indicates they have not:

life.vector=rep(0,ncol(mrna.data))
life.vector[which(patient.data[,2]=='Alive')] = 1
head(life.vector)

cor(sorted.matrix[1,],life.vector)

# Because we are interested in genes that are both correlated and anti-correlated we 
# compute the square of the correlation for each gene using the apply() function.

all.cors = apply(sorted.matrix,1, function(x) cor(x,life.vector)^2)
head(all.cors)

# Often times, genes with raw Pearson correlations of 0.4 and greater are targeted as 
# candidate genes in future analyses. Using the genes and values in all.cors, and a logical 
# expression, how many genes would be considered good candidates based on this threshold?

summary(all.cors)

# Because all.cors contains squared Pearson correlations, we must consider the square 
# of the 0.4 or 0.16 as our threshold for the all.cors values. One way to find out how 
# many genes have squared correlation values above 0.16 is to use the following code, 
# which returns the gene names and squared correlations that are above the 0.16 threshold: 

all.cors[all.cors > 0.16]


# Using a Heatmap to Visualize Patient Prognosis
# Because we are searching for genes that are highly correlated, we can use the order() function 
# to get genes that are most correlated.

cor.matrix = sorted.matrix[order(all.cors,decreasing=T),]

# Then we can use the heatmap to plot these genes to see if the clustering keeps all the patients 
# who survive together. This time we want to plot patient survival.

surv = subset(patient.data,select='Death.status')
surv

pheatmap(
    cor.matrix[1:50,],
    annotation=surv,
    fontsize=8,
    cellheight=9,
    scale='row'
)

# You might need to resize the windows within RStudio to get the entire heatmap to appear.
# Now the cluster of patients that are alive cluster together (with a few exceptions). 
# This implies that the genes selected may play a role in helping the patient respond to 
# treatment, or simply suggest a milder form of cancer.

# Using the 'Zoom' button in RStudio, zoom into the gene names to determine what role these 
# genes can be playing in patient survival. We can now evaluate the clusters of genes.
# Which of these genes are mostly up-regulated (yellow or orange) in patients who are alive? 
# Keep in mind that your heat map only includes the 50 genes most correlated with alive or dead patients
# PHC1, SERTAD3 and WDR57

# Which of these genes are mostly down-regulated (blue) in patients who are alive?
# TNK2 and SPPL2B




#### R HELP AND RESOURCES
example(plot)
example(boxplot)
example(pie)
example(pch)
