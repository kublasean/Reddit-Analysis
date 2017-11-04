library(bigrquery)

# set google project id & table id
pid = "subtle-melody-179319"

#sql request to get fkds per day
sql = 
  "SELECT COUNT(*) as count, DATE(SEC_TO_TIMESTAMP(created_utc)) as dt
  FROM 
  [fh-bigquery.reddit_comments.2017_09], [fh-bigquery.reddit_comments.2017_08], [fh-bigquery.reddit_comments.2017_07],
  [fh-bigquery.reddit_comments.2017_06], [fh-bigquery.reddit_comments.2017_05], [fh-bigquery.reddit_comments.2017_04],
  [fh-bigquery.reddit_comments.2017_03], [fh-bigquery.reddit_comments.2017_02], [fh-bigquery.reddit_comments.2017_01],
  [fh-bigquery.reddit_comments.2016_12], [fh-bigquery.reddit_comments.2016_11], [fh-bigquery.reddit_comments.2016_10],
  [fh-bigquery.reddit_comments.2016_09], [fh-bigquery.reddit_comments.2016_08], [fh-bigquery.reddit_comments.2016_07],
  [fh-bigquery.reddit_comments.2016_06], [fh-bigquery.reddit_comments.2016_05], [fh-bigquery.reddit_comments.2016_04],
  [fh-bigquery.reddit_comments.2016_03], [fh-bigquery.reddit_comments.2016_02], [fh-bigquery.reddit_comments.2016_01],
  [fh-bigquery.reddit_comments.2015_12],
  
  WHERE subreddit = 'nba' AND
  REGEXP_MATCH(body, r'(?i:fuck kd)')
  GROUP BY dt
  ORDER BY dt"
fkds = tbl_df(query_exec(sql, project=pid, max_pages=Inf))

# unfortunately this query doesn't include days where no fkd was found
# so we'll create a zeroed table for the given date range and merge
zeroes = data.frame('count'=0,'dt'=seq.Date(as.Date("2015-12-01"), as.Date("2017-09-30"), 1))

# if a date is NOT in the fkd table then add it with count of 0
fkds = rbind(fkds, zeroes[!(as.Date(zeroes$dt) %in% as.Date(fkds$dt)),])

#order by date again
fkds = fkds[order(fkds$dt)]

# write to .csv file (excel format, etc)
write.csv(res, file="fkd.csv", row.names=FALSE)