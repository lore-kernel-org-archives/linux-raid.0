From: "JaniD++" <djani22@dynamicweb.hu>
Subject: built in readahead? - chunk size question
Date: Thu, 12 Jan 2006 20:18:14 +0100
Message-ID: <04a601c617ac$f48bbc50$a400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello, list,

I have found one interesting issue.
I use 4 disk node with NBD, and the concentrator distributes the load equal
thanks to 32KB chunksize RAID0 inside.

At this time i am working on the system upgrade, and found one interesting
issue, and possibly one bottleneck on the system.

The concentrator shows this with  iostat -d -k -x 10:
(I have marked the interesting parts with [ ])

Device:    rrqm/s wrqm/s   r/s   w/s  rsec/s  wsec/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await  svctm  %util
nbd0        54.15   0.00 45.85  0.00 6169.83    0.00  3084.92     0.00
134.55     1.43   31.11   7.04  32.27           <--node-1
nbd1        58.24   0.00 44.06  0.00 6205.79    0.00  [3102.90]     0.00
140.86   516.74 11490.79  22.70 100.00 <--node-2
nbd2        55.84   0.00 44.76  0.00 6159.44    0.00  3079.72     0.00
137.62     1.51   33.73   6.88  30.77
nbd3        55.34   0.00 45.05  0.00 6169.03    0.00  3084.52     0.00
136.92     1.07   23.79   5.72  25.77
md31         0.00   0.00 401.70  0.10 24607.39    1.00 12303.70     0.50
61.25     0.00    0.00   0.00   0.00

The "old" node-1 shows this:
Device:    rrqm/s wrqm/s   r/s   w/s  rsec/s  wsec/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await  svctm  %util
hda        140.26   0.80  9.19  3.50 1195.60   34.37   597.80    17.18
96.94     0.20   15.43  11.81  14.99
hdc        133.37   0.00  8.89  3.30 1138.06   26.37   569.03    13.19
95.54     0.17   13.85  11.15  13.59
hde        142.76   1.40 13.99  3.90 1253.95   42.36   626.97    21.18
72.49     0.29   16.31  10.00  17.88
hdi        136.56   0.20 13.19  3.10 1197.20   26.37   598.60    13.19
75.14     0.33   20.12  12.82  20.88
hdk        134.07   0.30 13.89  3.40 1183.62   29.57   591.81    14.79
70.20     0.28   16.30  10.87  18.78
hdm        137.46   0.20 13.39  3.80 1205.99   31.97   603.00    15.98
72.05     0.38   21.98  12.67  21.78
hdo        125.07   0.10 11.69  3.20 1093.31   26.37   546.65    13.19
75.22     0.32   21.54  14.23  21.18
hdq        131.37   1.20 12.49  3.70 1150.85   39.16   575.42    19.58
73.53     0.30   18.77  12.04  19.48
hds        130.97   1.40 13.59  4.10 1155.64   43.96   577.82    21.98
67.84     0.57   32.37  14.80  26.17
sda        148.55   1.30 10.09  3.70 1269.13   39.96   634.57    19.98
94.96     0.30   21.81  14.86  20.48
sdb        131.07   0.10  9.69  3.30 1125.27   27.17   562.64    13.59
88.74     0.18   13.92  11.31  14.69
md0          0.00   0.00 1611.49  5.29 12891.91   42.36  [6445.95]    21.18
8.00     0.00    0.00   0.00   0.00

The "new" node #2 shows this:
Device:    rrqm/s wrqm/s   r/s   w/s  rsec/s  wsec/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await  svctm  %util
hda        1377.02   0.00 15.88  0.20 11143.26    1.60  5571.63     0.80
692.92     0.39   24.47  18.76  30.17
hdb        1406.79   0.00  8.59  0.20 11323.08    1.60  5661.54     0.80
1288.18     0.28   32.16  31.48  27.67
hde        1430.77   0.00  8.19  0.20 11511.69    1.60  5755.84     0.80
1372.00     0.27   32.74  29.17  24.48
hdf        1384.42   0.00  6.99  0.20 11130.47    1.60  5565.23     0.80
1547.67     0.40   56.94  54.86  39.46
sda        1489.11   0.00 15.08  0.20 12033.57    1.60  6016.78     0.80
787.40     0.36   23.33  14.38  21.98
sdb        1392.11   0.00 14.39  0.20 11251.95    1.60  5625.97     0.80
771.56     0.39   26.78  16.16  23.58
sdc        1468.33   3.00 14.29  0.40 11860.94   27.17  5930.47    13.59
809.52     0.37   25.24  14.97  21.98
sdd        1498.30   1.50 14.99  0.30 12106.29   14.39  6053.15     7.19
792.99     0.40   26.21  15.82  24.18
sde        1446.55   0.00 13.79  0.20 11683.52    1.60  5841.76     0.80
835.49     0.37   26.36  16.14  22.58
sdf        1510.59   0.00 13.19  0.20 12191.01    1.60  6095.50     0.80
910.81     0.39   28.96  17.39  23.28
sdg        1421.18   0.00 14.69  0.20 11486.91    1.60  5743.46     0.80
771.81     0.35   23.83  15.23  22.68
sdh          4.50   4.50  0.30  0.50   38.36   39.96    19.18    19.98
98.00     0.00    1.25   1.25   0.10
md1          0.00   0.00 15960.54  4.80 127684.32   38.36 [63842.16]
19.18     8.00     0.00    0.00   0.00   0.00

The node-1 (+3,4) have one raid-5 with chunksize 32K
The new node-2 have currently raid4, chunksize 1024K

The NBD is serves only 1KB blocks. (ethernet network)

Currently to clean test, the readahead on all nodes is set to 0 on all
devices, including md[0-1]!

The question is this:
The 3.1MB/s requests on concentrator how can generate 6.4MB/s read on node1
and 63.8MB/s on node2 with all readahead 0?

Does the raid 4,5 hardcoded readahead?
Or if the nbd-server fetch one kb, the raid (or another part of OS) reads
the entire chunk?

Thanks,
Janos

