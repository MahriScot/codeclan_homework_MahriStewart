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
library(plotly)
library(bslib)

game_sales <- CodeClanData::game_sales



ui <- fluidPage(
  
 tags$head(tags$style('body {font-family: Mukta, sans-serif;}')),
  theme = bs_theme(version = 4, bootswatch = "flatly"),
  
  
titlePanel("Game Sales and Ratings"),
  
    # sidebarLayout(
    #     sidebarPanel(
    #         sliderInput("year_input",
    #                     tags$i("Year of Release:"),
    #                     min = 1988,
    #                     max = 2016,
    #                     value = 2000)
    #     ),
        
mainPanel(
  
    tabsetPanel(
      
      tabPanel("Critic Vs User Scores",
               "I want to make this graph interactive so that users can hover
               over each point and see details like the name of the game - I 
               tried to use ggplotly but it is only working in my viewer pane 
               and not in the new window. This is why I have added the table at 
               the side for now.",
               sliderInput("year_input",
                           tags$i("Year of Release:"),
                           min = 1988,
                           max = 2016,
                           value = 2000),
                    
               fluidRow(
                 column(8, 
                    plotlyOutput("rating_plot")),
                 column(4, 
                    tableOutput("ratings_table"))
      )
      ),
  
      tabPanel("Game Sales by Platform",
               "Looking at the data this way can show how successful games were
               across cometing platforms. I would like for the user to be able 
               to search for a game by typing it into a search box.",
               selectInput("game_input", 
                           tags$i("Choose a game:"),
                           choices = unique(game_sales$name),
                           selected = "FIFA Soccer 09",
                           multiple = FALSE,
                           selectize = TRUE),
               plotOutput("sales_by_platform_plot")
               
      ),
      
      tabPanel("Game Sales by Genre",
               "The year scale was working but I'm not sure why it's not anymore.
               ",
               sliderInput("year_input",
                            tags$i("Year of Release:"),
                           min = 1988,
                           max = 2016,
                           value = 2000),
               plotOutput("sales_by_genre_plot")
            ),
      

          
           tabPanel("Data Table",
                     DT::dataTableOutput("table")
                     )
        )
    
)
)


server <- function(input, output) {
  
    output$rating_plot <- renderPlotly({
      
    score_plot_details <- 
    game_sales %>% 
      filter(year_of_release == input$year_input) %>% 
      ggplot() + 
      aes(x = critic_score, 
          y = user_score, 
          colour = genre, 
          fill = name) +
      geom_point() + 
      #facet_wrap(~genre) +
        xlim(1, 100) +
        ylim(1, 10) +
      labs(x = "Critics Score (out of 100)", 
           y = "Users Score (out of 10)",
           title = "Critic scores against user scores for each sold genre
             in the selected year", 
           fill = "Name") +
      theme(axis.text.x = element_text(angle = 45),
            legend.position = "none") 
    ggplotly(score_plot_details)
  })
  
    output$ratings_table <- renderTable({
      game_sales %>% 
        select(name, critic_score, user_score, genre, year_of_release) %>% 
        filter(year_of_release == input$year_input) #%>% 
 #       slice(1:10)   #this obviously only leaves the top 10
    })
  

    output$sales_by_platform_plot <- renderPlot({
      
      game_sales %>% 
        filter(name == input$game_input) %>% 
        ggplot() +
        aes(x = platform, 
            y = sales, 
            fill = platform) +
        geom_col() +
        labs(x = "\nPlatform",
             y = "Sales (in millions)",
             title = "Sales by platform for games that sold in selected year", 
             subtitle = tags$i(
               "Please note the y-axis (sales) scale changes for each year")) +
        theme(axis.text.x = element_text(angle = 45, vjust = 0.7)) +
        scale_fill_manual(
          values = c("3DS" = "#f2a02e", 
                     "DS" = "#f082ff",
                     "GBA" = "#ff6e88",
                     "GC" = "#ffd68a",
                     "PC" = "#e8b782",
                     "PS" = "#f89d13",
                     "PS2" = "#8fecc8",
                     "PS3" = "#240747", 
                     "PS4" = "#de6d0b",
                     "PSP" = "#f5ddc9",
                     "PSV" = "#c50d66",
                     "Wii" = "#afc5ff", 
                     "WiiU" = "#eb2632",
                     "X360" = "blue",
                     "XB" = "green",
                     "XOne" = "purple"))
    })
    
    
    
    output$sales_by_genre_plot <- renderPlot({
      game_sales %>% 
        filter(year_of_release == input$year_input) %>% 
        ggplot()+
        aes(x = genre, 
            y = sales, 
            fill = genre) +
        geom_col() +
        labs(x = "\nGenres that sold in selected year",
             y = "Sales (in millions)",
             title = "Sales for genres that sold in selected year", 
             subtitle = tags$i(
               "Please note the y-axis (sales) scale changes for each year")) +
        theme(axis.text.x=element_text(angle=45, vjust = 0.7), 
              legend.position="none")
    })
  
  
  output$table <- DT::renderDataTable({
    game_sales %>% 
      arrange(year_of_release)
    
  })
  }

# Run the application 
shinyApp(ui = ui, server = server)
