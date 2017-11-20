
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(tm)
library(SnowballC)
library(NMF)

shinyServer(function(input, output) {
  
  loadData <- reactive({
    path = paste0(input$subreddit, "_2017_1-2017_1.csv")
    #path = "test.csv"

      #load data
      withProgress(message = 'Loading data', value=0, {
        n = 10
        incProgress(1/n, detail = "loading dataset")
        data = read.csv(path)
        incProgress(4/n, detail = "cleaning")
        tmp = Corpus(VectorSource(data$X2))
        tmp = tm_map(tmp, content_transformer(tolower))
        tmp = tm_map(tmp, removeNumbers)
        tmp = tm_map(tmp, removePunctuation)
        tmp = tm_map(tmp, removeWords, c("the", "and", stopwords("english")))
        tmp =  tm_map(tmp, stripWhitespace)
        incProgress(3/n, detail = "creating document term matrix")
        tmp = DocumentTermMatrix(tmp, control = list(weighting = weightTfIdf))
        tmp = removeSparseTerms(tmp, 0.95)
        tmp = as.matrix(tmp)
        incProgress(2/n, detail = "grouping by date")
        m = aggregate(tmp ~ X1, data, sum)
      })
      
      dates = m[,1]
      m = m[,2:ncol(m)]
      sorted = sort(colSums(m), decreasing = TRUE)

    return (list("data" = m[,names(sorted[1:250])], "dates" = dates))
  })
  
  #do nmf
  doNMF <- reactive({
    vars = loadData()
    data_nmf = vars$data
    res = nmf(data_nmf,input$rank)
    return (list("res" = res, "dates"=vars$dates))
  })
  
  # output themes
  output$themes <- renderDataTable({
    vars = doNMF()
    res = vars$res
    h = coef(res)
    mytable = NULL
    for (i in 1:nrow(h)) { 
      mytable = rbind(mytable, names(sort(h[i,], decreasing=TRUE)[1:input$terms]))
      #print(mytable)
    }
    mytable = t(mytable)
    colnames(mytable) = seq(1, input$rank)
    return(as.table(mytable))
  })

  output$heatmap <- renderPlot({
    vars = doNMF()
    res = vars$res
    dates = vars$dates
    basismap(res,Rowv=NA,info=TRUE, labRow=dates)
  })
})
