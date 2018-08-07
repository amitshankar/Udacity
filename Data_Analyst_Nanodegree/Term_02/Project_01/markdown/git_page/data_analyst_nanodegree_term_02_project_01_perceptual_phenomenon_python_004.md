Title: Hypothesis testing the Stroop Effect
Author: Amit Shankar
Date: 06/18/2018
Tags: data analyst nanodegree, python, hypothesis testing
Summary: This is the second project of term 02 in the data analyst nanodegree program. In this project, we exammined the data regarding the Stroop Effect and performed a two tailed test.

The following information presented below about the Stroop effect can be found [here](https://docs.google.com/document/d/1-OkpZLjG_kX9J6LIQ5IltsqMzVWjh36QpnP2RYpVdPU/pub?embedded=True).  

What is Stroop Effect: In a Stroop task, participants are presented with a list of words, with each word displayed in a color of ink. The participant’s task is to say out loud the color of the ink in which the word is printed. The task has two conditions: a congruent words condition, and an incongruent words condition. In the congruent words condition, the words being displayed are color words whose names match the colors in which they are printed: for example RED, BLUE. In the incongruent words condition, the words displayed are color words whose names do not match the colors in which they are printed: for example PURPLE, ORANGE. In each case, we measure the time it takes to name the ink colors in equally-sized lists. Each participant will go through and record a time from each condition.  
Source: https://docs.google.com/document/d/1-OkpZLjG_kX9J6LIQ5IltsqMzVWjh36QpnP2RYpVdPU/pub?embedded=True

The dataset called stroopdata.csv and the ipython notebook can be found [here](https://github.com/amitshankar/Udacity/tree/master/Data_Analyst_Nanodegree/Term_02/Project_01).


(1) What is the independent variable? What is the dependent variable?

**Answer**<br>
Dependent variables are the congruent and incongruent times.<br>
Independent variables are word and color combination of text that is shown to the participants, also the size and type of fonts used.

(2) What is an appropriate set of hypotheses for this task? Specify your null and alternative hypotheses, and clearly define any notation used. Justify your choices.

**Answer**<br>
Two tail test is ideal when direction is not important. In this case, the null hypothesis could be that mean congruent time is equal to mean incongruent time. The alternate hypothesis is that the mean congruent time is not equal to incongruent time.


$$H_0: \mu_{congruent} - \mu_{incongruent} = 0$$
$$H_0: \mu_{congruent} - \mu_{incongruent} \neq 0$$

**$\mu_{congruent}$  and  $\mu_{incongruent}$ are population mean.**

** $\alpha$ = 0.05  (threshold of type 1 error)**

Degrees of freedom = 24-1=23

Assumption: Since the same candidate is taking the congruent and incongruent test, I am assuming that the two are related ( the candidate is the same just the test is different).

(3) Report some descriptive statistics regarding this dataset. Include at least one measure of central tendency and at least one measure of variability. The name of the data file is 'stroopdata.csv'.


```python
# Perform the analysis here
#import libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

%matplotlib inline
```


```python
#set random seed for reproducibilty
#np.random.seed(42)
```


```python
#read the data 
df=pd.read_csv('stroopdata.csv')
print(df.head())
print('\n')
print(df.info())
```

       Congruent  Incongruent
    0     12.079       19.278
    1     16.791       18.741
    2      9.564       21.214
    3      8.630       15.687
    4     14.669       22.803
    
    
    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 24 entries, 0 to 23
    Data columns (total 2 columns):
    Congruent      24 non-null float64
    Incongruent    24 non-null float64
    dtypes: float64(2)
    memory usage: 464.0 bytes
    None
    


```python
df.describe()
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Congruent</th>
      <th>Incongruent</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>24.000000</td>
      <td>24.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>14.051125</td>
      <td>22.015917</td>
    </tr>
    <tr>
      <th>std</th>
      <td>3.559358</td>
      <td>4.797057</td>
    </tr>
    <tr>
      <th>min</th>
      <td>8.630000</td>
      <td>15.687000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>11.895250</td>
      <td>18.716750</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>14.356500</td>
      <td>21.017500</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>16.200750</td>
      <td>24.051500</td>
    </tr>
    <tr>
      <th>max</th>
      <td>22.328000</td>
      <td>35.255000</td>
    </tr>
  </tbody>
</table>
</div>




```python
print('Congruent mean: ' +str(df['Congruent'].mean()))
print('Incongruent mean: ' +str(df['Incongruent'].mean()))
obs_diff_mean=df['Congruent'].mean()-df['Incongruent'].mean()
print('Difference between congruent and incongruent mean '+str(obs_diff_mean))

print('\n')
print('Congruent median: ' +str(df.Congruent.median()))
print('Incongruent median: ' +str(df.Incongruent.median()))

print('\n')
print('Congruent variance: ' +str(df.Congruent.var()))
print('Incongruent variance: ' +str(df.Incongruent.var()))

```

    Congruent mean: 14.051125
    Incongruent mean: 22.0159166667
    Difference between congruent and incongruent mean -7.96479166667
    
    
    Congruent median: 14.3565
    Incongruent median: 21.0175
    
    
    Congruent variance: 12.6690290707
    Incongruent variance: 23.0117570362
    


```python

```

(4) Provide one or two visualizations that show the distribution of the sample data. Write one or two sentences noting what you observe about the plot or plots.


```python
# Build the visualizations here
plt.hist(df.Congruent,alpha=0.5, label='Congruent Time');
plt.hist(df.Incongruent,alpha=0.5,label='Incongruent Time');
plt.legend(loc='upper right')
plt.title('Congruent and Incongruent Times Histograms')
plt.show()
```


![png](images/data_analyst_nanodegree_term_02_project_01_perceptual_phenomenon_python_004/data_analyst_nanodegree_term_02_project_01_perceptual_phenomenon_python_004_12_0.png)


**Observation:**<br>
Congruent times are lower than incongruent times with some overlap i.e. participants took less time in the congruent test than the incongruent test. 


```python
#set the x column as a range of numbers 0-27
x=range(df.shape[0])
x=pd.Series(x)

plt.plot(x,df.Congruent, label='Congruent Time');
plt.plot(x,df.Incongruent, label='Incongruent Time');
plt.legend(loc='upper left')
plt.title('Congruent Time and Incongruent Time Line plot')
plt.show()

```


![png](images/data_analyst_nanodegree_term_02_project_01_perceptual_phenomenon_python_004/data_analyst_nanodegree_term_02_project_01_perceptual_phenomenon_python_004_14_0.png)


**Observation:**<br>
The line plot confirms that each participant spent more time on Incongruent test than on congruent test. 


```python

```

(5)  Now, perform the statistical test and report your results. What is your confidence level or Type I error associated with your test? What is your conclusion regarding the hypotheses you set up? Did the results match up with your expectations? **Hint:**  Think about what is being measured on each individual, and what statistic best captures how an individual reacts in each environment.


```python
import scipy.stats as stats
```


```python
t_stat, p_val =stats.ttest_rel(df['Congruent'], df['Incongruent'])
#print(t_stat, p_val)
print('t statistic is '+str(t_stat))
print('p value is '+str(p_val))
```

    t statistic is -8.02070694411
    p value is 4.10300058571e-08
    


```python
#lower bound for 95% confidence interval
lower_t_95=stats.t.ppf(q=0.025,  # Quantile to check
            df=23)  # Degrees of freedom

upper_t_95=stats.t.ppf(q=0.975,  # Quantile to check
            df=23)  # Degrees of freedom

print('Confidence interval to accept null hypothesis if \n t statistic is between: ' +str(lower_t_95)+' and '+str(upper_t_95))
```

    Confidence interval to accept null hypothesis if 
     t statistic is between: -2.06865761042 and 2.06865761042
    

**Observation:**<br>
<br>
Analysing t statistic:<br>
Since the t statistic of -8.021 is outside the acceptable 95% confidence interval of (-2.069, 2.069), we reject the 
null hypothsis. 
<br><br>
Analysing p value:<br>
Also, since p value of 4.103e-08 is less than $\alpha$ of 0.05, we reject the null as well.

Therefore, we can not accept the null hythesis that mean congruent value is equal to mean incongruent value.


```python

```

(6) Optional: What do you think is responsible for the effects observed? Can you think of an alternative or similar task that would result in a similar effect? Some research about the problem will be helpful for thinking about these two questions!

**Answer**<br>
The brain gets confused becuase what the words mean does not match the color of the words. The two theories stated on this site
https://faculty.washington.edu/chudler/words.html#seffect are :

Speed of Processing Theory: the interference occurs because words are read faster than colors are named. <br>
Selective Attention Theory: the interference occurs because naming colors requires more attention than reading words.

Similar task that would result in a similar effect: <br>
Turn the words upside down or rotate them 90 degrees.


```python

```

**Reference**

https://stackoverflow.com/questions/22611446/perform-2-sample-t-test <br>
https://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.ttest_ind.html <br>
https://docs.scipy.org/doc/scipy-0.14.0/reference/generated/scipy.stats.ttest_rel.html <br>
http://benalexkeen.com/comparative-statistics-in-python-using-scipy/ <br>
http://hamelg.blogspot.com/2015/11/python-for-data-analysis-part-24.html?view=mosaic <br>
http://www.pythonforfinance.net/2016/04/04/python-skew-kurtosis/<br>
https://stackoverflow.com/questions/45483890/how-to-correctly-use-scipys-skew-and-kurtosis-functions<br>
http://davidmlane.com/hyperstat/A92403.html<br>
https://stackoverflow.com/questions/12838993/scipy-normaltest-how-is-it-used <br>
https://stackoverflow.com/questions/36667548/how-to-create-a-series-of-numbers-using-pandas-in-python <br>


```python

```
