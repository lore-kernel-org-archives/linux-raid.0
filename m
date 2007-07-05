From: Simon <simon.xhz@gmail.com>
Subject: Re: AW: The array is functioning normally (?)
Date: Thu, 05 Jul 2007 11:29:51 -0400
Message-ID: <468D0E6F.7090303@gmail.com>
References: <7AAD212492598A4A92463C3F5D34C54F3DD373@ccd3.cc.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <7AAD212492598A4A92463C3F5D34C54F3DD373@ccd3.cc.de>
Sender: linux-raid-owner@vger.kernel.org
To: "Heinzmann, Robert" <Heinzmann@cc-dresden.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> I made the 3 devices faulty.  I wonder why it's still clean 
>> and --test says it's functionning normally?!
> 
> Same here with a RAID1 when I kill the last disk.

Additionally, when I try to remove one of these faulty devices and add it again, 
THEN i get some indication that the array is not so good anymore:

# mdadm /dev/md1 -r /dev/sdd2
mdadm: hot removed /dev/sdd2
# mdadm /dev/md1 -a /dev/sdd2
mdadm: cannot find valid superblock in this array - HELP

I got the same exact message when I tried with the 3 drives, obviously it is 
because the array is no longer there...  and a final output of several programs 
give the output below.  Stoping the array prevents me from starting it again. 
Assembling fails too (not enough disk to start the array):

mdadm: /dev/sdd2 is identified as a member of /dev/md1, slot 3.
mdadm: /dev/sdb2 is identified as a member of /dev/md1, slot 2.
mdadm: /dev/sdc2 is identified as a member of /dev/md1, slot 1.
mdadm: no uptodate device for slot 0 of /dev/md1
mdadm: added /dev/sdc2 to /dev/md1 as 1
mdadm: added /dev/sdd2 to /dev/md1 as 3
mdadm: added /dev/sdb2 to /dev/md1 as 2
mdadm: /dev/md1 assembled from 1 drive and 1 spare - not enough to start the array.
(or with -R, ends with)
mdadm: failed to RUN_ARRAY /dev/md1: Input/output error
mdadm: Not enough devices to start the array.


===(`/sbin/mdadm -v -v --detail /dev/md1`)======================================
/dev/md1:
         Version : 00.90.03
   Creation Time : Tue Jul  3 16:29:38 2007
      Raid Level : raid5
      Array Size : 2011648 (1964.83 MiB 2059.93 MB)
   Used Dev Size : 1005824 (982.41 MiB 1029.96 MB)
    Raid Devices : 3
   Total Devices : 0
Preferred Minor : 1
     Persistence : Superblock is persistent

     Update Time : Thu Jul  5 11:25:32 2007
           State : clean, degraded
  Active Devices : 0
Working Devices : 0
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 64K

     Number   Major   Minor   RaidDevice State
        0       0        0        0      removed
        1       0        0        1      removed
        2       0        0        2      removed
-------------------------  Return was: 0  ---[ 0 = running | 256 = inactive ]---
===(`/sbin/lsraid -a /dev/md1`)=================================================
[dev   9,   1] /dev/md1         00000000.00000000.00000000.00000000 online
[dev   ?,   ?] (unknown)        00000000.00000000.00000000.00000000 missing
[dev   ?,   ?] (unknown)        00000000.00000000.00000000.00000000 missing
[dev   ?,   ?] (unknown)        00000000.00000000.00000000.00000000 missing

------------------------------------------------------------  Return was: 0  ---
Return from `/sbin/mdadm /dev/md1 --detail --test` gave:
mdadm: The array is functioning normally.
================================================================================
