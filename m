From: Chris Knipe <savage@savage.za.org>
Subject: Re: Correct RAID options
Date: Wed, 20 Aug 2014 03:24:36 +0200
Message-ID: <CA+4TWFtG0ofkzQH0-k-rjOakasQNvcNZDgit=KknE6TCaKXpgg@mail.gmail.com>
References: <027801cfbbdc$d33970f0$79ac52d0$@savage.za.org>
	<53F3EA59.6030808@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53F3EA59.6030808@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Aug 20, 2014 at 2:22 AM, David Brown <david.brown@hesbynett.no> wrote:

> In general, a 15 disk raid5 array is asking for trouble.  At least make it
> raid6.

At this stage the IO load on the archiver with the 15 disk RAID5 is
-very- minimal.  It's not even writing 8MB/s currently as the front
end RAID10 servers are obviously severely hampered whilst doing the
concurrent read/write requests. Now that it is our peak times, load
averages shoot up to over 80 due to IO wait from time to time, so this
is kinda critical for me right now :-(

Just a bit more background as was asked in the other replies...
Front end Servers are Dell PowerEdge R720 DX150s (8 x 4TB SATA-III,
64GB Ram, and Dual Xeon E5-2620 Hex-Core @ 2.00GHz)
The archiver is custom built (no brand name) and consists of the 15 x
4TB SATA-II drives, 32GB Ram, and a single Xeon E3-1245 Quad-Core @
3.3Ghz

Now the archiver we added is new - so I can't really comment at this
stage on how it is performing as it is not getting any real work from
the front ends.  During our standard benching (hdparm / dd / bonnie)
with no load on the archiver in terms of IO, performance was more than
adequate.

In terms of the front-ends with our "normal" load distribution of a
70/30 split between writes/reads, there's no serious performance
problems.  With over 500 concurrent application threads per server
accessing the files on the disks, load averages are generally around
the 3 to 5 range, with very minimal IO wait.  Munin reports "disk
utilization" between 20% and 30%, "disk latency" sub 100ms, and "disk
throughput" at about 30MB/s if I have to average all of this out.

Since we've now started to move data from the front ends to the
archiver, we have obviously thrown the 70/30 split out of the window,
and all stats are basically now off the charts. "disk utilization" is
averaging between 90% to 100%. The reading of the data from the front
end servers is obviously causing a bottleneck, and I can confirm this
seeing that as soon as we stop the archiving process that reads the
data on the front ends and writes it to the archiver, the load on the
servers return to normal.

In terms of adding more front end servers - it is definitely an option
yes.  Being brand name servers they do come at a premium however so I
would ideally like to have this as a last resort.  The premium cost,
together with the limited storage capacity basically made us opt to
rather try and offload some of the storage requirements to cheaper
alternatives (more than double the capacity - even at RAID10, for less
than half the price - realistically, we will be more than happy with
half the performance as well, so I'm not expecting miracles either).

RAID rebuilds are already problematic on the front end servers (RAID
10 over 8 x 4TB) with a single drive failure whilst the server is
under load takes approximately 8 odd hours to rebuild if memory serves
me correctly.  We've had a few failures in the past (even a double
drive failure at the same time), but nothing recent that I can recall
accurately.

I was never aware that bigger block sizes would increase read
performance though - this is interesting and something I can
definitely explore.  I am talking under correction, but I believe the
MegaRAIDs we're using can even go bigger than 1mbyte blocks.  I'll
have to check on this.  Bigger blocks does mean wasting more space
though if the files written are smaller and can't necessarily fill up
an entire block, right?  I suppose when you start talking about 12TB
and 50TB arrays, the amount of wasted space really becomes
insignificant, or am I mistaken?

SANs unfortunately is out of the question as this is hosted
infrastructure at a provider that does not offer SANs as part of their
product offerings.


> But the general idea is to have a set of raid1 mirrors (or possible Linux md
> raid10,far2 pairs if the traffic is read-heavy), and then tie them all
> together using a linear concatenation rather than raid0 stripes.  When you

Can I perhaps ask that you just elaborate a bit on what you mean by
linear concatenation?  I am presuming you are not referring to RAID 10
'per say' here as to your comment to use this rather than RAID 0
stripes.  XFS by itself, is also a good option - I honestly do not
know why this wasn't given consideration when we initially set the
machines up.  By the sound of it, all of them are now going to be
facing a rebuild.

> I am assuming your files are fairly small - if your reads or writes are
> often smaller than a full stripe of raid10 or raid5, performance will suffer
> greatly compared to XFS on a linear concat.

The files are VERY evenly distributed using md5 hashes.  We have 16
top level directories, 255 second level directories, and 4094 third
level directories.  Each third level directory currently holds between
4K and 4.5K files per directory (the archiver servers should have
roughly three or four times that amount once the disks are full).
Files are generally between 250kb and 750kb, a small percentage are a
bit larger to the 1.5mb range, and I can almost guarantee that not one
single file will exceed the 5mb range.  I'm not sure what the stripe
size is at this stage but it is more than likely what ever the default
is for the controller (64kb?)

I think to explore XFS would need to be my first port of call here.
Take one of the front ends out of production tomorrow when load has
quieted down, trash it, and rebuild it.  Then we'll more than likely
need 2 or 3 weeks for the disks to fill up again with files before
we're really going to see how it compares.

If I can perhaps just get some clarity in terms of the physical disk
layouts / configurations that you would recommend, I would appreciate
it greately.  You're obviously not talking about a simple RAID 10
array here, even though I think just XFS over EXT4 would already do us
wonders.

Many thanks for all the responces!

--
Chris.
