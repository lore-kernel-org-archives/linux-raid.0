From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH md 3 of 4] Delete unplug timer before shutting down md array.
Date: Fri, 5 Nov 2004 09:52:50 +0100
Message-ID: <20041105085250.GF16649@suse.de>
References: <20041102143440.12019.patches@notabene> <E1COpUP-000392-Hw@notabene.cse.unsw.edu.au> <20041103150315.47a7982e.akpm@osdl.org> <20041104092107.GE14993@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20041104092107.GE14993@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: NeilBrown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Nov 04 2004, Jens Axboe wrote:
> On Wed, Nov 03 2004, Andrew Morton wrote:
> > NeilBrown <neilb@cse.unsw.edu.au> wrote:
> > >
> > > As the unplug timer can potentially fire at any time, and
> > > and it access data that is released by the md ->stop function,
> > > we need to del_timer_sync before releasing that data.
> > 
> > I don't think I saw an update to this patch so I just knocked up the below
> > simple conversion.  If anyone can think up a nice description of what
> > blk_sync_queue() should do, it would be appreciated ;)
> 
> I don't see much merrit in this patch, you have to prevent new requests
> from setting it off again. Basically, from my understanding, Neil needs
> a way to atomically kill the timer and the unplug function. Correct?

Actually, with the online io scheduler switching we have a way to do
this already:

	blk_wait_queue_drained(q, 1);
	blk_sync_queue(q);

Then you are sure the queue is idle, switch unplug (or
->make_request_fn) and:

	blk_finish_queue_drain(q);

We need to move the ->rl waitqueue initializers to
blk_queue_make_request() then.

Would this work for you, Neil?

-- 
Jens Axboe

