From: "Zoe May" <Zoe.May@Cartesian.co.uk>
Subject: Aacraid - terrible performance on RHES3 pedge 2450
Date: Mon, 25 Oct 2004 11:31:07 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <7B3248565B589149B35D353FB966388E296F56@bunny.cartesian.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I am experiencing disk performance issues (very slow) with hardware and
software combo listed below.

Poweredge 2450 
Perc 3/si controller.
RH linux ES3 (2.4.21-4.Elsmp)
4 x 73GB scsi (In a RAID 5 set)

This server was previously running RH 7.3 with a 34GB mirror set with no
issue

So far I have updated the firmware of the card to Version 2.8.0.6092,
Rev. A13
And have updated the aacraid driver to aacraid-1.1.4-2302
Neither of the above have had any impact.

This machine is freshly installed and has no load to speak of yet
As an indicator of performance here is what I get from hdparm.


/dev/sda2:
 Timing buffer-cache reads:   780 MB in  2.00 seconds = 390.00 MB/sec
 Timing buffered disk reads:   22 MB in  3.20 seconds =   6.88 MB/sec
[root@benidorm root]# hdparm -tT /dev/sda1

/dev/sda1:
 Timing buffer-cache reads:   788 MB in  2.00 seconds = 394.00 MB/sec
 Timing buffered disk reads:   26 MB in  3.02 seconds =   8.61 MB/sec

When I do disk writes the system pretty much locks up in terms of doing
anything else until it's finished.

The following is a vmstat when the system is idle

vmstat 1
procs                      memory      swap          io     system
cpu
 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy
wa id
 0  0      0 1541840  23028 127984    0    0    22     4   80    85  1
0  1 98
 0  0      0 1541840  23028 127984    0    0     0     0  166   165  0
0  0 100
 0  0      0 1541840  23028 127984    0    0     0     0  171   172  0
0  0 100
 0  0      0 1541840  23028 127984    0    0     0     0  170   179  0
0  0 100
 0  0      0 1541824  23044 127984    0    0     0    48  174   180  0
0  0 100
 0  0      0 1541824  23044 127984    0    0     0     0  166   165  0
0  0 100
 0  0      0 1541824  23044 127984    0    0     0     0  171   160  0
0  0 100
 0  0      0 1541824  23044 127984    0    0     0     0  164   170  0
0  0 100
 2  0      0 1541824  23044 127984    0    0     0     0  169   167  0
0  0 100
 0  0      0 1541816  23052 127984    0    0     0    44  178   178  0
0  0 100
 0  0      0 1541816  23052 127984    0    0     0     0  163   161  0
0  0 100
 0  0      0 1541816  23052 127984    0    0     0     0  164   160  0
0  0 100
 1  0      0 1541816  23052 127984    0    0     0     0  163   165  0
0  0 100

This is what happens when I run 'dd if=/dev/zero of=test bs=1024000
count=500'


[root@benidorm raid]# vmstat 1
procs                      memory      swap          io     system
cpu
 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy
wa id
 0  0      0 1539248  23168 127984    0    0    22     4   80    86  1
0  1 98
 0  0      0 1539248  23168 127984    0    0     0     0  202   226  0
0  0 100
 0  0      0 1539248  23168 127984    0    0     0     0  445   458  0
0  0 99
 0  1      0 1539196  23196 127984    0    0    28     0  239   258  0
0  5 95
 2  0      0 1438304  23356 227984    0    0    28 14992  561   329  0
46 11 43
 1  0      0 1438304  23356 227984    0    0     0     0  254   238  0
0  0 100
 2  0      0 1438304  23356 227984    0    0     0     0  348   331  0
0  0 100
 0  0      0 1438304  23356 227984    0    0     0     0  311   404  0
0  0 100
 0  0      0 1438304  23356 227984    0    0     0     0  213   218  0
0  0 100
 1  2      0 1437672  23360 227984    0    0     0 63704  826   371  0
4 57 38
 0  2      0 1437668  23360 227984    0    0     0  8192  313   184  0
0 50 50
 0  2      0 1437664  23360 227984    0    0     0  8192  310   166  0
0 50 50
 0  2      0 1437652  23360 227984    0    0     0  5040  337   199  0
1 49 50
 2  2      0 1437652  23360 227984    0    0     0     0  332   190  0
0 50 50
 0  2      0 1437652  23360 227984    0    0     0   370  522   379  0
0 50 50
 0  2      0 1437652  23360 227984    0    0     0     0  417   285  0
0 50 50
 0  0      0 1437644  23372 227984    0    0     0   120  322   216  0
0  7 92
 0  0      0 1437644  23372 227984    0    0     0     0  275   254  1
0  0 100
procs                      memory      swap          io     system
cpu
 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy
wa id
 3  0      0 1437644  23372 227984    0    0     0     0  279   282  0
0  0 100
 0  0      0 1437636  23380 227984    0    0     0    16  597   617  1
0 15 83
 0  0      0 1437632  23380 227984    0    0     0     0  603   598  3
0  0 97
 0  0      0 1437632  23380 227984    0    0     0     0  192   188  0
0  0 100
 0  0      0 1437632  23380 227984    0    0     0     0  200   200  0
1  0 99
 1  0      0 1437632  23380 227984    0    0     0     0  188   189  0
0  0 100
 1  0      0 1437628  23388 227984    0    0     0    16  215   204  0
0  0 100
 0  0      0 1437628  23388 227984    0    0     0     0  289   296  1
0  0 99

[root@benidorm raid]# vmstat 1
procs                      memory      swap          io     system
cpu
 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy
wa id
 2  0      0 1225320  23700 431252    0    0    22    12   81    86  1
0  1 98
 1  2      0 1113708  23816 538284    0    0     4 42376  334   176  0
51  8 42
 1  3      0 1053544  23876 595980    0    0     4 23108  607   289  0
29 72  0
 0  2      0 1020184  23908 627984    0    0     0 10492  541   388  0
14 50 36
 0  2      0 1020184  23908 627984    0    0     0  8192  457   319  1
0 50 49
 0  2      0 1020184  23908 627984    0    0     0  8192  374   244  2
0 50 47
 0  2      0 1020184  23908 627984    0    0     0 10560  411   284  0
0 50 50
 1  2      0 1020184  23908 627984    0    0     0  6720  307   178  2
0 50 47
 0  2      0 1020184  23908 627984    0    0     0  8256  398   333  1
0 50 48
 0  2      0 1020184  23908 627984    0    0     0 10240  305   174  1
0 50 48
 0  2      0 1020184  23908 627984    0    0     0  8256  371   233  1
1 49 49
 0  2      0 1020184  23908 627984    0    0     0 10368  319   182  2
1 48 48
 0  2      0 1020184  23908 627984    0    0     0 10432  313   168  5
1 49 45
 0  2      0 1020184  23908 627984    0    0     0  8640  294   171  1
3 52 44
 0  2      0 1020184  23908 627984    0    0     0  8384  297   171  0
0 49 50
 0  2      0 1020184  23908 627984    0    0     0  8256  309   178  0
1 49 50
 0  2      0 1020184  23908 627984    0    0     0  8512  297   179  0
1 49 50
 0  2      0 1020184  23908 627984    0    0     0  8832  369   213  0
1 49 50
procs                      memory      swap          io     system
cpu
 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy
wa id
 1  2      0 1020184  23908 627984    0    0     0 10240  361   238  1
0 49 50
 0  2      0 1020184  23908 627984    0    0     0  8128  300   181  0
0 50 50
 0  2      0 1020184  23908 627984    0    0     0  8192  332   225  0
0 51 50
 0  2      0 1020184  23908 627984    0    0     0 10624  488   343  1
1 48 50
 0  2      0 1020184  23908 627984    0    0     0  8320  304   167  0
1 48 50
 0  2      0 1020184  23908 627984    0    0     0  8704  302   180  1
1 49 50
 0  2      0 1020184  23908 627984    0    0     0 10304  308   178  0
1 49 50
 0  2      0 1020184  23908 627984    0    0     0  8384  304   178  1
0 48 50
 0  2      0 1020184  23908 627984    0    0     0  8960  306   196  0
2 48 50
 0  2      0 1020184  23908 627984    0    0     0  8192  316   191  1
0 49 50
 0  2      0 1020184  23908 627984    0    0     0  8192  348   239  1
1 48 50
 0  2      0 1020184  23908 627984    0    0     0  8192  301   176  1
1 48 50
 0  2      0 1020184  23908 627984    0    0     0 10240  390   263  1
1 48 50
 0  3      0 1020184  23908 627984    0    0     0  8188  399   271  2
2 47 50
 0  3      0 1020184  23908 627984    0    0     0 11136  331   185  2
0 48 50
 1  3      0 1020184  23908 627984    0    0     0  8256  353   233  1
1 47 50
 0  3      0 1020184  23908 627984    0    0     0  8192  302   182  2
0 54 43
 0  3      0 1020180  23908 627984    0    0     0  7132  292   186  3
2 95  0
procs                      memory      swap          io     system
cpu
 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy
wa id
 1  4      0 1019896  23908 627988    0    0     0  8132  350   217  3
1 96  0
 0  4      0 1019896  23908 627988    0    0     0  7380  299   183  2
1 96  0
 1  4      0 1019896  23908 627988    0    0     0  7292  361   223  2
3 96  0
 1  4      0 1019896  23908 627988    0    0     0 10920  357   207  1
3 96  0
 0  4      0 1019892  23916 627988    0    0     0  9916  327   192  2
8 90  0
 1  4      0 1019892  23916 627988    0    0     0  8832  333   180  5
3 92  0
 0  4      0 1019892  23916 627988    0    0     0 10560  327   178  0
0 100  0
 0  4      0 1019880  23924 627988    0    0     0 10892  326   175  0
1 99  0
 0  4      0 1019880  23924 627988    0    0     0  8384  294   173  0
0 100  0
 1  4      0 1019880  23924 627988    0    0     0  8832  313   168  0
1 99  0
 1  4      0 1019880  23924 627988    0    0     0 10368  432   332  0
0 100  0
 0  4      0 1019880  23924 627988    0    0     0  8128  371   290  0
0 100  0
 0  4      0 1019880  23924 627988    0    0     0  8192  307   166  0
1 100  0
 0  4      0 1019880  23924 627988    0    0     0  8576  297   168  0
0 100  0
 0  4      0 1019880  23924 627988    0    0     0  8768  299   175  0
0 100  0
 1  3      0 1019880  23924 627988    0    0     0  5944  299   177  0
0 100  0
 1  3      0 1019880  23924 627988    0    0     0     0  306   156  0
0 100  0
 0  3      0 1019880  23924 627988    0    0     0     0  300   158  0
0 100  0



This is the container config output from aafcli

_container show > cache 0
Executing: container show cache 0

Global Container Read Cache Size  : 0
Global Container Write Cache Size : 51380224

Read Cache Setting        : ENABLE
Write Cache Setting       : ENABLE ALWAYS
Write Cache Status        : Active, not protected, battery not present

The write cache setting was previously 'enable when protected'. I
changed it to enable always but it had no impact.
I'm not sure where to go with this now. Possibly trying to boot off
knoppix or something to see if a different kernel changes things.
If anyone has any suggestions I'd be very grateful.
Thanks
Zoe 

