From: "Vladimir I. Umnov" <uvi@ezmail.ru>
Subject: Low perfomance of RAID0,RAID5, RAID+LVM on 2.6
Date: Thu, 19 Aug 2004 19:32:00 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040819193200.27c97a4e@vovapc.kpml.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

HW: chipset 875WPE, P4 2.4HT, 3 SATA WD 160JD, 1 ATA Samsung 80Gb.
SW: kernel 2.6.6, libata drivers for PROMISE S150 TX4.
CONFIG: 256K readahead on all drives.
	sda1,sdb1,sdc1->RAID0 (md0)
	sda2,sdb2,sdc2,hda1->RAID5 (md1)
	about 20 partitions on LVM2 with xfs,ext3,reiserfs
	chunksize on md0, md1 = 256k - this was optimal with 2.6.0test3 about
	year ago.

Theoretically RAID0 read speed should be nearly read speed of one
drive multiply to number of drives, but I have:
dd if=/dev/sda1 of=/dev/null gives about 44 Mb/s on all drives (but  on
sii3112 ide driver with  WD 160JD about 55Mb/s and on libata the same
44)

>dd if=/dev/md0 of=/dev/null
>2450142720 bytes transferred in 26,436693 seconds (92679622 bytes/sec)
And bus throughput in gkrellm about 180-340 Mb/s

But it's not main problem. Main problem in that LVM2 lower read speed
more than two times:
>dd if=/dev/raid0/video of=/dev/null
>837353472 bytes transferred in 17,210040 seconds (48654941 bytes/sec)
* /dev/raid0/video goes first at md0.

The same results with RAID5(md1):
>kpml:/soft#  dd if=/dev/md1 of=/dev/null
>1612713984 bytes transferred in 20,844837 seconds (77367551 bytes/sec)
>kpml:/soft#  dd if=/dev/raid5/soft of=/dev/null
>565116928 bytes transferred in 17,450073 seconds (32384789 bytes/sec)

And test results with bonnie++:
kpml:/video# bonnie++ -u 0:0
Using uid:0, gid:0.
Writing with putc()...done
Writing intelligently...done
Rewriting...done
Reading with getc()...done
Reading intelligently...done
start 'em...done...done...done...
Create files in sequential order...done.
Stat files in sequential order...done.
Delete files in sequential order...done.
Create files in random order...done.
Stat files in random order...done.
Delete files in random order...done.
Version  1.03       ------Sequential Output------ --Sequential Input-
--Random-                    -Per Chr- --Block-- -Rewrite- -Per Chr-
--Block-- --Seeks-- Machine        Size K/sec %CP K/sec %CP K/sec %CP
K/sec %CP K/sec %CP  /sec %CP kpml             2G 31917  97 99620  19
29519  10 29859  84 59717  12 256.4   1                   
------Sequential Create------ --------Random Create--------             
      -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--       
      files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP 
               16  4881  32 +++++ +++  7280  45  4092  31 +++++ +++ 
3517  25
kpml,2G,31917,97,99620,19,29519,10,29859,84,59717,12,256.4,1,16,4881,32
,+++++,+++,7280,45,4092,31,+++++,+++,3517,25

kpml:/video# cd /soft/
kpml:/soft# bonnie++ -u 0:0
Using uid:0, gid:0.
Writing with putc()...done
Writing intelligently...done
Rewriting...done
Reading with getc()...done
Reading intelligently...done
start 'em...done...done...done...
Create files in sequential order...done.
Stat files in sequential order...done.
Delete files in sequential order...done.
Create files in random order...done.
Stat files in random order...done.
Delete files in random order...done.
Version  1.03       ------Sequential Output------ --Sequential Input-
--Random-                    -Per Chr- --Block-- -Rewrite- -Per Chr-
--Block-- --Seeks-- Machine        Size K/sec %CP K/sec %CP K/sec %CP
K/sec %CP K/sec %CP  /sec %CP kpml             2G 31060  97 64993  20
14784   5 18662  52 32736   7 356.7   1                   
------Sequential Create------ --------Random Create--------             
      -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--       
      files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP 
               16  1199  13 +++++ +++   857   9   713   7 +++++ +++  
560   5
kpml,2G,31060,97,64993,20,14784,5,18662,52,32736,7,356.7,1,16,1199,13,+
++++,+++,857,9,713,7,+++++,+++,560,5

And tiobench:
kpml:/soft# tiobench
No size specified, using 1792 MB
Run #1: /usr/bin/tiotest -t 8 -f 224 -r 500 -b 4096 -d . -TTT

Unit information
================
File size = megabytes
Blk Size  = bytes
Rate      = megabytes per second
CPU%      = percentage of CPU used during the test
Latency   = milliseconds
Lat%      = percent of requests that took longer than X seconds
CPU Eff   = Rate divided by CPU% - throughput per cpu load

Sequential Reads
                              File  Blk   Num                   Avg     
Maximum      Lat%     Lat%    CPU Identifier                    Size 
Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s   
Eff---------------------------- ------ ----- ---  ------ ------
--------- -----------  -------- -------- ----- 2.6.6                    
    1792  4096    1   26.81 11.56%     0.142       60.47   0.00000 
0.00000   232 2.6.6                         1792  4096    2   33.38
16.50%     0.229       76.61   0.00000  0.00000   202 2.6.6             
           1792  4096    4   37.87 20.62%     0.372      274.79  
0.00000  0.00000   184 2.6.6                         1792  4096    8  
44.65 25.15%     0.602      420.46   0.00000  0.00000   178

Random Reads
                              File  Blk   Num                   Avg     
Maximum      Lat%     Lat%    CPU Identifier                    Size 
Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s   
Eff---------------------------- ------ ----- ---  ------ ------
--------- -----------  -------- -------- ----- 2.6.6                    
    1792  4096    1    0.69 0.789%     5.665       54.09   0.00000 
0.00000    87 2.6.6                         1792  4096    2    1.23
1.452%     6.336       45.20   0.00000  0.00000    84 2.6.6             
           1792  4096    4    1.65 1.401%     8.882      188.50  
0.00000  0.00000   117 2.6.6                         1792  4096    8   
1.84 1.474%    14.244      291.80   0.00000  0.00000   125

Sequential Writes
                              File  Blk   Num                   Avg     
Maximum      Lat%     Lat%    CPU Identifier                    Size 
Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s   
Eff---------------------------- ------ ----- ---  ------ ------
--------- -----------  -------- -------- ----- 2.6.6                    
    1792  4096    1   58.39 34.30%     0.047      189.67   0.00000 
0.00000   170 2.6.6                         1792  4096    2   56.21
43.01%     0.081    18535.41   0.00044  0.00022   131 2.6.6             
           1792  4096    4   38.19 32.81%     0.265    33476.28  
0.00131  0.00065   116 2.6.6                         1792  4096    8  
36.54 32.02%     0.464    33756.36   0.00218  0.00131   114

Random Writes
                              File  Blk   Num                   Avg     
Maximum      Lat%     Lat%    CPU Identifier                    Size 
Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s   
Eff---------------------------- ------ ----- ---  ------ ------
--------- -----------  -------- -------- ----- 2.6.6                    
    1792  4096    1    0.90 0.580%     0.011        0.77   0.00000 
0.00000   155 2.6.6                         1792  4096    2    0.85
0.666%     0.014        0.90   0.00000  0.00000   128 2.6.6             
           1792  4096    4    0.85 0.646%     0.014        0.94  
0.00000  0.00000   131 2.6.6                         1792  4096    8   
0.80 0.627%     0.015        2.74   0.00000  0.00000   127


Seems, that LVM2 is main problem.

I try 2.6.8 and with it md* devices had worse perfomance with all this
tests, on 2.4 perfomance worse than on any 2.6.

What should I do to get read speed greater and have about 20 partitions
on md* block devices? I have a lot of space in LAN to temporarly backup
all data from server and remake something. Additionally I can swap 80Gb
Samsung to 160Gb ATA  WD JB.

p.s. Forgive me for bad Eng.


