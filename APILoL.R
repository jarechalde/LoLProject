#Lol API

#Some Libraries that we are going to need
library(jsonlite)

key = 'RGAPI-ad126964-86f9-4815-97c8-dfc67d7f9ff2'
urlol = 'https://na1.api.riotgames.com/lol/summoner/v3/summoners/by-name/jarechalde?api_key='

#RGAPI-f165ab9a-cab1-4a32-859b-3df7c20e370d

urlol = paste(urlol,key,sep = '')

#GEtting all the champions information
championsurl = 'https://na1.api.riotgames.com/lol/static-data/v3/champions?locale=en_US&dataById=true&api_key=RGAPI-ad126964-86f9-4815-97c8-dfc67d7f9ff2'
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
#gameids = gameids[1:1]

durations = c()
resultarray = c()
champplayed =c()

for (i in 1:length(gameids)){
  print(gameids[i])
  
  gameurl = 'https://na1.api.riotgames.com/lol/match/v3/matches/'
  gameurl = paste(gameurl,as.character(gameids[i]),'?api_key=',key, sep = '')
  
  gamedata = readLines(gameurl)
  gamedata = fromJSON(gamedata)
  
  #Extracting data
  participants = gamedata$participants
  team = gamedata$teams
  champid = gamedata$participants$championId[1]
  playermatchid = gamedata$participantIdentities$participantId[gamedata$participantIdentities$player$accountId == apidata$accountId]
  
  #Getting if we won or lost
  teamIDPlayer = participants$teamId[participants$participantId == playermatchid]
  winloss = team$win[team$teamId == teamIDPlayer]
  
  duration = gamedata$gameDuration/60
  
  #Storing data in arrays
  durations = c(durations,duration)
  resultarray = c(resultarray,winloss)
  champplayed = c(champplayed, as.character(champdataframe$champnames[champdataframe$champids == champid]))
  
  Sys.sleep(1)
}