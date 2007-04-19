From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 write performance
Date: Thu, 19 Apr 2007 19:20:39 +1000
Message-ID: <17959.13415.960988.143833@notabene.brown>
References: <5d96567b0607020702p25d66490i79445bac606e5210@mail.gmail.com>
	<17576.18978.563672.656847@cse.unsw.edu.au>
	<5d96567b0608130619w60d8d883q4ffbfefcf650ee82@mail.gmail.com>
	<17650.29175.778076.964022@cse.unsw.edu.au>
	<5d96567b0703301444j9b416c2nbc5ce27487eef5bc@mail.gmail.com>
	<17950.50209.580439.607958@notabene.brown>
	<5d96567b0704161329n5c3ca008p56df00baaa16eacb@mail.gmail.com>
	<5d96567b0704190128q17b09dc9ld7c95a57a1edfb9f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Raz Ben-Jehuda(caro) on Thursday April 19
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday April 19, raziebe@gmail.com wrote:
> 
> Neil Hello
> I have been doing some thinking. I feel we should take a different path here.
> In my tests  I actually accumulate the user's buffers and when ready I submit
> them, an elevator like algorithm.
> 
> The main problem is the amount of IO's the stripe cache can hold which is
> too small. My suggestion is to add an elevator of bios before moving them to the
> stripe cache, trying to postpone as much as needed allocation of a new stripe.
> This way we will be able to move as much as IOs to the "raid logic"
> without congesting
> it and still filling stripes if possible.
> 
> Psuedo code;
> 
>  make_request()
> ...
>    if IO direction is WRITE and IO not in stripe cache
>      add IO to raid elevator
> ..
> 
> raid5d()
>   ...
>   Is there a set of IOs in raid elevator such that they make a full stripe
>     move IOs to raid handling
>   while oldest IO in raid elevator is deadlined( 3ms ? )
>       move IO to raid handling
>  ....
> 
> Does it make any sense ?

Yes.
The "Is there a set of IOs in raid elevator such that they make a full
stripe"  would be hard to calculate.

However the concept is still fine.
In make request, if we cannot get a stripe_head without blocking, just
add the request to a list.
Once the number of active stripes drops below 75% (or 50% or
whatever), raid5 reprocessed all the bios on the list, some will get
added, some might not until next time.

The fact that a single bio can require many stripe_heads adds an
awkwardness.  You would have to be able to store a partially-processed
request on the list, but we do that in retry_aligned_read, so we know
it is possible.  Possibly the same code can be used for
retry_aligned_read and for retry_delayed_write.

And we can treat writes and reads the same - if no stripe_head is
available, stick it on a queue.

Another issue to be aware of is that write-throttling in the VM
depends on the fact that each device has a limited queue.  Just
sticking everything on a list defeats thats.  So we do need to impose
some limit on the number of request in the queue.  Possibly we limit
the requests on the queue to some multiple of a full stripe.

NeilBrown
