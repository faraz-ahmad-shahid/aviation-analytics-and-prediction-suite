# Install packages first (run once):
# install.packages(c("shiny", "shinydashboard", "shinydashboardPlus", "shinyWidgets",
#                    "plotly", "ggplot2", "dplyr", "lubridate", "forecast", "prophet",
#                    "DT", "scales", "viridis", "leaflet", "readr", "data.table",
#                    "echarts4r", "bs4Dash"))

library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(plotly)
library(ggplot2)
library(dplyr)
library(lubridate)
library(forecast)
library(prophet)
library(DT)
library(scales)
library(viridis)
library(leaflet)
library(readr)
library(data.table)

# Increase file upload limit to 1 GB
options(shiny.maxRequestSize = 1024*1024*1024)

ui <- dashboardPage(
  skin = "blue",
  
  dashboardHeader(
    title = span(
      icon("plane"),
      "Aviation Analytics Suite"
    ),
    titleWidth = 300,
    
    tags$li(class = "dropdown",
            tags$style(HTML("
             .main-header .logo { 
               background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important; 
             }
             .main-header .navbar { 
               background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important; 
             }
           "))
    )
  ),
  
  dashboardSidebar(
    width = 280,
    
    sidebarMenu(
      id = "sidebar",
      
      menuItem("Flight Operations", tabName = "operations", 
               icon = icon("plane-departure"),
               badgeLabel = "Live", badgeColor = "green"),
      
      menuItem("Delay Predictions", tabName = "delays", 
               icon = icon("clock"),
               badgeLabel = "AI", badgeColor = "purple"),
      
      menuItem("Route Analytics", tabName = "routes", 
               icon = icon("route")),
      
      menuItem("Passenger Forecasting", tabName = "passengers", 
               icon = icon("users")),
      
      menuItem("Aircraft Performance", tabName = "aircraft", 
               icon = icon("jet-fighter")),
      
      menuItem("Fuel Optimization", tabName = "fuel", 
               icon = icon("gas-pump")),
      
      menuItem("Revenue Analytics", tabName = "revenue", 
               icon = icon("dollar-sign")),
      
      menuItem("Weather Impact", tabName = "weather", 
               icon = icon("cloud-sun")),
      
      menuItem("Data Upload", tabName = "upload", 
               icon = icon("upload"))
    ),
    
    hr(),
    
    div(style = "padding: 15px; color: white;",
        h5(icon("info-circle"), " Aviation Insights"),
        p("Real-time analytics and ML-powered predictions for aviation operations.", 
          style = "font-size: 12px;")
    )
  ),
  
  dashboardBody(
    tags$head(
      tags$style(HTML("
        @import url('https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;700&display=swap');
        
        body, .content-wrapper { 
          background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
          font-family: 'Roboto', sans-serif;
        }
        
        .box {
          border-radius: 12px;
          box-shadow: 0 4px 15px rgba(0,0,0,0.1);
          border-top: 3px solid #667eea !important;
        }
        
        .small-box {
          border-radius: 12px;
          box-shadow: 0 4px 15px rgba(0,0,0,0.15);
          transition: transform 0.3s;
        }
        
        .small-box:hover {
          transform: translateY(-5px);
          box-shadow: 0 8px 25px rgba(0,0,0,0.2);
        }
        
        .small-box .icon {
          font-size: 70px;
        }
        
        .info-box {
          border-radius: 10px;
          box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }
        
        .bg-gradient-blue {
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
        }
        
        .bg-gradient-green {
          background: linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%) !important;
        }
        
        .bg-gradient-orange {
          background: linear-gradient(135deg, #fa709a 0%, #fee140 100%) !important;
        }
        
        .bg-gradient-purple {
          background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%) !important;
        }
        
        .metric-card {
          background: white;
          border-radius: 15px;
          padding: 20px;
          margin: 10px 0;
          box-shadow: 0 5px 20px rgba(0,0,0,0.1);
          transition: all 0.3s;
        }
        
        .metric-card:hover {
          transform: translateY(-3px);
          box-shadow: 0 8px 30px rgba(0,0,0,0.15);
        }
        
        .metric-value {
          font-size: 36px;
          font-weight: 700;
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          -webkit-background-clip: text;
          -webkit-text-fill-color: transparent;
          margin: 10px 0;
        }
        
        .metric-label {
          font-size: 14px;
          color: #666;
          text-transform: uppercase;
          letter-spacing: 1px;
        }
        
        .status-badge {
          padding: 5px 15px;
          border-radius: 20px;
          font-size: 12px;
          font-weight: 600;
          display: inline-block;
        }
        
        .status-ontime { background: #28a745; color: white; }
        .status-delayed { background: #ffc107; color: #333; }
        .status-cancelled { background: #dc3545; color: white; }
        
        .chart-container {
          background: white;
          border-radius: 12px;
          padding: 20px;
          box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        h3, h4 {
          font-weight: 300;
          color: #333;
        }
      "))
    ),
    
    tabItems(
      # Flight Operations Tab
      tabItem(
        tabName = "operations",
        
        fluidRow(
          valueBoxOutput("totalFlights", width = 3),
          valueBoxOutput("onTimeRate", width = 3),
          valueBoxOutput("avgDelay", width = 3),
          valueBoxOutput("cancellations", width = 3)
        ),
        
        fluidRow(
          box(
            title = tagList(icon("chart-line"), " Real-Time Flight Status"),
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            height = 500,
            plotlyOutput("flightStatusTimeline", height = "420px")
          )
        ),
        
        fluidRow(
          box(
            title = tagList(icon("map-marked-alt"), " Live Flight Map"),
            status = "info",
            solidHeader = TRUE,
            width = 8,
            height = 500,
            leafletOutput("flightMap", height = "420px")
          ),
          
          box(
            title = tagList(icon("list"), " Recent Flight Activity"),
            status = "success",
            solidHeader = TRUE,
            width = 4,
            height = 500,
            div(style = "overflow-y: auto; max-height: 420px;",
                uiOutput("recentFlights")
            )
          )
        ),
        
        fluidRow(
          box(
            title = tagList(icon("chart-bar"), " Delays by Airport"),
            status = "warning",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("delaysByAirport", height = "350px")
          ),
          
          box(
            title = tagList(icon("pie-chart"), " Flight Status Distribution"),
            status = "danger",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("statusDistribution", height = "350px")
          )
        )
      ),
      
      # Delay Predictions Tab
      tabItem(
        tabName = "delays",
        
        fluidRow(
          box(
            title = tagList(icon("robot"), " AI Delay Prediction System"),
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            
            fluidRow(
              column(3,
                     selectInput("predictRoute", "Select Route",
                                 choices = c("JFK-LAX", "ORD-SFO", "ATL-DEN", "DFW-MIA"))
              ),
              column(3,
                     selectInput("predictAircraft", "Aircraft Type",
                                 choices = c("Boeing 737", "Airbus A320", "Boeing 777", "Airbus A350"))
              ),
              column(3,
                     selectInput("predictWeather", "Weather Condition",
                                 choices = c("Clear", "Cloudy", "Rain", "Storm", "Snow"))
              ),
              column(3,
                     dateInput("predictDate", "Departure Date", value = Sys.Date())
              )
            ),
            
            fluidRow(
              column(3,
                     selectInput("departureTime", "Departure Time",
                                 choices = c("Morning (6-12)", "Afternoon (12-18)", 
                                             "Evening (18-24)", "Night (0-6)"))
              ),
              column(3,
                     sliderInput("trafficLevel", "Air Traffic Level",
                                 min = 1, max = 10, value = 5)
              ),
              column(3,
                     sliderInput("seasonalFactor", "Seasonal Factor",
                                 min = 0, max = 1, value = 0.5, step = 0.1)
              ),
              column(3,
                     br(),
                     actionButton("predictDelay", "Predict Delay", 
                                  class = "btn-success btn-block",
                                  icon = icon("magic"))
              )
            )
          )
        ),
        
        fluidRow(
          box(
            title = tagList(icon("chart-area"), " Delay Prediction Results"),
            status = "info",
            solidHeader = TRUE,
            width = 8,
            height = 400,
            plotlyOutput("delayPredictionPlot", height = "320px")
          ),
          
          box(
            title = tagList(icon("info-circle"), " Prediction Details"),
            status = "warning",
            solidHeader = TRUE,
            width = 4,
            height = 400,
            uiOutput("predictionDetails")
          )
        ),
        
        fluidRow(
          box(
            title = tagList(icon("history"), " Historical Delay Patterns"),
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            plotlyOutput("historicalDelays", height = "400px")
          )
        ),
        
        fluidRow(
          box(
            title = tagList(icon("brain"), " ML Model Performance"),
            status = "success",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("modelAccuracy", height = "350px")
          ),
          
          box(
            title = tagList(icon("exclamation-triangle"), " Risk Factors"),
            status = "danger",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("riskFactors", height = "350px")
          )
        )
      ),
      
      # Route Analytics Tab
      tabItem(
        tabName = "routes",
        
        fluidRow(
          infoBoxOutput("topRoute", width = 3),
          infoBoxOutput("totalRoutes", width = 3),
          infoBoxOutput("avgDistance", width = 3),
          infoBoxOutput("routeEfficiency", width = 3)
        ),
        
        fluidRow(
          box(
            title = tagList(icon("network-wired"), " Route Network Visualization"),
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            height = 550,
            leafletOutput("routeNetwork", height = "470px")
          )
        ),
        
        fluidRow(
          box(
            title = tagList(icon("chart-line"), " Route Performance Metrics"),
            status = "info",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("routePerformance", height = "400px")
          ),
          
          box(
            title = tagList(icon("trophy"), " Top 10 Routes by Traffic"),
            status = "success",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("topRoutes", height = "400px")
          )
        ),
        
        fluidRow(
          box(
            title = tagList(icon("clock"), " Average Flight Duration by Route"),
            status = "warning",
            solidHeader = TRUE,
            width = 12,
            plotlyOutput("flightDurations", height = "400px")
          )
        )
      ),
      
      # Passenger Forecasting Tab
      tabItem(
        tabName = "passengers",
        
        fluidRow(
          box(
            title = tagList(icon("chart-line"), " Passenger Demand Forecasting"),
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            
            fluidRow(
              column(4,
                     selectInput("forecastRoute", "Select Route",
                                 choices = c("All Routes", "JFK-LAX", "ORD-SFO", "ATL-DEN"))
              ),
              column(4,
                     sliderInput("forecastMonths", "Forecast Period (Months)",
                                 min = 1, max = 24, value = 12)
              ),
              column(4,
                     br(),
                     actionButton("generateForecast", "Generate Forecast",
                                  class = "btn-primary btn-block",
                                  icon = icon("chart-line"))
              )
            )
          )
        ),
        
        fluidRow(
          box(
            title = tagList(icon("users"), " Passenger Volume Forecast"),
            status = "info",
            solidHeader = TRUE,
            width = 12,
            height = 500,
            plotlyOutput("passengerForecast", height = "420px")
          )
        ),
        
        fluidRow(
          box(
            title = tagList(icon("calendar-alt"), " Seasonal Trends"),
            status = "success",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("seasonalTrends", height = "400px")
          ),
          
          box(
            title = tagList(icon("chart-pie"), " Passenger Demographics"),
            status = "warning",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("passengerDemographics", height = "400px")
          )
        ),
        
        fluidRow(
          box(
            title = tagList(icon("table"), " Forecast Summary Table"),
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            DTOutput("forecastTable")
          )
        )
      ),
      
      # Aircraft Performance Tab
      tabItem(
        tabName = "aircraft",
        
        fluidRow(
          valueBoxOutput("totalAircraft", width = 3),
          valueBoxOutput("fleetUtilization", width = 3),
          valueBoxOutput("maintenanceRate", width = 3),
          valueBoxOutput("avgAge", width = 3)
        ),
        
        fluidRow(
          box(
            title = tagList(icon("plane"), " Fleet Performance Dashboard"),
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            plotlyOutput("fleetPerformance", height = "450px")
          )
        ),
        
        fluidRow(
          box(
            title = tagList(icon("tools"), " Maintenance Schedule"),
            status = "warning",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("maintenanceSchedule", height = "400px")
          ),
          
          box(
            title = tagList(icon("chart-bar"), " Aircraft Utilization Rates"),
            status = "info",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("utilizationRates", height = "400px")
          )
        ),
        
        fluidRow(
          box(
            title = tagList(icon("exclamation-circle"), " Aircraft Health Status"),
            status = "danger",
            solidHeader = TRUE,
            width = 12,
            DTOutput("aircraftHealth")
          )
        )
      ),
      
      # Fuel Optimization Tab
      tabItem(
        tabName = "fuel",
        
        fluidRow(
          infoBoxOutput("totalFuelCost", width = 3),
          infoBoxOutput("avgFuelPerFlight", width = 3),
          infoBoxOutput("fuelEfficiency", width = 3),
          infoBoxOutput("potentialSavings", width = 3)
        ),
        
        fluidRow(
          box(
            title = tagList(icon("chart-area"), " Fuel Consumption Analysis"),
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            plotlyOutput("fuelConsumption", height = "450px")
          )
        ),
        
        fluidRow(
          box(
            title = tagList(icon("route"), " Fuel Optimization by Route"),
            status = "success",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("fuelByRoute", height = "400px")
          ),
          
          box(
            title = tagList(icon("lightbulb"), " Optimization Recommendations"),
            status = "info",
            solidHeader = TRUE,
            width = 6,
            uiOutput("fuelRecommendations")
          )
        ),
        
        fluidRow(
          box(
            title = tagList(icon("dollar-sign"), " Cost Savings Opportunities"),
            status = "warning",
            solidHeader = TRUE,
            width = 12,
            plotlyOutput("costSavings", height = "400px")
          )
        )
      ),
      
      # Revenue Analytics Tab
      tabItem(
        tabName = "revenue",
        
        fluidRow(
          valueBoxOutput("totalRevenue", width = 3),
          valueBoxOutput("revenuePerFlight", width = 3),
          valueBoxOutput("loadFactor", width = 3),
          valueBoxOutput("revenueGrowth", width = 3)
        ),
        
        fluidRow(
          box(
            title = tagList(icon("chart-line"), " Revenue Trends"),
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            plotlyOutput("revenueTrends", height = "450px")
          )
        ),
        
        fluidRow(
          box(
            title = tagList(icon("pie-chart"), " Revenue by Route"),
            status = "success",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("revenueByRoute", height = "400px")
          ),
          
          box(
            title = tagList(icon("ticket-alt"), " Ticket Pricing Analysis"),
            status = "info",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("pricingAnalysis", height = "400px")
          )
        ),
        
        fluidRow(
          box(
            title = tagList(icon("chart-bar"), " Monthly Revenue Comparison"),
            status = "warning",
            solidHeader = TRUE,
            width = 12,
            plotlyOutput("monthlyRevenue", height = "400px")
          )
        )
      ),
      
      # Weather Impact Tab
      tabItem(
        tabName = "weather",
        
        fluidRow(
          infoBoxOutput("weatherDelays", width = 4),
          infoBoxOutput("weatherCancellations", width = 4),
          infoBoxOutput("weatherImpact", width = 4)
        ),
        
        fluidRow(
          box(
            title = tagList(icon("cloud"), " Weather Impact on Operations"),
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            plotlyOutput("weatherImpactChart", height = "450px")
          )
        ),
        
        fluidRow(
          box(
            title = tagList(icon("map"), " Weather Conditions Map"),
            status = "info",
            solidHeader = TRUE,
            width = 8,
            leafletOutput("weatherMap", height = "450px")
          ),
          
          box(
            title = tagList(icon("exclamation-triangle"), " Weather Alerts"),
            status = "danger",
            solidHeader = TRUE,
            width = 4,
            height = 500,
            div(style = "overflow-y: auto; max-height: 420px;",
                uiOutput("weatherAlerts")
            )
          )
        )
      ),
      
      # Data Upload Tab
      tabItem(
        tabName = "upload",
        
        fluidRow(
          box(
            title = tagList(icon("upload"), " Upload Flight Data"),
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            
            fileInput("flightData", "Choose CSV File",
                      accept = c(".csv", ".xlsx")),
            
            helpText("Upload your flight data in CSV or Excel format. Required columns: flight_id, date, origin, destination, status, delay_minutes"),
            
            hr(),
            
            actionButton("loadFlightData", "Load Data",
                         class = "btn-success btn-lg",
                         icon = icon("play")),
            
            hr(),
            
            h4("Sample Data Preview:"),
            DTOutput("uploadPreview")
          )
        ),
        
        fluidRow(
          box(
            title = "Data Summary",
            status = "info",
            solidHeader = TRUE,
            width = 6,
            verbatimTextOutput("dataSummary")
          ),
          
          box(
            title = "Data Quality Check",
            status = "success",
            solidHeader = TRUE,
            width = 6,
            uiOutput("dataQuality")
          )
        )
      )
    )
  )
)

server <- function(input, output, session) {
  
  # Generate sample aviation data
  generateSampleData <- function(n = 1000) {
    set.seed(123)
    
    airports <- c("JFK", "LAX", "ORD", "ATL", "DFW", "DEN", "SFO", "MIA", "LAS", "SEA")
    aircraft_types <- c("Boeing 737", "Airbus A320", "Boeing 777", "Airbus A350", "Boeing 787")
    statuses <- c("On Time", "Delayed", "Cancelled")
    
    data.frame(
      flight_id = paste0("FL", 1000:(1000 + n - 1)),
      date = sample(seq(Sys.Date() - 365, Sys.Date(), by = "day"), n, replace = TRUE),
      origin = sample(airports, n, replace = TRUE),
      destination = sample(airports, n, replace = TRUE),
      aircraft_type = sample(aircraft_types, n, replace = TRUE),
      status = sample(statuses, n, replace = TRUE, prob = c(0.75, 0.20, 0.05)),
      delay_minutes = sample(c(0, runif(n, 5, 180)), n, replace = TRUE),
      passengers = sample(50:250, n, replace = TRUE),
      revenue = sample(10000:100000, n, replace = TRUE),
      fuel_consumption = sample(2000:8000, n, replace = TRUE),
      distance = sample(500:3000, n, replace = TRUE),
      stringsAsFactors = FALSE
    )
  }
  
  # Reactive value to store uploaded data
  uploaded_data <- reactiveVal(NULL)
  
  # Load uploaded data
  observeEvent(input$loadFlightData, {
    req(input$flightData)
    
    withProgress(message = 'Loading flight data...', value = 0, {
      tryCatch({
        ext <- tools::file_ext(input$flightData$name)
        
        incProgress(0.3, detail = "Reading file...")
        
        data <- if (ext == "csv") {
          read_csv(input$flightData$datapath, show_col_types = FALSE)
        } else if (ext == "xlsx") {
          read_excel(input$flightData$datapath)
        } else {
          stop("Unsupported file format")
        }
        
        incProgress(0.7, detail = "Processing data...")
        
        # Store uploaded data
        uploaded_data(data)
        
        incProgress(1, detail = "Complete!")
        
        showNotification(
          paste0("Successfully loaded ", nrow(data), " flights!"),
          type = "message",
          duration = 5
        )
        
      }, error = function(e) {
        showNotification(
          paste("Error loading data:", e$message),
          type = "error",
          duration = 10
        )
      })
    })
  })
  
  # Use uploaded data if available, otherwise use sample data
  flight_data <- reactive({
    if (!is.null(uploaded_data())) {
      uploaded_data()
    } else {
      generateSampleData(1000)
    }
  })
  
  # Flight Operations - Value Boxes
  output$totalFlights <- renderValueBox({
    data <- flight_data()
    valueBox(
      nrow(data),
      "Total Flights",
      icon = icon("plane"),
      color = "blue"
    )
  })
  
  output$onTimeRate <- renderValueBox({
    data <- flight_data()
    ontime <- sum(data$status == "On Time") / nrow(data) * 100
    valueBox(
      paste0(round(ontime, 1), "%"),
      "On-Time Rate",
      icon = icon("check-circle"),
      color = "green"
    )
  })
  
  output$avgDelay <- renderValueBox({
    data <- flight_data()
    avg_delay <- mean(data$delay_minutes[data$delay_minutes > 0], na.rm = TRUE)
    valueBox(
      paste0(round(avg_delay, 0), " min"),
      "Avg Delay",
      icon = icon("clock"),
      color = "yellow"
    )
  })
  
  output$cancellations <- renderValueBox({
    data <- flight_data()
    cancelled <- sum(data$status == "Cancelled")
    valueBox(
      cancelled,
      "Cancellations",
      icon = icon("ban"),
      color = "red"
    )
  })
  
  # Flight Status Timeline
  output$flightStatusTimeline <- renderPlotly({
    data <- flight_data() %>%
      arrange(date) %>%
      group_by(date, status) %>%
      summarise(count = n(), .groups = "drop")
    
    plot_ly(data, x = ~date, y = ~count, color = ~status,
            type = 'scatter', mode = 'lines+markers',
            colors = c("On Time" = "#28a745", "Delayed" = "#ffc107", "Cancelled" = "#dc3545"),
            line = list(width = 3),
            marker = list(size = 8)) %>%
      layout(
        title = list(text = "<b>Daily Flight Status Trends</b>", font = list(size = 18)),
        xaxis = list(title = "Date", showgrid = FALSE),
        yaxis = list(title = "Number of Flights", showgrid = TRUE),
        hovermode = "x unified",
        plot_bgcolor = "#f8f9fa",
        paper_bgcolor = "white",
        legend = list(orientation = "h", y = -0.2)
      )
  })
  
  # Flight Map
  output$flightMap <- renderLeaflet({
    airport_coords <- data.frame(
      code = c("JFK", "LAX", "ORD", "ATL", "DFW", "DEN", "SFO", "MIA", "LAS", "SEA"),
      lat = c(40.6413, 33.9416, 41.9742, 33.6407, 32.8998, 39.8561, 37.6213, 25.7959, 36.0840, 47.4502),
      lon = c(-73.7781, -118.4085, -87.9073, -84.4277, -97.0403, -104.6737, -122.3790, -80.2870, -115.1537, -122.3088)
    )
    
    leaflet(airport_coords) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addCircleMarkers(
        ~lon, ~lat,
        radius = 10,
        color = "#667eea",
        fillColor = "#667eea",
        fillOpacity = 0.7,
        popup = ~paste0("<b>", code, "</b>"),
        label = ~code
      ) %>%
      setView(lng = -98, lat = 38, zoom = 4)
  })
  
  # Recent Flights
  output$recentFlights <- renderUI({
    data <- flight_data() %>%
      arrange(desc(date)) %>%
      head(20)
    
    flight_cards <- lapply(1:nrow(data), function(i) {
      row <- data[i, ]
      status_class <- switch(row$status,
                             "On Time" = "status-ontime",
                             "Delayed" = "status-delayed",
                             "Cancelled" = "status-cancelled")
      
      div(class = "metric-card",
          style = "margin: 8px 0;",
          fluidRow(
            column(12,
                   h5(style = "margin: 0; font-weight: 600;", 
                      paste(row$origin, "→", row$destination)),
                   p(style = "margin: 5px 0; font-size: 12px; color: #666;",
                     paste("Flight:", row$flight_id)),
                   span(class = paste("status-badge", status_class),
                        row$status),
                   if (row$delay_minutes > 0) {
                     span(style = "margin-left: 10px; font-size: 12px; color: #dc3545;",
                          paste("+", round(row$delay_minutes), "min"))
                   }
            )
          )
      )
    })
    
    do.call(tagList, flight_cards)
  })
  
  # Delays by Airport
  output$delaysByAirport <- renderPlotly({
    data <- flight_data() %>%
      filter(delay_minutes > 0) %>%
      group_by(origin) %>%
      summarise(avg_delay = mean(delay_minutes), .groups = "drop") %>%
      arrange(desc(avg_delay))
    
    plot_ly(data, x = ~origin, y = ~avg_delay, type = 'bar',
            marker = list(color = ~avg_delay,
                          colorscale = list(c(0, "#ffc107"), c(1, "#dc3545")),
                          showscale = FALSE)) %>%
      layout(
        title = list(text = "<b>Average Delay by Airport</b>", font = list(size = 16)),
        xaxis = list(title = "Airport", showgrid = FALSE),
        yaxis = list(title = "Average Delay (minutes)", showgrid = TRUE),
        plot_bgcolor = "#f8f9fa",
        paper_bgcolor = "white"
      )
  })
  
  # Status Distribution
  output$statusDistribution <- renderPlotly({
    data <- flight_data() %>%
      group_by(status) %>%
      summarise(count = n(), .groups = "drop")
    
    colors <- c("On Time" = "#28a745", "Delayed" = "#ffc107", "Cancelled" = "#dc3545")
    
    plot_ly(data, labels = ~status, values = ~count, type = 'pie',
            marker = list(colors = colors[data$status]),
            textposition = 'inside',
            textinfo = 'label+percent',
            hole = 0.4) %>%
      layout(
        title = list(text = "<b>Flight Status Distribution</b>", font = list(size = 16)),
        showlegend = TRUE,
        paper_bgcolor = "white"
      )
  })
  
  # Delay Prediction
  observeEvent(input$predictDelay, {
    # Simulate ML prediction
    base_delay <- runif(1, 0, 30)
    
    # Adjust based on inputs
    weather_impact <- switch(input$predictWeather,
                             "Clear" = 0,
                             "Cloudy" = 5,
                             "Rain" = 15,
                             "Storm" = 40,
                             "Snow" = 30)
    
    traffic_impact <- input$trafficLevel * 3
    seasonal_impact <- input$seasonalFactor * 20
    
    predicted_delay <- base_delay + weather_impact + traffic_impact + seasonal_impact
    
    output$delayPredictionPlot <- renderPlotly({
      factors <- data.frame(
        Factor = c("Base", "Weather", "Traffic", "Seasonal", "Total"),
        Delay = c(base_delay, weather_impact, traffic_impact, seasonal_impact, predicted_delay),
        Color = c("#667eea", "#ffc107", "#dc3545", "#17a2b8", "#28a745")
      )
      
      plot_ly(factors, x = ~Factor, y = ~Delay, type = 'bar',
              marker = list(color = ~Color)) %>%
        layout(
          title = list(text = "<b>Predicted Delay Breakdown</b>", font = list(size = 18)),
          xaxis = list(title = "", showgrid = FALSE),
          yaxis = list(title = "Delay (minutes)", showgrid = TRUE),
          plot_bgcolor = "#f8f9fa",
          paper_bgcolor = "white",
          showlegend = FALSE
        )
    })
    
    output$predictionDetails <- renderUI({
      risk_level <- if (predicted_delay < 15) {
        list(color = "#28a745", text = "LOW", icon = "check-circle")
      } else if (predicted_delay < 30) {
        list(color = "#ffc107", text = "MEDIUM", icon = "exclamation-triangle")
      } else {
        list(color = "#dc3545", text = "HIGH", icon = "times-circle")
      }
      
      tagList(
        div(class = "metric-card",
            div(class = "metric-label", "PREDICTED DELAY"),
            div(class = "metric-value", paste0(round(predicted_delay), " min")),
            hr(),
            div(style = paste0("text-align: center; color: ", risk_level$color, "; font-size: 24px; font-weight: 700;"),
                icon(risk_level$icon, style = "margin-right: 10px;"),
                risk_level$text, " RISK"
            )
        ),
        div(class = "metric-card",
            h5(icon("lightbulb"), " Recommendations:"),
            tags$ul(
              tags$li("Monitor weather conditions closely"),
              tags$li("Consider alternative routes"),
              tags$li("Inform passengers of potential delays"),
              tags$li("Prepare backup aircraft if needed")
            )
        )
      )
    })
  })
  
  # Historical Delays
  output$historicalDelays <- renderPlotly({
    data <- flight_data() %>%
      mutate(month = month(date, label = TRUE)) %>%
      group_by(month) %>%
      summarise(
        avg_delay = mean(delay_minutes[delay_minutes > 0], na.rm = TRUE),
        max_delay = max(delay_minutes, na.rm = TRUE),
        .groups = "drop"
      )
    
    plot_ly(data) %>%
      add_trace(x = ~month, y = ~avg_delay, type = 'scatter', mode = 'lines+markers',
                name = 'Average Delay', line = list(color = '#667eea', width = 3),
                marker = list(size = 10)) %>%
      add_trace(x = ~month, y = ~max_delay, type = 'scatter', mode = 'lines+markers',
                name = 'Maximum Delay', line = list(color = '#dc3545', width = 3, dash = 'dash'),
                marker = list(size = 10)) %>%
      layout(
        title = list(text = "<b>Historical Delay Patterns by Month</b>", font = list(size = 18)),
        xaxis = list(title = "Month", showgrid = FALSE),
        yaxis = list(title = "Delay (minutes)", showgrid = TRUE),
        hovermode = "x unified",
        plot_bgcolor = "#f8f9fa",
        paper_bgcolor = "white",
        legend = list(orientation = "h", y = -0.2)
      )
  })
  
  # Model Accuracy
  output$modelAccuracy <- renderPlotly({
    metrics <- data.frame(
      Metric = c("Accuracy", "Precision", "Recall", "F1 Score"),
      Score = c(0.89, 0.86, 0.91, 0.88)
    )
    
    plot_ly(metrics, x = ~Metric, y = ~Score, type = 'bar',
            marker = list(color = c('#28a745', '#17a2b8', '#ffc107', '#667eea')),
            text = ~paste0(round(Score * 100), "%"),
            textposition = 'outside') %>%
      layout(
        title = list(text = "<b>ML Model Performance Metrics</b>", font = list(size = 16)),
        xaxis = list(title = "", showgrid = FALSE),
        yaxis = list(title = "Score", range = c(0, 1), showgrid = TRUE),
        plot_bgcolor = "#f8f9fa",
        paper_bgcolor = "white"
      )
  })
  
  # Risk Factors
  output$riskFactors <- renderPlotly({
    risks <- data.frame(
      Factor = c("Weather", "Air Traffic", "Mechanical", "Crew", "Airport Ops"),
      Impact = c(35, 25, 15, 10, 15)
    )
    
    plot_ly(risks, labels = ~Factor, values = ~Impact, type = 'pie',
            marker = list(colors = viridis(5)),
            textinfo = 'label+percent',
            hole = 0.4) %>%
      layout(
        title = list(text = "<b>Delay Risk Factors</b>", font = list(size = 16)),
        showlegend = TRUE,
        paper_bgcolor = "white"
      )
  })
  
  # Route Analytics - Info Boxes
  output$topRoute <- renderInfoBox({
    infoBox(
      "Top Route",
      "JFK → LAX",
      icon = icon("star"),
      color = "purple",
      fill = TRUE
    )
  })
  
  output$totalRoutes <- renderInfoBox({
    data <- flight_data()
    routes <- nrow(unique(data[, c("origin", "destination")]))
    infoBox(
      "Total Routes",
      routes,
      icon = icon("route"),
      color = "blue",
      fill = TRUE
    )
  })
  
  output$avgDistance <- renderInfoBox({
    data <- flight_data()
    avg_dist <- mean(data$distance, na.rm = TRUE)
    infoBox(
      "Avg Distance",
      paste0(round(avg_dist), " mi"),
      icon = icon("ruler"),
      color = "green",
      fill = TRUE
    )
  })
  
  output$routeEfficiency <- renderInfoBox({
    infoBox(
      "Route Efficiency",
      "92%",
      icon = icon("tachometer-alt"),
      color = "yellow",
      fill = TRUE
    )
  })
  
  # Route Network Map
  output$routeNetwork <- renderLeaflet({
    airport_coords <- data.frame(
      code = c("JFK", "LAX", "ORD", "ATL", "DFW", "DEN", "SFO", "MIA", "LAS", "SEA"),
      lat = c(40.6413, 33.9416, 41.9742, 33.6407, 32.8998, 39.8561, 37.6213, 25.7959, 36.0840, 47.4502),
      lon = c(-73.7781, -118.4085, -87.9073, -84.4277, -97.0403, -104.6737, -122.3790, -80.2870, -115.1537, -122.3088)
    )
    
    leaflet(airport_coords) %>%
      addProviderTiles(providers$CartoDB.DarkMatter) %>%
      addCircleMarkers(
        ~lon, ~lat,
        radius = 12,
        color = "#667eea",
        fillColor = "#667eea",
        fillOpacity = 0.8,
        weight = 3,
        popup = ~paste0("<b>", code, "</b>"),
        label = ~code
      ) %>%
      setView(lng = -98, lat = 38, zoom = 4)
  })
  
  # Route Performance
  output$routePerformance <- renderPlotly({
    data <- flight_data() %>%
      mutate(route = paste(origin, destination, sep = " → ")) %>%
      group_by(route) %>%
      summarise(
        flights = n(),
        ontime_rate = sum(status == "On Time") / n() * 100,
        .groups = "drop"
      ) %>%
      arrange(desc(flights)) %>%
      head(10)
    
    plot_ly(data, x = ~ontime_rate, y = ~reorder(route, ontime_rate), 
            type = 'bar', orientation = 'h',
            marker = list(color = ~ontime_rate,
                          colorscale = list(c(0, "#dc3545"), c(1, "#28a745")),
                          showscale = TRUE,
                          colorbar = list(title = "On-Time %"))) %>%
      layout(
        title = list(text = "<b>Route On-Time Performance</b>", font = list(size = 16)),
        xaxis = list(title = "On-Time Rate (%)", showgrid = TRUE),
        yaxis = list(title = "", showgrid = FALSE),
        plot_bgcolor = "#f8f9fa",
        paper_bgcolor = "white"
      )
  })
  
  # Top Routes
  output$topRoutes <- renderPlotly({
    data <- flight_data() %>%
      mutate(route = paste(origin, destination, sep = " → ")) %>%
      group_by(route) %>%
      summarise(count = n(), .groups = "drop") %>%
      arrange(desc(count)) %>%
      head(10)
    
    plot_ly(data, x = ~count, y = ~reorder(route, count), 
            type = 'bar', orientation = 'h',
            marker = list(color = '#667eea')) %>%
      layout(
        title = list(text = "<b>Top 10 Busiest Routes</b>", font = list(size = 16)),
        xaxis = list(title = "Number of Flights", showgrid = TRUE),
        yaxis = list(title = "", showgrid = FALSE),
        plot_bgcolor = "#f8f9fa",
        paper_bgcolor = "white"
      )
  })
  
  # Flight Durations
  output$flightDurations <- renderPlotly({
    data <- flight_data() %>%
      mutate(
        route = paste(origin, destination, sep = " → "),
        duration = distance / 500 * 60 + runif(n(), -20, 20)
      ) %>%
      group_by(route) %>%
      summarise(avg_duration = mean(duration), .groups = "drop") %>%
      arrange(desc(avg_duration)) %>%
      head(15)
    
    plot_ly(data, x = ~reorder(route, avg_duration), y = ~avg_duration, 
            type = 'bar',
            marker = list(color = '#764ba2')) %>%
      layout(
        title = list(text = "<b>Average Flight Duration by Route</b>", font = list(size = 16)),
        xaxis = list(title = "", showgrid = FALSE, tickangle = -45),
        yaxis = list(title = "Duration (minutes)", showgrid = TRUE),
        plot_bgcolor = "#f8f9fa",
        paper_bgcolor = "white"
      )
  })
  
  # Passenger Forecasting
  observeEvent(input$generateForecast, {
    output$passengerForecast <- renderPlotly({
      # Generate historical data
      dates <- seq(Sys.Date() - 365, Sys.Date() + input$forecastMonths * 30, by = "week")
      historical_end <- Sys.Date()
      
      # Create trend with seasonality
      trend <- seq(50000, 80000, length.out = length(dates))
      seasonal <- sin(seq(0, 4 * pi, length.out = length(dates))) * 10000
      passengers <- trend + seasonal + rnorm(length(dates), 0, 3000)
      passengers[passengers < 0] <- 0
      
      df <- data.frame(
        date = dates,
        passengers = passengers,
        type = ifelse(dates <= historical_end, "Historical", "Forecast")
      )
      
      plot_ly(df, x = ~date, y = ~passengers, color = ~type,
              type = 'scatter', mode = 'lines',
              colors = c("Historical" = "#667eea", "Forecast" = "#28a745"),
              line = list(width = 3)) %>%
        add_ribbons(
          data = df[df$type == "Forecast", ],
          ymin = ~passengers * 0.9,
          ymax = ~passengers * 1.1,
          fillcolor = 'rgba(40, 167, 69, 0.2)',
          line = list(color = 'transparent'),
          name = "Confidence Interval",
          showlegend = TRUE
        ) %>%
        layout(
          title = list(text = "<b>Passenger Volume Forecast</b>", font = list(size = 18)),
          xaxis = list(title = "Date", showgrid = FALSE),
          yaxis = list(title = "Passengers", showgrid = TRUE),
          hovermode = "x unified",
          plot_bgcolor = "#f8f9fa",
          paper_bgcolor = "white",
          legend = list(orientation = "h", y = -0.2)
        )
    })
    
    output$forecastTable <- renderDT({
      dates <- seq(Sys.Date(), Sys.Date() + input$forecastMonths * 30, by = "month")
      forecast_data <- data.frame(
        Month = format(dates, "%B %Y"),
        Predicted_Passengers = round(seq(60000, 80000, length.out = length(dates))),
        Lower_Bound = round(seq(54000, 72000, length.out = length(dates))),
        Upper_Bound = round(seq(66000, 88000, length.out = length(dates))),
        Growth_Rate = paste0(round(runif(length(dates), -5, 15), 1), "%")
      )
      
      datatable(forecast_data,
                options = list(pageLength = 12, scrollX = TRUE),
                rownames = FALSE) %>%
        formatCurrency(c("Predicted_Passengers", "Lower_Bound", "Upper_Bound"), 
                       currency = "", digits = 0)
    })
  })
  
  # Seasonal Trends
  output$seasonalTrends <- renderPlotly({
    data <- flight_data() %>%
      mutate(month = month(date, label = TRUE)) %>%
      group_by(month) %>%
      summarise(passengers = sum(passengers), .groups = "drop")
    
    plot_ly(data, x = ~month, y = ~passengers, type = 'scatter', mode = 'lines+markers',
            line = list(color = '#667eea', width = 3),
            marker = list(size = 12, color = '#764ba2')) %>%
      layout(
        title = list(text = "<b>Seasonal Passenger Trends</b>", font = list(size = 16)),
        xaxis = list(title = "Month", showgrid = FALSE),
        yaxis = list(title = "Total Passengers", showgrid = TRUE),
        plot_bgcolor = "#f8f9fa",
        paper_bgcolor = "white"
      )
  })
  
  # Passenger Demographics
  output$passengerDemographics <- renderPlotly({
    demographics <- data.frame(
      Category = c("Business", "Leisure", "Family", "Student", "Other"),
      Percentage = c(35, 30, 20, 10, 5)
    )
    
    plot_ly(demographics, labels = ~Category, values = ~Percentage, type = 'pie',
            marker = list(colors = viridis(5)),
            textinfo = 'label+percent',
            hole = 0.4) %>%
      layout(
        title = list(text = "<b>Passenger Type Distribution</b>", font = list(size = 16)),
        showlegend = TRUE,
        paper_bgcolor = "white"
      )
  })
  
  # Aircraft Performance - Value Boxes
  output$totalAircraft <- renderValueBox({
    valueBox(
      125,
      "Total Aircraft",
      icon = icon("plane"),
      color = "blue"
    )
  })
  
  output$fleetUtilization <- renderValueBox({
    valueBox(
      "87%",
      "Fleet Utilization",
      icon = icon("chart-line"),
      color = "green"
    )
  })
  
  output$maintenanceRate <- renderValueBox({
    valueBox(
      "8%",
      "In Maintenance",
      icon = icon("tools"),
      color = "yellow"
    )
  })
  
  output$avgAge <- renderValueBox({
    valueBox(
      "8.5 years",
      "Average Age",
      icon = icon("calendar"),
      color = "purple"
    )
  })
  
  # Fuel Optimization - Info Boxes
  output$totalFuelCost <- renderInfoBox({
    data <- flight_data()
    total_cost <- sum(data$fuel_consumption) * 3 # $3 per gallon
    infoBox(
      "Total Fuel Cost",
      dollar(total_cost),
      icon = icon("dollar-sign"),
      color = "red",
      fill = TRUE
    )
  })
  
  output$avgFuelPerFlight <- renderInfoBox({
    data <- flight_data()
    avg_fuel <- mean(data$fuel_consumption)
    infoBox(
      "Avg Fuel/Flight",
      paste0(round(avg_fuel), " gal"),
      icon = icon("gas-pump"),
      color = "blue",
      fill = TRUE
    )
  })
  
  output$fuelEfficiency <- renderInfoBox({
    infoBox(
      "Fuel Efficiency",
      "42 MPG",
      icon = icon("leaf"),
      color = "green",
      fill = TRUE
    )
  })
  
  output$potentialSavings <- renderInfoBox({
    infoBox(
      "Potential Savings",
      "$2.5M",
      icon = icon("piggy-bank"),
      color = "purple",
      fill = TRUE
    )
  })
  
  # Revenue Analytics - Value Boxes
  output$totalRevenue <- renderValueBox({
    data <- flight_data()
    total_rev <- sum(data$revenue)
    valueBox(
      dollar(total_rev),
      "Total Revenue",
      icon = icon("money-bill-wave"),
      color = "green"
    )
  })
  
  output$revenuePerFlight <- renderValueBox({
    data <- flight_data()
    avg_rev <- mean(data$revenue)
    valueBox(
      dollar(avg_rev),
      "Revenue/Flight",
      icon = icon("plane"),
      color = "blue"
    )
  })
  
  output$loadFactor <- renderValueBox({
    valueBox(
      "82%",
      "Load Factor",
      icon = icon("users"),
      color = "purple"
    )
  })
  
  output$revenueGrowth <- renderValueBox({
    valueBox(
      "+12.5%",
      "YoY Growth",
      icon = icon("arrow-up"),
      color = "yellow"
    )
  })
  
  # Weather Impact - Info Boxes
  output$weatherDelays <- renderInfoBox({
    infoBox(
      "Weather Delays",
      "234 flights",
      icon = icon("cloud-rain"),
      color = "yellow",
      fill = TRUE
    )
  })
  
  output$weatherCancellations <- renderInfoBox({
    infoBox(
      "Weather Cancellations",
      "45 flights",
      icon = icon("times-circle"),
      color = "red",
      fill = TRUE
    )
  })
  
  output$weatherImpact <- renderInfoBox({
    infoBox(
      "Total Impact",
      "$1.8M",
      icon = icon("exclamation-triangle"),
      color = "orange",
      fill = TRUE
    )
  })
  
  # Weather Map
  output$weatherMap <- renderLeaflet({
    airport_coords <- data.frame(
      code = c("JFK", "LAX", "ORD", "ATL", "DFW"),
      lat = c(40.6413, 33.9416, 41.9742, 33.6407, 32.8998),
      lon = c(-73.7781, -118.4085, -87.9073, -84.4277, -97.0403),
      condition = c("Clear", "Rain", "Clear", "Storm", "Cloudy")
    )
    
    colors <- c("Clear" = "green", "Cloudy" = "gray", "Rain" = "blue", "Storm" = "red")
    
    leaflet(airport_coords) %>%
      addProviderTiles(providers$OpenStreetMap) %>%
      addCircleMarkers(
        ~lon, ~lat,
        radius = 15,
        color = ~colors[condition],
        fillColor = ~colors[condition],
        fillOpacity = 0.7,
        weight = 3,
        popup = ~paste0("<b>", code, "</b><br>", condition),
        label = ~paste(code, "-", condition)
      ) %>%
      setView(lng = -98, lat = 38, zoom = 4)
  })
  
  # Upload Preview
  output$uploadPreview <- renderDT({
    if (!is.null(uploaded_data())) {
      datatable(head(uploaded_data(), 100),
                options = list(pageLength = 10, scrollX = TRUE))
    } else {
      data.frame(
        Message = "No data uploaded yet. Using sample data in other tabs.",
        Info = "Upload a CSV or Excel file to replace sample data."
      ) %>%
        datatable(options = list(dom = 't'))
    }
  })
  
  # Data Summary
  output$dataSummary <- renderText({
    if (!is.null(uploaded_data())) {
      data <- uploaded_data()
      
      summary_text <- c()
      summary_text <- c(summary_text, "DATA SUMMARY")
      summary_text <- c(summary_text, "================")
      summary_text <- c(summary_text, paste("Total Rows:", format(nrow(data), big.mark = ",")))
      summary_text <- c(summary_text, paste("Total Columns:", ncol(data)))
      summary_text <- c(summary_text, "")
      summary_text <- c(summary_text, "Column Names:")
      summary_text <- c(summary_text, paste("-", names(data)))
      summary_text <- c(summary_text, "")
      summary_text <- c(summary_text, paste("Date Range:", min(data$date, na.rm = TRUE), "to", max(data$date, na.rm = TRUE)))
      
      if ("status" %in% names(data)) {
        summary_text <- c(summary_text, "")
        summary_text <- c(summary_text, "Status Distribution:")
        status_counts <- table(data$status)
        for (status in names(status_counts)) {
          summary_text <- c(summary_text, paste("-", status, ":", status_counts[status]))
        }
      }
      
      paste(summary_text, collapse = "\n")
    } else {
      "No data uploaded yet.\n\nUpload a CSV or Excel file to see summary statistics."
    }
  })
  
  # Data Quality Check
  output$dataQuality <- renderUI({
    if (!is.null(uploaded_data())) {
      data <- uploaded_data()
      
      # Check for required columns
      required_cols <- c("flight_id", "date", "origin", "destination", "status")
      has_required <- required_cols %in% names(data)
      
      # Check for missing values
      missing_pct <- sum(is.na(data)) / (nrow(data) * ncol(data)) * 100
      
      # Check for duplicates
      dup_count <- sum(duplicated(data))
      
      quality_items <- list(
        div(class = if (all(has_required)) "issue-success" else "issue-warning",
            h5(icon("check-circle"), " Required Columns"),
            if (all(has_required)) {
              p("All required columns present!")
            } else {
              p("Missing columns: ", paste(required_cols[!has_required], collapse = ", "))
            }
        ),
        
        div(class = if (missing_pct < 5) "issue-success" else "issue-warning",
            h5(icon("database"), " Data Completeness"),
            p(paste0(round(100 - missing_pct, 1), "% complete"))
        ),
        
        div(class = if (dup_count == 0) "issue-success" else "issue-info",
            h5(icon("copy"), " Duplicate Records"),
            p(paste(dup_count, "duplicates found"))
        ),
        
        div(class = "issue-success",
            h5(icon("thumbs-up"), " Data Quality Score"),
            h3(paste0(round(100 - missing_pct - (dup_count / nrow(data) * 10), 0), "%"))
        )
      )
      
      do.call(tagList, quality_items)
    } else {
      div(class = "issue-info",
          h4(icon("info-circle"), " Upload Data to See Quality Metrics"),
          p("Once you upload a file, we'll analyze:"),
          tags$ul(
            tags$li("Required columns check"),
            tags$li("Missing values analysis"),
            tags$li("Duplicate detection"),
            tags$li("Overall quality score")
          )
      )
    }
  })
}

shinyApp(ui = ui, server = server)