From: Stefan.Hagendorn@lindy.cc
Subject: Please help Data corruption on Raid5 Array
Date: Thu, 20 Nov 2003 10:20:38 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <OF7B8FCB8F.6D96733F-ONC1256DE4.00321A25-C1256DE4.003360D2@lindy.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi List,

I use a box with 4 harddisks with Raid5 and XFS. After writing a File the 
File appears to change when 
reading it. I've done the following to demonstrate the issue: 

Created 2 files 100 MB each with /dev/zero as source and compared the 
files 3 
times. 

[root@mss archive]# dd if=/dev/zero of=testfile1 bs=1M count=100 
100+0 Records in 
100+0 Records out 

[root@mss archive]# dd if=/dev/zero of=testfile2 bs=1M count=100 
100+0 Records in 
100+0 Records out 

[root@mss archive]# compare testfile1 testfile2 -a 
14614544  (0xdf0010)    0x7f != 0x00    ^?    ^@ 
14614545  (0xdf0011)    0xff != 0x00   ~^?    ^@ 
71893008  (0x4490010)   0x00 != 0x7f    ^@    ^? 
71893009  (0x4490011)   0x00 != 0xff    ^@   ~^? 

[root@mss archive]# compare testfile1 testfile2 -a 
44630032  (0x2a90010)   0x7f != 0x00    ^?    ^@ 
44630033  (0x2a90011)   0xff != 0x00   ~^?    ^@ 
58785808  (0x3810010)   0x7f != 0x00    ^?    ^@ 
58785809  (0x3810011)   0xff != 0x00   ~^?    ^@ 

[root@mss archive]# compare testfile1 testfile2 -a 
8716304  (0x850010)     0x7f != 0x00    ^?    ^@ 
8716305  (0x850011)     0xff != 0x00   ~^?    ^@ 
31260688  (0x1dd0010)   0x7f != 0x00    ^?    ^@ 
31260689  (0x1dd0011)   0xff != 0x00   ~^?    ^@ 
31326224  (0x1de0010)   0x7f != 0x00    ^?    ^@ 
31326225  (0x1de0011)   0xff != 0x00   ~^?    ^@ 
85385232  (0x516e010)   0x7f != 0x00    ^?    ^@ 
85385233  (0x516e011)   0xff != 0x00   ~^?    ^@ 
104136720  (0x6350010)  0x00 != 0x7f    ^@    ^? 
104136721  (0x6350011)  0x00 != 0xff    ^@   ~^? 

you can see this yields different problems every compare on both sides ... 


This looks to me like the data is written correctly to disk and the 
problem 
happens when reading the data. 

The Kerne I use is 2.4.22-ac3.  I recently updated to 2.4.23-rc1 but the 
Problem is still present.

After some Tests and some mails to the XFS List I've read the Files with 
'dd' directly from the raiddevice. The Problem is still there - When I put 
the Files on another volume - even another raid5 array on the same box the 
errors didn't change anymore .. like a snapshot of the current error.

It's a live system with some valuable data for me - the /dev/zero tests 
weher just to clarify the problem.

Here some additional Informations from the box:

[root@mss /]# cat /etc/raidtab
raiddev       /dev/md0
raid-level    5
chunk-size    64k
persistent-superblock 1
nr-raid-disks 4
    device    /dev/hde1
    raid-disk 0
    device    /dev/hdg1
    raid-disk 1
    device    /dev/hdi1
    raid-disk 2
    device    /dev/hdk1
    raid-disk 3
raiddev       /dev/md1
raid-level    5
chunk-size    64k
persistent-superblock 1
nr-raid-disks 3
    device    /dev/hdf1
    raid-disk 0
    device    /dev/hdh1
    raid-disk 1
    device    /dev/hdj1
    raid-disk 2

[root@mss /]# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5] [multipath]
read_ahead 1024 sectors
md0 : active raid5 hdk1[3] hdi1[2] hdg1[1] hde1[0]
      360160896 blocks level 5, 64k chunk, algorithm 0 [4/4] [UUUU]

md1 : active raid5 hdj1[2] hdh1[1] hdf1[0]
      156280064 blocks level 5, 64k chunk, algorithm 0 [3/3] [UUU]

unused devices: <none>

[root@mss /]# cat /proc/ide/hd[e-l]/model
Maxtor 4G120J6
SAMSUNG SV1604N
Maxtor 4G120J6
SAMSUNG SV1604N
Maxtor 4G120J6
Maxtor 4D080H4
Maxtor 4G120J6
Maxtor 98196H8

If you need anthing else or this is the wrong way to report an error, 
please 
inform me. 

Thanks 
Stefan Hagendorn
