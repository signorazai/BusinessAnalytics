library(shiny)

Data_file <- read.csv("C:/Users/junfe/Downloads/Arise-Restaurant Dashboard/Arise-Restaurant Dashboard/Dashboard/Data/zomato.csv", header = TRUE)

Rating_4 <- sum(Data_file$Rating >= 4)
total_Votes <- sum(Data_file$Votes)

shinyUI(
  dashboardPage(
    dashboardHeader(
      title = "Zomato Restaurants"
    ),
    dashboardSidebar(
      sidebarMenu(
        menuItem("About", tabName = "about",icon = icon("info")),
        menuItem("Dashboard", tabName = "dashboard",icon = icon("dashboard")),
        menuSubItem("Rating Analysis", tabName = "Rating",icon = icon("star")),
        menuSubItem("Food Analysis", tabName = "cuisines",icon = icon("utensils")),
        menuItem("Table", tabName = "Table" ,icon = icon("table"))
        
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(
          tabName = "about",
          fluidRow(
            box(
              title = "About the Zomato Restaurants Dashboard",
              status = "primary",
              width = 12,
              solidHeader = TRUE,
              collapsible = TRUE,
              h2("Welcome to the Zomato Restaurants Dashboard "),
              p("This dashboard provides insights into the restaurant landscape in the National Capital Region (NCR) as listed on Zomato, a popular online food delivery and restaurant discovery platform."),
              h2("Dataset Information"),
              p("• Dataset Name: Zomato Restaurants in Delhi NCR"),
              p("• Last Updated: August 30th, 2021"),
              p("• Number of Restaurants: 1965"),
              p("• Coverage: The dataset covers the entire NCR region, including Delhi and surrounding areas."),
              p("• The dataset was obtained from Kaggle, a platform for data science competitions and datasets."),
              h2("Purpose"),
              p("The purpose of this dashboard is to analyze and visualize key metrics related to restaurants listed on Zomato in Delhi NCR."),
              p("• Provide an overview of the restaurant market size and distribution across different localities in Delhi NCR."),
              p("• Analyze customer ratings and reviews to identify top-rated restaurants and understand customer preferences."),
              p("• Offer insights into average costs for dining, aiding users in budget planning and decision-making."),
              p("• Enable users to interact with the data and explore detailed information about individual restaurants through a user-friendly interface."),
              h2("Descriptive Analytics"),
              p("Descriptive analytics is employed in the Zomato Restaurants Dashboard to provide users with an understanding of the current state of the restaurant landscape in Delhi NCR, enabling the identification of trends, patterns, and correlations in key metrics such as ratings, reviews, cuisine preferences, and average costs. Through exploratory analysis and data visualization, descriptive analytics facilitates benchmarking, comparison, and insightful decision-making."),
              p("https://www.kaggle.com/datasets/aestheteaman01/zomato-restaurants-in-delhi-ncr/data"),
              p("Team Arise - Ala-an, Dalumpines, Ramos - (24/05/24)"),
              
               )
          )
        ),
        tabItem(
          tabName = "dashboard",
          fluidRow(
            valueBox(nrow(Data_file), "Total Restaurants in Delhi", icon = icon("utensils"), color = "maroon"),
            valueBox(Rating_4, "Rating more than 4", icon = icon("star"), color = "purple"),
            valueBox(total_Votes, "Total No of Votes in Delhi", icon = icon("handshake"), color = "purple")
          ),
          fluidRow(
            box(title = "Top Area in Delhi", plotOutput("barchart1", height = "490px"), width = 9, status = "primary"),
            box(
              sliderInput("num", "Number of Top Localities:", min = 1, max = 50, value = 20),
              h3("About The Restaurant"),
              selectInput("locality", "Choose a Locality:", choices = unique(Data_file$Locality)),
              uiOutput("restaurantUI"),
              br(),
              uiOutput("avgCostUI"),
              uiOutput("bestfoodUI"),
              uiOutput("ratingUI"),
              width = 3
            )
          )
        ),
        tabItem(
          tabName = "Rating",
          box(h1("Rating Analysis"), width = 12),
          box(
            title = "Number of Restaurants with Different Ratings",
            plotOutput("ratingBarChart"),
            status = "primary"
          ),
          box(
            title = "Reviews", status = "primary",
            plotOutput("ratingPiechart")
          )
        ),
        tabItem(
          tabName = "cuisines",
          fluidPage(
            box(title = "Cuisines Across Localities", plotOutput("cuisinesBarchart", height = "600px"), width = 9, status = "primary"),
            box(sliderInput("cuisinesnum", "Number of Top Localities:", min = 1, max = 50, value = 20), width = 3)
          )
        ),
        tabItem(
          tabName = "Table",
          h1("Data Table"),
          fluidRow(
            DTOutput("data_table", width = "1200")
          )
        )
      )
    )
  )
)
