From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: slow 'check'
Date: Sat, 10 Feb 2007 20:57:59 +1100
Message-ID: <45CD9727.5080307@eyal.emu.id.au>
References: <45CD5B26.5030707@eyal.emu.id.au> <5d96567b0702092341u7d307284ga88ee0f947c80c0f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5d96567b0702092341u7d307284ga88ee0f947c80c0f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Raz Ben-Jehuda(caro) wrote:
> On 2/10/07, Eyal Lebedinsky <eyal@eyal.emu.id.au> wrote:
> 
>> I have a six-disk RAID5 over sata. First two disks are on the mobo and
>> last four
>> are on a Promise SATA-II-150-TX4. The sixth disk was added recently
>> and I decided
>> to run a 'check' periodically, and started one manually to see how
>> long it should
>> take. Vanilla 2.6.20.
>>
>> A 'dd' test shows:
>>
>> # dd if=/dev/md0 of=/dev/null bs=1024k count=10240
>> 10240+0 records in
>> 10240+0 records out
>> 10737418240 bytes transferred in 84.449870 seconds (127145468 bytes/sec)
> 
> try dd with bs of 4x(5x256) = 5 M.

About the same:

# dd if=/dev/md0 of=/dev/null bs=5120k count=1024
1024+0 records in
1024+0 records out
5368709120 bytes transferred in 42.736373 seconds (125623883 bytes/sec)

Each disk pulls about 65MB/s alone, however with six concurrent dd's
the two mobo disks manage ~60MB/s while the four on the TX4 do only ~20MB/s.

>> This is good for this setup. A check shows:
>>
>> $ cat /proc/mdstat
>> Personalities : [raid6] [raid5] [raid4]
>> md0 : active raid5 sda1[0] sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[1]
>>      1562842880 blocks level 5, 256k chunk, algorithm 2 [6/6] [UUUUUU]
>>      [>....................]  check =  0.8% (2518144/312568576)
>> finish=2298.3min speed=2246K/sec
>>
>> unused devices: <none>
>>
>> which is an order of magnitude slower (the speed is per-disk, call it
>> 13MB/s
>> for the six). There is no activity on the RAID. Is this expected? I
>> assume
>> that the simple dd does the same amount of work (don't we check parity on
>> read?).
>>
>> I have these tweaked at bootup:
>>        echo 4096 >/sys/block/md0/md/stripe_cache_size
>>        blockdev --setra 32768 /dev/md0
>>
>> Changing the above parameters seems to not have a significant effect.
> 
> Stripe cache size is less effective than previous versions
> of raid5 since in some cases it is being bypassed.
> Why do you check random access to the raid
> and not sequential access.

What do you mean? I understand that 'setra' sets the readahead which
should not hurt sequential access. But I did try to take it down
without seeing any improvement:

# blockdev --setra 1024 /dev/md0
# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sda1[0] sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[1]
      1562842880 blocks level 5, 256k chunk, algorithm 2 [6/6] [UUUUUU]
      [>....................]  check =  0.0% (51456/312568576) finish=2326.1min speed=2237K/sec

Anyway, I was not checking anything but doing a raid check which
I recall was doing much better (20M+) with 5 devices on older kernels.

>> The check logs the following:
>>
>> md: data-check of RAID array md0
>> md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
>> md: using maximum available idle IO bandwidth (but not more than
>> 200000 KB/sec) for data-check.
>> md: using 128k window, over a total of 312568576 blocks.
>>
>> Does it need a larger window (whatever a window is)? If so, can it
>> be set dynamically?
>>
>> TIA
>>
>> -- 
>> Eyal Lebedinsky (eyal@eyal.emu.id.au) <http://samba.org/eyal/>

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au) <http://samba.org/eyal/>
	attach .zip as .dat
