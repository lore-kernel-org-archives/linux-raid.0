From: Mike Muratet <muratetm@gmail.com>
Subject: Converting RAID5 to RAID0
Date: Sun, 31 Aug 2014 12:43:26 +0000 (UTC)
Message-ID: <loom.20140831T143354-68@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am doing some experiments with mdadm to combine two 1TB disks into a RAID
array. I used fdisk to create the partitions and mdadm to create a two disk
RAID5 array. I would like to have more space and I can live without
redundancy. I searched the man pages and boards for a way to do that and found:

$ sudo mdadm /dev/md0 -f /dev/sdd
mdadm: set /dev/sdd faulty in /dev/md0
$ sudo mdadm /dev/md0 -r /dev/sdd
mdadm: hot removed /dev/sdd from /dev/md0
$ sudo echo raid0 > /sys/block/md0/md/level

-bash: /sys/block/md0/md/level: Permission denied

which was not the result I expected.

Is it possible to convert RAID5 to RAID0?

There are no data on the disk. Is there a way to start over?

Cheers

Mike

