From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: feature re-quest for "re-write"
Date: Tue, 25 Feb 2014 16:58:49 +1100
Message-ID: <530C3119.6030308@eyal.emu.id.au>
References: <alpine.DEB.2.02.1402211903030.15054@uplift.swm.pp.se>	<530AA09B.3090708@fnarfbargle.com>	<530AA460.602@eyal.emu.id.au>	<530AAA55.2080508@fnarfbargle.com>	<530ABF21.7030200@eyal.emu.id.au>	<BLU0-SMTP340FC1C74C40495FA5F94298860@phx.gbl>	<530BADF2.3090907@eyal.emu.id.au> <20140225141650.56b8dac4@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140225141650.56b8dac4@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

My case is consistent.

Reading /dev/sdi1 provokes the end_request error. This is 100% reproducible.
Reading /dev/md127 runs clean (no error message).
Doing a 'check' completes clean (no error message).(*)
smartctl shows one pending sector.

Some details listed below.

Eyal

(*) I run a check action by setting sync_min/sync_max/sync_action
to cover the bad sector. However, just to be sure, I allowed an overnight
full check which also ran clean. The bad sector is still pending.

This is how I run the short tests:

# parted -l
Model: ATA WDC WD4001FAEX-0 (scsi)
Disk /dev/sdi: 4001GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name  Flags
  1      1049kB  4001GB  4001GB

# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md127 : active raid6 sdf1[7] sdd1[1] sdc1[0] sdg1[4] sdh1[5] sde1[2] sdi1[6]
       19534425600 blocks super 1.2 level 6, 512k chunk, algorithm 2 [7/7] [UUUUUUU]
       bitmap: 0/30 pages [0KB], 65536KB chunk

# cat /sys/block/md127/md/chunk_size
524288

# sys="/sys/block/md127/md"
# echo       '0' >$sys/sync_min	# check first
# echo '1000384' >$sys/sync_max	#   1m sectors, 0.5GB
# echo 'check'   >$sys/sync_action

Examining /proc/mdstat every second:
16:30:46       [>....................]  check =  0.0% (131360/3906885120) finish=495.6min speed=131360K/sec
16:30:47       [>....................]  check =  0.0% (273696/3906885120) finish=237.8min speed=273696K/sec
16:30:48       [>....................]  check =  0.0% (416032/3906885120) finish=312.9min speed=208016K/sec
16:30:49       [>....................]  check =  0.0% (561952/3906885120) finish=347.5min speed=187317K/sec
16:30:50       [>....................]  check =  0.0% (707872/3906885120) finish=367.8min speed=176968K/sec
16:30:51       [>....................]  check =  0.0% (844072/3906885120) finish=385.6min speed=168814K/sec
16:30:52       [>....................]  check =  0.0% (991016/3906885120) finish=394.1min speed=165169K/sec
16:30:53       [>....................]  check =  0.0% (1136936/3906885120) finish=400.7min speed=162419K/sec
16:30:54       [>....................]  check =  0.0% (1283368/3906885120) finish=405.7min speed=160421K/sec
16:30:55       [>....................]  check =  0.0% (1427752/3906885120) finish=410.3min speed=158639K/sec
16:30:56       [>....................]  check =  0.0% (1544492/3906885120) finish=463.5min speed=140408K/sec
16:30:57       [>....................]  check =  0.0% (1726304/3906885120) finish=452.4min speed=143858K/sec
16:30:58       [>....................]  check =  0.0% (1866592/3906885120) finish=453.2min speed=143584K/sec
16:30:59       [>....................]  check =  0.0% (2012000/3906885120) finish=452.8min speed=143714K/sec
16:31:00       [>....................]  check =  0.0% (2154336/3906885120) finish=453.1min speed=143622K/sec
16:31:01       [>....................]  check =  0.0% (2226336/3906885120) finish=467.6min speed=139146K/sec
16:31:02       [>....................]  check =  0.0% (2401636/3906885120) finish=460.6min speed=141272K/sec
16:31:03       [>....................]  check =  0.0% (2549592/3906885120) finish=459.4min speed=141644K/sec
16:31:04       [>....................]  check =  0.0% (2690864/3906885120) finish=459.4min speed=141625K/sec
16:31:05       [>....................]  check =  0.0% (2834776/3906885120) finish=459.0min speed=141738K/sec
16:31:06       [>....................]  check =  0.0% (2928880/3906885120) finish=466.5min speed=139470K/sec
16:31:07       [>....................]  check =  0.0% (3029760/3906885120) finish=472.4min speed=137716K/sec
16:31:08       [>....................]  check =  0.0% (3111680/3906885120) finish=480.9min speed=135290K/sec
16:31:09       [>....................]  check =  0.0% (3258624/3906885120) finish=479.1min speed=135776K/sec
16:31:10       [>....................]  check =  0.0% (3401472/3906885120) finish=478.1min speed=136058K/sec
16:31:11       [>....................]  check =  0.0% (3544832/3906885120) finish=477.1min speed=136339K/sec
16:31:12       [>....................]  check =  0.0% (3657476/3906885120) finish=480.2min speed=135462K/sec
16:31:13       [>....................]  check =  0.0% (3797764/3906885120) finish=479.6min speed=135634K/sec
16:31:14       [>....................]  check =  0.1% (3941636/3906885120) finish=478.5min speed=135918K/sec
16:31:15       [>....................]  check =  0.1% (4076292/3906885120) finish=478.7min speed=135876K/sec
16:31:16       [>....................]  check =  0.1% (4221188/3906885120) finish=477.6min speed=136167K/sec
16:31:17       [>....................]  check =  0.1% (4325252/3906885120) finish=481.2min speed=135164K/sec
16:31:18       [>....................]  check =  0.1% (4497992/3906885120) finish=477.1min speed=136302K/sec
16:31:19       [>....................]  check =  0.1% (4644936/3906885120) finish=477.1min speed=136300K/sec
16:31:20       [>....................]  check =  0.1% (4779088/3906885120) finish=477.3min speed=136233K/sec
16:31:21       [>....................]  check =  0.1% (4914888/3906885120) finish=477.4min speed=136220K/sec
16:31:22       [>....................]  check =  0.1% (4990720/3906885120) finish=487.6min speed=133366K/sec
16:31:23       [>....................]  check =  0.1% (4999896/3906885120) finish=502.2min speed=129485K/sec

# cat /sys/block/md127/md/mismatch_cnt
0

# echo 'idle'   >$sys/sync_action

# dmesg|tail
[ 4134.750324] md: data-check of RAID array md127
[ 4134.756992] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[ 4134.764956] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[ 4134.776816] md: using 128k window, over a total of 3906885120k.
[ 4174.065003] md: md_do_sync() got signal ... exiting

On 02/25/14 14:16, NeilBrown wrote:
> On Tue, 25 Feb 2014 07:39:14 +1100 Eyal Lebedinsky <eyal@eyal.emu.id.au>
> wrote:
>
>> My main interest is to understand why 'check' does not actually check.
>> I already know how to fix the problem, by writing to the location I
>> can force the pending reallocation to happen, but then I will not have
>> the test case anymore.
>>
>> The OP asks for a specific solution, but I think that the 'check' action
>> should already correctly rewrite failed (i/o error) sectors. It does not
>> always know which sector to rewrite when it finds a raid6 mismatch
>> without an i/o error (with raid5 it never knows).
>>
>
> I cannot reproduce the problem.  In my testing a read error is fixed by
> 'check'.  For you it clearly isn't.  I wonder what is different.
>
> During normal 'check' or 'repair' etc the read requests are allowed to be
> combined by the io scheduler so when we get a read error, it could be one
> error for a megabyte of more of the address space.
> So the first thing raid5.c does is arrange to read all the blocks again but
> to prohibit the merging of requests.  This time any read error will be for a
> single 4K block.
>
> Once we have that reliable read error the data is constructed from the other
> blocks and the new block is written out.
>
> This suggests that when there is a read error you should see e.g.
>
> [  714.808494] end_request: I/O error, dev sds, sector 8141872
>
> then shortly after that another similar error, possibly with a slightly
> different sector number (at most a few thousand sectors later).
>
> Then something like
>
> md/raid:md0: read error corrected (8 sectors at 8141872 on sds)
>
>
> However in the log Mikael Abrahamsson posted on 16 Jan 2014
> (Subject: Re: read errors not corrected when doing check on RAID6)
>
> we only see that first 'end_request' message.  No second one and no "read
> error corrected".
>
> This seems to suggest that the second read succeeded, which is odd (to say
> the least).
>
> In your log posted 21 Feb 2014
> (Subject: raid 'check' does not provoke expected i/o error)
> there aren't even any read errors during 'check'.
> The drive sometimes reports a read error and something doesn't?
> Does reading the drive with 'dd' already report an error, and with 'check'
> never report an error?
>
>
>
> So I'm a bit stumped.  It looks like md is doing the right thing, but maybe
> the drive is getting confused.
> Are all the people who report this using the same sort of drive??
>
> NeilBrown
>

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
