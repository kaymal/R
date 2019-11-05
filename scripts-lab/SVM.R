# e1071 i yukle
dim(spam.train)
dim(spam.test)

# default bases function is radial bases function
# argument is gonna be kernel

# more peaked >>> more complex

svm.spam.3<-svm(factor(spam)~., data=spam.train[,-59], cost=10, gamma=1)
#svm responsu kategorik olarak algilasin diye factor yapiyoruz
svm.spam.3 #it classified for us
summary(svm.spam.3)

names(svm.spam.3)
# svm returns the class but not the estimated probs.
# If you want probs, need to wite prob=T as an argument
svm.spam.3$fitted # bize classification u veriyor

table (svm.spam.3$fitted)

#how well we did >>> confusion matrix
table(spam.train$spam, svm.spam.3$fitted)
#train set ama yine de iyi predict ediyor

predict(svm.spam.3, newdata=spam.test[,-59]) #predict the test using model created

#Confusing matrix of predicted values with actual test set
table(spam.test$spam, predict(svm.spam.3, newdata=spam.test[,-59]))
# not spam icin iyi ancak spam icin hic de iyi degil


svm.spam.3<-svm(factor(spam)~., data=spam.train[,-59], cost=10, gamma=.1, cross=10)
table(spam.test$spam, predict(svm.spam.3, newdata=spam.test[,-59]))
# daha iyi predict yapiyoruz

summary(svm.spam.3)

## tune
obj <- tune.svm(Species~., data = iris, gamma = 2^(-1:1), cost = 2^(2:4))
# iris te deniyoruz cunku spam de cok uzun surer
summary(obj)
####
- Detailed performance results:
  gamma cost      error dispersion
1   0.5    4 0.04666667 0.08344437
2   1.0    4 0.06000000 0.11525602
3   2.0    4 0.06666667 0.11331154
4   0.5    8 0.05333333 0.09838197
5   1.0    8 0.05333333 0.09838197
6   2.0    8 0.07333333 0.11088867
7   0.5   16 0.04666667 0.08344437 >>>>> best performing model????
8   1.0   16 0.06000000 0.09660918
9   2.0   16 0.06666667 0.11331154
#####
plot(obj)