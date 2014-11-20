From: Stephen Burke <steve.burke.56@gmail.com>
Subject: degraded raid troubleshooting
Date: Thu, 20 Nov 2014 08:41:51 -0500
Message-ID: <CAAugdn4bp9im=hk=8qWkcxpzss-dzB-5Fq-3KnJH6y3AoqXxZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I woke up this morning to my pc not booting saying that my raid was in
a degraded state.  I looked at the raid wiki and it told me to stop
what I was doing and mail the linux-raid list before doing anything
hasty.

Here's all the info that I could find out about it.  Any help would be
appreciated.
I am running Ubuntu 12.04
mdadm - v3.2.5 - 18th May 2012

The drive in question is /dev/sdb1 on my system.  I tried to look at
it via fdisk but it hangs up.  What should my first steps to figure
out if this drive is bad and if so replace it.  Thanks.


sburke@ht-pc:/tmp/logs$ sudo mdadm --detail /dev/md0

[sudo] password for sburke:

/dev/md0:

        Version : 1.2

  Creation Time : Fri Dec 13 01:18:13 2013

     Raid Level : raid5

     Array Size : 3906763776 (3725.78 GiB 4000.53 GB)

  Used Dev Size : 1953381888 (1862.89 GiB 2000.26 GB)

   Raid Devices : 3

  Total Devices : 2

    Persistence : Superblock is persistent


    Update Time : Thu Nov 20 01:16:00 2014

          State : clean, degraded

 Active Devices : 2

Working Devices : 2

 Failed Devices : 0

  Spare Devices : 0


         Layout : left-symmetric

     Chunk Size : 512K


           Name : ht-pc:0  (local to host ht-pc)

           UUID : 508cb42f:d2c1ea9c:e62b4121:c3d9cbc3

         Events : 140


    Number   Major   Minor   RaidDevice State

       0       0        0        0      removed

       1       8       33        1      active sync   /dev/sdc1

       3       8       65        2      active sync   /dev/sde1

sburke@ht-pc:/tmp/logs$ cat /proc/mdstat

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]

md0 : active raid5 sde1[3] sdc1[1]

      3906763776 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2] [_UU]



unused devices: <none>

syslog

Nov 20 01:14:53 ht-pc kernel: [    2.465076]          res
41/40:08:09:08:00/00:00:00:00:00/00 Emask 0x409 (media error) <F>

Nov 20 01:14:53 ht-pc kernel: [    2.465078] ata2.00: status: { DRDY ERR }

Nov 20 01:14:53 ht-pc kernel: [    2.465079] ata2.00: error: { UNC }

Nov 20 01:14:53 ht-pc kernel: [    2.484536] ata2.00: configured for UDMA/133

Nov 20 01:14:53 ht-pc kernel: [    2.484543] ata2: EH complete

Nov 20 01:14:53 ht-pc kernel: [    3.131754] ata2.00: exception Emask
0x0 SAct 0x40 SErr 0x0 action 0x0

Nov 20 01:14:53 ht-pc kernel: [    3.131756] ata2.00: irq_stat 0x40000008

Nov 20 01:14:53 ht-pc kernel: [    3.131758] ata2.00: failed command:
READ FPDMA QUEUED

Nov 20 01:14:53 ht-pc kernel: [    3.131762] ata2.00: cmd
60/08:30:08:08:00/00:00:00:00:00/40 tag 6 ncq 4096 in

Nov 20 01:14:53 ht-pc kernel: [    3.131763]          res
41/40:08:09:08:00/00:00:00:00:00/00 Emask 0x409 (media error) <F>

-- 
Steve
www.stayathomedevs.com

Game Data Editor Unity Plugin
