library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
    # Application title
    titlePanel(h1("Word Predictor",  h4("by Juan P. Alzate"))),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
          textInput("text", h4("Text used to predict"), 
                    value = ""),
          
          helpText("Note: Type the text you want to use to predict the next word. It is recommended to use at least three words, but ", strong("not"), "necessary."),
          
          sliderInput("slider1", h4("Number of words to predict"),
                      min = 5, max = 10, value = 1),  
          HTML('<center><img src="logo-removebg.png", height = 120, width = 180></center>')
        ),
       # img(src = "logo-removebg.png",height = 150, width = 220)
        

        # Show a plot of the generated distribution
        mainPanel(
          tabsetPanel(
            tabPanel("Predictor",
                     h1("Word Predictor"),
                     p(style="text-align: justify;","The", strong("Word Predictor"), "takes an imput and try to predict which are the next more likely 5 words based on a corpus of collected data from twitter, blogs and new. The prediction also gives an score round to six decimals which basically says how likely the word appear given the inputted words. If there are no input or there are no matches at all, the prediction will be just the most common words of the English languages, such as the, to, a, and, of, among othes…"),
                     h1(" "),
                     p(textOutput("text0") ,textOutput("text1")) ,
                     h3(htmlOutput("text2")),
                     h1(" "),
                     tableOutput('table')),

            tabPanel("Info", 
                     h1(' '),
                     h2("The Backoff of Algorithm"),
                     p(style="text-align: justify;","The assumption that the probability of a word depends only on the previous word is called a Markov assumption.", strong("Markov"), "models are the class of probabilistic models that assume we can predict the probability of some future unit without looking too far into the past. This app uses the" ,strong('Backoff algorithm'),", that is based on the Markov assumption. This assigns probabilities (scores) to each possible next word by calculating the frequency of a pair of word and then divided it into the frequency of the previous first word."),
                     h2('N-Gram'),
                     p(style="text-align: justify;","Gram talks about the words in a a specific text. In this case we used a 3-Gram model, which mean that the next word predicted depends on the last 3 words inputted to the App. If the corpus or data doesn’t find a match, then it take the last 2-Gram (last 2 words) and try to find matches to calculate the scores and so on. If there are not matches it will just return the most common words of the English language."),
                     img(src = "download.png"),
                     h1(" "),
                     h2('Why it is important to predict?'),
                     HTML("<li>	Speech recognition </li>"),
                     HTML("<li>	Faster typing  </li>"),
                     HTML("<li>	Spelling correction </li>"),
                     HTML("<li>	Grammatical error correction  </li>"),
                     HTML("<li>	Machine translation </li>"),
                     h2('References'),
                     HTML("<ul><li><p> N-gram Language Models - Speech and Language Processing. Daniel Jurafsky & James H. Martin. <a href='https://web.stanford.edu/~jurafsky/slp3/3.pdf'> Here </a></ul> <ul><li>Introduction to the tm Package - Text Mining in R by Ingo Feinerer <a href='https://cran.r-project.org/web/packages/tm/vignettes/tm.pdf'> Here </a></ul> <ul><li> Regular Expressions, Text Normalization, Edit Distance by  Daniel Jurafsky & James H. Martin.<a href='https://web.stanford.edu/~jurafsky/slp3/2.pdf'> Here </a></ul> <ul><li>Shiny R Studio tutorial - Build a user interface <a href='https://shiny.rstudio.com/tutorial/written-tutorial/lesson2/'> Here </ul></li></a></p>")

            ), 
            
            tabPanel("About Me",
                     h2("Juan Pablo"),
                     img(src = "picture.jpg", height = 150, width = 150),
                     h4("Biologist immersed in the field of statistics and data science."),
                     p(style="text-align: justify;","While I was majoring in biology I discovered that I had a particular interest in the large amount of data being generated every day. I began to delve into the different ways these data could be analyzed. Interested in the topics of data science and data analytics, I decided to emphasize the mathematics component of my studies, taking courses in subjects such as Basic Mathematics, Mathematics I and II, Biophysics I and II, Physical Chemistry, Biological Morphology, Biostatistics I and II and the application of GIS to biology. I have also complemented my studies with courses on the topics of developing data products, exploratory data analysis, foundations of probability, getting and cleaning data, data visualization, programming, regression models, statistical inference, and NLP, among others."),
                     h4('LinkedIn'),
                     a('https://www.linkedin.com/in/juanpaat/'),
                     h4('Twitter'),
                     a('https://twitter.com/JuanBioData'),
                     h4('GitHub'),
                     a('https://github.com/juanpaat'),
                     h4('Instagram'),
                     a('https://www.instagram.com/juanbiodata/'),
                     h1("")
    )
  )
)

)
)
)