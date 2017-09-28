# Reddit-Analysis

## Links
project proposal:
https://www.overleaf.com/11173103kgkpjdsybbsn

reddit authentication: 
https://github.com/reddit/reddit/wiki/OAuth2
http://praw.readthedocs.io/en/latest/index.html

extracting themes:
https://dl.acm.org/citation.cfm?id=1081895

## TODO:
1. figure out reddit auth process
2. ???
3. profit

## potential ideas:
  * identify memes
    * a meme is a popular repeated image or phrase
    * track popularity of memes vs. time
      * associate comment post time to parent post time
      * flatten comments -> one giant corpus
    * problems:
      * many memes are images/video, ignore these?
  * identify the most popular reddit users (those with most front page hits)
    * examine their interests
  * identify why some posts of the same content are upvoted, while others are not
  * how to determine themes?
  * find out why certain posts are controversial
  * look at point system
  * look at difference in reaction between the same content in different subreddits 
    * reddit bot does this?
  * most upvoted posts vs. downvoted 
  * most upvoted comments vs. downvoted
  * subreddit simulator
  
## installing praw on gcloud

1. log into docker 
2. docker-machine start fdac17-blah-1
3. docker-machine ssh fdac17-blah-1
4. sudo docker ps -a
   * if fdac17-blah isn't running then:
   * sudo docker start fdac-blah
5. sudo docker exec fdac-blah pip install --upgrade praw
6. logout, then ssh into fdac17-blah-1 and try import praw in python notebook
7. celebrate
     
