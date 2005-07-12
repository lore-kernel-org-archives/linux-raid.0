From: Laurent CARON <lcaron@apartia.fr>
Subject: Raid, resync and hotspare
Date: Tue, 12 Jul 2005 17:33:08 +0200
Message-ID: <42D3E2B4.1070605@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I recently moved a server from old disks to now ones and added a 
hotspare (mdadm /dev/md1 -a /dev/sdf2)

the hotspare appears in  /proc/mdstat

Personalities : [linear] [raid0] [raid1] [raid5] [multipath] [raid6]
md1 : active raid5 sdf2[5] sde2[4] sdd2[3] sdc2[2] sdb2[1] sda2[0]
      285699584 blocks level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]


when I fail a disk, mdadm does *not* send me any warning.

Only at the second failure when the array is in degraded state I receive 
a warning.

How may I receive a warning when the hotspare disk has been used to cope 
with a disk failure?

Thanks
