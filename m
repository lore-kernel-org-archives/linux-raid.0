From: "JaniD++" <djani22@dynamicweb.hu>
Subject: raid-reconf question
Date: Thu, 29 Dec 2005 02:08:50 +0100
Message-ID: <008401c60c58$effb7f90$a400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello, list,

I try to test raidreconf utility on my spare drives in my disk nodes.
(i want to convert raid0 chunksize 32K to 1M)

Why happenning this?

[root@dy-xeon-1 raid-converter]# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5] [multipath] [faulty]
md20 : active raid0 nbd7[3] nbd6[2] nbd5[1] nbd4[0]
      39101696 blocks 32k chunks

unused devices: <none>
[root@dy-xeon-1 raid-converter]# mdadm -D /dev/md20
/dev/md20:
        Version : 00.90.03
  Creation Time : Thu Dec 29 02:02:45 2005
     Raid Level : raid0
     Array Size : 39101696 (37.29 GiB 40.04 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 20
    Persistence : Superblock is persistent

    Update Time : Thu Dec 29 02:02:45 2005
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 32K

           UUID : 6865dd35:58a41e0c:b0c1a78a:2aa6d02d
         Events : 0.1

    Number   Major   Minor   RaidDevice State
       0      43        4        0      active sync   /dev/nb4
       1      43        5        1      active sync   /dev/nb5
       2      43        6        2      active sync   /dev/nb6
       3      43        7        3      active sync   /dev/nb7
[root@dy-xeon-1 raid-converter]# raidstop --configfile=raidtab.old /dev/md20
[root@dy-xeon-1 raid-converter]# ./raidreconf -o raidtab.old -n
raidtab.new -m /dev/md20
Working with device /dev/md20
Parsing raidtab.old
Parsing raidtab.new
Your on-disk array MUST be clean first.
reconfiguration failed
[root@dy-xeon-1 raid-converter]#

Anybody has an idea?

Thanks,
Janos

File: raidtab.old
raiddev         /dev/md20
raid-level      0
nr-raid-disks   4
chunk-size      32
persistent-superblock 1
device          /dev/nb4
raid-disk       0
device          /dev/nb5
raid-disk       1
device          /dev/nb6
raid-disk       2
device          /dev/nb7
raid-disk       3

File: raidtab.new
raiddev         /dev/md20
raid-level      0
nr-raid-disks   4
chunk-size      1024
persistent-superblock 1
device          /dev/nb4
raid-disk       0
device          /dev/nb5
raid-disk       1
device          /dev/nb6
raid-disk       2
device          /dev/nb7
raid-disk       3

