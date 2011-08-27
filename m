From: CoolCold <coolthecold@gmail.com>
Subject: possible bug - bitmap dirty pages status
Date: Sat, 27 Aug 2011 13:58:09 +0400
Message-ID: <CAGqmV7oKNSj2UjEKyqwE2qKrTj9Gj5-OZxwUAVw+uMh1TTRXuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello!
I have raid1 array with bitmap (md3), one disk has died, been replaced
and array resynced:

Aug 25 15:38:03 gamma2 kernel: [    5.986791] md: md3 stopped.
Aug 25 15:38:03 gamma2 kernel: [    6.043306] raid1: raid set md3
active with 1 out of 2 mirrors
Aug 25 15:38:03 gamma2 kernel: [    6.044378] md3: bitmap initialized
from disk: read 2/2 pages, set 357 bits
Aug 25 15:38:03 gamma2 kernel: [    6.044442] created bitmap (22
pages) for device md3
Aug 25 15:38:03 gamma2 kernel: [    6.070492] md3: detected capacity
change from 0 to 1478197903360
Aug 25 15:38:03 gamma2 kernel: [    6.070862]  md3: unknown partition table
Aug 26 19:33:33 gamma2 kernel: [100325.814179] md: md3: recovery done.

Now, /proc/mdstats still shows "dirty" bitmap, 16 of 22 pages:

root@gamma2:~# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md3 : active raid1 sdc3[1] sdb3[0]
      1443552640 blocks [2/2] [UU]
      bitmap: 16/22 pages [64KB], 32768KB chunk

root@gamma2:~# mdadm -D /dev/md3
/dev/md3:
        Version : 00.90
  Creation Time : Wed Oct 13 03:13:52 2010
     Raid Level : raid1
     Array Size : 1443552640 (1376.68 GiB 1478.20 GB)
  Used Dev Size : 1443552640 (1376.68 GiB 1478.20 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 3
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Sat Aug 27 13:53:57 2011
          State : active
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : f5a9c1da:83dd4c40:d363f6aa:3cbcebe5
         Events : 0.1381014

    Number   Major   Minor   RaidDevice State
       0       8       19        0      active sync   /dev/sdb3
       1       8       35        1      active sync   /dev/sdc3



That is strange as I can understand.

distrib & mdadm info:
Debian Lenny with openvz kernel from lenny-backports.

root@gamma2:~# cat /proc/version
Linux version 2.6.32-bpo.5-openvz-amd64 (Debian 2.6.32-35~bpo50+1)
(norbert@tretkowski.de) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #1 SMP
Wed Jul 20 11:23:01 UTC 2011
root@gamma2:~# mdadm --version
mdadm - v2.6.7.2 - 14th November 2008




-- 
Best regards,
[COOLCOLD-RIPN]
