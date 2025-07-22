library(here)
library(svDialogs)
library(readr)
library(signal)
library(ggplot2)
library(gganimate)

## Use R's GUI to pick the file you're going to analyse 
## To do: vectorise the code to plot and save however many files the user selects. 
## Also perhaps to have sampling rate and units of measurement as inputs? 
## See https://r4ds.had.co.nz/iteration.html

myFile <- dlg_open(
  title = "Please pick the file you want to analyse",
  multiple = FALSE,
  filters = dlg_filters[c("txt", "All"), ],
  gui = .GUI
)

# Get the base file name (not including directory) and strip off the file extension 
fName <- basename(myFile$res)

Name1 <- tools::file_path_sans_ext(fName[1])
#Name2 <- tools::file_path_sans_ext(fName[2])

# Read in the file (this works for .txt even though it says csv)
swayFile1 <- read_csv(myFile$res[1], col_names = TRUE)
#swayFile2 <- read_csv(myFile$res[2], col_names = TRUE)
# Use "decimate" function from signal toolbox to downsample data from 200 Hz to 50 Hz 
# (need to use 20 if data are at 1000 Hz)
ML = swayFile1$COPx
ML = ML - mean(ML[1:1000])
AP = swayFile1$COPy
AP = AP - mean(AP[1:1000])

ML_EC <- decimate(ML, 20)
AP_EC <- decimate(AP, 20)

#ML_EO <- decimate(swayFile2$COPx, 20)
#AP_EO <- decimate(swayFile2$COPy, 20)
# Convert to mm for nicer plots (this assumes data are in m - make it 100 for cm)
AP_EC_mm <- AP_EC*1000
ML_EC_mm <- ML_EC*1000

#AP_EO_mm <- AP_EO*1000
#ML_EO_mm <- ML_EO*1000


# Get max and min values for axes 
xmax <- max(ML_EC_mm)
xmin <- min(ML_EC_mm)
ymax <- max(AP_EC_mm)
ymin <- min(AP_EC_mm)



#xmax_EO <- max(ML_EO_mm)
#xmin_EO <- min(ML_EO_mm)
#ymax_EO <- max(AP_EO_mm)
#ymin_EO <- min(AP_EO_mm)

# work out range for each axis 
xRange <- xmax-xmin
yRange <- ymax-ymin

rangeDiff <- yRange - xRange 

#xRange_EO <- xmax_EO-xmin_EO
#yRange_EO <- ymax_EO-ymin_EO
# Get the difference 
#rangeDiff_EO <- yRange_EO - xRange_EO 

# Adjust so axes are equal lengths 
if (rangeDiff >0){
  xmax <- xmax+rangeDiff/2
  xmin <- xmin-rangeDiff/2
} else{
  ymax <- ymax+rangeDiff/2
  ymin <- ymin-rangeDiff/2   
}

#if (rangeDiff_EO >0){
#  xmax_EO <- xmax_EO+rangeDiff_EO/2
#  xmin_EO <- xmin_EO-rangeDiff_EO/2
#} else{
#  ymax_EO <- ymax_EO+rangeDiff_EO/2
#  ymin_EO <- ymin_EO-rangeDiff_EO/2   
#}

# Make time vector 
ms <- 1:length(AP_EC_mm)

#ms_EO <- 1:length(AP_EO_mm)
# Compile into data frame 
df_sway <- data.frame(AP_EC_mm, ML_EC_mm, ms)

#df_sway_EO <- data.frame(AP_EO_mm, ML_EO_mm, ms_EO)

# Make plot and animate it 
p1 <- ggplot(df_sway, aes(x = ML_EC_mm, y = AP_EC_mm)) + 
  geom_point(colour = "red", size = .5) + theme_classic()+
  transition_time(ms)+ 
  theme(text = element_text(size=14)) +
  shadow_mark(past = T, future=F, alpha=0.3) +
  xlim(xmin, xmax)+
  ylim(ymin,ymax)+ 
  coord_fixed(ratio = 1)+
  theme(plot.title = element_text(hjust = 0.5))+
  labs(title = paste("Sway animation", Name1, sep = " "), 
       x = "ML sway (mm)", 
       y = "AP sway (mm)")
a_gif <- animate(p1, width = 350, height = 350, detail = 20, fps = 20)
a_gif

saveFname <- paste("SwayAnimation_", Name1, ".gif", sep = "")
anim_save(saveFname)

#p2 <- ggplot(df_sway_EO, aes(x = ML_EO_mm, y = AP_EO_mm)) + 
#  geom_point(colour = "red", size = .5) + theme_classic()+
#  transition_time(ms_EO)+ 
#  theme(text = element_text(size=14)) +
#  shadow_mark(past = T, future=F, alpha=0.3) +
#  xlim(xmin_EO, xmax_EO)+
#  ylim(ymin_EO,ymax_EO)+ 
#  coord_fixed(ratio = 1)+
#  theme(plot.title = element_text(hjust = 0.5))+
#  labs(title = paste("Sway animation", Name2, sep = " "), 
##       x = "ML sway (mm)", 
#       y = "AP sway (mm)")
#b_gif <- animate(p2, width = 350, height = 350)
#b_gif

# Save as a .gif 


#saveFname2 <- paste("SwayAnimation_", Name2, ".gif", sep = "")
#anim_save(saveFname2)
