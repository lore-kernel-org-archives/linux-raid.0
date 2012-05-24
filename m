From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 1/4] raid1: directly dispatch write request if no bitmap
Date: Thu, 24 May 2012 10:54:25 +0800
Message-ID: <20120524025425.GA1190@kernel.org>
References: <20120523072619.670179001@kernel.org>
 <20120523072829.967587288@kernel.org>
 <20120524122112.05b4d6e3@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120524122112.05b4d6e3@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, shli@fusionio.com
List-Id: linux-raid.ids

On Thu, May 24, 2012 at 12:21:12PM +1000, NeilBrown wrote:
> On Wed, 23 May 2012 15:26:20 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> > In raid1, all write requests are dispatched in raid1d thread. In fast storage,
> > the raid1d thread is a bottleneck, because it dispatches request too slow. Also
> > raid1d thread migrates freely, which makes request completion cpu not match
> > with submission cpu even driver/block layer has such capability. This will
> > cause bad cache issue.
> > 
> > If no bitmap, there is no point to queue bio to a thread and dispatch it in the
> > thread. Directly dispatching bio doesn't impact correctness and removes above
> > bottleneck.
> > 
> > Multiple threads dispatch requests could potentially reduce request merge and
> > increase lock contention. For slow stroage, we just worry about request merge.
> > Caller of .make_request should already have correct block plug set, which will
> > take care of request merge and locking just like accessing raw device, so we
> > don't need worry about this too much.
> > 
> > In a 4k randwrite test with a 2 disks setup, below patch can provide 20% ~ 50%
> > performance improvements depending on numa binding.
> > 
> > Signed-off-by: Shaohua Li <shli@fusionio.com>
> > ---
> >  drivers/md/raid1.c |   11 +++++++----
> >  1 file changed, 7 insertions(+), 4 deletions(-)
> > 
> > Index: linux/drivers/md/raid1.c
> > ===================================================================
> > --- linux.orig/drivers/md/raid1.c	2012-05-22 13:50:26.989820654 +0800
> > +++ linux/drivers/md/raid1.c	2012-05-22 13:56:46.117054559 +0800
> > @@ -1187,10 +1187,13 @@ read_again:
> >  		mbio->bi_private = r1_bio;
> >  
> >  		atomic_inc(&r1_bio->remaining);
> > -		spin_lock_irqsave(&conf->device_lock, flags);
> > -		bio_list_add(&conf->pending_bio_list, mbio);
> > -		conf->pending_count++;
> > -		spin_unlock_irqrestore(&conf->device_lock, flags);
> > +		if (bitmap) {
> > +			spin_lock_irqsave(&conf->device_lock, flags);
> > +			bio_list_add(&conf->pending_bio_list, mbio);
> > +			conf->pending_count++;
> > +			spin_unlock_irqrestore(&conf->device_lock, flags);
> > +		} else
> > +			generic_make_request(mbio);
> >  	}
> >  	/* Mustn't call r1_bio_write_done before this next test,
> >  	 * as it could result in the bio being freed.
> 
> This looks like it should be 'obviously correct' but unfortunately it isn't.
> 
> If this raid1 is beneath a dm device (e.g. LVM), then generic_make_request
> will queue the request internally and not actually start it.
> In particular this means that the cloned bio has no chance of being released
> before the next clone_bio call which is made on the next time around the loop.
> 
> This can lead to a deadlock as the clone_bio() might be waiting for that
> first cloned bio to be released (if memory is really tight).
> 
> i.e. when allocating multiple bios from a mempool, we need to arrange for
> them to be submitted by a separate thread.

If there isn't block plug, generic_make_request will dispatch the request
directly. If there is, when clone_bio() waits for memory, it will
sleep/schedule, which will trigger block unplug and dispatch the first bio, so
no deadlock to me. Am I misunderstanding you?

Thanks,
Shaohua
