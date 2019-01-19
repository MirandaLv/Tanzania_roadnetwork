
library("gdistance")
set.seed(123)

# road raster
rdrst_dir <- "/Users/miranda/Documents/AidData/projects/Tanzania/dataset/roads/TanRoad_raster/tanRoad_rst.tif"

# slope raster (geoquery raw file)
slprst_dir <- "/Users/miranda/Documents/AidData/projects/Tanzania/dataset/roads/TanRoad_raster/TAN_SRTM_500m_slp_factor.tif"
# elevation
elerst_dir <- "/Users/miranda/Documents/AidData/projects/Tanzania/dataset/roads/TanRoad_raster/TAN_SRTM_500m_ele_factor.tif"
# landcover speed
lcrst_dir <- "/Users/miranda/Documents/AidData/projects/Tanzania/dataset/roads/TanRoad_raster/tan_esalc_speed.tif"
railrd_dir <- "/Users/miranda/Documents/AidData/projects/Tanzania/dataset/roads/TanRoad_raster/tanRailrd_rst.tif"

# create a transition layer based on road
tan_rdrst <- raster(rdrst_dir)
#tr1 <- transition(asFactor(tan_rdrst), transitionFunction=mean, directions=8)
#tr1C <- geoCorrection(tr1,type="c") # create a corrected transition layer tr1C

start <- as.numeric(Sys.time())

# create a transition layer based on slope
tan_slprst <- raster(slprst_dir)
# resample slope raster to be same with road raster
tan_slprst_res <- raster(nrow=nrow(tan_rdrst),ncol=ncol(tan_rdrst),xmn=xmin(tan_rdrst), xmx=xmax(tan_rdrst), ymn=ymin(tan_rdrst),ymx=ymax(tan_rdrst),crs=crs(tan_rdrst))
tan_slprst_res <- resample(tan_slprst,tan_slprst_res,method='bilinear')
tr2 <- transition(tan_slprst_res, transitionFunction=mean, directions=8)
tr2C <- geoCorrection(tr2,type="c")
# type="c" means the cost correction is done in east-west direction, this is used for least-cost walk
# type='r' for random walks, not only distance distortion plays a role, but also surface distortion
# distance calculated as great-circle distance for latlong grids


# create a transition layer based on elevation
tan_elerst <- raster(elerst_dir)
# resample slope raster to be same with road raster
tan_elerst_res <- raster(nrow=nrow(tan_rdrst),ncol=ncol(tan_rdrst),xmn=xmin(tan_rdrst), xmx=xmax(tan_rdrst), ymn=ymin(tan_rdrst),ymx=ymax(tan_rdrst),crs=crs(tan_rdrst))
tan_elerst_res <- resample(tan_elerst,tan_elerst_res,method='bilinear')
tr3 <- transition(tan_elerst_res, transitionFunction=mean, directions=8)
tr3C <- geoCorrection(tr3,type="c")

# create a transition layer based on land cover
tan_lcrst <- raster(lcrst_dir)
tan_lcrst_res <- raster(nrow=nrow(tan_rdrst),ncol=ncol(tan_rdrst),xmn=xmin(tan_rdrst), xmx=xmax(tan_rdrst), ymn=ymin(tan_rdrst),ymx=ymax(tan_rdrst),crs=crs(tan_rdrst))
tan_lcrst_res <- resample(tan_lcrst,tan_lcrst_res,method='bilinear')
tr4 <- transition(tan_lcrst_res, transitionFunction=mean, directions=8)
tr4C <- geoCorrection(tr4,type="c")

# create a transition layer based on rail road
tan_railrdrst <- raster(railrd_dir)
tan_railrdrst_res <- raster(nrow=nrow(tan_rdrst),ncol=ncol(tan_rdrst),xmn=xmin(tan_rdrst), xmx=xmax(tan_rdrst), ymn=ymin(tan_rdrst),ymx=ymax(tan_rdrst),crs=crs(tan_rdrst))
tan_railrdrst_res <- resample(tan_railrdrst,tan_railrdrst_res,method='bilinear')
tr5 <- transition(tan_railrdrst_res, transitionFunction=mean, directions=8)
tr5C <- geoCorrection(tr5,type="c")



#plot(raster(tr1C),main="raster(tr1C)",xlab="Longitude (degrees)",ylab="Latitude (degrees)")

# set sample points sP1 and sP2
sP <- cbind(runif(100,30,40),runif(100,-10,-1))

#pts1<-SpatialPoints(cbind(x=30,y=-2))
#pts2<-SpatialPoints(cbind(x=37,y=-3))


#test1<-costDistance(tr1C, sP1) #
#test2<-commuteDistance(tr1C, sP1) # calculate resistance distance between points
#test3<-rSPDistance(tr1C, sP1, sP1, theta=1e-12, totalNet="total") # randomized shortest path, back and forth

cdist <- costDistance(tr2C,sP)
#rSPDistance(tr1[[1]], pts1, pts2, theta=1e-12, totalNet="total")
end <- as.numeric(Sys.time())

timediff <- end - start






