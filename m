From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: interesting case of a hung 'recovery'
Date: Thu, 9 Mar 2017 22:00:17 +1100
Message-ID: <768e3a4c-070a-a47e-e86a-479918d01c5a@eyal.emu.id.au>
References: <091a6513-1594-4a33-691a-cd1f7920d4a0@eyal.emu.id.au>
 <61a297da-de29-e471-7270-166b33ce18b9@eyal.emu.id.au>
 <CA+res+SYTaCd77Nvdvn-gSe2qcJu5nXMdnV32nL0MKs9NOzqYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+res+SYTaCd77Nvdvn-gSe2qcJu5nXMdnV32nL0MKs9NOzqYg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/03/17 20:13, Jack Wang wrote:
> 2017-03-09 8:39 GMT+01:00 Eyal Lebedinsky <eyal@eyal.emu.id.au>:
>> Bump.
>>
>> On 18/02/17 23:14, Eyal Lebedinsky wrote:
>>>
>>> I should start by saying that this is an old fedora 19 system
>>>
>>> Executive summary: after '--add'ing a new member a 'recovery' starts but
>>> 'sync_max' is not reset.
>>>
>>> $ uname -a
>>> Linux e7.eyal.emu.id.au 3.14.27-100.fc19.x86_64 #1 SMP Wed Dec 17 19:36:34
>>> UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
>>
>>
>> $ sudo mdadm --version
>> mdadm - v4.0 - 2017-01-09
>>
>>> so the issue may have been fixed since.
>>>
>>> I had a disk fail in a raid6. After some 'pending' sectors were logged I
>>> decided to do a 'check'
>>> around that location (set sync_min/max and echo 'check'). Sure enough it
>>> elicited disk errors,
>>> but the disk did not recover and it was kicked out of the array. Moreover
>>> it became unresponsive.
>>> It needed a power cycle so I shutdown and rebooted the machine.
>>>
>>> Not one to give up easily I tried the check again, with the same result.
>>> It was time to '--remove' this array member. I then '--add'ed a new disk
>>> which started a recovery.
>>>
>>> A few hours later I noticed that it slowed down. A lot. It actually did
>>> not progress at all for
>>> a few hours (I was away from the machine).
>>>
>>> As I was staring at the screen (for a long while) I realised that it
>>> stopped at 55.5%, and this
>>> number is exactly where the original 'check' failed (I still do not
>>> understand why with my bad
>>> memory I remembered this number).
>>>
>>> I checked 'sync_completed' and it was proper.
>>> I then examined 'sync_max' and it was wrong - it had the location where
>>> the very early 'check'
>>> failed earlier in the day. It was the same sector where it is now paused
>>> at - looks related.
>>>
>>> I decided to take a (small) risk and do
>>>     # echo 'max' >/sys/block/md127/md/sync_max
>>> at which point the recovery moved on. It should be finished in about 5
>>> hours.
>>>
>>> I do not think that it is correct for 'sync_max' to not be set to 'max'
>>> when a new member is
>>> added - it surely requires a full recovery.
>>>
>>> I really hope (and expect) that this was actually fixed, but this note may
>>> help others facing
>>> same predicament.
>>>
>>> cheers
>>>
>>
>> --
>> Eyal Lebedinsky (eyal@eyal.emu.id.au)
>
> You'd better offer attach much detailed information, then people can help.

I know, but this is a live system and I cannot experiment with it.

There were no unusual messages (see below) at all. The 'recovery' simply stopped. This is
the usual behaviour when one sets sync_min/max and starts a (for example) 'check'.
As I described above, I found that after the --add 'sync_max' was NOT set to 'max' and
not to the full RAID size but was left at the value where the earlier 'check' failed.
It failed when the disk completely disappeared.

I guess the original 'check' was left pending, and when a replacement disk was added
to the RAID it was automatically recovered (as it should) but the original 'check'
somehow left something behind that should have been reset for the recovery.

> eg:
> https://raid.wiki.kernel.org/index.php/Asking_for_help
>
> For the problem you reported, better offer also kernel dmesg, output
> of blocking tasks via "echo w >  /proc/sysrq-trigger" maybe also
> "echo t > /proc/sysrq-trigger"

There was no blocked task, just that the recovery stopped progressing when it
reached sync_max, as it should. The problem is that sync_max had the wrong value,
the full (newly added) disk was supposed to be synced.

> Cheers,

In case it helps, here is all the info I have of the event:

### I have a script that checks the RAID in a small region. I had an earlier error in
### on the disk and to check it my script effectively did:
	echo 4336657408 >sys/block/md127/md/sync_min
	echo 4339803136 >sys/block/md127/md/sync_max
	echo check      >sys/block/md127/md/sync_action
### messages:
Feb 18 13:46:31 e7 kernel: [  976.688691] md: data-check of RAID array md127
Feb 18 13:46:31 e7 kernel: [  976.693254] md: minimum _guaranteed_  speed: 150000 KB/sec/disk.
Feb 18 13:46:31 e7 kernel: [  976.699479] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
Feb 18 13:46:31 e7 kernel: [  976.709420] md: using 128k window, over a total of 3906885120k.
Feb 18 13:46:31 e7 kernel: [  976.715457] md: resuming data-check of md127 from checkpoint.

### the failure of the 'check'
... many i/o errors then sdf completely disappeared ... errors at sectors 4337414{000,040,168}
Feb 18 13:47:08 e7 kernel: [ 1014.334781] md: super_written gets error=-5, uptodate=0
Feb 18 13:47:08 e7 kernel: [ 1014.340024] md/raid:md127: Disk failure on sdf1, disabling device.
Feb 18 13:47:08 e7 kernel: [ 1014.340024] md/raid:md127: Operation continuing on 6 devices.
Feb 18 13:47:08 e7 kernel: [ 1014.417307] md: md127: data-check interrupted.

### a new disk (sdj) is plugged in and partitioned.
$ sudo mdadm /dev/md127 --add /dev/sdj1
$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md127 : active raid6 sdj1[11] sdf1[7](F) sdi1[8] sde1[9] sdh1[12] sdc1[0] sdg1[13] sdd1[10]
       19534425600 blocks super 1.2 level 6, 512k chunk, algorithm 2 [7/6] [UUU_UUU]
       [>....................]  recovery =  0.7% (29805572/3906885120) finish=509.2min speed=126880K/sec
       bitmap: 7/30 pages [28KB], 65536KB chunk

### messages:
Feb 18 14:23:10 e7 kernel: [ 3177.183250] md: bind<sdj1>
Feb 18 14:23:10 e7 kernel: [ 3177.255529] md: recovery of RAID array md127
Feb 18 14:23:10 e7 kernel: [ 3177.259894] md: minimum _guaranteed_  speed: 150000 KB/sec/disk.
Feb 18 14:23:10 e7 kernel: [ 3177.265994] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
Feb 18 14:23:10 e7 kernel: [ 3177.275736] md: using 128k window, over a total of 3906885120k.

### the point when the recovery paused:
2017-02-18 20:02:48        [===========>.........]  recovery = 55.4% (2166229192/3906885120) finish=372.8min speed=77803K/sec
2017-02-18 20:02:58        [===========>.........]  recovery = 55.4% (2167083344/3906885120) finish=366.2min speed=79159K/sec
2017-02-18 20:03:08        [===========>.........]  recovery = 55.4% (2167819876/3906885120) finish=374.8min speed=77316K/sec
2017-02-18 20:03:18        [===========>.........]  recovery = 55.5% (2168520428/3906885120) finish=375.4min speed=77157K/sec
2017-02-18 20:03:28        [===========>.........]  recovery = 55.5% (2168590848/3906885120) finish=489.4min speed=59194K/sec
2017-02-18 20:03:38        [===========>.........]  recovery = 55.5% (2168590848/3906885120) finish=608.7min speed=47588K/sec
2017-02-18 20:03:48        [===========>.........]  recovery = 55.5% (2168590848/3906885120) finish=728.1min speed=39786K/sec
2017-02-18 20:03:58        [===========>.........]  recovery = 55.5% (2168590848/3906885120) finish=847.5min speed=34182K/sec
...
2017-02-18 22:36:44 0       [===========>.........]  recovery = 55.5% (2168590848/3906885120) finish=110261.8min speed=262K/sec
2017-02-18 22:36:54 0       [===========>.........]  recovery = 55.5% (2168590848/3906885120) finish=110381.2min speed=262K/sec
2017-02-18 22:37:04 0       [===========>.........]  recovery = 55.5% (2168590848/3906885120) finish=110500.6min speed=262K/sec
2017-02-18 22:37:14 0       [===========>.........]  recovery = 55.5% (2168590848/3906885120) finish=110619.9min speed=261K/sec

# echo 'max' >/sys/block/md127/md/sync_max
### recovery now moves on:
2017-02-18 22:37:24 0       [===========>.........]  recovery = 55.5% (2168938500/3906885120) finish=117500.2min speed=246K/sec
2017-02-18 22:37:34 0       [===========>.........]  recovery = 55.5% (2169997568/3906885120) finish=105201.7min speed=275K/sec
2017-02-18 22:37:44 0       [===========>.........]  recovery = 55.5% (2171066120/3906885120) finish=90962.0min speed=318K/sec
2017-02-18 22:37:54 0       [===========>.........]  recovery = 55.5% (2172125192/3906885120) finish=269.9min speed=107101K/sec
2017-02-18 22:38:04 0       [===========>.........]  recovery = 55.6% (2173114372/3906885120) finish=272.1min speed=106165K/sec
2017-02-18 22:38:14 0       [===========>.........]  recovery = 55.6% (2174004224/3906885120) finish=287.3min speed=100492K/sec

### and it completed over six hours later:
Feb 19 04:49:16 e7 kernel: [55167.633100] md: md127: recovery done.

cheers

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
