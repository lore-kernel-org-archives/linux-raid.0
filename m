From: Mike Barnard <mike@tracersinfo.com>
Subject: Problems with huge filesystem
Date: Mon, 12 Apr 2004 12:25:58 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <407AC316.8040605@tracersinfo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

    Hi, folks. My apologies if this has been asked and answered, but a 
quick scan of the archives didn't turn up anything helpful. I'm trying 
to create a huge filesystem with Linux software RAID and I'm running 
into a problem. I'm not even sure if the problem is with raidtools or 
the standard Linux filesystem utilities.

    I've got two Promise IDE hardware RAID boxes chock full o' 200GB 
disks, 1.1 TB usable space each. For those unfamiliar with these boxes, 
they are external SCSI devices that combine a slew of IDE drives into 
one big SCSI RAID array. I'm trying to use Linux software raid (raid 1) 
to combine the two boxes into one single 2.2TB filesystem.

    When I run mkraid, it exits and tells me it's created an array of 
about 2.2TB, like it should. But then when I run any of the other utils 
(mkfs.jfs, mkreiserfs, fdisk) they only ever see about 200 GB. I can, of 
course, cut and paste screen captures of all this stuff if anyone wants 
to see it. I've created 1TB+ reiserfs and jfs filesystems before without 
any problem, incidentally, using just the individual RAID boxes as 
single disks.

    I'm running Redhat Linux 9 with the stock 2.4.20smp kernel on a dual 
Athlon MP 1800+ box with 2G RAM.

Here's my raidtab:

raiddev /dev/md0
        raid-level      0
        nr-raid-disks   2
        persistent-superblock   1
        chunk-size      64
        device          /dev/sda1
        raid-disk       0
        device          /dev/sdb1
        raid-disk       1

    Any help would be greatly appreciated! Thanks in advance!

