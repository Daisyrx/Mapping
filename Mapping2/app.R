# Mapping Assignment Problem 2
# Runxin Yu

pacman::p_load(shiny,leaflet,tidyverse,leaflet.extras)

schools <- read.csv("Colledge and Universities.csv")
schools <- schools[-c(58:60),]

# Define UI for application that draws a histogram
ui <- fluidPage(

    titlePanel("Colleges and Universities"),
       
            leafletOutput(outputId = "mymap"),
            absolutePanel(top = 60, left = 20, 
                          checkboxInput("markers", "Match Type", FALSE),
                          checkboxInput("heat", "Heatmap", FALSE)
            )
        )
    

server <- function(input,output,session) {
    pal <- colorFactor(
        palette = c('blue', 'yellow', 'red'),
        domain = schools$Match_type
    )
    #create the map
    output$mymap <- renderLeaflet({
        leaflet(schools) %>% 
            setView(lng = -71, lat = 42.5, zoom = 8)  %>% #setting the view over ~ center of North America
            addTiles() %>% 
            addCircles(data = schools, lat = ~ Latitude, lng = ~ Longitude, weight = 1, fillOpacity = 0.5)
    })
    observe({
        proxy <- leafletProxy("mymap", data = schools)
        proxy %>% clearMarkers()
        if (input$markers) {
            proxy %>% addCircleMarkers(stroke = FALSE, color = ~pal(Match_type), fillOpacity = 0.2) %>%
                addLegend("bottomright", pal = pal, values = schools$Match_type,
                          title = "Match Type",
                          opacity = 1)}
        else {
            proxy %>% clearMarkers() %>% clearControls()
        }
    })
    observe({
        proxy <- leafletProxy("mymap", data = schools)
        proxy %>% clearMarkers()
        if (input$heat) {
            proxy %>%  addHeatmap(lng=~Longitude, lat=~Latitude, blur =  10, max = 0.05, radius = 15) 
        }
        else{
            proxy %>% clearHeatmap()
        }
        
        
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
