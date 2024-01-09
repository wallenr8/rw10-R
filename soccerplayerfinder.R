Using R shiny modules 

# Install required packages
install.packages(c("shiny", "httr", "jsonlite"))

# Load required libraries
library(shiny)
library(httr)
library(jsonlite)

# Define UI
ui <- fluidPage(
  titlePanel("Soccer Player Information"),
  sidebarLayout(
    sidebarPanel(
      textInput("player_name", "Enter Player Name:", ""),
      actionButton("submit", "Submit")
    ),
    mainPanel(
      tableOutput("player_info_table")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Function to fetch player information from the FIFA API
  fetchPlayerInfo <- function(player_name) {
    api_url <- "https://fifa-football-teams-and-players.p.rapidapi.com/players/"
    headers <- c(
      "X-RapidAPI-Host" = "fifa-football-teams-and-players.p.rapidapi.com",
      "X-RapidAPI-Key" = "YOUR_RAPIDAPI_KEY"
    )
    query_params <- list(player = player_name)
    
    response <- GET(api_url, query = query_params, add_headers(headers))
    player_info <- content(response, "text")
    player_info <- fromJSON(player_info)
    
    return(player_info)
  }
  
  # Reactive function to update player information based on user input
  player_info_data <- reactive({
    req(input$submit)
    player_name <- input$player_name
    player_info <- fetchPlayerInfo(player_name)
    return(player_info)
  })
  
  # Render the player information table
  output$player_info_table <- renderTable({
    player_info_data()
  })
}

# Run the Shiny app
shinyApp(ui = ui, server = server)
