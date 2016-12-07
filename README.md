# ADS Final Project: 

Term: Fall 2016

+ Team Name: Group 5
+ Projec title: Allstate Insurance Claims Severity Prediction
+ Team members
	+ Kyungmook Lim
	+ Hayoung Kim
	+ Hyung Joon Choi
	+ Younhyuk Cho
	
+ Project summary: In this project, we tried to demonstrate insights into finding better ways to predict Allstate claims severity using variables given in the data. The project was inspired by Allstate Claims Severity kaggle competition. There were 116 categorical variables and 14 continous varaibles given in our data. Five categorical variables had large number of categories(over 32) and some models including decision tree and random forest cannot handle large number of categories. We used response averaging to handle this problem and performed PCA to both categorical and continuous variables to reduce the dimention of our data. To perform PCA on categorical variables, we transformed categorical varaibles into model matrix. We used 7 components from continous varaibles and 8 components from categorical variables. Using these components and variables transformed using response averaging as inputs, we used decision tree, random forest and xgboost as our regression methods and found out that moel using xgboost gave the best result.
	
**Contribution statement**: ([default](doc/a_note_on_contributions.md)) All team members contributed equally in all stages of this project. All team members approve our work presented in this GitHub repository including this contributions statement. 

Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── lib/
├── data/
├── doc/
├── figs/
└── output/
```

Please see each subfolder for a README file.
