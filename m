From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 1/4] raid5-ppl: use a single mempool for ppl_io_unit and
 header_page
Date: Mon, 10 Apr 2017 12:09:48 -0700
Message-ID: <20170410190948.v33qgv63r423zfbb@kernel.org>
References: <20170404111358.14829-1-artur.paszkiewicz@intel.com>
 <20170404111358.14829-2-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170404111358.14829-2-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid@vger.kernel.org, songliubraving@fb.com
List-Id: linux-raid.ids


On Tue, Apr 04, 2017 at 01:13:55PM +0200, Artur Paszkiewicz wrote:

Cc: Song, the raid5-cache needs similar fix.

> Allocate both struct ppl_io_unit and its header_page from a shared
> mempool to avoid a possible deadlock. Implement allocate and free
> functions for the mempool, remove the second pool for allocating
> header_page. The header_pages are now freed with their io_units, not
> when the ppl bio completes. Also, use GFP_NOWAIT instead of GFP_ATOMIC
> for allocating ppl_io_unit because we can handle failed allocations and
> there is no reason to utilize emergency reserves.

I applied the last 3 patches, had some nitpicks for this one though

> Suggested-by: NeilBrown <neilb@suse.com>
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
>  drivers/md/raid5-ppl.c | 53 ++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 36 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
> index 86ea9addb51a..42e43467d1e8 100644
> --- a/drivers/md/raid5-ppl.c
> +++ b/drivers/md/raid5-ppl.c
> @@ -102,7 +102,6 @@ struct ppl_conf {
>  	struct kmem_cache *io_kc;
>  	mempool_t *io_pool;
>  	struct bio_set *bs;
> -	mempool_t *meta_pool;
>  
>  	/* used only for recovery */
>  	int recovered_entries;
> @@ -195,6 +194,33 @@ ops_run_partial_parity(struct stripe_head *sh, struct raid5_percpu *percpu,
>  	return tx;
>  }
>  
> +static void *ppl_io_pool_alloc(gfp_t gfp_mask, void *pool_data)
> +{
> +	struct kmem_cache *kc = pool_data;
> +	struct ppl_io_unit *io;
> +
> +	io = kmem_cache_alloc(kc, gfp_mask);
> +	if (!io)
> +		return NULL;
> +
> +	io->header_page = alloc_page(gfp_mask);
> +	if (!io->header_page) {
> +		kmem_cache_free(kc, io);
> +		return NULL;
> +	}
> +
> +	return io;

Maybe directly use GFP_NOWAIT here, we don't use other gfp

> +}
> +
> +static void ppl_io_pool_free(void *element, void *pool_data)
> +{
> +	struct kmem_cache *kc = pool_data;
> +	struct ppl_io_unit *io = element;
> +
> +	__free_page(io->header_page);
> +	kmem_cache_free(kc, io);
> +}
> +
>  static struct ppl_io_unit *ppl_new_iounit(struct ppl_log *log,
>  					  struct stripe_head *sh)
>  {
> @@ -202,18 +228,19 @@ static struct ppl_io_unit *ppl_new_iounit(struct ppl_log *log,
>  	struct ppl_io_unit *io;
>  	struct ppl_header *pplhdr;
>  
> -	io = mempool_alloc(ppl_conf->io_pool, GFP_ATOMIC);
> +	io = mempool_alloc(ppl_conf->io_pool, GFP_NOWAIT);
>  	if (!io)
>  		return NULL;
>  
> -	memset(io, 0, sizeof(*io));
>  	io->log = log;
> +	io->entries_count = 0;
> +	io->pp_size = 0;
> +	io->submitted = false;

I'd suggest moving the memset to ppl_io_pool_alloc. Don't think we need to
optimize to avoid setting header_page. And doing memset is less error prone,
for example adding new fields.

Otherwise looks quite good.

Thanks,
Shaohua
>  	INIT_LIST_HEAD(&io->log_sibling);
>  	INIT_LIST_HEAD(&io->stripe_list);
>  	atomic_set(&io->pending_stripes, 0);
>  	bio_init(&io->bio, io->biovec, PPL_IO_INLINE_BVECS);
>  
> -	io->header_page = mempool_alloc(ppl_conf->meta_pool, GFP_NOIO);
>  	pplhdr = page_address(io->header_page);
>  	clear_page(pplhdr);
>  	memset(pplhdr->reserved, 0xff, PPL_HDR_RESERVED);
> @@ -369,8 +396,6 @@ static void ppl_log_endio(struct bio *bio)
>  	if (bio->bi_error)
>  		md_error(ppl_conf->mddev, log->rdev);
>  
> -	mempool_free(io->header_page, ppl_conf->meta_pool);
> -
>  	list_for_each_entry_safe(sh, next, &io->stripe_list, log_list) {
>  		list_del_init(&sh->log_list);
>  
> @@ -998,7 +1023,6 @@ static void __ppl_exit_log(struct ppl_conf *ppl_conf)
>  
>  	kfree(ppl_conf->child_logs);
>  
> -	mempool_destroy(ppl_conf->meta_pool);
>  	if (ppl_conf->bs)
>  		bioset_free(ppl_conf->bs);
>  	mempool_destroy(ppl_conf->io_pool);
> @@ -1104,25 +1128,20 @@ int ppl_init_log(struct r5conf *conf)
>  
>  	ppl_conf->io_kc = KMEM_CACHE(ppl_io_unit, 0);
>  	if (!ppl_conf->io_kc) {
> -		ret = -EINVAL;
> +		ret = -ENOMEM;
>  		goto err;
>  	}
>  
> -	ppl_conf->io_pool = mempool_create_slab_pool(conf->raid_disks, ppl_conf->io_kc);
> +	ppl_conf->io_pool = mempool_create(conf->raid_disks, ppl_io_pool_alloc,
> +					   ppl_io_pool_free, ppl_conf->io_kc);
>  	if (!ppl_conf->io_pool) {
> -		ret = -EINVAL;
> +		ret = -ENOMEM;
>  		goto err;
>  	}
>  
>  	ppl_conf->bs = bioset_create(conf->raid_disks, 0);
>  	if (!ppl_conf->bs) {
> -		ret = -EINVAL;
> -		goto err;
> -	}
> -
> -	ppl_conf->meta_pool = mempool_create_page_pool(conf->raid_disks, 0);
> -	if (!ppl_conf->meta_pool) {
> -		ret = -EINVAL;
> +		ret = -ENOMEM;
>  		goto err;
>  	}
>  
> -- 
> 2.11.0
> 
