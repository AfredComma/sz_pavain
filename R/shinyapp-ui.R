

#' Function building dashboard UI, used in Shiny app
#'
#' @param request request object
#'
#' @return Dashboard page
#' @export
dashboardUI <- function(request) {
  dashboardPage(skin="black", title = "Pavian",
                dashboardHeader(title = "检测结果展示"
                ),
                dashboardSidebar(
                  div(class="hide_when_sidebar_collapsed",
                  shinyjs::hidden(shinyjs::disabled(actionButton("btn_remove_cache_files", "Remove cached files ???"))),
                  shinyjs::hidden(sidebarSearchForm(textId = "txt_sidebarSearch", buttonId = "btn_sidebarSearch", label = "Search ...")),
                  br()),
                  conditionalPanel(
                    condition = "input.sample_set_names != ''",
                    sidebarMenu(
                      id = "tabs",
                      menuItem("数据输入", tabName="Home", icon = icon("cloud-upload"), selected = TRUE),
                      div(class="set_selector hide_when_sidebar_collapsed no_padding", 
                          shinyjs::hidden(selectInput("sample_set_names", choices=NULL, label=NULL, multiple=TRUE, 
                                                      selectize = FALSE, size = 5))),
                      # The following menus are just displayed when a sample set has been loaded
                      shinydashboard::menuItem("结果总结", tabName="Overview", icon = icon("table")),
                      shinydashboard::menuItem("样品", tabName="Sample", icon = icon("sun-o")),
                      shinydashboard::menuItem("样品比较", icon = icon("line-chart"), tabName = "Comparison"),
                                               #shinydashboard::menuSubItem("All data", tabName="Comparison"),
                                               #actionLink("show_bacteria","Bacteria and Archaea", tabName="Bacteria")
                                               #shinydashboard::menuSubItem("Viruses", tabName="Viruses"),
                                               #shinydashboard::menuSubItem("Eukaryotes", tabName="Eukaryotes"),
                                               #shinydashboard::menuSubItem("Eukaryotes/Fungi", tabName="Fungi"),
                                               #shinydashboard::menuSubItem("Eukaryotes/Protists", tabName="Protists")
                      menuItem("比对观测", tabName = "Alignment", icon = icon("asterisk")),
                      menuItem("关于", tabName = "About")
                    ),
                    div(class="hide_when_sidebar_collapsed", #style = "color:lightblue",
                        br(),
                        uiOutput("bookmarkBtnUI")
                    )
                  ),
                  conditionalPanel(
                    condition = "input.sample_set_names == ''",
                    sidebarMenu(
                      id = "tabs",
                      menuItem("数据输入", tabName="Home", icon = icon("cloud-upload"), selected = TRUE),
                      # The following menus are just displayed when a sample set has been loaded
                      menuItem("比对观测", tabName = "Alignment", icon = icon("asterisk")),
                      menuItem("关于", tabName = "About")
                    ),
                    div(class="hide_when_sidebar_collapsed",
                    br(),
                    tags$p(class="sidebartext", style="padding-left: 10px;color: #b8c7ce; ", "To start exploring metagenomics data, upload a dataset in the 'Data Input' tab."),
                    tags$p(class="sidebartext", style="padding-left: 10px;color: #b8c7ce; ", "Or view alignments and download genomes in the 'Alignment viewer'.")
                    )
                  ),
                  
                  # Show a busy indicator
                  conditionalPanel(
                    condition="($('html').hasClass('shiny-busy'))",
                    div(class = "busy hide_when_sidebar_collapsed", style="padding-left: 10px; color: #b8c7ce; ", 
                        br(),
                        p(img(src="loading.gif"), "Calculation in progress..")
                    )),
                  div(class="hide_when_sidebar_collapsed", 
                  br(),
                  tags$p(class="sidebartext", style="padding-left: 10px;color: #b8c7ce; ",format(Sys.Date(), "Update, %Y"))
                  )
                ),
                dashboardBody(
                  shinyjs::useShinyjs(),
                  tags$head(includeCSS("style.css")),
                  tags$script(HTML("$('body').addClass('sidebar-mini');")),
                  tabItems(
                    tabItem("Home",
                            dataInputModuleUI("datafile")
                    ),
                    tabItem("Overview",
                            reportOverviewModuleUI("overview"),
                            uiOutput("view_in_sample_viewer") ### <<<<<< TODO
                    ),
                    #tabItem("Alldata"),
                    tabItem("Comparison", comparisonModuleUI("comparison")),
                    #tabItem("Bacteria", comparisonModuleUI("bacteria")),
                    #tabItem("Viruses", comparisonModuleUI("viruses")),
                    #tabItem("Eukaryotes", comparisonModuleUI("eukaryotes")),
                    #tabItem("Fungi", comparisonModuleUI("fungi")),
                    #tabItem("Protists", comparisonModuleUI("protists")),
                    tabItem("Sample", sampleModuleUI("sample")),
                    tabItem("Alignment", alignmentModuleUI("alignment")),
                    tabItem(
                      "About",

                      br(),
                      br(),
                      box(width=12,
                          title="Session Information",
                          collapsible=TRUE,
                          collapsed=FALSE,
                          verbatimTextOutput("session_info"),
                          verbatimTextOutput("session_info1")
                      )
                    )
                  )
                )
  )
}

navbarpageUI <- function(request) {
  navbarPage("Pavian", id="nav",
             tabPanel("Data Input",
                      dataInputModuleUI("datafile")
             ),
             tabPanel("Results Overview",
                      #reportOverviewModuleUI("overview"),
                      uiOutput("view_in_sample_viewer")
             ),
             tabPanel("Classifications across samples"#,
                      #comparisonModuleUI("alldata")
             )
  )
}
