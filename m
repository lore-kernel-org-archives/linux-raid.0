From: Ronny Plattner <ronny_p@gmx.net>
Subject: once again raid5
Date: Thu, 31 Mar 2005 14:41:15 +0200
Message-ID: <d2gr28$aeb$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

we still have troubles with our raid5 array. You can find the history of 
the fault in detail in my other postings (11.3.2005).

I will show you my attempts.

There are 4 discs (Maxtor 250GB) in a raid5-array. One disc failed and 
we sent it back to Maxtor. Now, the array consists of 3 discs.
I tried to reassemble it,

mdadm -A --run --force /dev/md2 /dev/hdi1 /dev/hdk1  /dev/hdo1

but i got an error:

-snip-
mdadm: failed to RUN_ARRAY /dev/md2: Invalid argument
-snap-

...in /var/log/messages

-snip-
Mar 31 14:29:00 server kernel: md: md2 stopped.
Mar 31 14:29:00 server kernel: md: bind<hdo1>
Mar 31 14:29:00 server kernel: md: bind<hdi1>
Mar 31 14:29:00 server kernel: md: bind<hdk1>
Mar 31 14:29:00 server kernel: raid5: device hdk1 operational as raid disk 1
Mar 31 14:29:00 server kernel: raid5: device hdo1 operational as raid disk 3
Mar 31 14:29:00 server kernel: RAID5 conf printout:
Mar 31 14:29:00 server kernel:  --- rd:4 wd:2 fd:2
Mar 31 14:29:00 server kernel:  disk 1, o:1, dev:hdk1
Mar 31 14:29:00 server kernel:  disk 3, o:1, dev:hdo1
-snap-

Amazingly, /proc/mdstat displays the md2-array !

-snip-
md2 : inactive hdk1[1] hdi1[4] hdo1[3]
       735334848 blocks
-snap-

So, md2 is there, but inactive. I tried

mdadm --detail /dev/md2


-snip-
mdadm  --detail /dev/md2
/dev/md2:
         Version : 00.90.01
   Creation Time : Mon Jun 14 18:43:20 2004
      Raid Level : raid5
     Device Size : 245111616 (233.76 GiB 250.99 GB)
    Raid Devices : 4
   Total Devices : 3
Preferred Minor : 2
     Persistence : Superblock is persistent

     Update Time : Sun Mar  6 16:40:29 2005
           State : active, degraded
  Active Devices : 2
Working Devices : 3
  Failed Devices : 0
   Spare Devices : 1

          Layout : left-symmetric
      Chunk Size : 64K

            UUID : 72c49e3a:de37c4f8:00a6d8a2:e8fddb2c
          Events : 0.60470022

     Number   Major   Minor   RaidDevice State
        0       0        0        -      removed
        1      57        1        1      active sync   /dev/hdk1
        2       0        0        -      removed
        3      89        1        3      active sync   /dev/hdo1

        4      56        1        -      spare   /dev/hdi1
-snap-

Okay...more details..

mdadm  --detail --test --brief /dev/md2

-snip-
ARRAY /dev/md2 level=raid5 num-devices=4 spares=1 
UUID=72c49e3a:de37c4f8:00a6d8a2:e8fddb2c
    devices=/dev/hdk1,/dev/hdo1,/dev/hdi1
-snap-

No more information :-(


Anyone can give me useful hints?

Regards
Ronny

