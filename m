From: Phil Turmel <philip@turmel.org>
Subject: Re: How to recover after md crash during reshape?
Date: Tue, 20 Oct 2015 09:49:01 -0400
Message-ID: <5626464D.9000502@turmel.org>
References: <04cdcd6bd69b3aa1f8f24465f8485c90@tantosonline.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <04cdcd6bd69b3aa1f8f24465f8485c90@tantosonline.com>
Sender: linux-raid-owner@vger.kernel.org
To: andras@tantosonline.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning Andras,

On 10/19/2015 10:35 PM, andras@tantosonline.com wrote:
> Dear all,
> 
> I have a serious (to me) problem, and I'm seeking some pro advice in
> recovering a RAID6 volume after a crash at the beginning of a reshape.
> Thank you all in advance for any help!
> 
> The details:
> 
> I'm running Debian.
>     uname -r says:
>         kernel 3.2.0-4-amd64
>     dmsg says:
>         Linux version 3.2.0-4-amd64 (debian-kernel@lists.debian.org)
> (gcc version 4.6.3 (Debian 4.6.3-14) ) #1 SMP Debian 3.2.68-1+deb7u3
>     mdadm -v says:
>         mdadm - v3.2.5 - 18th May 2012
> 
> I used to have a RAID6 volume with 7 disks on it. I've recently bought
> another 3 new HDD-s and was trying to add them to the array.
> I've put them in the machine (hot-plug), partitioned them then did:
> 
>     mdadm --add /dev/md1 /dev/sdh1 /dev/sdi1 /dev/sdj1
> 
> This worked fine, /proc/mdstat showed them as three spares. Then I did:
> 
>     mdadm --grow --raid-devices=10 /dev/md1
> 
> Yes, I was dumb enough to start the process without a backup option -
> (copy-paste error from https://raid.wiki.kernel.org/index.php/Growing).

The normal way to recover from this mistake is to issue

mdadm --grow --continue /dev/md1 --backup-file .....

> This immediately (well, after 2 seconds) crashed the MD driver:

Crashing is a bug, of course, but you are using an old kernel.  New
kernels *generally* have fewer bugs than old kernels :-)  In newer
kernels it would have just held @ 0% progress while still otherwise running.

Same observation applies to the mdadm utility too.  Consider using a
relatively new rescue CD for further operations.

[trim /]

> Upon reboot, the array wouldn't assemble, it was complaining that SDA
> and SDA1 had the same superblock info on it.
> 
> mdadm: WARNING /dev/sda and /dev/sda1 appear to have very similar
> superblocks.
>       If they are really different, please --zero the superblock on one
>       If they are the same or overlap, please remove one from the
>       DEVICE list in mdadm.conf.

This is a completely separate problem, and the warning is a bit
misleading.  It is a side effect of version 0.90 metadata that could not
be solved in a backward compatible manner.  Which is why v1.x metadata
was created and became the default years ago.  Basically, v0.90
metadata, which is placed at the end of a device, when used on the last
partition of a disk, is ambiguous about whether it belongs to the last
partition or the disk as a whole.

Normally, you can update the metadata in place from v0.90 to v1.0 with
mdadm --assemble --update=metadata  ....

> At this point, I looked at the drives and it appeared that the drive
> letters got re-arranged by the kernel. My three new HDD-s (which used to
> be SDH, SDI, SDJ) now appear as SDA, SDB and SDD.

This is common and often screws people up.  The kernel assigns names
based on discovery order, which varies, especially with hotplugging.
You need a map of your array and its devices versus the underlying drive
serial numbers.  This is so important I created a script years ago to
generate this information.  Please download and run it, and post the
results here so we can precisely tailor the instructions we give.

https://github.com/pturmel/lsdrv

> I've read up on this a little and everyone seemed to suggest that you
> repair this super-block corruption by zeroing out the suport-block, so I
> did:
> 
>     mdadm --zero-superblock /dev/sda1

"Everyone" was wrong.  Your drives only had the one superblock.  It was
just misidentified in two contexts.  You destroyed the only superblock
on those devices.

[trim /]

> After this, the array would assemble, but wouldn't start, stating that
> it doesn't have enough disks in it - which is correct for the new array:
> I just removed 3 drives from a RAID6.
> 
> Right now, /proc/mdstat says:
> 
>     Personalities : [raid1] [raid6] [raid5] [raid4]
>     md1 : inactive sdh2[0](S) sdc2[6](S) sdj1[5](S) sde1[4](S)
> sdg1[3](S) sdi1[2](S) sdf2[1](S)
>           10744335040 blocks super 0.91
> 
> mdadm -E /dev/sdc2 says:
>     /dev/sdc2:
>               Magic : a92b4efc
>             Version : 0.91.00
>                UUID : 5e57a17d:43eb0786:42ea8b6c:723593c7
>       Creation Time : Sat Oct  2 07:21:53 2010
>          Raid Level : raid6
>       Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
>          Array Size : 11721087488 (11178.10 GiB 12002.39 GB)
>        Raid Devices : 10
>       Total Devices : 10
>     Preferred Minor : 1
> 
> 
>       Reshape pos'n : 4096
>       Delta Devices : 3 (7->10)
> 
> 
>         Update Time : Sat Oct 17 18:59:50 2015
>               State : active
>      Active Devices : 10
>     Working Devices : 10
>      Failed Devices : 0
>       Spare Devices : 0
>            Checksum : fad60788 - correct
>              Events : 2579239
> 
> 
>              Layout : left-symmetric
>          Chunk Size : 64K
> 
> 
>           Number   Major   Minor   RaidDevice State
>     this     6       8       98        6      active sync
> 
> 
>        0     0       8       50        0      active sync
>        1     1       8       18        1      active sync
>        2     2       8       65        2      active sync   /dev/sde1
>        3     3       8       33        3      active sync   /dev/sdc1
>        4     4       8        1        4      active sync   /dev/sda1
>        5     5       8       81        5      active sync   /dev/sdf1
>        6     6       8       98        6      active sync
>        7     7       8      145        7      active sync   /dev/sdj1
>        8     8       8      129        8      active sync   /dev/sdi1
>        9     9       8      113        9      active sync   /dev/sdh1
> 
> So, if I read this right, the superblock here states that the array is
> in the middle of a reshape from 7 to 10 devices, but it just started
> (4096 is the position).

Yup, just a little ways in at the beginning.  Probably where it tried to
write its first critical section to the backup file.

> What's interesting is the device names listed here don't match the ones
> reported by /proc/mdstat, and are actually incorrect. The right
> partition numbers are in /proc/mdstat.

Names in the superblock are recorded per the last successful assembly.
Which is why a map of actual roles vs. drive serial numbers is so important.

> I've read in here (http://ubuntuforums.org/showthread.php?t=2133576)
> among many other places that it might be possible to recover the data on
> the array by trying to re-create it to the state before the re-shape.

Yes, since you have destroyed those superblocks, and the reshape
position is so low.  You might lose a little at the beginning of your
array.  Or might not, if it crashed at the first critical section as I
suspect.

> I've also read that if I want to re-create an array in read-only mode, I
> should re-create it degraded.

Not necessary or recommended in this case.

> So, what I thought I would do is this:
> 
>     mdadm --create /dev/md1 --level=6 --raid-devices=7 /dev/sdh2
> /dev/sdf2 /dev/sdi1 /dev/sdg1 /dev/sde1 missing missing
> 
> Obviously, at this point, I'm trying to be as cautious as possible in
> not causing any further damage, if that's at all possible.

Good, because the above would destroy your array.  You'd get modern
defaults for metadata version, offset, and chunk size.

Please supply all of you mdadm -E reports for the seven partitions and
the lsdrv output I requests.  Just post the text inline in your reply.

Do *not* do anything else.

Phil
