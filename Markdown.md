---
title: "EDA"
author: "Juan P. Alzate"
date: '2022-09-30'
output: 
        html_document:
         keep_md: yes
---




```r
setwd("~/Documents/Data Science/Capstone project")
# the packages are loaded
library(tidyverse)
```

```
## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──
```

```
## ✓ ggplot2 3.3.3     ✓ purrr   0.3.4
## ✓ tibble  3.1.1     ✓ dplyr   1.0.6
## ✓ tidyr   1.1.3     ✓ stringr 1.4.0
## ✓ readr   1.4.0     ✓ forcats 0.5.1
```

```
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```

```r
library(tidytext)
library(tm)
```

```
## Loading required package: NLP
```

```
## 
## Attaching package: 'NLP'
```

```
## The following object is masked from 'package:ggplot2':
## 
##     annotate
```

```r
library(ggwordcloud)
library(wordcloud)
```

```
## Loading required package: RColorBrewer
```



```r
URLprofanity <- url("https://raw.githubusercontent.com/LDNOOBW/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words/master/en")
profanity_words <- read.csv(URLprofanity,header = F)
profanity_words <- as.vector(profanity_words[,1])
```




```r
#Load the data 
setwd('..')
blogs <- readLines( "en_US/en_US.blogs.txt", encoding = "UTF-8", skipNul = TRUE)
news <- readLines( "en_US/en_US.news.txt", encoding = "UTF-8", skipNul= TRUE)
twitter <- readLines('en_US/en_US.twitter.txt', encoding = "UTF-8", skipNul = TRUE)
```



```r
#Split the data per indentation \n
blogs_splitted <- strsplit(x = blogs,split ="\n")
twitter_splitted <- strsplit(x = twitter,split ="\n")
news_splitted <- strsplit(x = news,split ="\n")
```




```r
#Convert Lists into vectors
twitter_splitted_vector <- unlist(twitter_splitted)

news_splitted_vector <-  unlist(news_splitted)

blogs_splitted_vector <-  unlist(blogs_splitted)


max(nchar(twitter_splitted_vector))    #Valor maximo de carateres de twitter
```

```
## [1] 140
```

```r
max(nchar(news_splitted_vector))       #Valor maximo de carateres de news
```

```
## [1] 11384
```

```r
max(nchar(blogs_splitted_vector))      #Valor maximo de carateres de blogs
```

```
## [1] 40833
```


## Respuestas quiz

```r
sum(grepl("love",x= twitter_splitted_vector))/sum(grepl("hate",x= twitter_splitted_vector))
```

```
## [1] 4.108592
```

```r
twitter_splitted_vector[grepl("biostats",x= twitter_splitted_vector)]
```

```
## [1] "i know how you feel.. i have biostats on tuesday and i have yet to study =/"
```

```r
sum(grepl('A computer once beat me at chess, but it was no match for me at kickboxing',
          x= twitter_splitted_vector))
```

```
## [1] 3
```


## randomly select 30% of the lines from the blogs data

```r
set.seed(1996)
blogs_sample <- blogs[rbinom(length(blogs) * 0.3, length(blogs), 0.5)]
writeLines(blogs_sample, con="blogsSample.txt")

set.seed(1996)
news_sample <- news[rbinom(length(news) * 0.3, length(news), 0.5)]
writeLines(news_sample, con="blogsSample.txt")

set.seed(1996)
twitter_sample <- twitter[rbinom(length(twitter) * 0.3, length(twitter), 0.5)]
writeLines(twitter_sample, con="blogsSample.txt")
```





# Twitter

## Tokenaization and removing the sto words, then sorting the output

```r
word_freq_tw <-as.data.frame(twitter_sample) %>%
  unnest_tokens(output = 'word',
                input = twitter_sample,
                token = 'words') %>%
  anti_join(stop_words)%>%
  count(word , sort = T)%>%
  filter(word %in% removeNumbers(word))%>%
  filter(!(word %in% profanity_words)) 
```

```
## Joining, by = "word"
```

```r
# adding some more words to the stop_words tipple
custom <- stop_words
useless_words <- c('rt', 'lol', 'haha' , 'hahaha' ,
                   'yeah' , 'hey' , 'omg' , 'ya')
custom <- add_row(custom, word= useless_words, lexicon = 'custom')


# run it again but insted of stop words with the cusmtumised stop words
word_freq_tw <-as.data.frame(twitter_sample) %>%
  unnest_tokens(output = 'word',
                input = twitter_sample,
                token = 'words') %>%
  anti_join(custom)%>%
  count(word , sort = T)%>%
  filter(word %in% removeNumbers(word))%>%
  filter(!(word %in% profanity_words)) 
```

```
## Joining, by = "word"
```

```r
word_freq_tw$word <- gsub('^im$', "i'm" ,word_freq_tw$word)
word_freq_tw$word <- gsub('^ya$', "you" ,word_freq_tw$word)


# show the first 100 words
set.seed(1996)
wordcloud(words = word_freq_tw$word,
          freq = word_freq_tw$n,min.freq=3482,
          max.words=Inf, random.order=FALSE,
          colors=brewer.pal(8, "Dark2"))
```

![](Markdown_files/figure-html/unnamed-chunk-8-1.png)<!-- -->



# Blogs  

# tokenaization and removing the sto words, then sorting the output

```r
word_freq_bl <-as.data.frame(blogs_sample) %>%
  unnest_tokens(output = 'word',
                input = blogs_sample,
                token = 'words') %>%
  anti_join(custom)%>%
  count(word , sort = T)%>%
  filter(word %in% removeNumbers(word))%>%
  filter(!(word %in% profanity_words))
```

```
## Joining, by = "word"
```

```r
# show the first 100 words
ggplot(word_freq_bl[1:100,])+
  geom_bar(aes(x=reorder(word, -n) , y = n),stat="identity")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
```

![](Markdown_files/figure-html/unnamed-chunk-9-1.png)<!-- -->





# News
# tokenaization and removing the sto words, then sorting the output

```r
# tokenaization and removing the sto words, then sorting the output
word_freq_nw <-as.data.frame(news_sample) %>%
  unnest_tokens(output = 'word',
                input = news_sample,
                token = 'words') %>%
  anti_join(custom)%>%
  count(word , sort = T)%>%
  filter(word %in% removeNumbers(word))%>%
  filter(!(word %in% profanity_words))
```

```
## Joining, by = "word"
```

```r
# show the first 100 words
ggplot(word_freq_nw[1:100,])+
  geom_bar(aes(x=reorder(word, -n) , y = n),stat="identity")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
```

![](Markdown_files/figure-html/unnamed-chunk-10-1.png)<!-- -->






# 3 datasets together 
##  concat tables  

```r
## adding them together and sorting by their frequency
all_data_freq <- rbind(word_freq_tw,word_freq_bl,word_freq_nw)
all_data_freq <- all_data_freq%>%
  group_by(word)%>%
  summarise(n = sum(n))%>%
  arrange(desc(n))

all_data_freq$word <- gsub('^im$', "i'm" ,all_data_freq$word)
all_data_freq$word <- gsub('^ya$', "you" ,all_data_freq$word)

# Plot of the whole text
ggplot(all_data_freq[1:50,])+
  geom_bar(aes(x=reorder(word, n) , y = n),stat="identity")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  coord_flip()
```

![](Markdown_files/figure-html/unnamed-chunk-11-1.png)<!-- -->





# Important information

```r
mean(word_freq_tw$word %in% word_freq_nw$word)
```

```
## [1] 0.5061579
```

```r
mean(word_freq_tw$word %in% word_freq_bl$word)
```

```
## [1] 0.509893
```

```r
mean(word_freq_nw$word %in% word_freq_tw$word)
```

```
## [1] 0.3177037
```

```r
mean(word_freq_nw$word %in% word_freq_bl$word)
```

```
## [1] 0.4613484
```

```r
mean(word_freq_bl$word %in% word_freq_nw$word)
```

```
## [1] 0.4682917
```

```r
mean(word_freq_bl$word %in% word_freq_tw$word)
```

```
## [1] 0.3248649
```






# 2 grams
## twitter

```r
word_freq_tw_2 <-as.data.frame(twitter_sample) %>%
  unnest_tokens(output = 'word',
                input = twitter_sample,
                token = "ngrams" , n = 2) %>%
  separate(word, c("word1", "word2"), sep = " ")%>%
  filter(!(word1 %in% profanity_words))%>%
  filter(!(word2 %in% profanity_words))%>%
  filter(!is.na(word1)) %>% 
  filter(!is.na(word2))%>%
  unite(word, word1, word2, sep=" ")%>%
  count(word , sort = T)

# show the first 100 words
ggplot(word_freq_tw_2[1:50,])+
  geom_bar(aes(x=reorder(word, n) , y = n),stat="identity")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  coord_flip()
```

![](Markdown_files/figure-html/unnamed-chunk-13-1.png)<!-- -->



  

## Blogs

```r
word_freq_bl_2 <-as.data.frame(blogs_sample) %>%
  unnest_tokens(output = 'word',
                input = blogs_sample,
                token = "ngrams" , n = 2) %>%
  separate(word, c("word1", "word2"), sep = " ")%>%
  filter(!(word1 %in% profanity_words))%>%
  filter(!(word2 %in% profanity_words))%>%
  filter(!is.na(word1)) %>% 
  filter(!is.na(word2))%>%
  unite(word, word1, word2, sep=" ")%>%
  count(word , sort = T)


# show the first 100 words
ggplot(word_freq_bl_2[1:50,])+
  geom_bar(aes(x=reorder(word, n) , y = n),stat="identity")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  coord_flip()
```

![](Markdown_files/figure-html/unnamed-chunk-14-1.png)<!-- -->





## News

```r
word_freq_nw_2 <-as.data.frame(news_sample) %>%
  unnest_tokens(output = 'word',
                input = news_sample,
                token = "ngrams" , n = 2) %>%
  separate(word, c("word1", "word2"), sep = " ")%>%
  filter(!(word1 %in% profanity_words))%>%
  filter(!(word2 %in% profanity_words))%>%
  filter(!is.na(word1)) %>% 
  filter(!is.na(word2))%>%
  unite(word, word1, word2, sep=" ")%>%
  count(word , sort = T)


# show the first 100 words
ggplot(word_freq_nw_2[1:50,])+
  geom_bar(aes(x=reorder(word, n) , y = n),stat="identity")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  coord_flip()
```

![](Markdown_files/figure-html/unnamed-chunk-15-1.png)<!-- -->






# 3 grams  
## twitter

```r
word_freq_tw_3 <-as.data.frame(twitter_sample) %>%
  unnest_tokens(output = 'word',
                input = twitter_sample,
                token = "ngrams" , n = 3) %>%
  separate(word, c("word1", "word2", "word3"), sep = " ")%>%
  filter(!(word1 %in% profanity_words))%>%
  filter(!(word2 %in% profanity_words))%>%
  filter(!(word3 %in% profanity_words))%>%
  filter(!is.na(word1)) %>% 
  filter(!is.na(word2))%>%
  filter(!is.na(word3)) %>% 
  unite(word, word1, word2, word3, sep=" ")%>%
  count(word , sort = T)
```

# show the first 100 words
ggplot(word_freq_tw_3[1:50,])+
  geom_bar(aes(x=reorder(word, n) , y = n),stat="identity")+
  coord_flip()


## Blogs

```r
word_freq_bl_3 <-as.data.frame(blogs_sample) %>%
  unnest_tokens(output = 'word',
                input = blogs_sample,
                token = "ngrams" , n = 3) %>%
  separate(word, c("word1", "word2", "word3"), sep = " ")%>%
  filter(!(word1 %in% profanity_words))%>%
  filter(!(word2 %in% profanity_words))%>%
  filter(!(word3 %in% profanity_words))%>%
  filter(!is.na(word1)) %>% 
  filter(!is.na(word2))%>%
  filter(!is.na(word3)) %>% 
  unite(word, word1, word2, word3, sep=" ")%>%
  count(word , sort = T)


# show the first 100 words
ggplot(word_freq_bl_3[1:50,])+
  geom_bar(aes(x=reorder(word, n) , y = n),stat="identity")+
  coord_flip()
```

![](Markdown_files/figure-html/unnamed-chunk-17-1.png)<!-- -->




## News

```r
word_freq_nw_3 <-as.data.frame(news_sample) %>%
  unnest_tokens(output = 'word',
                input = news_sample,
                token = "ngrams" , n = 3) %>%
  separate(word, c("word1", "word2", "word3"), sep = " ")%>%
  filter(!(word1 %in% profanity_words))%>%
  filter(!(word2 %in% profanity_words))%>%
  filter(!(word3 %in% profanity_words))%>%
  filter(!is.na(word1)) %>% 
  filter(!is.na(word2))%>%
  filter(!is.na(word3)) %>% 
  unite(word, word1, word2, word3, sep=" ")%>%
  count(word , sort = T)

# show the first 100 words
ggplot(word_freq_nw_3[1:50,])+
  geom_bar(aes(x=reorder(word, n) , y = n),stat="identity")+
  coord_flip()
```

![](Markdown_files/figure-html/unnamed-chunk-18-1.png)<!-- -->





