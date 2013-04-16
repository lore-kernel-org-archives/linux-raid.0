From: Robin Dong <robin.k.dong@gmail.com>
Subject: Question about resync in RAID5
Date: Tue, 16 Apr 2013 18:02:40 +0800
Message-ID: <1366106560-12957-1-git-send-email-robin.k.dong@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Raid experts,

I have a soft RAID5 volume and after one disk failed I replaced it with
a new hard-disk. Then the raid5 volume begin to resync with WHOLE new
disk.
There is only 1G data in the RAID5 volume so I think resync whole disk
is not efficient.
Take ZFS for example, when replacing with a new disk, it only resync the
data which are written after the creation of the volume.

Is there any method to just resync WRITTEN data to new-added-disk ? Or
any developing plan to add this feature?
