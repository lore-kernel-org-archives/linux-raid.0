From: "Greg Cormier" <gcormier@gmail.com>
Subject: Superblocks
Date: Fri, 26 Oct 2007 12:43:53 -0400
Message-ID: <29a863790710260943o7623212esce30325be4610dea@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Can someone help me understand superblocks and MD a little bit?

I've got a raid5 array with 3 disks - sdb1, sdc1, sdd1.

--examine on these 3 drives shows correct information.


However, if I also examine the raw disk devices, sdb and sdd, they
also appear to have superblocks with some semi valid looking
information. sdc has no superblock.

How can I clear these? If I unmount my raid, stop md0, it won't clear it.

[root@zeus ~]# mdadm --zero-superblock /dev/hdd
mdadm: Couldn't open /dev/hdd for write - not zeroing

I'd like to rule out these oddities before I start on my next
troubleshooting of why my array rebuilds every time I reboot :)

Thanks,
Greg
