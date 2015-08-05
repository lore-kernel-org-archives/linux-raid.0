From: Shaohua Li <shli@fb.com>
Subject: Re: [PATCH 4/9] raid5: log reclaim support
Date: Wed, 5 Aug 2015 14:34:21 -0700
Message-ID: <20150805213412.GA3167799@devbig257.prn2.facebook.com>
References: <cover.1438215986.git.shli@fb.com>
 <41a6d2e74494506fcd6ffd68a5884d38dc0bfa8e.1438215986.git.shli@fb.com>
 <20150805134330.3f4269e4@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150805134330.3f4269e4@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

On Wed, Aug 05, 2015 at 01:43:30PM +1000, NeilBrown wrote:
> On Wed, 29 Jul 2015 17:38:44 -0700 Shaohua Li <shli@fb.com> wrote:
> 
> > This is the reclaim support for raid5 log. A stripe write will have
> > following steps:
> > 
> > 1. reconstruct the stripe, read data/calculate parity. ops_run_io
> > prepares to write data/parity to raid disks
> > 2. hijack ops_run_io. stripe data/parity is appending to log disk
> > 3. flush log disk cache
> > 4. ops_run_io run again and do normal operation. stripe data/parity is
> > written in raid array disks. raid core can return io to upper layer.
> > 5. flush cache of all raid array disks
> > 6. update super block
> > 7. log disk space used by the stripe can be reused
> > 
> > In practice, several stripes consist of an io_unit and we will batch
> > several io_unit in different steps, but the whole process doesn't
> > change.
> > 
> > It's possible io return just after data/parity hit log disk, but then
> > read IO will need read from log disk. For simplicity, IO return happens
> > at step 4, where read IO can directly read from raid disks.
> > 
> > Currently reclaim run every minute or out of space. Reclaim is just to
> > free log disk spaces, it doesn't impact data consistency.
> 
> Having arbitrary times lines "every minute" is a warning sign.
> "As soon as possible" and "Just it time" can both make sense easily.
> "every minute" needs more justification.
> 
> I'll probably say more when I find the code.

The idea is if we reclaim periodically, recovery could scan less log
space. It's insane recovery scans a 1T disk. As I said this is just to
free disk spaces. It's not a signal we will lose data in minute
interval. I can change the relaim to run every 1G reclaimable space for
example.

> > +	r5l_move_io_unit_list(&log->running_ios, &log->io_end_ios,
> > +			IO_UNIT_IO_END);
> > +	r5l_move_io_unit_list(&log->io_end_ios, &log->stripe_end_ios,
> > +			IO_UNIT_STRIPE_END);
> > +	r5l_compress_stripe_end_list(log);
> > +	run_stripe = !list_empty(&log->io_end_ios);
> > +	spin_unlock(&log->io_list_lock);
> > +
> > +	if (!run_stripe)
> > +		return;
> > +
> > +	blkdev_issue_flush(r5l_bdev(log), GFP_NOIO, NULL);
> > +
> > +	spin_lock(&log->io_list_lock);
> > +	list_for_each_entry(io, &log->io_end_ios, log_sibling) {
> > +		if (io->state >= IO_UNIT_STRIPE_START)
> > +			continue;
> > +		r5l_set_io_unit_state(io, IO_UNIT_STRIPE_START);
> > +
> > +		while (!list_empty(&io->stripe_list)) {
> > +			sh = list_first_entry(&io->stripe_list,
> > +				struct stripe_head, log_list);
> > +			list_del_init(&sh->log_list);
> > +			set_bit(STRIPE_HANDLE, &sh->state);
> > +			release_stripe(sh);
> 
> This code makes me a bit nervous.  handle_stripe() can potentially be
> called on any stripe at any time.
> Here you are scheduling a call the handle_stripe() without obviously
> changing the state of the stripe.  So whatever is going to happen now
> could potentially have happened before... is that safe?

I'm not fully sure, but it's ok in my test.
 
> > +	 * move proper io_unit to reclaim list. We should not change the order.
> > +	 * reclaimable/unreclaimable io_unit can be mixed in the list, we
> > +	 * shouldn't reuse space of an unreclaimable io_unit
> > +	 * */
> > +	while (1) {
> > +		r5l_move_io_unit_list(&log->running_ios, &log->io_end_ios,
> > +			IO_UNIT_IO_END);
> > +		r5l_move_io_unit_list(&log->io_end_ios, &log->stripe_end_ios,
> > +				IO_UNIT_STRIPE_END);
> > +		while (!list_empty(&log->stripe_end_ios)) {
> > +			io = list_first_entry(&log->stripe_end_ios,
> > +				struct r5l_io_unit, log_sibling);
> > +			list_move_tail(&io->log_sibling, &list);
> > +			free += (io->log_end - io->log_start +
> > +				log->total_blocks) % log->total_blocks;
> > +		}
> > +
> > +		if (free >= reclaim_target || (list_empty(&log->running_ios) &&
> > +		    list_empty(&log->io_end_ios) &&
> > +		    list_empty(&log->stripe_end_ios)))
> > +			break;
> > +
> > +		if (!list_empty(&log->io_end_ios)) {
> > +			io = list_first_entry(&log->io_end_ios,
> > +				struct r5l_io_unit, log_sibling);
> > +			spin_unlock(&log->io_list_lock);
> > +			/* nobody else can delete the io, we are safe */
> > +			r5l_kick_io_unit(log, io);
> > +			spin_lock(&log->io_list_lock);
> > +			continue;
> > +		}
> > +
> > +		if (!list_empty(&log->running_ios)) {
> > +			io = list_first_entry(&log->running_ios,
> > +				struct r5l_io_unit, log_sibling);
> > +			spin_unlock(&log->io_list_lock);
> > +			/* nobody else can delete the io, we are safe */
> > +			r5l_kick_io_unit(log, io);
> > +			spin_lock(&log->io_list_lock);
> > +			continue;
> > +		}
> > +	}
> > +	spin_unlock(&log->io_list_lock);
> 
> Well, here we are with the important parts of the reclaim code...
> 
> The main result of the above section is to possibly call
> r5l_flush_stripe_to_raid() a few times, and to wait until 'list'
> contains enough io_units to satisfy the requirement.
> 
> As raid5d already calls r5l_flush_stripe_to_raid - which it really must
> to make sure that writes complete quickly - this really comes down to
> some book keeping and some waiting.
> Book keeping can be done as changes happen, and waiting is best not
> done at all.
> 
> To be more specific: when an io_unit transitions to IO_UNIT_STRIPE_END
> it can immediately be removed from the list and if it was the first
> io_unit on the list, then the log_start can immediately be updated.

Ok, the original idea is to avoid holding the io_list_lock for every IO
end/stripe end. Maybe over-designed, I'll fix this.

> > +
> > +	if (list_empty(&list))
> > +		return;
> > +
> > +	r5l_flush_all_disks(log);
> > +
> > +	/* super always point to last valid meta */
> > +	last = list_last_entry(&list, struct r5l_io_unit, log_sibling);
> > +	r5l_write_super(log, r5l_block_to_sector(log, last->log_start));
> 
> This bit flushes all the disks and then updates the metadata and writes
> it.
> As md_super_write already uses WRITE_FLUSH_FUA I don't think the extra
> flush is needed.
great.

> I really think you should just update ->recovery_offset and set
> MD_CHANGE_DEVS (or similar) and let the update happen.

I think we should write super here. The reclaimed space might be reused
immediately, we don't want to confuse recovery.

> > +
> > +	mutex_lock(&log->io_mutex);
> > +	log->last_checkpoint = last->log_start;
> > +	log->last_cp_seq = last->seq;
> > +	mutex_unlock(&log->io_mutex);
> > +	wake_up(&log->space_waitq);
> > +
> > +	while (!list_empty(&list)) {
> > +		io = list_first_entry(&list, struct r5l_io_unit, log_sibling);
> > +		list_del(&io->log_sibling);
> > +		r5l_free_io_unit(log, io);
> > +	}
> > +}
> 
> So I really think all of this can be done as-it-happens (the
> book-keeping) or asynchronously.  There is no need to push something
> every minute.

Because we need flush raid disks cache, to avoid the overhead, we do
batch operation. Once I changed the reclaim to run every specific
reclaimable space, this should be ok.

Thanks,
Shaohua
