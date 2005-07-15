From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: RAID-5 streaming read performance
Date: Thu, 14 Jul 2005 21:23:40 -0400
Message-ID: <1121390620.5544.134.camel@localhost.localdomain>
References: <Pine.LNX.4.44.0507141921050.16602-100000@coffee.psychology.mcmaster.ca>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0507141921050.16602-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: Dan Christensen <jdc@uwo.ca>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 2005-07-14 at 19:29 -0400, Mark Hahn wrote:
> > i also want a way to clear part of the whole page cache by file id. :)
> 
> understandably, kernel developers are don't high-prioritize this sort of 
> not-useful-for-normal-work feature.
agree.

> 
> > i also want a way to tell the cache distribution, how many for file A
> > and B, ....
> 
> you should probably try mmaping the file and using mincore.
> come to think of it, mmap+madvise might be a sensible way to 
> flush pages corresponding to a particular file, as well.
i prefer a generic way. :) it will be useful to tune the system. maybe
write a program to iterate the kernel structure can do this.


> 
> > > I'm really surprised there isn't something in /proc you can use to
> > > clear or disable the cache.  Would be very useful for benchmarking!
> 
> I assume you noticed "blockdev --flushbufs", no?  it works for me 
> (ie, a small, repeated streaming read of a disk device will show 
> pagecache speed).
it will do flush right? but will it flush and clean cache?


> 
> I think the problem is that it's difficult to dissociate readahead,
> writebehind and normal lru-ish caching.  there was quite a flurry of 
> activity around 2.4.10 related to this, and it left a bad taste in 
> everyone's mouth.  I think the main conclusion was that too much fanciness
> results in a fragile, more subtle and difficult-to-maintain system 
> that performs better, true, but over a narrower range of workloads.
maybe this will happen again for 2.6.x? i think there are still many
gray areas that can be checked. also many places can be improved. a test
i did show that even you have sda and sdb to form a raid0, the page
cache for sda and sdb will not be used by raid0. kind of funny.



> 
> regards, mark hahn
> sharcnet/mcmaster.
> 

thx!

Ming


