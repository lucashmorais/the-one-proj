# EP3 Report

### Bus VANET-like Scenario

#### Description
In this experiment we aimed to simulate a specific type of VANET called Bus
VANET, which is basically a VANET that contains just buses. Collecting and
sharing data between buses and the city infrastructure will allow one to
improve this basic and vital service to the citizens, for example predict
new routes for buses and do a better schedule of them, reducing the time that
the citizens need to wait in the bus stop.

While designing the following experiments, we aimed to simulate how DTNs based
on several different routing protocols would behave while serving hosts that
moved like buses. In such scenario, buses travel in different routes along the
roads of an accurate model of Finland's capital, Helsinki, with transmission
range set to 50m and speed varying from 30 to 60 kilometers per hour. Such
values were chosen so as to be representative of the behavior of real buses in
a city environment and of the features that could expect from wireless
transmission protocols to be rolled out in the following years.

#### Test methodology
- Tests were described by 3 configuration files relying on index-run for generating 54 different parameter combinations.
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
|DirectDeliveryRouter |
|EpidemicRouter       |
|EpidemicOracleRouter |

|Number of hosts in each route| Total number of hosts |
|-----------------------------|-----------------------|
|32                           |128                    |
|64                           |256                    |
|128                          |512                    |

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

The experiments that we described should be useful for characterizing the
situations in which DTNs could be successfully used as bus VANETs. That being
the case, we found the need for developing a single performance for uniformly
judging the gathered results, which can be defined as the following:

* For every transmission scenario T_i there are measurements for Message
Delivery Probability (P_i), Average Latency (L_i) and Overhead Ratio (O_i).
    * The Message Delivery Probability is the chance that a message created
    withing simulation time will be delivered to the target host before the
    simulation times out.
    * The Average Latency is the average amount of time, in seconds, that it
    took for the successfully delivered messages to be delivered.
    * The Overhead Ratio is the ratio between the number of packet
    transmissions and the number of messages created by the whole system. This
    value will always be in [1, +Inf[, where lower figures correspond to more
    efficient use of the transmission channels.
* Based on that, every scenario T_i is assigned a quality grade Q_i = (p_i,
l_i, o_i) = (floor(P_i * 20), - log2(L_i), - floor(O_i))
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

In our opinion, this is an interesting performance scale because Delivery
Probability is the most important performance metric we have under analysis,
followed by Average Latency and Overhead Ratio.

> TODO: Add footnote explaining the VANET acronym.

#### Results

In the following table we display the results of all the 54 tests that were
conducted for the scenario above, ordered according to the performance scale
described from best to worst.

Index|Routing protocol|# Hosts in each route|Buffer size|Transmission speed (bps)|P|L|O
-|-|-|-|-|-|-|-
0|EpidemicOracleRouter|128|2048M|1M|19|-6|-673
1|EpidemicOracleRouter|128|2048M|128k|19|-6|-673
2|EpidemicOracleRouter|128|64M|128k|19|-6|-6180
3|EpidemicOracleRouter|128|64M|1M|19|-6|-6180
4|EpidemicRouter|64|2048M|1M|18|-7|-206
5|EpidemicOracleRouter|64|2048M|1M|18|-7|-292
6|EpidemicOracleRouter|64|2048M|128k|18|-7|-292
7|EpidemicRouter|128|2048M|1M|18|-7|-446
8|EpidemicOracleRouter|64|64M|128k|18|-7|-695
9|EpidemicOracleRouter|64|64M|1M|18|-7|-695
10|EpidemicOracleRouter|32|2048M|128k|18|-8|-117
11|EpidemicOracleRouter|32|2048M|1M|18|-8|-117
12|EpidemicOracleRouter|32|64M|1M|18|-8|-121
13|EpidemicOracleRouter|32|64M|128k|18|-8|-121
14|EpidemicRouter|64|64M|1M|17|-7|-235
15|EpidemicRouter|128|64M|1M|17|-7|-527
16|EpidemicRouter|32|2048M|1M|17|-8|-91
17|EpidemicRouter|32|64M|1M|17|-8|-95
18|EpidemicRouter|64|2048M|128k|17|-8|-179
19|EpidemicRouter|64|64M|128k|17|-8|-184
20|EpidemicRouter|128|64M|128k|17|-8|-405
21|EpidemicRouter|128|2048M|128k|17|-8|-406
22|EpidemicRouter|32|64M|128k|16|-8|-79
23|EpidemicRouter|32|2048M|128k|16|-8|-79
24|DirectDeliveryRouter|64|2048M|128k|9|-9|0
25|DirectDeliveryRouter|64|64M|128k|9|-9|0
26|DirectDeliveryRouter|64|64M|1M|9|-9|0
27|DirectDeliveryRouter|64|2048M|1M|9|-9|0
28|DirectDeliveryRouter|32|2048M|128k|7|-8|0
29|DirectDeliveryRouter|32|64M|1M|7|-8|0
30|DirectDeliveryRouter|32|64M|128k|7|-8|0
31|DirectDeliveryRouter|32|2048M|1M|7|-8|0
32|DirectDeliveryRouter|128|2048M|1M|6|-8|0
33|DirectDeliveryRouter|128|64M|1M|6|-8|0
34|DirectDeliveryRouter|64|1M|1M|5|-7|0
35|DirectDeliveryRouter|128|2048M|128k|5|-8|0
36|DirectDeliveryRouter|128|64M|128k|5|-8|0
37|DirectDeliveryRouter|64|1M|128k|5|-8|0
38|DirectDeliveryRouter|32|1M|1M|4|-7|0
39|DirectDeliveryRouter|32|1M|128k|4|-7|0
40|EpidemicOracleRouter|64|1M|128k|4|-7|-264
41|EpidemicOracleRouter|64|1M|1M|4|-7|-264
42|EpidemicOracleRouter|128|1M|128k|4|-7|-1584
43|EpidemicOracleRouter|128|1M|1M|4|-7|-1584
44|EpidemicOracleRouter|32|1M|128k|3|-7|-91
45|EpidemicOracleRouter|32|1M|1M|3|-7|-91
46|DirectDeliveryRouter|128|1M|128k|3|-8|0
47|DirectDeliveryRouter|128|1M|1M|3|-8|0
48|EpidemicRouter|32|1M|1M|3|-8|-110
49|EpidemicRouter|64|1M|128k|3|-8|-292
50|EpidemicRouter|64|1M|1M|2|-7|-520
51|EpidemicRouter|32|1M|128k|2|-8|-112
52|EpidemicRouter|128|1M|128k|2|-8|-3504
53|EpidemicRouter|128|1M|1M|2|-8|-6079

#### Analysis

##### Facts

With respect to the results just presented, we can notice the following:

1. Only the EpidemicOracleRouter and the EpidemicRouter protocols are able to
display Delivery Probabilities higher than 70% for at least half of simulation
scenario.

2. EpidemicOracleRouter and EpidemicRouter are much more taxing on the
transmission network than thde DirectDeliveryRouter routing protocol. This is
kind of obvious since DirectDeliverRouter does not store buffers or has some
complex logic behind it, just send the message to the final destination,
reducing the overhead ratio.

3. When all other parameters are fixed, increasing buffer size will usually
improve delivery probability.

4. For the smallest buffer size, EpidemicRouter and EpidemicOracleRouter
protocols perform the worst, while DirectDeliverRouter gives the best results.
The Epidemics routing protocols need to store data about messages to work well,
thus if buffer is too small they are not the best choice.

5. With all other parameters kept stable, changing the routing protocol from
EpidemicRouter to EpidemicOracleRouter would usually improve delivery
probability (see, for example, \#7 vs \#0 and \#15 vs \#3)

6. With transmission speed is set to 1 Mbps and buffer size set to 1MB,
changing the routing protocol from either EpidemicRouter or
EpidemicOracleRouter to DirectDeliveryRouter always lead to higher delivery
probability or much lower overhead ratio with similar delivery probability
(see, for example, \#41 vs \#34 and \#53 vs \#47)

##### Rationale

* Since EpidemicRouter and EpidemicOracleRouter are protocols that rely heavily
on flooding - not bothering too much with keeping resource utilization down -
these protocols should usually lead to the highest delivery probabilities and
lowest latencies, as facts (1) and (2) show. This also explains why lower
buffer sizes tend to disfavor these protocols, as facts (3), (4) and (6) show.

* Given that the EpidemicRouter protocol doesn't rely on any historical data
about network topology to make routing decisions, it is heavily dependent on
the speed with which it may flood the network with the packets to be
transmitted. That being the case, improving the transmission speed will usually
improve the delivery probability of such protocol.

* Since the EpidemicOracleRouter protocol - in contrast with the EpidemicRouter
it is based upon - may take information about the contacts that hosts may have
made with each other in the past into account for performing routing decisions,
it is less dependent on flood speed than EpidemicRouter.  It also tends to lead
to more efficient use of message buffers than the latter protocol and, thus,
higher delivery probability, as fact (5) indicates.

#### Conclusion

The set of tests that we described above were useful for describing each
routing protocols should be used for several different scenarios involving
Bus VANET's. Concretly, we see that the EpidemicOracleRouter should be the
routing protocol of choice whenever available message buffers are not too small
