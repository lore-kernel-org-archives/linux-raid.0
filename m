From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: failed disks, mapper, and "Invalid argument"
Date: Thu, 21 May 2020 00:23:27 +0100
Message-ID: <5EC5BBEF.7070002@youngman.org.uk>
References: <20200520200514.GE1415@justpickone.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200520200514.GE1415@justpickone.org>
Sender: linux-raid-owner@vger.kernel.org
To: David T-G <davidtg-robot@justpickone.org>, Linux RAID list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 20/05/20 21:05, David T-G wrote:
> Hi, all --
> 
> I have a four-partition RAID5 array of which one disk failed while I was
> out of town and a second failed just today.  Both failed smartctl tests
> by not even starting, although I don't have that captured.  Those two
> were on a SATA daughtercard, so I swapped them (formerly sde, sdf)
> up to the motherboard SATA ports like the other two (still sda, sdb) and
> now all are visible and happily pass smartctl checks and generally look
> good ... except that my md0 doesn't :-(
> 
> I've been through the wiki and other found documentation and have scraped
> the archives, but the whole mapper thing is new to me, and I don't know
> enough to pin down the error.  I've been attempting to fake-build my
> array with overlay devices to see how it will do.  Please forgive the
> long post if it's a bit ridiculous; I wanted to make sure that you have
> all information :-)

https://raid.wiki.kernel.org/index.php/Asking_for_help

Hate to say it, but if you've found the wiki, there's an awful lot of
info missing from this post ...
> 
> Here's the array after I swapped ports and booted up:
> 
>   diskfarm:root:10:~> mdadm --detail /dev/md0
>   /dev/md0:
>           Version : 1.2
>     Creation Time : Mon Feb  6 00:56:35 2017
>        Raid Level : raid5
>     Used Dev Size : 4294967295
>      Raid Devices : 4
>     Total Devices : 2
>       Persistence : Superblock is persistent
> 
>       Update Time : Mon May 18 01:10:07 2020
>             State : active, FAILED, Not Started
>    Active Devices : 2
>   Working Devices : 2
>    Failed Devices : 0
>     Spare Devices : 0
> 
>            Layout : left-symmetric
>        Chunk Size : 512K
> 
>              Name : diskfarm:0  (local to host diskfarm)
>              UUID : ca7008ef:90693dae:6c231ad7:08b3f92d
>            Events : 57840
> 
>       Number   Major   Minor   RaidDevice State
>          0       8       17        0      active sync   /dev/sdb1
>          -       0        0        1      removed
>          -       0        0        2      removed
>          4       8        1        3      active sync   /dev/sda1
> 
> 
>   diskfarm:root:10:~> mdadm --examine /dev/sd[abcd]1 | egrep '/dev|vents'
>   /dev/sda1:
>            Events : 57840
>   /dev/sdb1:
>            Events : 57840
>   /dev/sdc1:
>            Events : 57836
>   /dev/sdd1:
>            Events : 48959
> 
> I'd say sdd is the former sde that went away first and sdc that was sdf
> only just fell over.

Okay, you DON'T want to include sdd in your attempts - sdc is only 4
events behind so if you can assemble those three, you'll be almost
perfect ...
> 
> In my first round, I shut down md0
> 
>   diskfarm:root:12:~> mdadm --stop /dev/md0
>   mdadm: stopped /dev/md0
>   diskfarm:root:12:~> cat /proc/mdstat
>   Personalities : [raid6] [raid5] [raid4]
>   md127 : active raid5 sdf2[0] sdg2[1] sdh2[3]
>         1464622080 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]
> 
>   unused devices: <none>
> 
> and of course it isn't in mdstat any more.  Oops.  But it's down, so we
> won't see any more writes that could be messy.
> 
> I whipped up four loop devices and created overlay files
> 
>   diskfarm:root:13:/mnt/scratch/disks> parallel truncate -s8G overlay-{/} ::: $DEVICES
>   ...
>   To silence this citation notice: run 'parallel --citation'.
> 
>   diskfarm:root:13:/mnt/scratch/disks> ls -goh
>   total 33M
>   -rw-r--r-- 1 8.0G May 20 14:00 overlay-sda1
>   -rw-r--r-- 1 8.0G May 20 14:00 overlay-sdb1
>   -rw-r--r-- 1 8.0G May 20 14:00 overlay-sdc1
>   -rw-r--r-- 1 8.0G May 20 14:00 overlay-sdd1
>   -rw-r--r-- 1  11K May 20 13:20 smartctl-a.sda.out
>   -rw-r--r-- 1 5.3K May 20 13:20 smartctl-a.sdb.out
>   -rw-r--r-- 1 5.3K May 20 13:20 smartctl-a.sdc.out
>   -rw-r--r-- 1 5.3K May 20 13:20 smartctl-a.sdd.out
> 
>   diskfarm:root:13:/mnt/scratch/disks> du -skhc overlay-sd*
>   8.0M    overlay-sda1
>   8.0M    overlay-sdb1
>   8.0M    overlay-sdc1
>   8.0M    overlay-sdd1
>   32M     total
> 
>   diskfarm:root:13:/mnt/scratch/disks> ls -goh /dev/mapper/*
>   crw------- 1 10, 236 May 20 08:04 /dev/mapper/control
>   lrwxrwxrwx 1       7 May 20 14:02 /dev/mapper/sda1 -> ../dm-1
>   lrwxrwxrwx 1       7 May 20 14:02 /dev/mapper/sdb1 -> ../dm-0
>   lrwxrwxrwx 1       7 May 20 14:02 /dev/mapper/sdc1 -> ../dm-2
>   lrwxrwxrwx 1       7 May 20 14:02 /dev/mapper/sdd1 -> ../dm-3
> 
> and grabbed my overlays and checked the mapper
> 
>   diskfarm:root:13:/mnt/scratch/disks> OVERLAYS=$(parallel echo /dev/mapper/{/} ::: $DEVICES)
>   diskfarm:root:13:/mnt/scratch/disks> echo $OVERLAYS
>   /dev/mapper/sda1 /dev/mapper/sdb1 /dev/mapper/sdc1 /dev/mapper/sdd1
>   diskfarm:root:13:/mnt/scratch/disks> dmsetup status
>   sdb1: 0 3518805647 snapshot 16/16777216 16
>   sdc1: 0 3518805647 snapshot 16/16777216 16
>   sda1: 0 3518805647 snapshot 16/16777216 16
>   sdd1: 0 3518805647 snapshot 16/16777216 16
> 
> and so far it looks good ... as far as I know :-)
> 
> I didn't know if I should try md0, the real array name, or create a new
> md1, so I took the safe approach first
> 
>   diskfarm:root:13:/mnt/scratch/disks> mdadm --assemble --force /dev/md1 $OVERLAYS
>   mdadm: forcing event count in /dev/mapper/sdc1(2) from 57836 upto 57840
>   mdadm: clearing FAULTY flag for device 2 in /dev/md1 for /dev/mapper/sdc1
>   mdadm: Marking array /dev/md1 as 'clean'
>   mdadm: failed to add /dev/mapper/sdd1 to /dev/md1: Invalid argument
>   mdadm: failed to add /dev/mapper/sdc1 to /dev/md1: Invalid argument
>   mdadm: failed to add /dev/mapper/sda1 to /dev/md1: Invalid argument
>   mdadm: failed to add /dev/mapper/sdb1 to /dev/md1: Invalid argument
>   mdadm: failed to RUN_ARRAY /dev/md1: Invalid argument
> 
>   diskfarm:root:13:/mnt/scratch/disks> cat /proc/mdstat
>   Personalities : [raid6] [raid5] [raid4]
>   md127 : active raid5 sdf2[0] sdg2[1] sdh2[3]
>         1464622080 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]
> 
>   unused devices: <none>
> 
>   diskfarm:root:13:/mnt/scratch/disks> mdadm --examine /dev/md1
>   mdadm: cannot open /dev/md1: No such file or directory
> 
> but didn't fet to move on to the next wiki step.  I crossed my fingers
> and tried md0
> 
>   diskfarm:root:13:/mnt/scratch/disks> mdadm --assemble --force /dev/md0 $OVERLAYS
>   mdadm: failed to add /dev/mapper/sdd1 to /dev/md0: Invalid argument
>   mdadm: failed to add /dev/mapper/sdc1 to /dev/md0: Invalid argument
>   mdadm: failed to add /dev/mapper/sda1 to /dev/md0: Invalid argument
>   mdadm: failed to add /dev/mapper/sdb1 to /dev/md0: Invalid argument
>   mdadm: failed to RUN_ARRAY /dev/md0: Invalid argument
> 
>   diskfarm:root:13:/mnt/scratch/disks> mdadm --assemble --force /dev/md0 --verbose $OVERLAYS
>   mdadm: looking for devices for /dev/md0
>   mdadm: /dev/mapper/sda1 is identified as a member of /dev/md0, slot 3.
>   mdadm: /dev/mapper/sdb1 is identified as a member of /dev/md0, slot 0.
>   mdadm: /dev/mapper/sdc1 is identified as a member of /dev/md0, slot 2.
>   mdadm: /dev/mapper/sdd1 is identified as a member of /dev/md0, slot 1.
>   mdadm: failed to add /dev/mapper/sdd1 to /dev/md0: Invalid argument
>   mdadm: failed to add /dev/mapper/sdc1 to /dev/md0: Invalid argument
>   mdadm: failed to add /dev/mapper/sda1 to /dev/md0: Invalid argument
>   mdadm: failed to add /dev/mapper/sdb1 to /dev/md0: Invalid argument
>   mdadm: failed to RUN_ARRAY /dev/md0: Invalid argument
> 
>   diskfarm:root:13:/mnt/scratch/disks> mdadm --detail /dev/md0
>   mdadm: cannot open /dev/md0: No such file or directory
> 
> and STILL got nowhere.  It was at this point that I figured I need to
> back away and call for help!  I don't want to try rebuilding the actual
> array in case it's out of sync and I lose data.
> 
> Soooooo...  There it is.  Any suggestions to correct whatever oops I've
> made or complete a step I overlooked?  Any ideas why my assemble didn't?
> 
What I *always* jump on ...

https://raid.wiki.kernel.org/index.php/Timeout_Mismatch

You don't have any of these drives you shouldn't?

I'll let someone else play about with all the device mapper stuff, I'm
only just getting in to it, but as I say, drop sdd and you should get
your array back with pretty much no corruption. Adding sdd runs the risk
of corrupting much more ...

Cheers,
Wol
