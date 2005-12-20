From: Sebastian Kuzminsky <seb@highlab.com>
Subject: Raid sync observations
Date: Tue, 20 Dec 2005 10:18:26 -0700
Message-ID: <E1Eol86-0008Ju-3J@highlab.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I just created a RAID array (4-disk RAID-6).  When "mdadm -C" returned,
/proc/mdstat showed it syncing the new array at about 17 MB/s.  "vmstat 1"
showed hardly any blocks in or out, and an almost completely idle cpu.


Question 1: Why didnt the raid sync I/O show up with vmstat?


Question 2: Why was it limited to 17 MB per second?  The maximum was
left at the default, 200 MB/s.  The min was also at the default, 1 MB/s.
I get 60 MB/s per disk with "hdparm -tT" (that's using one disk at a time,
but still).  The checksumming code does > 3 GB/s.


Just curious really.  This is with 2.6.15-rc5 and SATA disks via libata.


-- 
Sebastian Kuzminsky
