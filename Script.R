setwd("~/Documents/Data Science/Capstone project")


# the packages are loaded
library(tidyverse)
library(tidytext)
library(tm)
library(stringi)
library(ggwordcloud)


URLprofanity <- url("https://raw.githubusercontent.com/LDNOOBW/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words/master/en")
profanity_words <- read.csv(URLprofanity,header = F)
profanity_words <- as.vector(profanity_words[,1])



#Load the data 
blogs <- readLines( "en_US/en_US.blogs.txt", encoding = "UTF-8", skipNul = TRUE)
news <- readLines( "en_US/en_US.news.txt", encoding = "UTF-8", skipNul= TRUE)
twitter <- readLines('en_US/en_US.twitter.txt', encoding = "UTF-8", skipNul = TRUE)


#Split the data per indentation \n
blogs_splitted <- strsplit(x = blogs,split ="\n")
twitter_splitted <- strsplit(x = twitter,split ="\n")
news_splitted <- strsplit(x = news,split ="\n")

head(blogs_splitted)
head(twitter_splitted_vector)

#Convert Lists into vectors
twitter_splitted_vector <- unlist(twitter_splitted)

news_splitted_vector <-  unlist(news_splitted)

blogs_splitted_vector <-  unlist(blogs_splitted)


max(nchar(twitter_splitted_vector))    #Valor maximo de carateres de twitter
max(nchar(news_splitted_vector))       #Valor maximo de carateres de news
max(nchar(blogs_splitted_vector))      #Valor maximo de carateres de blogs

#
sum(grepl("love",x= twitter_splitted_vector))/sum(grepl("hate",x= twitter_splitted_vector))

twitter_splitted_vector[grepl("biostats",x= twitter_splitted_vector)]


sum(grepl('A computer once beat me at chess, but it was no match for me at kickboxing',
          x= twitter_splitted_vector))



## randomly select 30% of the lines from the blogs data
set.seed(1996)
blogs_sample <- blogs[rbinom(length(blogs) * 0.3, length(blogs), 0.5)]
writeLines(blogs_sample, con="blogsSample.txt")

set.seed(1996)
news_sample <- news[rbinom(length(news) * 0.3, length(news), 0.5)]
writeLines(news_sample, con="blogsSample.txt")

set.seed(1996)
twitter_sample <- twitter[rbinom(length(twitter) * 0.3, length(twitter), 0.5)]
writeLines(twitter_sample, con="blogsSample.txt")


################### Twitter ################

# tokenaization and removing the sto words, then sorting the output

word_freq_tw <-as.data.frame(twitter_sample) %>%
  unnest_tokens(output = 'word',
                input = twitter_sample,
                token = 'words') %>%
  anti_join(stop_words)%>%
  count(word , sort = T)%>%
  filter(word %in% removeNumbers(word))%>%
  filter(!(word %in% profanity_words)) 

# show the first 100 words
ggplot(word_freq_tw[1:100,])+
  geom_bar(aes(x=reorder(word, -n) , y = n),stat="identity")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))


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


# Plot over
ggplot(word_freq_tw[1:100,])+
  geom_bar(aes(x=reorder(word, -n) , y = n),stat="identity")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))


################### Blogs ################

# tokenaization and removing the sto words, then sorting the output
word_freq_bl <-as.data.frame(blogs_sample) %>%
  unnest_tokens(output = 'word',
                input = blogs_sample,
                token = 'words') %>%
  anti_join(custom)%>%
  count(word , sort = T)%>%
  filter(word %in% removeNumbers(word))%>%
  filter(!(word %in% profanity_words))

# show the first 100 words
ggplot(word_freq_bl[1:100,])+
  geom_bar(aes(x=reorder(word, -n) , y = n),stat="identity")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))




################### News ################

# tokenaization and removing the sto words, then sorting the output
word_freq_nw <-as.data.frame(news_sample) %>%
  unnest_tokens(output = 'word',
                input = news_sample,
                token = 'words') %>%
  anti_join(custom)%>%
  count(word , sort = T)%>%
  filter(word %in% removeNumbers(word))%>%
  filter(!(word %in% profanity_words))

# show the first 100 words
ggplot(word_freq_nw[1:100,])+
  geom_bar(aes(x=reorder(word, -n) , y = n),stat="identity")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))


################### 3 datasets together ########################
#  concat tables

head(word_freq_tw)
head(word_freq_bl)
head(word_freq_nw)

## adding them together and sorting by their frequency
all_data_freq <- rbind(word_freq_tw,word_freq_bl,word_freq_nw)
all_data_freq$word <- gsub('^im$', "i'm" ,all_data_freq$word)
all_data_freq$word <- gsub('^ya$', "you" ,all_data_freq$word)

all_data_freq <- all_data_freq%>%
  group_by(word)%>%
  summarise(n = sum(n))%>%
  arrange(desc(n))


# Plot of the whole text
ggplot(all_data_freq[1:50,])+
  geom_bar(aes(x=reorder(word, n) , y = n),stat="identity")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  coord_flip()



###################

mean(word_freq_tw$word %in% word_freq_nw$word)
mean(word_freq_tw$word %in% word_freq_bl$word)

mean(word_freq_nw$word %in% word_freq_tw$word)
mean(word_freq_nw$word %in% word_freq_bl$word)

mean(word_freq_bl$word %in% word_freq_nw$word)
mean(word_freq_bl$word %in% word_freq_tw$word)





#############  2 grams ##################
#### twitter
word_freq_tw_2 <-as.data.frame(twitter_sample) %>%
  unnest_tokens(output = 'word',
                input = twitter_sample,
                token = "ngrams" , n = 2) %>%
  separate(word, c("word1", "word2"), sep = " ")

word_freq_tw_2 <- word_freq_tw_2%>%
  filter(!(word1 %in% profanity_words))%>%
  filter(!(word2 %in% profanity_words))%>%
  filter(!is.na(word1)) %>% 
  filter(!is.na(word2))%>%
  unite(word, word1, word2, sep=" ")%>%
  count(word , sort = T)

  

######

# show the first 100 words
ggplot(word_freq_tw_2[1:50,])+
  geom_bar(aes(x=reorder(word, n) , y = n),stat="identity")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  coord_flip()


#### blogs
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


#### news
word_freq_nw_2 <-as.data.frame(news_sample) %>%
  unnest_tokens(output = 'word',
                input = news_sample,
                token = "ngrams" , n = 2) %>%
  count(word , sort = T)


# show the first 100 words
ggplot(word_freq_nw_2[1:50,])+
  geom_bar(aes(x=reorder(word, -n) , y = n),stat="identity")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  coord_flip()




############# 3 grams ##################
#### twitter
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


# show the first 100 words
ggplot(word_freq_tw_3[1:50,])+
  geom_bar(aes(x=reorder(word, n) , y = n),stat="identity")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  coord_flip()


#### blogs
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
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  coord_flip()


#### news
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
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  coord_flip()

