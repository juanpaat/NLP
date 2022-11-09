library(shiny)
library(tidytext)
library(dplyr)
library(NLP)
library(tm)

# Load the data
Data1 <- read.csv("1Gram.csv")
Data2 <- read.csv('2Grams.csv')
Data3 <- read.csv("3Grams.csv")
Data4 <- read.csv("4Grams.csv")
URLprofanity <- url("https://raw.githubusercontent.com/LDNOOBW/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words/master/en")
profanity <- read.csv(URLprofanity,header = F)
profanity <- as.vector(profanity[,1])




#################################
Algoritmo <-function(x){
  x <- tolower(x)
  x <- strsplit(x, " ")
  x <- unlist(x)
  l <- length(x)
  if (l>=3){
    input <- removeNumbers(removePunctuation(paste(x[l - 2],
                                                   x[l - 1],
                                                   x[l])))
    input2 <- removeNumbers(removePunctuation(paste(x[l - 1],
                                                    x[l])))
    input1 <- removeNumbers(removePunctuation(x[l]))
  }else if (l>=2){
    input <- removeNumbers(removePunctuation(paste(x[l - 1],
                                                   x[l])))
    input2 <- removeNumbers(removePunctuation(x[l]))
    input1 <- NULL
  } else {
    input2 <- NULL
    input1 <- NULL
    input <- removeNumbers(removePunctuation(x))
  }
  input <- (c(input, input2 , input1))
  if (length(input)==3){
    if (any(input[1] %in% Data4$word)) {
      predicted <- Data4$word4[input[1] == Data4$word]
      frequency <- Data4$n[input[1] == Data4$word]
      predicted2 <- Data3$word3[input[2] == Data3$word]
      frequency2 <- Data3$n[input[2] == Data3$word]
      predicted3 <- Data2$word2[input[3] == Data2$word1]
      frequency3 <- Data2$n[input[3] == Data2$word1]
      frequency4 <- Data1$n
      score <- frequency/sum(frequency2)
      score2 <- frequency2/sum(frequency3)
      score3 <-  frequency3/sum(frequency4)
      predicion = c(predicted,predicted2,predicted3)
      frequency <- c(frequency,frequency2,frequency3)
      score <- c(score,score2,score3)
    } else if (input[2] %in% Data3$word) {
      predicted <- Data3$word3[input[2] == Data3$word]
      frequency <- Data3$n[input[2] == Data3$word] 
      predicted2 <- Data2$word2[input[3] == Data2$word1]
      frequency2 <- Data2$n[input[3] == Data2$word1]
      frequency3 <- Data1$n
      score <- frequency/sum(frequency2)
      score2 <- frequency2/sum(frequency3)
      predicion = c(predicted,predicted2)
      frequency <- c(frequency,frequency2)
      score <- c(score, score2)
    } else if (input[3] %in% Data2$word1) {
      predicted <- Data2$word2[input[3] == Data2$word1]
      frequency <- Data2$n[input[3] == Data2$word1] 
      frequency2 <- Data1$n
      score <- frequency/sum(frequency2)
      predicion = c(predicted)
      frequency <- c(frequency)
      score <- c(score)
    } else {
      predicion <- Data1$word
      frequency <- Data1$n
      score <- frequency/sum(Data1$n)
    }
  } else if (length(input)==2){
    if (input[1] %in% Data3$word) {
      predicted <- Data3$word3[input[1] == Data3$word]
      frequency <- Data3$n[input[1] == Data3$word] 
      predicted2 <- Data2$word2[input[2] == Data2$word1]
      frequency2 <- Data2$n[input[2] == Data2$word1]
      frequency3 <- Data1$n
      score <- frequency/sum(frequency2)
      score2 <- frequency2/sum(frequency3)
      predicion = c(predicted,predicted2)
      frequency <- c(frequency,frequency2)
      score <- c(score, score2)
    } else if (input[2] %in% Data2$word1) {
      predicted <- Data2$word2[input[2] == Data2$word1]
      frequency <- Data2$n[input[2] == Data2$word1] 
      frequency2 <- Data1$n
      score <- frequency/sum(frequency2)
      predicion = c(predicted)
      frequency <- c(frequency)
      score <- c(score)
    } else {
      predicion <- Data1$word
      frequency <- Data1$n
      score <- frequency/sum(Data1$n)
    }
  }else { 
    if(input[1] %in% Data2$word1) {
      predicted <- Data2$word2[input[1] == Data2$word1]
      frequency <- Data2$n[input[1] == Data2$word1] 
      frequency2 <- Data1$n
      score <- frequency/sum(frequency2)
      predicion = c(predicted)
      frequency <- c(frequency)
      score <- c(score)
    } else {
      predicion <- Data1$word
      frequency <- Data1$n
      score <- frequency/sum(Data1$n)
    }
    
  }
  Top10 <-data.frame(Predicion =  predicion,
                     frequency = frequency,
                     Score = score)
  
  Top10 <- Top10 %>%
    group_by(Predicion)%>%
    summarise( Score = sum(Score)) %>%
    arrange(desc(Score))
  
  Top10 <- Top10[complete.cases(Top10),]
  return(Top10)
}

#################################


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
      output$text2 <- renderText({
        paste("<br>", input$text,"<b>" , Algoritmo(input$text)[1,1] , "</b>","</br>", sep = " ")
      })
      
    output$table <- renderTable({
      Algoritmo(input$text)[1:input$slider1,]
    },digits=6)
    
})
