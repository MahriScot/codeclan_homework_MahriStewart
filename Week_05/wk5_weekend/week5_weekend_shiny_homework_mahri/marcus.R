library(shiny)
library(tidyverse)
library(DT)
library(shinythemes)

games <- CodeClanData::game_sales
all_genres <- sort(unique(games$genre))
all_years <- sort(unique(games$year_of_release))
all_platforms <- sort(unique(games$platform))

ui <- fluidPage(
  
  theme = shinytheme("united"),
  
  titlePanel(h1("Bad Game Finder 🤢🕹")),
  
  sidebarLayout(
    
    sidebarPanel(
      
      selectInput("platform_input", label = h4("Platform"), 
                  choices = all_platforms),
      
      checkboxGroupInput("genre_input", label = h4("Genre"), 
                         choices = all_genres,
                         selected = all_genres),
      
      sliderInput("year_input", label = h4("Released"), min = 1988, 
                  max = 2016, value = c(1988, 2016), sep = "")
      
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Worst reviewed games", 
                 HTML("<br>"),
                 plotOutput("critic_ratings_plot"), 
                 HTML("<br>"),
                 plotOutput("user_ratings_plot")), 
        tabPanel("Table view", dataTableOutput("games_table")),
        tabPanel("Don't click", 
                 HTML("<br><br>"),
                 uiOutput("img"))
      )
    )
  )
)

server <- function(input, output) {
  
  filtered_games <- reactive({
    games %>% 
      filter(platform %in% input$platform_input) %>% 
      select(-c(publisher, sales, rating, platform)) %>% 
      filter(genre %in% input$genre_input) %>%
      filter(year_of_release %in% seq(input$year_input[1], input$year_input[2], 
                                      by = 1))
  })
  
  # The following is a bar chart that shows the 10 lowest rated games (by professional critics) for a platform chosen by the user. I have limited it to a bottom 10 in order to keep it legible, however there is also a table view in the second tab should the user want more information. I have set up the dashboard to show one platform at a time, however the user can also select one or several game genres as well as a range of release years. The aim is to highlight the worst games in the dataset so that the user can avoid them or maybe intentionally seek them out if they are so inclined.
  
  output$critic_ratings_plot <- renderPlot({
    
    filtered_games() %>%
      arrange(desc(critic_score)) %>% 
      tail(10) %>% 
      ggplot() +
      aes(x = critic_score, y = reorder(name, critic_score)) +
      geom_col(fill = "burlywood3") +
      geom_text(aes(label = critic_score), hjust = 1.5) +
      labs(x = "Critic score",
           y = "Game title",
           title = "Worst games by critic score") +
      theme_minimal() +
      theme(title = element_text(size = 14),
            axis.text = element_text(size = 11),
            axis.title.x = element_text(size = 14),
            axis.title.y = element_text(size = 0))
    
  })
  
  # The following plot is similar to the first one, however instead of critic ratings it shows user ratings. It is a good supplement to the first plot as user ratings can sometimes be more dependable than professional ones.
  
  output$user_ratings_plot <- renderPlot({
    
    filtered_games() %>%
      arrange(desc(user_score)) %>% 
      tail(10) %>% 
      ggplot() +
      aes(x = user_score, y = reorder(name, user_score)) +
      geom_col(fill = "lightgoldenrod3") +
      geom_text(aes(label = user_score), hjust = 1.5) +
      labs(x = "User score",
           y = "Game title",
           title = "Worst games by user score") +
      theme_minimal() +
      theme(title = element_text(size = 14),
            axis.text = element_text(size = 11),
            axis.title.x = element_text(size = 14),
            axis.title.y = element_text(size = 0))
    
  })
  
  output$games_table <- renderDataTable({
    
    filtered_games() %>%
      arrange(user_score)
    
  })
  
  output$img <- renderUI({
    tags$img(src = "https://upload.wikimedia.org/wikipedia/en/9/9a/Trollface_non-free.png")
  })
  
}

shinyApp(ui = ui, server = server)