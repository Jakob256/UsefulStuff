#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#### copy for importing this script ####
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# if(!require("devtools")){install.packages("devtools")}
# library(devtools)
# source_url("https://raw.githubusercontent.com/Jakob256/UsefulStuff/main/UsefulStuff.R")


#~~~~~~~~~~~~~~
#### pause ####
#~~~~~~~~~~~~~~


.pause <- function(filePath){
  if (file.exists(filePath)){
    i=0
    symbols=c("-","\\","|","/")
    cat(rep("-",47),"\n",sep="")
    time=as.character(Sys.time())
    
    while(file.exists(filePath)){
      i=i%%4+1
      
      cat("\r",rep(symbols[i],3)," Process paused    @ ",time," ",rep(symbols[i],3),sep="")
      Sys.sleep(1)
      
    }
    
    cat("\r--- Process paused    @ ",time," ---\n",sep="")
    time=as.character(Sys.time())
    cat("\r--- Process continued @ ",time," ---\n",sep="")
    cat(rep("-",47),"\n",sep="")
  }
}


#~~~~~~~~~~~~~~~~~~
#### .progress ####
#~~~~~~~~~~~~~~~~~~


.progPar <<- as.data.frame(matrix(0,ncol=5))
colnames(.progPar)=c("progressStartTime","lastInfo","setType","totalLength","done")



.progressStart <- function(totalLength){
  time=round(as.numeric(Sys.time()))
  .progPar$totalLength<<-totalLength
  .progPar$done<<- -1
  .progPar$progressStartTime<<- time
  .progPar$lastInfo<<- time
  .progPar$setType<<- "blindCounter"
  cat("Blind counter started\n\n")
}


.progress<- function(whereNow=NULL,setInfo1=NULL,setInfo2=NULL){
  if (is.null(whereNow)){.progPar$done <<- .progPar$done+1} ## no input at all -> we have a blind Counter

  time=round(as.numeric(Sys.time()))
  if (time==.progPar$lastInfo){return()} ##quick escape - since anyway no update necessary
  
  
  ## check if the loop has just started:
  justStarted=F
  if (!is.null(whereNow)){ ## if is null -> blind Counter -> not necessary to check if started
    if (is.null(setInfo2)){ ## no second info
      if (length(setInfo1)==1){ ## only endpoint given
        if (whereNow==1){justStarted=T}
      } else { ##set is given
        if (whereNow==setInfo1[1]){justStarted=T}
      }
    } else { ## there is a second info
      if (whereNow==setInfo1[1]){justStarted=T}
    }
  }
  
  
  ## initialize and store stuff if just started
  
  if (justStarted){
    .progPar$progressStartTime<<-time
    .progPar$lastInfo<<-time
    
    if (is.null(setInfo2)){ ## no second info
      if (length(setInfo1)==1){ ## only endpoint given
        .progPar$setType<<-"singleElement"
        .progPar$totalLength<<-setInfo1
      } else {                  ## set given
        .progPar$setType<<-"set"
        .progPar$totalLength<<-length(setInfo1)
      }
    } else {
      .progPar$setType<<-"doubleElement"
      .progPar$totalLength<<- setInfo2-setInfo1+1
    }
    
    cat("progress update started\n\n")
  }
  
  
  
  if (time>.progPar$lastInfo){##one sec has passed; lets give an update
    ## calculate how many iterations done:
    
    if (.progPar$setType=="singleElement"){
      done=whereNow-1
    } else if (.progPar$setType=="doubleElement"){
      done=whereNow-setInfo1
    } else if (.progPar$setType=="set"){
      done=which(whereNow==setInfo1)-1
    } else if (.progPar$setType=="blindCounter"){
      done=.progPar$done
    }
    
    remaining=.progPar$totalLength-done
    
    remainingTime=(.progPar$totalLength-done)*(time-.progPar$progressStartTime)/done
    #  nrStillRemaining   *   passedTime  /  how many already
    
    remainingTime=round(remainingTime)
    
    ## calculate sec, min and h
    
    remainingSec=remainingTime%%60
    remainingMin=floor((remainingTime%%3600)/60)
    remainingH=floor(remainingTime/3600)
    
    # make 4:3 min -> 4:03 min
    if (remainingTime>=60){remainingSec=paste(rep("0",2-nchar(remainingSec)),remainingSec,sep="")}
    if (remainingTime>=3600){remainingMin=paste(rep("0",2-nchar(remainingMin)),remainingMin,sep="")}
    if (remainingTime<60){
      cat("Remaining: ",remainingSec," sec;  (",done,"/",.progPar$totalLength,")\r",sep="")
    } else if (remainingTime<3600){
      cat("Remaining: ",remainingMin,":",remainingSec," min;  (",done,"/",.progPar$totalLength,")\r",sep="")
    } else {
      cat("Remaining: ",remainingH,":",remainingMin,":",remainingSec," h;  (",done,"/",.progPar$totalLength,")\r",sep="")
    }
    
    .progPar$lastInfo<<-time
  }
}
