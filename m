From: Sedlak Anton <ased@cce.cz>
Subject: raid1 allow unintentional mount of low devices ...!!!
Date: Thu, 13 Feb 2003 11:54:45 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E4B7975.2010005@cce.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: jakob@unthought.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

|Problem description in RAID1 - MIRROR - kernel-2.4.20, 
raidtool2-0.90.200109:
it look that while mirror raiddev is mounted and working it is possible 
to mount devices
that constitute that raid1. It means that it is also possible to mount 
it when raid is stopped.
And here is the problem: while in first case I can check if there is any 
raid devices in advance using 'mount'
in second I have no chance to do that - no partition type FD.

Consider raid1 setup: /dev/md0 consist of /dev/hda1 and /dev/hdb1
After (unintentional||) mounting /dev/hda1 I see on ext3 or ReiserFS: 
journal reply n records.
These records was replied without notice of raid system - later I made 
check - creating dir or file
on /dev/hda1 was not recognised by /dev/md0.

Because I don't know in which state is now raid1 I always copy 
everything to clean disk,
reformat raid and copy back - but this take a lot of time.

I appreciate any suggestion how to synchronise low devices with raid 
device or how
to recognise in advance that given device is part of raid or to patch 
'mount' to roar
that there could be such problem.

Sedlak Anton <ased@cce.cz>

used config: /etc/raidtab

raiddev /dev/md0
|

|        raid-level      1
        nr-raid-disks   2
        nr-spare-disks  0
        chunk-size     4
        persistent-superblock 1
        device          /dev/hda1
        raid-disk       0
        device          /dev/hdb1
        raid-disk       1
|



