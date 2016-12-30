From: Doug Dumitru <doug@easyco.com>
Subject: Re: Intel SSD or other brands
Date: Thu, 29 Dec 2016 17:24:16 -0800
Message-ID: <CAFx4rwRUnfCXgM66oa+-GYbtthVZvtHQkb2-J3XqUU9YXWF6sA@mail.gmail.com>
References: <0329d841-984b-fa25-0bf2-0aba4d55b6de@websitemanagers.com.au>
 <CAFx4rwT+j3mx3B_bj803Zs1kX=x-1w4Nwwsyb=a=NumFo8-Ufw@mail.gmail.com> <6199a648-eebe-687d-1a13-3f2dd954ae54@websitemanagers.com.au>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6199a648-eebe-687d-1a13-3f2dd954ae54@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Dec 29, 2016 at 2:51 PM, Adam Goryachev
<mailinglists@websitemanagers.com.au> wrote:
> On 30/12/16 05:50, Doug Dumitru wrote:
>>
>> Mr. Goryachev,
>>
>> I find it easier to look at these numbers in terms of IOPS.  You are
>> dealing with 17,500 IOPS vs 100 IOPS.  This pretty much has to be the
>> "commit" from the drive.  The benchmark is basically waiting for the
>> data to actually hit "recorded media" before the IO completes.  The
>> "better" drive is returning this "write ACK" when the data is in RAM,
>> the the "worse" drive is returning this "write ACK" after the data is
>> somewhere much slower (probably flash).  I would note that 17,500 IOPS
>> is a "good" but not "great" number.
>
>
> So what would you consider a great number? I guess in practice the
> environment isn't really that massive, it shouldn't really *need* great
> numbers, but it seems no matter how hard I try to "over-architect", it is
> still not performing to end user expectation.

The Intel drives run the same IOPS regardless of pre-conditioning.
They do this mostly by intentionally slowing down random writes so
that the worst case does not actually look any worse.  You can pretty
much dial in any level of random write IOPS by manipulating over
provisioning.  With 8% OP, a drive might get 5K IOPS, but at 20%, this
goes up to 15K.  So if you want to keep an SSD fast, don't fill it up.

>>
>> Doing commit writes to Flash is expensive.  Not only do you have to
>> wait for the flash, but you have to update the mapping tables to get
>> to the data.  Flash also does not typically allow 4K updates (even
>> given the erase rules), so your 4K sync update probably has to update
>> a 16K "page" is probably causing a lot of flash wear.  Maybe as much
>> as 10:1 write amplification.  Maybe more.
>
> Wear doesn't seem to have been a problem so far.
>
>   9 Power_On_Hours_and_Msec 0x0032   000   000   000    Old_age Always
> -       914339h+46m+34.180s
> This is obviously wrong, I haven't had the drive for >100 years, but it is
> at least almost 4 years old (early 2013 I suspect).
> 233 Media_Wearout_Indicator 0x0032   095   095   000    Old_age Always
> -       0
> This is the worst drive out of the whole array, the best is 99, but either
> way it suggests these drives could easily last >10 years, which would be
> well and truly longer than their expected/useful life (based on capacity).
>
> 241 Host_Writes_32MiB       0x0032   100   100   000    Old_age Always
> -       3329773
> This is the drive with the highest number of writes.... Obviously most
> writes are smaller than 32MB, so I'm not entirely sure what this means, but
> I suspect we are not doing a lot of writes per day compared to the total
> storage capacity...
> 3329773 * 32MB / 3 years / 365 days = 97308MB/day. Total capacity is 480*7 =
> 3360GB or approx 0.03 per drive writes per day.
>
> I've actually asked this question before, but here again we find what
> appears to be an anomaly... some drives have significantly more writes than
> others, and I don't understand why in a RAID5 array this would be the case,
> I would have expected the writes to be split approx equally across all
> drives...
> 225 Host_Writes_32MiB       0x0032   100   100   000    Old_age Always
> -       1501762
> 225 Host_Writes_32MiB       0x0032   100   100   000    Old_age Always
> -       1712480
> 225 Host_Writes_32MiB       0x0032   100   100   000    Old_age Always
> -       1684811
> 225 Host_Writes_32MiB       0x0032   100   100   000    Old_age Always
> -       1781849
> 225 Host_Writes_32MiB       0x0032   100   100   000    Old_age Always
> -       2282764
> 225 Host_Writes_32MiB       0x0032   100   100   000    Old_age Always
> -       2269957
> 225 Host_Writes_32MiB       0x0032   100   100   000    Old_age Always
> -       2154155
> 225 Host_Writes_32MiB       0x0032   100   100   000    Old_age Always
> -       2163563
> 225 Host_Writes_32MiB       0x0032   100   100   000    Old_age Always
> -       3329774
>
> It's hard to calculate whether some drives were replaced or similar due to
> the nonsense power on hours values.... but generally all these drives were
> purchased at the same time, and so should have been used mostly equally.
>
>> In the case of RAID-5 in a "traditional" Linux deployment, and
>> especially with DRBD protecting you on another node, you are probably
>> fine without having every last ACK "perfect".  After all, if you power
>> fail the primary node, the secondary will become the primary, and any
>> "tail writes" that are missing will get re-sync'd by DRBD's hash
>> checks.  And because the amount of data being re-synced is small, it
>> will happen very quickly and you might not even notice it.
>
> Right, and at this stage I'm not even looking at data integrity, I'm only
> examining "performance". In fact, it would be within the "acceptable"
> parameters" to lose some data under a "disaster" scenario (where disaster
> means losing both primary and secondary in an unclean shutdown). Of course,
> I wouldn't design the system to do that, but it isn't a strict requirement,
> as long as "normal" processes mean no data loss/corruption, and any drive
> should (eventually) write all the data it has told you it will.
>>
>> Back to performance, you should also consider what your array is doing
>> to you.  You are running an 8 drive raid-5 array.  This will limit
>> performance even more because every write becomes 2 sync writes, plus
>> 6 reads.  With q=1 latencies, if you run this test on the array with
>> "good" drives, you should probably get about 15K IOPS max, but it
>> might be a bit worse as the read and write latencies add for each OP.
>
> Right, and one thing I've considered was moving to RAID10 to avoid this, but
> even RAID10 means 2 writes. Assuming reads are relatively quick, than that
> should reduce the impact of the RAID5 as well. At this stage, converting to
> RAID10 is still something I'm holding up my sleeve as a last resort (due to
> the additional wasted capacity).
>
> Note that my tests are all on single drives, not the array. I can't afford
> to be doing testing on the full array due to the destructive nature, and
> also it is almost impossible to get a quiet moment where the tests wouldn't
> be affected by workload.
>>
>> I tried your test on our "in house" "server-side FTL" mapping layer on
>> 8 drives raid-5.  This is an E5-1650 v3 w/ an LSI 3008 SAS controller
>> and 8 Samsung 256GB 850 Pro SSDs.  The array is "new" so it will slow
>> down somewhat as it fills.  439K IOPS is actually quite a bit under
>> the array's bandwidth, but at q=1, you end up benchmarking the
>> benchmark program.  (at q=10, the array saturates the drives linear
>> performance at about 900K IOPS or 3518 MB/sec).
>>
>> root@ubuntu-16-24-2:/usr/local/ess# fio --filename=/dev/mapper/ess-md0
>> --direct=1 --sync=1 --rw=write --bs=4k --iodepth=1 --runtime=60
>> --time_based --group_reporting --name=ess-raid5 --numjobs=1
>
> Would it be possible for you to run the test on a single drive directly
> instead?
>>
>>
>> Run status group 0 (all jobs):
>>    WRITE: io=102653MB, aggrb=1710.9MB/s, minb=1710.9MB/s,
>> maxb=1710.9MB/s, mint=60001msec, maxt=60001msec
>
> I might be looking at the wrong value, but you are getting 1711MB/s out of
> an 8 drive array, I got a max of 99MB/s on a single drive, even if I
> multiply that by 7 (8 drives - 1 redundancy), it's still less than half. I'd
> be pretty keen to see your single drive results. Also whether those results
> will change when using the 800GB model.

My test is of a "managed" array with a "host side Flash Translation
Layer".  This means that software is linearizing the writes before
RAID-5 sees them.  This is how the major "storage appliance" vendors
get really fast performance.  One vendor, running an earlier version
of the software I am running here, was able to support 5000 ESXI VDI
clients from a single 2U storage server (with a lot of FC cards).  The
boot storm took about 3 minutes to settle.

Single drives are around 500 MB/sec which is 125K IOPS through our
engine.  Eight drives are (8-1)x500=3500 MB/sec or 900K IOPS.  This is
actually faster than FIO can generate a test pattern from a single
job.  It is also faster than stock RAID-5 can linearly write without
patches.

In terms of wear, lots of users are running very light write
environments.  This is good as many configurations are > 50:1 write
amp if you measure "end to end".  By end to end, I mean, how many
flash writes happen when you create a small file inside of a file
system.  This leads to "file system write amp" x "raid write amp" x
"SSD write amp".  Some people don't like this approach as the file
system is often "off limits" and a black box.  Then again, some file
systems are better than others (for 10K sync creates, EXT4 and XFS are
both about 4.4:1 whereas ZFS is a lot worse).  And with EXT4/XFS, you
can mitigate some of this with an SSD or mapping layer that compresses
blocks.

Doug Dumitru



>
> Thank you for your advice, I'll see whether I can find a way to purchase one
> of the samsung drives for testing/evaluation, then seem to be a similar
> price to the Intel S3510 that I was looking at.
>
> Regards,
> Adam
>
>
>> On Wed, Dec 28, 2016 at 6:14 PM, Adam Goryachev
>> <mailinglists@websitemanagers.com.au> wrote:
>>>
>>> Apologies for my prematurely sent email (if it gets through), this one is
>>> complete...
>>>
>>> Hi all,
>>>
>>> I've spent a number of years trying to build up a nice RAID array for my
>>> SAN, but I seem to be slowly solving one bottle neck only to find another
>>> one. Right now, I've identified the underlying SSD's as being a major
>>> factor
>>> in that performance issue.
>>>
>>> I started with 5 x 480GB Intel 520s SSD's in a RAID5 array, and this
>>> performed really well.
>>> I added 1 x 480GB 530s SSD
>>> I added 2 x 480GB 530s SSD
>>>
>>> I now found out that performance of a 520s SSD is around 180 times faster
>>> than a 530s SSD. I had to run many tests, but eventually I found the
>>> right
>>> things to test for (which matched my real life results), and the numbers
>>> were nothing short of crazy.
>>> Running each test 5 times and average the results...
>>> 520s: 70MB/s
>>> 530s: 0.4MB/s
>>>
>>> OK, so before I could remove and test the 520s, I removed/tested one of
>>> the
>>> 530s and saw the horrible performance, so I bought and tested a 540s and
>>> found:
>>> 540s: 6.7MB/s
>>> So, around 20 times better than the 530, so I replaced all the drives
>>> with
>>> the 540, but I still have worse performance than the original 5 x 520s
>>> array.
>>>
>>> Working with Intel, they swapped a 530s drive for a DC3510, and I then
>>> found
>>> the DC3510 was awesome:
>>> DC3510: 99MB/s
>>> Except, a few weeks back when I placed the order, I was told there is no
>>> longer any stock of this drive, (I wanted 16 x 800GB model), and that the
>>> replacement model is the DC3520. So I figure I won't just blindly buy the
>>> DC3520 assuming it's performance will be similar to the previous model,
>>> so I
>>> buy 4 x 480GB DC3520 and start testing.
>>> DC3520: 37MB/s
>>>
>>> So, 1/3rd of a DC3510, but still better than the current live 540s
>>> drives,
>>> but also still half the original 520s drives.
>>>
>>> Summary:
>>> 520s:   70217kB/s
>>> 530s:     391kB/s
>>> 540s:    6712kB/s
>>> 330s:      24kB/s
>>> DC3510: 99313kB/s
>>> DC3520: 37051kB/s
>>> WD2TBCB:  475kB/s
>>>
>>> * For comparison, I had a older Western Digital Black 2TB spare, and ran
>>> the
>>> same test on it. Got a better result than some of the SSD's which was
>>> really
>>> surprising, but it's certainly not an option.
>>> FYI, the test I'm running is this:
>>> fio --filename=/dev/sdb --direct=1 --sync=1 --rw=write --bs=4k
>>> --iodepth=1
>>> --runtime=60 --time_based --group_reporting --name=IntelDC3510_4kj1
>>> --numjobs=1
>>> All drives were tested on the same machine/SATA3 port (basic intel
>>> desktop
>>> motherboard), with nothing on the drive (no fs, no partition, nothing
>>> trying
>>> to access it, etc..).
>>> In reality, I tested iodepth from 1..10, but in my use case, the
>>> iodepth=1
>>> matches is the relevant number. At higher iodepth, we see performance on
>>> all
>>> the drives improve, if interested, I can provide a full set of my
>>> results/analysis.
>>>
>>> So, my actual question... Can you suggest or have you tested any Intel
>>> (or
>>> other brand) SSD which has good performance (similar to the DC3510 or the
>>> 520s)? (I can't buy and test every single variant out there, my budget
>>> doesn't go anywhere close to that).
>>> It needs to be SATA, since I don't have enough PCIe slots to get the
>>> needed
>>> capacity (nor enough budget). I need around 8 x drives with around 6TB
>>> capacity in RAID5.
>>>
>>> FYI, my storage stack is like this:
>>> 8 x SSD's
>>> mdadm - RAID5
>>> LVM
>>> DRBD
>>> iSCSI
>>>
>>>  From my understanding, it is DRBD that makes everything a iodepth=1
>>> issue.
>>> It is possible to reach iodepth=2 if I have 2 x VM's both doing a lot of
>>> IO
>>> at the same time, but it usually a single VM performance that is too
>>> limited.
>>>
>>> Regards,
>>> Adam
>>>
>>>
>>> --
>>> Adam Goryachev Website Managers www.websitemanagers.com.au
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>
>
> --
> Adam Goryachev Website Managers www.websitemanagers.com.au
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Doug Dumitru
EasyCo LLC
