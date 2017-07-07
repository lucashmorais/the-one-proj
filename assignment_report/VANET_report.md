# EP3 Report

### VANET-like Scenario
#### Description
In the following experiments, we aimed to simulate how DTNs based on several different routing protocols would behave while serving hosts that moved like cars. In such scenario, hosts travel along the roads of an accurate model of Finland's capital, Helsinki, with transmission range set to 50m and speed varying from 30 to 60 kilometers per hour. Such values were chosen so as to be representative of the behavior of real cars in a city environment and of features that could expect from wireless transmission protocols to be rolled out in the following years.

> TODO: Improve writing.
>
> TODO: Study how the remaining protocols work.

#### Test methodology
- Tests were described by 3 configuration files relying on index-run for generating, each, 30 different parameter combinations.
- We also conducted some tests for checking whether performance figures would vary much if simulation time were increased from 50 min to 12h.
- All tests were run once with the same random seed.
- The tables that follow describe the most relevant parameters explored for this scenario.
- The performance of the DTNs for each particular configuration was judged according to a single performance scale that we discuss in a next subsection.

> Add LaTeX citation to the tables.

##### Parameter-set tables
The following tables describe all the test configurations that we run the simulation with.

|Transmission range|
|------------------|
|50 m|

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

#### Results and Analysis
In the following table we display the results of all the 90 tests that were conducted for the scenario above, ordered according to the performance scale described.
