Title: Analyzing Twitter Feed - Part 1 - Wrangling Code
Author: Amit Shankar
Date: 08/18/2018
Tags: data analyst nanodegree, python, twitter
Summary: This is the third project of term 02 in the data analyst nanodegree program. This file shows the actual codes used to download tweets from twitter and the codes used to clean the data.

# Wrangle Report

   
**Table of Contents**<a id='Top'><a>   
[Reference](#Reference)  
[A. Data Gathering Efforts](#A)  
[B. Data Access Issues](#B)  
[C. Data Cleaning](#C)



<a id='Reference'></a>
[Top](#Top)
# Reference 


https://stackoverflow.com/questions/32400867/pandas-read-csv-from-url  
https://developer.twitter.com/en/docs/tweets/data-dictionary/overview/tweet-object3
https://stackoverflow.com/questions/6159900/correct-way-to-write-line-to-file
https://stackoverflow.com/questions/4706499/how-do-you-append-to-a-file
https://stackoverflow.com/questions/41001973/python-3-5-1-nameerror-name-json-is-not-defined
https://stackoverflow.com/questions/27900451/convert-tweepy-status-object-into-json
https://gist.github.com/yanofsky/5436496
https://stackoverflow.com/questions/11716380/python-beautifulsoup-extract-text-from-anchor-tag
https://stackoverflow.com/questions/30522724/take-multiple-lists-into-dataframe
https://stackoverflow.com/questions/15247628/how-to-find-duplicate-names-using-pandas  
https://stackoverflow.com/questions/466345/converting-string-into-datetime
https://stackoverflow.com/questions/33034559/how-to-remove-last-the-two-digits-in-a-column-that-is-of-integer-type
https://stackoverflow.com/questions/25146121/extracting-just-month-and-year-from-pandas-datetime-column-python
https://stackoverflow.com/questions/20250771/remap-values-in-pandas-column-with-a-dict
https://stackoverflow.com/questions/39092067/pandas-dataframe-convert-column-type-to-string-or-categorical
https://stackoverflow.com/questions/18792918/combine-two-pandas-data-frames-join-on-a-common-column


```python
#import libraries
import requests # reading files programmatically
import os # manipulating file paths
import pandas as pd
import numpy as np
import tweepy #read tweeter data -- pip install tweepy
#import simplejson as json # to make json dumps --  pip install simplejson
import json # to create json objects 
import time # to calculate the execution times of functions
from datetime import datetime

# set seed for sampling
np.random.seed(27)

```

<a id='A'></a>
[Top](#Top)
# A. Data Gathering Efforts 

## 1. Downloading the twitter-archive-enhanced.csv

The twitter-archive-enhanced.csv was saved to the local directory by clicking the following link https://d17h27t6h515a5.cloudfront.net/topher/2017/August/59a4e958_twitter-archive-enhanced/twitter-archive-enhanced.csv 
and saving the corresponding csv file in the local working directory. 


```python
# read the twitter-archive-enhanced.csv file intp a pandas dataframe
df_twitter_archive=pd.read_csv('twitter-archive-enhanced.csv')
```


```python
# examine the dataframe
df_twitter_archive.head(2)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>tweet_id</th>
      <th>in_reply_to_status_id</th>
      <th>in_reply_to_user_id</th>
      <th>timestamp</th>
      <th>source</th>
      <th>text</th>
      <th>retweeted_status_id</th>
      <th>retweeted_status_user_id</th>
      <th>retweeted_status_timestamp</th>
      <th>expanded_urls</th>
      <th>rating_numerator</th>
      <th>rating_denominator</th>
      <th>name</th>
      <th>doggo</th>
      <th>floofer</th>
      <th>pupper</th>
      <th>puppo</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>892420643555336193</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-08-01 16:23:56 +0000</td>
      <td>&lt;a href="http://twitter.com/download/iphone" r...</td>
      <td>This is Phineas. He's a mystical boy. Only eve...</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>https://twitter.com/dog_rates/status/892420643...</td>
      <td>13</td>
      <td>10</td>
      <td>Phineas</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
    </tr>
    <tr>
      <th>1</th>
      <td>892177421306343426</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-08-01 00:17:27 +0000</td>
      <td>&lt;a href="http://twitter.com/download/iphone" r...</td>
      <td>This is Tilly. She's just checking pup on you....</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>https://twitter.com/dog_rates/status/892177421...</td>
      <td>13</td>
      <td>10</td>
      <td>Tilly</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
    </tr>
  </tbody>
</table>
</div>




```python
# examine the dataframe structure
df_twitter_archive.info()
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 2356 entries, 0 to 2355
    Data columns (total 17 columns):
    tweet_id                      2356 non-null int64
    in_reply_to_status_id         78 non-null float64
    in_reply_to_user_id           78 non-null float64
    timestamp                     2356 non-null object
    source                        2356 non-null object
    text                          2356 non-null object
    retweeted_status_id           181 non-null float64
    retweeted_status_user_id      181 non-null float64
    retweeted_status_timestamp    181 non-null object
    expanded_urls                 2297 non-null object
    rating_numerator              2356 non-null int64
    rating_denominator            2356 non-null int64
    name                          2356 non-null object
    doggo                         2356 non-null object
    floofer                       2356 non-null object
    pupper                        2356 non-null object
    puppo                         2356 non-null object
    dtypes: float64(4), int64(3), object(10)
    memory usage: 313.0+ KB
    

## Observation
The df_twitter_archive dataframe has 17 variables and 2356 observations. Some of the variables have missing values.


```python

```

## 2. Downloading programmatically the image_predictions.tsv file

The image_predictions.tsv was programmatically downloaded from https://d17h27t6h515a5.cloudfront.net/topher/2017/August/599fd2ad_image-predictions/image-predictions.tsv using the requests funciton.


```python
# programmatically download the image_predictions.tsv file
url='https://d17h27t6h515a5.cloudfront.net/topher/2017/August/599fd2ad_image-predictions/image-predictions.tsv'
response=requests.get(url) # saves the file in the memory

# view the file in the memory
# response.content

# create the file name by truncating the file name from the end of the url
file_name=url.split('/')[-1] #'image-predictions.tsv'

# write the tsv file to the working directory 
with open(file_name, mode='wb') as file:
    file.write(response.content)
    
```


```python
# read the image-predictions.tsv file into a pandas file
df_image_predictions=pd.read_csv('image-predictions.tsv', sep = '\t', encoding = 'utf-8')
```


```python
# examine the image_predictions_df dataframe
df_image_predictions.head(2)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>tweet_id</th>
      <th>jpg_url</th>
      <th>img_num</th>
      <th>p1</th>
      <th>p1_conf</th>
      <th>p1_dog</th>
      <th>p2</th>
      <th>p2_conf</th>
      <th>p2_dog</th>
      <th>p3</th>
      <th>p3_conf</th>
      <th>p3_dog</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>666020888022790149</td>
      <td>https://pbs.twimg.com/media/CT4udn0WwAA0aMy.jpg</td>
      <td>1</td>
      <td>Welsh_springer_spaniel</td>
      <td>0.465074</td>
      <td>True</td>
      <td>collie</td>
      <td>0.156665</td>
      <td>True</td>
      <td>Shetland_sheepdog</td>
      <td>0.061428</td>
      <td>True</td>
    </tr>
    <tr>
      <th>1</th>
      <td>666029285002620928</td>
      <td>https://pbs.twimg.com/media/CT42GRgUYAA5iDo.jpg</td>
      <td>1</td>
      <td>redbone</td>
      <td>0.506826</td>
      <td>True</td>
      <td>miniature_pinscher</td>
      <td>0.074192</td>
      <td>True</td>
      <td>Rhodesian_ridgeback</td>
      <td>0.072010</td>
      <td>True</td>
    </tr>
  </tbody>
</table>
</div>




```python
# examine the structure of the df_image_predictions dataframe
df_image_predictions.info()
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 2075 entries, 0 to 2074
    Data columns (total 12 columns):
    tweet_id    2075 non-null int64
    jpg_url     2075 non-null object
    img_num     2075 non-null int64
    p1          2075 non-null object
    p1_conf     2075 non-null float64
    p1_dog      2075 non-null bool
    p2          2075 non-null object
    p2_conf     2075 non-null float64
    p2_dog      2075 non-null bool
    p3          2075 non-null object
    p3_conf     2075 non-null float64
    p3_dog      2075 non-null bool
    dtypes: bool(3), float64(3), int64(2), object(4)
    memory usage: 152.1+ KB
    

## Observation

The df_image_predictions has 12 variables and 2075 observations. The are no missing values in the dataframe.


```python

```

## 3. Downloading Twitter data via Twitter API and tweepy library


```python
## set tweet consumer and access key >>> replace the ### with actual keys
consumer_key = 'Yn71UCiC2MdIHkBalOBc08yMO'
consumer_secret = 'K7CAtE6njCkEA3trt592jJEBDRa0a6OkZsoV6MsdkM8BLWPSCl'
access_token = '108732090-QR9V8gfQGTPu6tJBzNkINGhKjCTMh0vhuOziyoe3'
access_secret = 'HsALvm8Y5qG77fTMrfGeWjVYZY6DnupdoZu4FSBnaUmk2'

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_secret)

# use jsonparser to make json readable content, create json dumps and query json objects
# wait_on_rate_limit = True , allows the program to wait during timeouts 
# wait_on_rate_limit_notify = True, writes to screen when waiting
api = tweepy.API(auth,parser=tweepy.parsers.JSONParser(),wait_on_rate_limit = True, wait_on_rate_limit_notify = True)
```


```python
# function to append file line by line
# The function was adapted from https://stackoverflow.com/questions/4706499/how-do-you-append-to-a-file
# input: the function takes a filename string and text
# process: the function opens a file and adds the text in append mode
# out: none
def FileSave(filename,content):
    with open(filename, "a") as myfile:
        myfile.write(content)
```


```python
# input: the function takes a list of tweet ids and a filename
# process: the function downloads tweets corresponding to a tweet ids and adds it to a file
# out: the function prints out the time taken to download the tweets, prints the error msgs and
#      returns a list of ids that could not be downloaded

def download_tweets(id_list,filename):
    
    # set the start time
    start_time = time.time()

    unloaded_tweet_ids=[]
    counter=0
    for i in id_list:
        try:
            #print(counter,' >> Tweet id: ',i)
            tweet=api.get_status(i,tweet_mode='extended')
            FileSave(filename,json.dumps(tweet)+'\n')
            counter=counter+1
            
        except Exception as download_error_msg:
            print(counter,' >> Tweet id: ',i)
            print(download_error_msg)
            unloaded_tweet_ids.append(i)
            counter=counter+1

            
    #print unloaded tweeter ids
    print('\n \nTotal number of Tweeter ids :',len(id_list))
    print('The following ',len(unloaded_tweet_ids), 'tweet ids could not be downloaded for various reasons: ')
    print(unloaded_tweet_ids)
    
    # set the end time
    end_time = time.time()

    # print the execution time
    print('\n \nThe download process took: ', (end_time - start_time)/60, ' minutes')
    
    return(unloaded_tweet_ids)
```


```python
# set the tweet ids that will be using in the api to access the actual data
tweet_id=df_twitter_archive['tweet_id']

# download tweets by passing the tweet_id list and tweet_json.txt filename
# save the results of unloaded ids so they can be attempted again
error_ids_01=download_tweets(tweet_id,'tweet_json.txt')
```

    19  >> Tweet id:  888202515573088257
    [{'code': 144, 'message': 'No status found with that ID.'}]
    95  >> Tweet id:  873697596434513921
    [{'code': 144, 'message': 'No status found with that ID.'}]
    118  >> Tweet id:  869988702071779329
    [{'code': 144, 'message': 'No status found with that ID.'}]
    132  >> Tweet id:  866816280283807744
    [{'code': 144, 'message': 'No status found with that ID.'}]
    155  >> Tweet id:  861769973181624320
    [{'code': 144, 'message': 'No status found with that ID.'}]
    247  >> Tweet id:  845459076796616705
    [{'code': 144, 'message': 'No status found with that ID.'}]
    260  >> Tweet id:  842892208864923648
    [{'code': 144, 'message': 'No status found with that ID.'}]
    298  >> Tweet id:  837012587749474308
    [{'code': 144, 'message': 'No status found with that ID.'}]
    382  >> Tweet id:  827228250799742977
    [{'code': 144, 'message': 'No status found with that ID.'}]
    566  >> Tweet id:  802247111496568832
    [{'code': 144, 'message': 'No status found with that ID.'}]
    784  >> Tweet id:  775096608509886464
    [{'code': 144, 'message': 'No status found with that ID.'}]
    815  >> Tweet id:  771004394259247104
    [{'code': 179, 'message': 'Sorry, you are not authorized to see this status.'}]
    818  >> Tweet id:  770743923962707968
    [{'code': 144, 'message': 'No status found with that ID.'}]
    

    Rate limit reached. Sleeping for: 732
    

    932  >> Tweet id:  754011816964026368
    [{'code': 144, 'message': 'No status found with that ID.'}]
    

    Rate limit reached. Sleeping for: 728
    

    
     
    Total number of Tweeter ids : 2356
    The following  14 tweet ids could not be downloaded for various reasons: 
    [888202515573088257, 873697596434513921, 869988702071779329, 866816280283807744, 861769973181624320, 845459076796616705, 842892208864923648, 837012587749474308, 827228250799742977, 802247111496568832, 775096608509886464, 771004394259247104, 770743923962707968, 754011816964026368]
    
     
    The download process took:  31.737418989340465  minutes
    


```python
# try to download the tweet contents corresponding the error tweets
error_ids_02=download_tweets(error_ids_01,'tweet_json.txt')
```

    0  >> Tweet id:  888202515573088257
    [{'code': 144, 'message': 'No status found with that ID.'}]
    1  >> Tweet id:  873697596434513921
    [{'code': 144, 'message': 'No status found with that ID.'}]
    2  >> Tweet id:  869988702071779329
    [{'code': 144, 'message': 'No status found with that ID.'}]
    3  >> Tweet id:  866816280283807744
    [{'code': 144, 'message': 'No status found with that ID.'}]
    4  >> Tweet id:  861769973181624320
    [{'code': 144, 'message': 'No status found with that ID.'}]
    5  >> Tweet id:  845459076796616705
    [{'code': 144, 'message': 'No status found with that ID.'}]
    6  >> Tweet id:  842892208864923648
    [{'code': 144, 'message': 'No status found with that ID.'}]
    7  >> Tweet id:  837012587749474308
    [{'code': 144, 'message': 'No status found with that ID.'}]
    8  >> Tweet id:  827228250799742977
    [{'code': 144, 'message': 'No status found with that ID.'}]
    9  >> Tweet id:  802247111496568832
    [{'code': 144, 'message': 'No status found with that ID.'}]
    10  >> Tweet id:  775096608509886464
    [{'code': 144, 'message': 'No status found with that ID.'}]
    11  >> Tweet id:  771004394259247104
    [{'code': 179, 'message': 'Sorry, you are not authorized to see this status.'}]
    12  >> Tweet id:  770743923962707968
    [{'code': 144, 'message': 'No status found with that ID.'}]
    13  >> Tweet id:  754011816964026368
    [{'code': 144, 'message': 'No status found with that ID.'}]
    
     
    Total number of Tweeter ids : 14
    The following  14 tweet ids could not be downloaded for various reasons: 
    [888202515573088257, 873697596434513921, 869988702071779329, 866816280283807744, 861769973181624320, 845459076796616705, 842892208864923648, 837012587749474308, 827228250799742977, 802247111496568832, 775096608509886464, 771004394259247104, 770743923962707968, 754011816964026368]
    
     
    The download process took:  0.03408433596293132  minutes
    

## Observation

At this point, we have successfully saved each tweet's entire content in a tweet_json.txt file with each tweet in a new line.There were 13 tweets that could not be downloaded for various reasons.  

Next, we will read the file into memory where each tweet will be saved into a separate element in a list called 'lines'. We will then iterate through the lines list and extract interesting elements such as tweet text, favourites count, retweet count etc in separate lists and later concatenate the lists into a dataframe.  


```python
## read json file to a list array and strip new line charactor
lines = [line.rstrip('\n') for line in open('tweet_json.txt')]
```


```python
# read one tweet into a temp file to examine its content
# load the tweet into a json format for easier extraction of information
tmp = json.loads(lines[0])

# examine a tweet
tmp
```




    {'contributors': None,
     'coordinates': None,
     'created_at': 'Tue Aug 01 16:23:56 +0000 2017',
     'display_text_range': [0, 85],
     'entities': {'hashtags': [],
      'media': [{'display_url': 'pic.twitter.com/MgUWQ76dJU',
        'expanded_url': 'https://twitter.com/dog_rates/status/892420643555336193/photo/1',
        'id': 892420639486877696,
        'id_str': '892420639486877696',
        'indices': [86, 109],
        'media_url': 'http://pbs.twimg.com/media/DGKD1-bXoAAIAUK.jpg',
        'media_url_https': 'https://pbs.twimg.com/media/DGKD1-bXoAAIAUK.jpg',
        'sizes': {'large': {'h': 528, 'resize': 'fit', 'w': 540},
         'medium': {'h': 528, 'resize': 'fit', 'w': 540},
         'small': {'h': 528, 'resize': 'fit', 'w': 540},
         'thumb': {'h': 150, 'resize': 'crop', 'w': 150}},
        'type': 'photo',
        'url': 'https://t.co/MgUWQ76dJU'}],
      'symbols': [],
      'urls': [],
      'user_mentions': []},
     'extended_entities': {'media': [{'display_url': 'pic.twitter.com/MgUWQ76dJU',
        'expanded_url': 'https://twitter.com/dog_rates/status/892420643555336193/photo/1',
        'id': 892420639486877696,
        'id_str': '892420639486877696',
        'indices': [86, 109],
        'media_url': 'http://pbs.twimg.com/media/DGKD1-bXoAAIAUK.jpg',
        'media_url_https': 'https://pbs.twimg.com/media/DGKD1-bXoAAIAUK.jpg',
        'sizes': {'large': {'h': 528, 'resize': 'fit', 'w': 540},
         'medium': {'h': 528, 'resize': 'fit', 'w': 540},
         'small': {'h': 528, 'resize': 'fit', 'w': 540},
         'thumb': {'h': 150, 'resize': 'crop', 'w': 150}},
        'type': 'photo',
        'url': 'https://t.co/MgUWQ76dJU'}]},
     'favorite_count': 38492,
     'favorited': False,
     'full_text': "This is Phineas. He's a mystical boy. Only ever appears in the hole of a donut. 13/10 https://t.co/MgUWQ76dJU",
     'geo': None,
     'id': 892420643555336193,
     'id_str': '892420643555336193',
     'in_reply_to_screen_name': None,
     'in_reply_to_status_id': None,
     'in_reply_to_status_id_str': None,
     'in_reply_to_user_id': None,
     'in_reply_to_user_id_str': None,
     'is_quote_status': False,
     'lang': 'en',
     'place': None,
     'possibly_sensitive': False,
     'possibly_sensitive_appealable': False,
     'retweet_count': 8480,
     'retweeted': False,
     'source': '<a href="http://twitter.com/download/iphone" rel="nofollow">Twitter for iPhone</a>',
     'truncated': False,
     'user': {'contributors_enabled': False,
      'created_at': 'Sun Nov 15 21:41:29 +0000 2015',
      'default_profile': False,
      'default_profile_image': False,
      'description': 'Your Only Source For Professional Dog Ratings  IG, FB, Snapchat ⇨ WeRateDogs ⠀⠀⠀⠀ Business Inquiries: dogratingtwitter@gmail.com',
      'entities': {'description': {'urls': []},
       'url': {'urls': [{'display_url': 'weratedogs.com',
          'expanded_url': 'http://weratedogs.com',
          'indices': [0, 23],
          'url': 'https://t.co/N7sNNHAEXS'}]}},
      'favourites_count': 137074,
      'follow_request_sent': False,
      'followers_count': 7174950,
      'following': False,
      'friends_count': 10,
      'geo_enabled': True,
      'has_extended_profile': False,
      'id': 4196983835,
      'id_str': '4196983835',
      'is_translation_enabled': False,
      'is_translator': False,
      'lang': 'en',
      'listed_count': 4906,
      'location': '⇩ merch ⇩         DM YOUR DOGS',
      'name': 'WeRateDogs™',
      'notifications': False,
      'profile_background_color': '000000',
      'profile_background_image_url': 'http://abs.twimg.com/images/themes/theme1/bg.png',
      'profile_background_image_url_https': 'https://abs.twimg.com/images/themes/theme1/bg.png',
      'profile_background_tile': False,
      'profile_banner_url': 'https://pbs.twimg.com/profile_banners/4196983835/1525830435',
      'profile_image_url': 'http://pbs.twimg.com/profile_images/948761950363664385/Fpr2Oz35_normal.jpg',
      'profile_image_url_https': 'https://pbs.twimg.com/profile_images/948761950363664385/Fpr2Oz35_normal.jpg',
      'profile_link_color': 'F5ABB5',
      'profile_sidebar_border_color': '000000',
      'profile_sidebar_fill_color': '000000',
      'profile_text_color': '000000',
      'profile_use_background_image': False,
      'protected': False,
      'screen_name': 'dog_rates',
      'statuses_count': 8670,
      'time_zone': None,
      'translator_type': 'none',
      'url': 'https://t.co/N7sNNHAEXS',
      'utc_offset': None,
      'verified': True}}




```python
# Extract elements
print(tmp['id'])
```

    892420643555336193
    


```python
# Extract elements from the lines list

# total number of tweets 
number_of_tweets=len(lines)

# initialize a set of lists that will hold informative tweet elements 
list_t_ids=[] # will store ids
list_t_created_at=[] # will store the dates tweets were created 
list_t_full_text=[] # will store the full text
list_t_favorite_count=[] # will store the count of favorites
list_t_retweet_count=[] # will store the count of retweets

# iterate over the lines list of tweets, extract information and save to the initialized lists
for i in range(number_of_tweets):
    
    # load a list element containing a tweet into json format
    tmp = json.loads(lines[i])
    
    # extract and add the id
    list_t_ids.append(tmp['id'])

    # extract and add the date the tweet was created
    list_t_created_at.append(tmp['created_at'])

    
    # extract and add the full text from the tweet
    list_t_full_text.append(tmp['full_text'])
    
    # extract add the favorite count
    list_t_favorite_count.append(tmp['favorite_count'])
    
    # extract and add the retweet count
    list_t_retweet_count.append(tmp['retweet_count'])
        
    #print(i)
```


```python
# concatenate the lists into a pandas dataframe
lists = [list_t_ids, list_t_created_at, list_t_full_text,list_t_favorite_count,list_t_retweet_count]
df_json_tweets = pd.concat([pd.Series(x) for x in lists], axis=1)
df_json_tweets.columns = ['tweet_id', 'time_created','full_text','favorite_count','retweet_count']
```


```python
# examine the jason_tweets dataframe
df_json_tweets.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>tweet_id</th>
      <th>time_created</th>
      <th>full_text</th>
      <th>favorite_count</th>
      <th>retweet_count</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>892420643555336193</td>
      <td>Tue Aug 01 16:23:56 +0000 2017</td>
      <td>This is Phineas. He's a mystical boy. Only eve...</td>
      <td>38492</td>
      <td>8480</td>
    </tr>
    <tr>
      <th>1</th>
      <td>892177421306343426</td>
      <td>Tue Aug 01 00:17:27 +0000 2017</td>
      <td>This is Tilly. She's just checking pup on you....</td>
      <td>32986</td>
      <td>6241</td>
    </tr>
    <tr>
      <th>2</th>
      <td>891815181378084864</td>
      <td>Mon Jul 31 00:18:03 +0000 2017</td>
      <td>This is Archie. He is a rare Norwegian Pouncin...</td>
      <td>24840</td>
      <td>4137</td>
    </tr>
    <tr>
      <th>3</th>
      <td>891689557279858688</td>
      <td>Sun Jul 30 15:58:51 +0000 2017</td>
      <td>This is Darla. She commenced a snooze mid meal...</td>
      <td>41865</td>
      <td>8598</td>
    </tr>
    <tr>
      <th>4</th>
      <td>891327558926688256</td>
      <td>Sat Jul 29 16:00:24 +0000 2017</td>
      <td>This is Franklin. He would like you to stop ca...</td>
      <td>40029</td>
      <td>9336</td>
    </tr>
  </tbody>
</table>
</div>




```python
# examine the json_tweets data structure
df_json_tweets.info()
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 2342 entries, 0 to 2341
    Data columns (total 5 columns):
    tweet_id          2342 non-null int64
    time_created      2342 non-null object
    full_text         2342 non-null object
    favorite_count    2342 non-null int64
    retweet_count     2342 non-null int64
    dtypes: int64(3), object(2)
    memory usage: 91.6+ KB
    

## Observation

df_json_tweets dataframe has 5 variables and 2343 observations. It has no missing values.



```python

```

<a id='B'></a>
[Top](#Top)
## B. Data Access Issues 
(The insights here are summarized from analysis in this subsection.)


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



```python

```


```python
# function to find duplicates in a dataframe column
# source:  https://stackoverflow.com/questions/15247628/how-to-find-duplicate-names-using-pandas
def find_duplicates(df_column):
    names=df_column.value_counts()
    return(names[names>1])
```

# Analysing the twitter_archive dataframe


```python
df_twitter_archive.head(2)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>tweet_id</th>
      <th>in_reply_to_status_id</th>
      <th>in_reply_to_user_id</th>
      <th>timestamp</th>
      <th>source</th>
      <th>text</th>
      <th>retweeted_status_id</th>
      <th>retweeted_status_user_id</th>
      <th>retweeted_status_timestamp</th>
      <th>expanded_urls</th>
      <th>rating_numerator</th>
      <th>rating_denominator</th>
      <th>name</th>
      <th>doggo</th>
      <th>floofer</th>
      <th>pupper</th>
      <th>puppo</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>892420643555336193</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-08-01 16:23:56 +0000</td>
      <td>&lt;a href="http://twitter.com/download/iphone" r...</td>
      <td>This is Phineas. He's a mystical boy. Only eve...</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>https://twitter.com/dog_rates/status/892420643...</td>
      <td>13</td>
      <td>10</td>
      <td>Phineas</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
    </tr>
    <tr>
      <th>1</th>
      <td>892177421306343426</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-08-01 00:17:27 +0000</td>
      <td>&lt;a href="http://twitter.com/download/iphone" r...</td>
      <td>This is Tilly. She's just checking pup on you....</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>https://twitter.com/dog_rates/status/892177421...</td>
      <td>13</td>
      <td>10</td>
      <td>Tilly</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
    </tr>
  </tbody>
</table>
</div>



There is presence of missing values in twitter archive table so this needs to be further investigated. The timestamp column contains two separate variables date and time. 


```python
df_twitter_archive.columns
```




    Index(['tweet_id', 'in_reply_to_status_id', 'in_reply_to_user_id', 'timestamp',
           'source', 'text', 'retweeted_status_id', 'retweeted_status_user_id',
           'retweeted_status_timestamp', 'expanded_urls', 'rating_numerator',
           'rating_denominator', 'name', 'doggo', 'floofer', 'pupper', 'puppo'],
          dtype='object')



Variables called 'doggo', 'floofer', 'pupper', 'puppo' are different growth stages of a pet and should be in one column.


```python
df_twitter_archive.sample(5)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>tweet_id</th>
      <th>in_reply_to_status_id</th>
      <th>in_reply_to_user_id</th>
      <th>timestamp</th>
      <th>source</th>
      <th>text</th>
      <th>retweeted_status_id</th>
      <th>retweeted_status_user_id</th>
      <th>retweeted_status_timestamp</th>
      <th>expanded_urls</th>
      <th>rating_numerator</th>
      <th>rating_denominator</th>
      <th>name</th>
      <th>doggo</th>
      <th>floofer</th>
      <th>pupper</th>
      <th>puppo</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>815</th>
      <td>771004394259247104</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2016-08-31 15:19:06 +0000</td>
      <td>&lt;a href="http://twitter.com/download/iphone" r...</td>
      <td>RT @katieornah: @dog_rates learning a lot at c...</td>
      <td>7.710021e+17</td>
      <td>1.732729e+09</td>
      <td>2016-08-31 15:10:07 +0000</td>
      <td>https://twitter.com/katieornah/status/77100213...</td>
      <td>12</td>
      <td>10</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>pupper</td>
      <td>None</td>
    </tr>
    <tr>
      <th>682</th>
      <td>788552643979468800</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2016-10-19 01:29:35 +0000</td>
      <td>&lt;a href="http://twitter.com/download/iphone" r...</td>
      <td>RT @dog_rates: Say hello to mad pupper. You kn...</td>
      <td>7.363926e+17</td>
      <td>4.196984e+09</td>
      <td>2016-05-28 03:04:00 +0000</td>
      <td>https://vine.co/v/iEggaEOiLO3,https://vine.co/...</td>
      <td>13</td>
      <td>10</td>
      <td>mad</td>
      <td>None</td>
      <td>None</td>
      <td>pupper</td>
      <td>None</td>
    </tr>
    <tr>
      <th>254</th>
      <td>844580511645339650</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-03-22 16:04:20 +0000</td>
      <td>&lt;a href="http://twitter.com/download/iphone" r...</td>
      <td>This is Charlie. He wants to know if you have ...</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>https://twitter.com/dog_rates/status/844580511...</td>
      <td>11</td>
      <td>10</td>
      <td>Charlie</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
    </tr>
    <tr>
      <th>741</th>
      <td>780496263422808064</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2016-09-26 19:56:24 +0000</td>
      <td>&lt;a href="http://twitter.com/download/iphone" r...</td>
      <td>RT @dog_rates: This is Bell. She likes holding...</td>
      <td>7.424232e+17</td>
      <td>4.196984e+09</td>
      <td>2016-06-13 18:27:32 +0000</td>
      <td>https://twitter.com/dog_rates/status/742423170...</td>
      <td>12</td>
      <td>10</td>
      <td>Bell</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
    </tr>
    <tr>
      <th>143</th>
      <td>864197398364647424</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-05-15 19:14:50 +0000</td>
      <td>&lt;a href="http://twitter.com/download/iphone" r...</td>
      <td>This is Paisley. She ate a flower just to prov...</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>https://twitter.com/dog_rates/status/864197398...</td>
      <td>13</td>
      <td>10</td>
      <td>Paisley</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
    </tr>
  </tbody>
</table>
</div>




```python
find_duplicates(df_twitter_archive.tweet_id)
```




    Series([], Name: tweet_id, dtype: int64)



no duplicates in tweet id


```python
find_duplicates(df_twitter_archive.source)
```




    <a href="http://twitter.com/download/iphone" rel="nofollow">Twitter for iPhone</a>     2221
    <a href="http://vine.co" rel="nofollow">Vine - Make a Scene</a>                          91
    <a href="http://twitter.com" rel="nofollow">Twitter Web Client</a>                       33
    <a href="https://about.twitter.com/products/tweetdeck" rel="nofollow">TweetDeck</a>      11
    Name: source, dtype: int64



the anchor text in source column is repeated numerous times - good candidate for categorical object


```python
find_duplicates(df_twitter_archive.expanded_urls).head()
```




    https://twitter.com/dog_rates/status/829501995190984704/photo/1,https://twitter.com/dog_rates/status/829501995190984704/photo/1    2
    https://twitter.com/dog_rates/status/819227688460238848/photo/1                                                                    2
    https://twitter.com/dog_rates/status/683391852557561860/photo/1                                                                    2
    https://twitter.com/dog_rates/status/832369877331693569/photo/1                                                                    2
    https://twitter.com/dog_rates/status/753375668877008896/photo/1                                                                    2
    Name: expanded_urls, dtype: int64



In the expanded_url column, there some instances where the url is repeated multiple times in a cell separated by a comma
eg. https://twitter.com/dog_rates/status/791406955684368384/photo/1,https://twitter.com/dog_rates/status/791406955684368384/photo/1,https://twitter.com/dog_rates/status/791406955684368384/photo/1,https://twitter.com/dog_rates/status/791406955684368384/photo/1 -- may consider removing the repeated link after the comma 


```python
find_duplicates(df_twitter_archive.rating_numerator)
```




    12     558
    11     464
    10     461
    13     351
    9      158
    8      102
    7       55
    14      54
    5       37
    6       32
    3       19
    4       17
    1        9
    2        9
    420      2
    0        2
    15       2
    75       2
    Name: rating_numerator, dtype: int64




```python
find_duplicates(df_twitter_archive.rating_denominator)
```




    10    2333
    11       3
    50       3
    80       2
    20       2
    Name: rating_denominator, dtype: int64




```python
find_duplicates(df_twitter_archive.name).head(20)
```




    None       745
    a           55
    Charlie     12
    Lucy        11
    Oliver      11
    Cooper      11
    Penny       10
    Tucker      10
    Lola        10
    Winston      9
    Bo           9
    Sadie        8
    the          8
    Toby         7
    Bailey       7
    Buddy        7
    an           7
    Daisy        7
    Stanley      6
    Koda         6
    Name: name, dtype: int64



The name column has non name strings such as None, a, an.  
Could conside replacing non-name strings with nan.


```python
find_duplicates(df_twitter_archive.rating_numerator)
```




    12     558
    11     464
    10     461
    13     351
    9      158
    8      102
    7       55
    14      54
    5       37
    6       32
    3       19
    4       17
    1        9
    2        9
    420      2
    0        2
    15       2
    75       2
    Name: rating_numerator, dtype: int64



Interesting to note that rating number of 420 occurs twice and it seems too 'high - 420'. 
Instructions indicate that rating_numerator is almost more than 10. Also, interesting to note that there are 9 occurances of rating of 1 and 2.


```python
find_duplicates(df_twitter_archive.rating_denominator)
```




    10    2333
    11       3
    50       3
    80       2
    20       2
    Name: rating_denominator, dtype: int64



According to instructions, the denominator should be 10. But denominators as high as 80 can be observed.
May consider changing them to 10.


```python
df_twitter_archive.info()
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 2356 entries, 0 to 2355
    Data columns (total 17 columns):
    tweet_id                      2356 non-null int64
    in_reply_to_status_id         78 non-null float64
    in_reply_to_user_id           78 non-null float64
    timestamp                     2356 non-null object
    source                        2356 non-null object
    text                          2356 non-null object
    retweeted_status_id           181 non-null float64
    retweeted_status_user_id      181 non-null float64
    retweeted_status_timestamp    181 non-null object
    expanded_urls                 2297 non-null object
    rating_numerator              2356 non-null int64
    rating_denominator            2356 non-null int64
    name                          2356 non-null object
    doggo                         2356 non-null object
    floofer                       2356 non-null object
    pupper                        2356 non-null object
    puppo                         2356 non-null object
    dtypes: float64(4), int64(3), object(10)
    memory usage: 313.0+ KB
    

The table has 17 variables and 2356 observations. The table is organized by 2356 unique tweet_ids.

There is presence of missing values in in_reply_to_status_id, in_reply_to_user_id, retweeted_status_id, 
retweeted_status_user_id,retweeted_status_timestamp, expanded_urls.

The following variables should be integers instead of floats: in_reply_to_status_id,in_reply_to_user_id, retweeted_status_id,retweeted_status_user_id.  

Timestamp is a string object instead of a date time object.

retweeted_status_id count of 181 indicates that there are 181 tweets that are actually retweets and will need to be removed from the dataframe as we will be only working with original tweets and not retweets.


```python

```

# Analysing the image_predictions dataframe


```python
df_image_predictions.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>tweet_id</th>
      <th>jpg_url</th>
      <th>img_num</th>
      <th>p1</th>
      <th>p1_conf</th>
      <th>p1_dog</th>
      <th>p2</th>
      <th>p2_conf</th>
      <th>p2_dog</th>
      <th>p3</th>
      <th>p3_conf</th>
      <th>p3_dog</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>666020888022790149</td>
      <td>https://pbs.twimg.com/media/CT4udn0WwAA0aMy.jpg</td>
      <td>1</td>
      <td>Welsh_springer_spaniel</td>
      <td>0.465074</td>
      <td>True</td>
      <td>collie</td>
      <td>0.156665</td>
      <td>True</td>
      <td>Shetland_sheepdog</td>
      <td>0.061428</td>
      <td>True</td>
    </tr>
    <tr>
      <th>1</th>
      <td>666029285002620928</td>
      <td>https://pbs.twimg.com/media/CT42GRgUYAA5iDo.jpg</td>
      <td>1</td>
      <td>redbone</td>
      <td>0.506826</td>
      <td>True</td>
      <td>miniature_pinscher</td>
      <td>0.074192</td>
      <td>True</td>
      <td>Rhodesian_ridgeback</td>
      <td>0.072010</td>
      <td>True</td>
    </tr>
    <tr>
      <th>2</th>
      <td>666033412701032449</td>
      <td>https://pbs.twimg.com/media/CT4521TWwAEvMyu.jpg</td>
      <td>1</td>
      <td>German_shepherd</td>
      <td>0.596461</td>
      <td>True</td>
      <td>malinois</td>
      <td>0.138584</td>
      <td>True</td>
      <td>bloodhound</td>
      <td>0.116197</td>
      <td>True</td>
    </tr>
    <tr>
      <th>3</th>
      <td>666044226329800704</td>
      <td>https://pbs.twimg.com/media/CT5Dr8HUEAA-lEu.jpg</td>
      <td>1</td>
      <td>Rhodesian_ridgeback</td>
      <td>0.408143</td>
      <td>True</td>
      <td>redbone</td>
      <td>0.360687</td>
      <td>True</td>
      <td>miniature_pinscher</td>
      <td>0.222752</td>
      <td>True</td>
    </tr>
    <tr>
      <th>4</th>
      <td>666049248165822465</td>
      <td>https://pbs.twimg.com/media/CT5IQmsXIAAKY4A.jpg</td>
      <td>1</td>
      <td>miniature_pinscher</td>
      <td>0.560311</td>
      <td>True</td>
      <td>Rottweiler</td>
      <td>0.243682</td>
      <td>True</td>
      <td>Doberman</td>
      <td>0.154629</td>
      <td>True</td>
    </tr>
  </tbody>
</table>
</div>



p1, p2,p3: upper and lower case mixed together


```python
df_image_predictions.sample(5)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>tweet_id</th>
      <th>jpg_url</th>
      <th>img_num</th>
      <th>p1</th>
      <th>p1_conf</th>
      <th>p1_dog</th>
      <th>p2</th>
      <th>p2_conf</th>
      <th>p2_dog</th>
      <th>p3</th>
      <th>p3_conf</th>
      <th>p3_dog</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>892</th>
      <td>699413908797464576</td>
      <td>https://pbs.twimg.com/media/CbTRPXdW8AQMZf7.jpg</td>
      <td>1</td>
      <td>Samoyed</td>
      <td>0.517479</td>
      <td>True</td>
      <td>malamute</td>
      <td>0.155935</td>
      <td>True</td>
      <td>Eskimo_dog</td>
      <td>0.095001</td>
      <td>True</td>
    </tr>
    <tr>
      <th>1967</th>
      <td>867900495410671616</td>
      <td>https://pbs.twimg.com/media/DAtm5MkXoAA4R6P.jpg</td>
      <td>1</td>
      <td>Labrador_retriever</td>
      <td>0.522644</td>
      <td>True</td>
      <td>kuvasz</td>
      <td>0.332461</td>
      <td>True</td>
      <td>dalmatian</td>
      <td>0.032008</td>
      <td>True</td>
    </tr>
    <tr>
      <th>1397</th>
      <td>768193404517830656</td>
      <td>https://pbs.twimg.com/media/Cqkr0wiW8AAn2Oi.jpg</td>
      <td>1</td>
      <td>lion</td>
      <td>0.396984</td>
      <td>False</td>
      <td>ram</td>
      <td>0.300851</td>
      <td>False</td>
      <td>cheetah</td>
      <td>0.094474</td>
      <td>False</td>
    </tr>
    <tr>
      <th>771</th>
      <td>689517482558820352</td>
      <td>https://pbs.twimg.com/media/CZGofjJW0AINjN9.jpg</td>
      <td>1</td>
      <td>Pembroke</td>
      <td>0.799319</td>
      <td>True</td>
      <td>Cardigan</td>
      <td>0.189537</td>
      <td>True</td>
      <td>papillon</td>
      <td>0.003386</td>
      <td>True</td>
    </tr>
    <tr>
      <th>919</th>
      <td>701889187134500865</td>
      <td>https://pbs.twimg.com/media/Cb2cfd9WAAEL-zk.jpg</td>
      <td>1</td>
      <td>French_bulldog</td>
      <td>0.902856</td>
      <td>True</td>
      <td>Staffordshire_bullterrier</td>
      <td>0.022634</td>
      <td>True</td>
      <td>soap_dispenser</td>
      <td>0.011973</td>
      <td>False</td>
    </tr>
  </tbody>
</table>
</div>



p1, p2,p3: dash and underscore mixed in string eg. black-and-tan_coonhound	


```python
df_image_predictions.info()
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 2075 entries, 0 to 2074
    Data columns (total 12 columns):
    tweet_id    2075 non-null int64
    jpg_url     2075 non-null object
    img_num     2075 non-null int64
    p1          2075 non-null object
    p1_conf     2075 non-null float64
    p1_dog      2075 non-null bool
    p2          2075 non-null object
    p2_conf     2075 non-null float64
    p2_dog      2075 non-null bool
    p3          2075 non-null object
    p3_conf     2075 non-null float64
    p3_dog      2075 non-null bool
    dtypes: bool(3), float64(3), int64(2), object(4)
    memory usage: 152.1+ KB
    

No missing values in this dataset.

This dataset should be merged with the archived dataset based on the tweet ids becuase this dataset is predicting the images of the tweet ids. In that case, this dataset will have missing values as the archive dataset has 2355 observations and this dataset
has 2075 instances.


```python
find_duplicates(df_image_predictions.tweet_id)
```




    Series([], Name: tweet_id, dtype: int64)



no duplicates in tweet id


```python
find_duplicates(df_image_predictions.jpg_url).head()
```




    https://pbs.twimg.com/ext_tw_video_thumb/675354114423808004/pu/img/qL1R_nGLqa6lmkOx.jpg    2
    https://pbs.twimg.com/media/DA7iHL5U0AA1OQo.jpg                                            2
    https://pbs.twimg.com/media/CYLDikFWEAAIy1y.jpg                                            2
    https://pbs.twimg.com/media/CzG425nWgAAnP7P.jpg                                            2
    https://pbs.twimg.com/media/CkjMx99UoAM2B1a.jpg                                            2
    Name: jpg_url, dtype: int64



numerous urls are repeated in the jpg_url column - this could or could not be an issue in future


```python

```

# Analysing the tweet_json dataframe


```python
df_json_tweets.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>tweet_id</th>
      <th>time_created</th>
      <th>full_text</th>
      <th>favorite_count</th>
      <th>retweet_count</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>892420643555336193</td>
      <td>Tue Aug 01 16:23:56 +0000 2017</td>
      <td>This is Phineas. He's a mystical boy. Only eve...</td>
      <td>38492</td>
      <td>8480</td>
    </tr>
    <tr>
      <th>1</th>
      <td>892177421306343426</td>
      <td>Tue Aug 01 00:17:27 +0000 2017</td>
      <td>This is Tilly. She's just checking pup on you....</td>
      <td>32986</td>
      <td>6241</td>
    </tr>
    <tr>
      <th>2</th>
      <td>891815181378084864</td>
      <td>Mon Jul 31 00:18:03 +0000 2017</td>
      <td>This is Archie. He is a rare Norwegian Pouncin...</td>
      <td>24840</td>
      <td>4137</td>
    </tr>
    <tr>
      <th>3</th>
      <td>891689557279858688</td>
      <td>Sun Jul 30 15:58:51 +0000 2017</td>
      <td>This is Darla. She commenced a snooze mid meal...</td>
      <td>41865</td>
      <td>8598</td>
    </tr>
    <tr>
      <th>4</th>
      <td>891327558926688256</td>
      <td>Sat Jul 29 16:00:24 +0000 2017</td>
      <td>This is Franklin. He would like you to stop ca...</td>
      <td>40029</td>
      <td>9336</td>
    </tr>
  </tbody>
</table>
</div>



time_created could be further split into day, month and time.


```python
df_json_tweets.sample(5)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>tweet_id</th>
      <th>time_created</th>
      <th>full_text</th>
      <th>favorite_count</th>
      <th>retweet_count</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2069</th>
      <td>670811965569282048</td>
      <td>Sun Nov 29 03:50:10 +0000 2015</td>
      <td>Meet Maggie. She enjoys her stick in the yard....</td>
      <td>1162</td>
      <td>281</td>
    </tr>
    <tr>
      <th>2227</th>
      <td>667915453470232577</td>
      <td>Sat Nov 21 04:00:28 +0000 2015</td>
      <td>Meet Otis. He is a Peruvian Quartzite. Pic spo...</td>
      <td>216</td>
      <td>58</td>
    </tr>
    <tr>
      <th>1886</th>
      <td>674664755118911488</td>
      <td>Wed Dec 09 18:59:46 +0000 2015</td>
      <td>This is Rodman. He's getting destroyed by the ...</td>
      <td>957</td>
      <td>270</td>
    </tr>
    <tr>
      <th>1339</th>
      <td>703769065844768768</td>
      <td>Sun Feb 28 02:29:55 +0000 2016</td>
      <td>When you're trying to watch your favorite tv s...</td>
      <td>3494</td>
      <td>1231</td>
    </tr>
    <tr>
      <th>1974</th>
      <td>672834301050937345</td>
      <td>Fri Dec 04 17:46:12 +0000 2015</td>
      <td>This is Ed. He's not mad, just disappointed. 1...</td>
      <td>1352</td>
      <td>595</td>
    </tr>
  </tbody>
</table>
</div>




```python
df_json_tweets.describe()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>tweet_id</th>
      <th>favorite_count</th>
      <th>retweet_count</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>2.342000e+03</td>
      <td>2342.000000</td>
      <td>2342.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>7.422646e+17</td>
      <td>8042.367635</td>
      <td>2980.833049</td>
    </tr>
    <tr>
      <th>std</th>
      <td>6.837466e+16</td>
      <td>12364.650672</td>
      <td>4990.628083</td>
    </tr>
    <tr>
      <th>min</th>
      <td>6.660209e+17</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>6.783509e+17</td>
      <td>1394.250000</td>
      <td>599.250000</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>7.186224e+17</td>
      <td>3509.000000</td>
      <td>1395.000000</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>7.987010e+17</td>
      <td>9881.750000</td>
      <td>3478.000000</td>
    </tr>
    <tr>
      <th>max</th>
      <td>8.924206e+17</td>
      <td>162143.000000</td>
      <td>84152.000000</td>
    </tr>
  </tbody>
</table>
</div>



There is a tweet that got 142,306 favorite counts and 76,667 retweet counts. It would be nice to investigate this further in visuals to see if it is the same tweet. Also what days do most tweets occur?


```python
find_duplicates(df_json_tweets.tweet_id)
```




    Series([], Name: tweet_id, dtype: int64)



tweet_id is not duplicated.


```python
df_json_tweets.info()
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 2342 entries, 0 to 2341
    Data columns (total 5 columns):
    tweet_id          2342 non-null int64
    time_created      2342 non-null object
    full_text         2342 non-null object
    favorite_count    2342 non-null int64
    retweet_count     2342 non-null int64
    dtypes: int64(3), object(2)
    memory usage: 91.6+ KB
    

Since this dataframe's tweet id is based on the tweet id of the twitter_archive dataframe's tweet id, we can merge both these
tables into one table and add the favorite_count annd retweet_count from json_tweets dataframe to twitter_archive dataframe.


```python

```

<a id='C'></a>
[Top](#Top)
# C. Data Cleaning 
(Define, code, test )
- code and test are addressed separately for each issue.

### Define - Content Issues
#### Cleaning the twitter_archive dataframe 

1. Format the timestamp to datetime format
2. Add columns for the month, weekday and hour the tweet was created
3. Remove all retweets
4. Convert source to categorical value
5. Remove same multiple urls in expanded_urls variable 
6. Change the rating denominator to 10
7. Remove non name characters from the name variable
8. Only keep necessary columns

#### Cleaning image_predictions table
1. Drop img_num variable

#### Cleaning json tweets table
1. Drop full_text and time_created variables

### Define - Structural Issues
1. Merge cleaned twitter archive table with cleaned image predictions table to create a df_main table
2. Merge the df_main table with cleaned json tweets table
3. For df_main dataframe, merge  'doggo','floofer','pupper','puppo' variables into one column 

## Cleaning the twitter_archive dataframe 


```python
# make a copy of the twitter_archive dataframe
df_twitter_archive_clean=df_twitter_archive.copy()
```


```python
# 1. Format the timestamp to datetime format

#### code
# remove the +0000 from timestamp
df_twitter_archive_clean.timestamp=df_twitter_archive_clean.timestamp.str[:-6]

# convert the whole column proper date format using the datetime function
df_twitter_archive_clean['timestamp'] =  pd.to_datetime(df_twitter_archive_clean['timestamp'], format='%Y-%m-%d %X')

#### test
df_twitter_archive_clean.info()
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 2356 entries, 0 to 2355
    Data columns (total 17 columns):
    tweet_id                      2356 non-null int64
    in_reply_to_status_id         78 non-null float64
    in_reply_to_user_id           78 non-null float64
    timestamp                     2356 non-null datetime64[ns]
    source                        2356 non-null object
    text                          2356 non-null object
    retweeted_status_id           181 non-null float64
    retweeted_status_user_id      181 non-null float64
    retweeted_status_timestamp    181 non-null object
    expanded_urls                 2297 non-null object
    rating_numerator              2356 non-null int64
    rating_denominator            2356 non-null int64
    name                          2356 non-null object
    doggo                         2356 non-null object
    floofer                       2356 non-null object
    pupper                        2356 non-null object
    puppo                         2356 non-null object
    dtypes: datetime64[ns](1), float64(4), int64(3), object(9)
    memory usage: 313.0+ KB
    


```python
# 2. Add columns for the month, weekday and hour the tweet was created

#### code
#df_twitter_clean.timestamp[0].hour
df_twitter_archive_clean['timestamp_month']=df_twitter_archive_clean.timestamp.map(lambda a: a.month)
df_twitter_archive_clean['timestamp_weekday']=df_twitter_archive_clean.timestamp.map(lambda a: a.weekday())
df_twitter_archive_clean['timestamp_hour']=df_twitter_archive_clean.timestamp.map(lambda a: a.hour)

#### test
df_twitter_archive_clean.head(2)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>tweet_id</th>
      <th>in_reply_to_status_id</th>
      <th>in_reply_to_user_id</th>
      <th>timestamp</th>
      <th>source</th>
      <th>text</th>
      <th>retweeted_status_id</th>
      <th>retweeted_status_user_id</th>
      <th>retweeted_status_timestamp</th>
      <th>expanded_urls</th>
      <th>rating_numerator</th>
      <th>rating_denominator</th>
      <th>name</th>
      <th>doggo</th>
      <th>floofer</th>
      <th>pupper</th>
      <th>puppo</th>
      <th>timestamp_month</th>
      <th>timestamp_weekday</th>
      <th>timestamp_hour</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>892420643555336193</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-08-01 16:23:56</td>
      <td>&lt;a href="http://twitter.com/download/iphone" r...</td>
      <td>This is Phineas. He's a mystical boy. Only eve...</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>https://twitter.com/dog_rates/status/892420643...</td>
      <td>13</td>
      <td>10</td>
      <td>Phineas</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>8</td>
      <td>1</td>
      <td>16</td>
    </tr>
    <tr>
      <th>1</th>
      <td>892177421306343426</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-08-01 00:17:27</td>
      <td>&lt;a href="http://twitter.com/download/iphone" r...</td>
      <td>This is Tilly. She's just checking pup on you....</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>https://twitter.com/dog_rates/status/892177421...</td>
      <td>13</td>
      <td>10</td>
      <td>Tilly</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>8</td>
      <td>1</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div>




```python
# 3. Remove all retweets
# retweeted_status_id contains id of retweets so remove all retweets and only keep NaN

#### code
# df_twitter_clean.retweeted_status_id
index_original_tweet=pd.isnull(df_twitter_archive_clean['retweeted_status_id'])
df_twitter_archive_clean=df_twitter_archive_clean[index_original_tweet]

#### test
df_twitter_archive_clean.retweeted_status_id.value_counts() # shows no values
```




    Series([], Name: retweeted_status_id, dtype: int64)




```python
# 4. Convert source to categorical value

#### code
#view the value counts
print(df_twitter_archive_clean.source.value_counts())


# create a dictionary for mapping
di_source = {'<a href="http://twitter.com/download/iphone" rel="nofollow">Twitter for iPhone</a>':'Twitter for iPhone',
            '<a href="http://vine.co" rel="nofollow">Vine - Make a Scene</a>':'Vine - Make a Scene',
            '<a href="http://twitter.com" rel="nofollow">Twitter Web Client</a>':'Twitter Web Client',
            '<a href="https://about.twitter.com/products/tweetdeck" rel="nofollow">TweetDeck</a>':'TweetDeck'}

# map the dictionary 
df_twitter_archive_clean['source']=df_twitter_archive_clean['source'].replace(di_source)

print('\n\n')
print(df_twitter_archive_clean['source'].value_counts())
print('\n\n')

# convert the source variable to a categorical object
df_twitter_archive_clean['source']=df_twitter_archive_clean['source'].astype('category')

#### test 
# .info() hows that source variable is now sa category 
print(df_twitter_archive_clean.info())
```

    <a href="http://twitter.com/download/iphone" rel="nofollow">Twitter for iPhone</a>     2042
    <a href="http://vine.co" rel="nofollow">Vine - Make a Scene</a>                          91
    <a href="http://twitter.com" rel="nofollow">Twitter Web Client</a>                       31
    <a href="https://about.twitter.com/products/tweetdeck" rel="nofollow">TweetDeck</a>      11
    Name: source, dtype: int64
    
    
    
    Twitter for iPhone     2042
    Vine - Make a Scene      91
    Twitter Web Client       31
    TweetDeck                11
    Name: source, dtype: int64
    
    
    
    <class 'pandas.core.frame.DataFrame'>
    Int64Index: 2175 entries, 0 to 2355
    Data columns (total 20 columns):
    tweet_id                      2175 non-null int64
    in_reply_to_status_id         78 non-null float64
    in_reply_to_user_id           78 non-null float64
    timestamp                     2175 non-null datetime64[ns]
    source                        2175 non-null category
    text                          2175 non-null object
    retweeted_status_id           0 non-null float64
    retweeted_status_user_id      0 non-null float64
    retweeted_status_timestamp    0 non-null object
    expanded_urls                 2117 non-null object
    rating_numerator              2175 non-null int64
    rating_denominator            2175 non-null int64
    name                          2175 non-null object
    doggo                         2175 non-null object
    floofer                       2175 non-null object
    pupper                        2175 non-null object
    puppo                         2175 non-null object
    timestamp_month               2175 non-null int64
    timestamp_weekday             2175 non-null int64
    timestamp_hour                2175 non-null int64
    dtypes: category(1), datetime64[ns](1), float64(4), int64(6), object(8)
    memory usage: 342.2+ KB
    None
    


```python
# 5. Remove same multiple urls in expanded_urls variable 

#### code
# first print the urls to screen
df_twitter_archive_clean.expanded_urls.head(10).map(lambda a : print(a))
```

    https://twitter.com/dog_rates/status/892420643555336193/photo/1
    https://twitter.com/dog_rates/status/892177421306343426/photo/1
    https://twitter.com/dog_rates/status/891815181378084864/photo/1
    https://twitter.com/dog_rates/status/891689557279858688/photo/1
    https://twitter.com/dog_rates/status/891327558926688256/photo/1,https://twitter.com/dog_rates/status/891327558926688256/photo/1
    https://twitter.com/dog_rates/status/891087950875897856/photo/1
    https://gofundme.com/ydvmve-surgery-for-jax,https://twitter.com/dog_rates/status/890971913173991426/photo/1
    https://twitter.com/dog_rates/status/890729181411237888/photo/1,https://twitter.com/dog_rates/status/890729181411237888/photo/1
    https://twitter.com/dog_rates/status/890609185150312448/photo/1
    https://twitter.com/dog_rates/status/890240255349198849/photo/1
    




    0    None
    1    None
    2    None
    3    None
    4    None
    5    None
    6    None
    7    None
    8    None
    9    None
    Name: expanded_urls, dtype: object




```python
#### code continued..
# use the str.split function to split on comma and save the first column
tmp=df_twitter_archive_clean.expanded_urls.str.split(',', expand=True)[0]
#tmp.map(lambda a : print(a))


#### test 
# print the formatted urp to screen for a visual confirmation
df_twitter_archive_clean.expanded_urls=tmp.copy()
df_twitter_archive_clean.expanded_urls.head(10).map(lambda a : print(a))
```

    https://twitter.com/dog_rates/status/892420643555336193/photo/1
    https://twitter.com/dog_rates/status/892177421306343426/photo/1
    https://twitter.com/dog_rates/status/891815181378084864/photo/1
    https://twitter.com/dog_rates/status/891689557279858688/photo/1
    https://twitter.com/dog_rates/status/891327558926688256/photo/1
    https://twitter.com/dog_rates/status/891087950875897856/photo/1
    https://gofundme.com/ydvmve-surgery-for-jax
    https://twitter.com/dog_rates/status/890729181411237888/photo/1
    https://twitter.com/dog_rates/status/890609185150312448/photo/1
    https://twitter.com/dog_rates/status/890240255349198849/photo/1
    




    0    None
    1    None
    2    None
    3    None
    4    None
    5    None
    6    None
    7    None
    8    None
    9    None
    Name: expanded_urls, dtype: object




```python
# 6. Change the rating denominator to 10

#### code
print(df_twitter_archive_clean.rating_denominator.value_counts())
df_twitter_archive_clean.rating_denominator=10

#### test
print('\n\n')
print(df_twitter_archive_clean.rating_denominator.value_counts())

```

    10     2153
    50        3
    80        2
    11        2
    20        2
    2         1
    16        1
    40        1
    70        1
    15        1
    90        1
    110       1
    120       1
    130       1
    150       1
    170       1
    7         1
    0         1
    Name: rating_denominator, dtype: int64
    
    
    
    10    2175
    Name: rating_denominator, dtype: int64
    


```python
# 7. Remove non name characters from the name variable
# Replace the non name strings 'None','a', 'an' with Nan

#### code
print(df_twitter_archive_clean.name.value_counts()) # shows there is None,a,an in name value 
```

    None         680
    a             55
    Charlie       11
    Lucy          11
    Cooper        10
    Oliver        10
    Penny          9
    Tucker         9
    Sadie          8
    the            8
    Winston        8
    Lola           8
    Daisy          7
    Toby           7
    Bailey         6
    Jax            6
    Bo             6
    Koda           6
    Stanley        6
    Bella          6
    Oscar          6
    an             6
    Dave           5
    Milo           5
    Bentley        5
    Rusty          5
    Buddy          5
    Louis          5
    Chester        5
    Leo            5
                ... 
    Levi           1
    Aubie          1
    Asher          1
    Shnuggles      1
    Amber          1
    Astrid         1
    Beemo          1
    Aldrick        1
    Julio          1
    Laika          1
    Chef           1
    Sandra         1
    Eve            1
    Newt           1
    Zeek           1
    Filup          1
    Hubertson      1
    Sierra         1
    Alf            1
    Skittle        1
    Charleson      1
    Tedrick        1
    Steve          1
    Hanz           1
    Akumi          1
    Wafer          1
    Happy          1
    Angel          1
    Benny          1
    such           1
    Name: name, Length: 956, dtype: int64
    


```python
#### code continued ...
# Try using Regex for a one liner
#Replace 'None' with Nan
df_twitter_archive_clean['name']=df_twitter_archive_clean['name'].replace('None', np.NaN, )
# Replace 'a' with Nan
df_twitter_archive_clean['name']=df_twitter_archive_clean['name'].replace('a', np.NaN, )
# Replace 'an' with Nan
df_twitter_archive_clean['name']=df_twitter_archive_clean['name'].replace('an', np.NaN, )

#### test
print(df_twitter_archive_clean['name'].value_counts())
# output shows no occurance of None, a, an
```

    Lucy         11
    Charlie      11
    Cooper       10
    Oliver       10
    Tucker        9
    Penny         9
    Winston       8
    Lola          8
    Sadie         8
    the           8
    Daisy         7
    Toby          7
    Jax           6
    Koda          6
    Bella         6
    Oscar         6
    Bailey        6
    Bo            6
    Stanley       6
    Rusty         5
    Chester       5
    Buddy         5
    Scout         5
    Leo           5
    Louis         5
    Milo          5
    Bentley       5
    Dave          5
    Jack          4
    Archie        4
                 ..
    Mimosa        1
    Levi          1
    Aubie         1
    Asher         1
    Aldrick       1
    Benny         1
    Angel         1
    Happy         1
    Diogi         1
    Trigger       1
    Antony        1
    Julio         1
    Laika         1
    Chef          1
    Sandra        1
    Eve           1
    Newt          1
    Zeek          1
    Filup         1
    Hubertson     1
    Sierra        1
    Alf           1
    Skittle       1
    Charleson     1
    Tedrick       1
    Steve         1
    Hanz          1
    Akumi         1
    Wafer         1
    such          1
    Name: name, Length: 953, dtype: int64
    


```python
# 8. Only keep necessary columns
# Drop the following columns : 'in_reply_to_status_id', 'in_reply_to_user_id', 'retweeted_status_id', 
#                              'retweeted_status_user_id','retweeted_status_timestamp'

#### code
print(df_twitter_archive_clean.columns)

drop_columns = ['in_reply_to_status_id', 'in_reply_to_user_id', 'retweeted_status_id', 
                'retweeted_status_user_id','retweeted_status_timestamp']

df_twitter_archive_clean=df_twitter_archive_clean.drop(drop_columns, axis=1)  # df.columns is zero-based pd.Index 

#### test
df_twitter_archive_clean.head()
```

    Index(['tweet_id', 'in_reply_to_status_id', 'in_reply_to_user_id', 'timestamp',
           'source', 'text', 'retweeted_status_id', 'retweeted_status_user_id',
           'retweeted_status_timestamp', 'expanded_urls', 'rating_numerator',
           'rating_denominator', 'name', 'doggo', 'floofer', 'pupper', 'puppo',
           'timestamp_month', 'timestamp_weekday', 'timestamp_hour'],
          dtype='object')
    




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>tweet_id</th>
      <th>timestamp</th>
      <th>source</th>
      <th>text</th>
      <th>expanded_urls</th>
      <th>rating_numerator</th>
      <th>rating_denominator</th>
      <th>name</th>
      <th>doggo</th>
      <th>floofer</th>
      <th>pupper</th>
      <th>puppo</th>
      <th>timestamp_month</th>
      <th>timestamp_weekday</th>
      <th>timestamp_hour</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>892420643555336193</td>
      <td>2017-08-01 16:23:56</td>
      <td>Twitter for iPhone</td>
      <td>This is Phineas. He's a mystical boy. Only eve...</td>
      <td>https://twitter.com/dog_rates/status/892420643...</td>
      <td>13</td>
      <td>10</td>
      <td>Phineas</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>8</td>
      <td>1</td>
      <td>16</td>
    </tr>
    <tr>
      <th>1</th>
      <td>892177421306343426</td>
      <td>2017-08-01 00:17:27</td>
      <td>Twitter for iPhone</td>
      <td>This is Tilly. She's just checking pup on you....</td>
      <td>https://twitter.com/dog_rates/status/892177421...</td>
      <td>13</td>
      <td>10</td>
      <td>Tilly</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>8</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>891815181378084864</td>
      <td>2017-07-31 00:18:03</td>
      <td>Twitter for iPhone</td>
      <td>This is Archie. He is a rare Norwegian Pouncin...</td>
      <td>https://twitter.com/dog_rates/status/891815181...</td>
      <td>12</td>
      <td>10</td>
      <td>Archie</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>7</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>891689557279858688</td>
      <td>2017-07-30 15:58:51</td>
      <td>Twitter for iPhone</td>
      <td>This is Darla. She commenced a snooze mid meal...</td>
      <td>https://twitter.com/dog_rates/status/891689557...</td>
      <td>13</td>
      <td>10</td>
      <td>Darla</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>7</td>
      <td>6</td>
      <td>15</td>
    </tr>
    <tr>
      <th>4</th>
      <td>891327558926688256</td>
      <td>2017-07-29 16:00:24</td>
      <td>Twitter for iPhone</td>
      <td>This is Franklin. He would like you to stop ca...</td>
      <td>https://twitter.com/dog_rates/status/891327558...</td>
      <td>12</td>
      <td>10</td>
      <td>Franklin</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>7</td>
      <td>5</td>
      <td>16</td>
    </tr>
  </tbody>
</table>
</div>



# Clean image_predictions table


```python
# 1. Drop img_num variable

#### code
df_image_predictions_clean=df_image_predictions.copy()
#df_image_predictions_clean.head()
df_image_predictions_clean=df_image_predictions_clean.drop('img_num',axis=1)

#### test
df_image_predictions_clean.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>tweet_id</th>
      <th>jpg_url</th>
      <th>p1</th>
      <th>p1_conf</th>
      <th>p1_dog</th>
      <th>p2</th>
      <th>p2_conf</th>
      <th>p2_dog</th>
      <th>p3</th>
      <th>p3_conf</th>
      <th>p3_dog</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>666020888022790149</td>
      <td>https://pbs.twimg.com/media/CT4udn0WwAA0aMy.jpg</td>
      <td>Welsh_springer_spaniel</td>
      <td>0.465074</td>
      <td>True</td>
      <td>collie</td>
      <td>0.156665</td>
      <td>True</td>
      <td>Shetland_sheepdog</td>
      <td>0.061428</td>
      <td>True</td>
    </tr>
    <tr>
      <th>1</th>
      <td>666029285002620928</td>
      <td>https://pbs.twimg.com/media/CT42GRgUYAA5iDo.jpg</td>
      <td>redbone</td>
      <td>0.506826</td>
      <td>True</td>
      <td>miniature_pinscher</td>
      <td>0.074192</td>
      <td>True</td>
      <td>Rhodesian_ridgeback</td>
      <td>0.072010</td>
      <td>True</td>
    </tr>
    <tr>
      <th>2</th>
      <td>666033412701032449</td>
      <td>https://pbs.twimg.com/media/CT4521TWwAEvMyu.jpg</td>
      <td>German_shepherd</td>
      <td>0.596461</td>
      <td>True</td>
      <td>malinois</td>
      <td>0.138584</td>
      <td>True</td>
      <td>bloodhound</td>
      <td>0.116197</td>
      <td>True</td>
    </tr>
    <tr>
      <th>3</th>
      <td>666044226329800704</td>
      <td>https://pbs.twimg.com/media/CT5Dr8HUEAA-lEu.jpg</td>
      <td>Rhodesian_ridgeback</td>
      <td>0.408143</td>
      <td>True</td>
      <td>redbone</td>
      <td>0.360687</td>
      <td>True</td>
      <td>miniature_pinscher</td>
      <td>0.222752</td>
      <td>True</td>
    </tr>
    <tr>
      <th>4</th>
      <td>666049248165822465</td>
      <td>https://pbs.twimg.com/media/CT5IQmsXIAAKY4A.jpg</td>
      <td>miniature_pinscher</td>
      <td>0.560311</td>
      <td>True</td>
      <td>Rottweiler</td>
      <td>0.243682</td>
      <td>True</td>
      <td>Doberman</td>
      <td>0.154629</td>
      <td>True</td>
    </tr>
  </tbody>
</table>
</div>



# Clean json tweets table


```python
# 1. Drop full_text and time_created variables

#### code
df_json_tweets_cleaned=df_json_tweets.copy()
drop_columns=['full_text','time_created']
df_json_tweets_cleaned=df_json_tweets_cleaned.drop(drop_columns,axis=1)

#### test
df_json_tweets_cleaned.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>tweet_id</th>
      <th>favorite_count</th>
      <th>retweet_count</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>892420643555336193</td>
      <td>38492</td>
      <td>8480</td>
    </tr>
    <tr>
      <th>1</th>
      <td>892177421306343426</td>
      <td>32986</td>
      <td>6241</td>
    </tr>
    <tr>
      <th>2</th>
      <td>891815181378084864</td>
      <td>24840</td>
      <td>4137</td>
    </tr>
    <tr>
      <th>3</th>
      <td>891689557279858688</td>
      <td>41865</td>
      <td>8598</td>
    </tr>
    <tr>
      <th>4</th>
      <td>891327558926688256</td>
      <td>40029</td>
      <td>9336</td>
    </tr>
  </tbody>
</table>
</div>



# Structural Issue 1: Merge cleaned twitter archive table with cleaned image predictions table to create a df_main table


```python
# Structural Issue 1: Merge cleaned twitter archive table with cleaned image predictions table to create a df_main table

#### code
df_main=pd.merge(df_twitter_archive_clean,df_image_predictions_clean, on='tweet_id', how='left')

#### test
df_main.head(2)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>tweet_id</th>
      <th>timestamp</th>
      <th>source</th>
      <th>text</th>
      <th>expanded_urls</th>
      <th>rating_numerator</th>
      <th>rating_denominator</th>
      <th>name</th>
      <th>doggo</th>
      <th>floofer</th>
      <th>...</th>
      <th>jpg_url</th>
      <th>p1</th>
      <th>p1_conf</th>
      <th>p1_dog</th>
      <th>p2</th>
      <th>p2_conf</th>
      <th>p2_dog</th>
      <th>p3</th>
      <th>p3_conf</th>
      <th>p3_dog</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>892420643555336193</td>
      <td>2017-08-01 16:23:56</td>
      <td>Twitter for iPhone</td>
      <td>This is Phineas. He's a mystical boy. Only eve...</td>
      <td>https://twitter.com/dog_rates/status/892420643...</td>
      <td>13</td>
      <td>10</td>
      <td>Phineas</td>
      <td>None</td>
      <td>None</td>
      <td>...</td>
      <td>https://pbs.twimg.com/media/DGKD1-bXoAAIAUK.jpg</td>
      <td>orange</td>
      <td>0.097049</td>
      <td>False</td>
      <td>bagel</td>
      <td>0.085851</td>
      <td>False</td>
      <td>banana</td>
      <td>0.076110</td>
      <td>False</td>
    </tr>
    <tr>
      <th>1</th>
      <td>892177421306343426</td>
      <td>2017-08-01 00:17:27</td>
      <td>Twitter for iPhone</td>
      <td>This is Tilly. She's just checking pup on you....</td>
      <td>https://twitter.com/dog_rates/status/892177421...</td>
      <td>13</td>
      <td>10</td>
      <td>Tilly</td>
      <td>None</td>
      <td>None</td>
      <td>...</td>
      <td>https://pbs.twimg.com/media/DGGmoV4XsAAUL6n.jpg</td>
      <td>Chihuahua</td>
      <td>0.323581</td>
      <td>True</td>
      <td>Pekinese</td>
      <td>0.090647</td>
      <td>True</td>
      <td>papillon</td>
      <td>0.068957</td>
      <td>True</td>
    </tr>
  </tbody>
</table>
<p>2 rows × 25 columns</p>
</div>



# Structural Issue 2: Merge the df_main table with cleaned json tweets table


```python
# Structural Issue 2: Merge the df_main table with cleaned json tweets table

#### code
df_main=pd.merge(df_main,df_json_tweets_cleaned,on='tweet_id', how='left')

#### test
df_main.info()
```

    <class 'pandas.core.frame.DataFrame'>
    Int64Index: 2175 entries, 0 to 2174
    Data columns (total 27 columns):
    tweet_id              2175 non-null int64
    timestamp             2175 non-null datetime64[ns]
    source                2175 non-null category
    text                  2175 non-null object
    expanded_urls         2117 non-null object
    rating_numerator      2175 non-null int64
    rating_denominator    2175 non-null int64
    name                  1434 non-null object
    doggo                 2175 non-null object
    floofer               2175 non-null object
    pupper                2175 non-null object
    puppo                 2175 non-null object
    timestamp_month       2175 non-null int64
    timestamp_weekday     2175 non-null int64
    timestamp_hour        2175 non-null int64
    jpg_url               1994 non-null object
    p1                    1994 non-null object
    p1_conf               1994 non-null float64
    p1_dog                1994 non-null object
    p2                    1994 non-null object
    p2_conf               1994 non-null float64
    p2_dog                1994 non-null object
    p3                    1994 non-null object
    p3_conf               1994 non-null float64
    p3_dog                1994 non-null object
    favorite_count        2174 non-null float64
    retweet_count         2174 non-null float64
    dtypes: category(1), datetime64[ns](1), float64(5), int64(6), object(14)
    memory usage: 461.1+ KB
    


```python

```

# Structural Issue 3: For df_main dataframe, merge  'doggo','floofer','pupper','puppo' variables into one column 


```python
# Structural Issue 3: melt variables 'doggo','floofer','pupper','puppo' into one column

#### code
# copy the variables to a tmp dataframe
tmp=df_main[['tweet_id','doggo','floofer','pupper','puppo']].copy()

# melt the variables
tmp=pd.melt(tmp,id_vars=['tweet_id'], value_vars=['doggo','floofer','pupper','puppo'],value_name='growth_stage')

# drop the column called variable
tmp=tmp.drop('variable', axis=1)

# replace the None with NaN in growth_stage column
tmp['growth_stage']=tmp['growth_stage'].replace('None', np.NaN, )

#drop rows containing na's because there are too many rows with na's
tmp=tmp.dropna()

tmp.growth_stage.value_counts()
```




    pupper     234
    doggo       87
    puppo       25
    floofer     10
    Name: growth_stage, dtype: int64




```python
#### code continued ...
# remove the following variables ('tweet_id','doggo','floofer','pupper','puppo') from the df_main table
drop_columns = ['doggo','floofer','pupper','puppo']
df_main = df_main.drop(drop_columns,axis=1)

# merge df_main with the tmp dataframe containing the growth_stage column
df_main=pd.merge(df_main,tmp,on='tweet_id', how='left')

df_main.head(2)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>tweet_id</th>
      <th>timestamp</th>
      <th>source</th>
      <th>text</th>
      <th>expanded_urls</th>
      <th>rating_numerator</th>
      <th>rating_denominator</th>
      <th>name</th>
      <th>timestamp_month</th>
      <th>timestamp_weekday</th>
      <th>...</th>
      <th>p1_dog</th>
      <th>p2</th>
      <th>p2_conf</th>
      <th>p2_dog</th>
      <th>p3</th>
      <th>p3_conf</th>
      <th>p3_dog</th>
      <th>favorite_count</th>
      <th>retweet_count</th>
      <th>growth_stage</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>892420643555336193</td>
      <td>2017-08-01 16:23:56</td>
      <td>Twitter for iPhone</td>
      <td>This is Phineas. He's a mystical boy. Only eve...</td>
      <td>https://twitter.com/dog_rates/status/892420643...</td>
      <td>13</td>
      <td>10</td>
      <td>Phineas</td>
      <td>8</td>
      <td>1</td>
      <td>...</td>
      <td>False</td>
      <td>bagel</td>
      <td>0.085851</td>
      <td>False</td>
      <td>banana</td>
      <td>0.076110</td>
      <td>False</td>
      <td>38492.0</td>
      <td>8480.0</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>1</th>
      <td>892177421306343426</td>
      <td>2017-08-01 00:17:27</td>
      <td>Twitter for iPhone</td>
      <td>This is Tilly. She's just checking pup on you....</td>
      <td>https://twitter.com/dog_rates/status/892177421...</td>
      <td>13</td>
      <td>10</td>
      <td>Tilly</td>
      <td>8</td>
      <td>1</td>
      <td>...</td>
      <td>True</td>
      <td>Pekinese</td>
      <td>0.090647</td>
      <td>True</td>
      <td>papillon</td>
      <td>0.068957</td>
      <td>True</td>
      <td>32986.0</td>
      <td>6241.0</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
<p>2 rows × 24 columns</p>
</div>




```python
#### test
df_main.info()
```

    <class 'pandas.core.frame.DataFrame'>
    Int64Index: 2187 entries, 0 to 2186
    Data columns (total 24 columns):
    tweet_id              2187 non-null int64
    timestamp             2187 non-null datetime64[ns]
    source                2187 non-null category
    text                  2187 non-null object
    expanded_urls         2129 non-null object
    rating_numerator      2187 non-null int64
    rating_denominator    2187 non-null int64
    name                  1439 non-null object
    timestamp_month       2187 non-null int64
    timestamp_weekday     2187 non-null int64
    timestamp_hour        2187 non-null int64
    jpg_url               2005 non-null object
    p1                    2005 non-null object
    p1_conf               2005 non-null float64
    p1_dog                2005 non-null object
    p2                    2005 non-null object
    p2_conf               2005 non-null float64
    p2_dog                2005 non-null object
    p3                    2005 non-null object
    p3_conf               2005 non-null float64
    p3_dog                2005 non-null object
    favorite_count        2186 non-null float64
    retweet_count         2186 non-null float64
    growth_stage          356 non-null object
    dtypes: category(1), datetime64[ns](1), float64(5), int64(6), object(11)
    memory usage: 412.4+ KB
    


```python
# save the main dataframe to working directory
df_main.to_csv('main_twitter_dataset.csv', index=False)
```
