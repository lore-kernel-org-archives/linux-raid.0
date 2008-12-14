From: Michal Soltys <soltys@ziu.info>
Subject: Re: Raid 5 Problem
Date: Sun, 14 Dec 2008 16:34:06 +0100
Message-ID: <4945276E.1010405@ziu.info>
References: <49450D04.8060703@nigelterry.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49450D04.8060703@nigelterry.net>
Sender: linux-raid-owner@vger.kernel.org
To: nterry <nigel@nigelterry.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

nterry wrote:
> Hi.  I hope someone can tell me what I have done wrong.  I have a 4 disk 
> Raid 5 array running on Fedora9.  I've run this array for 2.5 years with 
> no issues.  I recently rebooted after upgrading to Kernel 2.6.27.7.  
> When I did this I found that only 3 of my disks were in the array.  When 
> I examine the three active elements of the array (/dev/sdd1, /dev/sde1, 
> /dev/sdc1) they all show that the array has 3 drives and one missing.  
> When I examine the missing drive it shows that all members of the array 
> are present, which I don't understand! When I try to add the missing 
> drive back is says the device is busy.  Please see below and let me know 
> what I need to do to get this working again.  Thanks Nigel:
> 
> ==================================================================
> [root@homepc ~]# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sdd1[0] sdc1[3] sde1[1]
>      735334656 blocks level 5, 128k chunk, algorithm 2 [4/3] [UU_U]
>     md_d0 : inactive sdb[2](S)
>      245117312 blocks
>      unused devices: <none>
> [root@homepc ~]#

For some reason, it looks like you have 2 raid arrays visible - md0 and 
md_d0. The latter took sdb (not sdb1) as its component.

sd{c,d,e}1 is in assembeld array (with appropriately updated 
superblocks), thus mdadm --examine calls show one device as removed, but 
sdb is part of another inactive array, and the superblock is untouched 
and shows "old" situation. Note that 0.9 superblock is stored at the end 
  of the device (see md(4) for details), so its position could be valid 
for both sdb and sdb1.

This might be an effect of --incremental assembly mode. Hard to tell 
more without seeing startup scripts, mdadm.conf, udev rules, partition 
layout... Did upgrade involve anything more besides kernel ?

Stop both arrays, check mdadm.conf, assemble md0 manually (mdadm -A 
/dev/md0 /dev/sd{c,d,e}1 ), verify situation with mdadm -D. If 
everything looks sane, add /dev/sdb1 to the array. Still, w/o checking 
out startup stuff, it might happen again after reboot. Adding DEVICE 
/dev/sd[bcde]1 to mdadm.conf might help though.

Wait a bit for other suggestions as well.

