From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: RAID-5 streaming read performance
Date: Wed, 13 Jul 2005 08:52:06 -0400
Message-ID: <1121259126.5504.14.camel@localhost.localdomain>
References: <874qb14btr.fsf@uwo.ca>
	 <1121220487.5552.34.camel@localhost.localdomain> <87mzorfmdx.fsf@uwo.ca>
	 <1121257494.5504.4.camel@localhost.localdomain>  <87eka2g9dp.fsf@uwo.ca>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87eka2g9dp.fsf@uwo.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Christensen <jdc@uwo.ca>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 2005-07-13 at 08:48 -0400, Dan Christensen wrote:
> Ming Zhang <mingz@ele.uri.edu> writes:
> 
> > have u try the parallel write?
> 
> I haven't tested it as thoroughly, as it brings lvm and the filesystem
> into the mix.  (The disks are in "production" use, and are fairly
> full, so I can't do writes directly to the disk partitions/raid
> device.)
test on a production environment is too dangerous. :P
and many benchmark tool u can not perform as well.

LVM overhead is small, but file system overhead is hard to say.

> 
> My preliminary finding is that raid writes are faster than non-raid
> writes:  49MB/s vs 39MB/s.  Still not stellar performance, though.
> Question for the list:  if I'm doing a long sequential write, naively
> each parity block will get recalculated and rewritten several times,
> once for each non-parity block in the stripe.  Does the write-caching
> that the kernel does mean that each parity block will only get written
> once?
> 
if you write sequential, you might see a stripe write thus write only
once.

but if you write on file system and file system has meta data write, log
write, then things become complicated. you can use iostat to see r/w on
your disk.

> Dan

