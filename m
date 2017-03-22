From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: recovery does not complete after --add
Date: Wed, 22 Mar 2017 14:12:46 +1100
Message-ID: <461c66fc-9231-0296-2824-db1265e3b745@eyal.emu.id.au>
References: <b0a98fa0-b271-4ed4-c8fa-15cdafe63fb0@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b0a98fa0-b271-4ed4-c8fa-15cdafe63fb0@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Bump.

I expect those in the know should find this simple to answer?

TIA

On 17/03/17 10:51, Eyal Lebedinsky wrote:
> This is a repost of the issue (from a month ago) that did not get a response then.
>
> Executive summary:
> After '--add'ing a new member a 'recovery' starts automatically but 'sync_max' is not reset
> and the recovery hangs part way through where sync_max happened to be. This is a 7 disk raid6.
>
> Is this a known issue? Was it fixed since? Did I do something wrong?
>
> This machine runs the older f19.
>     $ uname -a
> Linux e7.eyal.emu.id.au 3.14.27-100.fc19.x86_64 #1 SMP Wed Dec 17 19:36:34 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
>
> mdadm was built from source:
>     $ sudo mdadm --version
> mdadm - v4.0 - 2017-01-09
>
> The long story:
>
> I had a disk fail in a raid6. After some 'pending' sectors were logged I decided to do a 'check'
> around that location by setting sync_min/max and echo 'check'. This is done with a script doing:
>     # echo 4336657408 >sys/block/md127/md/sync_min
>     # echo 4339803136 >sys/block/md127/md/sync_max
>     # echo check      >sys/block/md127/md/sync_action
> The messages then say
>     Feb 18 13:46:31 e7 kernel: [  976.688691] md: data-check of RAID array md127
>     Feb 18 13:46:31 e7 kernel: [  976.693254] md: minimum _guaranteed_  speed: 150000 KB/sec/disk.
>     Feb 18 13:46:31 e7 kernel: [  976.699479] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
>     Feb 18 13:46:31 e7 kernel: [  976.709420] md: using 128k window, over a total of 3906885120k.
>     Feb 18 13:46:31 e7 kernel: [  976.715457] md: resuming data-check of md127 from checkpoint.
>
> Sure enough this elicited disk errors, but the disk did not recover and it was kicked out of the array.
> Moreover it became unresponsive. It needed a power cycle so I shutdown and rebooted the machine.
>
> messages:
>     ... many i/o errors then sdf completely disappeared ... errors at sectors 4337414{000,040,168}
>     Feb 18 13:47:08 e7 kernel: [ 1014.334781] md: super_written gets error=-5, uptodate=0
>     Feb 18 13:47:08 e7 kernel: [ 1014.340024] md/raid:md127: Disk failure on sdf1, disabling device.
>     Feb 18 13:47:08 e7 kernel: [ 1014.340024] md/raid:md127: Operation continuing on 6 devices.
>     Feb 18 13:47:08 e7 kernel: [ 1014.417307] md: md127: data-check interrupted.
>
> A second power off/on, a check produced the same result. At this point I added a fresh disk:
>     $ sudo mdadm /dev/md127 --add /dev/sdj1
>     $ cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md127 : active raid6 sdj1[11] sdf1[7](F) sdi1[8] sde1[9] sdh1[12] sdc1[0] sdg1[13] sdd1[10]
>       19534425600 blocks super 1.2 level 6, 512k chunk, algorithm 2 [7/6] [UUU_UUU]
>       [>....................]  recovery =  0.7% (29805572/3906885120) finish=509.2min speed=126880K/sec
>       bitmap: 7/30 pages [28KB], 65536KB chunk
>
> messages:
>     Feb 18 14:23:10 e7 kernel: [ 3177.183250] md: bind<sdj1>
>     Feb 18 14:23:10 e7 kernel: [ 3177.255529] md: recovery of RAID array md127
>     Feb 18 14:23:10 e7 kernel: [ 3177.259894] md: minimum _guaranteed_  speed: 150000 KB/sec/disk.
>     Feb 18 14:23:10 e7 kernel: [ 3177.265994] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
>     Feb 18 14:23:10 e7 kernel: [ 3177.275736] md: using 128k window, over a total of 3906885120k.
>
> However, the recovery stopped progressing at one point (my script logs /proc/mdstat every 10 seconds):
>     2017-02-18 20:02:48        [===========>.........]  recovery = 55.4% (2166229192/3906885120) finish=372.8min speed=77803K/sec
>     2017-02-18 20:02:58        [===========>.........]  recovery = 55.4% (2167083344/3906885120) finish=366.2min speed=79159K/sec
>     2017-02-18 20:03:08        [===========>.........]  recovery = 55.4% (2167819876/3906885120) finish=374.8min speed=77316K/sec
>     2017-02-18 20:03:18        [===========>.........]  recovery = 55.5% (2168520428/3906885120) finish=375.4min speed=77157K/sec
>     2017-02-18 20:03:28        [===========>.........]  recovery = 55.5% (2168590848/3906885120) finish=489.4min speed=59194K/sec
>     2017-02-18 20:03:38        [===========>.........]  recovery = 55.5% (2168590848/3906885120) finish=608.7min speed=47588K/sec
>     2017-02-18 20:03:48        [===========>.........]  recovery = 55.5% (2168590848/3906885120) finish=728.1min speed=39786K/sec
>     2017-02-18 20:03:58        [===========>.........]  recovery = 55.5% (2168590848/3906885120) finish=847.5min speed=34182K/sec
>     ... no progress anymore
>     2017-02-18 22:36:44        [===========>.........]  recovery = 55.5% (2168590848/3906885120) finish=110261.8min speed=262K/sec
>     2017-02-18 22:36:54        [===========>.........]  recovery = 55.5% (2168590848/3906885120) finish=110381.2min speed=262K/sec
>     2017-02-18 22:37:04        [===========>.........]  recovery = 55.5% (2168590848/3906885120) finish=110500.6min speed=262K/sec
>     2017-02-18 22:37:14        [===========>.........]  recovery = 55.5% (2168590848/3906885120) finish=110619.9min speed=261K/sec
>
> After some thinking I realised that it has paused at the point where the earlier 'check' failed. This was unexpected.
> I followed with
>     # echo 'max' >/sys/block/md127/md/sync_max
> the recovery now moves on:
>     2017-02-18 22:37:24        [===========>.........]  recovery = 55.5% (2168938500/3906885120) finish=117500.2min speed=246K/sec
>     2017-02-18 22:37:34        [===========>.........]  recovery = 55.5% (2169997568/3906885120) finish=105201.7min speed=275K/sec
>     2017-02-18 22:37:44        [===========>.........]  recovery = 55.5% (2171066120/3906885120) finish=90962.0min speed=318K/sec
>     2017-02-18 22:37:54        [===========>.........]  recovery = 55.5% (2172125192/3906885120) finish=269.9min speed=107101K/sec
>     2017-02-18 22:38:04        [===========>.........]  recovery = 55.6% (2173114372/3906885120) finish=272.1min speed=106165K/sec
>     2017-02-18 22:38:14        [===========>.........]  recovery = 55.6% (2174004224/3906885120) finish=287.3min speed=100492K/sec
>
> ### and it completed over six hours later:
>     Feb 19 04:49:16 e7 kernel: [55167.633100] md: md127: recovery done.
>
> TIA
>

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
