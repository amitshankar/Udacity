Title: Analyzing Twitter Feed - Part 2 - Wrangle Report
Author: Amit Shankar
Date: 08/19/2018
Tags: data analyst nanodegree, python, twitter
Summary: This is the third project of term 02 in the data analyst nanodegree program. This post shows the wrangling efforts used in gathering, accessing and cleaning the data.


# Wrangle Report

## 1. Data Gathering Efforts 

The twitter-archive-enhanced.csv was saved to the local directory by clicking the following link https://d17h27t6h515a5.cloudfront.net/topher/2017/August/59a4e958_twitter-archive-enhanced/twitter-archive-enhanced.csv and saving the corresponding csv file in the local working directory. This was a manual process and not scaleable. This process could be made more efficient by directly passing the url to the pandas read csv function eg. 
pd.read_csv('https://d17h27t6h515a5.cloudfront.net/topher/2017/August/59a4e958_twitter-archive-enhanced/twitter-archive-enhanced.csv').

The image_predictions.tsv was programmatically downloaded from https://d17h27t6h515a5.cloudfront.net/topher/2017/August/599fd2ad_image-predictions/image-predictions.tsv using the requests funciton in conjunction with file.write function. This is very scaleable becuase it allows for setting dynamic filenames by extracting file names from the url and saving the content to specific file name. The mode='wb' allows for saving files individually but by setting mode='a', we can append content from numerous files into one file.

Downloading Twitter data via Twitter API and tweepy library was a lengthy learning process. First set the consumer and access token/keys. Used a json parser by setting tweepy.API(parser=tweepy.parsers.JSONParser()) becuase twitter data is stored in json format and the json parser allows for converting to downloaded data in json format. Once the data is in json format, it is appended to  tweet_json.txt file in the working directory. After the data is saved to working directory, it is then read back into memory as a python list. Each element in the list is converted back into a json format and revelant data is extracted such as tweet id, favorites count and retweet count.

It is helpful to save each tweet's complete data to the file and read it back to extract info because it saves time in the future to re-read the data from file than to read the data from twitter's website.

api.get_status(tweet_mode='extended')
By setting the tweet_mode='extended', allows the api to download more data relating to a tweet. I have noticed that the tweet text is truncated followed by a '...' if the tweet_mode is not set to extended .i.e. in extended mode, the api is able to download the complete tweet text. 

**Some important takeaways:** 
1. It is helpful to name dataframes with extenion df_***, so typing a dataframe name, we can type 'df' and autocomplete can show a drop down list of dataframes for us to choose from.
2. It is also helpful to paste the json format tweet in sublime text to see the indents in the text and this is very helpful when extracting  values from multilevel lists.



## 2. Data Accessing Issues 

## Content Issues 

(Visual & Programmatically - completness, validity, accuracy, consistency)

### twitter_archive dataframe
    
    - The expanded_url column, has some instances where the url is repeated multiple times in a cell separated by a comma
    - The name column has non name strings such as None, a, an 
    - Rating_denominator as high as 80
    - The following variables should be integers instead of floats: in_reply_to_status_id,in_reply_to_user_id,    
      retweeted_status_id,retweeted_status_user_id 
    - Contains retweets


### image_predictions dataframe

    - p1, p2,p3: upper and lower case mixed together
    - p1, p2,p3: dash and underscore mixed in string eg. black-and-tan_coonhound	
    - Missing values when compared to twitter_archive dataframe

###  tweet_json dataframe

    - time_created should be a data/time object

## Structural Issues

(Visual & Programmatically -  variable(column), observation(row), unit(table))

### twitter_archive dataframe

    - The timestamp column contains two separate variables date and time. 
    - The anchor text in source column is repeated numerous times
    - Variables called 'doggo', 'floofer', 'pupper', 'puppo' are different growth stages of a pet based on age.

### image_predictions dataframe

    - Merge the dataset with twitter_archive dataframe based on tweet_id

###  tweet_json dataframe

    - time_created could be further split into day, month and time 
    - Merge this dataframe with twitter_archive dataframe


## 3. Data Cleaning 

Cleaning the timestamp variable in df_twitter_archive_clean dataframe was tricky. The pd.to_datetime function was very helpful in converting a column to datetime format. The month, week and hour function in the datetime library can not be applied directly to a dataframe column and mapping using lambda function was very helpful. 

Also mapping the dictory on a dataframe column is very helpful instead of using a multilevel if else condition. I used dictionary to map source values in the df_twitter_archive_clean dataframe.

Its also useful to note that a print function on a text column with truncate the results on screen and mapping a lambda function works well eg.  df_twitter_archive_clean.expanded_urls.map(lambda a : print(a))

#### Goal

The goal of cleaning was to produce a high quality dataframe that can provide insights to these questions: 

1. Is the tweet that received the most favorites count also the tweet that was retweeted most?
2. What day of the week were most of the tweets created? 
3. What are some of the common words used in the top tweets?


```python

```
