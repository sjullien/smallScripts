library(rvest)
library(lubridate)
library(xlsx)
countryList <- c("Austria","Croatia","Luxembourg","France","Germany","Czech%20Republic", "Greece", "Hungary", "Italy", "Poland",
                 "Republic%20of%20Slovakia","Liechtenstein","Romania","Switzerland","Turkey")

hourIntervals <- function(hours, da){
  if (length(hours>0)){
    start <- sub("-.*", "", hours)
    end <- sub(".*-", "", hours)
    startHr <- sub(":.*", "", start)
    endHr <- sub(":.*", "", end)
    startMin <- sub(".*:", "", start)
    endMin <- sub(".*:", "", end)
    startDate <- da + hours(startHr) + minutes(startMin)
    endDate <- da + hours(endHr) + minutes(endMin)
  }
  else{
    startDate <- NULL
    endDate <- NULL
  }
  return(list("startDate" = startDate,"endDate" = endDate))
}
getMultipleDrivingBans <- function(page){
  bans <- html_nodes(page, '.panel-body')  %>% 
    html_nodes('.form-group')
  roads <- rep('sj', length(bans)) 
  for (i in 1:length(roads)){
    details <-  html_nodes(bans[i], 'li') %>%
      html_text()
    if (identical(character(0),details)){
      roads[i] <- (html_nodes(bans[i], 'p')  %>% 
                     html_text())[2]
    }
    else{roads[i] <- details %>%
      paste(collapse = ", ")
    }}
  roads 
}

getSingleDrivingBan <- function(page){
  roads <- html_nodes(page, '.form-group')  %>% 
    html_nodes('li') %>%
    html_text() %>%
    paste(collapse = ", ")
  if (roads==""){
    roads <- (html_nodes(page, '.form-group')  %>% 
                html_nodes('p') %>%
                html_text())[2]
  }
  roads
}
getDrivingBan <- function(date, country){
  day <-as.Date(date)
  dat <- format(day, "%d.%m.%Y")
  url <-paste0("https://www.truckban.info/en/",country,"/",dat)
  page <- read_html(url)
  hours <- html_nodes(page, '.text-danger')  %>% 
    html_text()
  dateTime <- hourIntervals(hours, day)
  if (length(hours)>1){
    roads <- as.character(getMultipleDrivingBans(page))
  }
  else if (identical(character(0),hours)){
    roads<-NULL
  }
  else{
    roads <- as.character(getSingleDrivingBan(page))
  }
  data.frame( "startDate" = dateTime$startDate, "endDate" = dateTime$endDate, "roads" = roads)
  
}
dateArray <- seq.Date(from=Sys.Date(),by = "day",length.out = 93)
res <- vector(length(countryList),mode = "list")
for (i in 1:length(countryList)){
  res[[i]]<-do.call(rbind,lapply(dateArray,FUN = getDrivingBan,country=countryList[i]))
}

countryListExcel <- c("Austria","Croatia","Luxembourg","France","Germany","Czech Republic", "Greece", "Hungary", "Italy", "Poland",
                      "Republic of Slovakia","Liechtenstein","Romania","Switzerland","Turkey")
wb <- createWorkbook()
cs1 <- CellStyle(wb) + Font(wb, isBold=TRUE) + Border()



for(i in 1:length(countryList)){
  sheet  <- createSheet(wb, sheetName=countryList[i])
  addDataFrame(as.data.frame(res[[i]]), sheet, startRow=1, startColumn=1, colnamesStyle=cs1, row.names = F)
}
saveWorkbook(wb, "//ant/dept-eu/MUC/DE_SCO/EU_INO/Interns/Sami/drivingBans.xlsx") 
