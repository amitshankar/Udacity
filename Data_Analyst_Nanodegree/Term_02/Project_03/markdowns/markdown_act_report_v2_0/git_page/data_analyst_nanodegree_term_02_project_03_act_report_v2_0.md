Title: Analyzing Twitter Feed - Part 3 - Insights Report
Author: Amit Shankar
Date: 08/21/2018
Tags: data analyst nanodegree, python, twitter
Summary: This is the third project of term 02 in the data analyst nanodegree program. In this project, we examined the twitter feeds and this post highlights the insights on some questions that were answered through exploration.


# Act Report

Explored the cleaned data to gain insights on the following questions: 

1. Is the tweet that received the most favorites count also the tweet that was retweeted most?
2. What day of the week were most of the tweets created? 
3. What are some of the common words used in the top tweets?

# Reference

https://pandas.pydata.org/pandas-docs/version/0.23/generated/pandas.DataFrame.plot.bar.html  
https://stackoverflow.com/questions/16645799/how-to-create-a-word-cloud-from-a-corpus-in-python  
https://stackoverflow.com/questions/27934885/how-to-hide-code-from-cells-in-ipython-notebook-visualized-with-nbviewer  


```python
# Import libraries
import pandas as pd
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
import seaborn as sns
from wordcloud import WordCloud, STOPWORDS 
sns.set(style="whitegrid", color_codes=True)
```


```python
# Source: https://stackoverflow.com/questions/16645799/how-to-create-a-word-cloud-from-a-corpus-in-python
stopwords = set(STOPWORDS)  # set the stop words

def show_wordcloud(data, title = None):
    wordcloud = WordCloud(
        background_color='white',
        stopwords=stopwords,
        max_words=200,
        max_font_size=40, 
        scale=3,
        random_state=1 # chosen at random by flipping a coin; it was heads
    ).generate(str(data))

    fig = plt.figure(1, figsize=(12, 12))
    plt.axis('off')
    if title: 
        fig.suptitle(title, fontsize=20)
        fig.subplots_adjust(top=2.3)

    plt.imshow(wordcloud)
    plt.show()
```


```python
# read the main tweet dataset csv
df_main=pd.read_csv('main_twitter_dataset.csv')
```

# Question 1: Is the tweet that received the most favorites count also the tweet that was retweeted most?


```python
tmp=df_main.sort_values(by=['favorite_count','retweet_count'],
                        ascending=False)[['tweet_id','favorite_count','retweet_count']].head(10)

print('Table of Tweet IDs with the top 10 favorites count and retweets count')

tmp
```

    Table of Tweet IDs with the top 10 favorites count and retweets count
    




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
      <th>872</th>
      <td>744234799360020481</td>
      <td>162143.0</td>
      <td>84152.0</td>
    </tr>
    <tr>
      <th>350</th>
      <td>822872901745569793</td>
      <td>142138.0</td>
      <td>48561.0</td>
    </tr>
    <tr>
      <th>119</th>
      <td>866450705531457537</td>
      <td>123352.0</td>
      <td>36023.0</td>
    </tr>
    <tr>
      <th>449</th>
      <td>807106840509214720</td>
      <td>121999.0</td>
      <td>60430.0</td>
    </tr>
    <tr>
      <th>912</th>
      <td>739238157791694849</td>
      <td>121443.0</td>
      <td>62781.0</td>
    </tr>
    <tr>
      <th>63</th>
      <td>879415818425184262</td>
      <td>105136.0</td>
      <td>44023.0</td>
    </tr>
    <tr>
      <th>376</th>
      <td>819004803107983360</td>
      <td>92986.0</td>
      <td>40642.0</td>
    </tr>
    <tr>
      <th>147</th>
      <td>859196978902773760</td>
      <td>91694.0</td>
      <td>31340.0</td>
    </tr>
    <tr>
      <th>103</th>
      <td>870374049280663552</td>
      <td>82744.0</td>
      <td>26514.0</td>
    </tr>
    <tr>
      <th>451</th>
      <td>806629075125202948</td>
      <td>81404.0</td>
      <td>38968.0</td>
    </tr>
  </tbody>
</table>
</div>




```python
ax=tmp.plot.bar(x='tweet_id',rot=0,subplots=False,figsize=(10,5))
ax.set_xticklabels(ax.get_xticklabels(),rotation=90,fontsize=15)
ax.set_title("Graph of Top Tweets Favorite's Count and Retweet Count", fontsize=20);
```


![png](images/data_analyst_nanodegree_term_02_project_03_act_report_v2_0/data_analyst_nanodegree_term_02_project_03_act_report_v2_0_8_0.png)


From the graph above it can be seen that the tweet that received the most favorite's count was not the tweet that was retweeted 
most.

Tweet corresponding to the tweet id 822872901745569793 received the highest favorites count while tweet corresponding to tweet id 744234799360020481 received the highest retweet count. 

It can also be observed that the top 10 tweets:
1. Favorites count was more than 80,000
2. Retweets count was more than 20,000

# Question 2: What day of the week were most of the tweets created? 


```python
tmp=df_main.groupby('timestamp_weekday').size().reset_index(name = "Number of Tweets")

print('Table of number of Tweets by weekday')

tmp
```

    Table of number of Tweets by weekday
    




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
      <th>timestamp_weekday</th>
      <th>Number of Tweets</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0</td>
      <td>359</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1</td>
      <td>328</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2</td>
      <td>322</td>
    </tr>
    <tr>
      <th>3</th>
      <td>3</td>
      <td>307</td>
    </tr>
    <tr>
      <th>4</th>
      <td>4</td>
      <td>307</td>
    </tr>
    <tr>
      <th>5</th>
      <td>5</td>
      <td>287</td>
    </tr>
    <tr>
      <th>6</th>
      <td>6</td>
      <td>277</td>
    </tr>
  </tbody>
</table>
</div>




```python
# create a dictionary for mapping
di_day = {'0':'Monday','1':'Tuesday','2':'Wednesday','3':'Thursday','4':'Friday','5':'Saturday','6':'Sunday'}

# map the dictionary 
tmp['timestamp_weekday']=tmp['timestamp_weekday'].astype(str).replace(di_day)

# plot the barplot
ax=tmp.plot.bar(x='timestamp_weekday',rot=0,subplots=False,figsize=(10,5))
ax.set_title("Graph of Total Tweets by Day", fontsize=20);
```


![png](images/data_analyst_nanodegree_term_02_project_03_act_report_v2_0/data_analyst_nanodegree_term_02_project_03_act_report_v2_0_12_0.png)


From the above graph it can be observed that the highest number of tweets were created on Monday. It is interesting to note that the number of tweets tapered down towards the weekend.  


```python

```

# Question 3: What are some of the common words used in the top tweets?


```python
# extract the top tweets
tmp=df_main.sort_values(by=['favorite_count'],ascending=False)[['text']].head(10)

print('<<Below are text corresponding to the top 10 tweets that received the most favorites count>> \n')

#view the top tweets
for i in tmp['text']:
    print(i)
```

    <<Below are text corresponding to the top 10 tweets that received the most favorites count>> 
    
    Here's a doggo realizing you can stand in a pool. 13/10 enlightened af (vid by Tina Conrad) https://t.co/7wE9LTEXC4
    Here's a super supportive puppo participating in the Toronto  #WomensMarch today. 13/10 https://t.co/nTz3FtorBc
    This is Jamesy. He gives a kiss to every other pupper he sees on his walk. 13/10 such passion, much tender https://t.co/wk7TfysWHr
    This is Stephan. He just wants to help. 13/10 such a good boy https://t.co/DkBYaCAg2d
    Here's a doggo blowing bubbles. It's downright legendary. 13/10 would watch on repeat forever (vid by Kent Duryee) https://t.co/YcXgHfp1EC
    This is Duddles. He did an attempt. 13/10 someone help him (vid by Georgia Felici) https://t.co/UDT7ZkcTgY
    This is Bo. He was a very good First Doggo. 14/10 would be an absolute honor to pet https://t.co/AdPKrI8BZ1
    We only rate dogs. This is quite clearly a smol broken polar bear. We'd appreciate if you only send dogs. Thank you... 12/10 https://t.co/g2nSyGenG9
    This is Zoey. She really likes the planet. Would hate to see willful ignorance and the denial of fairly elemental science destroy it. 13/10 https://t.co/T1xlgaPujm
    "Good afternoon class today we're going to learn what makes a good boy so good" 13/10 https://t.co/f1h2Fsalv9
    


```python
print('Word cloud of some of the common words in top 10 tweets that received the most favorites count' )
show_wordcloud(tmp['text'])
```

    Word cloud of some of the common words in top 10 tweets that received the most favorites count
    


![png](images/data_analyst_nanodegree_term_02_project_03_act_report_v2_0/data_analyst_nanodegree_term_02_project_03_act_report_v2_0_17_1.png)


From the word cloud, it can be observed that the top 10 tweets contained some interesting text such as:  
help, stand, kiss, participating, supportive, gives, wants, quite.


```python

```
