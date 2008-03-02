From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: Setting up md-raid5: observations, errors, questions
Date: Sun, 2 Mar 2008 19:53:52 +0100
Message-ID: <bb145bd20803021053y50405ed9uc405b08d503622e2@mail.gmail.com>
References: <bb145bd20803020423m14efea1by6e3e38bb8d0decb8@mail.gmail.com>
	 <47CAC5BF.6060600@msgid.tls.msk.ru>
	 <bb145bd20803020832x744c2674nd0a6a30e445b5453@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <bb145bd20803020832x744c2674nd0a6a30e445b5453@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Some more data, captured with "vmstat 2 10" during "mke2fs -j -E
stride=16" (to match default chunk size of 64k). The disks are still
WD RE2-GP 1TB.


single disk (no stride):

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 1  2      0 1391888 546344  12784    0    0   527  3795  187  700  0  6 85  9
 0  3      0 1260596 673608  12860    0    0     0 64816  402  136  0  7  0 93
 0  3      0 1130200 800808  12836    0    0     0 56576  405  135  0  7  0 93
 0  3      0 1007040 919952  12796    0    0     0 67108  405  149  0  7  0 93
 0  3      0 892572 1030672  12852    0    0     0 54528  398  129  0  8  0 92
 0  3      0 753968 1165840  12792    0    0     0 61696  404  145  0 12  0 88
 0  3      0 631500 1284656  12788    0    0     0 61184  403  136  0 10  0 90
 0  3      0 500448 1411856  12868    0    0     0 65536  404  139  0 10  0 90
 0  3      0 382016 1526736  12860    0    0     0 59392  400  132  0  9  0 91
 0  3      0 251276 1653840  12792    0    0     0 58880  403  138  0 11  0 89


RAID1 (2 disks, no stride):

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0      0 1346104 586692  11716    0    0   524  3914  187  698  0  6 84 10
 0  0      0 1236228 697284  11776    0    0     0 41452  568 2932  0 14 86  0
 0  0      0 1130244 799684  11768    0    0     0 57518  670 2164  0 13 86  0
 0  0      0 1013020 914200  11752    0    0     0 51870  637 1572  0 14 86  0
 1  0      0 899232 1024972  11720    0    0     0 55504  632 2164  0 15 85  0
 1  0      0 788188 1132912  11728    0    0     0 52908  643 1839  0 16 83  0
 0  0      0 785120 1135564  11768    0    0     0 49980  660 2351  0 13 88  0
 2  0      0 667624 1250252  11768    0    0     0 50028  671 2304  0 17 83  0
 0  0      0 549556 1364940  11768    0    0     0 48186  651 2060  0 17 83  0
 0  0      0 427292 1483724  11768    0    0     0 48568  711 3367  0 18 82  0

[progress of "writing inode tables" pauses regularly then increases in a burst]


RAID0 (2 disks):

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  1      0 1333272 566348  10716    0    0   515  4452  188  708  0  6 84 10
 0  2      0 1084244 808332  10632    0    0     0 123904  547  420  0 17 49 33
 1  1      0 847580 1039004  10720    0    0     0 113228  539  498  0 18 50 32
 1  1      0 603576 1276012  10724    0    0     0 119416  549  505  0 20 50 30
 0  2      0 366996 1505836  10692    0    0     0 120636  544  499  0 19 50 31
 1  1      0 113540 1751948  10700    0    0     0 116764  549  516  0 21 50 29
 0  2      0  12820 1849320  10092    0    0     0 122852  544  637  0 21 50 29
 0  2      0  11544 1850664  10160    0    0     0 120832  549  760  0 22 49 29
 1  1      0  11892 1850312   9980    0    0     0 117996  539  732  0 22 48 30
 0  2      0  12312 1849960   9980    0    0     0 107284  520  700  0 20 48 32


RAID1 (4 disks, no stride)

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0      0 1701472 240556  11600    0    0   512  4653  189  706  0  6 84 10
 0  0      0 1487172 453548  11580    0    0     0 26432  705 8308  0 15 85  0
 2  0      0 1487804 453548  11580    0    0     0 28214 1122 2917  0  9 91  0
 1  3      0 1309804 609292  11544    0    0     4 72986 1019 2111  0 21 78  1
 3  0      0 1279008 626284  11584    0    0     0 63262  551  236  0 13 38 49
 0  1      0 1294940 626284  11584    0    0     0     0  549 8816  0  8 49 43
 0  0      0 1098588 831088  11596    0    0     0  6752  586 14067  0 13 78  8
 0  0      0 1098672 831088  11584    0    0     0 33944  772 1183  0  9 91  0
 0  0      0 981492 945776  11584    0    0     0 32974  841 4643  0 15 85  0
 0  0      0 981436 945776  11584    0    0     0 30546 1120 2474  0 11 89  0

[extremely bursty, can't data be written to the disks in parallel?]


RAID0 (4 disks):

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 1  2      0 945164 866516  11620    0    0   507  4675  190  707  0  6 84 10
 0  1      0 633716 1169620  11528    0    0     0 151552  623  734  0 23 50 27
 1  0      0 324452 1470016  11540    0    0     0 149504  622  717  0 24 50 26
 1  0      0  14644 1771024  11540    0    0     0 149522  622  689  0 25 50 25
 1  0      0  11948 1773160  11044    0    0     0 151552  621  992  0 28 48 24
 1  1      0  12788 1772420  11156    0    0     0 151552  623  985  0 28 48 23
 0  1      0  11952 1773060  11088    0    0     0 151552  622 1004  0 27 48 25
 1  0      0  12744 1772220  11172    0    0     0 149504  620 1000  0 27 48 25
 0  1      0  11888 1773192  11172    0    0     0 151552  622  967  0 28 47 25
 0  1      0  12860 1773000  10268    0    0     0 151560  624  994  0 29 48 23

[there seems to be a cap when writing @~150MB/s, 4 single disks in
parallel yield the same value. It's not the bus so it's probably the
controller. Anyway I can live with that.]


RAID5 (4 disks, syncing in b/g):

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0      0 1223568 636836  11340    0    0   501  4748  190  702  0  6 84 10
 0  0      0 1067636 788388  11372    0    0     0 63074 1639 19766  0 32 45 23
 3  0      0 945316 907172  11276    0    0     0 63294 1684 20441  0 31 47 22
 1  1      0 852584 997292  11340    0    0     0 57012 1651 15925  0 27 54 18
 2  1      0 717548 1128364  11340    0    0     0 61824 1659 20125  0 31 46 23
 0  0      0 586852 1255340  11340    0    0     0 60608 1643 14772  0 29 49 22
 2  1      0 447692 1390508  11368    0    0     0 61400 1703 18710  0 31 43 26
 3  0      0 333892 1501100  11340    0    0     0 64998 1769 20846  0 33 45 23
 3  0      0 190696 1640364  11336    0    0     0 60992 1683 18032  0 32 48 20
 0  1      0 110568 1718188  11340    0    0     0 59970 1651 13064  0 25 57 18

[burstier than RAID0 or the single disk but a lot smoother than RAID1.
Keep in mind that it is syncing in parallel. NO responsiveness
problem.]


RAID5 (4 disks, --assume-clean):

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 5  2      0  11332 1814052  10536    0    0   472  4739  214  819  0  7 84  9
 2  1      0  12304 1812828  10540    0    0     0 73586 1562 23273  0 38 41 20
 0  0      0  13004 1812188  10584    0    0     0 69642 1649 19816  0 34 44 22
 0  1      0  12188 1813084  10580    0    0     0 72452 1675 20730  0 37 42 21
 2  0      0  11784 1813596  10540    0    0     0 74662 1776 20616  0 37 42 21
 0  0      0  12348 1812956  10548    0    0     0 69546 1578 19984  0 32 47 21
 2  1      0  11416 1813724  10608    0    0     0 71092 1712 20723  0 37 41 22
 1  1      0  12496 1812880  10624    0    0     0 71368 1608 22813  0 38 42 20
 2  0      0  11436 1813852  10628    0    0     0 74796 1727 22632  0 38 40 22
 0  1      0  12552 1812572  10564    0    0     0 70248 1656 12608  0 33 48 19



Aside from the fact that RAID1 writes are somewhat erratic these
values seem ok to me. I have no idea how fast a degraded 3/4 disk
RAID5 array should be but it's still faster than a single disk. No
responsiveness problems in any test. Is it possible that the Promise
doesn't like the requests generated by the 1M chunk size used for the
original setup? dmesg is silent so I guess I'll be doing chunksize
tests this evening.

Thanks,

C.
