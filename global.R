library(Vennerable)
library(RColorBrewer)
library(colourpicker)
library(shiny)
library(shinyjs)
library(shinythemes)

options(shiny.maxRequestSize = 2*1024^2) # Max upload size is 2Mbp
options(shiny.launch.browser = TRUE)

#################################
# Color functions
#################################

colorify <- function(val, cols){
  #remaps native Vennerable color map
  orig <- c("#FFEDA0", "#FEB24C","#F03B20")
  new <- cols
  val <- new[val == orig]; return(val)
}

colorify2 <- function(val, cols, inters1, inters2){
  #change color of isolated sets
  val[grep("#FFEDA0", val)] <- cols
  #change color of overlaps
  val[grep("#FEB24C", val)] <- inters1
  val[grep("F03B20", val)] <- inters2
  return(val)
}

# clean empty values
clean <- function(x){as.character(x[x!=""])}

#################################
# Main function
#################################

venner <- function(x, weighted, fontsize, labelsize, lwd,
                   lwcol, lty, lbcol,
                   colorify, cols, fontcol, inters1, inters2){

  # very sketchy library info here:http://rpackages.ianhowson.com/rforge/Vennerable/
  
  # x is a list with named sets of (overlapping) elements
  
  V <- Venn(x)
  VC <- compute.Venn(V, doWeights = weighted)
  gp <- VennThemes(VC, colourAlgorithm = "signature")
  
  # change circles line color, type and width
  for(s in names(gp[['Set']])){
    gp[["Set"]][[s]]$col = lwcol
    gp[["Set"]][[s]]$lty = lty
    gp[["Set"]][[s]]$lwd = lwd
  }

  # change size of text inside circle
  for(s in names(gp[['FaceText']])){
    gp[["FaceText"]][[s]]$fontsize = fontsize
    ## TESTING
    gp[["FaceText"]][[s]]$col = fontcol
  }

  # change color and size of labels
  for(s in names(gp[['SetText']])){
    gp[["SetText"]][[s]]$col = lbcol
    gp[["SetText"]][[s]]$fontsize = labelsize
  }

  if(colorify == 'mono'){
    # change circle color by re-mapping with Colorbrewer using colorify()
    for(s in names(gp[['Face']])){
      gp[["Face"]][[s]]$fill = colorify(gp[["Face"]][[s]]$fill, cols = cols)
    }
  }

  if(colorify == 'multiple'){
    # change circle color by re-mapping with Colorbrewer using colorify2()
    origcols <- c()
    for(s in 1:length(gp[['Face']])){
      origcols[s] <- gp[["Face"]][[s]]$fill
    }

    newcols <- colorify2(origcols, cols = cols, inters1, inters2)

    for(s in 1:length(gp[['Face']])){
      gp[["Face"]][[s]]$fill <- newcols[s]
    }
  }

  plot(VC, gpList = gp, show = list(Universe = FALSE))
}
