From: Dan Christensen <jdc@uwo.ca>
Subject: Re: RAID-5 streaming read performance
Date: Wed, 13 Jul 2005 10:23:33 -0400
Message-ID: <87vf3eeqe2.fsf@uwo.ca>
References: <874qb14btr.fsf@uwo.ca>
 <1121220487.5552.34.camel@localhost.localdomain> <87mzorfmdx.fsf@uwo.ca>
 <1121257494.5504.4.camel@localhost.localdomain> <87eka2g9dp.fsf@uwo.ca>
 <1121259126.5504.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <1121259126.5504.14.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: mingz@ele.uri.edu
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Ming Zhang <mingz@ele.uri.edu> writes:

> test on a production environment is too dangerous. :P
> and many benchmark tool u can not perform as well.

Well, I put "production" in quotes because this is just a home mythtv
box.  :-)  So there are plenty of times when it is idle and I can do
benchmarks.  But I can't erase the hard drives in my tests.

> LVM overhead is small, but file system overhead is hard to say.

I expected LVM overhead to be small, but in my tests it is very high.
I plan to discuss this on the lvm mailing list after I've got the RAID
working as well as possible, but as an example:

Streaming reads using dd to /dev/null:

component partitions, e.g. /dev/sda7: 58MB/s
raid device /dev/md2:                 59MB/s
lvm device /dev/main/media:           34MB/s

So something is seriously wrong with my lvm set-up (or with lvm).  The
lvm device is linearly mapped to the initial blocks of md2, so the
last two tests should be reading the same blocks from disk.

>> My preliminary finding is that raid writes are faster than non-raid
>> writes:  49MB/s vs 39MB/s.  Still not stellar performance, though.
>> Question for the list:  if I'm doing a long sequential write, naively
>> each parity block will get recalculated and rewritten several times,
>> once for each non-parity block in the stripe.  Does the write-caching
>> that the kernel does mean that each parity block will only get written
>> once?
> 
> if you write sequential, you might see a stripe write thus write only
> once.

Glad to hear it.  In that case, sequential writes to a RAID-5 device
with 4 physical drives should be up to 3 times faster than writes to a
single device (ignoring journaling, time for calculating parity, bus
bandwidth issues, etc).

Is this "stripe write" something that the md layer does to optimize
things?  In other words, does the md layer cache writes and write a
stripe at a time when that's possible?  Or is this just an automatic
effect of the general purpose write-caching that the kernel does?

> but if you write on file system and file system has meta data write, log
> write, then things become complicated. 

Yes.  For now I'm starting at the bottom and working up...

> you can use iostat to see r/w on your disk.

Thanks, I'll try that.

Dan
