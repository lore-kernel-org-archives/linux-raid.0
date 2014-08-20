From: David Brown <david.brown@hesbynett.no>
Subject: Re: Correct RAID options
Date: Wed, 20 Aug 2014 09:32:40 +0200
Message-ID: <53F44F18.1020401@hesbynett.no>
References: <027801cfbbdc$d33970f0$79ac52d0$@savage.za.org>	<53F3EA59.6030808@hesbynett.no> <CA+4TWFtG0ofkzQH0-k-rjOakasQNvcNZDgit=KknE6TCaKXpgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+4TWFtG0ofkzQH0-k-rjOakasQNvcNZDgit=KknE6TCaKXpgg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Knipe <savage@savage.za.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/08/14 03:24, Chris Knipe wrote:
> On Wed, Aug 20, 2014 at 2:22 AM, David Brown <david.brown@hesbynett.no> wrote:
> 

Let me first add a disclaimer - my comments here are based mainly on
theory, much of it gained from discussions on this list over the years.
 I haven't built servers like this, and I haven't used XFS with linear
concatenation - I have just heard many nice things about it, and it
sounds to me like a good fit for your needs.  But you are doing the
right thing with your testing and benchmarking - it's the only way to
find out if the raid/filesystem setup matches /your/ loads.

>> In general, a 15 disk raid5 array is asking for trouble.  At least make it
>> raid6.
> 
> At this stage the IO load on the archiver with the 15 disk RAID5 is
> -very- minimal.  It's not even writing 8MB/s currently as the front
> end RAID10 servers are obviously severely hampered whilst doing the
> concurrent read/write requests. Now that it is our peak times, load
> averages shoot up to over 80 due to IO wait from time to time, so this
> is kinda critical for me right now :-(

I wasn't thinking so much about the load here, as the
safety/reliability.  With a 15 disk system with heavy load, you /will/
get double failures, such as a disk failing and an unrecoverable read
error during rebuild.  Raid6 will make it orders of magnitude more reliable.

Regarding performance, striping (with raid0, raid5, raid6) across a
large number of disks (or raid1 pairs for raid10) works well for large
reads and writes, but for smaller accesses you get lots of partial
stripe writes (which have to be turned into full stripe writes, or RMW
accesses) and lots of head movement for each access.  Stripe caches
help, of course, but with hardware raid cards the stripe cache is
limited by the hardware raid card rather than main memory.

> 
> Just a bit more background as was asked in the other replies...
> Front end Servers are Dell PowerEdge R720 DX150s (8 x 4TB SATA-III,
> 64GB Ram, and Dual Xeon E5-2620 Hex-Core @ 2.00GHz)
> The archiver is custom built (no brand name) and consists of the 15 x
> 4TB SATA-II drives, 32GB Ram, and a single Xeon E3-1245 Quad-Core @
> 3.3Ghz
> 
> Now the archiver we added is new - so I can't really comment at this
> stage on how it is performing as it is not getting any real work from
> the front ends.  During our standard benching (hdparm / dd / bonnie)
> with no load on the archiver in terms of IO, performance was more than
> adequate.
> 
> In terms of the front-ends with our "normal" load distribution of a
> 70/30 split between writes/reads, there's no serious performance
> problems.  With over 500 concurrent application threads per server
> accessing the files on the disks, load averages are generally around
> the 3 to 5 range, with very minimal IO wait.  Munin reports "disk
> utilization" between 20% and 30%, "disk latency" sub 100ms, and "disk
> throughput" at about 30MB/s if I have to average all of this out.
> 
> Since we've now started to move data from the front ends to the
> archiver, we have obviously thrown the 70/30 split out of the window,
> and all stats are basically now off the charts. "disk utilization" is
> averaging between 90% to 100%. The reading of the data from the front
> end servers is obviously causing a bottleneck, and I can confirm this
> seeing that as soon as we stop the archiving process that reads the
> data on the front ends and writes it to the archiver, the load on the
> servers return to normal.

Is there any way to coordinate the writes to the front end and the
archiver?  If you can archive a file just after it has been written to
the front-end disks, then it will be served from ram, and there will be
no need to read it physically from the disk.

> 
> In terms of adding more front end servers - it is definitely an option
> yes.  Being brand name servers they do come at a premium however so I
> would ideally like to have this as a last resort.  The premium cost,
> together with the limited storage capacity basically made us opt to
> rather try and offload some of the storage requirements to cheaper
> alternatives (more than double the capacity - even at RAID10, for less
> than half the price - realistically, we will be more than happy with
> half the performance as well, so I'm not expecting miracles either).
> 
> RAID rebuilds are already problematic on the front end servers (RAID
> 10 over 8 x 4TB) with a single drive failure whilst the server is
> under load takes approximately 8 odd hours to rebuild if memory serves
> me correctly.  We've had a few failures in the past (even a double
> drive failure at the same time), but nothing recent that I can recall
> accurately.
> 
> I was never aware that bigger block sizes would increase read
> performance though - this is interesting and something I can
> definitely explore.  I am talking under correction, but I believe the
> MegaRAIDs we're using can even go bigger than 1mbyte blocks.  I'll
> have to check on this.  Bigger blocks does mean wasting more space
> though if the files written are smaller and can't necessarily fill up
> an entire block, right?  I suppose when you start talking about 12TB
> and 50TB arrays, the amount of wasted space really becomes
> insignificant, or am I mistaken?
> 
> SANs unfortunately is out of the question as this is hosted
> infrastructure at a provider that does not offer SANs as part of their
> product offerings.
> 
> 
>> But the general idea is to have a set of raid1 mirrors (or possible Linux md
>> raid10,far2 pairs if the traffic is read-heavy), and then tie them all
>> together using a linear concatenation rather than raid0 stripes.  When you
> 
> Can I perhaps ask that you just elaborate a bit on what you mean by
> linear concatenation?  I am presuming you are not referring to RAID 10
> 'per say' here as to your comment to use this rather than RAID 0
> stripes.  XFS by itself, is also a good option - I honestly do not
> know why this wasn't given consideration when we initially set the
> machines up.  By the sound of it, all of them are now going to be
> facing a rebuild.

Let me step back a little, and try to make the jargon clearer.  Terms
can be slightly different in the md raid world than the hardware raid
world, because md raid is often more flexible.

raid1 is a simple mirroring of two or more disks.  I don't know if your
hardware allows three-way mirroring, but it can help speed up read
access (more parallel reads from the same set), gives extra redundancy,
and faster rebuilds, at the cost of marginally more write time (since
your write latency is the worst case of three disks) - and obviously at
the cost of more disks.  For many complex raid systems, raid1 pairs are
your basic building block.

md raid supports a type of raid10 on two disks (actually, on any number
of disks).  You can imagine the "far" layout as splitting the two disks
into two halves, 1a+1b and 2a+2b.  1a is mirrored (raid1) with 2b and 1b
is mirrored with 2a.  Then these two mirrors are striped (raid0).  Write
performance is similar to raid1 - data is written in two copies, once to
each disk.  But read performance is fast - it is read as a stripe, with
the faster outer halves of each disk used of preference, giving faster
than raid0 reads.  For read-heavy loads, it is therefore a very nice setup.

<http://en.wikipedia.org/wiki/Linux_MD_RAID_10#LINUX-MD-RAID-10>

In your case, however, I expect you will use plain raid1 pairs from the
hardware raid controller.


"linear concatenation" is a md raid type that simply makes one big
logical disk from putting the contained disks (or raid1 pairs) together.
 There is no striping or extra parity.  The overhead of the "raid" is
absolutely minimal - no more than a re-mapping of logical sectors on the
concat to the constituent block devices.

This is quite inefficient for most filesystems - critical structures
would end up on the one raid1 pair, and you would make no use of the
later pairs until the first pairs were full.  But XFS has a concept of
"allocation groups", and likes to divide the whole "disk" into these
AG's.  Every time you make a new directory, it gets put into another AG
with a simple round-robin policy (AFAIK).  All access to a file - data,
metadata, inodes, directory entries, etc., will be done within entirely
within the AG.

So with your 8 disk front-end servers, you would first set up 4 pairs of
hardware raid1 mirrors.  You join these in a linear concat.  Then you
make an XFS filesystem with two AG's per mirror - 8 AG's altogether.
The directories you make will then be spread evenly across these, and
you will get maximal parallelism accessing files in different directories.

XFS over linear concat is typically used for large mail servers (using
maildir directories for each user), or "home directory servers" for
large numbers of users.  It is efficient for small file access, and
stops large file accesses blocking other accesses (but it is not ideal
if you need high speed streaming of a few big files).

(As the XFS fills up, if an AG gets full then new files spill over into
other AGs - so if your data is not evenly spread across directories then
you can still use all your disk space, but you lose a little of the
parallelism.)

> 
>> I am assuming your files are fairly small - if your reads or writes are
>> often smaller than a full stripe of raid10 or raid5, performance will suffer
>> greatly compared to XFS on a linear concat.
> 
> The files are VERY evenly distributed using md5 hashes.  We have 16
> top level directories, 255 second level directories, and 4094 third
> level directories.  Each third level directory currently holds between
> 4K and 4.5K files per directory (the archiver servers should have
> roughly three or four times that amount once the disks are full).
> Files are generally between 250kb and 750kb, a small percentage are a
> bit larger to the 1.5mb range, and I can almost guarantee that not one
> single file will exceed the 5mb range.  I'm not sure what the stripe
> size is at this stage but it is more than likely what ever the default
> is for the controller (64kb?)
> 
> I think to explore XFS would need to be my first port of call here.
> Take one of the front ends out of production tomorrow when load has
> quieted down, trash it, and rebuild it.  Then we'll more than likely
> need 2 or 3 weeks for the disks to fill up again with files before
> we're really going to see how it compares.
> 
> If I can perhaps just get some clarity in terms of the physical disk
> layouts / configurations that you would recommend, I would appreciate
> it greately.  You're obviously not talking about a simple RAID 10
> array here, even though I think just XFS over EXT4 would already do us
> wonders.
> 
> Many thanks for all the responces!
> 

The xfs.org site should have more information on this (read the FAQ),
and I believe they have a good mailing list too.  There are a number of
options and parameters that are important when creating and mounting an
XFS system, and they can make a huge difference to performance.  You
need to be careful about barriers and caching - if your hardware raid
controller has battery backup then you can disable barriers for faster
performance.  If you get your AG's aligned with the elements of your
linear cat, you will get high speeds - but if you get it wrong,
performance will be crippled.  And while I believe "twice the number of
raid1 pairs" is a common choice for the number of AG's in this sort of
arrangement, it may be better with more (but still a multiple of the
number of pairs).

Another possibility for XFS is to use an external log file rather than
putting it on main disks.  Consider using a small but fast SSD for the
log, in addition to the main disk array.  This would also be a
convenient place to put everything else, such as the OS, leaving your
main disks for the application data.

Also be aware that doing a fsck on XFS can take a long time, and use a
lot of memory.  I assume you've got a good UPS!

Remember, this is expensive, high-performance equipment you are playing
with.  So have fun :-)


