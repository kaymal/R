spam.data <- read.table(file.choose(), header=T, sep="")
dim(spam.data)
names(spam.data)

table(spam.data$test,useNA="always") 
#useNA table kullanirken gerekli. Yoksa ignore edebilir.
#en azindan sayisini veriyor

spam.test <- spam.data[spam.data$test==1,]
spam.train <- spam.data[spam.data$test==0,]
table(spam.train$spam,useNA="always")
table(spam.train$spam,useNA="always")/3065 #What prorportion of the training set is spam?

spam.tree<-rpart (spam~.,data = spam.train[,-59])
spam.tree
summary(spam.tree)

spam.tree<-rpart (as.factor(spam)~.,data = spam.train[,-59])
# To use information score to split:
# rpart(as.factor(spam)~.,data=spam.train,parms=list(split=”information”))
spam.tree
plotcp(spam.tree) #time to prune, or maybe not… 
# plot of the cross validated.... 
#cp is still getting smaller. Lets choose a spmaller cp
printcp(spam.tree)

spam.tree<-rpart (as.factor(spam)~.,data = spam.train[,-59],cp=.005)
plotcp(spam.tree)

printcp(spam.tree) # we're gonno take the smallest relative error
#####
CP nsplit rel error  xerror     xstd
1 0.4934319      0   1.00000 1.00000 0.022243
2 0.1444992      1   0.50657 0.50657 0.018226
3 0.0418719      2   0.36207 0.36289 0.015968
4 0.0279146      4   0.27833 0.29228 0.014564
5 0.0172414      5   0.25041 0.26683 0.013994
6 0.0114943      6   0.23317 0.25287 0.013666
7 0.0082102      7   0.22167 0.23810 0.013304
8 0.0057471      8   0.21346 0.22660 0.013011
9 0.0050000     10   0.20197 0.22660 0.013011
####
spam.tree<-rpart (as.factor(spam)~.,data = spam.train[,-59],cp=.006)
printcp(spam.tree)

fancyRpartPlot(spam.tree) #rattle i yukle
#the percentage in the boxes represents the percentage of the winners in that box 

# Assessing the model

table (spam.train$spam, predict(spam.tree,type="class")) #confusion matrix


########## ADULT HW
adult.train <- read.table(file.choose(), header=T, sep=",")
adult.test <- read.table(file.choose(), header=T, sep=",")
names(adult.train)
adult.test

adult.tree<-rpart (as.factor(Income)~.,data = adult.train, cp=.0017)
adult.tree
plotcp(adult.tree)
printcp(adult.tree)
plotcp(adult.tree)
fancyRpartPlot(adult.tree)

rattle()

11841/(11841+594) 
594/(11841+594) 
1691/(1691+2155)
2155/(1691+2155)

table(adult.train$Income,useNA="always")/32561
table(adult.train$Income,useNA="always")
24720+7841 