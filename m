From: Neil Brown <neilb@suse.de>
Subject: Re: Basic RAID5/6 reshape question
Date: Tue, 16 Dec 2008 09:24:47 +1100
Message-ID: <18758.55599.689845.935141@notabene.brown>
References: <4940E377.7070907@wasp.net.au>
	<4941E007.4090907@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Roger Heflin on Thursday December 11
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: Brad Campbell <brad@wasp.net.au>, RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday December 11, rogerheflin@gmail.com wrote:
> 
> Reshaping appears to be much much slower.

Yes.

> 
> I can resync in just a 2-3 hours, but a reshape of a single drive 
> takes 10-15 hours with nothing else happening, if any other work is 
> being done by the disks the number gets much worse.

With resync, the drives a streaming - reading sequential blocks.
With reshape, they are reading from one place, and writing to
another.   It tries to maximise the size of the reads and writes and
so minimise seeks, but there is a limit to that.  If you increase the
stripe_cache_size that should increase the size of each read and write
and so might improve reshape speed a bit.


> 
> To make it look just like a normally built array of the same number of 
> disks it is very likely that reshaping is moving lots and lots of data 
> around to make the changes.

True.

> 
> I have so far done 2 reshapes, and I would like to know also how 
> dangerous an event would be if it happens during a reshape.

A drive failure or a system crash should be handled correctly.

NeilBrown
