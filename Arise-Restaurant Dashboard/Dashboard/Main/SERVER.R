library(shiny)
library(shinydashboard)
library(dplyr)
library(DT)
library(ggplot2)
library(leaflet)

# Load the data file
Data_file <- read.csv("C:/Users/junfe/Downloads/Arise-Restaurant Dashboard/Arise-Restaurant Dashboard/Dashboard/Data/zomato.csv", header = TRUE)

shinyServer(function(input, output) {

  ###### Dashboard page

  ## Dashboard // barplot chart 
  output$barchart1 <- renderPlot({
    Data_file %>% count(Locality) %>% top_n(input$num, n) %>% 
      ggplot(aes(x=reorder(Locality, n), y=n)) +
      geom_bar(stat="identity") +
      coord_flip() +
      labs(y = "Total Restaurants", x = "Locality")
  })

  ## Dashboard // Restaurants Select input
  output$restaurantUI <- renderUI({
    locality_data <- subset(Data_file, Locality == input$locality)
    selectInput("restaurant", "Choose a Restaurant:", choices = unique(locality_data$Restaurant))
  })

  ## Dashboard // Calculate cost
  output$avgCostUI <- renderUI({
    selected_data <- subset(Data_file, Locality == input$locality & Restaurant == input$restaurant)
    avg_cost <- mean(selected_data$Average.Cost.for.two, na.rm = TRUE)

    valueBox(
      value = h4(paste("Average Cost for two:", avg_cost)),
      subtitle = paste(input$restaurant, "in", input$locality),
      color = "purple", width = 12
    )
  })

  ## Dashboard // Rating 
  output$ratingUI <- renderUI({
    selected_data <- subset(Data_file, Locality == input$locality & Restaurant == input$restaurant)
    Rating1 <- mean(selected_data$Rating, na.rm = TRUE)

    valueBox(
      value = h4(paste("Rating : ", Rating1)),
      subtitle = paste(input$restaurant, "in", input$locality),
      color = "purple", width = 12
    )
  })

  ###### Rating Page

  ## Rating // Bar chart
  output$ratingBarChart <- renderPlot({
    rating_chart1 <- table(Data_file$Rating)
    rating_chart11 <- as.data.frame(rating_chart1)

    ggplot(rating_chart11, aes(x=Var1, y=Freq)) +
      geom_bar(stat="identity") +
      labs(x = "Rating", y = "Count of Restaurants")
  })

  ## Rating // Pie chart
  output$ratingPiechart <- renderPlot({
    rating_data <- as.data.frame(table(Data_file$Rating.text))
    ggplot(rating_data, aes(x = "", y = Freq, fill = Var1, label = paste(Var1, Freq))) +
      geom_bar(stat = "identity") +
      coord_polar("y") +
      geom_label(aes(x = 1.2), position = position_stack(vjust = 0.5), hjust = 1) +
      labs(fill = "Rating") +
      theme_void() +
      theme(legend.position = "none") # Hide the legend
  })

  ###### Food page

  ## Food // Top Cities
  output$cuisinesBarchart <- renderPlot({
    Data_file %>%
      count(Locality, Cuisines) %>%
      top_n(input$cuisinesnum, n) %>%
      ggplot(aes(x=reorder(Locality, n), y=n, fill=Cuisines)) +
      geom_bar(stat="identity") +
      coord_flip() +
      labs(y = "Total Restaurants", x = "Locality") +
      theme(legend.position="bottom")
  })

  ###### Table 
  output$data_table <- renderDT({
    datatable(Data_file)
  })

  ###### Map
  output$map <- renderLeaflet({
    leaflet(Data_file) %>%
      addTiles() %>%
      addMarkers(~Longitude, ~Latitude, popup = ~paste(Restaurant, "<br>", Address))
  })
})
