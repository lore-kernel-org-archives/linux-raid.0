From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Re: invalid superblock - *again*
Date: Tue, 22 Aug 2006 03:02:23 +0200
Message-ID: <200608220302.23412.Dexter.Filmore@gmx.de>
References: <200608210104.17274.Dexter.Filmore@gmx.de> <17641.3010.978057.92568@cse.unsw.edu.au> <200608211304.12010.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200608211304.12010.Dexter.Filmore@gmx.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am Montag, 21. August 2006 13:04 schrieb Dexter Filmore:
I seriously don't know what's going on here.
I upgraded packages and rebooted the machine to find that now disk 4 of 4 is 
not assembled.

Here's dmesg and mdadm -E 

***************** dmesg ******************
[   38.439644] md: md0 stopped.
[   38.536089] md: bind<sdb1>
[   38.536301] md: bind<sdc1>
[   38.536501] md: bind<sdd1>
[   38.536702] md: bind<sda1>
[   38.536733] md: kicking non-fresh sdd1 from array!
[   38.536751] md: unbind<sdd1>
[   38.536765] md: export_rdev(sdd1)
[   38.536794] raid5: device sda1 operational as raid disk 0
[   38.536812] raid5: device sdc1 operational as raid disk 2
[   38.536831] raid5: device sdb1 operational as raid disk 1
[   38.537453] raid5: allocated 4195kB for md0
[   38.537471] raid5: raid level 5 set md0 active with 3 out of 4 devices, 
algor
ithm 2
[   38.537499] RAID5 conf printout:
[   38.537513]  --- rd:4 wd:3 fd:1
[   38.537528]  disk 0, o:1, dev:sda1
[   38.537543]  disk 1, o:1, dev:sdb1
[   38.537558]  disk 2, o:1, dev:sdc1
*********************************************

Most notable: [   38.536733] md: kicking non-fresh sdd1 from array!
What does this mean?

********* mdadm -E /dev/sdd1 ****************
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 7f103422:7be2c2ce:e67a70be:112a2914
  Creation Time : Tue May  9 01:11:41 2006
     Raid Level : raid5
    Device Size : 244187904 (232.88 GiB 250.05 GB)
     Array Size : 732563712 (698.63 GiB 750.15 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Tue Aug 22 01:42:36 2006
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 33b2d59b - correct
         Events : 0.765488

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     3       8       49        3      active sync   /dev/sdd1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1

*************************************************

What's happening here? What can I do? Do I have to readd sdd and resync? Or is 
there an easier way out? What causes these issues?


-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
