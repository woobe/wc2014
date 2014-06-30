World Cup 2014 Data Analysis and Predictions
======

This is an experiment to see whether data mining can outperform my friends. So far data mining has the upper hand :)

### Data Source

1. http://fivethirtyeight.com/interactives/world-cup/
2. http://www.bloomberg.com/visual-data/world-cup/
3. https://www.betfair.com/sport

### Results

Match | Date | Team 1 | Team 2 | Predictions | Results | Correct WDL? | Correct Score? | Comments
------|------|--------|--------|-------------|---------|--------------|---------------|---------
1 | 12/06/2014 | Brazil | Croatia | 4:0 | 3:1 | Yes | No | Pure guess.
2 | 13/06/2014 | Mexico | Cameroon | 1:0 | 1:0 | Yes | Yes | Bloomberg predictions included as training data.
3 | 13/06/2014 | Spain | Netherlands | 1:0 | 1:5 | No | No | Bloomberg predictions included as training data.
4 | 13/06/2014 | Chile | Australia | 1:0 | 3:1 | Yes | No | Bloomberg predictions included as training data.
5 | 14/06/2014 | Colombia | Greece | 1:0 | 3:0 | Yes | No | Bloomberg predictions included as training data.
6 | 14/06/2014 | Uruguay | Costa Rica | 2:0 | 1:3 | No | No | Bloomberg predictions included as training data.
7 | 14/06/2014 | England | Italy | 1:1 | 1:2 | No | No | Bloomberg predictions included as training data.
8 | 15/06/2014 | Ivory Coast | Japan | 1:1 | 2:1 | No | No | Bloomberg predictions included as training data.
9 | 15/06/2014 | Switzerland | Ecuador | 1:1 | 2:1 | No | No | Bloomberg predictions included as training data.
10 | 15/06/2014 | France | Honduras | 2:0 | 3:0 | Yes | No | Bloomberg predictions included as training data.
11 | 15/06/2014 | Argentina | Bosnia | 2:1 | 2:1 | Yes | Yes | Bloomberg predictions included as training data.
12 | 16/06/2014 | Germany | Portugal | 1:1 | 4:0 | No | No | Started using only previous results as training data.
13 | 16/06/2014 | Iran | Nigeria | 1:1 | 0:0 | Yes | No |
14 | 16/06/2014 | Ghana | USA | 1:1 | 1:2 | No | No |
15 | 17/06/2014 | Belgium | Algeria | 2:1 | 2:1 | Yes | Yes |
16 | 17/06/2014 | Brazil | Mexico | 3:1 | 0:0 | No | No |
17 | 17/06/2014 | Russia | S Korea | 1:1 | 1:1 | Yes | Yes |
18 | 18/06/2014 | Australia | Netherlands | 1:3 | 2:3 | Yes | No |
19 | 18/06/2014 | Spain | Chile | 2:3 | 0:2 | Yes | No |
20 | 18/06/2014 | Cameroon | Croatia | 1:1 | 0:4 | No | No |
21 | 19/06/2014 | Colombia | Ivory Coast | 2:1 | 2:1 | Yes | Yes |
22 | 19/06/2014 | Uruguay | England | 2:2 | 2:1 | No | No |
23 | 19/06/2014 | Japan | Greece | 0:0 | 1:1 | Yes | No |
24 | 20/06/2014 | Italy | Costa Rica | 2:1 | 0:1 | No | No |
25 | 20/06/2014 | Switzerland | France | 1:2 | 2:5 | Yes | No |
26 | 20/06/2014 | Honduras | Ecuador | 1:2 | 1:2 | Yes | Yes |
27 | 21/06/2014 | Argentina | Iran | 2:1 | 1:0 | Yes | No |
28 | 21/06/2014 | Germany | Ghana | 3:1 | 2:2 | No | No |
29 | 21/06/2014 | Nigeria | Bosnia | 1:2 | 1:0 | No | No |
30 | 22/06/2014 | Belgium | Russia | 2:1 | 1:0 | Yes | No |
31 | 22/06/2014 | S Korea | Algeria | 1:1 | 2:4 | No | No |
32 | 22/06/2014 | USA | Portugal | 2:2 | 2:2 | Yes | Yes |
33 | 23/06/2014 | Netherlands | Chile | 2:2 | 2:0 | No | No | Family holiday began. Predictions made on 23/06/2014.
34 | 23/06/2014 | Australia | Spain | 1:2 | 0:3 | Yes | No | Predictions made on 23/06/2014.
35 | 23/06/2014 | Cameroon | Brazil | 1:2 | 1:4 | Yes | No | Predictions made on 23/06/2014.
36 | 23/06/2014 | Croatia | Mexico | 1:1 | 1:3 | No | No | Predictions made on 23/06/2014.
37 | 24/06/2014 | Costa Rica | England | 2:2 | 0:0 | Yes | No | Predictions made on 23/06/2014.
38 | 24/06/2014 | Italy | Uruguay | 1:1 | 0:1 | No | No | Predictions made on 23/06/2014.
39 | 24/06/2014 | Japan | Colombia | 1:2 | 1:4 | Yes | No | Predictions made on 23/06/2014.
40 | 24/06/2014 | Greece | Ivory Coast | 1:1 | 2:1 | No | No | Predictions made on 23/06/2014.
41 | 25/06/2014 | Nigeria | Argentina | 1:2 | 2:3 | Yes | No | Predictions made on 23/06/2014.
42 | 25/06/2014 | Bosnia | Iran | 1:1 | 3:1 | No | No | Predictions made on 23/06/2014.
43 | 25/06/2014 | Ecuador | France | 1:2 | 0:0 | No | No | Predictions made on 23/06/2014.
44 | 25/06/2014 | Honduras | Switzerland | 1:2 | 0:3 | Yes | No | Predictions made on 23/06/2014.
45 | 26/06/2014 | Portugal | Ghana | 2:1 | 2:1 | Yes | Yes | Predictions made on 23/06/2014.
46 | 26/06/2014 | USA | Germany | 1:2 | 0:1 | Yes | No | Predictions made on 23/06/2014.
47 | 26/06/2014 | Algeria | Russia | 1:2 | 1:1 | No | No | Predictions made on 23/06/2014.
48 | 26/06/2014 | S Korea | Belgium | 1:2 | 0:1 | Yes | No | Predictions made on 23/06/2014. Returned from holiday.
49 | 28/06/2014 | Brazil | Chile | 2:2 | 1:1 | Yes | No | Setting off for useR! conference. Predictions made on 28/06/2014.
50 | 28/06/2014 | Colombia | Uruguay | 1:1 | 2:0 | No | No | Predictions made on 28/06/2014.
51 | 29/06/2014 | Netherlands | Mexico | 2:1 | 2:1 | Yes | Yes | Predictions made on 28/06/2014.
52 | 29/06/2014 | Costa Rica | Greece | 1:1 | 1:1 | Yes | Yes | Predictions made on 28/06/2014.
53 | 30/06/2014 | France | Nigeria | 2:1 | ?:? | ? | ? | Predictions made on 28/06/2014.
54 | 30/06/2014 | Germany | Algeria | 2:1 | ?:? | ? | ? | Predictions made on 28/06/2014.
55 | 01/07/2014 | Argentina | Switzerland | 3:1 | ?:? | ? | ? | Predictions made on 28/06/2014.
56 | 01/07/2014 | Belgium | USA | 2:1 | ?:? | ? | ? | Predictions made on 28/06/2014.
Summary | - | - | - | - | - | 30/52 | 10/52 | Correct Predictions  / Matches Played
Summary | - | - | - | - | - | 57.7% | 19.2% | Accuracy


