From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: Re: raid5 write performance
Date: Thu, 19 Apr 2007 11:28:48 +0300
Message-ID: <5d96567b0704190128q17b09dc9ld7c95a57a1edfb9f@mail.gmail.com>
References: <5d96567b0607020702p25d66490i79445bac606e5210@mail.gmail.com>
	 <17576.18978.563672.656847@cse.unsw.edu.au>
	 <5d96567b0608130619w60d8d883q4ffbfefcf650ee82@mail.gmail.com>
	 <17650.29175.778076.964022@cse.unsw.edu.au>
	 <5d96567b0703301444j9b416c2nbc5ce27487eef5bc@mail.gmail.com>
	 <17950.50209.580439.607958@notabene.brown>
	 <5d96567b0704161329n5c3ca008p56df00baaa16eacb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5d96567b0704161329n5c3ca008p56df00baaa16eacb@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4/16/07, Raz Ben-Jehuda(caro) <raziebe@gmail.com> wrote:
> On 4/13/07, Neil Brown <neilb@suse.de> wrote:
> > On Saturday March 31, raziebe@gmail.com wrote:
> > >
> > > 4.
> > > I am going to work on this with other configurations, such as raid5's
> > > with more disks and raid50.  I will be happy to hear your opinion on
> > > this matter. what puzzles me is why deadline must be so long as 10 ms?
> > >  the less deadline the more reads I am getting.
> >
> > I've finally had a bit of a look at this.
> >
> > The extra reads are being caused because for the 3msec unplug
> > timeout. Once you plug a queue it will automatically get unplugged 3
> > msec later.  When this happens, any stripes that are on the pending
> > list (waiting to see if more blocks will be written to them) get
> > processed and some pre-reading happens.
> >
> > If you remove the 3msec timeout (I changed it to 300msec) in
> > block/ll_rw_blk.c, the reads go away.  However that isn't a good
> > solution.
> >
> > Your patch effectively ensures that a stripe gets to last at least N
> > msec before being unplugged and pre-reading starts.
> > Why does it need to be 10 msec?  Let's see.
> >
> > When you start writing, you will quickly fill up the stripe cache and
> > then have to wait for stripes to be fully written and become free
> > before you can start attaching more write requests.
> > You could have to wait for a full chunk-wide stripe to be written
> > before another chunk of stripes can proceed.  The first blocks of the
> > second stripe could stay in the stripe cache for the time it takes to
> > write out a stripe.
> >
> > With a 1024K chunk size and 30Meg/second write speed it will take 1/30
> > of a second to write out a chunk-wide stripe, or about 33msec.  So I'm
> > surprised you get by with a deadline of 'only' 10msec.  Maybe there is
> > some over-lapping of chunks that I wasn't taking into account (I did
> > oversimplify the model a bit).
> >
> > So, what is the right heuristic to use to determine when we should
> > start write-processing on an incomplete stripe?  Obviously '3msec' is
> > bad.
> >
> > It seems we don't want to start processing incomplete stripes while
> > there are full stripes being written, but we also don't want to hold
> > up incomplete stripes forever if some other thread is successfully
> > writing complete stripes.
> >
> > So maybe something like this:
> >  - We keep a (cyclic) counter of the number of stripes on which we
> >    have started write, and the number which have completed.
> >  - every time we add a write request to a stripe, we set the deadline
> >    to 3msec in the future, and we record in the stripe the current
> >    value of the number that have started write.
> >  - We process a stripe requiring preread when both the deadline
> >    has expired, and the count of completed writes reaches the recorded
> >    count of commenced writes.
> >
> > Does that make sense?  Would you like to try it?
> >
> > NeilBrown
> >

Neil Hello
I have been doing some thinking. I feel we should take a different path here.
In my tests  I actually accumulate the user's buffers and when ready I submit
them, an elevator like algorithm.

The main problem is the amount of IO's the stripe cache can hold which is
too small. My suggestion is to add an elevator of bios before moving them to the
stripe cache, trying to postpone as much as needed allocation of a new stripe.
This way we will be able to move as much as IOs to the "raid logic"
without congesting
it and still filling stripes if possible.

Psuedo code;

 make_request()
...
   if IO direction is WRITE and IO not in stripe cache
     add IO to raid elevator
..

raid5d()
  ...
  Is there a set of IOs in raid elevator such that they make a full stripe
    move IOs to raid handling
  while oldest IO in raid elevator is deadlined( 3ms ? )
      move IO to raid handling
 ....

Does it make any sense ?

thank you
-- 
Raz
