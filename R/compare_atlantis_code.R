#' Function to track differences in Atlantis code versions
#' Inputs: atlantis code versions
#' Outputs: Plots of biomass, numbers, weight at age, RN and SN; 
#' Outputs: csv files of biomass and numbers
#' @author Hem Nalini Morzaria Luna
#' @date Last edited May 2024
#' 

# List of packages for session
.packages = c("diffr", "dplyr","here")

# List revisions
#svn log -v  -l 2 https://svnserv.csiro.au/svn/ext/atlantis/Atlantis/trunk --username XXX --password XXX
  

# Install CRAN packages (if not already installed)
.inst <- .packages %in% installed.packages()
if(length(.packages[!.inst]) > 0) install.packages(.packages[!.inst])

# Load packages into session 
lapply(.packages, require, character.only=TRUE)

oldcodepath <- "~/trunk_6715/atlantis"
newcodepath <- "~/trunk_6716/atlantis"

old.ver <- "6715"
new.ver <- "6716"

output.txt <- paste0("atlantis_code_comp_",old.ver,"-",new.ver, ".txt")
file.create(output.txt)

compare_code <- function(oldcodepath, newcodepath){
  
# code.files <-  list.files(newcodepath, pattern = "*.*", full.names = FALSE, recursive = TRUE)
 code.files <-  list.files(newcodepath, pattern = "*.c$", full.names = FALSE, recursive = TRUE)
 
 system("sudo apt-get install moreutils", wait = TRUE)
 
 cat(paste("Versions compared", new.ver, old.ver), file= output.txt, append = FALSE)
 
 for(eachcodefile in code.files){
   
   print(eachcodefile)
   
   cat("", file = output.txt, append = TRUE, sep="\n")  # Add an empty line for spacing
   
   cat("FILE COMPARED", file= output.txt, append = TRUE)
   cat("", file = output.txt, append = TRUE, sep="\n")  # Add an empty line for spacing
   cat(eachcodefile, file= output.txt, append = TRUE)
   cat("", file = output.txt, append = TRUE, sep="\n")  # Add an empty line for spacing
    
   #system(paste0("diff -u ", paste0(newcodepath,"/", eachcodefile)," ", paste0(oldcodepath,"/",eachcodefile), " >> ", output.txt), wait = TRUE)
   system(paste0("diff -a --suppress-common-lines -y ", paste0(newcodepath,"/",eachcodefile)," ", paste0(oldcodepath,"/",eachcodefile), " >> ", output.txt), wait = TRUE)
   cat("", file = output.txt, append = TRUE)  # Add an empty line for spacing
   cat("", file = output.txt, append = TRUE)  # Add an empty line for spacing
 }
  
}


compare_code(oldcodepath, newcodepath)

#To further compare specific files using the GUI
file.new <- paste0(newcodepath,"/atecology/atdemography.c")
file.old <- paste0(oldcodepath,"/atecology/atdemography.c")

library("diffr")

diffr(file1 = file.old, file2 = file.new, contextSize = 3, minJumpSize = 10, wordWrap = TRUE, width = NULL, height = NULL)
