From: Jeremy Sanders <jss@ast.cam.ac.uk>
Subject: Raid and badblocks
Date: Fri, 22 May 2009 10:09:13 +0100
Message-ID: <gv5q3p$vof$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We have a linux RAID 5 md setup with 10 disks controlled using a 3ware 
9650se card. Here is /proc/mdstat:

Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdb1[0] sdk1[9] sdj1[8] sdi1[7] sdh1[6] sdg1[5] sdf1[4] 
sde1[3] sdd1[2] sdc1[1]
      8788959360 blocks level 5, 32k chunk, algorithm 2 [10/10] [UUUUUUUUUU]

The built-in 3ware autoverify feature found some bad blocks on sdj. To try 
to correct these I ran:

echo repair > /sys/block/md0/md/sync_action

This completed with no errors, but the bad blocks have not gone away. 
Smartctl has these entries:

197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       
-       1
198 Offline_Uncorrectable   0x0030   100   100   000    Old_age   Offline      
-       1

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  
LBA_of_first_error
# 1  Extended offline    Completed: read failure       90%       961         
1953103085

I also tried a check on md0, but it found no errors. If I run a badblocks 
read test directly on sdj, it finds bad blocks. A smartctl long test also 
finds the problems.

Isn't the check/repair supposed to find bad blocks and report/repair them? I 
thought a check would read all the data off all the disks and check for 
inconsistencies. How can I get these bad blocks repaired?

The kernel is Fedora 10, 2.6.29.2-52.fc10.x86_64.

Thanks

Jeremy

-- 
Jeremy Sanders <jss@ast.cam.ac.uk>   http://www-xray.ast.cam.ac.uk/~jss/



