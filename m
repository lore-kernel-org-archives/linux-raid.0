From: Tom <matx3001@gmail.com>
Subject: raid 5, drives marked as failed. Can I recover?
Date: Thu, 29 Jan 2009 23:17:14 +0000
Message-ID: <f97906a70901291517h2da6fd19pe800d9c17c49f562@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

2 drives have failed on my raid5 setup and I need to recover the data
on the raid.
I am sure that the drives still works or at least one of them still works.

How do I recover my drives?

I can't mount the raid no more and I am missing a hard drive when i
run ls /dev/sd?
I have 7 drives on my raid.

Here is output of /var/log/messages in following link

http://matx.pastebin.com/m35423452

also some more information

tom@desu ~ $ cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
[raid4] [multipath]
md2 : inactive sdc1[1] sdd1[4] sdf1[3] sde1[2]
      1953214208 blocks


tom@desu ~ $ sudo mdadm --detail /dev/md2
Password:
/dev/md2:
        Version : 00.90.03
  Creation Time : Thu Sep  4 20:14:31 2008
     Raid Level : raid5
  Used Dev Size : 488303552 (465.68 GiB 500.02 GB)
   Raid Devices : 7
  Total Devices : 4
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Thu Jan 29 21:16:34 2009
          State : active, degraded, Not Started
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : cf3d1948:1d0e65b6:c028c7c8:
56f0c54c
         Events : 0.1411738

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       8       33        1      active sync   /dev/sdc1
       2       8       65        2      active sync   /dev/sde1
       3       8       81        3      active sync   /dev/sdf1
       4       8       49        4      active sync   /dev/sdd1
       5       0        0        5      removed
       6       0        0        6      removed




Thank you for your time in advance.
