From: "Janos Haar" <janos.haar@netcenter.hu>
Subject: question about sb, if somebody have a little time to help
Date: Thu, 20 May 2010 01:19:26 +0200
Message-ID: <1b9201caf7a9$bc6304a0$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-2";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello list,

I am trying to recover data from linux based NAS box wich uses sw raid.
Unfortunately i have no the box nor the original disks, only the raw copy of 
the drives.
I know this is hard, but this is a challenge for me.

I know that, the original raid structure was RAID5 from 3 disks + 1 spare.
The owner tried to move the disks across the slots, now i have found only 
one original superblock, but this looks like strange too for me:

/dev/sdi3:
          Magic : a92b4efc
        Version : 00.90.00
       UUID : 9604e5ec:2c1ee6c4:39d34560:27adacf1
  Creation Time : Tue Jan 24 15:13:05 2006
     Raid Level : raid5
    Device Size : 195069184 (186.03 GiB 199.75 GB)
     Array Size : 390138368 (372.06 GiB 399.50 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0

    Update Time : Mon May 10 12:43:09 2010
          State : clean
 Active Devices : 1
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 682ebe56 - correct
         Events : 0.116

         Layout : left-asymmetric
     Chunk Size : 4K

      Number   Major   Minor   RaidDevice State
this     3      33        3        3      spare

   0     0      56        3        0      active sync
   1     1      57        3        1      faulty
   2     2       0        0        2      faulty removed
   3     3      33        3        3      spare


My questions:
- If this is a spare drive, should be moved (rebuild) to the #2 no, because 
the #2 failed and than removed, no?
- how can be "clean" this array?
- Is there a way to get information about the failing order or time?

(The May 10 was the fail of the nas.)

Somebody have any idea, how can this be?

Thanks,
Janos Haar 

