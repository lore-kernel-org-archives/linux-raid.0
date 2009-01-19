From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: Roadmap for md/raid ???
Date: Mon, 19 Jan 2009 19:26:34 +0100
Message-ID: <4974C5DA.3090806@rabbit.us>
References: <18763.7881.300921.177207@notabene.brown> <20090111181413.GA24988@lazy.lzy> <18803.55804.905420.503480@nbeee.brown> <20090119181919.GB4290@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090119181919.GB4290@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Piergiorgio Sartor wrote:
> Hi,
> 
>>> RAID-5/6 with heterogeneous devices.
> [...]
>> I've thought about this occasionally but don't think much of the idea.
>> It seems nice until you think about what happens when devices fail
>> and you need to integrate hot spares.
>> Clearly any spare will need to be as big as the largest device.
>> When that get integrated in place of a small device, you will be
>> wasting space on it, and then someone will want to be able to
>> grow the array to use that extra space, which would be rather
>> messy.
>>
>> I think it is best to assume that all devices are the same size.
>> Trying to support anything else in a useful way would just add
>> complexity with little value.
> 
> I see your point and I also agree that complexity
> might be too much.
> 
> Nevertheless I disagree about the "wasting space",
> since I can see a scenario where there is even
> more wasting.
> 
> Let's assume we have a RAID-5 with 7 disks.
> Each time an HD fails, we will replace it with a
> larger one, since this will be cheaper.
> Once we replaced 3 HDs, with could use the unused
> space in RAID-5 again.
> Unfortunately, with the current features, we will
> have to wait to fail all the 7 disks.
> So, with 6 HDs replaced with larger ones, we will
> have a lot of wasted space.
> Of course, unless we did a clever partitioning at
> very the beginning.
> 

Or alternatively you use LVM from the start. Then you only need to
"cleverly partition" the new drives, use the first partition in the old
RAID, use the second partition for a new smaller raid, join the new raid
to the VG of the old raid and voilla - no wasted space.
