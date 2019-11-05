beer.data <- read.table("clipboard", sep=",",header=T) # dosyanin icinde copy_all yaptim
names(beer.data)
#install rpart library

beer.tree <- rpart (Calories ~ Alcohol, data = beer.data) 
beer.tree

# PLOTTING REGRESSION SPACE
alc<-seq(0,6,.01) #biranin bira olabilmesi icin minimum 6% gerekli
newdata<-data.frame(Alcohol=alc) #data frame in ilk sutunu Alcohol oldu
yhat <- predict (beer.tree, newdata)
#yhatler icinde olduklari dikdortgenin ortalamasi olan constant degerler
plot(alc,yhat,type="l", col="magenta")
#bunda sadece alcohol vardi. asagida daha fazla faktorle yapacagiz

curve(predict(beer.tree,data.frame(Alcohol=x)),0,6,col="red") #2. yol

head(beer.data)
beer.tree <- rpart (Calories ~ ., data = beer.data[,-1]) 
beer.tree #ilginc bir sekilde ayni agac cikti
# big driver for calories is alcohol
plot(beer.tree)

rpart (Calories ~ ., data = beer.data[,-1], minbucket=3, cp=0)

#plot(x,predict(beer.tree,newdata)
#This works too.
#curve(predict(beer.tree,data.frame(Alcohol=x)),0,6,col=”red”)

## Rattle
#install rattle
rattle()
wage.train <- read.table(file.choose(), sep="", header=T)
head(wage.train)

.libPaths()

crs$dataset # gives the data that rattle stored
plot(crs$rpart)
text(crs$rpart)
fancyRpartPlot(crs$rpart, main="Decision Tree wage.train $ Wage")

fancyRpartPlot <- fancyRpartPlot # kendi workspace ime yukledim
fix(fancyRpartPlot)

####
CP          nsplit rel error xerror   xstd
1 0.173435      0   1.00000 1.00338 0.087321
2 0.055130      1   0.82656 0.86784 0.068450
3 0.045188      2   0.77144 0.89327 0.071523
4 0.029407      3   0.72625 0.84554 0.069911
5 0.014981      4   0.69684 0.83792 0.069542 #en kucuk xerror bunda #4 split is going to have 5 leaves
6 0.013780      5   0.68186 0.85562 0.071275
7 0.013528      6   0.66808 0.86761 0.072320
8 0.011288      7   0.65455 0.85786 0.071885
9 0.010000      9   0.63198 0.88256 0.075459
#####
#xstd : cross validated std error
#rel error is like r-squared?
#I'd like to find least complex tree whose .... 
#(soln:2nd option,0.86, 0.83+-0.06 icinde-----> least complex tree 2nci olan)
#complexity parameter: 0.06 deneyelim >> iki yaprak oluyor..
# We want least complex model so 2nd option is the best
# Rattle da complexity parameter i artirinca daha az yaprakli agac elce ediyoruz

crs$rpart
predict(crs$rpart)
fancyRpartPlot(crs$rpart)

#eger variance constant degilse (equal degilse)
##> weighted ... veya y transform kullanmaliyiz

# unequal variance arayalim
y.hat <- predict(crs$rpart)
r <- resid(crs$rpart)
plot(y.hat, r)   # sadece 3 yaprak var, bu nedenle 3 level goruyoruz
abline (0,0)
# en soldakinde ortada daha cok koyuluk var, yani variance daha az gibi duruyor
plot(factor(y.hat), r) # factor yaparak kategorik olarak y.hat i aldik

#unequal variance icin ikinci yontem (?)
qqnorm(r)
qqline(r)

meanvar(crs$rpart) #plots yhat (average of the y’s) against MSE (average “deviance”) for each node.
#average of the y's for each one of the leave against the average deviance (mean squared error)
#>>>> for sure the variance is increasing