From: Shaohua Li <shli@fb.com>
Subject: Re: [RFC] using mempools for raid5-cache
Date: Thu, 10 Dec 2015 15:40:57 -0800
Message-ID: <20151210234047.GA3596673@devbig084.prn1.facebook.com>
References: <1449072638-15409-1-git-send-email-hch@lst.de>
 <876108qwz5.fsf@notabene.neil.brown.name>
 <20151209012812.GA2403138@devbig084.prn1.facebook.com>
 <87vb88p1tm.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87vb88p1tm.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Dec 09, 2015 at 05:34:45PM +1100, NeilBrown wrote:
> On Wed, Dec 09 2015, Shaohua Li wrote:
> 
> > On Wed, Dec 09, 2015 at 11:36:30AM +1100, NeilBrown wrote:
> >> On Thu, Dec 03 2015, Christoph Hellwig wrote:
> >> 
> >> > Currently the raid5-cache code is heavily relying on GFP_NOFAIL allocations.
> >> >
> >> > I've looked into replacing these with mempools and biosets, and for the
> >> > bio and the meta_page that's pretty trivial as they have short life times
> >> > and do make guaranteed progress.  I'm massively struggling with the iounit
> >> > allocation, though.  These can live on for a long time over log I/O, cache
> >> > flushing and last but not least RAID I/O, and every attempt at something
> >> > mempool-like results in reproducible deadlocks.  I wonder if we need to
> >> > figure out some more efficient data structure to communicate the completion
> >> > status that doesn't rely on these fairly long living allocations from
> >> > the I/O path.
> >> 
> >> Presumably the root cause of these deadlocks is that the raid5d thread
> >> has called
> >>    handle_stripe -> ops_run_io ->r5l_write_stripe -> r5l_log_stripe
> >>       -> r5l_get_meta -> r5l_new_meta
> >> 
> >> and r5l_new_meta is blocked on memory allocation, which won't complete
> >> until some raid5 stripes get written out, which requires raid5d to do
> >> something more useful than sitting and waiting.
> >> 
> >> I suspect a good direction towards a solution would be to allow the
> >> memory allocation to fail, to cleanly propagate that failure indication
> >> up through r5l_log_stripe to r5l_write_stripe which falls back to adding
> >> the stripe_head to ->no_space_stripes.
> >> 
> >> Then we only release stripes from no_space_stripes when a memory
> >> allocation might succeed.
> >> 
> >> There are lots of missing details, and possibly we would need a separate
> >> list rather than re-using no_space_stripes.
> >> But the key idea is that raid5d should never block (except beneath
> >> submit_bio on some other device) and when it cannot make progress
> >> without blocking, it should queue the stripe_head for later handling.
> >> 
> >> Does that make sense?
> >
> > It does remove the scary __GFP_NOFAIL, but the approach is essentially
> > idential to a 'retry after allocation failure'. Why not just let the mm
> > (with __GFP_NOFAIL) to do the retry then?
> >
> 
> Because deadlocks.
> 
> If raid5d is waiting for the mm to allocated memory, then it cannot
> retire write requests which could free up memory.

Ok, I missed the deadlock issue. Looks raid5d can't sleep waitting for
memory. That means the mempool for metadata page/bio doesn't work too,
as raid5d might block and not dispatch previous IO. Your proposal looks
reasonable.

Would keeping NOFAIL and having a separate thread got r5l_log_stripe
work too?

Thanks,
Shaohua
