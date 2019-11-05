#load arules package
library(arules)
#Since the a priori algorithm requires categorical predictors, let us 
#discard the numeric columns and also change the one logical column to 
#categorical.
tunnel.data <- read.delim(file.choose(), stringsAsFactors=TRUE)
head(tunnel.data)
tun <- tunnel.data[,-(1:2)] #get rid of unique IDs 

tun <- tun[,sapply(tun, class) == "factor"] #keep just factors

tun.trans <- as(tun, "transactions") #tabular to transactional format

#Now we can begin to see some of the building blocks of the algorithms:

#shows each categorical level's frequency  
itemFrequencyPlot(tun.trans, topN=20)

#shows frequent itemsets (antecedents) with support 0.4;
eclat (tun.trans,parameter= list (support=0.4))

#if you forget to save a result you can use .Last.value (temp memory file)
#to retrieve and save.
sets <- .Last.value
inspect (sets[1])
inspect (sort(sets)[1])


#Now that we know there are 25 itemsets (antecedents) we runs the apriori 
#algorithm with support = 0.4 and minimum length 2 (two antecedents). 
#You get 18 rules resulting. Use inspect to look at the rules
trules <- apriori (tun.trans, parameter=list (minlen=2, support=0.4))
inspect(trules[1:18])

#load maps library
#R has a library of maps that is surprisingly sophisticated (for the 
#continental US). Let's start R and read in the data into an object named tun.
#Now check out these commands:
library(maps)

map ("county", "california")
map ("county", "california,monterey", add=T, col="red", fill=T) 

map ("county", c("california", "arizona"))
map ("county", c("california,san diego", "california,imperial"), add=T, col="red")
map ("county", c("arizona,yuma", "arizona,pima", "arizona,santa cruz", "arizona,cochise"), col="red", add=T)

#multiplying by -1 to get West longitudes)
points (-1 * tunnel.data$East, tunnel.data$North, col="blue") # The tunnels plotted!

identify(tunnel.data)

