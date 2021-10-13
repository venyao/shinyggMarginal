
options(shiny.maxRequestSize = 200*1024^2)

shinyServer(
  function(input, output, session){
    observe({
      if(input$submit1 > 0){
        isolate({
          ggMar.height <<- input$ggMarHeight
          ggMar.width <<- input$ggMarWidth
          
          if(input$seluploaddata == "1"&& !is.null(input$Upload_data)) {
            data_info <- file.info(input$Upload_data$datapath)
            if(data_info$size == 0) {
              sendSweetAlert(
                session = session,
                title = "Error !!",
                text = "The file can't be empty.",
                type = "error"
              )
            } else {
              data <- read.table(input$Upload_data$datapath,  sep = "\t", head = T, as.is = T)
              if(dim(data)[2] != 2) {
                sendSweetAlert(
                  session = session,
                  title = "Data formatting error !", type = "error",
                  text = "Please check the input data format!"
                )
              }
            }
          }
          
          if(input$seluploaddata == "2" && !is.null(input$Paste_data)) {
            if (input$Paste_data == "") {
              sendSweetAlert(
                session = session,
                title = "No input data received!", type = "error",
              )
            } else {
              data <- unlist(strsplit(input$Paste_data,"\n"))
              data <- strsplit(data,"\t")
              if(length(data[[1]]) != 2)  {
                sendSweetAlert(
                  session = session,
                  title = "Data formatting error !", type = "error",
                  text = "Please check the input data format!"
                )
              }
              data <- unlist(data)
              data <- data.frame(t(matrix(data, 2)),stringsAsFactors = F)
              data[,1] <- as.numeric(data[,1])
              data[,2] <- as.numeric(data[,2])
            }
          }
          
          ggmar <- function(){
            p <- ggplot(data, aes(x = data[,1], y=data[,2])) + geom_point(size = input$var2, colour =input$var5, shape=input$var6) + 
              theme(legend.position = "none", axis.text=element_text(size = input$var3)) +
              labs(x = input$ggMar_xTitle, y = input$ggMar_yTitle, title = input$ggMar_Title) +
              theme(axis.title = element_text(size = input$var4))
            
            if (input$plot_type == "histogram" ) {
              p1 <- ggMarginal(p, type = "histogram", fill = input$var1, binwidth = input$var7, margins = input$which_margin)
            }
            
            if (input$plot_type == "density") {
              p1 <- ggMarginal(p, type = "density", color = input$var1, size=4, fill = input$var1, margins = input$which_margin)
            }
            
            if (input$plot_type == "boxplot" ) {
              if (input$outlier == 1) {
                p1 <- ggMarginal(p, type = "boxplot", color = input$var1, margins = input$which_margin)
              }
              if (input$outlier == 2) {
                p1 <- ggMarginal(p, type = "boxplot", color = input$var1, outlier.colour = NA, margins = input$which_margin)
              }
            }
            
            if (input$plot_type == "violin" ) {
              p1 <- ggMarginal(p, type = "violin", color = input$var1, margins = input$which_margin)
            }
            
            if (input$plot_type == "densigram") {
              p1 <- ggMarginal(p, type = "densigram", color = input$var1, margins = input$which_margin)
            }
            
            return(p1)
          }
          
          output$ggplot <- renderPlot({  
            ggmar()
          })
        })
      } else{
        NULL
      }
      ## *** Download example data ***
      output$Example_data.txt <- downloadHandler(
        filename <- function() {
          paste('Example_data.txt')
        },
        content <- function(file) {
          input_file <- "www/Example_data.txt"
          example_dat <- read.table(input_file, head = T, as.is = T, sep = "\t", quote = "")
          write.table(example_dat, file = file, row.names = F, quote = F, sep = "\t")
        }, contentType = 'text/csv') 
      
      ## paste example input 
      observe({
        if (input$Paste_example >0) {
          isolate({
            exam <- readLines("www/Example_data.txt")
            updateTextAreaInput(session, "Paste_data", value = paste0(exam,collapse = "\n"))
          })
        } else {NULL}
      })
      ## Download PDF file of ggMar
      output$downloadggMar.pdf <- downloadHandler(
        filename <- function() { paste('ggMar.pdf') },
        content <- function(file) {
          pdf(file)
          p2 <- ggmar()
          grid.draw(p2)
          dev.off()
        }, contentType = 'application/pdf')
      
      ## Download SVG file of ggMar
      output$downloadggMar.svg <- downloadHandler(
        filename <- function() { paste('ggMar.svg') },
        content <- function(file) {
          svg(file)
          p2 <- ggmar()
          grid.draw(p2)
          dev.off()
        }, contentType = 'image/svg')
      
    })
  })

