From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: [PATCH md 0 of 4] Introduction
Date: Tue, 8 Mar 2005 20:05:13 +0100
Message-ID: <9k91g2-vss.ln1@news.it.uc3m.es>
References: <20050308165021.3745.patches@notabene> <6jj0g2-c27.ln1@news.it.uc3m.es> <422DDA99.60608@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Paul Clements <paul.clements@steeleye.com> wrote:
> Peter T. Breuer wrote:
> > Neil - can you describe for me (us all?) what is meant by
> > intent-logging here.
> 
> Since I wrote a lot of the code, I guess I'll try...

Hi, Paul. Thanks.

> > Well, I can guess - I suppose the driver marks the bitmap before a write
> > (or group of writes) and unmarks it when they have completed
> > successfully.  Is that it?
> 
> Yes. It marks the bitmap before writing (actually queues up the bitmap 
> and normal writes in bunches for the sake of performance). The code is 
> actually (loosely) based on your original bitmap (fr1) code.

Yeah, I can see the traces.  I'm a little tired right now, but some
aspects of this idea vaguely worry me.  I'll see if I manage to
articulate those worries here despite my state. And you can dispell
them :).

Let me first of all guess at the intervals involved. I assume you will
write the marked parts of the bitmap to disk every 1/100th of a second or
so?  (I'd probably opt for 1/10th of a second or even every second just
to make sure it's not noticable on bandwidth and to heck with the
safety until we learn better what the tradeoffs are).  Or perhaps once
every hundred trasactions in busy times.

Now, there are races here.  You must mark the bitmap in memory before
every write, and unmark it after every complete write.  That is an
ordering constraint.  There is a race, however, to record the bitmap
state to disk.  Without any rendezvous or handshake or other
synchronization, one would simply be snapshotting the in-memory bitmap
to disk every so often, and the  on-disk bitmap would not always
accurately reflect the current state of completed transactions to the
mirror. The question is whether it shows an overly-pessimistic picture,
an overly-optimistic picture, or neither one nor the other.

I would naively imagine straight off that it cannot in general be
(appropriately) pessimistic because it does not know what writes will
occur in the next 1/100th second in order to be able to mark those on
the disk bitmap before they happen.  In the next section of your answer,
however, you say this is what happens, and therefore I deduce that

   a) 1/100th second's worth of writes to the mirror are first queued
   b) the in-memory bitmap is marked for these (if it exists as separate)
   c) the dirty parts of that bitmap are written to disk(s)
   d) the queued writes are carried out on the mirror
   e) the in-memory bitmap is unmarked for these
   f) the newly cleaned parts of that bitmap are written to disk. 

You may even have some sort of direct mapping between the on-disk
bitmap and the memory image, which could be quite effective, but
may run into problems with the address range available (bitmap must be
less than 2GB, no?), unless it maps only the necessary parts of the
bitmap at a time.  Well, if the kernel can manage that mapping window on
its own, it would be useful and probably what you have done.

But I digress. My immediate problem is that writes must be queued
first. I thought md traditionally did not queue requests, but instead
used its own make_request substitute to dispatch incoming requests as
they arrived.

Have you remodelled the md/raid1 make_request() fn?

And if so, do you also aggregate them? And what steps are taken to
preserve write ordering constraints (do some overlying file systems
still require these)?

> > If so, how does it manage to mark what it is _going_ to do (without
> > psychic powers) on the disk bitmap?  
> 
> That's actually fairly easy. The pages for the bitmap are locked in 
> memory,

That limits the size to about 2GB - oh, but perhaps you are doing as I
did and release bitmap pages when they are not dirty. Yes, you must.

>  so you just dirty the bits you want (which doesn't actually 
> incur any I/O) and then when you're about to perform the normal writes, 
> you flush the dirty bitmap pages to disk.

Hmm. I don't know how one can select pages to flush, but clearly one
can!  You maintain a list of dirtied pages, clearly. This list cannot be
larger than the list of outstanding requests. If you use the generic
kernel mechanisms, that will be 1000 or so, max.

> Once the writes are complete, a thread (we have the raid1d thread doing 
> this) comes back along and flushes the (now clean) bitmap pages back to 
> disk.

OK ..  there is a potential race here too, however, ...

> If the pages get dirty again in the meantime (because of more 
> I/O), we just leave them dirty and don't touch the disk.

Hmm. This appears to me to be an optimization. OK.

> > Then resync would only deal with the marked blocks.
> 
> Right. It clears the bitmap once things are back in sync.

Well, OK. Thinking it through as I write I see fewer problems. Thank
you for the explanation, and well done.

I have been meaning to merge the patches and see what comes out. I
presume you left out the mechanisms I included to allow a mirror
component to aggressively notify the array when it feels sick, and when
it feels better again. That required the array to be able to notify the
mirror components that they have been included in an array, and lodge
a callback hotline with  them.

Thanks again.

Peter

