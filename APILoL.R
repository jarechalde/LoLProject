#Lol API

#Some Libraries that we are going to need
library(jsonlite)

key = 'RGAPI-f165ab9a-cab1-4a32-859b-3df7c20e370d'
urlol = 'https://na1.api.riotgames.com/lol/summoner/v3/summoners/by-name/jarechalde?api_key='

#RGAPI-f165ab9a-cab1-4a32-859b-3df7c20e370d

urlol = paste(urlol,key,sep = '')

#GEtting all the champions information
championsurl = 'https://na1.api.riotgames.com/lol/static-data/v3/champions?locale=en_US&dataById=false&api_key=RGAPI-f165ab9a-cab1-4a32-859b-3df7c20e370d'
championsurl = 'https://na1.api.riotgames.com/lol/static-data/v3/champions?locale=en_US&dataById=true&api_key=RGAPI-f165ab9a-cab1-4a32-859b-3df7c20e370d'
#championsurl = 'https://na1.api.riotgames.com/lol/static-data/v3/champions/{id}?locale=en_US&api_key=RGAPI-f165ab9a-cab1-4a32-859b-3df7c20e370d'
championsdata = readLines(championsurl)
championsdata = fromJSON(championsdata)

champids = c()
champnames = c()

for (i in 1:length(championsdata$data)){
  
  champion = championsdata$data[i]
  champid = champion[[1]][[1]]
  champname = champion[[1]][[2]]

  champids = c(champids,champid)
  champnames = c(champnames,champname)
    
}

champdataframe = data.frame(champids,champnames)#,col.names = c('Champion_Name','Champion_ID'))

#We call the API, and convert the results
apidata = readLines(urlol)
apidata = fromJSON(apidata)

matchurl = 'https://na1.api.riotgames.com/lol/match/v3/matchlists/by-account/'
matchurl = paste(matchurl,apidata$accountId,'?api_key=',key,sep = '')

#We call the API, and convert the results
matchdata = readLines(matchurl)
matchdata = fromJSON(matchdata)

gameids = matchdata$matches$gameId
gameids = gameids[1:1]

durations = c()
resultarray = c()
champplayed =c()

for (i in 1:length(gameids)){
  print(gameids[i])
  
  gameurl = 'https://na1.api.riotgames.com/lol/match/v3/matches/'
  key = '?api_key=RGAPI-f165ab9a-cab1-4a32-859b-3df7c20e370d'
  gameurl = paste(gameurl,as.character(gameids[i]), key, sep = '')
  
  gamedata = readLines(gameurl)
  gamedata = fromJSON(gamedata)
  
  #Extracting data
  participants = gamedata$participants
  team = gamedata$teams
  
  #Getting if we won or lost
  teamIDPlayer = participants$teamId[participants$participantId == 1]
  winloss = team$win[team$teamId == teamIDPlayer]
  
  duration = gamedata$gameDuration/60
  
  #Storing data in arrays
  durations = c(durations,duration)
  resultarray = c(resultarray,winloss)
  champplayed = c(champplayed, champdataframe[champdataframe$champids == champID])
  
  Sys.sleep(1)
}