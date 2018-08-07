#Note
# 1. change the rmd name to data_analyst_nanodegree_term_02_project_02_redwine_eda_r_005.Rmd
# 2. in rmd global options, include the file name as path as below
#```{r global_options, include=FALSE}
#
#knitr::opts_chunk$set(fig.path = 'images/data_analyst_nanodegree_term_02_project_02_redwine_eda_r_005/',echo = FALSE, 
#                      warning = FALSE, message = FALSE)
#
#
#```
#3. Edit line 32 of this file and run this file

require(knitr)
require(markdown)
#knit('test.rmd', 'test.md') # creates md file
#markdownToHTML('test.md', 'test.html') # creates html file

#create a webpage folder
mkdirs <- function(fp) {
  if(!file.exists(fp)) {
    mkdirs(dirname(fp))
    dir.create(fp)
  }
} 

#make the directory
mkdirs("git_page")

#Enter these values
#rmd_file_name<-'RedWineEDA_v03.Rmd' #name of the rmd file
# REMEMBER EXTENSION is XXX.Rmd, not xxx.rmd
rmd_file_name<-'data_analyst_nanodegree_term_02_project_02_redwine_eda_r_005.Rmd'
#image_subfolder_name<-'redwine_eda' #name of the subfolder inside images folder
image_subfolder_name<-gsub(".Rmd","",rmd_file_name) #remove the .Rmd extension
md_file_name<-gsub("Rmd","md",rmd_file_name)# replace .Rmd with md



#knit the md file
#knit('RedWineEDA_v03.Rmd', 'git_page/RedWineEDA_v03.md') # creates md file
knit(rmd_file_name, paste('git_page/',md_file_name,sep = ''))


#copy image files to git_page directory
#from.dir <- "images/redwine_eda"
from.dir <-paste('images/',image_subfolder_name,sep = '')

#create a subfolder in git_page>>images>>image_subfolder_name
#mkdirs("git_page/images")
mkdirs(paste('git_page/images/',image_subfolder_name,sep=''))


#to.dir   <- "git_page/images/"
to.dir   <- paste('git_page/images/',image_subfolder_name,sep='')

#save paths to all the image files
files    <- list.files(path = from.dir, full.names = TRUE, recursive = TRUE)

#iterate and save files to images subfolder in git_page folder
for (f in files) file.copy(from = f, to = to.dir)

#delete the images directory
unlink('images', recursive = TRUE)

