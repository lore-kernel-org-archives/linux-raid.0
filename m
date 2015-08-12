From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 3/9] raid5: add basic stripe log
Date: Wed, 12 Aug 2015 13:20:33 +1000
Message-ID: <20150812132033.7534a751@noble>
References: <cover.1438215986.git.shli@fb.com>
	<29c5d697b86094fb7141b23875eb4da6abc6022c.1438215986.git.shli@fb.com>
	<20150805130736.7ba8a6d5@noble>
	<20150805211919.GA3102271@devbig257.prn2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150805211919.GA3102271@devbig257.prn2.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

On Wed, 5 Aug 2015 14:19:20 -0700 Shaohua Li <shli@fb.com> wrote:

> On Wed, Aug 05, 2015 at 01:07:36PM +1000, NeilBrown wrote:
> > On Wed, 29 Jul 2015 17:38:43 -0700 Shaohua Li <shli@fb.com> wrote:
> > 
> > > This introduces a simple log for raid5. Data/parity writting to raid
> > > array first writes to the log, then write to raid array disks. If crash
> > > happens, we can recovery data from the log. This can speed up raid
> > > resync and fix write hole issue.
> > > 
> > > The log structure is pretty simple. Data/meta data is stored in block
> > > unit, which is 4k generally. It has only one type of meta data block.
> > > The meta data block can track 3 types of data, stripe data, stripe
> > > parity and flush block. MD superblock will point to the last valid meta
> > > data block. Each meta data block has checksum/seq number, so recovery
> > > can scan the log correctly. We store a checksum of stripe data/parity to
> > > the metadata block, so meta data and stripe data/parity can be written
> > > to log disk together. otherwise, meta data write must wait till stripe
> > > data/parity is finished.
> > > 
> > > For stripe data, meta data block will record stripe data sector and
> > > size. Currently the size is always 4k. This meta data record can be made
> > > simpler if we just fix write hole (eg, we can record data of a stripe's
> > > different disks together), but this format can be extended to support
> > > caching in the future, which must record data address/size.
> > > 
> > > For stripe parity, meta data block will record stripe sector. It's size
> > > should be 4k (for raid5) or 8k (for raid6). We always store p parity
> > > first. This format should work for caching too.
> > 
> > It feels a bit odd have a 8K parity block for RAID6 as it is really two
> > blocks: a parity block and a Q-syndrome block.  What would you think of
> > introducing another block type for Q?  So there are Data blocks, Parity
> > blocks, and Q blocks ???
> > 
> > Not a big issue, but I thought I would mention it.
> 
> I'd prefer not adding the complexity, it's just a naming.

It's not really "just naming" - it affects the format of the metadata
block.
And I think your approach adds complexity.  It means the parity blocks
can be a different size to the data blocks, and it makes
r5l_log_pages() more complex than needed.



> 
> > > 
> > > flush block indicates a stripe is in raid array disks. Fixing write hole
> > > doesn't need this type of meta data, it's for caching extention.
> > > 
> > > We should be careful about deadlock. Appending stripe data/parity to log
> > > is done in raid5d. The append need log space, which can trigger log
> > > reclaim, which might wait for raid5d to run (to flush data from log to
> > > raid array disks). Here we always do the log write in a separate thread.
> > 
> > I'm not convinced about the need for a separate thread.  As
> > raid5d/handle_stripe works as a state machine, and as all IO is async,
> > we should at most need an extra state, not an extra thread.
> > 
> > I think a key issue is that you don't call r5l_get_reserve() until you
> > are about to submit writes to the log.
> > If instead you reserved the space in r5l_write_stripe and delay the
> > stripe if space is not available, there there would be no deadlock.
> > Then when available space crosses some threshold, re-activate those
> > delayed stripes.
> 
> ok, that way works too. As I said before, I really hate making the
> log/cache stuff tie tightly together with stripe cache state machine if
> possible (eg, adding new state/list/stripe analysis etc). I'd rather to
> keep current logic if you don't strongly object.

I think I do strongly object.

The stripe cache and state machine are the heart-and-soul of md/raid5.
If everything goes through the stripe cache then there are fewer
special cases to think about.

Having to create a separate thread to avoid a deadlock is a fairly
clear indicator that the design isn't very clean.


> 
> > > +#include <linux/kernel.h>
> > > +#include <linux/wait.h>
> > > +#include <linux/blkdev.h>
> > > +#include <linux/slab.h>
> > > +#include <linux/raid/md_p.h>
> > > +#include <linux/crc32.h>
> > > +#include <linux/random.h>
> > > +#include "md.h"
> > > +#include "raid5.h"
> > > +
> > > +typedef u64 r5blk_t; /* log blocks, 512B - 4k */
> > 
> > I would much rather use sector_t throughout and keep all addresses as
> > sector addresses.  Much less room for confusion that way.
> > 
> > If we wanted to pack lots of addresses into limited space then using
> > block addresses might be justified (filesystems do that), but I don't
> > think it is called for here at all.
> 
> The original idea is metadata block size could be changed between 512B
> to 4k. Sometimes the metadata block can't have enough data if we don't
> want to delay IO. When the block size isn't a sector, the type helps me
> avoid coding error (eg, remind it's a block instead of a sector). Do you
> prefer metadata block size one sector?

No, I don't prefer one-sector metadata blocks.  Given that there is a
growing amount of hardware that works best with 4K IO, I think a 4K
metadata block size is a good choice.

I certainly agree that having a separate type to store block numbers
makes sense as it could help avoid coding errors - except that I don't
think we should be storing block numbers at all.  EVery.

Just use sector numbers everywhere.

> 
> > > +static void r5l_put_reserve(struct r5l_log *log, unsigned int reserved_blocks)
> > > +{
> > > +	BUG_ON(!mutex_is_locked(&log->io_mutex));
> > > +
> > > +	log->reserved_blocks -= reserved_blocks;
> > > +	if (r5l_free_space(log) > 0)
> > > +		wake_up(&log->space_waitq);
> > > +}
> > > +
> > > +static struct r5l_io_unit *r5l_alloc_io_unit(struct r5l_log *log)
> > > +{
> > > +	struct r5l_io_unit *io;
> > > +	gfp_t gfp = GFP_NOIO | __GFP_NOFAIL;
> > > +
> > > +	io = kmem_cache_zalloc(log->io_kc, gfp);
> > > +	if (!io)
> > > +		return NULL;
> > > +	io->log = log;
> > > +	io->meta_page = alloc_page(gfp | __GFP_ZERO);
> > > +	if (!io->meta_page) {
> > > +		kmem_cache_free(log->io_kc, io);
> > > +		return NULL;
> > > +	}
> > 
> > This can return NULL, but the one place where you call it you do not
> > check for NULL.
> > Maybe a mempool would be appropriate, maybe something else - I haven't
> > examine the issue closely.
> 
> I use mempool for the cache patch, but eventually choose to use NOFAIL
> allocation here, because don't know what the minimal mempool element
> size should be. incorrect mempool element size could introduce trouble,
> eg, the allocation expects we free an element, which might not possible
> without increasing complexity in reclaim. Maybe I should just ignore the
> NULL, it's a NOFAIL allocation. The log code isn't ready with allocation
> failure.

I hadn't noticed the __GFP_NOFAIL, only the "return NULL".
But I don't really like __GFP_NOFAIL, and there seem to be people in
the mm community who don't either, so I'd rather not rely on it.

2 entries in a mempool should be plenty.  The freeing of old entries
through reclaim should be completely independent of the allocation of
new entries, so that latter can safely wait for the former.


>  
> > > +static int r5l_recovery_log(struct r5l_log *log)
> > > +{
> > > +	/* fake recovery */
> > > +	log->seq = log->last_cp_seq + 1;
> > > +	log->log_start = r5l_ring_add(log, log->last_checkpoint, 1);
> > > +	return 0;
> > > +}
> > > +
> > > +static void r5l_write_super(struct r5l_log *log, sector_t cp)
> > > +{
> > > +	log->rdev->recovery_offset = cp;
> > > +	md_update_sb(log->mddev, 1);
> > > +}
> > 
> > This is only called from run() when the log is first initialised.  At
> > this point there is nothing useful in the log, so recording it's
> > location is pointless.  At most you  could set the MD_SB_DIRTY flag (or
> > whatever it is).
> > So it really doesn't need to be a separate function.
> 
> We must write super here. If we start append data to the log and super
> doesn't point to correct postion (reclaim might not run once yet),
> recovery doesn't know where to find the log.

Yes, we do need to store the address of the log in the superblock
before the first write.

We already have code to ensure the superblock is written on the first
write: md_write_start.
If mddev->in_sync is true when the array starts, then we are already
certain that the metadata will be updated before any write is sent.
Can you just make use of that?



> 
> > > +void r5l_exit_log(struct r5l_log *log)
> > > +{
> > > +	md_unregister_thread(&log->log_thread);
> > > +
> > > +	kmem_cache_destroy(log->io_kc);
> > > +	kfree(log);
> > > +}
> > > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > > index 59e44e9..9608a44 100644
> > > --- a/drivers/md/raid5.c
> > > +++ b/drivers/md/raid5.c
> > > @@ -899,6 +899,8 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
> > >  
> > >  	might_sleep();
> > >  
> > > +	if (!r5l_write_stripe(conf->log, sh))
> > > +		return;
> > 
> > If no log is configured, r5l_write_stripe will return -EAGAIN, and so
> > ops_run_io will never submit any IO....
> 
> I think you read it wrong, we don't return in that case.

You are correct - sorry.
If often get confused when "!" is used like that.  It looks like it
says "If not r5l_write_stripe" - i.e. if we didn't write to the log.
I personally much prefer
   if (r5l_write_stripe(..) == 0)

just like I hate "if (!strcmp(x,y))" and prefer "if (strcmp(x,y) == 0)".
But maybe that it just me.



> 
> > > diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> > > index 02c3bf8..a8daf39 100644
> > > --- a/drivers/md/raid5.h
> > > +++ b/drivers/md/raid5.h
> > > @@ -223,6 +223,9 @@ struct stripe_head {
> > >  	struct stripe_head	*batch_head; /* protected by stripe lock */
> > >  	spinlock_t		batch_lock; /* only header's lock is useful */
> > >  	struct list_head	batch_list; /* protected by head's batch lock*/
> > > +
> > > +	struct r5l_io_unit	*log_io;
> > > +	struct list_head	log_list;
> > >  	/**
> > >  	 * struct stripe_operations
> > >  	 * @target - STRIPE_OP_COMPUTE_BLK target
> > 
> > I wonder if we really need yet another 'list_head' in 'stripe_head'.
> > I guess one more is no great cost.
> 
> I'm pretty sure using the lru list of stripe_head is broken, that's why
> I added the new list. 

You're probably right.

Thanks,
NeilBrown


> 
> I'll fix other issues or add more comments.
> 
> Thanks,
> Shaohua

