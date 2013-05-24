From: David Brown <david.brown@hesbynett.no>
Subject: Re: "Missing" RAID devices
Date: Fri, 24 May 2013 11:23:30 +0200
Message-ID: <519F3192.7000506@hesbynett.no>
References: <CAGPLN=viGgdw0MM18tiNxwjNadg0cj8xjntW3ne1qMNkfgocaA@mail.gmail.com> <519B9351.4050708@turmel.org> <CAGPLN=uiUD3wnwt6DfELaLh+yqxkbrA=KetPiQHZrqq4FrS=HA@mail.gmail.com> <519C0B13.3040906@turmel.org> <519D4A15.7020107@hardwarefreak.com> <519D541B.1090508@turmel.org> <519DB04B.5030505@hardwarefreak.com> <20130523083032.GA2579@www5.open-std.org> <519EE274.5030905@hardwarefreak.com> <20130524063228.GB30833@www5.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130524063228.GB30833@www5.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: keld@keldix.com
Cc: Stan Hoeppner <stan@hardwarefreak.com>, Phil Turmel <philip@turmel.org>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 24/05/13 08:32, keld@keldix.com wrote:
> On Thu, May 23, 2013 at 10:45:56PM -0500, Stan Hoeppner wrote:
>> On 5/23/2013 3:30 AM, keld@keldix.com wrote:
>>> On Thu, May 23, 2013 at 12:59:39AM -0500, Stan Hoeppner wrote:
>>
>>>> You may be tempted to use md/RAID10 of some layout
>>>> to optimize for writes, but you'd gain nothing, and you'd lose some
>>>> performance due to overhead.  The partitions you'll be using in this
>>>> case are so small that they easily fit in a single physical disk track,
>>>> thus no head movement is required to seek between sectors, only rotation
>>>> of the platter.
>> ...
>>> I think a raid10,far3 is a good choice for swap, then you will enjoy
>>> RAID0-like reading speed. and good write speed (compared to raid6),
>>> and a chance of live surviving if just one drive keeps functioning.
>>
>> As I mention above, none of the md/RAID10 layouts will yield any added
>> performance benefit for swap partitions.  And I state the reason why.
>> If you think about this for a moment you should reach the same conclusion.
> 
> I think it is you who are not fully aquainted with Linux MD. Linux 
> MD RAID10,far3 offers improved performance in single read, which is an
> advantage for swap, when you are swapping in. Thinkk about it and try it out for yourself.
> Especially if we are talking 3 drives (far3), but also when you are
> talking more drives and only 2 copies. You don't get raid0 read performance in Linux
> on a combination of raid1 and raid0.
> 

I think you are getting a number of things wrong here.  For general
usage, especially on a two disk system, raid10,f2 is very often an
excellent choice of setup - it gives you protection (two copies of
everything) and fastreads (you get striped read performance, and always
from the faster outer half of the disk).  You pay a higher write latency
compared to plain raid1, but with typical usage figures of 5 reads per
write, that's fine.  And normally you don't have to wait for writes to
finish anyway.

But swap is different in many ways.

First, the read/write ratio for swap is much closer to 1 - it can even
be lower than 1.  (Things like startup code for programs can get pushed
to swap and never read again, as can leaked memory from buggy programs.)

Secondly, write latency is a big factor - data is pushed to swap to free
up memory for other usage, and that has to wait until the write is complete.

Thirdly, the kernel will handle striping of multiple swap partitions
automatically.  And it will do it in a way that is optimal for swap
usage, rather than the chunk sizes used by a striped raid system.  (More
often, the kernel wants parallel access to different parts of swap,
rather than single large reads or writes.)


One thing that seems to be slightly confused here in this thread is the
mixup between the number of mirror copies and the number of drives in
raid10 setups.  With md raid, you can have as many mirrors as you like
over as many drives as you like, though you need at least as many
partitions as mirrors (and it seldom makes sense to have more mirrors
than drives).  For example, if you have 3 disks, you can use "far3"
layout to get three copies of your data - one copy on each disk.  But
you can also use "far2", and get two copies of your data.  See
<http://en.wikipedia.org/wiki/Non-standard_RAID_levels#Linux_MD_RAID_10>
for some pictures.

With plain raid1, if you use 3 drives you get three copies.

It seems unlikely to me that you would need the "safe against two disk
failure" protection of 3-way mirrors on swap, but it is possible.


Back to swap.

If you don't need protection for your swap (swap should not often be in
use, and a dead disk will lead to crashes on swapped-out processes but
should not cause more problems than that), put a small partition on each
disk, and add them all to swap.  The kernel will handle striping of the
swap partitions.  There is nothing you can do to make it faster.

When you want protection, raid1 is your best choice.  Make small
partitions on each disk, then pair them up as a number of raid1 pairs,
and add each of these as swap.  Your system will survive any disk
failure, or multiple failures as long as they are from different pairs.
 Again, there is nothing you can do to make it faster.


The important factor here is to minimise write latency.  You do that by
keeping the layers as simple as possible - raid1 is simpler and faster
than raid10 on two disks.  With small partitions, head movement and the
bandwidth differences between inner and outer tracks makes no
difference, so "far" layout is no benefit.

Theoretically, a set of raid10,f2 pairs rather than raid1 pairs would
allow faster reading of large chunks of swap - assuming, of course, that
the rest of the system supports such large I/O bandwidth.  But such
large streaming reads do not often happen with swap - more commonly, the
kernel will jump around in its accesses.  Large reads that use all
spindles are good for the throughput for large streamed reads, but they
also block all disks and increase the latency for random accesses which
are the common case for swap.


I'm a great fan of raid10,f2 - I think it is an optimal choice for many
uses, and shows a power and flexibility of Linux's md system that is
well above what you can get with hardware raid (or software raid on
other OS's).  But for swap, you want raid1.




