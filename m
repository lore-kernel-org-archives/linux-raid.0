From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: md faster than h/w?
Date: Sat, 14 Jan 2006 01:40:53 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0601131720090.24299-100000@coffee.psychology.mcmaster.ca>
References: <dq7jii$n1c$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dq7jii$n1c$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Max Waterman <davidmaxwaterman+gmane@fastmail.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> have 5 Fujitsu MAX3073NC drives attached to one of it's channels (can't 
...
> According to Fujitsu's web site, the disks can each do internal IO at 
> upto 147MB/s, and burst upto 320MB/s. According to the LSI Logic web 

the meaning of "internal transfer rate" is a bit fuzzy - 
let's assume it means the raw bandwidth coming off the head,
before encoding and ECC overhead.  I believe the real sustained
transfer rate (at the scsi connector) would be under 100 MB/s,
decreasing noticably on inner tracks.

note also that the MegaRAID SCSI 320-2 is just a 64x66 card,
meaning its peak theoretical bandwidth is 533 MB/s, and you 
probably should expect closer to 50% of that peak under the 
best circumstances.  have you examined your PCI topology, as well
as some of the tweakable settings like the latency timer?

the 2850 seems to be a pretty reasonable server, and should
certainly not be starving you for host memory bandwidth, for instance.

> So, we're trying to measure the performance. We've been using 'bonnie++' 
> and 'hdparm -t'.

they each have flaws.  I prefer to attempt to get more basic numbers
by ignoring filesystem issues entirely, ignoring seek rates, and 
measuring pure read/write streaming bandwidth.  I've written a fairly
simple bandwidth-reporting tool:
	http://www.sharcnet.ca/~hahn/iorate.c

it prints incremental bandwidth, which I find helpful because it shows
recording zones, like this slightly odd Samsung:
	http://www.sharcnet.ca/~hahn/sp0812c.png

> Initially, we were getting 'hdparm -t' numbers around 80MB/s, but this 
> was when we were testing /dev/sdb1 - the (only) partition on the device. 
> When we started testing /dev/sdb, it increased significantly to around 
> 180MB/s. I'm not sure what to conclude from this.

there are some funny interactions between partitions, filesystems 
and low-level parameters like readahead.

> Using theoretical numbers as a maximum, we should be able to read at the 
> greater of 4 times a single drive speed (=588MB/s) or the SCSI bus speed 
> (320MB/s) ie 320MB/s.

you should really measure the actual speed of one drive alone first.  
I'd guess it starts at ~90 MB/s and drops to 70 or so..

> Doing this initially resulted in a doubling of bonnie++ speed at over 
> 200MB/s, though I have been unable to reproduce this result - the most 
> common result is still about 180MB/s.

200 is pretty easy to achieve using MD raid0, and pretty impressive for 
hardware raid, at least traditionally.  there are millions and millions
of hardware raid solutions out there that wind up being disgustingly 
slow, with very little correlation to price, marketing features, etc.
you can pretty safely assume that older HW raid solutions suck, though:
the only ones I've seen perform well are new or fundamental redesigns 
happening in the last ~2 years.

I suspect you can actually tell a lot about the throughput of a HW 
raid solution just by looking at the card: estimate the local memory
bandwidth.  for instance, the Megaraid, like many HW raid cards,
takes a 100 MHz ECC sdram dimm, which means it has 2-300 MB/s to work
with.  compare this to a (new) 3ware 9550 card, which has ddr2/400,
(8x peak bandwidth, I believe - it actually has BGA memory chips on both
sides of the board like a GPU...)

> One further strangeness is that our best results have been while using a 
> uni-processor kernel - 2.6.8. We would prefer it if our best results 
> were with the most recent kernel we have, which is 2.6.15, but no.

hmm, good one.  I haven't scrutinized the changelogs in enough detail,
but I don't see a lot of major overhaul happening.  how much difference 
are you talking about?

> So, any advice on how to obtain best performance (mainly web and mail 
> server stuff)?

do you actually need large/streaming bandwidth?  best performance 
is when the file is in page cache already, which is why it sometimes 
makes sense to put lots of GB into this kind of machine...

> Is 180MB/s-200MB/s a reasonable number for this h/w?

somewhat, but it's not really a high-performance card.  it might be
instructive to try a single disk, then 2x raid0, then 3x, 4x.  I'm guessing
that you get most of that speed with just 2 or 3 disks, and that adding the 
fourth is hitting a bottleneck, probably on the card.

> What numbers do other people see on their raid0 h/w?

I'm about to test an 8x 3ware 9550 this weekend.  but 4x disks on a $US 60
promise tx2 will already beat your system ;)




