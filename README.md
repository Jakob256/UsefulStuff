# Useful functions for time-intensive programs

## .pause: provides a tool to efficiently pause a running script
Description: pause(filePath) sleeps as long as filePath exists

         for (i in 1:10){print(i); pause("myProject/a.txt")}
         
           [1] 1
           [1] 2
           [1] 3
           [1] 4
           -----------------------------------------------
           --- Process paused    @ 2022-10-27 14:32:02 ---
           --- Process continued @ 2022-10-27 15:55:06 ---
           -----------------------------------------------
           [1] 5
           [1] 6
           [1] 7
           [1] 8
           [1] 9
           [1] 10

## .progress: provides a tool for giving progress updates in loops

Usage 1: Loops, starting at 0 or 1

         for (i in 1:10) {*Your Code*; .progress(i,10)}

Usage 2: Loops, starting at other values
         
         for (i in 10:20){*Your Code*; .progress(i,10,20)}

Usage 3: Loops over sets

         for (i in LETTERS){*Your Code*; .progress(i,LETTERS)}

Usage 4: Loops over sets (alternative)

        .progressStart(length(Set))
         for (i in Set){*Your Code*; .progress()}
         
Usage 5: when dealing with loops inside loops and known number of total iterations:

         n=100
         .progressStart(n*(n+1)/2)
         for (k in 1:n){
           for (j in k:n){
             .progress()
             *Your Code*
           }
         }
