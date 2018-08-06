Title: Bart Ridership Stats with User Validation in Python
Author: Amit Shankar
Date: 4/5/2018
Tags: data analyst nanodegree, python, programming
Summary: This is the second project of term one in the data analyst nanodegree program. This project reads data regarding bart ridership in Chicago, New York, Washington and takes user input regarding a particular state and computes stats with validation in python.

The dataset for the project are located [here](https://github.com/amitshankar/Udacity/tree/master/Data_Analyst_Nanodegree/Term_01/Project_02/datasets) and python script that interacts with the data is called final.py located [here](https://github.com/amitshankar/Udacity/tree/master/Data_Analyst_Nanodegree/Term_01/Project_02).


# Resources
https://stackoverflow.com/questions/1801668/convert-a-python-list-with-strings-all-to-lowercase-or-uppercase
https://stackoverflow.com/questions/29403192/convert-series-returned-by-pandas-series-value-counts-to-a-dictionary
https://bytes.com/topic/python/answers/794376-printing-contents-list-one-line
https://stackoverflow.com/questions/483666/python-reverse-invert-a-mapping
https://stackoverflow.com/questions/13411544/delete-column-from-pandas-dataframe-using-python-del


# Improvements from suggestions from first submission:
1. Reading only one file instead of all the files into memory.  
2. Included a display function to display 5 lines at a time.  
3. Not throwing an error when user enters ChiCAgo instead of Chicago.  
4. For gender and birth calculations, checking the column names.  

# Statistics Computed

## 1 Popular times of travel (i.e., occurs most often in the start time)

most common month  
most common day of week  
most common hour of day  

## 2 Popular stations and trip

most common start station  
most common end station  
most common trip from start to end (i.e., most frequent combination of start station and end station)  

## 3 Trip duration

total travel time  
average travel time  

## 4 User info

counts of each user type  
counts of each gender (only available for NYC and Chicago)  
earliest, most recent, most common year of birth (only available for NYC and Chicago)  


## The following are the codes for the projgect:

```
# coding: utf-8

# In[1]:


#import packages
import pandas as pd
import numpy as np


# In[2]:


#df -means data frame

def data_stats(df):
    '''
    This is a helper function to get a better understanding of each dataframe such as 
    the data types, number of rows of data, missing values etc.
    '''
    print(df.head(2))
    print('\n')
    print(df.describe())
    print('\n')
    print(df.info())
    return None

def reading_file(location):
    '''
    Input: Receives the correct location name.
    Process: Reads the csv file into a data frame corresponding to the location.
    Ouput: Returns the data frame.
    '''
    
    city_data = { 'chicago': 'datasets/chicago.csv',
              'new york': 'datasets/new_york_city.csv',
              'washington': 'datasets/washington.csv' }
    filename=city_data[location]
    df=pd.read_csv(filename)
    df['Location']=location.title()
    
    return df


def clean_files(df):
    '''
    The function receives a dataframe, drops the first column and 
    converts the Start Time and End Time columns in to pandas date time format and returns that dataframe
    '''

    #drop first column
    df.drop('Unnamed: 0', axis='columns',inplace=True)
    #make start time and end time to data time format
    df['Start Time']=pd.to_datetime(df['Start Time'])
    df['End Time']=pd.to_datetime(df['End Time'])
    
    #add hour column to dataframe
    df['hour'] = df['Start Time'].dt.hour
    
    #add week day column containing weekday name
    df['week_day']=df['Start Time'].dt.weekday_name
    
    #add month column containing month name
    calender={1:'January',2:'February',3:'March',4:'April',5:'May',6:'June'}
    df['month']=df['Start Time'].dt.month
    df['month']=df['month'].map(calender) #month number to name
        
    return df


def validate_user_input(value,possible_values):
    '''
    Input: Receives the input value and possible values.
    Process:This function compares what the user entered against possible values and asks the user to enter the one of the possible values.
    Output: Returns the correct value in lower case.
    '''
    value_lower_case=value.lower()#lower case the values for easy comparison
    possible_values_lower_case=[x.lower() for x in possible_values]
    exit_loop=True
    while exit_loop:
        if value_lower_case in possible_values_lower_case: 
            print('Thanks for choosing {}.'.format(value_lower_case.title()))
            print('\n')
            correct_value=value_lower_case
            exit_loop=False
        else:
            print('The valid options are from the following {}'.format(possible_values))
            value=input('Please enter the valid option as stated above:') ######
            value_lower_case=value.lower()
    return correct_value #always lower case



def get_location():
    '''
    Process:This function gets asks the user for the location and validates user input
    Output: Returns the correct location
    '''
    location_value=input('Would you like to see data for Chicago, New York, or Washington? ')
    location_possible_values=['Chicago','New York','Washington']
    correct_location=validate_user_input(location_value,location_possible_values)
    return correct_location

def get_day():
    '''
    Input: None
    Process: The function gives user the option to filter data by day.
    If the user chooses to filter the data by day, then user is presented with the next option to 
    choose a specific day.
    Output: The function returns the correct day
    '''
    day_input=input('Would you like to filter the data by day (Yes or No): ')
    day_possible_input=['Yes','No']
    correct_day_input=validate_user_input(day_input,day_possible_input)
    if correct_day_input=='yes':
        day_name=input('Please enter any of the following days: Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday: ')
        day_possible_names=['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday']
        correct_day_name=validate_user_input(day_name,day_possible_names)
        return(correct_day_name.title()) #capitalize first letter so consistant with day names in data frame
    else:
        return(correct_day_input)

    
def get_month():
    '''
    Input: None
    Process: This function will give user the option to sort the data by month.
    If user chooses yes, then user is presented with the options to choose the month
    Output: Returns the correct month chosen by the user
    '''
    month_input=input('Would you like to filter the data by month (Yes or No): ')
    month_possible_input=['Yes','No']
    correct_month_input=validate_user_input(month_input,month_possible_input)
    if correct_month_input=='yes':
        month_name=input('Please enter any of the following months: Januay,February,March,April,May,June: ')
        month_possible_names=['January','February','March','April','May','June']
        correct_month_name=validate_user_input(month_name,month_possible_names)
        return(correct_month_name.title()) #capitalize the first letter so consistant with months in data frame

    else:
        return(correct_month_input)
    

def load_filter_data():
    '''
    Input:None
    Process: This function will use sub functions to get inputs from the user such as location, month and day.
    It also validates user input so correct options are chose. It then filters the data based on user selecton.
    Output: Returns the filtered dataframe.
    '''
    location_filter=get_location() # get location
    month_filter=get_month() #get month
    day_filter=get_day() #get day
    
    #filter by location
    df=reading_file(location_filter) #read file
    df=clean_files(df) #clean file
    
    #filter data by month
    if month_filter!='no':
        df=df[df.month==month_filter]
    
    #filter data by day name
    if day_filter!='no':
        df=df[df.week_day==day_filter]
        
    return df


def calculate_stats(df):
    '''
    Input: The function receives a clean dataframe.
    Process: The function calculates all the statistics required for the project and instead of printing to
    screen, it appends it to a output list.
    Output: The function returns a list containing all statistics.
    '''
    output=[]#declare a list to save all outputs
    location=df.Location.unique()[0]
    #popular travel times
    output.append('For {}, most common hour is {}.'.format(location,df.hour.mode().max()))
    output.append('For {}, most common day of week is {}.'.format(location,df.week_day.mode().max()))
    output.append('For {}, most common month is {}.'.format(location,df.month.mode().max()))

    #popular stations
    output.append('For {}, most common start station is {}'.format(location,df['Start Station'].mode().max()))
    output.append('For {}, most common end station is {}'.format(location,df['End Station'].mode().max()))
    df['Start End Station']=df['Start Station'].str.cat(df['End Station'], sep=' to ')
    output.append('For {}, most common start to end station is {}.'.format(location,df['Start End Station'].mode().max()))

    #trip durations
    total_travel_time=df['Trip Duration'].sum()
    mean_travel_time=df['Trip Duration'].mean()
    output.append('For {}, the total travel time was {} seconds and average travel time was {} seconds.'.format(location,total_travel_time,mean_travel_time))


    #user type info
    #convert value count to dictionary for easier unpacking into a list via a for loop
    subscribers=dict(df['User Type'].value_counts())
    for (k, v) in subscribers.items():
        output.append('For {},there are {} {}(s).'.format(location,v,k))

    #gender info
    #check to see if there is gender column
    if 'gender' in map(str.lower,df.columns): #convert column names to lower case for easier comparison
        gender=dict(df['Gender'].value_counts())
        for (k, v) in gender.items():
            output.append('For {},there are {} {}(s).'.format(location,v,k))


    #birth info
    if 'birth year' in map(str.lower,df.columns): #convert column names to lower case for easier comparison
        df['Birth Year']=df['Birth Year'].fillna(0.0).astype(int)
        test=df['Birth Year']>0
        oldest_rider=df[test]['Birth Year'].min()
        youngest_rider=df[test]['Birth Year'].max()
        most_common=df[test]['Birth Year'].mode().max()
        output.append('For {}, the oldest rider was born in the year: {}.'.format(location,oldest_rider))
        output.append('For {}, the youngest rider was born in the year: {}.'.format(location,youngest_rider))
        output.append('For {}, the most common birth year was: {}.'.format(location,most_common))
    
    return output

def display_output(output_list):
    '''
    Input: The function recevies a list containing all analysis
    Process: The function iterates through the list to print each element and asks for user
    input after every 5 print statements
    Output: None
    '''
    
    counter=0
    start=counter
    end=counter+5
    max_iteration=len(output_list)
    last_loop=0
    while(counter<max_iteration):
        for i in range(start,end):
            #print('i is {} and counter is {}'.format(i,counter))
            print(output_list[i])
        counter=counter+5
        start=counter


        if last_loop==0:
            response=input('Enter 0 to exit seeing the output or enter anything else to continue seeing the output: ')
            if response=='0':
                print('Now exiting the analysis display.')
                break #break if the user chooses to exit early
        else:
            break #will break the for loop since this is last iteration


        #check if end limit is less than 5 to determine if the next loop is the last loop
        # if next loop is the last loop then reset end limit to whatever is left over
        if max_iteration-counter<=5:
            end=start+(max_iteration-counter)
            last_loop=1 #will prevent asking the user for input in the last iteration
        else:
            end=counter+5


def main():
    '''
    The main function calls the rest of the functions to load the data, calculate results and
    diplay the data.
    '''
    exit_loop=True
    while exit_loop:  
        data=load_filter_data()
        results=calculate_stats(data)
        display_output(results)
        tmp=input('\n \nIf you would like to end the program, enter 0 or else enter anything to continue running this program: ')
        if tmp=='0':
            print('This program will now terminate.')
            exit_loop=False


# In[3]:


if __name__ == "__main__":
    main()


# In[ ]:

```
