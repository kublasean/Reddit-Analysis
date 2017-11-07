#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(ggthemes)
library(scales)
library(lubridate)
library(zoo)
library(tweenr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
    
    df = read.csv("../data/fkd.csv")
    df$rollmean = rollmean(df$count, input$window, na.pad = TRUE)
    df$dt = as.Date(df$dt)
    
    #plot
    df %>% ggplot(aes(x=dt)) + geom_point(aes(y = count, color = "black"), color = 'red') + 
      theme_minimal() + scale_y_continuous(labels = scales::comma)  +
      geom_line(aes(y = rollmean, color = "red"), size = 1.5, color = 'black') + scale_x_date(date_breaks = "3 months", date_labels = "%b-'%y") +
      theme( # remove the vertical grid lines
        panel.grid.minor.x = element_blank()) + theme(legend.position = "none") + 
      labs(x = "", 
           y = "# of fkds",
           title = "'Fuck KD' comments on /r/nba",
           subtitle = "Number of daily fkds\nDecember 2015 - September 2017",
           caption = "Reddit via Google Big Query") +
      geom_vline(xintercept = as.Date("2016-7-4"), linetype = 4)   + annotate("text", x = as.Date("2016-7-4"), y = 400, label = "Kevin Durant announces\n signing with GSW") +
      geom_vline(xintercept = as.Date("2016-11-03"), linetype = 4) + annotate("text", x = as.Date("2016-11-03"), y = 200, label = "First game against OKC") +
      geom_vline(xintercept = as.Date("2017-06-12"), linetype = 4) + annotate("text", x = as.Date("2017-06-12"), y = 650, label = "Warriors win Game 5\nof the NBA Finals")

  })
  
})
