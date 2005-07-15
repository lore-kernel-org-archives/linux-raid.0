From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: RAID-5 streaming read performance
Date: Fri, 15 Jul 2005 08:28:57 -0400
Message-ID: <1121430537.5548.9.camel@localhost.localdomain>
References: <Pine.LNX.4.44.0507141921050.16602-100000@coffee.psychology.mcmaster.ca>
	 <1121390620.5544.134.camel@localhost.localdomain>   <871x6095ty.fsf@uwo.ca>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <871x6095ty.fsf@uwo.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Christensen <jdc@uwo.ca>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 2005-07-14 at 22:11 -0400, Dan Christensen wrote:
> Ming Zhang <mingz@ele.uri.edu> writes:
> 
> > On Thu, 2005-07-14 at 19:29 -0400, Mark Hahn wrote:
> >>
> >> > i also want a way to clear part of the whole page cache by file id. :)
> >> 
> >> understandably, kernel developers are don't high-prioritize this sort of 
> >> not-useful-for-normal-work feature.
> > agree.
> 
> Clearing just part of the page cache sounds too complicated to be
> worth it, but clearing it all seems reasonable;  some kernel developers
> spend time doing benchmarks too!

maybe they do not care to run a program to clear it every time. :P



> 
> >> > Dan Christensen wrote:
> >> >
> >> > > I'm really surprised there isn't something in /proc you can use to
> >> > > clear or disable the cache.  Would be very useful for benchmarking!
> >> 
> >> I assume you noticed "blockdev --flushbufs", no?  it works for me 
> 
> I had tried this and noticed that it didn't work for files on a
> filesystem.  But it does seem to work for block devices.  That's
> great, thanks.  I didn't realize the cache was so complicated;
> it can be retained for files but not for the block device underlying
> those files!  

yes, that is the why the command name is blockdev. :) i guess for files
we just need to call fsync system call? is that call work on block
device as well?


> 
> > a test i did show that even you have sda and sdb to form a raid0,
> > the page cache for sda and sdb will not be used by raid0. kind of
> > funny.
> 
> I thought I had noticed raid devices making use of cache from
> underlying devices, but a test I just did agrees with your result, for
> both RAID-1 and RAID-5.  Again, this seems odd.  Shouldn't the raid
> layer take advantage of a block that's already in RAM?  I guess this
> won't matter in practice, since you usually don't read from both a
> raid device and an underlying device.

you are right, that is weired in real world.

ming


