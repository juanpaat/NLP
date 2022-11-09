# NLP
This is a repo of the [Data Science specialisation for the Johns Hopkins University](https://www.coursera.org/specializations/jhu-data-science). The goal of this project is to build a predictiong model that find the next word given an inputted text.  

Find the App in [here!](https://juanbiodata.shinyapps.io/WordPredictor/)

## Word Predictor  
**Word Predictor** takes an imput and try to predict which are the next more likely 5 words based on a corpus of collected data from twitter, blogs and new. The prediction also gives an score round to six decimals which basically says how likely the word appear given the inputted words. If there are no input or there are no matches at all, the prediction will be just the most common words of the English languages, such as the, to, a, and, of, among others.  

## How to use **Word Predictor**  
To use **Word Predictor** you just need to type the text you want to use to predict the next word and choose the number of word you want the algorithm to predict. It is recommended to use at least three words, but not necessary. Then in the main panel you will see your input together with the predicted word in bold. You will also see the list of the other words that are likely to follow your inputted text.

## The Algorithm 
The assumption that the probability of a word depends only on the previous word is called a Markov assumption. Markov models are the class of probabilistic models that assume we can predict the probability of some future unit without looking too far into the past.
This app uses the **Backoff algorithm**, that is based on the Markov assumption. This assigns probabilities (scores) to each possible next word by calculating the frequency of a pair of word and then divided it into the frequency of the previous first word. 
Gram talks about the words in a specific text. In this case we used a 3-Gram model, which mean that the next word predicted depends on the last 3 words inputted to the App. If the corpus or data doesn’t find a match, then it take the last 2-Gram (last 2 words) and try to find matches to calculate the scores and so on. If there are not matches it will just return the most common words of the English language.

## The Data
The Corpus of this project could be found [here](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip)  

The corpora are collected from publicly available sources by a web crawler. The crawler checks for language, so as to mainly get texts consisting of the desired language.  
Each entry is tagged with it's date of publication. Where user comments are included they will be tagged with the date of the main entry.  
Each entry is tagged with the type of entry, based on the type of website it is collected from (e.g. newspaper or personal blog) If possible, each entry is tagged with one or more subjects based on the title or keywords of the entry (e.g. if the entry comes from the sports section of a newspaper it will be tagged with "sports" subject).In many cases it's not feasible to tag the entries (for example, it's not really practical to tag each individual Twitter entry, though I've got some ideas which might be implemented in the future) or no subject is found by the automated process, in which case the entry is tagged with a '0'.

# Links
- Github [Repo](https://github.com/juanpaat/NLP) with the code used to create the App.  
- [Word Predictor](https://juanbiodata.shinyapps.io/WordPredictor/) app.

## References
- [N-gram Language Models - Speech and Language Processing by Daniel Jurafsky & James H. Martin.](https://web.stanford.edu/~jurafsky/slp3/3.pdf)   
- [Introduction to the tm Package - Text Mining in R by Ingo Feinerer](https://cran.r-project.org/web/packages/tm/vignettes/tm.pdf)  
- [Regular Expressions, Text Normalization, Edit Distance by Daniel Jurafsky & James H. Martin.](https://web.stanford.edu/~jurafsky/slp3/2.pdf)  
- [Shiny R Studio tutorial - Build a user interface.](https://shiny.rstudio.com/tutorial/written-tutorial/lesson2/) 


