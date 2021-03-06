
# date: 05/11/2020
# author: VB
# description: collate all capital data processed in other scripts and write to a single test region csv for CRAFTY

library(tidyverse)
library(ggplot2)
library(sf)

#dirData <- "C:/Users/vanessa.burton/OneDrive - Forest Research/Documents/R/CRAFTY-OPM"
dirData <- "~/CRAFTY-opm" # sandbox VM
scenario <- "de-regulation"
dirCapitals <- sprintf("~/eclipse-workspace/CRAFTY_RangeshiftR/data_LondonOPM/worlds/LondonBoroughs/%s", scenario)


### baseline -------------------------------------------------------------------

# load in capital files
natural <- sf::st_read(paste0(dirData,"/data-processed/capitals/hexG_bio_access.shp"))
social <- st_read(paste0(dirData,"/data-processed/capitals/hexG_social.shp"))

# merge
social <- social %>% st_drop_geometry()
TestRegion <- merge(natural,social,by="joinID")

# add empty OPM presence column for now
TestRegion$OPMpresence <- 0

# row and column ids for hex
# extract geometry into x and y
TestRegion <- TestRegion %>%
  mutate(Long = st_coordinates(st_centroid(.))[,1],
         Lat = st_coordinates(st_centroid(.))[,2]) %>% 
  st_drop_geometry()

# check plot
ggplot(TestRegion)+
  geom_raster(aes(Long,Lat,fill=nature))+
  coord_cartesian(xlim = c(525000, 527500),ylim = c(180000, 182500))
# issues with gaps.
# due to hexagonal grid.
# have to re-do with regular grid?

# rasterise
library(raster)
TRxyz <- TestRegion[,c(11,12,4)]
rstTestRegion <- rasterFromXYZ(TRxyz)  #Convert first two columns as lon-lat and third as value                
plot(rstTestRegion)

# where 'type' is non-greenspace, mask out/remove from CRAFTY?
TestRegion <- TestRegion %>%
  filter(type != "Non.greenspace") 
TestRegion %>%
  ggplot()+
  geom_tile(aes(Long,Lat,fill=type))


# cell id and lat long
ids <- TestRegion[,c(1,11,12)]
head(ids)
write.csv(ids, paste0(dirData,"/data-processed/for-CRAFTY/Cell_ID_LatLong.csv"), row.names = F )


# initial agent allocation - no management everywhere
TestRegion$Agent <- "no_mgmt"

# edit order of columns and write to csv
head(TestRegion)
head(TestRegion[,c(1,11,12,13,10,6,8,9,2,3)])
TestRegion <- TestRegion[,c(1,11,12,13,10,6,8,9,2,3)]

# make NAs 0 for CRAFTY?
TestRegion[is.na(TestRegion)] <- 0

TestRegion %>%
  ggplot()+
  geom_tile(aes(Long,Lat,fill=riskPerc))

write.csv(TestRegion, paste0(dirData,"/data-processed/for-CRAFTY/LondonBoroughs_latLong.csv"), row.names = F)

write.csv(TestRegion, paste0(dirData,"/data-processed/for-CRAFTY/TestRegion.csv"), row.names = F)

# round coordinates to 1 decimal place for CRAFTY
TestRegion <- read.csv(paste0(dirData,"/data-processed/for-CRAFTY/LondonBoroughs.csv"))
summary(TestRegion$X)
TestRegion$X <- round(TestRegion$X, digits=2)
TestRegion$Y <- round(TestRegion$Y, digits=2)
summary(TestRegion)
TestRegion[,5:10] <- round(TestRegion[,5:10], digits = 2)
summary (TestRegion)

TestRegion <- tibble::rowid_to_column(TestRegion, "id")

write.csv(TestRegion, paste0(dirData,"/data-processed/for-CRAFTY/LondonBoroughs.csv"), row.names = F)

### baseline updater file -----------------------------------------------

dirCRAFTYInput <- path.expand(paste0(dirWorking, "/data_LondonOPM/"))
capitals <- read.csv(paste0(dirCRAFTYInput,"worlds/LondonBoroughs/LondonBoroughs_XY.csv"), header = T, sep = ",")
head(capitals)
#write.csv(capitals, paste0(dirCRAFTYInput,"worlds/LondonBoroughs/LondonBoroughs_XY.csv"),row.names = F)

capitals$OPMinverted <- 1 # OPM nowhere
capitals$knowledge <- 0 # knowledge nowhere
write.csv(capitals, paste0(dirCRAFTYInput,"worlds/LondonBoroughs/LondonBoroughs_XY.csv"),row.names = F)

updaterFiles <- capitals[1:8]
head(updaterFiles)

updaterFiles$OPMinverted <- 1
updaterFiles$knowledge <- 0
head(updaterFiles)
summary(updaterFiles)

ticks <- c(1,2,3,4,5,6,7,8,9,10)

for (i in ticks){
  
  #tick <- ticks[1]
  write.csv(updaterFiles, paste0(dirCRAFTYInput,"worlds/LondonBoroughs/LondonBoroughs_XY_tstep_",i,".csv") ,row.names = FALSE)
  
}





### de-regulation --------------------------------------------------------------

