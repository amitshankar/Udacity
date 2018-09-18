Title: Tableau Project - Analyzing Flights Data
Author: Amit Shankar
Date: 09/10/2018
Tags: data analyst nanodegree, tableau
Summary: This is the fourth project in second term of the data analyst nanodegree program. This project focussed on analyzing data in Tableau and creating a 'Tableau Story' for presenting the highlights. The story board can be accessed [here](https://public.tableau.com/profile/amit.kumar.shankar#!/vizhome/Udacity_Tableau_Project_Story_v4/ExplorationofFlightsDataset-Story-Final). 

# Documentation
Chose the Flights data set from https://docs.google.com/document/d/1w7KhqotVi5eoKE3I_AZHbsxdr-NmcWsLTIiZrpxWx4w/pub?embedded=true .
I tried importing all the csv files into Tableau, but the free version only allows for 15,000,000 rows of data. Therefore, I chose to analyze the two most recent datasets: 2007 and 2008 flight data.

I created a union of 2007 and 2008 dataset and then an intersection with the carrier’s dataset to extract the proper names for each unique airline carrier.
For feedback purposes, I showed the dashboards and storyline to a friend.

The final story board can be accessed [here](https://public.tableau.com/profile/amit.kumar.shankar#!/vizhome/Udacity_Tableau_Project_Story_v4/ExplorationofFlightsDataset-Story-Final). 


## Calculated Field: 
Since the dataset contains ‘Year’, ‘Month’ and ‘Dayof Month’ fields, I combined those fields together to create a Reference_Date field. First, converted the fields to string, then concatenated them using ‘-’ and parsed it using the DATEPARSE function. This resulted in a proper date and time. Since the time was not needed, applied the DATE function to only keep the DATE  in Reference_Date field. 
DATE(DATEPARSE("YYYY-MM-dd",STR([Year])+"-"+STR([Month])+"-"+STR([Dayof Month])))

## Note: 
The story board best renders on a chrome browser in full screen mode. 

## Good workflow I learnt is  :
create worksheet -> embed worksheet to dashborad and polish your presentation-> embed dashboard to storyboard

