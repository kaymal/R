# LAB 1 - Lasso and Ridge Regression

# Data
prostate.data <- read.table(file.choose(), header=T, sep="\t", row.names=1)
head(prostate.data)
plot(prostate.data[,c(9,1:8)])
# lpsa is the response

# Scaling the regressors
x<-prostate.data[,1:8] #extract the regressors only
cov(x) # the diagonals of the covariance matrix are the variances
# pgg45 de ciddi cov var

x<-scale(x,TRUE,TRUE) #both center and scale
cov(x) # Now the diagonals are 1 and the off-diagonals are correlations
apply(x,2,mean) ### I get 0 > all are scaled
prostate.sc<-data.frame(lpsa=prostate.data$lpsa,x) ###lpsa=>name of the column
head(prostate.sc)

# Training and Test Set
sample(1:97,30) ###sample without replacement
order(sample(1:97,30))
sort(sample(1:97,30))

test.index<-sort(sample(1:97,30))#sample the row numbers without replacement
data.test<-prostate.sc[test.index,] #select the 30 in the test set
dim(data.test)
data.train<-prostate.sc[-test.index,]#the remaining 67 go in the training set 
dim(data.train)

prostate.train<-prostate.sc[prostate.data$train,]
dim(prostate.train)
prostate.test<-prostate.sc[!prostate.data$train,]
dim(prostate.test)

prostate.lm<-lm(lpsa~.,data=prostate.train)
summary(prostate.lm) #notice that we don’t need all of the variables
#regular regression yapsak, once assumptionlara bakip sonra linear model e bakmak lazim


y.hat<-predict(prostate.lm,newdata=prostate.test)
y.hat
y.test<-prostate.test$lpsa #I'm gonna use them more than once
pred.error<-y.test-y.hat #for each one of the 3, the prediction errors
mean(pred.error^2) #This is the number to beat (Square them, average them)
#[1] 0.521274 > daha cok verimiz olsaydi daha accurate olurduk.
sd(pred.error^2)/sqrt(30)# The standard error of the number to beat. 
#what is the standard error of...?? burada kare olacak.

#Buraya kadar klasik regresyon yaptik

# glmnet
library(glmnet)
x.train <- as.matrix(prostate.train[,-1]) # take all rows, without the first column
names(prostate.train)
y.train <- prostate.train$lpsa
prostate.lasso<-glmnet(x=x.train, y=y.train)
prostate.lasso #%Dev is like Rsquared
#lambda lar yuksekse betalar 0 a gider

names(prostate.lasso)

plot(prostate.lasso)
plot(prostate.lasso,xvar="lambda",label=T) #label'lar columnlari gosteriyor
#Small values of lambda are on the left > No penalty.
#smallest lambda > most complex
prostate.lasso$lambda
dim(prostate.lasso$beta) #vector of betas for each lambda


# Cross-Validate to Choose Lambda
prostate.cv.lasso<-cv.glmnet(x=x.train, y=y.train)
names(prostate.cv.lasso)

plot(prostate.cv.lasso) # cross validated mean square error
#grafigin sag tarafinda muhtemelen "under fitting", sol tarafta ise
#muhtemelen "over fitting", cunku duzlesmeye basliyor

#sekildeki ust alt cizgiler 1 sd 'yi gosteriyor. Programin sectigi sonuc,
#ikinci kesik cizginin uzerinde oldugu nokta

prostate.cv.lasso$lambda.min # gives you the min cross validated mean square error
log(prostate.cv.lasso$lambda.min)
log(prostate.cv.lasso$lambda.1se) # istedigimiz lambda bu*** the one we want

#compare results
x.test<-as.matrix(prostate.test[,-1])
y.hat.lasso<-predict(prostate.lasso,newx=x.test,s=prostate.cv.lasso$lambda.1se)
error.lasso<-y.hat.lasso-y.test
mean(error.lasso^2)
sd(error.lasso^2)/sqrt(30)

#lambda.lasso<-prostate.cv.lasso$lambda.1se
#log(lambda.lasso)
#plot(prostate.lasso,xvar="lambda")
#abline(v=log(lambda.lasso),lty=2,col=”grey”)

#Ridge regression
-----------------
prostate.ridge<-glmnet(x=x.train, y=y.train, alpha=0)
plot(prostate.ridge,xvar="lambda",label=T)
#sol tarafta smallest lambda. Coefficients lar 0's yaklasior.
#aslinda hicbiri 0'a gelmiyor

prostate.cv.ridge<-cv.glmnet(x=x.train, y=y.train,alpha=0)
#if alpha is 1, then this is doing lasso (alpha=1 -> default)
plot(prostate.cv.ridge)
lambda.ridge<-prostate.cv.ridge$lambda.1se
lambda.ridge

y.hat.ridge<-predict(prostate.ridge,newx=x.test,s=lambda.ridge)
error.ridge<-y.hat.ridge-y.test
mean(error.ridge^2)
sd(error.ridge^2)/sqrt(30)

# Compare the Results
x.test<-as.matrix(prostate.test[,-1])
y.hat.lasso<-predict(prostate.lasso,newx=x.test,s=lambda.lasso)
error.lasso<-y.hat.lasso-y.test
mean(error.lasso^2)
sd(error.lasso)/sqrt(30)


### HW 
## AIC
prostate.AIC.lm <- stepAIC(prostate.lm,scope=~.,trace=F, direction="both")
summary(prostate.AIC.lm)

y.hat.step<-predict(prostate.AIC.lm,newdata=prostate.test)
pred.error.step<-y.test-y.hat.step
mean(pred.error.step^2) 
sd(pred.error.step^2)/sqrt(30)

prostate.AIC.lm2 <- stepAIC(prostate.lm,scope=~.^2,trace=F, direction="both")
summary(prostate.AIC.lm2)

y.hat.step2<-predict(prostate.AIC.lm2,newdata=prostate.test)
pred.error.step2<-y.test-y.hat.step2 
mean(pred.error.step2^2) 
sd(pred.error.step2^2)/sqrt(30)
## Drop
# One-way
drop1(prostate.lm, test="F")
prostate.lm2<-lm(lpsa~.-gleason,data=prostate.train)
summary(prostate.lm2)
drop1(prostate.lm2, test="F")
prostate.lm2<-lm(lpsa~.-gleason-age-lcp-pgg45-lbph-svi,data=prostate.train)
summary(prostate.lm2)
drop1(prostate.lm2, test="F")

y.hat.drop<-predict(prostate.lm2,newdata=prostate.test)
pred.error.drop<-y.test-y.hat.drop 
mean(pred.error.drop^2) 
sd(pred.error.drop^2)/sqrt(30)

# Two-way
prostate2.lm<-lm(lpsa~.^2,data=prostate.train)
summary(prostate2.lm)
drop1(prostate2.lm, test="F")
prostate2.lm2<-lm(lpsa~.^2-lbph:gleason-age:gleason-gleason:pgg45
                  -weight:pgg45-weight:svi-age:svi-lcavol:lcp
                  -weight:lcp-lbph:lcp-weight:age-age:lbph-lcavol:svi
                  -lcavol:lbph-lcp:gleason-lcp:pgg45-lcavol:gleason
                  -lcavol:pgg45-age:pgg45-lcavol:weight-lcavol:age
                  -age:lcp-age-lbph:pgg45-lbph:svi-svi:lcp-svi:pgg45
                  -pgg45-lcp-svi:gleason-weight:lbph-lbph,data=prostate.train)

drop1(prostate2.lm2, test="F")
summary(prostate2.lm2)

y.hat.drop2<-predict(prostate2.lm2,newdata=prostate.test)
pred.error.drop2<-y.test-y.hat.drop2 
mean(pred.error.drop2^2) 
sd(pred.error.drop2^2)/sqrt(30)

#Step BIC
prostate.BIC.lm <- lm(lpsa~+lcavol+weight+svi+lcavol:weight,data=prostate.train)
summary(prostate.BIC.lm)

y.hat.BIC<-predict(prostate.BIC.lm,newdata=prostate.test)
pred.error.BIC<-y.test-y.hat.BIC 
mean(pred.error.BIC^2) 
sd(pred.error.BIC^2)/sqrt(30)\

#regsubsets
summary(regsubsets)