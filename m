From: "D. Lin" <dlbulk-mllr@yahoo.com>
Subject: help: re-add needed after each reboot
Date: Mon, 7 May 2012 09:29:03 -0700
Message-ID: <5d1b39dd26f138ed494e779218d21346.squirrel@anguish.kchang.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am running 3.2.0 (ubuntu 12.04). My raid5 has 3 disks (sd[cbd]1) and no
spares. The system boots off a non-raid device and auto discovers and
mounts the raid device.

For some reason, sdc1 is not automatically detected and is always missed
on each boot. I have to re-add it back. What could be causing this?

This did not happen while I was running 2.6.38.

Thanks,

Dong Lin


; mdadm --misc --detail /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Fri Jul 22 22:39:40 2011
     Raid Level : raid5
     Array Size : 3907020800 (3726.03 GiB 4000.79 GB)
  Used Dev Size : 1953510400 (1863.01 GiB 2000.39 GB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Mon May  7 09:21:29 2012
          State : active
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : disc:0
           UUID : 4195aaa7:0ebd37ce:d4b9481e:1a68f4a8
         Events : 230784

    Number   Major   Minor   RaidDevice State
       4       8       33        0      active sync   /dev/sdc1
       2       8       49        1      active sync   /dev/sdd1
       3       8       17        2      active sync   /dev/sdb1


----------------------------

here is what happened on boot:

; dmesg |grep md
[    1.781917] md: linear personality registered for level -1
[    1.789184] md: multipath personality registered for level -4
[    1.797121] md: raid0 personality registered for level 0
[    1.801681] md: raid1 personality registered for level 1
[    1.820485] ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfa00
irq 14
[    1.820547] ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfa08
irq 15
[    1.920271] md: bind<sdb1>
[    1.962482] md: bind<sdd1>
[    2.300917] md: raid6 personality registered for level 6
[    2.300980] md: raid5 personality registered for level 5
[    2.301036] md: raid4 personality registered for level 4
[    2.306171] md: raid10 personality registered for level 10
[    2.329393] md/raid:md0: device sdd1 operational as raid disk 1
[    2.329450] md/raid:md0: device sdb1 operational as raid disk 2
[    2.329792] md/raid:md0: allocated 3228kB
[    2.329921] md/raid:md0: raid level 5 active with 2 out of 3 devices,
algorithm 2
[    2.330235] created bitmap (15 pages) for device md0
[    2.330706] md0: bitmap initialized from disk: read 1/1 pages, set 0 of
29809 bits
[    2.362404] md0: detected capacity change from 0 to 4000789299200
[    2.367990]  md0: unknown partition table



=======================================
partition tables:

; fdisk -l | egrep '^/dev/sd[cbd]'
/dev/sdb1              63  3907024064  1953512001   fd  Linux raid autodetect
/dev/sdc1              63  3907024064  1953512001   fd  Linux raid autodetect
/dev/sdd1              63  3907024064  1953512001   fd  Linux raid autodetect


