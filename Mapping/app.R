# Mapping Assignment
# Runxin Yu

pacman::p_load(shiny,plotly,ggmap,maptools,maps,mapproj)

mapWorld <- map_data("world")
mp1 <- ggplot(mapWorld, aes(x=long, y=lat, group=group))+
    geom_polygon(fill="white", color="black") +
    coord_map(xlim=c(-180,180), ylim=c(-60, 90))


ui <- fluidPage(
    
    titlePanel("World Map Different Projection"),
    
    sidebarLayout(
        sidebarPanel(
            selectInput("Projections",
                        "Choose a projection:",
                        c("cylindrical",
                          "mercator",
                          "sinusoidal",
                          "gnomonic",
                          "rectangular",
                          "cylequalarea",
                          "cylindrical",
                          "mollweide",
                          "gilbert",
                          "azequidistant",
                          "orthographic",
                          "laue",
                          "globular"
                        ))
        ),
        
        mainPanel(h3(textOutput("caption")),
                   plotOutput("Project")
        )
    )
)


server <- function(input, output) {
    
    output$Project <- renderPlot({
        if (input$Projections  %in% c("rectangular","cylequalarea")) {
            mp1 + coord_map(input$Projections,parameters = 0,xlim=c(-180,180), ylim=c(-60, 90))
        }  else {
            mp1 + coord_map(input$Projections,xlim=c(-180,180), ylim=c(-60, 90))
        }
    })
}


# Run the application 
shinyApp(ui = ui, server = server)
