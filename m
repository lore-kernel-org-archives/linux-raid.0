From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: raid1 bitmap code [Was: Re: Questions answered by Neil Brown]
Date: Thu, 27 Feb 2003 11:35:09 +0100 (MET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200302271035.h1RAZ9A26165@oboe.it.uc3m.es>
References: <3E5DA32C.F9AAFD1A@SteelEye.com>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3E5DA32C.F9AAFD1A@SteelEye.com> from Paul Clements at "Feb 27,
 2003 00:33:33 am"
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, ptb@it.uc3m.es, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Paul Clements wrote:"
> > 2/ You cannot allocate the bitmap on demand.
> 
> Hmm...that's a very good point. I had not really thought about that, but
> you're right. Maybe there are some advantages to having a simple, flat,
> pre-allocated bitmap...although, I do really like Peter's two-level
> on-demand allocation scheme. Maybe we could do partial pre-allocation,
> using the pre-allocated pages when we're under pressure and kmalloc

I am sure that as the code evolves, schemes like this will be added to
it. But are we really sure that it's worth trying to beat the kernels
memory management? All the calls here are for 4KB. Sure, we can maybe
always maintain a 5% reserve on standby (if the reserve drops to 1%
then ask for some more), and also maintain a free list (for first
recourse) that is swept every so often.

But the kernel already does that kind of management and balancing.  What
right do we have to say we're better than the rest of the kernel?  I can
up the priority with which we ask for memory, but it seems to me that in
times of memory pressure we /ought to fail/, but fail gracefully.

Currently we degrade to 4MB resolution, instead of 1KB. That's all.

> fails, and doing on-demand allocation the rest of the time? Another
> idea, expanding on what Peter has already done with marking the pointer
> with an "address" of 1 if the kmalloc fails (this means that the bitmap
> degrades from 1bit/1k to 1bit/4MB, which is not a terrible thing, all in
> all). What if we were clever and used more than just one bit when the
> allocation fails, so that the ratio could be kept more reasonable (I'm
> thinking the 1bit/4MB is OK now, but with a default bit/block ratio

This is OK as an idea. The sign bit can be used as a marker. Or perhaps
the top two bits, since I think memory normally starts at an adress of
0xc.... Can anyone confirm that? I'm thinking that if the top two bits
of the address are low we can take it that this is not an address, but
a small bitmap in itself.

Hmm ... no, thats' silly. We need a number of bits that is a power of
2. OK, so the top 16 bits being zero lets us see that the bottom 16
bits are a bitmap.

> that's much higher, it might get out of control)...maybe something
> similar to the IS_ERR and ERR_PTR macros that are elsewhere in the
> kernel? Those use 1000 values (I think...) that are known not to be
> valid pointer values as error values instead.

If 16 bits are available instead of 4096 * 8 = 32K, then we get
resolution of 4M/16 = 256K per bit instead of 1K per bit (or instead of
4M per bit). This is more reasonable. I'll look at the coding effort.

> > 3/ Internally, you need to store a counter for each 'chunk' (need a
> mechanism for tracking multiple pending writes to the same 'chunk'. One

I really don't see the logic of this argument, so I'll risk your wrath
by saying so in public.  We cannot account for how many bits are really
dirty in this chunk.  If you mark the same spot twice you will count 2
by your logic when only 1 should have been added to the count.  Nor can
you really clear a bit, because by the same token, if we try and clear a
bit that is already notionally cleared, you will want to subtract 1 from
the count, when 0 should really be subtracted.

In other words, you are making assumptions on the mode of use of the
bitmap interface that are difficult to express ..  I think you need to
count in "sessions", and promise not to mark the same place twice per
session, and never to clear anything that you have not already marked in
the session, and to not close the session until you have cleared everthing
etc.  ..  but in any case these assumptions render the use of a bitmap
as a programming abstraction inappropriate.  It's not really good for
maintenance.

> way to do this is to keep a counter (say 16 or 32 bits) on each chunk,
> rather than just a single bit. Another alternative might be to queue the
> writes (using a hash on the 'chunk' number, for quick insertion and
> deletion). This would tell us how many writes are pending for a given
> 'chunk', and allow us to clear the bit at the appropriate time (once the
> last pending write for the 'chunk' had finished). This could be expanded
> later to queueing entire requests (including data) so we could do full
> transaction logging, so that a short network outage (how short depends
> on how much $$ (sorry Peter, pesetas^Weuros) you want to lay out for RAM

I really don't grok the idea here. I am hung up by the fundamental
impossibility of accounting correctly in the situation where writes
to different places on disk will land on the same bit of the bitmap.
That breaks the logic so thoroughly for me that I cannot proceed from
there!

Maybe I need to receive more $$!

> :)) could be recovered from quickly, by just replaying the already
> queued data.

Well, if you really want to store the requests instead of merely where
those requests are aimed at, that's another story. But it still won't
work. State information that's needed for the accounting will vanish
when those requests complete. The bitmap cannot have worse granularity
than writes can have.

Peter
