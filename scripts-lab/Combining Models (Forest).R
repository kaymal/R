rocrattle()
# number of variables (try first the sqrt of the total number> sqrt(50)=7))
# spam.train
# target data type=categoric

#Variable Importance
===================
  
  0     1 MeanDecreaseAccuracy MeanDecreaseGini
char_freq_..3              32.89 36.05                41.82           105.11
char_freq_..4              32.95 28.79                37.99            90.67

# 1. siradaki en onemli, GINI ye gore bayagi onemli

###
spam.rf <- randomForest(formula = as.factor(spam) ~ .,
             data = crs$dataset[, c(crs$input, crs$target)],
             ntree = 200, mtry = 7, importance = TRUE, replace = FALSE,
             na.action = na.roughfix, proximity=T)
#proximity=T kismini yeni ekledik, digerleri rattle da vardi

rf.mds <- cmdscale (1-spam.rf$proximity, eig=T, k=3)
library(rgl)
plot3d(rf.mds$points,col=c("blue","red")[spam.train$spam+1],pch=19,cex=.5)

#### 2nd part
rattle()

crs$ada
names(crs$ada)
crs$ada$bag.frac # it randomly selects half of the data each time
crs$ada$nu  # learning paramter (greek letter ata)
#nu=0.1 > relative fast learner

#complexity = -1 yaparsak yapabildigi kadar split yapar

###
# gbm ve mboost paketlerini yukle

spam.boost3<-gbm(spam~., distribution = "bernoulli", data = spam.train[,-59],
                 n.trees = 1000, interaction.depth = 3,  shrinkage = 0.01,
                 cv.folds=10) #cv=cross-validate

spam.boost3
# we need to keep going, increase the number of trees

gbm.perf(spam.boost3, method = "cv") #cross validated errors
# black is out of bag error, green is cross validated error (because it is higher)

best.iter <- gbm.perf(spam.boost3,method="cv")
print(best.iter)# cv best number of iterations

predict(spam.boost3, spam.test) # shows log-odds (not estimated probs)
y.hat<-predict(spam.boost3,spam.test, type="response") #shows estimated probs

table(spam.test$spam,y.hat>.5)  #classify using a threshold of .5
(53+35)/1536 # 5% is not bad, it is actually good

#our cv error is still decreasing with 1000, we need to increase this number

summary(spam.boost3,n.trees=1,las=2,cex.names=.5)   # based on the first tree
summary(spam.boost3,n.trees=best.iter,las=2,cex.names=.5) # best num. of trees

plot(spam.boost3, 1, best.iter)

spam.sum<-summary(spam.boost3) 
names(spam.sum)
head(spam.sum) # ordered from the most important to least important
imp.vars<-spam.sum$var[1:4]#names of the 4 most important

imp.vars
names(spam.boost3)
spam.boost3$var.names[1]
which(spam.boost3$var.names%in%imp.vars)

x<-which(spam.boost3$var.names%in%imp.vars)#row numbers of the most important
par(mfrow=c(2,2))
plot(spam.boost3,x[1],best.iter)
plot(spam.boost3,x[2],best.iter)
plot(spam.boost3,x[3],best.iter)
plot(spam.boost3,x[4],best.iter)

#sag altta $ var. Bir tane bile olsa hemen spam oluyor. Very significant

plot(spam.boost3,x[1:2],best.iter)
#acik renkten koyu renge cok hizli gidiyor