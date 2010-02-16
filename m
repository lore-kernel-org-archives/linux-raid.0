From: Neil Brown <neilb@suse.de>
Subject: Re: MD: "sync_action" issues: pausing resync/recovery automatically
 restarts.
Date: Tue, 16 Feb 2010 12:26:16 +1100
Message-ID: <20100216122616.6ea5c0e4@notabene.brown>
References: <4B73F1F0.1030800@mpstor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B73F1F0.1030800@mpstor.com>
Sender: linux-raid-owner@vger.kernel.org
To: Benjamin ESTRABAUD <be@mpstor.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 11 Feb 2010 12:02:56 +0000
Benjamin ESTRABAUD <be@mpstor.com> wrote:

> Hi everybody,
> 
> I am getting a weird issue when I am writing values to 
> "/sys/block/mdX/md/sync_action".
> For instance, I would like to pause a resync or/and a recovery when they 
> are happening.
> I create a RAID 5 as follow:
> 
> mdadm --create -vvv --force --run --metadata=1.2 /dev/md/d0 --level=5 
> --size=9429760 --chunk=64 --name=1056856 -n5 --bitmap=internal 
> --bitmap-chunk=4096 --layout=ls /dev/sde2 /dev/sdb2 /dev/sdc2 /dev/sdf2 
> /dev/sdd2
> 
> The RAID is resyncing:
> 
> # cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md_d0 : active raid5 sdd2[4] sdf2[3] sdc2[2] sdb2[1] sde2[0]
>       37719040 blocks super 1.2 level 5, 64k chunk, algorithm 2 [5/5] 
> [UUUUU]
>       [====>................]  resync = 22.2% (2101824/9429760) 
> finish=2.6min speed=46186K/sec
>       bitmap: 1/1 pages [64KB], 4096KB chunk
> 
> unused devices: <none>
> 
> I then decide to pause its resync:
> 
> # echo idle > /sys/block/md_d0/md/sync_action
> 
> The RAID resync should have paused by now, let's check the sys properties:
> 
> # cat /sys/block/md_d0/md/sync_action
> resync
> 
> The resync seems to have not stopped/restarted, let's check dmesg:
> 
> [157287.049715] raid5: raid level 5 set md_d0 active with 5 out of 5 
> devices, algorithm 2
> [157287.057601] RAID5 conf printout:
> [157287.060909]  --- rd:5 wd:5
> [157287.063700]  disk 0, o:1, dev:sde2
> [157287.067182]  disk 1, o:1, dev:sdb2
> [157287.070664]  disk 2, o:1, dev:sdc2
> [157287.074147]  disk 3, o:1, dev:sdf2
> [157287.077628]  disk 4, o:1, dev:sdd2
> [157287.086813] md_d0: bitmap initialized from disk: read 1/1 pages, set 
> 2303 bits
> [157287.094134] created bitmap (1 pages) for device md_d0
> [157287.113475] md: resync of RAID array md_d0
> [157287.117650] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> [157287.123555] md: using maximum available idle IO bandwidth (but not 
> more than 200000 KB/sec) for resync.
> [157287.133011] md: using 2048k window, over a total of 9429760 blocks.
> [157345.158535] md: md_do_sync() got signal ... exiting
> [157345.166057] md: checkpointing resync of md_d0.
> [157345.179819] md: resync of RAID array md_d0
> [157345.183993] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> [157345.189899] md: using maximum available idle IO bandwidth (but not 
> more than 200000 KB/sec) for resync.
> [157345.199353] md: using 2048k window, over a total of 9429760 blocks.
> 
> The resync seem to stop at some stage since:
> 
> [157345.158535] md: md_do_sync() got signal ... exiting
> 
> But it seems to be restarting right after this:
> 
> [157345.179819] md: resync of RAID array md_d0
> 
> I read in the md.txt documentation that pausing a resync could sometimes 
> not work if a n event or trigger was triggering it to automatically 
> restart. However, I don't think I have any trigger that would cause it 
> to restart.
> it then builds perfectly fine.
> 
> I now want to check if the same issue occurs while recovering, after 
> all, I especially want to be able to pause a recovery, while I don't 
> really need to pause/restart resyncs.
> 
> Let's say I pull a disk from the bay, fail it and remove it as follow:
> 
> # mdadm --fail /dev/md/d0 /dev/sde2
> mdadm: set /dev/sde2 faulty in /dev/md/d0
> 
> # mdadm --remove /dev/md/d0 /dev/sde2
> mdadm: hot removed /dev/sde2
> 
> Now let's add a spare:
> 
> # /opt/soma/bin/mdadm/mdadm --add /dev/md/d0 /dev/sda2  
> raid manager: added /dev/sda2
> 
> The RAID is now recovering:
> 
> # cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md_d0 : active raid5 sda2[5] sdd2[4] sdf2[3] sdc2[2] sdb2[1]
>       37719040 blocks super 1.2 level 5, 64k chunk, algorithm 2 [5/4] 
> [_UUUU]
>       [>....................]  recovery =  1.7% (169792/9429760) 
> finish=0.9min speed=169792K/sec
>       bitmap: 0/1 pages [0KB], 4096KB chunk
> 
> unused devices: <none>
> 
> # cat /sys/block/md_d0/md/sync_action
> recover
> 
> Let's try and stop this recovery:
> 
> # echo idle > /sys/block/md_d0/md/sync_action
> 
> [157641.618291]  disk 3, o:1, dev:sdf2
> [157641.621774]  disk 4, o:1, dev:sdd2
> [157641.632057] md: recovery of RAID array md_d0
> [157641.636413] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> [157641.642314] md: using maximum available idle IO bandwidth (but not 
> more than 200000 KB/sec) for recovery.
> [157641.651940] md: using 2048k window, over a total of 9429760 blocks.
> [157657.120722] md: md_do_sync() got signal ... exiting
> [157657.267055] RAID5 conf printout:
> [157657.270381]  --- rd:5 wd:4
> [157657.273171]  disk 0, o:1, dev:sda2
> [157657.276650]  disk 1, o:1, dev:sdb2
> [157657.280129]  disk 2, o:1, dev:sdc2
> [157657.283605]  disk 3, o:1, dev:sdf2
> [157657.287087]  disk 4, o:1, dev:sdd2
> [157657.290568] RAID5 conf printout:
> [157657.293876]  --- rd:5 wd:4
> [157657.296660]  disk 0, o:1, dev:sda2
> [157657.300139]  disk 1, o:1, dev:sdb2
> [157657.303615]  disk 2, o:1, dev:sdc2
> [157657.307096]  disk 3, o:1, dev:sdf2
> [157657.310579]  disk 4, o:1, dev:sdd2
> [157657.320835] md: recovery of RAID array md_d0
> [157657.325194] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> [157657.331091] md: using maximum available idle IO bandwidth (but not 
> more than 200000 KB/sec) for recovery.
> [157657.340713] md: using 2048k window, over a total of 9429760 blocks.
> [157657.347047] md: resuming recovery of md_d0 from checkpoint.
> 
> I am getting the same issue, the recovery stops, but restarts 200 
> milliseconds later.

So clearly the resync is pausing - for 200milliseconds....

'idle' is only really useful to top a 'check' or 'repair'.
A 'sync' or 'recovery' md really wants to do, so whenever it seems to be
needed it, it does it.

What you want is "frozen" which is only available since 2.6.31.

> 
> This clearly indicates that some sort of trigger is automatically 
> restarting the resync and recovery, but I have no clue as of what could 
> it be.
> 
> Would anyone here had a similar experience with trying to stop resyncs? 
> Is there a "magic" variable that would enable or disable automatic 
> restart of resync/recoveries?
> 
> Would anyone know of a standard event or trigger that would cause a 
> resync or recovery to automatically restart?
> 
> Thank you very much in advance for your help.
> 
> My Kernel version is:
> 
> 2.6.26.3
>

So with that kernel, you cannot freeze a recovery.

Why do you want to?

A possible option is the mark the array read-only 
   "mdadm  --read-only /dev/mdXX".

This doesn't work if the array is mounted, but does stop any recovery from
happening.

NeilBrown

