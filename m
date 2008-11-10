From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: RAID-6 question.
Date: Mon, 10 Nov 2008 11:02:41 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0811101101530.25411@p34.internal.lan>
References: <alpine.DEB.1.10.0811100653060.21263@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811100653060.21263@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Mon, 10 Nov 2008, Justin Piszcz wrote:

> I ran a check on a RAID6 and my entire machine was timing out ssh connections 
> etc until it was just about finished, I never experienced this with RAID5, 
> any comments?
>
> $ cat /sys/block/md3/md/sync_speed_min
> 1000 (system)
> $ cat /sys/block/md3/md/sync_speed_max
> 200000 (system)
>
> md3 : active raid6 sdl1[9] sdk1[8] sdj1[7] sdi1[6] sdh1[5] sdg1[4] sdf1[3] 
> sde1[2] sdd1[1] sdc1[0]
>      2344263680 blocks level 6, 1024k chunk, algorithm 2 [10/10] 
> [UUUUUUUUUU]
>      [===================>.]  resync = 96.5% (283046144/293032960) 
> finish=2.3min speed=71092K/sec
>
> # dd if=/dev/zero of=disk bs=1M # write to entire raid6 device
> # then, run a check > on /sys/etc for all devices that support parity
> # (do this on a regular basis w/raid1+5), never seen any slowdown etc like
> # i experienced w/ RAID6: /app/jp-mystuff/bin/check_mdraid.sh
> Mon Nov 10 06:00:54 EST 2008: Parity check(s) running, sleeping 10 minutes...
>
>

During RAID6-resync (recovering from 2-failed disks)
1. Manually failed 2 drives.
2. Added one drive, it started rebuilding--processes seemed OK.
3. Added the second drive during the rebuilding of the first drive.
4. The exact commands ran are shown below:

   501  mdadm /dev/md3 --fail /dev/sdg1
   502  mdadm /dev/md3 -r /dev/sdg1
   503  mdadm /dev/md3 -a /dev/sdg1
   504  mdadm /dev/md3 --fail /dev/sdh1
   507  mdadm -D /dev/md3
   508  mdadm /dev/md3 -r /dev/sdh1
   517  mdadm -D /dev/md3
   518  mdadm /dev/md3 -a /dev/sdh1
   522  mdadm -D /dev/md3

During this rebuild, this is what the process stats look like:
--------------------------------------------------------------
   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
19108 root      15  -5     0    0    0 R  100  0.0 296:36.31 md3_raid5
25676 root      15  -5     0    0    0 D   41  0.0   4:13.48 md3_resync

It also appears to 'starve' my md/root (RAID1) such that regular processes
go into D-state.  This does not appear to happen under RAID5-resync..
---------------------------------------------------------------------------
root     18954  1.3  0.0      0     0 ?        D    Nov09  12:34 [pdflush]
root     18246  0.0  0.0   5904   668 ?        Ds   Nov09   0:00 /sbin/syslogd -
r
postfix  25761  0.0  0.0  43720  3128 ?        D    10:43   0:00 cleanup -z -t unix -u -c
jpiszcz  25411  0.0  0.0  69020  6544 pts/35   Dl+  10:32   0:00 alpine -i

During this time, I cannot ssh to the host:

md3 : active raid6 sdh1[10](S) sdg1[11] sdj1[7] sdl1[9] sdk1[8] sdi1[6] sdf1[3] sde1[2] sdd1[1] sdc1[0]
       2344263680 blocks level 6, 1024k chunk, algorithm 2 [10/8] [UUUU__UUUU]
       [=========>...........]  recovery = 47.1% (138049268/293032960) finish=24.6min speed=104740K/sec

After I lowered the speed a little bit, the system came back:

# echo 90000 > /sys/block/md3/md/sync_speed_max

The minimum/maximum were default:

# cat /sys/block/md3/md/sync_speed_min
1000 (system)

The sync_speed_max was the default as well until I changed it, once I lowered
the speed, the system was functional again.  By default its set quite high,
this appeared to be the root cause of the problem.

Justin.

