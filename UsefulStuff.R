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
      cat("Remaining: ",remainingSec," sec;  (",done,"/",.progPar$totalLength,")\n",sep="")
    } else if (remainingTime<3600){
      cat("Remaining: ",remainingMin,":",remainingSec," min;  (",done,"/",.progPar$totalLength,")\n",sep="")
    } else {
      cat("Remaining: ",remainingH,":",remainingMin,":",remainingSec," h;  (",done,"/",.progPar$totalLength,")\n",sep="")
    }
    
    .progPar$lastInfo<<-time
  }
}




if(FALSE){
  f <- function(){Sys.sleep(0.1)}
  g <- function(){Sys.sleep(1)}
  h <- function(){Sys.sleep(2)}
  
  for (i in 1:362){
    .progress(i,362)
    ## stuff here
    g()
  }
  
  for (i in 101:400){
    .progress(i,101,400)
    ## stuff here
    f()
  }
  
  for (n in LETTERS){
    .progress(n,LETTERS)
    f()
    ## stuff here
  }
  
  .progressStart(20*21/2)
  for (i in 1:20){
    for (j in i:20){
      .progress()
      g()
    }
  }
}


# you may pass

#1) the set
#2) the endpoint of the set (assuming start=1)
#3) the start and endpoint of the set
#4) nothing at all



# simply pass it in chronological order
