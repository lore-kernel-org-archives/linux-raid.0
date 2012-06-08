From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Software RAID checksum performance on 24 disks not even close
 to kernel reported
Date: Thu, 07 Jun 2012 20:23:42 -0500
Message-ID: <4FD1541E.3030705@hardwarefreak.com>
References: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com> <CA+4vN7xQgecd95FO6gYVLMuPDKXbfZfzuXS1dzHd+e-otrPxwg@mail.gmail.com> <CAA9_cmcANJjd8gfagWw5vENABh+n13xFnk7OF-ZzxecfxU719w@mail.gmail.com> <4FD028B2.1050306@hardwarefreak.com> <4FD0BD78.2050808@gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FD0BD78.2050808@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/7/2012 9:40 AM, Joe Landman wrote:
> Not to interject too much here ...
> 
> On 06/07/2012 12:06 AM, Stan Hoeppner wrote:
>> On 6/6/2012 11:09 AM, Dan Williams wrote:
>>
>>> Hardware raid ultimately does the same shuffling, outside of nvram an
>>> advantage it has is that parity data does not traverse the bus...
>>
>> Are you referring to the host data bus(s)?  I.e. HT/QPI and PCIe?
>>
>> With a 24 disk array, a full stripe write is only 1/12th parity data,
>> less than 10%.  And the buses (point to point actually) of 24 drive
>> caliber systems will usually start at one way B/W of 4GB/s for PCIe 2.0
>> x8 and with one way B/W from the PCIe controller to the CPU starting at
> 
> PCIe gen 2 is ~500MB/s per lane in each direction, but there's like a
> 14% protocol overhead, so your "sustained" streaming performance is more
> along the lines of 430 MB/s.  For a PCIe x8 gen 2 system, this nets you
> about 3.4GB/s in each direction.

You're quite right Joe.  I was intentionally stating raw B/W numbers
simply for easier comparison, same with my HT numbers below.

>> 10.4GB/s for AMD HT 3.0 systems.  PCIe x8 is plenty to handle a 24 drive
>> md RAID 6, using 7.2K SATA drives anyway.
> 
> Each drive capable of streaming say 140 MB/s (modern drives).  24 x 140
> = 3.4 GB/s

I was being conservative and assuming 100MB/s per drive, as streaming
workloads over stripes don't seem to always generate typical single
streaming behavior at the individual drive level.

> This assumes streaming, no seeks that aren't part of streaming.
> 
> This said, this is *not* a design pattern you'd want to follow for a
> number of reasons.
> 
> But for seek heavy designs, you aren't going to hit anything close to
> 140 MB/s.  We've just done a brief study for a customer on what they
> should expect to see (by measuring it and reporting on the measurement).
>  Assume close to an order of magnitude off for seekier loads.

Yep.  Which is why I always recommend the fastest spindles one can
afford if they have a random IOPS workload, or many parallel streaming
workloads, or mix of these.  Both hammer the actuators, and even more so
using XFS w/Inode64 on a striped array.

And I'd never recommend a 23/24 drive RAID6 (or RAID5).  I was simply
commenting based on the OP's preferred setup.  I did recommend multiple
RAID5s as a better solution to the 23 drive RAID6 and the OP did not
respond to those suggestions.  Seems he's set on a 23 drive RAID6 no
matter what.

> Also, please note that iozone, dd, bonnie++, ... aren't great load
> generators, especially if things are in cache.  You tend to measure the
> upper layers of the file system stack, and not the actual full stack
> performance.  

I've never quoted numbers from any of these benchmarks.  I don't use
them.  I did comment on someone else's apparent misuse of dd.

> fio does a better job if you set the right options.  This
> said, almost all of these codes suffer from a measurement at the front
> end of the stack, if you want to know what the disks are really doing,
> you have to start poking your head into the kernel proc/sys spaces.
> Whats interesting is that of the tools mentioned, only fio appears to
> eventually converge its reporting to what the backend hardware does. The
> front end measurements seem to do a pretty bad job of deciding when an
> IO begins and when it is complete.  Could be an fsync or similar problem
> (discussed in the past), but its very annoying.  End users look at
> bonnie++ and other results and don't understand why their use case is so
> badly different in performance.

When I do my own benchmarking it's at the application level.  I let
others benchmark however they wish.  It's difficult and too time
consuming to convince some users that their fav benchy has no relevance
to their target workload.  That takes time and patience, and often
political skills, which I don't tend to possess.  On occasion I will try
to steer people clear of what should be seen as obviously bad design
choices but are yet not.

>> What is a bigger issue, and may actually be what you were referring to,
>> is read-modify-write B/W, which will incur a full stripe read and write.
>>   For RMW heavy workloads, this is significant.  HBA RAID does have a big
>> advantage here, compared to one's md array possessing the aggregate
>> performance to saturate the PCIe bus.
> 
> The big issues for most HBAs are the available bandwidth to the disks,
> the quality/implementation of the controllers/drivers, etc.  Hanging 24
> drives off a single controller is a low cost design, not a high
> performance design.  You will get contention (especially with expandor
> chips).  You will get sub-optimal performance.

In general I'd agree.  But this depends heavily on the HBA, its ASIC,
its QC, and the same for any expanders in question.  The LSI 2x36 6Gb/s
SAS expander ASIC doesn't seem to slow things down any.  The Marvell SAS
expanders, and Marvell and Silicon Image SATA PMPs are another story.

Regarding HBAs, there are a few LSI boards that when used with LSI
expanders can easily handle 24 drive md arrays.

> Checksumming speed on the CPU will not be the bottleneck in most of
> these cases.  Controller/driver performance and contention will be.

Not threading?  Well, I guess if you have a cruddy HBA and/or driver you
won't get far enough along to hit the md raid threading limitation, so
this is a good point.

-- 
Stan
