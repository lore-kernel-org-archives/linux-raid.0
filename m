From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID10 Performance
Date: Thu, 09 Aug 2012 11:00:32 +1000
Message-ID: <50230BB0.60509@websitemanagers.com.au>
References: <50115123.1020900@websitemanagers.com.au> <50123E2C.8090108@hardwarefreak.com> <50129176.3050604@websitemanagers.com.au> <5012DE22.10108@hardwarefreak.com> <50138853.5030100@websitemanagers.com.au> <50140657.8010802@hardwarefreak.com> <5021E1BC.3060607@websitemanagers.com.au> <50229B0D.5070201@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50229B0D.5070201@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/08/12 02:59, Stan Hoeppner wrote:
> On 8/7/2012 10:49 PM, Adam Goryachev wrote:
>> Just some followup questions, hopefully this isn't too off-topic for
>> this list, if it is please let me know.
> 
>> OK, with the given budget, we currently have a couple of options:
>> 1) Replace the primary SAN (which currently has 2 x 2TB WD Caviar Black
>> RE4 drives in RAID1 + a hot spare) with 5 x 1TB Raptors you suggested
>> above (4 x 1TB in RAID10 + 1 hot spare).
> 
> Wow, that is a tight budget.  You'll be increasing total IOPS by about
> 3x with 4 10k drives.  Probably not optimal for your workload but it's a
> good start.
> 
> Also, don't use a hot spare--just wastes ports, cages, dollars.  It's
> not needed with RAID10.  Keep a spare in a locked cabinet and hot swap
> the drives upon failure notification.  RAID10 has a very large "double
> drive failure kills array" window, like many months to years.
> 
> BTW, Caviar Black != RE4  They're different products.

Yes, well it's a brand new SAN solution, for some stupid reason I didn't
consider how this would perform differently compared to the previous SAN
(overland s1000 which was ... returned.... due to some issues
experienced there). So, yes, budget is somewhat restrictive at the moment.

>> 2) Replace the primary SAN with 3 x 480GB SSD drives in linear + one of
>> the existing 2TB drives combined as RAID1 with the 2TB drive in write
>> only mode. This reduces overall capacity, but it does provide enough
>> capacity for at least 6 to 12 months. If needed, one additional SSD will
>> provide almost 2TB across the entire san.
> 
> This is simply insane, frankly.  Don't attempt this, even if md does
> support a write only mirror partner.

OK, what if we manage to do 4 x SSD's providing 960GB space in RAID10,
this might be possible now, and then we can add additional SATA
controller with additional SSD's when we need to upgrade further.

> Wait until *enterprise* SSD is fully mature and less expensive.  Stick
> with mechanical storage for now as your budget doesn't support SSD.
> If/when you go SSD, go *all* SSD, not this asymmetric Frankenstein
> stuff, which will only cause you problems.

A slightly different question, is the reason you don't suggest SSD
because you feel that it is not as good as spinning disks (reliability
or something else?)

It would seem that SSD would be the ideal solution to this problem
(ignoring cost) in that it provides very high IOPS for random read/write
performance. I'm somewhat suggesting SSD as the best option, but I'm
starting to question that. I don't have a lot of experience with SSD's,
though my limited experience says they are perfectly good/fast/etc...

>> I'm aware that a single SSD failure will reduce performance back to
>> current levels.
> 
> Then why would you ever consider this?  This thread is about increasing
> performance.  Why would you build a system that will instantly decrease
> IOPS by a factor of 1000 upon device failure?  That's insane.

Well, poor performance during a hardware failure is acceptable... at
least, explainable, and long term may assist in getting additional
funding/upgrades. In any case, if we use 4 x SSD in RAID10, that should
avoid that issue, it is only if we need to failover to the secondary san
that performance will degrade (significantly).

>>> And don't use the default 512KB chunk size of metadata 1.2.  512KB per
>>> chunk is insane.  With your Win server VM workload, where no server does
>>> much writing of large files or at a sustained rate, usually only small
>>> files, you should be using a small chunk size, something like 32KB,
>>> maybe even 16KB.  If you use a large chunk size you'll rarely be able to
>>> fill a full stripe write, and you'll end up with IO hot spots on
>>> individual drives, decreasing performance.
>>
>> I'm assuming that this can't be changed?
> 
> You assume what can't be changed?  Define what is changing.  It's a
> simple command line switch to change the chunk size from the default.
> See man mdadm.

I meant can't be changed on the current MD, ie, convert the existing MD
device to a different chunk size.

>> Could I simply create a new MD array with the smaller chunk size, tell
> 
> So you're asking how to migrate from the current disks to the new disks?
>  Yes you obviously must create a new RAID10 array.  Do you have enough
> SAS/SATA ports to have all (2+4) disks running?  If so this should be
> straightforward but will require some downtime.
> 
>> DRBD to sync from the remote to this new array, and then do the same for
>> the other SAN?
> 
> Don't do this over ethernet.  What I would do is simply shut down all
> daemons that may write to the current array, make it "static".  Shut
> down DRBD on both hosts.  Use dd or a partition tool to copy everything
> from the 2TB md/RAID1 mirror to the new 4 drive array.  Change your
> mounts etc to the new RAID10 device.  Down the 2TB mirror array.
> Confirm the new array is working.  Delete the current DRBD configuration
> on both hosts and create a new one.  Start DRBD on both hosts and as its
> syncing up restart services.

We only have 5 available sata ports right now, so probably I will mostly
follow what you just said (only change is to create new array with one
missing disk, then after the dd, remove the two old drives, and add the
4th missing disk.

> md/RAID1 doesn't guarantee symmetric read IO across members of the pair.
>  RAID1 isn't for high performance.  It's for cheap redundancy.  

Actually, I always thought RAID1 was the most expensive RAID (since it
halves capacity) and provided the best read performance. Am I really
wrong :(

Why doesn't the md driver "attempt" to balance read requests across both
members of a RAID1? Or are you saying it does attempt to, it just isn't
guaranteed?

> Even RAID0 can exhibit this behavior if you have a large chunk size
> and lots of small files.  They tend to align to the first drive in
> the stripe because they fit entirely within the chunk.  This is why
> a default 512KB chunk is insane for most workloads, especially
> mail servers.

That is perfectly understandable on RAID0, since the data only exists in
one place, so you MUST read it from the disk it exists on. You are
optimizing how the data is spread by changing the chunk size/stripe
size/etc, not where it CAN be read from.

Finally, just to throw a really horrible thought into the mix... RAID5
is considered horrible because you need to read/modify/write when doing
a write smaller than the stripe size. Is this still a significant issue
when dealing with SSD's, where we don't care about the seek time to do
this? Or is RAID5 still silly to consider (I think it is)?

Thank you.

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au
