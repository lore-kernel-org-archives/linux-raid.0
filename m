From: CoolCold <coolthecold@gmail.com>
Subject: repartitioning disks
Date: Tue, 17 May 2011 12:20:50 +0400
Message-ID: <BANLkTim5A1HEiPrRMxiUFZ4PGuyc4pbG-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Wiki says: "Never NEVER never re-partition disks that are part of a
running RAID. If you must alter the partition table on a disk which is
a part of a RAID, stop the array first, then repartition. " -
https://raid.wiki.kernel.org/index.php/Tweaking,_tuning_and_troubleshooting#Pitfalls

Is it really true for situations like - I have 2x1Tb drives, which are
already partitioned like /dev/sd{a,b}1 - 500mb, /boot & /dev/sd{a,b}2
- 20gb, / and are assembled in RAID1 arrays md0 & md1 accordingly. So,
if I want to create one more RAID1 array , say md3 from the rest of
the drives.
So i take my cfdisk ,add new partition with some space 100-150mb from
the end, do write changes & partprobe the drives, then creating new
array.

Is it bad? To be honest i'm doing this all the time and can't
understand how this gonna hurt md. Neil and/or others, please clarify
this.


-- 
Best regards,
[COOLCOLD-RIPN]
