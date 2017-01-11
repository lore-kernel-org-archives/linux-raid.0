From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v2 2/2] md/r5cache: enable chunk_aligned_read with write
 back cache
Date: Wed, 11 Jan 2017 10:02:11 -0800
Message-ID: <20170111180211.2qfiav4lxd7inyrx@kernel.org>
References: <20170111014251.3236610-1-songliubraving@fb.com>
 <20170111014251.3236610-2-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170111014251.3236610-2-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuan@kylinos.cn, liuyun01@kylinos.cn, Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

On Tue, Jan 10, 2017 at 05:42:51PM -0800, Song Liu wrote:
> Chunk aligned read significantly reduces CPU usage of raid456.
> However, it is not safe to fully bypass the write back cache.
> This patch enables chunk aligned read with write back cache.
> 
> For chunk aligned read, we track stripes in write back cache at
> a bigger granularity, "big_stripe". Each chunk may contain more
> than one stripe (for example, a 256kB chunk contains 64 4kB-page,
> so this chunk contain 64 stripes). For chunk_aligned_read, these
> stripes are grouped into one big_stripe, so we only need one lookup
> for the whole chunk.
> 
> For each big_stripe, struct big_stripe_info tracks how many stripes
> of this big_stripe are in the write back cache. We count how many
> stripes of this big_stripe are in the write back cache. These
> counters are tracked in a radix tree (big_stripe_tree).
> r5c_tree_index() is used to calculate keys for the radix tree.
> 
> chunk_aligned_read() calls r5c_big_stripe_cached() to look up
> big_stripe of each chunk in the tree. If this big_stripe is in the
> tree, chunk_aligned_read() aborts. This look up is protected by
> rcu_read_lock().
> 
> It is necessary to remember whether a stripe is counted in
> big_stripe_tree. Instead of adding new flag, we reuses existing flags:
> STRIPE_R5C_PARTIAL_STRIPE and STRIPE_R5C_FULL_STRIPE. If either of these
> two flags are set, the stripe is counted in big_stripe_tree. This
> requires moving set_bit(STRIPE_R5C_PARTIAL_STRIPE) to
> r5c_try_caching_write(); and moving clear_bit of
> STRIPE_R5C_PARTIAL_STRIPE and STRIPE_R5C_FULL_STRIPE to
> r5c_finish_stripe_write_out().
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/md/raid5-cache.c | 164 ++++++++++++++++++++++++++++++++++++++++++-----
>  drivers/md/raid5.c       |  19 ++++--
>  drivers/md/raid5.h       |   1 +
>  3 files changed, 160 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 3e3e5dc..2ff2510 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -20,6 +20,7 @@
>  #include <linux/crc32c.h>
>  #include <linux/random.h>
>  #include <linux/kthread.h>
> +#include <linux/types.h>
>  #include "md.h"
>  #include "raid5.h"
>  #include "bitmap.h"
> @@ -162,9 +163,59 @@ struct r5l_log {
>  
>  	/* to submit async io_units, to fulfill ordering of flush */
>  	struct work_struct deferred_io_work;
> +
> +	/* to for chunk_aligned_read in writeback mode, details below */
> +	spinlock_t tree_lock;
> +	struct radix_tree_root big_stripe_tree;
>  };
>  
>  /*
> + * Enable chunk_aligned_read() with write back cache.
> + *
> + * Each chunk may contain more than one stripe (for example, a 256kB
> + * chunk contains 64 4kB-page, so this chunk contain 64 stripes). For
> + * chunk_aligned_read, these stripes are grouped into one "big_stripe".
> + * For each big_stripe, we count how many stripes of this big_stripe
> + * are in the write back cache. These data are tracked in a radix tree
> + * (big_stripe_tree). We use radix_tree item pointer as the counter.
> + * r5c_tree_index() is used to calculate keys for the radix tree.
> + *
> + * chunk_aligned_read() calls r5c_big_stripe_cached() to look up
> + * big_stripe of each chunk in the tree. If this big_stripe is in the
> + * tree, chunk_aligned_read() aborts. This look up is protected by
> + * rcu_read_lock().
> + *
> + * It is necessary to remember whether a stripe is counted in
> + * big_stripe_tree. Instead of adding new flag, we reuses existing flags:
> + * STRIPE_R5C_PARTIAL_STRIPE and STRIPE_R5C_FULL_STRIPE. If either of these
> + * two flags are set, the stripe is counted in big_stripe_tree. This
> + * requires moving set_bit(STRIPE_R5C_PARTIAL_STRIPE) to
> + * r5c_try_caching_write(); and moving clear_bit of
> + * STRIPE_R5C_PARTIAL_STRIPE and STRIPE_R5C_FULL_STRIPE to
> + * r5c_finish_stripe_write_out().
> + */
> +
> +/*
> + * radix tree requests lowest 2 bits of data pointer to be 2b'00, so we
> + * adds 4 for each stripe
> + */
> +#define R5C_RADIX_COUNT_UNIT 4

I'd use bit shift here. To increase/decrease refcount, write (refcount +/- 1)
<< 2. It's much more readable than refcount +/- R5C_RADIX_COUNT_UNIT.

> +/* check whether this big stripe is in write back cache. */
> +bool r5c_big_stripe_cached(struct r5conf *conf, sector_t sect)
> +{
> +	struct r5l_log *log = conf->log;
> +	sector_t tree_index;
> +	void **pslot;
> +
> +	if (!log)
> +		return false;
> +
> +	WARN_ON_ONCE(!rcu_read_lock_held());
> +	tree_index = r5c_tree_index(conf, sect);
> +	pslot = radix_tree_lookup_slot(&log->big_stripe_tree, tree_index);

The comment above radix_tree_lookup_slot explains:
 *	This function can be called under rcu_read_lock iff the slot is not
 *	modified by radix_tree_replace_slot, otherwise it must be called
 *	exclusive from other writers. 

It's not the case here, since other threads are add/delete items.

> +	return pslot != NULL;
> +}
> +
>  static int r5l_load_log(struct r5l_log *log)
>  {
>  	struct md_rdev *rdev = log->rdev;
> @@ -2641,6 +2768,9 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
>  	if (!log->meta_pool)
>  		goto out_mempool;
>  
> +	spin_lock_init(&log->tree_lock);
> +	INIT_RADIX_TREE(&log->big_stripe_tree, GFP_ATOMIC);

Since the allocation can fail safely, this should be GFP_NOWAIT | __GFP_NOWARN.
GFP_ATOMIC can use reserved memory, which is unnecessary here.

Thanks,
Shaohua
