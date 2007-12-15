From: mangaskahn <mangaskahn@yahoo.com>
Subject: Please Help!!! Raid 5 reshape failed!
Date: Fri, 14 Dec 2007 17:21:54 -0800 (PST)
Message-ID: <14339886.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


It started off a fairly simple project, install 2 new drives and use those in
combination with 2 existing drives to store my music and movie collection.
(about 7-10 years worth of collecting.) I installed the drives fine, Created
a raid 1 from the 2 new drives and reshaped it into a 2 disk raid 5 as
suggested here: http://scott.wallace.sh/node/1521 After the drives resynced,
I moved my data into it and added my 2 existing drives as the article
instructed. Looking back, it probably would have been better to do it one at
time. During the second resync, the Murphy struck; 1 of the old drives
failed and the other stopped. I figured a missing disk shouldn't be too much
of a problem, being a raid 5 array, but in the middle of a resync, it
probably was not good. Of course I was doing this with no backup. Now that
you know my life story, I pose this question.

I am trying to bring the array back on-line with the 3 remaining disks to
finish the resync, but mdadm is not cooperating. Please Help!

gentoofs ~#mdadm --assemble /dev/md1 /dev/sdc /dev/sdd /dev/sdf
mdadm: /dev/md1 assembled from 2 drives - not enough to start the array

The results of cat /proc/mdstat are:

Personalities : [raid1] [raid6] [raid5] [raid4]
md1 : inactive sdd[0](S) sdc[2](S) sdf[1](S)
1465158912 blocks

unused devices: <none>\

The results of mdstat --query /dev/md1 /dev/sdc /dev/sdd /dev/sdf are:

/dev/md1: is an md device which is not active
/dev/sdc: is not an md array
/dev/sdc: device 2 in 4 device undetected raid5 /dev/md1. Use mdadm
--examine for more detail.
/dev/sdd: is not an md array
/dev/sdd: device 0 in 4 device undetected raid5 /dev/md1. Use mdadm
--examine for more detail.
/dev/sdf: is not an md array
/dev/sdf: device 1 in 4 device undetected raid5 /dev/md1. Use mdadm
--examine for more detail.

The results of mdstat --examine /dev/sdc /dev/sdd /dev/sdf are:

/dev/sdc:
Magic : a92b4efc
Version : 00.91.00
UUID : 50e20ea1:18efd436:86ef0f3e:0c0af959
Creation Time : Tue Dec 11 13:03:23 2007
Raid Level : raid5
Used Dev Size : 488386304 (465.76 GiB 500.11 GB)
Array Size : 1465158912 (1397.28 GiB 1500.32 GB)
Raid Devices : 4
Total Devices : 3
Preferred Minor : 1

Reshape pos'n : 418942464 (399.53 GiB 429.00 GB)
Delta Devices : 2 (2->4)

Update Time : Thu Dec 13 16:00:27 2007
State : clean
Active Devices : 3
Working Devices : 3
Failed Devices : 1
Spare Devices : 0
Checksum : 83cfc18e - correct
Events : 0.91680

Layout : left-symmetric
Chunk Size : 256K

Number Major Minor RaidDevice State
this 2 8 32 2 active sync /dev/sdc

0 0 8 48 0 active sync /dev/sdd
1 1 8 80 1 active sync /dev/sdf
2 2 8 32 2 active sync /dev/sdc
3 3 0 0 3 faulty removed
/dev/sdd:
Magic : a92b4efc
Version : 00.91.00
UUID : 50e20ea1:18efd436:86ef0f3e:0c0af959
Creation Time : Tue Dec 11 13:03:23 2007
Raid Level : raid5
Used Dev Size : 488386304 (465.76 GiB 500.11 GB)
Array Size : 1465158912 (1397.28 GiB 1500.32 GB)
Raid Devices : 4
Total Devices : 3
Preferred Minor : 1

Reshape pos'n : 418942464 (399.53 GiB 429.00 GB)
Delta Devices : 2 (2->4)

Update Time : Thu Dec 13 16:44:49 2007
State : clean
Active Devices : 2
Working Devices : 2
Failed Devices : 2
Spare Devices : 0
Checksum : 83cfcc23 - correct
Events : 0.91692

Layout : left-symmetric
Chunk Size : 256K

Number Major Minor RaidDevice State
this 0 8 48 0 active sync /dev/sdd

0 0 8 48 0 active sync /dev/sdd
1 1 8 80 1 active sync /dev/sdf
2 2 0 0 2 faulty removed
3 3 0 0 3 faulty removed
/dev/sdf:
Magic : a92b4efc
Version : 00.91.00
UUID : 50e20ea1:18efd436:86ef0f3e:0c0af959
Creation Time : Tue Dec 11 13:03:23 2007
Raid Level : raid5
Used Dev Size : 488386304 (465.76 GiB 500.11 GB)
Array Size : 1465158912 (1397.28 GiB 1500.32 GB)
Raid Devices : 4
Total Devices : 3
Preferred Minor : 1

Reshape pos'n : 418942464 (399.53 GiB 429.00 GB)
Delta Devices : 2 (2->4)

Update Time : Thu Dec 13 16:44:49 2007
State : clean
Active Devices : 2
Working Devices : 2
Failed Devices : 2
Spare Devices : 0
Checksum : 83cfcc45 - correct
Events : 0.91692

Layout : left-symmetric
Chunk Size : 256K

Number Major Minor RaidDevice State
this 1 8 80 1 active sync /dev/sdf

0 0 8 48 0 active sync /dev/sdd
1 1 8 80 1 active sync /dev/sdf
2 2 0 0 2 faulty removed
3 3 0 0 3 faulty removed
-- 
View this message in context: http://www.nabble.com/Please-Help%21%21%21-Raid-5-reshape-failed%21-tp14339886p14339886.html
Sent from the linux-raid mailing list archive at Nabble.com.

