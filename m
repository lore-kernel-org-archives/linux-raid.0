From: Troy Cauble <troycauble@gmail.com>
Subject: system upgrade reordered drives, confused software raid-1
Date: Mon, 19 Jan 2009 23:19:17 -0500
Message-ID: <6d344ffd0901192019t2e9f1e59q862fed68a68ea4a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I recently upgraded an Ubuntu box and noticed that my drives got reordered
(possibly by a SATA driver change) and my RAID-1 is degraded.

Originally...
My (PATA) OS drive had some other partitions and *was* known as /dev/sda.
My (SATA) raid-1 /home *was* made from /dev/sdb and /dev/sdc.

Now my OS drive is sdc with side effects like mounting some sdc partitions
on my old sda mount points. (not a big deal)

The real problem is the RAID-1. I think the following 3 queries say:
1) the raid is running with SDA, with the other drive removed.
2) SDA is clean and part of md0
3) SDB is "clean", but part of a raid that doesn't exist.


Quote:
mastershake:~> sudo mdadm --detail /dev/md0
/dev/md0:
Version : 00.90.03
Creation Time : Sun Jan 2 12:53:01 2005
Raid Level : raid1
Array Size : 244195904 (232.88 GiB 250.06 GB)
Used Dev Size : 244195904 (232.88 GiB 250.06 GB)
Raid Devices : 2
Total Devices : 1
Preferred Minor : 0
Persistence : Superblock is persistent

Update Time : Sun Jan 18 23:33:56 2009
State : clean, degraded
Active Devices : 1
Working Devices : 1
Failed Devices : 0
Spare Devices : 0

UUID : 61645020:223a69dc:12d77363:0c0f047d
Events : 0.5125062

Number Major Minor RaidDevice State
0 8 1 0 active sync /dev/sda1
1 0 0 1 removed


Quote:
mastershake:~> sudo mdadm --examine /dev/sda1
/dev/sda1:
Magic : a92b4efc
Version : 00.90.00
UUID : 61645020:223a69dc:12d77363:0c0f047d
Creation Time : Sun Jan 2 12:53:01 2005
Raid Level : raid1
Used Dev Size : 244195904 (232.88 GiB 250.06 GB)
Array Size : 244195904 (232.88 GiB 250.06 GB)
Raid Devices : 2
Total Devices : 1
Preferred Minor : 0

Update Time : Sun Jan 18 23:34:36 2009
State : clean
Active Devices : 1
Working Devices : 1
Failed Devices : 1
Spare Devices : 0
Checksum : e627430d - correct
Events : 0.5125064


Number Major Minor RaidDevice State
this 0 8 1 0 active sync /dev/sda1

0 0 8 1 0 active sync /dev/sda1
1 1 0 0 1 faulty removed
Quote:


mastershake:~> sudo mdadm --examine /dev/sdb1
/dev/sdb1:
Magic : a92b4efc
Version : 00.90.00
UUID : 61645020:223a69dc:12d77363:0c0f047d
Creation Time : Sun Jan 2 12:53:01 2005
Raid Level : raid1
Used Dev Size : 244195904 (232.88 GiB 250.06 GB)
Array Size : 244195904 (232.88 GiB 250.06 GB)
Raid Devices : 2
Total Devices : 2
Preferred Minor : 0

Update Time : Tue Sep 16 07:38:13 2008
State : clean
Active Devices : 2
Working Devices : 2
Failed Devices : 0
Spare Devices : 0
Checksum : e5808830 - correct
Events : 0.5048904


Number Major Minor RaidDevice State
this 1 8 33 1 active sync /dev/sdc1

0 0 8 17 0 active sync /dev/sdb1
1 1 8 33 1 active sync /dev/sdc1


I've touched files on the degraded md0, so sdb is out-of-date.

So what's the safest way to fix this? I've never had to rebuild before.

Do I need to fail, remove, then add sdb?  Can I
    mdadm -f /dev/md0 /dev/sdb1
if md0 doesn't thinks sdb is part of it?

Or does "removed" in the md0 output mean I don't need to
fail and remove, just add?

Or do I need to "assemble"?  I really don't understand when to use what.

Thanks,
-troy
