
# date: 05/11/2020
# author: VB
# purpose: create csv files for each OPM management agent

library(tidyverse)

#wd <- "~/CRAFTY-opm" # sandbox VM
wd <- "~/eclipse-workspace/CRAFTY_RangeshiftR/data_LondonOPM/"

agentProdFilepath <- paste0(wd,"production/de-regulation/")
agentBehavFilepath <- paste0(wd,"agents/V4/")

# define Production levels for Services (0-1, low-high)
# and sensitivity of Production to each capital (0-1, low-high)

# V2 - change to just 1 no management agents, tweak sensitivities and production
# V3 - remove medium intensity agent, remove management service
# V4 - remove sensitivity of no management agent to risk perception/budget/knowledge
#      1:1 service production might be making dynamics harder to control. Test going back to changing production levels for low and high intensity management agents


# no management
Service <- c("biodiversity","recreation")
Production <- c(1,1) # if no OPM, assume maximum amount of Services can be produced
#OPMpresence <- c(0,0) # not relianct on presence
OPMinverted <- c(0.9,0.9) # but if OPM present and unable to manage, bio and recreation provision compromised maximum amount
riskPerc <- c(0,0) # no reliance on risk perception
budget <- c(0,0) # no reliance on budget
knowledge <- c(0,0) # no reliance on knowledge
nature <- c(1,0) # Production of biodiversity fully reliant on nature capital level, 1:1
access <- c(0,1) # Production of recreation fully reliant on access capital level, 1:1

no.mgmt <- tibble(Service,OPMinverted,riskPerc,budget,knowledge,nature,access,Production)
view(no.mgmt)
write.csv(no.mgmt, paste0(agentProdFilepath,"no_mgmt.csv"), row.names=F)

# no management (unable)
#Service <- c("biodiversity","recreation","management")
#Production <- c(0.4,0.4,0) # if OPM present but no management, Service provision compromised
#OPMpresence <- c(1,1,1) # should only appear when OPM is present 
#riskPerc <- c(0,0,0) # no reliance
#budget <- c(0,0,0) # no reliance 
#knowledge <- c(0,0,0) # no reliance
#nature <- c(1,0,0) # Production of biodiversity dependent on nature capital
#access <- c(0,1,0) # Production of recreation dependent on access capital

#no.mgmt.unable <- tibble(Service,OPMpresence,riskPerc,budget,knowledge,nature,access,Production)
#write.csv(no.mgmt.unable, paste0(agentProdFilepath,"no_mgmt_unable.csv"), row.names=F)

# manage (low intensity)
Service <- c("biodiversity","recreation")
Production <- c(1,0.5) # focus is on biodiversity, so provides maximum amount - recreation compromised by reduced access
#OPMpresence <- c(1,1) # should only appear/manage when OPM is present 
OPMinverted <- c(0,0) # service provision compromised by OPM presence, but less so due to management
riskPerc <- c(0.5,0.5) # lower risk perceptions, skeptical about human health impacts, worried about biodiversity. does lower sensitivity to risk capital achieve this?
budget <- c(0.5,0.5) # some budget required
knowledge <- c(1,1) # management requires knowledge
nature <- c(1,0) # Production of biodiversity dependent on nature capital
access <- c(0,1) # Production of recreation dependent on access capital

mgmt.low <- tibble(Service,OPMinverted,riskPerc,budget,knowledge,nature,access,Production)
view(mgmt.low)
write.csv(mgmt.low, paste0(agentProdFilepath,"mgmt_lowInt.csv"), row.names=F)

# remove this agent for now
# manage (med intensity)
#Service <- c("biodiversity","recreation","management")
#Production <- c(0.6,0.6,0.9) # attempting balance of objectives
#OPMpresence <- c(0,0,1) # should only appear when OPM is present 
#OPMinverted <- c(0,0,0)
#riskPerc <- c(0,0,0.5) # medium risk perception
#budget <- c(0,0,0.5) # requires more budget for spraying etc. 
#knowledge <- c(0,0,0.8) # management requires knowledge
#nature <- c(1,0,0) # Production of biodiversity dependent on nature capital
#access <- c(0,1,0) # Production of recreation dependent on access capital

#mgmt.med <- tibble(Service,OPMpresence,OPMinverted,riskPerc,budget,knowledge,nature,access,Production)
#write.csv(mgmt.med, paste0(agentProdFilepath,"mgmt_medInt.csv"), row.names=F)

# manage (high intensity)
Service <- c("biodiversity","recreation")
Production <- c(0.5,1) # focus is on reducing risk to public health and allowing continued access
#OPMpresence <- c(1,1) # should only appear when OPM is present 
OPMinverted <- c(0,0) # service provision compromised by OPM presence, but less so due to management
riskPerc <- c(1,1) # this kind of management only possible where risk perceptions...
budget <- c(1,1) # and budget are high
knowledge <- c(1,1) # management requires knowledge
nature <- c(1,0) # Production of biodiversity dependent on nature capital
access <- c(0,1) # Production of recreation dependent on access capital

mgmt.high <- tibble(Service,OPMinverted,riskPerc,budget,knowledge,nature,access,Production)
view(mgmt.high)
write.csv(mgmt.high, paste0(agentProdFilepath,"mgmt_highInt.csv"), row.names=F)


##### Agent behavioural parameter files

aftParamId <- 0
givingInDistributionMean <- 0
givingInDistributionSD <- 0
givingUpDistributionMean <- 0
givingUpDistributionSD <- 0
serviceLevelNoiseMin <- 1
serviceLevelNoiseMax <- 1
givingUpProb <- 0
productionCsvFile <- ".//production/%s/no_mgmt.csv"
params0 <- tibble(aftParamId,givingInDistributionMean,givingInDistributionSD,givingUpDistributionMean,givingUpDistributionSD,
                  serviceLevelNoiseMin,serviceLevelNoiseMax,givingUpProb,productionCsvFile)
write.csv(params0, paste0(agentBehavFilepath,"AftParams_no_mgmt.csv"), row.names=F)

#aftParamId <- 0
#givingInDistributionMean <- 0
#givingInDistributionSD <- 0
#givingUpDistributionMean <- 0
#givingUpDistributionSD <- 0
#serviceLevelNoiseMin <- 1
#serviceLevelNoiseMax <- 1
#givingUpProb <- 0
#productionCsvFile <- ".//production/%s/no_mgmt_unable.csv"
#params1 <- tibble(aftParamId,givingInDistributionMean,givingInDistributionSD,givingUpDistributionMean,givingUpDistributionSD,
 #                 serviceLevelNoiseMin,serviceLevelNoiseMax,givingUpProb,productionCsvFile)
#write.csv(params1, paste0(agentBehavFilepath,"AftParams_no_mgmt_unable.csv"), row.names=F)

aftParamId <- 0
givingInDistributionMean <- 0
givingInDistributionSD <- 0
givingUpDistributionMean <- 0
givingUpDistributionSD <- 0
serviceLevelNoiseMin <- 1
serviceLevelNoiseMax <- 1
givingUpProb <- 0
productionCsvFile <- ".//production/%s/mgmt_lowInt.csv"
params2 <- tibble(aftParamId,givingInDistributionMean,givingInDistributionSD,givingUpDistributionMean,givingUpDistributionSD,
                  serviceLevelNoiseMin,serviceLevelNoiseMax,givingUpProb,productionCsvFile)
write.csv(params2, paste0(agentBehavFilepath,"AftParams_mgmt_lowInt.csv"), row.names=F)

#aftParamId <- 0
#givingInDistributionMean <- 0
#givingInDistributionSD <- 0
#givingUpDistributionMean <- 0
#givingUpDistributionSD <- 0
#serviceLevelNoiseMin <- 1
#serviceLevelNoiseMax <- 1
#givingUpProb <- 0
#productionCsvFile <- ".//production/mgmt_medInt.csv"
#params3 <- tibble(aftParamId,givingInDistributionMean,givingInDistributionSD,givingUpDistributionMean,givingUpDistributionSD,
 #                 serviceLevelNoiseMin,serviceLevelNoiseMax,givingUpProb,productionCsvFile)
#write.csv(params3, paste0(agentBehavFilepath,"AftParams_mgmt_medInt.csv"), row.names=F)

aftParamId <- 0
givingInDistributionMean <- 0
givingInDistributionSD <- 0
givingUpDistributionMean <- 0
givingUpDistributionSD <- 0
serviceLevelNoiseMin <- 1
serviceLevelNoiseMax <- 1
givingUpProb <- 0
productionCsvFile <- ".//production/%s/mgmt_highInt.csv"
params4 <- tibble(aftParamId,givingInDistributionMean,givingInDistributionSD,givingUpDistributionMean,givingUpDistributionSD,
                  serviceLevelNoiseMin,serviceLevelNoiseMax,givingUpProb,productionCsvFile)
write.csv(params4, paste0(agentBehavFilepath,"AftParams_mgmt_highInt.csv"), row.names=F)

##### Also capitals, Services index tables, + demand

# Capitals
Name <- c("OPMinverted","riskPerc","budget","knowledge","nature","access")
Index <- c(0,1,2,3,4,5)
Capitals <- tibble(Name,Index)
write.csv(Capitals, paste0(wd,"csv/Capitals.csv"), row.names=F)

# Services
Name <- c("biodiversity","recreation")
Index <- c(0,1)
Services <- tibble(Name,Index)
write.csv(Services, paste0(wd,"csv/Services.csv"), row.names=F)

# Demand

# run CRAFTY for a single timestep and use biodiversity and recreation supply values as initial demand
# set management demand relative to the values for bio and rec - but higher so that it takes priority
Year <- c(1,2,3,4,5,6,7,8,9,10)
bio <- 10490.667 #12000 # inital supply V4 = 11,412
biodiversity <- seq(11000, 11900, 100)
rec <- 6304 #8000 # inital supply V4 = 7,224
recreation <- seq(7000, 7900, 100)
# increase initial demand to see if it drives change
#management <- 12000 # set so that it is higher than bio, taking priority
Demand <- tibble(Year,biodiversity,recreation)
write.csv(Demand, paste0(wd,"worlds/baseline/Demand.csv"), row.names=F)

bio/10000
rec/10000
