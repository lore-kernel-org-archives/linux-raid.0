From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid 5 rebuild with only 2 spare devices
Date: Thu, 10 Feb 2011 13:53:55 -0500
Message-ID: <4D543443.9060709@turmel.org>
References: <4D542872.3090102@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D542872.3090102@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Heilberg <theilberg42@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Thomas,

On 02/10/2011 01:03 PM, Thomas Heilberg wrote:
> Hi!
> 
> Sorry for my bad English. I'm from Austria and this is also my first "mailinglist-post".

Welcome!  (Your English looks fine to me--and I've had 40+ years of practice.)
> 
> I have a problem with my RAID5. The raid has only 1 active devices out of 3. The other 2 devices are detected as spare.
> This is what happens when I try to assemble the raid(I'm using loop devices because I'm working with backup files):

Working from backups is a very good plan!

> root@backup-server:/media# mdadm --assemble --force /dev/md2 /dev/loop0 /dev/loop1 /dev/loop2
> mdadm: /dev/md2 assembled from 1 drive and 2 spares - not enough to start the array.
> 
> root@backup-server:/media# cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
> md2 : inactive loop1[0](S) loop2[4](S) loop0[3](S)
>       4390443648 blocks
> 
> unused devices: <none>
> 
> root@backup-server:/media# mdadm -R /dev/md2
> mdadm: failed to run array /dev/md2: Input/output error
> 
> root@backup-server:/media# mdadm -D /dev/md2
> /dev/md2:
>         Version : 0.90
>   Creation Time : Thu Nov 19 21:09:37 2009
>      Raid Level : raid5
>   Used Dev Size : 1463481216 (1395.68 GiB 1498.60 GB)
>    Raid Devices : 3
>   Total Devices : 1
> Preferred Minor : 2
>     Persistence : Superblock is persistent
> 
>     Update Time : Sun Nov 14 14:12:44 2010
>           State : active, FAILED, Not Started
>  Active Devices : 1
> Working Devices : 1
>  Failed Devices : 0
>   Spare Devices : 0
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>            UUID : 9665c475:31f17aa2:83a3570a:c5b3b84e
>          Events : 0.3352467
> 
>     Number   Major   Minor   RaidDevice State
>        0       7        1        0      active sync   /dev/loop1
>        1       0        0        1      removed
>        2       0        0        2      removed

Hmmm.  Not enough info here, and further steps destroy it.  Good thing you started over.

Please show "mdadm -E /dev/loop[0-2]" on fresh loop copies *before* trying any "create" or "add" operations.

> root@backup-server:/media# mdadm /dev/md2 -a /dev/loop0
> mdadm: re-added /dev/loop0
> root@backup-server:/media# mdadm /dev/md2 -a /dev/loop2
> mdadm: re-added /dev/loop2
> root@backup-server:/media# mdadm -D /dev/md2
> /dev/md2:
>         Version : 0.90
>   Creation Time : Thu Nov 19 21:09:37 2009
>      Raid Level : raid5
>   Used Dev Size : 1463481216 (1395.68 GiB 1498.60 GB)
>    Raid Devices : 3
>   Total Devices : 3
> Preferred Minor : 2
>     Persistence : Superblock is persistent
> 
>     Update Time : Sun Nov 14 14:12:44 2010
>           State : active, FAILED, Not Started
>  Active Devices : 1
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 2
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>            UUID : 9665c475:31f17aa2:83a3570a:c5b3b84e
>          Events : 0.3352467
> 
>     Number   Major   Minor   RaidDevice State
>        0       7        1        0      active sync   /dev/loop1
>        1       0        0        1      removed
>        2       0        0        2      removed
> 
>        3       7        0        -      spare   /dev/loop0
>        4       7        2        -      spare   /dev/loop2
> 
> I also tried to recreate the raid:
> 
> root@backup-server:/media# mdadm -Cv /dev/md2 -n3 -l5 /dev/loop0 /dev/loop1 /dev/loop2
> mdadm: layout defaults to left-symmetric
> mdadm: chunk size defaults to 512K
> mdadm: layout defaults to left-symmetric
> mdadm: layout defaults to left-symmetric
> mdadm: /dev/loop0 appears to be part of a raid array:
>     level=raid5 devices=3 ctime=Thu Nov 19 21:09:37 2009
> mdadm: layout defaults to left-symmetric
> mdadm: /dev/loop1 appears to be part of a raid array:
>     level=raid5 devices=3 ctime=Thu Nov 19 21:09:37 2009
> mdadm: layout defaults to left-symmetric
> mdadm: /dev/loop2 appears to be part of a raid array:
>     level=raid5 devices=3 ctime=Thu Nov 19 21:09:37 2009
> mdadm: size set to 1463479808K
> Continue creating array? y
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md2 started.

Yeah, mdadm was trying to tell you not to do that.  "--assume-clean" is really important when trying to recreate an array with existing data.

[trim /]

If the problem is just the event counts, "mdadm --assemble --force" is probably what you want, followed by "mdadm --readonly".  If pvscan shows your LVM subsystem at that point, try an fsck to see how much trouble you are in.

Phil
