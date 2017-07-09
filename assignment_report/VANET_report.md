# EP3 Report

### VANET-like Scenario
#### Description
While designing the following experiments, we aimed to simulate how DTNs based on several different routing protocols would behave while serving hosts that moved like cars. In such scenario, hosts travel along the roads of an accurate model of Finland's capital, Helsinki, with transmission range set to 50m and speed varying from 30 to 60 kilometers per hour. Such values were chosen so as to be representative of the behavior of real cars in a city environment and of the features that could expect from wireless transmission protocols to be rolled out in the following years.

#### Test methodology
- Tests were described by 3 configuration files relying on index-run for generating, each, 30 different parameter combinations.
- All tests were run once with the same random seed.
- The tables that follow describe the most relevant parameters explored for this scenario.
- The performance of the DTNs for each particular configuration was judged according to a single performance scale that we discuss in a next subsection.

##### Parameter-set tables
The following tables describe all the test configurations that we run the simulation with.

|Transmission range|
|------------------|
|50 m|

|Average period of packet creation|
|---------------------------------|
|30s|

|Transmission Speed|
|------------------|
|128 KB/s          |
|1 MB/s            |

|Routing Protocols    |
|---------------------|
|SprayAndWaitRouter   |
|DirectDeliveryRouter |
|EpidemicRouter       |
|EpidemicOracleRouter |

|Number of hosts|
|---------------|
|32             |
|256            |
|2048           |

|Buffer size|
|---------------|
|1M             |
|64M            |
|2048M          |

|Packet TTL|
|----------|
|5h|

|Simulation time|
|---------------|
|50 min|

##### Defining a single performance scale
The experiments that we described should be useful for characterizing the situations in which DTNs could be successfully used as VANETs. That being the case, we found the need for developing a single performance for uniformly judging the gathered results, which can be defined as the following:

* For every transmission scenario T_i there are measurements for Message Delivery Probability (P_i), Average Latency (L_i) and Overhead Ratio (O_i).
    * The Message Delivery Probability is the chance that a message created withing simulation time will be delivered to the target host before the simulation times out.
    * The Average Latency is the average amount of time, in seconds, that it took for the successfully delivered messages to be delivered.
    * The Overhead Ratio is the ratio between the number of packet transmissions and the number of messages created by the whole system. This value will always be in [1, +Inf[, where lower figures correspond to more efficient use of the transmission channels.
* Based on that, every scenario T_i is assigned a quality grade Q_i = (p_i, l_i, o_i) = (floor(P_i * 20), - log2(L_i), - floor(O_i))
* We say that T_i is better than T_j if, and only if:
    1. p_i > p_j, or
    2. p_i == p_j and l_i > l_j, or
    3. p_i == p_j and l_i == l_j and o_i > o_j

The following Python2 snippet expresses the same performance comparison criterion:
```python
from math import log

class TQuality:
    def __init__(self, del_prob, avg_latency, ovh_ratio):
        self.p =   int(del_prob * 20)
        self.l = - int(log(avg_latency) / log(2))
        self.o = - int(ovh_ratio)

    # Method for comparing two transmission quality descriptors.
    #
    # @otherTQ: Transmission quality descriptor to compare with.
    # @return:  Positive, if this object describes better transmission quality;
    #           Negative, if this object describes worse transmission quality;
    #           Zero, if both objects correspond to equivalent transmission quality.
    def compareTo(self, otherTQ):
        if (self.p > otherTQ.p):
            return 1;
        elif (self.p == otherTQ.p and self.l > otherTQ.l):
            return 1;
        elif (self.p == otherTQ.p and self.l == otherTQ.l and self.o > otherTQ.o):
            return 1;
        elif (self.p == otherTQ.p and self.l == otherTQ.l and self.o == otherTQ.o):
            return 0;
        else:
            return -1;
```

In our opinion, this is an interesting performance scale because Delivery Probability is the most important performance metric we have under analysis, followed by Average Latency and Overhead Ratio.

> TODO: Add footnote explaining the VANET acronym.

#### Results
In the following table we display the results of all the 72 tests that were conducted for the scenario above, ordered according to the performance scale described from best to worst.

Index|Routing protocol|# Hosts|Buffer size|Transmission speed (bps)|P|L|O
-|-|-|-|-|-|-|-
0|EpidemicOracleRouter|2048|2048M|128k|20|-5|-3005
1|EpidemicOracleRouter|2048|2048M|1M|20|-5|-3005
2|EpidemicOracleRouter|2048|64M|128k|20|-5|-37272
3|EpidemicOracleRouter|2048|64M|1M|20|-5|-37272
4|EpidemicRouter|2048|2048M|1M|18|-7|-2161
5|EpidemicRouter|2048|64M|1M|18|-7|-2843
6|EpidemicRouter|256|2048M|1M|16|-8|-252
7|EpidemicRouter|256|64M|1M|16|-8|-253
8|EpidemicOracleRouter|256|2048M|128k|16|-8|-353
9|EpidemicOracleRouter|256|2048M|1M|16|-8|-353
10|EpidemicOracleRouter|256|64M|128k|16|-8|-363
11|EpidemicOracleRouter|256|64M|1M|16|-8|-363
12|EpidemicRouter|2048|2048M|128k|14|-9|-2042
13|EpidemicRouter|2048|64M|128k|14|-9|-2042
14|SprayAndWaitRouter|256|64M|1M|10|-9|-9
15|SprayAndWaitRouter|256|2048M|1M|10|-9|-9
16|EpidemicRouter|256|64M|128k|9|-9|-174
17|EpidemicRouter|256|2048M|128k|9|-9|-174
18|SprayAndWaitRouter|256|1M|1M|7|-9|-13
19|EpidemicOracleRouter|32|64M|1M|7|-10|-29
20|EpidemicOracleRouter|32|2048M|1M|7|-10|-29
21|EpidemicOracleRouter|32|64M|128k|7|-10|-29
22|EpidemicOracleRouter|32|2048M|128k|7|-10|-29
23|SprayAndWaitRouter|2048|2048M|1M|6|-9|-14
24|SprayAndWaitRouter|256|64M|128k|6|-9|-14
25|SprayAndWaitRouter|256|2048M|128k|6|-9|-14
26|SprayAndWaitRouter|2048|64M|1M|6|-9|-14
27|SprayAndWaitRouter|2048|1M|1M|6|-9|-15
28|SprayAndWaitRouter|32|64M|1M|6|-10|-9
29|SprayAndWaitRouter|32|2048M|1M|6|-10|-9
30|EpidemicRouter|32|64M|1M|6|-10|-12
31|EpidemicRouter|32|2048M|1M|6|-10|-12
32|SprayAndWaitRouter|2048|64M|128k|5|-10|-19
33|SprayAndWaitRouter|2048|2048M|128k|5|-10|-19
34|SprayAndWaitRouter|2048|1M|128k|4|-10|-23
35|DirectDeliveryRouter|32|2048M|1M|3|-9|0
36|DirectDeliveryRouter|2048|2048M|1M|3|-9|0
37|DirectDeliveryRouter|32|64M|1M|3|-9|0
38|DirectDeliveryRouter|2048|1M|1M|3|-9|0
39|DirectDeliveryRouter|2048|64M|1M|3|-9|0
40|EpidemicRouter|32|64M|128k|3|-10|-7
41|SprayAndWaitRouter|32|2048M|128k|3|-10|-7
42|SprayAndWaitRouter|32|64M|128k|3|-10|-7
43|EpidemicRouter|32|2048M|128k|3|-10|-7
44|DirectDeliveryRouter|2048|64M|128k|2|-9|0
45|DirectDeliveryRouter|256|1M|1M|2|-9|0
46|DirectDeliveryRouter|256|2048M|1M|2|-9|0
47|DirectDeliveryRouter|2048|1M|128k|2|-9|0
48|DirectDeliveryRouter|256|64M|1M|2|-9|0
49|DirectDeliveryRouter|2048|2048M|128k|2|-9|0
50|SprayAndWaitRouter|256|1M|128k|2|-9|-33
51|EpidemicOracleRouter|256|1M|128k|2|-9|-376
52|EpidemicOracleRouter|256|1M|1M|2|-9|-376
53|EpidemicRouter|256|1M|1M|2|-9|-532
54|DirectDeliveryRouter|32|1M|1M|1|-7|0
55|SprayAndWaitRouter|32|1M|1M|1|-8|-14
56|DirectDeliveryRouter|256|2048M|128k|1|-9|0
57|DirectDeliveryRouter|256|1M|128k|1|-9|0
58|DirectDeliveryRouter|256|64M|128k|1|-9|0
59|EpidemicRouter|2048|1M|1M|1|-9|-60068
60|DirectDeliveryRouter|32|2048M|128k|1|-10|0
61|DirectDeliveryRouter|32|64M|128k|1|-10|0
62|EpidemicOracleRouter|32|1M|128k|0|-7|-39
63|EpidemicOracleRouter|32|1M|1M|0|-7|-39
64|EpidemicOracleRouter|2048|1M|1M|0|-7|-52720
65|EpidemicOracleRouter|2048|1M|128k|0|-7|-52720
66|DirectDeliveryRouter|32|1M|128k|0|-8|0
67|SprayAndWaitRouter|32|1M|128k|0|-8|-33
68|EpidemicRouter|32|1M|1M|0|-8|-36
69|EpidemicRouter|32|1M|128k|0|-8|-81
70|EpidemicRouter|256|1M|128k|0|-9|-952
71|EpidemicRouter|2048|1M|128k|0|-9|-40119

#### Analysis
##### Facts
With respect to the results just presented, we can notice the following:
1. Only the EpidemicOracleRouter and the EpidemicRouter protocols are able to display Delivery Probabilities higher than 70% for any simulation scenario.
2. EpidemicOracleRouter and EpidemicRouter are usually much more taxing on the transmission network than all other routing protocols: if scenarios based on SprayAndWaitRouter and SprayAndWaitRouter never display overhead ratios above 33 (which occurs for scenario \#50), the same metric is as high as 3005 for the best-performing EpidemicOracleRouter scenario or as high as 37272 for other top-five scenarios using the same protocol, with EpidemicRouter scenarios showing similar figures.
3. When all other parameters are fixed, increasing buffer size will usually improve delivery probability.
4. For the smallest buffer size, EpidemicRouter and EpidemicOracleRouter protocols perform the worst, while SprayAndWaitRouter gives the best results.
5. For the EpidemicRouter protocol, increasing the transmission speed from 128K to 1M while maintaining all other parameters always improved delivery probability (see, for example, \#12 vs \#4 and \#16 vs \#7)
6. For the EpidemicOracleRouter protocol, increasing the transmission speed from 128K to 1M while maintaining all other parameters never improved delivery probability (see, for example, \#0 vs \#1 and \#10 vs \#11)
7. With all other parameters kept stable, changing the routing protocol from EpidemicRouter to EpidemicOracleRouter would usually improve delivery probability (see, for example, \#30 vs \#19 and \#4 vs \#1)
8. With transmission speed is set to 1 Mbps and buffer size set to 1MB, changing the routing protocol from either EpidemicRouter or EpidemicOracleRouter to DirectDeliveryRouter always lead to higher delivery probability or much lower overhead ratio with similar delivery probability (see, for example, \#63 vs \#54 and \#59 vs \#38)
9. With buffer size set to 1MB, changing the protocol from either EpidemicRouter, EpidemicOracleRouter or DirectDeliveryRouter to SprayAndWaitRouter would usually lead to much higher delivery probability (see, for example, \#52 vs \#18 or \#47 vs \#34)

##### Rationale
* Since EpidemicRouter and EpidemicOracleRouter are protocols that rely heavily on flooding - not bothering too much with keeping resource utilization down - these protocols should usually lead to the highest delivery probabilities and lowest latencies, as facts (1) and (2) show. This also explains why lower buffer sizes tend to disfavor these protocols, as facts (3), (4), (8) and (9) show.
* Although the SprayAndWaitRouter protocol is also based replication, the fact that it limits the number of copies that each message may have on the system make it much more robust in low-buffer scenarios. This contributes to facts (4), (8) and (9).
* The fact that SprayAndWaitRouter makes use of some degree of message replication while DirectDeliveryRouter does not explains fact (9), since replication should usually lead to higher delivery probability.
* Given that the EpidemicRouter protocol doesn't rely on any historical data about network topology to make routing decisions, it is heavily dependent on the speed with which it may flood the network with the packets to be transmitted. That being the case, improving the transmission speed will usually improve the delivery probability of such protocol, as fact (5) reveals.
* Since the EpidemicOracleRouter protocol - in contrast with the EpidemicRouter it is based upon - may take information about the contacts that hosts may have made with each other in the past into account for performing routing decisions, it is less dependent on flood speed than EpidemicRouter, as fact (6) suggests. It also tends to lead to more efficient use of message buffers than the latter protocol and, thus, higher delivery probability, as fact (7) indicates.

#### Conclusion
The set of tests that we described above were useful for describing each routing protocols should be used for several different scenarios involving VANET's. Concretly, we see that the EpidemicOracleRouter should be the routing protocol of choice whenever available message buffers are not too small and higher network utilization is not a great concern.
