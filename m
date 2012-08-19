From: Kyle Brantley <kyle@averageurl.com>
Subject: Issue with md and 4K sector alignment
Date: Sun, 19 Aug 2012 15:06:51 -0600
Message-ID: <5031556B.5050706@averageurl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've got a set of 9x3TB drives that I'm trying to place in RAID6. These 
have the 512B/4096B logical/physical compatibility emulation:

Model: ATA ST3000DM001-1CH1 (scsi)
Disk /dev/sda: 3001GB
Sector size (logical/physical): 512B/4096B

This is being run on CentOS6:

mdadm - v3.2.3 - 23rd December 2011
Linux vmbox 2.6.32-279.5.1.el6.x86_64 #1 SMP Tue Aug 14 23:54:45 UTC 
2012 x86_64 x86_64 x86_64 GNU/Linux


In general, I'm having a hard time telling the md subsystem to align to 
4K sectors. This is evident in a few ways:

* resync speed / time

Default 512k chunk:
       20511855616 blocks super 1.2 level 6, 512k chunk, algorithm 2 
[9/9] [UUUUUUUUU]
       [>....................]  resync =  0.0% (187904/2930265088) 
finish=1559.2min speed=31317K/sec

4k chunk size (no functional change):
       20511857968 blocks super 1.2 level 6, 4k chunk, algorithm 2 [9/9] 
[UUUUUUUUU]
       [>....................]  resync =  0.0% (475820/2930265424) 
finish=1436.6min speed=33987K/sec


I rebuilt the array  with --assume-clean and default chunk size, and 
then ran some simple tests with dd.

* Read test, not 4K aligned:
[root@vmbox ~]# dd if=/dev/md127 of=/dev/zero
12228837376 bytes (12 GB) copied, 30.568 s, 400 MB/s
24344251904 bytes (24 GB) copied, 60.9207 s, 400 MB/s

* Read test, manually 4K aligned:
[root@vmbox ~]# dd if=/dev/md127 of=/dev/zero bs=4096
18783485952 bytes (19 GB) copied, 30.7766 s, 610 MB/s
37306327040 bytes (37 GB) copied, 61.1433 s, 610 MB/s

* Write test, not 4K aligned:
[root@vmbox ~]# dd if=/dev/zero of=/dev/md127
774734336 bytes (775 MB) copied, 31.1458 s, 24.9 MB/s
1438485504 bytes (1.4 GB) copied, 61.5351 s, 23.4 MB/s

* Write test, manually 4K aligned, and ran over a much longer period of 
time to ensure that the buffers don't get in the way:
30602686464 bytes (31 GB) copied, 121.036 s, 253 MB/s
63765032960 bytes (64 GB) copied, 301.284 s, 212 MB/s

Or, in other words, I'm seeing a 200MB/sec (+1.5x) read boost if I 
manually align the I/O, and a 200MB/sec (+10x) write boost if manually 
aligned. Note how the non-aligned dd run more or less matches the resync 
speeds listed above.

I understand that I may need to work on the higher layers (LVM, 
partitioning -- and if there is any insight here, it would be 
appreciated!) with respect to the alignment, but my concern is the 
resync times. I've tried building the array off of both the raw disks 
and 4K aligned partitions placed on the disks -- the resync performance 
is identical, and poor.

How exactly should I construct this array to fix the resync time / align 
the I/O? I've searched everywhere that I can find but have yet to find a 
solution.

Thanks for any insight!
--Kyle
