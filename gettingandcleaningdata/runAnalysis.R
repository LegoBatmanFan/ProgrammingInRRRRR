runAnalysis <- function(){
  source("runAnalysisFunctionCalls.R")
  downloadDataFromInternet()
  dataTable001 <- mergeTrainingAndTestData()
  dataTable002 <- modifyDataset(dataTable001)
  createDataFile(dataTable002)
}