
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Reddit Analysis"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      radioButtons("subreddit",
                   "Select a subreddit",
                   c("r/worldnews" = "worldnews",
                     "r/nba" = "nba")),
      sliderInput("rank",
                  "Number of themes:",
                  min = 2,
                  max = 20,
                  value = 10),
      sliderInput("terms",
                  "Number of terms per theme:",
                  min = 1,
                  max = 20,
                  value = 10)
 
    ),

    # Show a plot of the generated distribution
    mainPanel(
      dataTableOutput("themes"),
      plotOutput("heatmap")
    )
  )
))
