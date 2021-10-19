
library(shiny)
library(ggplot2)
library(ggExtra)
library(shinyjqui)
library(shinyWidgets)

shinyUI(
  navbarPage(
    title="shinyggMarginal",
    theme=shinytheme("flatly"),
    windowTitle="Marginal distribution with ggplot2 and ggExtra in Shiny",
    
    tabPanel("ggMarginal",
             tags$style("#var1 {width:100%}",
                        "#var5 {width:100%}"),
             sidebarPanel(width=3,
                          selectInput("seluploaddata", h4("Input Data",
                                                          bsButton("bs00", label="", icon=icon("question"), style="info", size="small")
                          ), c("Upload input data" = "1", "Paste input data" = "2"), "2"),
                          bsPopover("bs00", 'Select Input data type', "可上传或粘贴输入数据，输入数据应该包含两列，分别对应横轴和纵轴的数值", trigger = "focus"),
                          conditionalPanel(condition="input.seluploaddata == '1'",
                                           fileInput("Upload_data", label="", multiple = FALSE),
                                           downloadButton("Example_data.txt", "Download example data"),
                          ),
                          
                          conditionalPanel(condition="input.seluploaddata == '2'",
                                           textAreaInput("Paste_data", label="", width="100%", resize="vertical", 
                                                         height="200px", placeholder = "Paste text to upload data"),
                                           actionButton("Paste_example", strong("Paste example data"), styleclass = "info", width='100%'),
                          ),
                          
                          br(),
                          selectInput('which_margin', 'Which margins?', c("both" = "both", "x" = "x", "y" = "y"), "both"),
                          selectInput('plot_type', 'Set marginal plot type:', c("histogram" = "histogram", "density" = "density", 
                                                                                "boxplot" = "boxplot", "violin" = "violin",
                                                                                "densigram" = "densigram"), 
                                      "histogram"),
                          conditionalPanel(condition="input.plot_type == 'histogram'",
                                           sliderInput("var7", h4("Bin width of histogram:"),
                                                       min = 0.001, max = 1.0,
                                                       value = 0.1, step = 0.01),
                          ),
                          conditionalPanel(condition="input.plot_type == '2'"),
                          conditionalPanel(condition="input.plot_type == 'boxplot'",
                                           radioButtons("outlier", label = "", 
                                                        choices = list("Retain outliers" = 1, "Hide outliers" = 2),
                                                        selected = 1),
                          ),
                          
                          checkboxInput("ggMarcolor", "Plot color", FALSE),
                          conditionalPanel(
                            condition = "input.ggMarcolor",
                            h4("Marginal plot color:",
                               bsButton("bs3", label="", icon=icon("question"), style="info", size="small")
                            ),
                            bsPopover("bs3", '对数据进行绘图时，填充边缘图的颜色，且用户可根据自己喜好更改颜色。', trigger = "focus"),
                            fluidRow(column(12, jscolorInput("var1", label = NULL, value = "#545A5C"))),
                            h4("Scatter plot color:",
                               bsButton("bs4", label="", icon=icon("question"), style="info", size="small")
                            ),
                            bsPopover("bs4", '对数据进行绘图时，填充散点图的颜色，且用户可根据自己喜好更改颜色。', trigger = "focus"),
                            fluidRow(column(12, jscolorInput("var5", label = NULL, value = "#000000"))),
                          ),
                          
                          checkboxInput("ggMartitle", "Plot title", FALSE), 
                          conditionalPanel(
                            condition = "input.ggMartitle",
                            textInput("ggMar_plotTitle", h4("Plot title:",
                                                            bsButton("bs0", label = "", icon = icon("question"), style = "info", size = "small")
                            ), value = c("plot title")),
                            bsPopover("bs0", "修改图片标题。", trigger = "focus"),
                            
                            textInput("ggMar_xTitle", h4("X axis title:",
                                                         bsButton("bs1", label = "", icon = icon("question"), style = "info", size = "small")
                            ), value = c("X axis")),
                            bsPopover("bs1", "修改x轴标题。", trigger = "focus"),
                            
                            textInput("ggMar_yTitle", h4("Y axis title:",
                                                         bsButton("bs2", label = "", icon = icon("question"), style = "info", size = "small")
                            ), value = c("Y axis")),
                            bsPopover("bs2", "修改y轴标题。", trigger = "focus")
                          ),
                          
                          checkboxInput("ggMarSize", "Other plot parameters", FALSE),
                          
                          conditionalPanel(
                            condition = "input.ggMarSize",
                            sliderInput("var2", h4("Point size:"),
                                        min = 0, max = 10,
                                        value = 4.5, step = 0.01),
                            sliderInput("var6", h4("Point shape:"),
                                        min = 0, max = 20,
                                        value = 20, step = 1),
                            sliderInput("var3", h4("Plot title font size"),
                                        min = 10, max = 50,
                                        value = 25, step = 0.01),
                            sliderInput("var4", h4("Axis label font size"),
                                        min = 10, max = 30,
                                        value = 15, step = 0.01),
                            sliderInput("var9", h4("Axis title font size"),
                                        min = 10, max = 50,
                                        value = 25, step = 0.01),
                            sliderInput("var8", h4("Size ratio of main plot:marginal plots"),
                                        min = 1, max = 5,
                                        value = 2.5, step = 0.01),
                          ),
                          actionButton("submit1", strong("Submit!"), styleclass = "success", width='100%') 
             ),
             
             mainPanel(
               downloadButton("downloadggMar.pdf", "Download PDF File"),
               downloadButton("downloadggMar.svg", "Download SVG File"),
               
               jqui_resizable(plotOutput("ggplot", width = "60%", height = "700px"))
             )
    ),
    
    tabPanel("Help",
             includeMarkdown("README.md"))
  )
)

