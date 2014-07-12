### Introduction

This repository contains all the data, code and outputs for my World Cup 2014 analysis. It is an experiment to see whether data mining can outperform my friends. So far the data mining approach has the upper hand. It predicted 35/62 (or 56.5%) correct match results (Win/Draw/Lose) and 10/62 (or 16.1%) correct scores.

### Data Source

1. http://fivethirtyeight.com/interactives/world-cup/
2. http://www.bloomberg.com/visual-data/world-cup/
3. https://www.betfair.com/sport

### Methods

- The predictors include various information from Bloomberg and FiveThirtyEight such as team performance indicators, probability of Win/Draw/Lose, world ranking as well as latest odds from betfair.com. An Excel spreadsheet in the **data** folder is used for storing the data.
- The predicted results are median values from multiple model predictions. Each model consists of four common regression mini models (Random Forest, SVMs, Cubist and KNN) which are trained with bootstrapped samples and blended for better genearlisation.
- Early on in the tourament, the future match results predicted by Bloomberg had been used as training data as there were not enough actual results.


### Results

**Notes**: more detailed results including the distribution of predictions results can be found in the **output** folder.


Match | Date | Team 1 | Team 2 | Predictions | Results (90 mins) | Correct WDL | Correct Score 
------|------|--------|--------|-------------|---------|--------------|---------------
1 | 12/06 | Brazil | Croatia | 4:0 | 3:1 | **Yes** | No 
2 | 13/06 | Mexico | Cameroon | 1:0 | 1:0 | **Yes** | **Yes** 
3 | 13/06 | Spain | Netherlands | 1:0 | 1:5 | No | No 
4 | 13/06 | Chile | Australia | 1:0 | 3:1 | **Yes** | No 
5 | 14/06 | Colombia | Greece | 1:0 | 3:0 | **Yes** | No 
6 | 14/06 | Uruguay | Costa Rica | 2:0 | 1:3 | No | No 
7 | 14/06 | England | Italy | 1:1 | 1:2 | No | No 
8 | 15/06 | Ivory Coast | Japan | 1:1 | 2:1 | No | No 
9 | 15/06 | Switzerland | Ecuador | 1:1 | 2:1 | No | No 
10 | 15/06 | France | Honduras | 2:0 | 3:0 | **Yes** | No 
11 | 15/06 | Argentina | Bosnia | 2:1 | 2:1 | **Yes** | **Yes** 
12 | 16/06 | Germany | Portugal | 1:1 | 4:0 | No | No 
13 | 16/06 | Iran | Nigeria | 1:1 | 0:0 | **Yes** | No 
14 | 16/06 | Ghana | USA | 1:1 | 1:2 | No | No 
15 | 17/06 | Belgium | Algeria | 2:1 | 2:1 | **Yes** | **Yes** 
16 | 17/06 | Brazil | Mexico | 3:1 | 0:0 | No | No 
17 | 17/06 | Russia | S Korea | 1:1 | 1:1 | **Yes** | **Yes** 
18 | 18/06 | Australia | Netherlands | 1:3 | 2:3 | **Yes** | No 
19 | 18/06 | Spain | Chile | 2:3 | 0:2 | **Yes** | No 
20 | 18/06 | Cameroon | Croatia | 1:1 | 0:4 | No | No 
21 | 19/06 | Colombia | Ivory Coast | 2:1 | 2:1 | **Yes** | **Yes** 
22 | 19/06 | Uruguay | England | 2:2 | 2:1 | No | No 
23 | 19/06 | Japan | Greece | 0:0 | 1:1 | **Yes** | No 
24 | 20/06 | Italy | Costa Rica | 2:1 | 0:1 | No | No 
25 | 20/06 | Switzerland | France | 1:2 | 2:5 | **Yes** | No
26 | 20/06 | Honduras | Ecuador | 1:2 | 1:2 | **Yes** | **Yes** 
27 | 21/06 | Argentina | Iran | 2:1 | 1:0 | **Yes** | No 
28 | 21/06 | Germany | Ghana | 3:1 | 2:2 | No | No 
29 | 21/06 | Nigeria | Bosnia | 1:2 | 1:0 | No | No 
30 | 22/06 | Belgium | Russia | 2:1 | 1:0 | **Yes** | No 
31 | 22/06 | S Korea | Algeria | 1:1 | 2:4 | No | No 
32 | 22/06 | USA | Portugal | 2:2 | 2:2 | **Yes** | **Yes** 
33 | 23/06 | Netherlands | Chile | 2:2 | 2:0 | No | No 
34 | 23/06 | Australia | Spain | 1:2 | 0:3 | **Yes** | No 
35 | 23/06 | Cameroon | Brazil | 1:2 | 1:4 | **Yes** | No 
36 | 23/06 | Croatia | Mexico | 1:1 | 1:3 | No | No 
37 | 24/06 | Costa Rica | England | 2:2 | 0:0 | **Yes** | No 
38 | 24/06 | Italy | Uruguay | 1:1 | 0:1 | No | No 
39 | 24/06 | Japan | Colombia | 1:2 | 1:4 | **Yes** | No 
40 | 24/06 | Greece | Ivory Coast | 1:1 | 2:1 | No | No 
41 | 25/06 | Nigeria | Argentina | 1:2 | 2:3 | **Yes** | No 
42 | 25/06 | Bosnia | Iran | 1:1 | 3:1 | No | No 
43 | 25/06 | Ecuador | France | 1:2 | 0:0 | No | No 
44 | 25/06 | Honduras | Switzerland | 1:2 | 0:3 | **Yes** | No 
45 | 26/06 | Portugal | Ghana | 2:1 | 2:1 | **Yes** | **Yes** 
46 | 26/06 | USA | Germany | 1:2 | 0:1 | **Yes** | No 
47 | 26/06 | Algeria | Russia | 1:2 | 1:1 | No | No 
48 | 26/06 | S Korea | Belgium | 1:2 | 0:1 | **Yes** | No 
49 | 28/06 | Brazil | Chile | 2:2 | 1:1 | **Yes** | No 
50 | 28/06 | Colombia | Uruguay | 1:1 | 2:0 | No | No 
51 | 29/06 | Netherlands | Mexico | 2:1 | 2:1 | **Yes** | **Yes** 
52 | 29/06 | Costa Rica | Greece | 1:1 | 1:1 | **Yes** | **Yes** 
53 | 30/06 | France | Nigeria | 2:1 | 2:0 | **Yes** | No 
54 | 30/06 | Germany | Algeria | 2:1 | 0:0 | No | No 
55 | 01/07 | Argentina | Switzerland | 3:1 | 0:0 | No | No 
56 | 01/07 | Belgium | USA | 2:1 | 0:0 | No | No 
57 | 04/07 | France | Germany | 1:2 | 0:1 | **Yes** | No
58 | 04/07 | Brazil | Colombia | 1:1 | 2:1 | No | No
59 | 05/07 | Argentina | Belgium | 2:1 | 1:0 | **Yes** | No
60 | 05/07 | Netherlands | Costa Rica | 1:1 | 0:0 | **Yes** | No
61 | 08/07 | Brazil | Germany | 1:1 | 1:7 | No | No
62 | 09/07 | Netherlands | Argentina | 1:1 | 0:0 | **Yes** | No
63 | 12/07 | Brazil | Netherlands | 1:1 | ?:? | ? | ?
64 | 13/07 | Germany | Argentina | 2:1 | ?:? | ? | ?
**Summary** | - | - | - | - | - | **35/62** | **10/62**
**Accuracy** | - | - | - | - | - | **56.5%** | **16.1%** 

### Comments

Match(es) | Comments
----------|-------------
1 | Pure guess only.
2-11 | Bloomberg future predictions used as training data.
12 | Dropped Bloomberg future predictions. Started using actual results only.
33 - 48 | Predictions all made on 23/6 as family holiday began.
49 - 52 | Predictions all made on 28/6 as I travelled to LA for useR! conference.
