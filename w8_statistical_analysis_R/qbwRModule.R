###additions to courseModule.R
#install.packages('pheatmap',repos="http://lib.stat.cmu.edu/R/CRAN")
library(pheatmap)

sim = function(nsamples, samplesize, mu=0, sigma=1)
{
	xvals = double(nsamples*samplesize)
	xvals = matrix(xvals, samplesize, nsamples)
	
	for (i in 1:nsamples)
	{
		for (j in 1:samplesize)
		{
			xvals[j,i] = i
		}
	}
	
	yvals = rnorm(nsamples*samplesize, mean=mu, sd=sigma)
	# uncomment this line to draw samples from a uniform distribution
	# rather than a normal distribution
	#yvals = runif(nsamples*samplesize, -1, 1)
	yvals = matrix(yvals, samplesize, nsamples)
	
	return(list("xvals"=xvals, "yvals"=yvals))
}

count = function(input, lowerbound, upperbound)
{
	return(sum(input>lowerbound & input<upperbound))
}

plotsidebyside = function(first, second, firstname="First", secondname="Second", ylab="Values")
{
	plot(c(first, second), col=c(rep("red", length(first)), rep("blue", length(second))),
	     xlab="", ylab=ylab)
	if (firstname != "First")
	{
		legend("topleft", c(firstname, secondname), pch="o", col=c("red", "blue"))
	}
}

sem = function(input)
{
    if (is.matrix(input))
    {
        samplesize = nrow(input)
        sdvals=apply(input,2,sd)
    }
    else
    {
        samplesize = length(input)
        sdvals=sd(input)
    }
	return(sdvals/sqrt(samplesize))
}

errorbars = function(aboves, belows, x=1:length(aboves), col="black")
{
	arrows(x, belows, x, aboves, code=3, angle=90, length=0.02, col=col)	
}

errorbarcolors = function(aboves, belows)
{
	colors = ifelse(belows>0 | aboves < 0, "red", "black")
	colors
}

clearworkspace = function()
{
	rm(list=ls(pos=.GlobalEnv), pos=.GlobalEnv)
}


lowtemp = c(1.07, 1.11, 1.12, 1, 1.15, 1.13, 0.92, 1.07, 0.98, 1.07, 1.18, 
1.03, 1.2, 1, 1.11, 1.13, 1.21, 1.09, 0.96, 0.94, 1.09, 1.21, 
1.14, 1.23, 1.02, 1.12, 1.03, 1.3, 1.2, 1.16, 1, 1.06, 1.11, 
1.04, 1.04, 1.03, 1.14, 1.21, 1.04, 1.11, 1.07, 1.09, 1.1, 0.97
)

hightemp = c(1.1, 1.15, 1.04, 1.07, 1.02, 1, 0.99, 1.02, 1.02, 0.98, 1.1, 
1.02, 0.98, 0.93, 1.12, 0.93, 0.99, 1, 1.04, 0.9, 0.93, 1.1, 
1.17, 1.1, 0.95, 0.91, 0.96, 1.01, 1.04, 1.06, 1, 0.84, 1.09, 
0.86, 1.1, 1.01, 1.12, 1.08, 1, 0.94, 0.88, 1.1, 1.05, 1.02)

thorax_length = append(lowtemp, hightemp, after=length(lowtemp))
high= rep_len("high", 44)
low= rep_len("low", 44)
treatment = append(low, high, after= length(low))
expt <- data.frame(thorax_length, treatment)
color.list <- c("red", "blue")
palette(color.list)


s3 = function()
{
	oldpar = par(mfcol=c(2,1))

	nsamples = 100
	samplesize = 25
	datasets = sim(nsamples, samplesize)
	plot(datasets$xvals, datasets$yvals, col="grey", xlab="Datasets", ylab="Simulated Values")
	
	col.means = colMeans(datasets$yvals)
	col.sems = sem(datasets$yvals)
	points(1:nsamples, col.means, pch="x")
	
	col.lowers = col.means-2*col.sems
	col.uppers = col.means+2*col.sems

	colors = errorbarcolors(col.uppers, col.lowers)

	errorbars(col.uppers, col.lowers, col=colors)
	abline(h=0, col="red")
	print(count(0, col.lowers, col.uppers)/nsamples)


	hist(col.means, breaks=20, xlab="Means", main="Histogram of Dataset Means\n(should be approximately bell-curved)")

	par(oldpar)
}

s4 = function()
{
	nsim = 1000
	samplesize = 50
	wildtype.mean = 300
	wildtype.sd = 25

	wildtype = sim(nsim, samplesize, wildtype.mean, wildtype.sd)
	wildtype.col.means = colMeans(wildtype$yvals)

	mutant = rnorm(samplesize, mean=290, sd=wildtype.sd)
	print(mean(mutant) < 300)

	print(t.test(mutant, mu=300, alternative="less")$p.value)
	print(count(wildtype.col.means, 0, mean(mutant))/nsim)
}


missingpats<-c(1,49,52,63,65,78,6,57)
##get data, removing select patients
getMrnaData<-function() as.matrix(read.table('http://files.edx.org/MITx/7.QBWx/7qbwx_mrnaData.tab',sep='\t',as.is=T,header=T,row.names=1,fill=T)[,-missingpats])

read.url <- function(url, ...){
  tmpFile <- tempfile()
  download.file(url, destfile = tmpFile, method = "curl")
  url.data <- read.csv(tmpFile, ...)
  return(url.data)
}

getPatientData<-function(){
  tab=read.url("https://courses.edx.org/c4x/MITx/7.QBW_1x/asset/7qbwx_patientData.csv",sep=',',as.is=T,header=T,fill=T,row.names=1)[-missingpats,]
  tab[,3]<-as.numeric(tab[,3])
  return(tab)
} 

##get variance or SD for all rows of matrix
getAllRowVariance<-function(x) apply(x,1,var)
getAllRowStd<-function(x) apply(x,1,sd)

##compute correlation or sd for all rows in matrix
matrixToVectorCor<-function(matrix,vec) apply(matrix,1,function(x) cor(x,vec))
matrixToVectorSqCor<-function(matrix,vec) apply(matrix,1,function(x) cor(x,vec)^2)