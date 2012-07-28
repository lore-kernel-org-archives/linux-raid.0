From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID10 Performance
Date: Sat, 28 Jul 2012 10:33:43 -0500
Message-ID: <50140657.8010802@hardwarefreak.com>
References: <50115123.1020900@websitemanagers.com.au> <50123E2C.8090108@hardwarefreak.com> <50129176.3050604@websitemanagers.com.au> <5012DE22.10108@hardwarefreak.com> <50138853.5030100@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50138853.5030100@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 7/28/2012 1:36 AM, Adam Goryachev wrote:
> On 28/07/12 04:29, Stan Hoeppner wrote:

>> In that case, get 8 of these: 
>> http://www.newegg.com/Product/Product.aspx?Item=N82E16822148710
> 
> Are you suggesting these drives because:
> a) They perform better than the WD drives?
> b) They are cheaper than the WD drives
> c) give more spindles per TB
> d) The physical size
> e) other?

c&d, d facilitates c

> Just trying to clarify the choices, as far as I can find, the avg seek
> times are almost identical, but for reason b and c, I could see the
> advantage.

They're not cheaper per GB, but yes, you can get ~twice the spindles in
the same space, which is the key to performance here if sticking with
7.2k spindles.

But I think you should go with the 10K rpm Raptors.  Same capacity but
with a 40% increase in spindle speed for only 30% more cost, at Newegg
prices anyway, but I don't think Newegg ships to Australia.  If money
were of no concern, which is rarely the case, I'd recommend 15K drives.
 But they're just so disproportionately expensive compared to 10K drives
given the capacities offered.

>> See above.  Or you could get 6 of these: 
>> http://www.newegg.com/Product/Product.aspx?Item=N82E16822236243
> 
> Would 6 of these perform better than 8 of the above seagates at 7200rpm?

Generally speaking, the performance should be similar.  Choosing between
7.2/10/15k drives is a tradeoff between spindle speed, count, and
capacity.  These numbers are generally accepted estimates of spindle
performance across all drives from all vendors.  These are "peak" random
head seek rates.

7.2k = 150 IOPS = 8*150= 1200 IOPS
10k  = 225 IOPS = 6*225= 1350 IOPS
15k  = 300 IOPS = 4*300= 1200 IOPS

Four 15k drives will give the same IOPS as 8*7.2k drives for slightly
less total money, but you'll get only about 1/8th the capacity with
600GB 15K drives and 2TB 7.2K drives, 2.4TB vs 16TB.  But you can fit
almost twice as many drives in the same chassis space.  So if
performance is more critical than budget or space and you max your
chassis, your total IOPS will be 4800 vs 1200 w/16 vs 8 drives, in the
same rack space.  Which is exactly why you see many rows of racks in
many enterprise datacenters housing 2.5" drives--performance is more
critical than cost, and they have plenty of racks--and money--to achieve
the needed capacity.

You mentioned adding more capacity in the near future.  It is always
better to buy as much up front as possible and expand as little as
possible as this prevents disruption to your production environment.

If cost isn't an overriding concern, my recommendation would be to add 8
of the 10k 1TB Raptor drives and use them for your iSCSI LUN exports,
and redeploy the RE4 drives.

The performance gain with either 6 or 8 of the Raptors will be substantial.

>>> Would adding another 2 identical drives and configuring in RAID10
>>> really improve performance by double?
>>
>> No because you'd have 5 drives and you have 3 now.
> 
> Sorry, I wasn't clear. I currently am using a 2 drive RAID10 (which is
> the same as a RAID1) with a hot spare. The third drive is not active.

Ah, ok.  Yeah, you could add 2 drives and double your IOPS, but you'd
have to scrap and rebuild the array, dumping and restoring any data, as
md/RAID10 can't currently be expanded/grown.

> The specific workload that performance is being measured on is
> actually large file read + concurrent large file write + concurrent
> small random read/write. ie, in better english:
> 1) Normal operations (small random read/write, low load)
> 2) Performance testing - copying a large file with source and
> destination on the same location.

The second turns a big streaming workload into a big random workload due
to head thrashing between two platter regions.  The 10K drives will
definitely help here, especially with more of them.  At least 6 or 8.

And don't use the default 512KB chunk size of metadata 1.2.  512KB per
chunk is insane.  With your Win server VM workload, where no server does
much writing of large files or at a sustained rate, usually only small
files, you should be using a small chunk size, something like 32KB,
maybe even 16KB.  If you use a large chunk size you'll rarely be able to
fill a full stripe write, and you'll end up with IO hot spots on
individual drives, decreasing performance.

> In real world application, number 2 is replaced by a once weekly
> "maintenance procedure" that essentially is a backup (copy large file
> from/to same drive).

Are you describing snapshotting a LUN here?

> In actual fact, normal performance currently is fine, apart from this
> weekly maintenance task (blackbox, I'm not allowed to know more).

Because the Windows VMs don't do much IO, makes sense.

> The main concern is that once we add a SQL server, domain controller,
> and 2 XP VM's, it will further increase the stress on the system.

That's simply untenable with the 2 spindles you currently have.

Assuming the SQL server actually does a little work, that VM alone may
likely generate more daily IO than all others combined.

This, overall, is a typical random IOPS server workload, at least from
the perspective of the RAID subsystem in this machine.  All of the large
file operations you mention are mixed with either other large file
operations or small file ops, making the overall IO pattern a mixed
random IOPS workload.  Again, you need faster spindles, more of them,
preferably both.  Adding 8*10k 1TB drives will make a world of difference.

>> I'd recommend the 10k RPM WD Raptor 1TB drives.  They're sold as 
>> 3.5" drives but are actually 2.5" drives in a custom mounting 
>> frame, so you can use them in a chassis with either size of hot 
>> swap cage.  They're also very inexpensive given the performance 
>> plus capacity.
> 
> Would you suggest that these drives are reliable enough to support
> this type of usage? We are currently using enterprise grade drives...

The WD VelociRaptors are enterprise grade drives, just as the RE4 and XE
series.  They have the same TLER/ERC support for hardware RAID use and
the same 5 year enterprise warranty.  They're tested and certified by
LSI for use on every LSI RAID controller, just as the other two.  No
other WD drives are certified but these 3 lines.  I assume you're
familiar with LSI, the world's leading and largest producer of high
performance branded and OEM enterprise RAID HBAs, producers of Dell and
IBM's OEM RAID cards, the PERC and ServeRAID lines?

I wouldn't have mentioned them if I didn't believe they are suitable. ;)

> Not using XFS at all, it's just plain raw disk space from MD, LVM2,
> and exported via iSCSI, the client VM will format (NTFS) and use it.

You mentioned that in your first post and I simply missed/forgot it.
Sorry bout that.

>> You can grow a RAID10 based array:  join 2 or more 4 drive RAID10s 
>> in a --linear array.  Add more 4 drive RAID10s in the future by 
>> growing the linear array.  Then grow the filesystem over the new 
>> space.

Again, missed that you're exporting raw device space.

> Does a 8 drive RAID10 look like:
> A A B B C C D D
> ...
> W W X X Y Y Z Z
> 
> OR
> 
> A A B B W W X X
> ...
> C C D D Y Y Z Z

The actual pattern is a bit irrelevant.

> In other words, does RAID10 with 8 drives write 4 x as fast as a
> single drive (large continuous write) by splitting it into 4 stripes
> and writing each stripe to a pair of drives.

In a 'perfect' scenario such as a massive large file write with an
appropriate chunk/stripe size, overall array streaming write performance
should be close to 4x that of a single drive, assuming there are no
hardware bottlenecks slowing down the duplicate writes to the mirror
drives, and no CPU saturation.

An 8 drive RAID 10 has 4 data spindles and 4 redundancy spindles--in
essence a stripe over 4 RAID1 pairs.  That's the standard RAID10 layout.
 The non standard layouts unique to md will yield considerably different
layout and performance characteristics.  They can also decrease the
number of concurrent drive failures the array can survive vs standard
RAID10.  For these reasons and others I don't care for these alternate
layouts.

> Just in case I'm being silly, could I create a 8 drive RAID10 array
> using the drives you suggested above, giving 4TB usable space, move
> the existing 3 drives to the "standby" server, giving it 6 x 2TB
> drives in RAID10 maybe 2 x hot spare, and 4 usable for 4TB total
> usable space?

In this scenario the standby server will have 1/3rd the disk IOPS of the
8 drive primary machine, assuming you use the 10K Raptor drives.  Most
people are using single GbE for DRBD, limited to ~100MB/s, so the
difference in array write speed shouldn't be a problem for DRBD.  Just
make sure you have your block device mirroring setup right and you
should be fine.

And of course you'll have ~1/3rd the IOPS and throughput should you have
to deploy the standby in production.

Many people run a DRBD standby server of lesser performance than their
primary, treating it as a hedge against primary failure, and assuming
they'll never have to use it.  But it's there just in case.  Thus they
don't put as much money or capability in it.  I.e. you'd have lots of
company if you did this.

> Long term, the "standby" SAN could be replaced with the same 8 x 1TB
> drives, and move the 6 x 2TB drives into the disk based backup server
> (not san). This would avoid wasting the drives.

That sounds like a perfectly good strategy to me.

> Thanks again for your comments and suggestions on parts.

You're welcome Adam.

Did you happen to notice the domain in my email address? ;)  If you need
hardware information/advice, on anything from channel
CPUs/mobos/drives/RAID/NICs/etc to 2560 CPU SGI supercomputers and 1200+
drive FC SAN storage arrays, FC switch fabrics, and anything in between,
I can usually provide the info you seek.

-- 
Stan

