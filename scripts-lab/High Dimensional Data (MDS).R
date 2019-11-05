#
## Graphical Representation of Multivariate Data
#

head(state.x77)
stars(state.x77)
stars(state.x77,draw.seg=T)

library(MASS)
parcoord(state.x77)
parcoord(state.x77, col=c(1:50))

index<-row.names(state.x77)=="California"
index
parcoord(state.x77,col=c("light grey","red")[index+1]) # index+1 >>> 0 ve 1'i 1 ve 2 yaptik
#sadece california yi sectik

state.clusters<-kmeans(scale(state.x77),4)  #4 cluster i hoca once denemis
#our data icludes miles, population vs different things>>>
#we need to scale to deal with wide ranges
names(state.clusters)
state.clusters$cluster
col<-c("green","dodger blue","red", "yellow")[state.clusters$cluster]
col
parcoord(state.x77,col=col)

#
## Metric Multidimensional Scaling and Interactive plots
#
state.mds <- cmdscale (dist (scale(state.x77)))
state.mds ## mapped our .. .into two dimensions
plot (state.mds, type = "n")
text (state.mds, state.abb,col=col)

Now install and load the very cool rgl library. This library will allow us to plot in 3 dimensions and to rotate the plot. You can take “movies” of the plots, play them back etc.

state.mds <- cmdscale (dist (scale(state.x77)), k = 3)
library(rgl)
open3d()
plot3d(state.mds,type="n")
text3d(state.mds,text=state.abb,col=col)

###Projection Pursuit
library (tourr)
animate_xy(scale(state.x77),guided_tour(index=holes),col=col)
