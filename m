From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: raid1 bitmap code [Was: Re: Questions answered by Neil Brown]
Date: Thu, 27 Feb 2003 00:33:33 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E5DA32C.F9AAFD1A@SteelEye.com>
References: <3E5D078C.72A523AE@SteelEye.com>
			<200302261915.h1QJFfS17808@oboe.it.uc3m.es> <15965.15322.459068.818409@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: ptb@it.uc3m.es, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil, 

You've made some really good points and suggestions...thanks...


> 1/ You don't want or need very fine granularity.  The value of this is
>    to speed up resync time.  Currently it is limited by drive
>    bandwidth.  If you have lots of little updates due to fine
>    granularity, you will be limited by seek time.

One more reason why an adjustable bit to block ratio would be nice :)
...
 

> 2/ You cannot allocate the bitmap on demand.

Hmm...that's a very good point. I had not really thought about that, but
you're right. Maybe there are some advantages to having a simple, flat,
pre-allocated bitmap...although, I do really like Peter's two-level
on-demand allocation scheme. Maybe we could do partial pre-allocation,
using the pre-allocated pages when we're under pressure and kmalloc
fails, and doing on-demand allocation the rest of the time? Another
idea, expanding on what Peter has already done with marking the pointer
with an "address" of 1 if the kmalloc fails (this means that the bitmap
degrades from 1bit/1k to 1bit/4MB, which is not a terrible thing, all in
all). What if we were clever and used more than just one bit when the
allocation fails, so that the ratio could be kept more reasonable (I'm
thinking the 1bit/4MB is OK now, but with a default bit/block ratio
that's much higher, it might get out of control)...maybe something
similar to the IS_ERR and ERR_PTR macros that are elsewhere in the
kernel? Those use 1000 values (I think...) that are known not to be
valid pointer values as error values instead.

 
> 3/ Internally, you need to store a counter for each 'chunk' (need a

Yes, in order to use a bit/block ratio other than 1 bit/1k, we need some
mechanism for tracking multiple pending writes to the same 'chunk'. One
way to do this is to keep a counter (say 16 or 32 bits) on each chunk,
rather than just a single bit. Another alternative might be to queue the
writes (using a hash on the 'chunk' number, for quick insertion and
deletion). This would tell us how many writes are pending for a given
'chunk', and allow us to clear the bit at the appropriate time (once the
last pending write for the 'chunk' had finished). This could be expanded
later to queueing entire requests (including data) so we could do full
transaction logging, so that a short network outage (how short depends
on how much $$ (sorry Peter, pesetas^Weuros) you want to lay out for RAM
:)) could be recovered from quickly, by just replaying the already
queued data.


> 4/ I would use device plugging to help reduce the number of times you
>    have to write the intent bitmap.

That's a good idea. I also think that with a large bit/block ratio, the
bitmap syncing will be fairly efficient, since the bitmap will
only have to be synced once per XXXk of data written.

--
Paul
