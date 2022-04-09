#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(CodeClanData)
library(tidyverse)
library(ggplot2)

game_sales <- CodeClanData::game_sales



# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Game Sales and Ratings"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("year_input",
                        "Year of Release:",
                        min = 1988,
                        max = 2016,
                        value = 2)
        ),
        
        selectInput("game_input", 
                    "Choose a game:", 
                    choices = unique(game_sales$name), 
                    selected = NULL, 
                    multiple = FALSE, 
                    selectize = TRUE)
    ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("score_plot"),
           plotOutput("sales_by_genre_plot"),
           plotOutput("game_sales") #not working
        )
    )


# Define server logic required to draw a histogram
server <- function(input, output) {

  output$sales_by_genre_plot <- renderPlot({
  game_sales %>% 
    ggplot()+
    aes(x = genre, 
        y = sales, 
        fill = genre)+
    geom_col()
  })
  
  
    output$score_plot <- renderPlot({
        
      game_sales %>%
        # filter(genre == "Action") %>% 
        ggplot() +
        aes(x = critic_score, 
            y = user_score, 
            colour = genre) +
        geom_point() +
        facet_wrap(~genre)
      
    })
    
    
    #not working
    output$platform_sales <- renderPlot({
      game_sales %>% 
        ggplot()+
        aes(x = platform, 
            y = sales) +
        geom_col(fill = input$game_input)
      
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
