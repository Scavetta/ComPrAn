###################
# body.R
#
###################
body <- dashboardBody(
    tags$head(tags$style(HTML('
      .main-header .logo {
        font-weight: bold;
        font-size: 24px;
      }
    '))),
  tabItems(
   
    ########################
    # intro tab content ####
    ########################
    tabItem(
      tabName = "intro",
      h2("Introduction"),
      p(
        strong("Complexome profiling") ,
        "or",
        strong("complexomics"),
        "is a method used in biology to study migration profiles of proteins and protein complexes. First, ",
        strong("sample is separated into fractions"),
        ", typically by blue native electrophoresis or gradient centrifugation and individual",
        strong("fractions are analysed by mass spectrometry."),
        "
        This allows to identify proteins that co-migrate. Often people want to compare migration
        profiles and quantities of proteins between two biological samples. SILAC version of
        complexomics provides a useful tool for such studies."
      ),
      p(
        "Here we present an app to analyse data produced by ",
        strong("SILAC complexomics experiments"),
        ". This app does not interpret raw mass spectrometry data. As an input it
        takes a table of peptides there were identified by search engines such as Mascot, and
        quantified, e.g. in Proteome Discoverer."
      ),

      h3("Import",
         style = "padding-left: 1em"),
      p(" In this section you can import your data file. The source data is either a",
        strong("file containing peptide records"),",with each row representing values for one peptide.",
        strong("Or"), "a",
        strong("file with normalised protein values"), "with each row representing values for one protein.",
        style = "padding-left: 2em"),

      h3("Part 1: Peptide-to-protein",
         style = "padding-left: 1em"),
      p(strong("The aim of part 1 is to estimate protein intensity based on peptide intensities."),
        "During this part peptide data are filtered, a representative peptide is picked for each protein and
        amounts of detected proteins are nomrlaized.",
        style = "padding-left: 2em"),

      h3("Part 2: Protein Workflow",
         style = "padding-left: 1em"),
      p(strong("The aim of part 2 is to visualize and cluster protein results."),
        "Different types of plots can be produced, including line graph of selected protein, heatmap of
        a group of proteins and protein co-migration plots",
        style = "padding-left: 2em")
      ),

    ########################
    # import tab content ####
    ########################
    tabItem(tabName="import",
            h2("Import data"),
            p("Enter a file to use, if this is blank, we'll just use an example file"),

            fluidRow(useShinyjs(),

              tabBox(id = "tabsetImport", height = "250px",
                     tabPanel("Raw Data",
                              p("Use this to import a peptide file."),
                              fileInput("inputfile", "Select a file for analysis", accept = c('text/tab-separated-values',
                                                                                              '.txt',
                                                                                              '.csv',
                                                                                              '.tsv')),
                              actionButton("processRaw", "Process data")),
                     tabPanel("Normalized values",
                              p("Use this to import a file containing normalized values that you've previously generated using this app."),
                              fileInput("inputfileNorm", "Select a Normalized peptide file for analysis", accept = c('text/tab-separated-values',
                                                                                                                     '.txt',
                                                                                                                     '.csv',
                                                                                                                     '.tsv')),
                              actionButton("processNorm", "Process data")

                     )
              ),

              h3(textOutput("useCase"))


            ),
            fluidRow(
            ),
            # fluidRow(
            #   verbatimTextOutput("NormInputTest_0")
            # ),

            fluidRow(

              box(width = 6, solidHeader = TRUE,

                  textInput("labelledName", label = "Labeled sample:", value = "Control")
              ),
              box(width = 6, solidHeader = TRUE,
                  textInput("unlabelledName", label = "Unlabeled sample", value = "KO")
              )
            )
    ),
    ########################
    # summary tab content ####
    ########################
    tabItem(tabName="summary",
            conditionalPanel(
                condition = "output.useCase != 'Using raw data file. Proceed to part 1.'",
                h3(strong("Note: You need to import peptide data to use this section.")),
                h4("Go to Import -> Raw data box -> select peptide data file")
                
            ),
            
            conditionalPanel(
                condition = "output.useCase == 'Using raw data file. Proceed to part 1.'",
            h2("Summary"),
            p("Here is a summary of the peptide values in your raw data:"),

            fluidRow(
              # textOutput("selected_var"),
              plotOutput("totalSplit", width = "100%", height = "150px")
            ),

            fluidRow(
              # textOutput("selected_var"),
              textOutput("test_input")
            ),

            fluidRow(
              # textOutput("selected_var"),
              plotOutput("labUnlabSplit", width = "100%", height = "150px")
            ))

    ),

    ########################
    # filter tab content ####
    ########################
    tabItem(tabName="filter",
            conditionalPanel(
                condition = "output.useCase != 'Using raw data file. Proceed to part 1.'",
                h3(strong("Note: You need to import peptide data to use this section.")),
                h4("Go to Import -> Raw data box -> select peptide data file")
                
            ),
            conditionalPanel(
                condition = "output.useCase == 'Using raw data file. Proceed to part 1.'",
            fluidRow(
                column(6,
                       h2("Filter data"),
                       p("Choose your filtering criteria in this section.",
                         
                         # numericInput("frac","Number of fractions:", value = max_frac()),
                         uiOutput("UI_rank"),
                         #sliderInput("rank", label = "Keep peptides ranked below or equal to:",
                         #            min = 1, max = max(peptides$Rank), value = 1, step = 1),
                         
                         checkboxGroupInput("checkGroup", label = "Include peptides with confidence level:",
                                            choices = list("High" = "High", "Middle" = "Middle", "Low" = "Low"),
                                            selected = c("High", "Middle","Low")),
                         
                         checkboxInput("simplify", label = "Simplify data set", value = TRUE),
                         
                         actionButton("filter", "Filter the data"),
                         "(Larger number of processing steps happens after pressing 'Filter the data' button, this might take a while.) "
                         
                       )
                ),
                column(6,
                       h2("Select representative peptides"),
                       p("Once you filter the data a button will appear here to allow you to select representative peptides."),
                       conditionalPanel(
                           condition = "output.filterTabPostVenn == 'show'",
                         uiOutput("pepsFilteredButton"),
                       textOutput("openRepPep"))

                )
            ),
            
            

            fluidRow(
              box(title = "Pre-filtering", width = 6, solidHeader = TRUE,
                  textOutput("preFilterVennText"),
                  plotOutput("preFilterVenn", width = "100%", height = "450px")
              ),
              
              box(title = "Post-filtering", width = 6, solidHeader = TRUE,
                  conditionalPanel(
                      condition = "output.filterTabPostVenn == 'show'",
                  textOutput("postFilterVennText"),
                  plotOutput("postFilterVenn", width = "100%", height = "450px")
              )
            )))
    ),

    ########################
    # bylabelstate tab content ####
    ########################
    tabItem(tabName="bylabelstate",
            conditionalPanel(
                condition = "output.openRepPep != 'Representative peptides selected, proceed to next section!'",
    
                h3(strong("Note: You need to select representative peptides to use this section.")),
                h4(strong("Go to Filter and Select tab")),
                h5("If there is a note shown, follow the instructions on Filter and Select tab."),
                h4("If you see the content of Filter and Select tab:"),
                h4("Select filtering options you want -> press ",em("`Filter`") ," button -> 
                   press ",em("`Select peptides`"), " button -> you can use Rep peptides tab now",
                   style = "padding-left: 1em")
                # ,p(),
                # p(),
                # p("On this tab you will be able to:"),
                # p("- display plot with all peptides for a selected protein", br(),
                #    "- download list of proteins present in both or only in one of the two samples",
                #   style = "padding-left: 1em")
            ),
            
            conditionalPanel(
                condition = "output.openRepPep == 'Representative peptides selected, proceed to next section!'",
            h2("Analysis Summary"),
            p("Here you can search for presence/absence of a protein in your data set.
              The plot displayes all peptides that belong to the selected protein.
              There are multiple options with which you can modify the plot visualization,
              including the option to highliht peptide that was selected as \"representative peptide\"
              by the analysis.",
              style="padding-left: 0em"),
            fluidRow(
                column(width = 6,
                       h4(strong("Selec protein:")),
              tabBox(id = "tabset1", height = "400px",width = 12,
                     tabPanel("All Proteins",
                              DT::dataTableOutput('dt'),
                              #style = "height:300px; overflow-y: scroll; overflow-x: scroll;"
                              style = "height:350px"
                              
                              #uiOutput("dt")
                     ),
                     tabPanel("By label state",
                              #column(width = 6,
                              #       actionButton("chooseUnlabeled", "Only Unlabeled"),
                              #       actionButton("chooseBoth", "Both"),
                              #       actionButton("chooseLabeled", "Only Labeled")),
                              column(width = 12,
                                     actionButton("chooseUnlabeled", "Only Unlabeled"),
                                     actionButton("chooseBoth", "Both"),
                                     actionButton("chooseLabeled", "Only Labeled"),
                                     DT::dataTableOutput('allPeptides_choose'),
                                     #style = "height:300px; overflow-y: scroll; overflow-x: scroll;"
                                     style = "height:350px"

                              )
                     )
              )
                ),
              column(width = 6, 
                     h4(strong("Available downloads:"))),
              uiOutput("dl_both"),
              uiOutput("dl_onlyLab"),
                       uiOutput("dl_onlyUnlab")
              ),

            fluidRow(
              column(width = 6,
                     h4(strong("Controls for plot settings:")),
                     checkboxInput("allPeptidesPlot_mean", label = "Show mean line", value = FALSE),
                     checkboxInput("allPeptidesPlot_reppep", label = "Show representative peptide line", value = FALSE),
                     checkboxInput("allPeptidesPlot_sepstates", label = "Separate label states", value = FALSE),
                     checkboxInput("allPeptidesPlot_removegrid", label = "Show gridlines", value = FALSE),
                     radioButtons("allPeptidesPlot_title", label = "Title:",
                                  choices = list("All" = "all", "Only gene name" = "GN"),
                                  selected = "all"),
                     radioButtons("allPeptidesPlot_align", label = "Title alignment:",
                                  choices = list("Left" = "left", "Center" = "center", "Right" = "right"),
                                  selected = "left"),
                     textInput("allPeptidesPlot_xaxis", label = "X axis label:", value = "Fraction"),
                     textInput("allPeptidesPlot_yaxis", label = "Y axis label:", value = "Precursor Area")
              ),
              column(width = 6, 
                     h4(strong("Plot showing all peptides that were detected for a protein:")),
                     plotOutput("allPeptidesPlot", height = 500)
                     )
            ))

    ),

    ########################
    # normalize tab content ####
    ########################
    tabItem(tabName="normalize",
            
            conditionalPanel(
                condition = "output.openRepPep != 'Representative peptides selected, proceed to next section!'",
                h3(strong("Note: You need to select representative peptides to use this section.")),
                h4(strong("Go to Filter and Select tab")),
                h5("If there is a note shown, follow the instructions on Filter and Select tab."),
                h4("If you see the content of Filter and Select tab:"),
                h4("Select filtering options you want -> press ",em("`Filter`") ," button -> 
                   press ",em("`Select peptides`"), " button -> you can use Normalize tab now",
                   style = "padding-left: 1em")
                # ,p(),
                # p(),
                # p("On this tab you will be able to:"),
                # p("- produce a table with normalised protein values neccessary for Part 2", br(),
                #    "- download normalised protein table in tab separated format",
                #   style = "padding-left: 1em")
            ),
            
            conditionalPanel(
                condition = "output.openRepPep == 'Representative peptides selected, proceed to next section!'",
            h2("Normalize protein values"),
            p("For easier comparison of protein co-migrations and quantities we
              normalize all values to be between 0 and 1."),

            fluidRow(
              column(width = 6,
                     actionButton("normData", "Normalize the data"),
                     conditionalPanel(
                         condition = "output.normProtDownload == 'show'",
                         h4(strong("Part 1 analysis finished, you may proceed to Part 2.")))
              ),
              conditionalPanel(
                  condition = "output.normProtDownload == 'show'",
              column(width = 6,
                     #verbatimTextOutput("NormTest"),
                     h4("Normalized protein data are available for download:"),
                     uiOutput("dl_Norm")
                    
              ))
            ))
    ),

    ########################
    # proteinNormViz tab content ####
    ########################
    tabItem(tabName="proteinNormViz",
            conditionalPanel(
                condition = "output.openPart2 != 'Part2 ready!'",
                h3(strong("Note: You need to do one of the following to access this section")),
                h4(strong("- Import protein data"),
                    style = "padding-left: 1em"),
                h4("Go to Import -> Normalized values box -> select protein data file",
                   style = "padding-left: 2em"),
                h4(strong("- Use Part 1 to produce protein data from peptide data"),
                   style = "padding-left: 1em"),
                h4("Follow instructions on tabs in Part 1", 
                   style = "padding-left: 2em")
            ),
            
            conditionalPanel(
                condition = "output.openPart2 == 'Part2 ready!'",
            h2("Protein Normalized Profile"),
            p("This plot ",
              strong("compares quantity"),
              " of the selected protein between labeled and unlabeled samples"),
            fluidRow(
              column(width = 6,
                     verbatimTextOutput("NormInputTest"),
                     uiOutput("dt_2"),
                     checkboxInput("allProteinPlot_removegrid", label = "Show gridlines", value = FALSE),
                     radioButtons("allProteinPlot_title", label = "Title:",
                                  choices = list("All" = "all", "Only gene name" = "GN"),
                                  selected = "all"),
                     radioButtons("allProteinPlot_align", label = "Title alignment:",
                                  choices = list("Left" = "left", "Center" = "center", "Right" = "right"),
                                  selected = "left"),
                     textInput("allProteinPlot_legend", label = "Legend label:", value = "Condition"),
                     textInput("allProteinPlot_xaxis", label = "X axis label:", value = "Fraction"),
                     textInput("allProteinPlot_yaxis", label = "Y axis label:", value = "Precursor Area")
              ),
              column(width = 6,
                     plotOutput("proteinPlot", height = 500),
                     uiOutput("dl_Norm_Plot")
                     #,verbatimTextOutput("normDataPresent")
              ),

            fluidRow(
              column(width = 12,
            textAreaInput("normPlotsMultipleInput",
                          label = "Input for multiple plots ..."),
            downloadLink('allgraphsNorm')

              )

            )
            ))
    ),

    ########################
    # heatMaps tab content ####
    ########################
    tabItem(tabName="heatMaps",
            conditionalPanel(
                condition = "output.openPart2 != 'Part2 ready!'",
                h3(strong("Note: You need to do one of the following to access this section")),
                h4(strong("- Import protein data"),
                   style = "padding-left: 1em"),
                h4("Go to Import -> Normalized values box -> select protein data file",
                   style = "padding-left: 2em"),
                h4(strong("- Use Part 1 to produce protein data from peptide data"),
                   style = "padding-left: 1em"),
                h4("Follow instructions on tabs in Part 1", 
                   style = "padding-left: 2em")
            ),
            conditionalPanel(
                condition = "output.openPart2 == 'Part2 ready!'",
            h2("Heatmaps of Normalized Profiles"),
            p("Quantitative comparison of a group of proteins
              between labeled and unlabeled samples"),
            fluidRow(
              column(width = 4,
                     fileInput("heatMapFile", "Select a file for analysis", accept = c('text/tab-separated-values',
                                                                                       '.csv',
                                                                                       '.tsv',
                                                                                       '.txt')) ,
                     actionButton("exampleGroup", "Use example group"),

                     textInput("heatMapGroupName", label = "Group Name:", value = "Group 1"),

                     #verbatimTextOutput("testDF"),
                     checkboxInput("renameProteinsHeatMap", label = "Rename proteins", value = FALSE),
                     #uiOutput("dt_3"),
                     uiOutput("HeatmapGroupColList"),
                     #h4(strong(textOutput("colNotFound"))),
                     checkboxInput("reorderProteinsHeatMap", label = "Reorder proteins", value = FALSE),
                     uiOutput("HeatmapGroupColList_2"),
                     h4(strong(textOutput("noDoubleColumn"))),
                     verbatimTextOutput("testColType"),

                     radioButtons("showSamplesHeatMap", label = "Show Samples",
                                  choices = list("Side-by-side" = 2, "One above another" = 1),
                                  selected = 1),
                     radioButtons("legendPosition", label = "Legend position",
                                  choices = list("Right" = "right", "Bottom" = "bottom"),
                                  selected = "right"),
                     verbatimTextOutput("testPlay"),
                     uiOutput("dl_Heat_Plot"),
                     uiOutput("heatmapHeightSlider"),
                     uiOutput("heatmapWidthSlider")
                     ),

              column(width = 8,
                     plotOutput("heatMapPlot")
                     #plotOutput("heatMapPlot_example", height = 500),
 
              )


            ))
    ),

    ########################
    # co-migration tab content ####
    ########################
    tabItem(tabName="coMigration",
            conditionalPanel(
                condition = "output.openPart2 != 'Part2 ready!'",
                h3(strong("Note: You need to do one of the following to access this section")),
                h4(strong("- Import protein data"),
                   style = "padding-left: 1em"),
                h4("Go to Import -> Normalized values box -> select protein data file",
                   style = "padding-left: 2em"),
                h4(strong("- Use Part 1 to produce protein data from peptide data"),
                   style = "padding-left: 1em"),
                h4("Follow instructions on tabs in Part 1", 
                   style = "padding-left: 2em")
            ),
            conditionalPanel(
                condition = "output.openPart2 == 'Part2 ready!'",
            h2("Co-migration plots"),
            p("Here you can compare migation of a single group of proteins between the label states,
              or look whether two groups of proteins co-migrate in both label states."),
            p("This plot is ",
              strong("not quantitative"), "and should not be used to compare the amounts of proteins
              between label states!"),

            fluidRow(
              tabBox(id = "tabsetComigration", height = "100%", width = "100%",
                     tabPanel("Co-migration 1",
                              p("Here we show whether the migration pattern of proteins specified in \"Protein IDs\"
                                box changes between label states"),
                              fluidRow(column(width = 3,
                                              textInput("groupName_coMig1",
                                                        label = "Group Name",
                                                        value = "Group 1"),
                                              textAreaInput("groupData_coMig1",
                                                            label = "Protein IDs (one per line)"),
                                              p("Predefined protein groups:"),
                                              actionButton("mtLSU", "mitoribosome - large subunit"),
                                              p(""),
                                              actionButton("mtSSU", "mitoribosome - small subunit")
                              ),
                              column(width = 3,
                                     checkboxInput("grid_coMig1", label = "Show grid", value = FALSE),
                                     checkboxInput("meanLine_coMig1", label = "Show mean line", value = FALSE),
                                     checkboxInput("medianLine_coMig1", label = "Show median line", value = FALSE),
                                     sliderInput("jitterPoints_coMig1", label = "Jittering",
                                                 min = 0, max = 1, value = 0.3, step = 0.05),
                                     sliderInput("pointSize_coMig1", label = "Point size",
                                                 min = 1, max = 10, value = 2.5, step = 0.5),
                                     sliderInput("alphaValue_coMig1", label = "Opacity",
                                                 min = 0.1, max = 1, value = 0.5, step = 0.05),
                                     radioButtons("titleAlign_coMig1", label = "Title alignment",
                                                  choices = list("Left" = "left", "Center" = "center", "Right" = "right"),
                                                  selected = "left"),
                                     textInput("legendLabel_coMig1", label = "Legend label" , value = "Condition"),
                                     textInput("ylabel_coMig1", label = "Y-axis label", value = "Relative Protein Abundance"),
                                     textInput("xlabel_coMig1", label = "X-axis label", value = "Fraction")
                              ),
                              # labelled_coMig1 = 'Labeled',
                              # unlabelled_coMig1 = 'Unlabeled',
                              column(width = 6,
                                     plotOutput("coMig_1"),
                                     uiOutput("dl_Comig1_Plot")
                              ))
                     ),
                     tabPanel("Co-migration 2",
                              p("Here we show whether the proteins specified in \"Group 1 protein IDs\" and
                                \"Group 2 protein IDs\" boxes co-migrate in labeled/unlabeled samples"),
                              fluidRow(column(width = 3,
                                              textInput("groupName_coMig2_g1",
                                                        label = "Group Name",
                                                        value = "Group 1"),
                                              textAreaInput("groupData_coMig2_g1",
                                                            label = "Group 1 protein IDs (one per line)"),
                                              textInput("groupName_coMig2_g2",
                                                        label = "Group Name",
                                                        value = "Group 2"),
                                              textAreaInput("groupData_coMig2_g2",
                                                            label = "Group 2 protein IDs (one per line)")
                              ),
                              column(width = 3,
                                     checkboxInput("grid_coMig2", label = "Show grid", value = FALSE),
                                     checkboxInput("meanLine_coMig2", label = "Show mean line", value = FALSE),
                                     checkboxInput("medianLine_coMig2", label = "Show median line", value = FALSE),
                                     sliderInput("jitterPoints_coMig2", label = "Jittering",
                                                 min = 0, max = 1, value = 0.3, step = 0.05),
                                     sliderInput("pointSize_coMig2", label = "Point size",
                                                 min = 1, max = 10, value = 2.5, step = 0.5),
                                     sliderInput("alphaValue_coMig2", label = "Opacity",
                                                 min = 0.1, max = 1, value = 0.5, step = 0.05),
                                     radioButtons("titleAlign_coMig2", label = "Title alignment",
                                                  choices = list("Left" = "left", "Center" = "center", "Right" = "right"),
                                                  selected = "left"),
                                     textInput("legendLabel_coMig2", label = "Legend label" , value = "Condition"),
                                     textInput("ylabel_coMig2", label = "Y-axis label", value = "Relative Protein Abundance"),
                                     textInput("xlabel_coMig2", label = "X-axis label", value = "Fraction")
                              ),

                              column(width = 6,
                                     plotOutput("coMig_2"),
                                     uiOutput("dl_Comig2_Plot")
                              ))

                     )
              )
            ))
    ),



    ########################
    # cluster tab content ####
    ########################
    tabItem(tabName="cluster",
            conditionalPanel(
                condition = "output.openPart2 != 'Part2 ready!'",
                h3(strong("Note: You need to do one of the following to access this section")),
                h4(strong("- Import protein data"),
                   style = "padding-left: 1em"),
                h4("Go to Import -> Normalized values box -> select protein data file",
                   style = "padding-left: 2em"),
                h4(strong("- Use Part 1 to produce protein data from peptide data"),
                   style = "padding-left: 1em"),
                h4("Follow instructions on tabs in Part 1", 
                   style = "padding-left: 2em")
            ),
            conditionalPanel(
        condition = "output.openPart2 == 'Part2 ready!'",

            h2("Clustering"),
            p("Here you can perform a hierarchical clustering of your protein data.
              Clustering is performed separately on labelled and unlabelled sample."),
            fluidRow(
              column(width = 6,
                     radioButtons("distCentered", label = "Pearson correlation variant:",
                                  choices = list("centered" = "centered",
                                                 "uncentered" = "uncentered"
                                                 )),

                     radioButtons("distMethod", "Linkage method:",
                                  choices = list("complete" = "complete",
                                                 "average" = "average",
                                                 "single" = "single")),
                     uiOutput("UI_distCutoff"),
                     uiOutput("dl_clustertable")

                    ),
              column(width = 6,
                     plotOutput("labeledBar_plot", height = 500),
                     uiOutput("dl_labeledBar_Plot"),
                     plotOutput("unlabeledBar_plot", height = 500),
                     uiOutput("dl_unlabeledBar_Plot")
                     )
    ))
    ),




    ########################
    # QuestionsAndAnswers tab content ####
    ########################
    tabItem(tabName="QuestionsAndAnswers",
            h2("FAQ"),
            p("Information about this app and FAQ will be updated regularly.",
              style="padding-left: 0em"),
            # fluidPage(
            fluidRow(
              column(title = "Output",

                     width = 3,
                     plotOutput('distPlot_1', height = 200),
                     plotOutput('distPlot_2', height = 200)
              ),
              column(width = 8, plotOutput('distPlot_3', height = 400))
            )
    ),

    ########################
    # feedback tab content ####
    ########################
    tabItem(tabName="feedback",
            h2("Feedback"),
            p("This app is developed and maintained by Rick Scavetta (office@scavetta.academy) 
            and Petra Palenikova (pp451@cam.ac.uk)
              as part of the R Complexome Profiling Analysis package.")
    )
  )
)
