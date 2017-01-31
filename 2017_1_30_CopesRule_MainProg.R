install.packages('ape')
install.packages('phytools')
install.packages('paleotree')

require(ape)
require(phytools)
require(paleotree)

source('~/Dropbox/ungulate_RA/RCode/2017_1_30_CopesRule_Source_Func.R', chdir = TRUE) #call cource file for functions

#sources for Jon Marcot's code and specimen measurements 
source("https://dl.dropbox.com/s/8jy9de5owxj72p7/strat.R")
source("https://dl.dropbox.com/s/253p4avcvb66795/occFns.R")
source("https://dl.dropbox.com/s/9gdafsqss2b586x/phy_dateTree.R")
source("https://dl.dropbox.com/s/9tdawj35qf502jj/amandaSrc.R")
source("https://dl.dropbox.com/s/rlof7juwr2q4y77/blasto_Birlenbach.R")

tree_base <- read.nexus("~/Dropbox/ungulate_RA/NAUngulata_Trees/BackBoneTrees/2017_1_25_UngulataBackBone")
tree_base
class(tree_base)

clade_sp <- read.csv("~/Dropbox/ungulate_RA/2017_1_26_Clade_species.csv", stringsAsFactors = FALSE)
clade_sp

#clade_sp <- read.csv("C:/Users/Evan/Dropbox/ungulate_RA/2017_1_26_Clade_species.csv",stringsAsFactors = FALSE)
#clade_sp

MCRA_Codes <- read.csv("~/Dropbox/ungulate_RA/2017_1_26_MCRA_Codes.csv", stringsAsFactors = FALSE)
MCRA_Codes

#MCRA_Codes <- read.csv("C:/Users/Evan/Dropbox/ungulate_RA/2017_1_26_MCRA_Codes.csv", stringsAsFactors = FALSE)
#MCRA_Codes <- read.csv("C:/Users/Evan/Dropbox/ungulate_RA/2017_1_26_MCRA_Codes_Laptop.csv", stringsAsFactors = FALSE) #for calling tree files on Evan's laptop
#MCRA_Codes

#place funciton to request number of iterations

#iter <- as.numeric(iterations()) #select number of iterations to run

reps <- 10

#tree.list <- list()
tree.list <- replicate(n = reps,expr = tree_resolution(backbone_tree = tree_base,Species_file = clade_sp,MRCA_file = MCRA_Codes))
tree.list
class(tree.list)


#Date tree
occs <- read.csv("http://paleobiodb.org/data1.2/occs/list.csv?base_name=Artiodactyla,Perissodactyla&continent=NOA&max_ma=66&min_ma=0&timerule=overlap&show=full&limit=all", stringsAsFactors=TRUE, strip.white=TRUE)

#occs <- appendTaxonNames1.2(occs, taxonomic.level="species", keep.indet=TRUE)

tree_dated <- list()
tree_dated <- lapply (X = tree.list, FUN = date_tree, occs) #need to swap LO and FO column headers
#tree_dated <- replicate(n = reps, expr = date_tree)

class(tree_dated)

#Approximate Sampling Rate
freqRat(timeData = ranges,plot=TRUE)
SPres <- getSampProbDisc()
SPres
sRate <-sProb2sRate(SPres[[0]][], int.legnth=meanInt)


#will call cal3 next
cal3TimePaleoPhy(tree, timeData, brRate, extRate, sampRate, ntrees = 1, anc.wt = 1, node.mins = NULL, dateTreatment = "firstLast", FAD.only = FALSE, adj.obs.wt = TRUE, root.max = 200, step.size = 0.1, randres = FALSE, noisyDrop = TRUE, tolerance = 1e-04, diagnosticMode = FALSE, plot = FALSE)

tree_cal <- bin_cal3TimePaleoPhy(tree = tree_dated, timeData = ranges, brRate = ranges$FO, extRate = ranges$LO, sampRate, ntrees = reps, anc.wt = 1, node.mins = NULL, dateTreatment = "firstLast", FAD.only = FALSE, adj.obs.wt = TRUE, root.max = 200, step.size = 0.1, randres = FALSE, noisyDrop = TRUE, tolerance = 1e-04, diagnosticMode = FALSE, plot = FALSE)