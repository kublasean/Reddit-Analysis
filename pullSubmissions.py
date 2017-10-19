import click
import os
import re

import praw
import time
import datetime


@click.command()
@click.argument("subreddit",help="Name of the Subreddit",type=string)
@click.argument("startYear",help="Start timestamp year",type=int)
@click.argument("startMonth",help="Start timestamp month",type=int)
@click.argument("startDay",help="Start timestamp day",type=int)
@click.argument("stopYear",help="Stop timestamp year",type=int)
@click.argument("stopMonth",help="Stop timestamp month",type=int)
@click.argument("stopDay",help="Stop timestamp day",type=int)

def get_comments(submission):
	flat_comment = ''
	submission.comments.replace_more(limit=0)
	for comment in submission.comments.list():
		if not comment == '[deleted]':
			flat_comment += comment.body + ' '
	return flat_comment
	
def clean_flat_comments(document):
	document = document.encode(encoding='ascii', errors='ignore').decode('ascii')
	document = document.replace('\n', ' ')
	document = document.replace('\t', ' ')
	return document	


def main(subreddit,startYear,startMonth,startDay,stopYear,stopMonth,stopDay):
	
	reddit = praw.Reddit(client_id='qJwY2ZzRahm-GQ',
                     	client_secret='lkZjzt2g6MutrTm3D7c7hNl5R6w',
                     	user_agent='linux:reddit-analysis:v1.0.0 (by /u/DigitalArcheology)',
                     	username='DigitalArcheology',
                     	password='GOvols!2017')
                     
                     
	sub = reddit.subreddit(subreddit)

	timestamp_Start = time.mktime(datetime.date(startYear, startMonth, startDay).timetuple())
	timestamp_Stop = time.mktime(datetime.date(stopYear, stopMonth, stopDay).timetuple())

	submissions = []
	for submission in sub.submissions(start=timestamp_Start, end=timestamp_Stop):
		if submission.num_comments > 100:
    		submissions.append(submission)
    
	#print(len(submissions))
	outfile = str(subreddit)+'_'+ str(startYear) + '_' + str(startMonth) + ':' + str(stopYear) + '_' + str(stopMonth) + '_flatcomments.txt'
	with open(outfile, 'w') as f:
    	for i, submission in enumerate(submissions):
            document = get_comments(submission=submission)
            document = cc(document)
            f.write(submission.id + '\t' + document + '\n')

            
            
            
            
                                              