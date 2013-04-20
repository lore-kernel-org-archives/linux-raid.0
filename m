From: Andrei Banu <andrei.banu@redhost.ro>
Subject: Re: Incredibly poor performance of mdraid-1 with 2 SSD Samsung 840
 PRO
Date: Sun, 21 Apr 2013 02:25:14 +0300
Message-ID: <517323DA.5010209@redhost.ro>
References: <5171CBF9.9020701@redhost.ro> <CAH3kUhEaZGON=fAyVMZOz5fH_DcfKv=hCa96UCeK4pN7k81c_Q@mail.gmail.com> <51725458.7020109@redhost.ro> <CAH3kUhHxBiqugFQm=PPJNNe9jOdKy0etUjQNsoDz_LJNUCLCCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhHxBiqugFQm=PPJNNe9jOdKy0etUjQNsoDz_LJNUCLCCQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The previous test was done with "noop" for scheduler (the speed test 
completed at about 8MB/s). Then I rebooted the server and redone the 
test (also with noop) and the result was slightly better but not as it 
should be (21MB/s). A third test 5-10 minute later (after the load 
subsided) completed at 16MB/s.  A fourth test ended with 14.6MB/s.

Something else: the weekly auto raid check started a little time ago and 
it's going at an average of 60MB/s (anywhere between 25 and 100MB/s) 
with noop, cfq and deadline. A raid check with ordinary mechanical 
drives gets done at about 160MB/s on the outer cylinders. Why are these 
SSDs so slow?

These are the result from the 21MB/s test (5 seconds delay):

Device:            tps    kB_read/s    kB_wrtn/s    kB_read kB_wrtn
sda             204.94      1918.02       389.30    1367719 277605
sdb             154.80      1196.21       389.30     853008 277605
md1               0.65         2.59         0.00 1848          0
md2             355.45      3106.05       388.53    2214890 277056
md0               1.10         2.90         0.01 2069          9

Device:            tps    kB_read/s    kB_wrtn/s    kB_read kB_wrtn
sda             583.40     42764.80     29452.90     213824 147264
sdb             234.80     23172.00     14950.50     115860 74752
md1               0.00         0.00         0.00 0          0
md2            8079.60     65886.40     29862.40     329432 149312
md0               0.00         0.00         0.00 0          0

Device:            tps    kB_read/s    kB_wrtn/s    kB_read kB_wrtn
sda              15.00         1.60      1740.00          8 8700
sdb              15.00         0.00      7196.80          0 35984
md1               0.00         0.00         0.00 0          0
md2             333.20         1.60      1330.40          8 6652
md0               0.00         0.00         0.00 0          0

Device:            tps    kB_read/s    kB_wrtn/s    kB_read kB_wrtn
sda             167.20       538.40     37432.80       2692 187164
sdb              86.20        16.00     33688.80         80 168444
md1               0.00         0.00         0.00 0          0
md2            9510.80       572.80     37934.40       2864 189672
md0               0.00         0.00         0.00 0          0

Device:            tps    kB_read/s    kB_wrtn/s    kB_read kB_wrtn
sda             150.20       585.60     29090.40       2928 145452
sdb              71.20        44.00     30355.20        220 151776
md1               0.00         0.00         0.00 0          0
md2            7306.20       615.20     28998.40       3076 144992
md0               0.00         0.00         0.00 0          0

Device:            tps    kB_read/s    kB_wrtn/s    kB_read kB_wrtn
sda             257.20      1624.00      9913.80       8120 49569
sdb             137.20       372.00     21438.60       1860 107193
md1               0.00         0.00         0.00 0          0
md2            2600.80      1991.20      9504.00       9956 47520
md0               0.00         0.00         0.00 0          0

Device:            tps    kB_read/s    kB_wrtn/s    kB_read kB_wrtn
sda             186.80       972.80       292.70       4864 1463
sdb             150.40       733.60       292.70       3668 1463
md1               0.00         0.00         0.00 0          0
md2             283.80      1706.40       291.20       8532 1456
md0               0.00         0.00         0.00 0          0

If you have any idea what can I do to improve this please let me know.

Thanks!!
