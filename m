From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: async writes in raid1
Date: Mon, 14 Apr 2003 21:24:03 +0200 (MET DST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200304141924.h3EJO4x07957@oboe.it.uc3m.es>
References: <3E9B00F6.6C46EBBC@SteelEye.com>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3E9B00F6.6C46EBBC@SteelEye.com> from Paul Clements at "Apr 14,
 2003 02:41:58 pm"
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"A month of sundays ago Paul Clements wrote:"
> coding (the design is complete) on some stuff for md/raid1. I'm hoping
> to use your code as a starting point. On top of that, I'll be adding:
> 
> * disk storage for the bitmap

Sounds good.

Coincidently I just had to add an ondisk hashmap for ENBD (another project)
in order to cache request IDs for transport protocols that don't handle
repeats and retries on their own. I used a zone allocator to dispense
items of memory.

You have to be careful never to leave the map in an incoherent state
(even if somebody pulls the plug). That's much easier with a bitmap!

> * changing bits in the bitmaps to 16-bit counters (so that a bit won't
> be cleared prematurely when there are other outstanding I/Os to a block,
> which could result in data loss on the backup, if a failure coincides)

The current bitmap implementation already has 16-bit counters for each 
"page" (4096 bytes, i.e. mapping 32K ondisk blocks), to which it falls
back to in case it can't get the bitmap page itself. Actually, it
has one 16bit counter for every 2K ondisk blocks (256B of bitmap)

That was the most extra capital cost I was willing to invest at startup.
It's about one one-hundredth of the maximum size of the bitmap,
invested in counters that are "just in case".

So the bitmap can always be relied on to be accurate in lumps of 2MB or
so, even when there is no memory.

> * allowing the bitmap to be rescaled -- i.e., changing the amount of
> data that each bit represents

I really don't agree with that :-).  But maybe it can be done!  It's
just I personally see no way anyone can count in anything except 1K
blocks with the current raid code the way it is.

Originally I wrote the patch with more generality, but realized that the
generality could never be made use of - there are too many assumptions
in the extant raid code that one block = 1KB.

> * modifying the code so that it can be more easily leveraged by the
> other raid drivers, as Neil has indicated that that would be better

It is my intention also - I don't know of anything that stops it being
extended. I'll have a look at raid5 if you like.

> Some comments below on your newest additions...

Ta.


> >  1) in make_request:
> >     duplicating the bh->b_data from the original request into a local
> >     buffer obtained via kmalloc (if kmalloc fails, don't set the flag
> >     in the rh1_bh for async writes). 
> 
> You might want a pool of these...otherwise, under memory pressure, the
> whole thing degrades to synchronous mode...which may be OK for some
> applications, but probably not all...

Yes. My intention is only to do testing at the moment. I don't see
anything wrong with degrading to sync mode, since I actually don't
believe there is any advantage to async writes in normal use :-).

> >  2) in the mirrored bh's end_request:
> >     if we're the first mbh and async flag is set, ack the original bh.
> 
> Actually, I think you want to make sure, in the async case, that the
> write to the _primary_ disk completes, as opposed to just the first
> write...I think you could get the I/O completing out of order, right?

Hmm .. that's a point. It's not a question of out of order, so much as
we want to give the maximum chance of getting one successful write and
reporting success. This way we may be unlucky and hit a device that has
just failed, and report failure to the user, when we should have gone on
to try another device and report success back when we write to it.
It's just a case of adding "&& uptodate" to the below conditional
in raid1_end_bh_io (the end_req for a mirrored i/o)...


        /* if nobody has done the final end_io yet, do it now */
        if (!test_and_set_bit(R1BH_AsyncPhase, &r1_bh->state)) {

                PRINTK(KERN_DEBUG "raid1: sync end i/o on sectors %lu-%lu\n",
                        bh->b_rsector, bh->b_rsector + (bh->b_size >> 9) - 1);

                io_request_done(bh->b_rsector, conf,
                        test_bit(R1BH_SyncPhase, &r1_bh->state));
                bh->b_end_io(bh, uptodate);
        }

Should I add "&& uptodate" to the condition? I'm inclined to!


I don't see that there's any particular attempt to enforce write order
in raid.  Correct me if I'm wrong!  I think that requests are submitted
asynchronously to the various devices, and we just wait for the i/o to
complete (in sync mode, for all writes to complete). That can in
principle lead to arbitrary reordering all by itself.

Adding something to preserve write order might be sensible.


> > Doubts: do I have to point mbh->b_page at something new too? There are
> > occasional tests scattered in the code (on read, as far as I can see)
> > to make sure it corresponds correctly to the b_data field.
> 
> I don't believe this is necessary, since you already have logic to make
> sure that the page gets freed after the last I/O is complete.

OK - it's not my logic, I believe, but rather whatever naturally
happens in the existing raid and generic block device code. This
needs study, but the memory management in the raid code is not
completely transparant.

Peter
