#Lol API

key = 'RGAPI-f165ab9a-cab1-4a32-859b-3df7c20e370d'
urlol = 'https://na1.api.riotgames.com/lol/summoner/v3/summoners/by-name/jarechalde?api_key='

#RGAPI-f165ab9a-cab1-4a32-859b-3df7c20e370d

urlol = paste(urlol,key,sep = '')

#We call the API, and convert the results
apidata = readLines(urlol)
apidata = fromJSON(apidata)

matchurl = 'https://na1.api.riotgames.com/lol/match/v3/matchlists/by-account/'
matchurl = paste(matchurl,apidata$accountId,'?api_key=',key,sep = '')

#We call the API, and convert the results
matchdata = readLines(matchurl)
matchdata = fromJSON(matchdata)

gameids = matchdata$matches$gameId

durations = c()

for (i in 1:length(gameids)){
  print(gameids[i])
  
  gameurl = 'https://na1.api.riotgames.com/lol/match/v3/matches/'
  key = '?api_key=RGAPI-f165ab9a-cab1-4a32-859b-3df7c20e370d'
  gameurl = paste(gameurl,as.character(gameids[i]), key, sep = '')
  
  gamedata = readLines(gameurl)
  gamedata = fromJSON(gamedata)
  
  duration = gamedata$gameDuration/60
  
  durations = c(durations,duration)
  Sys.sleep(5)
}