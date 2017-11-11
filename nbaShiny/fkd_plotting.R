library(tidyverse)
library(ggthemes)
library(scales)
library(lubridate)
library(zoo)
library(tweenr)

df = read.csv("../data/fkd.csv")
df$rollmean = rollmean(df$count, 30, na.pad = TRUE)
df$dt = as.Date(df$dt)

#plot
p = df %>% ggplot(aes(x=dt)) + 
  geom_point(aes(y = count, color = "black"), color = 'red') + 
  theme_minimal() + 
  scale_y_continuous(labels = scales::comma)  +
  geom_line(aes(y = rollmean, color = "red"), size = 1.5, color = 'black') + 
  scale_x_date(date_breaks = "3 months", date_labels = "%b-'%y") +
  theme( # remove the vertical grid lines
    panel.grid.minor.x = element_blank()) + theme(legend.position = "none") + 
  labs(x = "", 
       y = "# of fkds",
       title = "'Fuck KD' comments on /r/nba",
       subtitle = "Number of daily fkds\nDecember 2015 - September 2017",
       caption = "Reddit via Google Big Query") +
  geom_vline(xintercept = as.numeric(as.Date("2016-7-4")), linetype = 4)   + annotate("text", x = as.Date("2016-7-4"), y = 400, label = "Kevin Durant announces\n signing with GSW") +
  geom_vline(xintercept = as.numeric(as.Date("2016-11-03")), linetype = 4) + annotate("text", x = as.Date("2016-11-03"), y = 200, label = "First game against OKC") +
  geom_vline(xintercept = as.numeric(as.Date("2017-06-12")), linetype = 4) + annotate("text", x = as.Date("2017-06-12"), y = 650, label = "Warriors win Game 5\nof the NBA Finals")

p