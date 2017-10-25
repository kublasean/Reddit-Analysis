import numpy as np
import praw


def main():

input_file = args.SubmissionFile


ids = np.loadtxt(input_file,delimiter='\t',usecols=(0,),dtype=str)

reddit = praw.Reddit(client_id='qJwY2ZzRahm-GQ',
                     client_secret='lkZjzt2g6MutrTm3D7c7hNl5R6w',
                     user_agent='linux:reddit-analysis:v1.0.0 (by /u/DigitalArcheology)',
                     username='DigitalArcheology',
                     password='GOvols!2017')


outfile = input_file.rsplit('_',maxsplit=1)[0] + '_authors.txt'

with open(outfile,"w") as f:
    for i_d in ids:
	submission = reddit.submission(id=i_d)
        f.write(str(submission.id) + '\t' + "submission" + '\t' + str(submission.author.name) + '\t' + str(sub) + '\n')
        #print ("Sub Author: ", submission.author.name)
        submission.comments.replace_more(limit=0)
        for comment in submission.comments.list():
            if comment.author != None:
                #print(comment.author.name)
                f.write(str(submission.id) + '\t' + "comment" + '\t' + str(comment.author.name) + '\t' + str(sub) + '\n')



if __name__ == '__main__':
	import argparse
	parser = argparse.ArgumentParser()
	parser.add_argument("SubmissionFile",help="Name of file, IDs in first column")
	args = parser.parse_args()
	main() 
