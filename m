From: Ming Zhang <mingz@ele.uri.edu>
Subject: raid 1 random write performance is better than the disk?
Date: Fri, 26 Dec 2003 23:13:44 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1072498424.2867.41.camel@localhost.localdomain>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, Happy new year!

I have a question on raid 1 performance. I setup a simple two disk raid1
on a p4 pc and used iometer to measure the random write performance. 

*the disks i used are two same seagate 18gb 15k rpm scsi disks. disks
are connected to different channels in one aic7xxx controller.
*the raid1 device is md0. 
*the iometer workload is 100% random 100% write 4k request size,
outstanding request number 1. i run test with 1 hours.
*i changed the raid1 code slightly. in raid1_make_request(), i change
	mirror = conf->mirrors + raid1_read_balance(conf, bh);
to
	mirror = conf->mirrors;
so there is no read balance and raid1 only read from the first scsi
disk.


i ran iometer on /dev/sda, the IO per second is 260.
i ran iometer on /dev/md0, the IO per second is 290.


can anybody tell me why md0 is faster than sda? i had assumed that md0
can not be faster than sda at this situation. since regularly raid1 can
improve read performance but not write performance. so the raid1 write
performance should be the same with the slowest device i used. but here
sth different happened.

and i noticed that even i set to 100% write, there are still many read
activities on first scsi disk shown by iostat. one test result is

Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
dev3-0            0.15         1.60         1.42      37170      33082
dev8-0           15.60        13.76        64.24     320452    1496416
dev8-1            8.70         0.00        64.24         48    1496416

i think i already choose the request size to be 4k, which is page size,
but why here still so many reads?



ming


