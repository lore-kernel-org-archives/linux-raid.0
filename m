From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: RAID 1 vs RAID 0
Date: Wed, 18 Jan 2006 02:40:04 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0601180228370.2456-100000@coffee.psychology.mcmaster.ca>
References: <dqkie5$mf2$3@sea.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dqkie5$mf2$3@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Max Waterman <davidmaxwaterman+gmane@fastmail.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> They seem to suggest RAID 0 is faster for reading than RAID 1, and I 
> can't figure out why.

with R0, streaming from two disks involves no seeks;
with R1, a single stream will have to read, say 0-64K from the first disk,
and 64-128K from the second.  these could happen at the same time, and 
would indeed match R0 bandwidth.  but with R1, each disk has to seek past
the blocks being read from the other disk.  seeking tends to be slow...

> Clearly, the write performance is worse for RAID 1 than RAID 0 since 
> with RAID 1 that data you are writing at the same time is the same for 
> both drives;

the cost for doing the double writes in R1 is not high, unless you've 
already got a bottleneck somewhere that limits you to talking to one disk
at a time.  for instance, R1 to a pair of disks at 50 MB/s apiece is 
basically trivial for a decent server, since it's about 1% of memory
bandwidth, and a smallish fraction of even plain old 64x66 PCI.

> array has more than two disks, that would make RAID 1 *faster* than RAID 0.

R1 is not going to be faster than R0 on the same number of disks.

regards, mark hahn.

