From: Dan Christensen <jdc@uwo.ca>
Subject: Re: RAID-5 streaming read performance
Date: Wed, 13 Jul 2005 08:48:02 -0400
Message-ID: <87eka2g9dp.fsf@uwo.ca>
References: <874qb14btr.fsf@uwo.ca>
 <1121220487.5552.34.camel@localhost.localdomain> <87mzorfmdx.fsf@uwo.ca>
 <1121257494.5504.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <1121257494.5504.4.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: mingz@ele.uri.edu
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Ming Zhang <mingz@ele.uri.edu> writes:

> have u try the parallel write?

I haven't tested it as thoroughly, as it brings lvm and the filesystem
into the mix.  (The disks are in "production" use, and are fairly
full, so I can't do writes directly to the disk partitions/raid
device.)

My preliminary finding is that raid writes are faster than non-raid
writes:  49MB/s vs 39MB/s.  Still not stellar performance, though.
Question for the list:  if I'm doing a long sequential write, naively
each parity block will get recalculated and rewritten several times,
once for each non-parity block in the stripe.  Does the write-caching
that the kernel does mean that each parity block will only get written
once?

Dan
