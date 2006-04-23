From: Anssi Hannula <anssi.hannula@gmail.com>
Subject: Recovery speed at 1MB/s/device, unable to change
Date: Sun, 23 Apr 2006 22:22:15 +0300
Message-ID: <444BD3E7.4090601@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I created a raid array:
---
# mdadm --create /dev/md_d0 -ap --level=5 --raid-devices=2 \
/dev/sda1 missing
---

Then partitioned it:
---
# LANGUAGE=C fdisk -l /dev/md_d0

Disk /dev/md_d0: 250.0 GB, 250056605696 bytes
2 heads, 4 sectors/track, 61048976 cylinders
Units = cylinders of 8 * 512 = 4096 bytes

      Device Boot      Start         End      Blocks   Id  System
/dev/md_d0p1               1    61048976   244195902   83  Linux
---

Then made a ext3 filesystem in /dev/md_d0p1 with mke2fs.

Then I added another device:
---
# mdadm --manage /dev/md_d0 --add /dev/sdb1
---

Currently status is:
---
# cat /proc/mdstat
Personalities : [raid0] [raid5] [raid4]
md_d0 : active raid5 sdb1[2] sda1[0]
      244195904 blocks level 5, 64k chunk, algorithm 2 [2/1] [U_]
      [>....................]  recovery =  1.0% (2588800/244195904)
finish=2100.4min speed=1916K/sec

unused devices: <none>
---

The speed is only 2000K/sec, even after I set:
---
# cat /proc/sys/dev/raid/speed_limit_min
10000
# cat /proc/sys/dev/raid/speed_limit_max
400000
---

The system is about 90% idle, so there should be more bandwidth.

---
# cat /proc/version
Linux version 2.6.17-rc2-git4 (anssi@delta.onse.fi) (gcc version 4.0.1
(4.0.1-5mdk for Mandriva Linux release 2006.0)) #1 Sun Apr 23 00:56:30
EEST 2006
---


Any tips?

-- 
Anssi Hannula

