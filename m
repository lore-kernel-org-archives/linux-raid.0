From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: raid1 bitmap code [Was: Re: Questions answered by Neil Brown]
Date: Wed, 26 Feb 2003 20:15:41 +0100 (MET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200302261915.h1QJFfS17808@oboe.it.uc3m.es>
References: <3E5D078C.72A523AE@SteelEye.com>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3E5D078C.72A523AE@SteelEye.com> from Paul Clements at "Feb 26,
 2003 01:29:32 pm"
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: ptb@it.uc3m.es, Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"A month of sundays ago Paul Clements wrote:"
> "Peter T. Breuer" wrote:
> > Don't worry about that - that's not necessary, I think.  The bitmap is
> > already lazy on creating pages for itself.  But yes, it needs to
> > maintain a count of dirty bits per bitmap page, and when the count drops
> > to zero it needs to free the page.  I can do that if you like?
> 
> Yes, the on-demand page freeing sounds like a good idea. If you don't
> have that, I think the bitmap eventually grows to maximum size over
> time...

Of course. But nobody's complained yet :-)

The bitmap is OO. It's easy to do changes like that. I'll have to
test the map before setting the bit in order to count the number of
dirty bits. That's all (the ops are done under lock).


> As far as the bit to block ratio, some numbers:
> 
> 1 bit/64kb @ 1TB ->   2MB maximum bitmap size
> 
> 1 bit/512b @ 1TB -> 250MB maximum bitmap size

Yes, I understand this.  But I simply do not believe it is worth the
pain initially.  The raid code already disallows all blksizes apart from
1KB and so I only allowed one bit per block!  That seems fair.
Oversizing the dirty bit to cover more than the minimal transaction unit
means that translations have to be made all over the place.  Well, OK,
it could be done by simply calling bitmap->setbit(bitmap, block >> 8)
instead of bitmap->setbit(bitmap, block >> 8), and the same for testbit,
But cannot this be left for some other time?



> So, I think that if we want to be sure that this will scale, we'll want
> the bit to block ratio to be adjustable. Another benefit of having a

Well, the simple thing is to change the bitmap calls in the patched
raid1.c to have

   block >> scale

in them instead of just block, and then set scale as a module
parameter.

> large bitmap block size is that it limits the frequency of the disk
> writes required to sync the bitmap to disk (1 sync per 128 sectors
> written vs. 1 per sector, in the example above).

But I don't think this really matters. Kernel request aggregation
to the underlying devices will smooth out everything anyhow.

My instinct is to leave things be for the moment.

Peter
