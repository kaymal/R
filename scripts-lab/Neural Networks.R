data(iris)

dim(iris) #should be 150 x 5
head(iris)
summary (iris)
#we have equal number of each species

c("orange","blue","red")[c(1,1,2,1,3)]
col<- c("orange","blue","red")[iris$Species]
col #species de 3 level var. her level sirayla rengi aliyor
pairs(iris[,1:4],col=col)
#2d de bile gayet iyi ayrim yapabiliyoruz. 3d daha da iyi olabilir.
library(rgl)
plot3d(iris[,1:3],col=col,type="s",size=1.2)

#coefficient for the neural networks are called weights

#
## Example: the Iris data 
#
library(nnet)
set.seed (94) # initialize the random number generator
iris.3.94 <- nnet(Species ~., data=iris, size=3)  #size:number of units in the hidden layer.
summary(iris.3.94)

#we want to see how well we predict
predict(iris.3.94)
#setosa yi iyi yapiyor, ancak digerleri cok kotu
predict(iris.3.94, type="class")
table (iris$Species, predict(iris.3.94, type="class"))
#son iki cicek icin gercekten kotu, ancak seed den de olabilir

set.seed(54)
iris.3.54<-nnet(Species~.,data=iris,size=3)
#score function cok dustu, bu seed le gayet iyi yapabiliriz
table (iris$Species, predict(iris.3.54, type="class")) # gayet iyi

iris.3.54
summary(iris.3.54)
names(iris.3.54)

#
## Jittering the Weights
#
iris.3.x<-nnet(Species~.,data=iris,size=3,Wts=jitter(iris.3.94$wts))
#Wts : starting values??
#jitter yapinca biraz randomness eklemis oluyoruz 
#bundan pek olumlu sonuc cikmadi

# Weight Decay
set.seed(94)
iris.new<-data.frame(scale(iris[,1:4]),Species=iris[,5])
#scale automatically divides by the standard deviation
#args(scale)
iris.3W.94 <- nnet(Species ~., decay = 5e-4, data = iris.new, size = 3) #decay:parameter for weight decay. Default 0.
#decay is like doing ridge regression in nnet.
#decay in degerine gore penalize ediyoruz.
table (iris$Species, predict (iris.3W.94,type="class"))

#
## Picture
#Sakai de plot.nnet i calistir

plot.nnet(iris.3W.94)

#add color
plot.nnet(iris.3W.94,pos.col="blue",neg.col="green",
          all.out="setosa",all.in="Sepal.Length")
#blue > positive (large) weights, green > negative weights
#ince cizgiler >> weights are around zero, they are not contributing that much

#
### HW - 3
#

opt.train <- read.delim(file.choose(),header=F,sep=",")
opt.test <- read.delim(file.choose(),header=F,sep=",")

head(opt.train)

#
# seperate the 65th column
# the 65th column names the digit in question
dim(opt.train)
dim(opt.test)
#check.train <- opt.train[,65]
#opt.train <- opt.train[,1:64]
#dim(opt.train)
# do the same to test data
#check.test <- opt.test[,65]
#opt.test <- opt.test[,1:64]
#dim(opt.test)

#
## Plots
#
op.4<-opt.train[opt.train[,65]==4,] #extract only the fours
dim(op.4)# there are a lot of these
col<-colorRampPalette(c("alice blue","dodger blue"))(16)

# Make four plots
op<-par(mfrow=c(2,2))
for(i in c(1,3,5,10)){
  z<-matrix(unlist(op.4[i,1:64]),nrow=8,ncol=8)
  image(z[,8:1],col=col)#turn it upside down
  box()}
par(op)

z<-matrix(unlist(op.4[1,1:64]),nrow=8,ncol=8)
filled.contour(x=1:8,y=1:8,z=z[,8:1],col=col)
##########
#
## Question 1
#
dim(opt.train)
(3823/4)/10
digits <- numeric()
rm(index.validation)
index.validation <- numeric()
for (i in 0:9) {
  index.validation <- c(index.validation, sample((which(opt.train$V65==i)),95, replace=F))
}
dim(index.validation)
opt.validation <- opt.train[index.validation,]
opt.train2 <- opt.train[-index.validation,]

dim(opt.validation)
dim(opt.train2)

#
## Question 2
#
temp = 10000
k = 1
opt.val <- numeric()
seed.choice = 1
for (k in 1:100) {
  set.seed(k)
  opt.nnet <- nnet(as.factor(V65)~., data=opt.train, size=10)
  if (opt.nnet$val < temp) { 
    temp = opt.nnet$val
    seed.choice = k
  }
  opt.val[k] <- opt.nnet$val
#  print(seed.choice)
}
seed.choice

plot(1:100, opt.val, type="l")

set.seed(88)
opt.nnet <- nnet(as.factor(V65)~., data=opt.train2, size=10)

size.opt.val <- numeric()
for (s in 1:15) {
  set.seed(88)
  opt.nnet <- nnet(as.factor(V65)~., data=opt.train2, size=s)
  size.opt.val[s]<- opt.nnet$val
}
plot(1:13, size.opt.val, type="l")

set.seed(88)
final.model <- nnet(as.factor(V65)~., data=opt.train2, size=13)
table (opt.validation$V65, predict (final.model,type="class", newdata=opt.validation))
(27+33)/950
## tune
obj <- tune.nnet(as.factor(V65)~., data=opt.train, gamma = 2^(-1:1), cost = 2^(2:4))
# iris te deniyoruz cunku spam de cok uzun surer
summary(obj)


#
## Question 3
# Below is the confusing matrix on the test set, utilizing the best model from question 2. 
table (opt.test$V65, predict (final.model,type="class", newdata=opt.test))
166/ dim(opt.test)
#
## Question 4
#
library (rattle)
rattle()

#
## Question 5
#
table (opt.test$V65, predict (opt.tree,type="class", newdata=opt.test))
