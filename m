From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: Questions answered by Neil Brown
Date: Wed, 26 Feb 2003 18:26:45 +0100 (MET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200302261726.h1QHQjS07452@oboe.it.uc3m.es>
References: <3E5CEE4F.363A9FB6@SteelEye.com>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3E5CEE4F.363A9FB6@SteelEye.com> from Paul Clements at "Feb 26,
 2003 11:41:51 am"
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: ptb@it.uc3m.es, Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Paul Clements wrote:"
> Right, but note that when raid1 is setting those 1s, it's in the bh's
> that it's sending down to lower level devices, not in the bh's that came
> in from above...a subtle distinction. So these 1s would be consumed only

Too subtle for me.  

> by raid1's end_io routines. Any changes we make to b_this_page in the

Umm ... err, I'm not at all sure .. you mean that their b_end_io
is something we implanted? Yes, I'll go along with that. OK - here's
the story ..

   the bh's that we set the this_page field to 1 on come from
   raid1_alloc_bh.  Normally these come from a pool of preallocated bhs
   that stick around in the driver.
   
   The b_end_io that we give them is the raid1_end_request function, which
   is the common or garden endio that does /nothing/. 

   Only on the last of the bh's do we run a raid1_end_bh_io, which
   calls raid1_free_r1bh on the /master/,
   
   surprise, raid1_free_r1bh does nothing except call raid1_free_bh on the
   list of all the associated bh's that's been sitting chained onto the
   mirror_bh_list field of the master,
   
   and then raid1_free_bh runs through the list and calls kmem_cahe_free on
   each of them.

I see the this_page field used nowhere in this. I can't follow what the
raid1_alloc_bh thing does, so I have an info leak here. I don't know
how the preallocated bh cache grows or shrinks under pressure.

Anyway, if we run raid1_end_bh_io early, we will free up bh's and they
may get reused before we have a chance to complete them. So that's
a problem.

Uh - we'll have to stop raid1_end_bh_io calling raid1_free_bh and
instead get each individual bh to unchain itself from the linked
list and free itself. Under some lock, of course. 

Where in all this do we ack the original end_io on the md array? I
don't see it!

> "master_bh" will have to be handled correctly by the end_io of the upper
> level code (stuff in buffer.c).

> Probably because the timing is so close...if we were to delay the
> completion of I/O to one of the devices by several seconds, say, I
> believe we'd see some really bad things happen. Another thing that
> probably has to coincide with the I/O delays is memory pressure,
> otherwise I think the system will just end up keeping the buffers cached
> forever (OK, a really long time...) and nothing bad will happen. 

I don't know how many bh's there are in the preallocated pool.  If there
were more than 128 it's fairly certain that they could satisfy all
requests outstanding at any one time. Especially if freed requests
go to the back of the free list (do they?). 

> One thought I had for a test (when I get to the point of really
> rigorously testing this stuff :)) is to set up an nbd-client/server pair
> and insert a sleep into the nbd-server so that completion of I/O is
> _always_ delayed by some period...(this will also help in performance

Possibly. My enbd will timeout.

> testing, to see how much benefit we get from doing async writes with
> high latency).
> 
> BTW, I'm working on the code to duplicate the bh (and its memory buffer)
> right now. It's basically coded, but not tested. I've based it off your
> 2.5 code. I'm also working on a simple queueing mechanism (to queue
> write requests to backup devices). This will allow us to adjust the bit
> to block ratio of the bitmap (intent log) to save disk space and memory.

Don't worry about that - that's not necessary, I think.  The bitmap is
already lazy on creating pages for itself.  But yes, it needs to
maintain a count of dirty bits per bitmap page, and when the count drops
to zero it needs to free the page.  I can do that if you like?

> This mechanism will also be needed if we want to increase the degree of
> asynchronicity of the writes (we could just queue all writes and deal
> with them later, perhaps in batches).

Yes.

Peter
