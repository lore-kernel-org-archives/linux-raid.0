From: Maurice Hilarius <maurice@harddata.com>
Subject: Re: large devices (3ware)
Date: Wed, 21 Aug 2002 09:47:54 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.1.0.14.2.20020821093541.03bec540@mail.harddata.com>
References: <Pine.LNX.4.44.0208211035120.1498-100000@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0208211035120.1498-100000@uplift.swm.pp.se>
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

With regards to your message at 02:37 AM 8/21/02, Mikael Abrahamsson. Where 
you stated:

>I am considering a 3ware 7500-12 (12 channel IDE raid controller) and 12
>120 gig drives in a single large RAID5. Am I correct that Linux (latest
>Redhat 7.3 shipped 2.4.18 kernel) can handle devices up to 2 terabyte and
>that this raid5 (1320 gig) would work as expected as one single file
>system (ext3) ? Anyone actually have something similar up and running and
>can verify that it works?


It works just great.
The 3Ware have the new ATA addressing and handle large drives just fine.
Actually the 120GB does not need this newer addressing. Only drives over 
128GB need it.
We use the WD and also the Maxtor 160GB with 3Ware.
You will get a RAID volume with a formatted capacity of about 1.221TB
One thing I can point out is that the "slower" Maxtor 5400rpm drives 
actually produce very similar performance results compared to the "faster" 
7200rpm models. While they spin slower, the track data density is very 
high, and this seems to make up for the slower spin rate to a great degree.
Using a set of 160GB, 5400 rpm drives we get very similar performance to 
the 7200rpm WDs.
Using the 160GB drives we build 16 drive RAID 5 arrays (using 2 of the 
3Ware cards, and can build a 2TB partition and if we use all drive, another 
311MB for a second partition.
Works great.
Here's a bonnie test on 8 of the WD1200-JB, using different options. Read 
the inline notes by the bonnie++ tests for info.
Note that we are using a 4GB file size in the bonnie++ tests, so as to 
avoid artificially high readings due to OS buffers, drive cacheing, etc.:

Hardware:

SuperMicro P4DL6 Motherboard
1024 MB of RAM
3ware 7850 RAID Controller
Dual P4 Xeons 2GHz
8 x 120GB Western Digital c/w 8MB Cache WD1200-JB

raidtab file:

raiddev             /dev/md2
raid-level                  5
nr-raid-disks               8
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
     device          /dev/sda3
     raid-disk     0
     device          /dev/sdb2
     raid-disk     1
     device          /dev/sdc2
     raid-disk     2
     device          /dev/sdd2
     raid-disk     3
     device          /dev/sde2
     raid-disk     4
     device          /dev/sdf2
     raid-disk     5
     device          /dev/sdg2
     raid-disk     6
     device          /dev/sdh2
     raid-disk     7
raiddev             /dev/md0
raid-level                  5
nr-raid-disks               8
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
     device          /dev/sda9
     raid-disk     0
     device          /dev/sdb9
     raid-disk     1
     device          /dev/sdc9
     raid-disk     2
     device          /dev/sdd9
     raid-disk     3
     device          /dev/sde9
     raid-disk     4
     device          /dev/sdf9
     raid-disk     5
     device          /dev/sdg9
     raid-disk     6
     device          /dev/sdh9
     raid-disk     7
raiddev             /dev/md1
raid-level                  5
nr-raid-disks               8
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
     device          /dev/sda8
     raid-disk     0
     device          /dev/sdb8
     raid-disk     1
     device          /dev/sdc8
     raid-disk     2
     device          /dev/sdd8
     raid-disk     3
     device          /dev/sde8
     raid-disk     4
     device          /dev/sdf8
     raid-disk     5
     device          /dev/sdg8
     raid-disk     6
     device          /dev/sdh8
     raid-disk     7
raiddev             /dev/md4
raid-level                  5
nr-raid-disks               8
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
     device          /dev/sda6
     raid-disk     0
     device          /dev/sdb6
     raid-disk     1
     device          /dev/sdc6
     raid-disk     2
     device          /dev/sdd6
     raid-disk     3
     device          /dev/sde6
     raid-disk     4
     device          /dev/sdf6
     raid-disk     5
     device          /dev/sdg6
     raid-disk     6
     device          /dev/sdh6
     raid-disk     7
raiddev             /dev/md5
raid-level                  5
nr-raid-disks               8
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
     device          /dev/sda7
     raid-disk     0
     device          /dev/sdb7
     raid-disk     1
     device          /dev/sdc7
     raid-disk     2
     device          /dev/sdd7
     raid-disk     3
     device          /dev/sde7
     raid-disk     4
     device          /dev/sdf7
     raid-disk     5
     device          /dev/sdg7
     raid-disk     6
     device          /dev/sdh7
     raid-disk     7
raiddev             /dev/md3
raid-level                  5
nr-raid-disks               8
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
     device          /dev/sda5
     raid-disk     0
     device          /dev/sdb5
     raid-disk     1
     device          /dev/sdc5
     raid-disk     2
     device          /dev/sdd5
     raid-disk     3
     device          /dev/sde5
     raid-disk     4
     device          /dev/sdf5
     raid-disk     5
     device          /dev/sdg5
     raid-disk     6
     device          /dev/sdh5
     raid-disk     7

Test 1:  Command Line: bonnie++ -d /data -s 4g -r 1024 -u root > /root/bonoutb
* This test had the driver from the 7.3 RedHat Install and the RAID was 
still resyncing after the OS install.
*3ware Storage Controller device driver for Linux v1.02.00.020

Version 1.02c       ------Sequential Output------ --Sequential Input- --Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
dynamic-188.hard 4G 15554  99 76414  98 49839  52 22177  99 155182  53 
373.9   2                    ------Sequential Create------ --------Random 
Create--------
                     -Create-- --Read--- -Delete-- -Create-- --Read--- 
-Delete--
               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec 
%CP  /sec %CP
                  16  2101  97 +++++ +++ 29801 100  1878  97 +++++ 
+++  3738  98
dynamic-188.harddata.net,4G,15554,99,76414,98,49839,52,22177,99,155182,53,373.9,2,16,2101,97,+++++,+++,29801,100,1878,97,+++++,+++,3738,98


Test3: Command line: bonnie++ -d /data -s 4g -r 1024 -u root > /root/bonoutd
* This test is the stock driver from the 7.3 RedHat Install and the RAID is 
done resyncing.
*3ware Storage Controller device driver for Linux v1.02.00.020

Version 1.02c       ------Sequential Output------ --Sequential Input- --Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
dynamic-188.hard 4G 17293  99 77746  99 51494  54 22826  98 157093  50 
393.7   3                    ------Sequential Create------ --------Random 
Create--------
                     -Create-- --Read--- -Delete-- -Create-- --Read--- 
-Delete--
               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec 
%CP  /sec %CP
                  16  2081  97 +++++ +++ 32012  99  2200  99 +++++ 
+++  5846 100
dynamic-188.harddata.net,4G,17293,99,77746,99,51494,54,22826,98,157093,50,393.7,3,16,2081,97,+++++,+++,32012,99,2200,99,+++++,+++,5846,100

Test4: Command line: bonnie++ -d /data -s 4096 -r 1024 -u root
* This test is the stock driver from the 7.3 RedHat Install and the RAID is 
done resyncing.
*3ware Storage Controller device driver for Linux v1.02.00.020

Version 1.02c       ------Sequential Output------ --Sequential Input- --Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
dynamic-188.hard 4G 17324  99 82418  99 50897  55 22718  99 154522  46 
389.9   2                    ------Sequential Create------ --------Random 
Create--------
                     -Create-- --Read--- -Delete-- -Create-- --Read--- 
-Delete--
               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec 
%CP  /sec %CP
                  16  2075  99 +++++ +++ 32095  99  2202  98 +++++ 
+++  5848 100
dynamic-188.harddata.net,4G,17324,99,82418,99,50897,55,22718,99,154522,46,389.9,2,16,2075,99,+++++,+++,32095,99,2202,98,+++++,+++,5848,100

Test5: Command line: bonnie++ -d /data -s 4096 -r 1024 -u root
* This test is with the newest driver available from 3ware.
*3ware Storage Controller device driver for Linux v1.02.00.025

Version 1.02c       ------Sequential Output------ --Sequential Input- --Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
dynamic-188.hard 4G 17299  99 82519  99 51073  54 22969  99 158657  46 
394.5   2                    ------Sequential Create------ --------Random 
Create--------
                     -Create-- --Read--- -Delete-- -Create-- --Read--- 
-Delete--
               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec 
%CP  /sec %CP
                  16  2078  98 +++++ +++ 31989  99  2139  98 +++++ 
+++  5129  99
dynamic-188.harddata.net,4G,17299,99,82519,99,51073,54,22969,99,158657,46,394.5,2,16,2078,98,+++++,+++,31989,99,2139,98,+++++,+++,5129,99

Test6: Command line: bonnie++ -d /data -s 4g -r 1024 -u root
* This test is with the newest driver available from 3ware.
*3ware Storage Controller device driver for Linux v1.02.00.025

Version 1.02c       ------Sequential Output------ --Sequential Input- --Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
dynamic-188.hard 4G 17465  99 78499  99 50943  53 22833  98 150570  44 
384.8   2                    ------Sequential Create------ --------Random 
Create--------
                     -Create-- --Read--- -Delete-- -Create-- --Read--- 
-Delete--
               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec 
%CP  /sec %CP
                  16  2083  98 +++++ +++ 31929  99  2158  99 +++++ 
+++  5029  98
dynamic-188.harddata.net,4G,17465,99,78499,99,50943,53,22833,98,150570,44,384.8,2,16,2083,98,+++++,+++,31929,99,2158,99,+++++,+++,5029,98



With our best regards,

Maurice W. Hilarius       Telephone: 01-780-456-9771
Hard Data Ltd.               FAX:       01-780-456-9772
11060 - 166 Avenue        mailto:maurice@harddata.com
Edmonton, AB, Canada      http://www.harddata.com/
    T5X 1Y3

2.3TB RAID5 NAS server - dual AthlonMP CPU, Linux, $10,995 CAD / $6850 USD

