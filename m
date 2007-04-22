From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: major performance drop on raid5 due to context switches caused
 by small max_hw_sectors [partially resolved]
Date: Sun, 22 Apr 2007 07:42:43 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0704220742080.14170@p34.internal.lan>
References: <200704202306.14880.dap@mail.index.hu> <200704221152.18747.dap@mail.index.hu>
 <Pine.LNX.4.64.0704220619390.14170@p34.internal.lan> <200704221338.45759.dap@mail.index.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200704221338.45759.dap@mail.index.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Pallai Roland <dap@mail.index.hu>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Sun, 22 Apr 2007, Pallai Roland wrote:

>
> On Sunday 22 April 2007 12:23:12 Justin Piszcz wrote:
>> On Sun, 22 Apr 2007, Pallai Roland wrote:
>>> On Sunday 22 April 2007 10:47:59 Justin Piszcz wrote:
>>>> On Sun, 22 Apr 2007, Pallai Roland wrote:
>>>>> On Sunday 22 April 2007 02:18:09 Justin Piszcz wrote:
>>>>>> How did you run your read test?
>>>>>
>>>>> I did run 100 parallel reader process (dd) top of XFS file system, try
>>>>> this: for i in `seq 1 100`; do dd of=$i if=/dev/zero bs=64k
>>>>> 2>/dev/null; done for i in `seq 1 100`; do dd if=$i of=/dev/zero bs=64k
>>>>> 2>/dev/null & done
>>>>>
>>>>> and don't forget to set max_sectors_kb below chunk size (eg. 64/128Kb)
>>>>> /sys/block# for i in sd*; do echo 64 >$i/queue/max_sectors_kb; done
>>>>>
>>>>> I also set 2048/4096 readahead sectors with blockdev --setra
>>>>>
>>>>> You need 50-100 reader processes for this issue, I think so. My kernel
>>>>> version is 2.6.20.3
>>>>
>>>> In one xterm:
>>>> for i in `seq 1 100`; do dd of=$i if=/dev/zero bs=64k 2>/dev/null; done
>>>>
>>>> In another:
>>>> for i in `seq 1 100`; do dd if=/dev/md3 of=$i.out bs=64k & done
>>>
>>> Write and read files top of XFS, not on the block device. $i isn't a
>>> typo, you should write into 100 files and read back by 100 threads in
>>> parallel when done. I've 1Gb of RAM, maybe you should use mem= kernel
>>> parameter on boot.
>>>
>>> 1. for i in `seq 1 100`; do dd of=$i if=/dev/zero bs=1M count=100
>>> 2>/dev/null; done
>>> 2. for i in `seq 1 100`; do dd if=$i of=/dev/zero bs=64k 2>/dev/null &
>>> done
>>>
>>
>> I use a combination of 4 Silicon Image controllers (SiI) and the Intel 965
>> chipset.  My max_sectors_kb is 128kb, my chunk size is 128kb, why do you
>> set the max_sectors_kb less than the chunk size?
> It's the maximum on Marvell SATA chips under Linux. Maybe hardware
> limitation. I just would used 128Kb chunk but I hit this issue.
>
>> For read-ahead, there
>> are some good benchmarks by SGI(?) I believe and some others that states
>> 16MB is the best value, over that, you lose on reads/writes or the other,
>> 16MB appears to be optimal for best overall value.  Do these values look
>> good to you, or?
> Where can I found this bechmark?

http://www.rhic.bnl.gov/hepix/talks/041019pm/schoen.pdf
Check page 13 of 20.

  I did some test on this topic, too. I think
> the optimal readahead size always depend on the number of sequentally reading
> processes and the available RAM. If you've 100 processes and 1Gb of RAM, max
> optimal readahead is about 5-6Mb, if you set it bigger that turns into
> readahead thrashing and undesirable context switches. Anyway, I tried 16Mb
> now, but the readahead size doesn't matter in this bug, same context switch
> storm appears with any readahead window size.
>
>> Read 100 files on XFS simultaneously:
> max_sectors_kb is 128kb is here? I think so. I see some anomaly, but maybe
> just you've too big readahead window for so many processes, it's not the bug
> what I'm talking about in my original post. High interrupt and CS count has
> been building slowly, it may a sign of readahead thrashing. In my case the CS
> storm began in the first second and no high interrupt count:
>
> procs -----------memory---------- ---swap-- -----io---- --system-- ----cpu----
> r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa
> 0  0      0   7220      0 940972    0    0     0     0  256    20  0  0 100  0
> 0 13      0 383636      0 535520    0    0 144904    32 2804 63834  1 42  0 57
> 24 20     0 353312      0 558200    0    0 121524     0 2669 67604  1 40  0 59
> 15 21      0 314808      0 557068    0    0 91300    33 2572 53442  0 29  0 71
>
> I attached a small kernel patch, you can measure readahead thrashing ratio
> with this (see tail of /proc/vmstat). I think it's a handy tool to find the
> optimal RA-size. And if you're interested in the bug what I'm talking about,
> set max_sectors_kb to 64Kb.
>
>
> --
> d
>
>
