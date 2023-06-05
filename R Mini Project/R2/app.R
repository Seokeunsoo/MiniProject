birth_data <- read.csv("teamproject6\\2015출생.csv")

library(shiny)
library(ggplot2)
library(png)
library(grid)
library(dplyr)
library(corrplot)
# 필요한 부, 모의 나이, 출생아체중량, 임신주수만 가져오기
# birth_data= birth_data[,2:6]
birth_data= birth_data[,2:6]

str(birth_data)

# 출생자 성별코드를 남자(male) 또는 여자(female)로 변환
birth_data$출생자성별코드 <- ifelse(birth_data$출생자성별코드 == 1, "남자", "여자")

head(birth_data)
str(birth_data)

# 자료가 40만개 이상이어서 설문에따른 결측값 400개 제거
nrow(birth_data[birth_data$임신주수 == 0, ])
nrow(birth_data[birth_data$출생아체중량 < 0.4,])
nrow(birth_data[birth_data$모_연령 == 99,])
nrow(birth_data[birth_data$부_연령 == 99,])
sum(birth_data$임신주수 == 0 & birth_data$출생아체중량 == 0)

birth_data <- birth_data[!(birth_data$임신주 == 0 | birth_data$출생아체중량 < 0.4), ]
birth_data <- birth_data[!(birth_data$모_연령 == 99 | birth_data$부_연령 == 99), ]

# 내가 쓰고싶은 자료
week_mom = lm(임신주수 ~ 모_연령, data=birth_data)
kg_week <- lm(출생아체중량 ~ 임신주수, data = birth_data)
kg_mom = lm(출생아체중량 ~ 모_연령, data=birth_data)

ui = fluidPage(
    titlePanel('신생아 출생'),
    navbarPage('목차',
                    tabPanel("Table",
                    dataTableOutput('table')
                    ),
                    tabPanel("Summary",
                        verbatimTextOutput("summary"),
                        verbatimTextOutput("str")
                    ),
                    tabPanel("Statistics",
                          sidebarLayout(
                            sidebarPanel(
                              selectInput('xcol', 'X Variable', names(birth_data)),
                              selectInput('ycol', 'Y Variable', names(birth_data),
                                          selected=names(birth_data)[[2]])
                            ),
                            mainPanel(
                              verbatimTextOutput("cor"),
                              plotOutput("corrplot"),
                              verbatimTextOutput("totalcorr")
                            )
                          )
                 ),
                 tabPanel("Plot",
                          sidebarLayout(
                            sidebarPanel(
                              radioButtons("Kind", "Plot type",
                                           c("BIRTH"="p", "임신주수 ~ 모_연령"="week_mom", "출생아체중량 ~ 임신주수"="kg_week", "출생아체중량 ~ 모_연령"="kg_mom")
                              )
                            ),
                            mainPanel(
                              imageOutput("plot")
                            )
                       
))))


server <- function (input, output, session){
    selectedData <- reactive({
    birth_data[, c(input$xcol, input$ycol)]
  })
  
  output$table <- renderDataTable(birth_data, options = list(pageLength = 5)
  )
  
  output$summary <- renderPrint({
    summary(birth_data)
  })
  
  output$str <- renderPrint({
    str(birth_data)
  })
  
  output$cor <- renderPrint({
    cor(selectedData(), use="complete.obs")
  })
  
  output$corrplot <- renderPlot({
    corrplot(cor(birth_data[,2:5], use="complete.obs"))
  })
  
  output$totalcorr <- renderPrint({
    cor(birth_data[,2:5], use="complete.obs")
  })
  
  output$plot <- renderPlot({
    if(input$Kind == "p"){
      img <- readPNG("images\\plot(birth).png")
      ggplot() + 
        theme_void()+
        annotation_custom(rasterGrob(img), xmin=-Inf, xmax=Inf, ymin=-Inf, ymax=Inf)
    }
    else if(input$Kind == "week_mom"){
    img <- readPNG("images\\plot(kg_mom).png")
      ggplot() + 
        theme_void()+
        annotation_custom(rasterGrob(img), xmin=-Inf, xmax=Inf, ymin=-Inf, ymax=Inf)
    }
    else if(input$Kind == "kg_week"){
    img <- readPNG("images\\kg_week.png")
      ggplot() + 
        theme_void()+
        annotation_custom(rasterGrob(img), xmin=-Inf, xmax=Inf, ymin=-Inf, ymax=Inf)
    }
    else if(input$Kind == "kg_mom"){
    img <- readPNG("images\\plot(week_mom1).png")
      ggplot() + 
        theme_void()+
        annotation_custom(rasterGrob(img), xmin=-Inf, xmax=Inf, ymin=-Inf, ymax=Inf)
    }
  })
  
}

shinyApp(ui = ui, server = server)