.LastInfo<<-0

.progress<- function(whereNow,setInfo1,setInfo2=NULL){
  time=round(as.numeric(Sys.time()))
  if (time==.LastInfo){return()} ##chick escape

  ## check if the loop has just started:
  justStarted=F
  if (is.null(setInfo2)){ ## no second info
    if (length(setInfo1)==1){ ## only endpoint given
      if (whereNow==1){justStarted=T}
    } else { ##set is given
      if (whereNow==setInfo1[1]){justStarted=T}
    }
  } else { ## there is a second info
    if (whereNow==setInfo1[1]){justStarted=T}
  }

  
  ## initialize and store stuff if just started
  if (justStarted){
    .ProgressStartTime<<-time
    .LastInfo<<-time
    
    if (is.null(setInfo2)){ ## no second info
      if (length(setInfo1)==1){ ## only endpoint given
        .setType<<-"singleElement"
        .totalLength<<-setInfo1
      } else {                  ## set given
        .setType<<-"set"
        .totalLength<<-length(setInfo1)
      }
    } else {
      .setType<<-"doubleElement"
      .totalLength<<- setInfo2-setInfo1+1
    }
    cat("progress update started\n\n")
  }
  
  
  if (time>.LastInfo){##one sec has passed; lets give an update
    ## calculate how many iterations done:
    if (.setType=="singleElement"){
      done=whereNow-1 
    } else if (.setType=="doubleElement"){
      done=whereNow-setInfo1
    } else if (.setType=="set"){
      done=which(whereNow==setInfo1)
    }
    remaining=.totalLength-done
    
    
    remainingTime=(.totalLength-done)*(time-.ProgressStartTime)/done
    #  nrStillRemaining   *   passedTime  /  how many already
    remainingTime=round(remainingTime)
    if (remainingTime<60){
      cat("Remaining:",remainingTime,"secs;  (",done,"/",.totalLength,")\n")
    } else {
      cat("Remaining:",floor(remainingTime/60),":",remainingTime%%60,"min;  (",done,"/",.totalLength,")\n")
    }
    .LastInfo<<-time
  }
}




for (i in 1:300){
  .progress(i,300)
  Sys.sleep(1)
  ## stuff here
}

for (i in 1:300){
  .progress(i,1,300)
  Sys.sleep(1)
  ## stuff here
}

for (n in LETTERS){
  .progress(n,LETTERS)
  Sys.sleep(1)
  ## stuff here
}

# you might pass 
#1) the set
#2) the endpoint of the set (assuming start=1)
#3) the start and endpoint of the set

# simply pass it in chronological order
