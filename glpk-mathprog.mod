/* TSP, Traveling Salesman Problem */
/* Source: https://github.com/firedrakeproject/glpk/blob/master/examples/tsp.mod */

/* Written in GNU MathProg by Andrew Makhorin <mao@gnu.org> */

/* The Traveling Salesman Problem (TSP) is stated as follows.
   Let a directed graph G = (V, E) be given, where V = {1, ..., n} is
   a set of nodes, E <= V x V is a set of arcs. Let also each arc
   e = (i,j) be assigned a number c[i,j], which is the length of the
   arc e. The problem is to find a closed path of minimal length going
   through each node of G exactly once. */

param n, integer, >= 3;
/* number of nodes */

set V := 1..n;
/* set of nodes */

set E, within V cross V;
/* set of arcs */

param c{(i,j) in E};
/* distance from node i to node j */

var x{(i,j) in E}, binary;
/* x[i,j] = 1 means that the salesman goes from node i to node j */

minimize total: sum{(i,j) in E} c[i,j] * x[i,j];
/* the objective is to make the path length as small as possible */

s.t. leave{i in V}: sum{(i,j) in E} x[i,j] = 1;
/* the salesman leaves each node i exactly once */

s.t. enter{j in V}: sum{(i,j) in E} x[i,j] = 1;
/* the salesman enters each node j exactly once */

/* Constraints above are not sufficient to describe valid tours, so we
   need to add constraints to eliminate subtours, i.e. tours which have
   disconnected components. Although there are many known ways to do
   that, I invented yet another way. The general idea is the following.
   Let the salesman sell, say, cars, starting the travel from node 1,
   where he has n cars. If we require the salesman to sell exactly one
   car in each node, he will need to go through all nodes to satisfy
   this requirement, thus, all subtours will be eliminated. */

var y{(i,j) in E}, >= 0;
/* y[i,j] is the number of cars, which the salesman has after leaving
   node i and before entering node j; in terms of the network analysis,
   y[i,j] is a flow through arc (i,j) */

s.t. cap{(i,j) in E}: y[i,j] <= (n-1) * x[i,j];
/* if arc (i,j) does not belong to the salesman's tour, its capacity
   must be zero; it is obvious that on leaving a node, it is sufficient
   to have not more than n-1 cars */

s.t. node{i in V}:
/* node[i] is a conservation constraint for node i */

      sum{(j,i) in E} y[j,i]
      /* summary flow into node i through all ingoing arcs */

      + (if i = 1 then n)
      /* plus n cars which the salesman has at starting node */

      = /* must be equal to */

      sum{(i,j) in E} y[i,j]
      /* summary flow from node i through all outgoing arcs */

      + 1;
      /* plus one car which the salesman sells at node i */

solve;

printf "Optimal tour has length %d\n",
   sum{(i,j) in E} c[i,j] * x[i,j];
printf("From node   To node   Distance\n");
printf{(i,j) in E: x[i,j]} "      %3d       %3d   %8g\n",
   i, j, c[i,j];

data;

/* These data correspond to the symmetric instance ulysses22 from:

   Reinelt, G.: TSPLIB - A travelling salesman problem library.
   ORSA-Journal of the Computing 3 (1991) 376-84;
   http://elib.zib.de/pub/Packages/mp-testdata/tsp/tsplib 

   Coordinates 23 and 24 are not from the source,
   arbitrary values ​​were chosen to increase complexity. */

/* The optimal solution is 7119 */

param n := 24;

param : E : c :=
 1  2   509
 1  3   501
 1  4   312
 1  5  1019
 1  6   736
 1  7   656
 1  8    60
 1  9  1039
 1 10   726
 1 11  2314
 1 12   479
 1 13   448
 1 14   479
 1 15   619
 1 16   150
 1 17   342
 1 18   323
 1 19   635
 1 20   604
 1 21   596
 1 22   202
 1 23   390
 1 24    59
 2  1   509
 2  3   126
 2  4   474
 2  5  1526
 2  6  1226
 2  7  1133
 2  8   532
 2  9  1449
 2 10  1122
 2 11  2789
 2 12   958
 2 13   941
 2 14   978
 2 15  1127
 2 16   542
 2 17   246
 2 18   510
 2 19  1047
 2 20  1021
 2 21  1010
 2 22   364
 2 23   898
 2 24   451
 3  1   501
 3  2   126
 3  4   541
 3  5  1516
 3  6  1184
 3  7  1084
 3  8   536
 3  9  1371
 3 10  1045
 3 11  2728
 3 12   913
 3 13   904
 3 14   946
 3 15  1115
 3 16   499
 3 17   321
 3 18   577
 3 19   976
 3 20   952
 3 21   941
 3 22   401
 3 23   889
 3 24   446
 4  1   312
 4  2   474
 4  3   541
 4  5  1157
 4  6   980
 4  7   919
 4  8   271
 4  9  1333
 4 10  1029
 4 11  2553
 4 12   751
 4 13   704
 4 14   720
 4 15   783
 4 16   455
 4 17   228
 4 18    37
 4 19   936
 4 20   904
 4 21   898
 4 22   171
 4 23   569
 4 24   290
 5  1  1019
 5  2  1526
 5  3  1516
 5  4  1157
 5  6   478
 5  7   583
 5  8   996
 5  9   858
 5 10   855
 5 11  1504
 5 12   677
 5 13   651
 5 14   600
 5 15   401
 5 16  1033
 5 17  1325
 5 18  1134
 5 19   818
 5 20   808
 5 21   820
 5 22  1179
 5 23   629
 5 24  1077
 6  1   736
 6  2  1226
 6  3  1184
 6  4   980
 6  5   478
 6  7   115
 6  8   740
 6  9   470
 6 10   379
 6 11  1581
 6 12   271
 6 13   289
 6 14   261
 6 15   308
 6 16   687
 6 17  1077
 6 18   970
 6 19   342
 6 20   336
 6 21   348
 6 22   932
 6 23   425
 6 24   792
 7  1   656
 7  2  1133
 7  3  1084
 7  4   919
 7  5   583
 7  6   115
 7  8   667
 7  9   455
 7 10   288
 7 11  1661
 7 12   177
 7 13   216
 7 14   207
 7 15   343
 7 16   592
 7 17   997
 7 18   913
 7 19   236
 7 20   226
 7 21   237
 7 22   856
 7 23   394
 7 24   709
 8  1    60
 8  2   532
 8  3   536
 8  4   271
 8  5   996
 8  6   740
 8  7   667
 8  9  1066
 8 10   759
 8 11  2320
 8 12   493
 8 13   454
 8 14   479
 8 15   598
 8 16   206
 8 17   341
 8 18   278
 8 19   666
 8 20   634
 8 21   628
 8 22   194
 8 23   369
 8 24    94
 9  1  1039
 9  2  1449
 9  3  1371
 9  4  1333
 9  5   858
 9  6   470
 9  7   455
 9  8  1066
 9 10   328
 9 11  1387
 9 12   591
 9 13   650
 9 14   656
 9 15   776
 9 16   933
 9 17  1367
 9 18  1333
 9 19   408
 9 20   438
 9 21   447
 9 22  1239
 9 23   846
 9 24  1084
10  1   726
10  2  1122
10  3  1045
10  4  1029
10  5   855
10  6   379
10  7   288
10  8   759
10  9   328
10 11  1697
10 12   333
10 13   400
10 14   427
10 15   622
10 16   610
10 17  1046
10 18  1033
10 19    96
10 20   128
10 21   133
10 22   922
10 23   607
10 24   767
11  1  2314
11  2  2789
11  3  2728
11  4  2553
11  5  1504
11  6  1581
11  7  1661
11  8  2320
11  9  1387
11 10  1697
11 12  1838
11 13  1868
11 14  1841
11 15  1789
11 16  2248
11 17  2656
11 18  2540
11 19  1755
11 20  1777
11 21  1789
11 22  2512
11 23  1986
11 24  2369
12  1   479
12  2   958
12  3   913
12  4   751
12  5   677
12  6   271
12  7   177
12  8   493
12  9   591
12 10   333
12 11  1838
12 13    68
12 14   105
12 15   336
12 16   417
12 17   821
12 18   748
12 19   243
12 20   214
12 21   217
12 22   680
12 23   275
12 24   533
13  1   448
13  2   941
13  3   904
13  4   704
13  5   651
13  6   289
13  7   216
13  8   454
13  9   650
13 10   400
13 11  1868
13 12    68
13 14    52
13 15   287
13 16   406
13 17   789
13 18   698
13 19   311
13 20   281
13 21   283
13 22   645
13 23   208
13 24   503
14  1   479
14  2   978
14  3   946
14  4   720
14  5   600
14  6   261
14  7   207
14  8   479
14  9   656
14 10   427
14 11  1841
14 12   105
14 13    52
14 15   237
14 16   449
14 17   818
14 18   712
14 19   341
14 20   314
14 21   318
14 22   672
14 23   191
14 24   536
15  1   619
15  2  1127
15  3  1115
15  4   783
15  5   401
15  6   308
15  7   343
15  8   598
15  9   776
15 10   622
15 11  1789
15 12   336
15 13   287
15 14   237
15 16   636
15 17   932
15 18   764
15 19   550
15 20   528
15 21   535
15 22   785
15 23   230
15 24   677
16  1   150
16  2   542
16  3   499
16  4   455
16  5  1033
16  6   687
16  7   592
16  8   206
16  9   933
16 10   610
16 11  2248
16 12   417
16 13   406
16 14   449
16 15   636
16 17   436
16 18   470
16 19   525
16 20   496
16 21   486
16 22   319
16 23   423
16 24   167
17  1   342
17  2   246
17  3   321
17  4   228
17  5  1325
17  6  1077
17  7   997
17  8   341
17  9  1367
17 10  1046
17 11  2656
17 12   821
17 13   789
17 14   818
17 15   932
17 16   436
17 18   265
17 19   959
17 20   930
17 21   921
17 22   148
17 23   705
17 24   289
18  1   323
18  2   510
18  3   577
18  4    37
18  5  1134
18  6   970
18  7   913
18  8   278
18  9  1333
18 10  1033
18 11  2540
18 12   748
18 13   698
18 14   712
18 15   764
18 16   470
18 17   265
18 19   939
18 20   907
18 21   901
18 22   201
18 23   555
18 24   307
19  1   635
19  2  1047
19  3   976
19  4   936
19  5   818
19  6   342
19  7   236
19  8   666
19  9   408
19 10    96
19 11  1755
19 12   243
19 13   311
19 14   341
19 15   550
19 16   525
19 17   959
19 18   939
19 20    33
19 21    39
19 22   833
19 23   517
19 24   677
20  1   604
20  2  1021
20  3   952
20  4   904
20  5   808
20  6   336
20  7   226
20  8   634
20  9   438
20 10   128
20 11  1777
20 12   214
20 13   281
20 14   314
20 15   528
20 16   496
20 17   930
20 18   907
20 19    33
20 21    14
20 22   803
20 23   487
20 24   647
21  1   596
21  2  1010
21  3   941
21  4   898
21  5   820
21  6   348
21  7   237
21  8   628
21  9   447
21 10   133
21 11  1789
21 12   217
21 13   283
21 14   318
21 15   535
21 16   486
21 17   921
21 18   901
21 19    39
21 20    14
21 22   794
21 23   488
21 24   639
22  1   202
22  2   364
22  3   401
22  4   171
22  5  1179
22  6   932
22  7   856
22  8   194
22  9  1239
22 10   922
22 11  2512
22 12   680
22 13   645
22 14   672
22 15   785
22 16   319
22 17   148
22 18   201
22 19   833
22 20   803
22 21   794
22 23   557
22 24   156
23  1   390
23  2   898
23  3   889
23  4   569
23  5   629
23  6   425
23  7   394
23  8   369
23  9   846
23 10   607
23 11  1986
23 12   275
23 13   208
23 14   191
23 15   230
23 16   423
23 17   705
23 18   555
23 19   517
23 20   487
23 21   488
23 22   557
23 24   448
24  1    59
24  2   451
24  3   446
24  4   290
24  5  1077
24  6   792
24  7   709
24  8    94
24  9  1084
24 10   767
24 11  2369
24 12   533
24 13   503
24 14   536
24 15   677
24 16   167
24 17   289
24 18   307
24 19   677
24 20   647
24 21   639
24 22   156
24 23   448
;

end;
