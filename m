From: "Matthew - RAID" <RAID@lists.elvey.com>
Subject: Kluge Fails - Re: (Can I mark a RAID 1 drive as old?)
Date: Wed, 14 Jul 2004 11:41:49 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1089830509.12996.200366142@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 7/8/04 2:42 PM, Matthew (RAID) sent forth electrons to convey:

>I'm wondering how handle a situation.  There are several issues, would
>appreciate help w/ ANY ONE of 'em.
>I'm most of the way there - I've been able to use RAID to create a
>backup system, but it's far from quite right.
>
>I think I want to make the raid code consider a disk in a raid 1 array
>older than another disk, and/or move arrays around, and/or resolve a
>hang when I insert SCA drives into the system.
>[...]
>One system is an already live system serving users, the other is a warm
>backup.  I call 'em LIVE and BK. 
>I've been using raid to make BK a backup of LIVE..
>[...]
>If I add and remove drives with the sytem off, I hit a different set of
>problems:
>1)If the system comes up with half the drives removed, the drives get
>relabled : they are always sda, sdb, and sdc.
>  I could rearrange things so that it's sdd,sde,and sdf that get pulled,
>  but I don't know how to do that. Hence the second question in this
>  email's subject.
>2)If I put back the pulled drives, when the system restarts, sometimes
>these drives are chosen by the RAID code as being newer than the drives
>that haven't been pulled. Hence the first question in this email's
>subject.
>
I thought I found a kluge partial fix to this: run fdisk (actually I use
sfdisk) and repartition the drive with partitions of size 0.
The 'repartition' just writes to the partition table; the data on these
drives seems to remain untouched when a system boots with 'em.
I thought I'd be able to sfdisk back their normal partition tables and
raidhotadd 'em.

I tried this: I powered off and removed the second drive from the raid1
arrays, replacing them will 'filler drives' made with the kluge above.
Well,  on startup, md0 fails, and so md2 (the raid0 on top of md0 and
md1) fails too.
Error messages:
"Starting up raid devices : /dev/md0: Invalid argument"
"/dev/md0 is not a RAID0 or LINEAR array!"
"md0 raid1: md1, not all disks are  operational -- trying to recover
array"
"md1 /dev/md2: Invalid arcument"
"/dev/md2 must be a nonpersistent RAID0 or LINEAR array!
md2"
***

I tried marking sdb1 as failed and doing raidstart --all - no dice:
Invalid argument on md0,2. 1 already running.
raidstart /dev/md0 /dev/sdc1 gives
"device /dev/sdc1 is not decribed in config file."???  It is!!!  I don't
get this!
 fdisk on sdc shows what I'd expect.

> <rest snipped>

I'm about ready to give up and go with hardware raid. :(
