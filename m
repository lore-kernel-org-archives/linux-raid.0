From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Tue, 22 Mar 2005 23:35:02 +0100
Message-ID: <m5j6h2-mbo.ln1@news.it.uc3m.es>
References: <16950.5692.594941.130741@cse.unsw.edu.au> <20050318103326.GA18819@marowsky-bree.de> <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de> <7e6rg2-pj1.ln1@news.it.uc3m.es> <423B09EF.8070708@steeleye.com> <23krg2-4rr.ln1@news.it.uc3m.es> <423B2F7C.3030907@steeleye.com> <qehtg2-6c1.ln1@news.it.uc3m.es> <423EF12A.4030207@steeleye.com> <20050321185606.GA27541@percy.comedia.it> <423F2780.5000601@steeleye.com> <qbo3h2-kjo.ln1@news.it.uc3m.es> <423F3A69.5090502@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Paul Clements <paul.clements@steeleye.com> wrote:
>      system A
>      [raid1]
>      /     \
> [disk]    [nbd] --> system B
> 
> 2) you're writing, say, block 10 to the raid1 when A crashes (block 10 
> is dirty in the bitmap, and you don't know whether it got written to the 
> disk on A or B, neither, or both)

Let me offer an example based on this scenario.  Block 10 is sent to
both, and B's bitmap is dirtied for it, but the data itself never
arrives.  At the same time block 10 is sent to A, and the bitmap is
dirtied for it, the data sent, and (miraculously) the bitmap on A is
cleared for the received data (I don't now why or how - nobody has yet
specified the algorithm with enough precision for me to say).

At this point B's bitmap is dirty for block 10, and A's is not. A has
received the data for block 10, and B has not.

> 3) something (i.e., your cluster framework) notices that A is gone and 
> brings up a new raid1, with an empty bitmap, on system B:

Now, this looks wrong, because to sync A from B we will later need to
copy block 10 from B to A in order to "undo" the extra write already
done on A, and A's bitmap is not marked dirty for block 10, only B's is,
so we cannot zero B's bitmap because that would lose the information
about block 10.

 --

I've been thinking about this in more general terms, and it seems to me
that the algorithms offered (and I say I have not seen enough
detail to be sure) may be in general "insufficiently pessimistic".

That is, they may clear the bitmap too soon (as in the thought
experiment above).  Or they may not dirty the bitmaps soon enough.

I believe that you are aiming for algorithms in which the _combined_
bitmaps are "sufficiently pessimistic", but the individual bitmaps
are not necesarily so.

But it appears to me as though it may not be much trouble to ensure that
_each_ bitmap is sufficiently pessimistic on its own with respect to
clearing.  Just clear _each_ bitmap only when _both_ writes have been
done.

 --

Can this plan fail to be pessimistic enough with respect to dirtying
the bitmaps in the first place?

What if block 10 is sent to A, which is to say the bitmap on A is
dirtied, and the data sent, and received on A. Can B _not_ have its
bitmap dirtied for block 10?

Well, yes, if A dies before sending out the bitmap dirty to B, but after
sending out the bitmap dirty AND the data to A.  That's normally not
possible. We normally surely send out all bitmap dirties before sending
out any data. But can we wait for these to complete before starting on
the data writes? If B times out, we will have to go ahead and dirty A's
bitmap on its own and thereafter always dirty and never clear it.

So this corresponds to A continuing to work after losing contact with B.

Now, if A dies after that, and for some reason we start using B, then B
will need eventually to have its block 10 sent to A when we resync A
from B.

But we never should have switched to B in the first place! B was
expelled from the array.  But A maybe died before saying so to anyone.

Well, plainly A should not have gone on to write anything in the array
after expelling B until it was able to write in its (A's) superblock
that B had been expelled.

Then, later, on recovery with a sync from B to A (even though it is the
wrong direction), A will either say in its sb that B has not been
expelled AND contain no extra writes t be undone from B, or A will say
that B has been expelled, and its bitmap will say which writes have
been done that were not done on B, and we can happily decide to sync
from B, or sync from A.

So it looks like there are indeed several admin foul-ups and crossed
wires which could give us reason to sync in the rong direction, and
then we will want to know what the recipient has in its bitmap. But
we will be able to see that that is the situuation.

In all other cases, it is sufficient to know just the bitmap on the
master.

The particular dubious situation outlined here is

1) A loses contact with B and continues working without B in the array,
  so B is out of date.

2) A dies, and B is recovered, becoming used as the master.

3) When A is recovered, we choose to sync A from B, not B from A.

In that case we need to look at bitmaps both sides. But note that one
bitmap per array (on the "local" side) would suffice in this case. The
array node location shifts during the process outlined, givig two
bitmaps to make use of eventually.


Peter

