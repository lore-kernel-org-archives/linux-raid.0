From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: slow 'check'
Date: Sat, 10 Feb 2007 15:18:39 -0500
Message-ID: <45CE289F.10105@tmr.com>
References: <45CD5B26.5030707@eyal.emu.id.au> <5d96567b0702092341u7d307284ga88ee0f947c80c0f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5d96567b0702092341u7d307284ga88ee0f947c80c0f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: Eyal Lebedinsky <eyal@eyal.emu.id.au>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Raz Ben-Jehuda(caro) wrote:
> On 2/10/07, Eyal Lebedinsky <eyal@eyal.emu.id.au> wrote:
>> I have a six-disk RAID5 over sata. First two disks are on the mobo 
>> and last four
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
> try dd with bs of 4x(5x256) = 5 M.
>
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
>> that the simple dd does the same amount of work (don't we check 
>> parity on
>> read?).
>>
>> I have these tweaked at bootup:
>>        echo 4096 >/sys/block/md0/md/stripe_cache_size
>>        blockdev --setra 32768 /dev/md0
>>
>> Changing the above parameters seems to not have a significant effect.
> Stripe cache size is less effective than previous versions
> of raid5 since in some cases it is being bypassed.
> Why do you check random access to the raid
> and not sequential access. 
What on Earth makes you think dd uses random access???

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

