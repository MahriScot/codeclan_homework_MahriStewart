# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(CodeClanData)
library(plotly)
# Define UI for application that draws a histogram
ui <- fluidPage(# Application title
  
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      radioButtons(
        "compare",
        "Compare",
        choices = list("Genre" = "genre", "Publisher" = "publisher")
      ),
      selectInput("against",
                  "Against",
                  c("Item A", "Item B", "Item C")),
      verbatimTextOutput("click")
      
      # list("Sales" = "sales", "Average Critic Score" = "critic_score", "Average User Score" = "user_score"))
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(plotlyOutput("compare_plot"),
              selectInput("detail_year",
                          "Investigate a Year",
                          choices = 2000, 2001)
              
    )
    
  ))

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  observe({
    against_choices <- game_sales %>%
      select(input$compare) %>%
      distinct()
    
    updateSelectInput(
      session,
      "against",
      label = paste("Select Game", str_to_title(input$compare)),
      choices = against_choices
    )
    
  })
  
  compare_plot_pre <- reactive({
    if (input$compare == "genre") {
      CodeClanData::game_sales %>%
        select(sales, year_of_release, input$compare) %>%
        filter(genre == input$against) %>%
        group_by(year_of_release) %>%
        summarise(total_sales = sum(sales)) %>%
        ggplot() +
        aes(x = year_of_release, y = total_sales) +
        geom_bar(stat = "identity")
      
    } else {
      CodeClanData::game_sales %>%
        select(sales, year_of_release, input$compare) %>%
        filter(publisher == input$against) %>%
        group_by(year_of_release) %>%
        summarise(total_sales = sum(sales)) %>%
        ggplot() +
        aes(x = year_of_release, y = total_sales) +
        geom_bar(stat = "identity")
      
    }
  }
  )
  
  
  output$compare_plot <- renderPlotly({
    ggplotly(compare_plot_pre())
  })
  
  
  
  observe({
    year_details <- game_sales %>%
      select(input$compare, year_of_release) %>%
      distinct(year_of_release)
    
    updateSelectInput(
      session,
      "detail_year",
      label = paste("Select Year to detal"),
      choices = year_details
    )
  })
  
  # output$detailplot <- renderPlotly({
  #   ggplotly(detail_plot_pre())
  # })
  
  # detail_plot_pre <- reactive({
  #   game_sales %>% 
  #     select(sales, input$compare) %>% 
  #     filter(year == input$detail_year) %>% 
  #     ggplot() +
  #     aes(x = year_of_release, y = sales) +
  #     geom_col()
  # })
  
  
  
  
  
  # output$detail_plot <- renderPlotly({
  #   ggplotly(detail_plot_pre())
  # })
  # })
  # detail_plot_pre <- reactive({
  #   CodeClanData::game_sales %>%
  #     filter(publisher == input$against,
  #            year_of_release == year) %>% 
  #     ggplot() +
  #     aes(x = year_of_release, y = sales) +
  #     geom_bar() +
  #     coord_flip()
  # })
  # output$click <- renderPrint({
  #   event_data("plotly_selected")
  # })
}

# Run the application
shinyApp(ui = ui, server = server)