From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH md 3 of 4] Delete unplug timer before shutting down md array.
Date: Mon, 8 Nov 2004 12:23:03 +0100
Message-ID: <20041108112302.GJ29120@suse.de>
References: <20041102143440.12019.patches@notabene> <E1COpUP-000392-Hw@notabene.cse.unsw.edu.au> <20041103150315.47a7982e.akpm@osdl.org> <20041104092107.GE14993@suse.de> <20041105085250.GF16649@suse.de> <16782.45573.167835.261291@cse.unsw.edu.au> <20041107154223.0900c37f.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20041107154223.0900c37f.akpm@osdl.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Nov 07 2004, Andrew Morton wrote:
> Neil Brown <neilb@cse.unsw.edu.au> wrote:
> >
> > On Friday November 5, axboe@suse.de wrote:
> > > On Thu, Nov 04 2004, Jens Axboe wrote:
> > > > On Wed, Nov 03 2004, Andrew Morton wrote:
> > > > > NeilBrown <neilb@cse.unsw.edu.au> wrote:
> > > > > >
> > > > > > As the unplug timer can potentially fire at any time, and
> > > > > > and it access data that is released by the md ->stop function,
> > > > > > we need to del_timer_sync before releasing that data.
> > > > > 
> > > > > I don't think I saw an update to this patch so I just knocked up the below
> > > > > simple conversion.  If anyone can think up a nice description of what
> > > > > blk_sync_queue() should do, it would be appreciated ;)
> > > > 
> > > > I don't see much merrit in this patch, you have to prevent new requests
> > > > from setting it off again. Basically, from my understanding, Neil needs
> > > > a way to atomically kill the timer and the unplug function. Correct?
> > > 
> > > Actually, with the online io scheduler switching we have a way to do
> > > this already:
> > > 
> > > 	blk_wait_queue_drained(q, 1);
> > > 	blk_sync_queue(q);
> > > 
> > 
> > I couldn't find blk_sync_queue in 2.6.10-rc1-mm2 ....
> 
> I added it in -mm3 to replace all the open-coded del_timer_sync()s.
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.10-rc1/2.6.10-rc1-mm3/broken-out/md-delete-unplug-timer-before-shutting-down-md-array-cleanup.patch

I seem to be missing Neils reply, this is the first I see of it.
Strange.

> > > 
> > > Would this work for you, Neil?
> > 
> > I need it to do:
> > 	del_timer_sync(&q->unplug_timer);
> > 	kblockd_flush();

blk_sync_queue() should do both. I'm unsure of whether we should wrap
blk_wait_queue_drained() and that into a seperate helper. There needs to
be an unfreeze as well, of course. Perhaps blk_freeze_queue() and
blk_unfreeze_queue()?

-- 
Jens Axboe

