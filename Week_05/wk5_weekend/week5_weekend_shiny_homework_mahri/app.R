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

  
titlePanel("Game Sales and Ratings"),

#     sliderInput("bins",
#                 "Number of bins:",
#                 min = 1,
#                 max = 50,
#                 value = 30)
# ),
# output$distPlot <- renderPlot({
#   # generate bins based on input$bins from ui.R
#   x    <- faithful[, 2]
#   bins <- seq(min(x), max(x), length.out = input$bins + 1)
#   
  
    sidebarLayout(
        sidebarPanel(
            sliderInput("year_input",
                        tags$i("Year of Release:"),
                        min = 1988,
                        max = 2016,
                        value = 2000)
        ),
        
    

mainPanel(
    tabsetPanel(
            tabPanel("Game Sales by Genre",
                     plotOutput("sales_by_genre_plot")
            ),
            tabPanel("Game Sales by Platform",
                     plotOutput("sales_by_platform_plot")
            ),
            tabPanel("Critic Vs User Scores by Genre",
                     plotOutput("score_plot")
            ),
           tabPanel("Data for Selected Year",
                     DT::dataTableOutput("table"), 
                     
                     # selectInput("game_input", 
                     #             "Choose a game:", 
                     #             choices = unique(game_sales$name), 
                     #             selected = NULL, 
                     #             multiple = FALSE, 
                     #             selectize = TRUE)
                     )
        ))
        )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  output$sales_by_genre_plot <- renderPlot({
  game_sales %>% 
      filter(year_of_release == input$year_input) %>% 
    ggplot()+
    aes(x = genre, 
        y = sales, 
        fill = genre)+
    geom_col() +
   #   scale_y_continuous(breaks = 10:130, 10) +
      labs(x = "\nGenres that sold",
           y = "Sales (in millions)",
           title = "Sales for genres that sold in selected year", 
           subtitle = tags$i(
             "Please note the y-axis (sales) scale changes for each year")) +
  theme(axis.text.x=element_text(angle=45, vjust = 0.7), 
        legend.position="none")
  })
  
  
  output$sales_by_platform_plot <- renderPlot({
    
    game_sales %>% 
      filter(year_of_release == input$year_input) %>%
      ggplot() +
      aes(x = platform, 
          y = sales, 
          fill = name) +
      geom_col() +
      labs(x = "\nPlatform",
           y = "Sales (in millions)",
           title = "Sales by platform for games that sold in selected year", 
           subtitle = tags$i(
             "Please note the y-axis (sales) scale changes for each year")) +
      theme(axis.text.x=element_text(angle=45, vjust = 0.7))
  })
    
    
  
  # I want to make this reactive - hover over a point and it tells you the name
  # of the game
  output$score_plot <- renderPlot({
      game_sales %>%
        filter(year_of_release == input$year_input) %>% 
        ggplot() +
        aes(x = critic_score, 
            y = user_score, 
            colour = genre) +
        geom_point() +
        facet_wrap(~genre) +
      #  scale_x_continuous(breaks = seq(20)) +
        #scale_y_continuous(breaks = seq(2))+
        labs(x = "Critics Score (out of 100)", 
             y = "Users Score (out of 10)",
             title = "Critic scores against user scores for each sold genre
             in the selected year") +
        theme(axis.text.x=element_text(angle=45), legend.position="none")
      
    })
    
  
  output$table <- DT::renderDataTable({
    game_sales %>%
      filter(year_of_release == input$year_input) %>% 
      arrange(desc(sales))
    
  })
  }

# Run the application 
shinyApp(ui = ui, server = server)
