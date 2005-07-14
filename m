From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: RAID-5 streaming read performance
Date: Thu, 14 Jul 2005 19:29:32 -0400 (EDT)
Message-ID: <Pine.LNX.4.44.0507141921050.16602-100000@coffee.psychology.mcmaster.ca>
References: <1121376646.5544.125.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1121376646.5544.125.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Ming Zhang <mingz@ele.uri.edu>
Cc: Dan Christensen <jdc@uwo.ca>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> i also want a way to clear part of the whole page cache by file id. :)

understandably, kernel developers are don't high-prioritize this sort of 
not-useful-for-normal-work feature.

> i also want a way to tell the cache distribution, how many for file A
> and B, ....

you should probably try mmaping the file and using mincore.
come to think of it, mmap+madvise might be a sensible way to 
flush pages corresponding to a particular file, as well.

> > I'm really surprised there isn't something in /proc you can use to
> > clear or disable the cache.  Would be very useful for benchmarking!

I assume you noticed "blockdev --flushbufs", no?  it works for me 
(ie, a small, repeated streaming read of a disk device will show 
pagecache speed).

I think the problem is that it's difficult to dissociate readahead,
writebehind and normal lru-ish caching.  there was quite a flurry of 
activity around 2.4.10 related to this, and it left a bad taste in 
everyone's mouth.  I think the main conclusion was that too much fanciness
results in a fragile, more subtle and difficult-to-maintain system 
that performs better, true, but over a narrower range of workloads.

regards, mark hahn
sharcnet/mcmaster.

