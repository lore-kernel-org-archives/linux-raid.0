From: Neil Brown <neilb@suse.de>
Subject: Re: [md PATCH 4/4] async_tx: fix asynchronous raid6 recovery for ddf
	layouts
Date: Thu, 22 Oct 2009 10:26:10 +1100
Message-ID: <19167.39058.385807.420558@notabene.brown>
References: <20091020070627.6489.4006.stgit@dwillia2-linux.ch.intel.com>
	<20091020071138.6489.73870.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Tuesday October 20
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Thanks for these Dan.  I have pulled them and will ask Linus to pull
them shortly.

I'm a little concerned about the following patch though.  While it
looks like it is probably correct, it seems to be creating some rather
complex code.

How hard would it be do simply scan the src_ptrs list for non-NULL
entries and if there are 0 or 1 of them, handle them with special case
code, rather than carrying around the 'is_ddf' flag and so forth??

Thanks,
NeilBrown


On Tuesday October 20, dan.j.williams@intel.com wrote:
> The raid6 recovery code currently requires special handling of the
> 4-disk and 5-disk recovery scenarios for the native layout.  Quoting
> from commit 0a82a623:
> 
>      In these situations the default N-disk algorithm will present
>      0-source or 1-source operations to dma devices.  To cover for
>      dma devices where the minimum source count is 2 we implement
>      4-disk and 5-disk handling in the recovery code.
> 
> Recovery in the ddf layout case needs explicit handling of the 6-disk
> and 7-disk recovery cases which pose the same problems as the ones
> mentioned above.  Note that N-disks refers to N syndrome-disks not the
> width of the array.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  crypto/async_tx/async_raid6_recov.c |   98 ++++++++++++++++++++++++++++-------
>  crypto/async_tx/raid6test.c         |    6 +-
>  drivers/md/raid5.c                  |    6 +-
>  include/linux/async_tx.h            |    6 +-
>  4 files changed, 89 insertions(+), 27 deletions(-)
> 
> diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
> index 8e30b6e..54b39d2 100644
> --- a/crypto/async_tx/async_raid6_recov.c
> +++ b/crypto/async_tx/async_raid6_recov.c
> @@ -132,7 +132,7 @@ async_mult(struct page *dest, struct page *src, u8 coef, size_t len,
>  
>  static struct dma_async_tx_descriptor *
>  __2data_recov_4(size_t bytes, int faila, int failb, struct page **blocks,
> -	      struct async_submit_ctl *submit)
> +		bool is_ddf, struct async_submit_ctl *submit)
>  {
>  	struct dma_async_tx_descriptor *tx = NULL;
>  	struct page *p, *q, *a, *b;
> @@ -143,8 +143,13 @@ __2data_recov_4(size_t bytes, int faila, int failb, struct page **blocks,
>  	void *cb_param = submit->cb_param;
>  	void *scribble = submit->scribble;
>  
> -	p = blocks[4-2];
> -	q = blocks[4-1];
> +	if (is_ddf) {
> +		p = blocks[6-2];
> +		q = blocks[6-1];
> +	} else {
> +		p = blocks[4-2];
> +		q = blocks[4-1];
> +	}
>  
>  	a = blocks[faila];
>  	b = blocks[failb];
> @@ -171,7 +176,7 @@ __2data_recov_4(size_t bytes, int faila, int failb, struct page **blocks,
>  
>  static struct dma_async_tx_descriptor *
>  __2data_recov_5(size_t bytes, int faila, int failb, struct page **blocks,
> -	      struct async_submit_ctl *submit)
> +		bool is_ddf, struct async_submit_ctl *submit)
>  {
>  	struct dma_async_tx_descriptor *tx = NULL;
>  	struct page *p, *q, *g, *dp, *dq;
> @@ -181,21 +186,34 @@ __2data_recov_5(size_t bytes, int faila, int failb, struct page **blocks,
>  	dma_async_tx_callback cb_fn = submit->cb_fn;
>  	void *cb_param = submit->cb_param;
>  	void *scribble = submit->scribble;
> -	int uninitialized_var(good);
> +	int good = -1;
>  	int i;
>  
> -	for (i = 0; i < 3; i++) {
> -		if (i == faila || i == failb)
> -			continue;
> -		else {
> +	if (is_ddf) {
> +		/* a 7-disk ddf operation devolves to the 5-disk native
> +		 * layout case modulo these fixups
> +		 */
> +		for (i = 0; i < 7-2; i++) {
> +			if (blocks[i] == NULL)
> +				continue;
> +			if (i == faila || i == failb)
> +				continue;
> +			BUG_ON(good != -1);
>  			good = i;
> -			break;
>  		}
> +		p = blocks[7-2];
> +		q = blocks[7-1];
> +	} else {
> +		for (i = 0; i < 5-2; i++) {
> +			if (i == faila || i == failb)
> +				continue;
> +			BUG_ON(good != -1);
> +			good = i;
> +		}
> +		p = blocks[5-2];
> +		q = blocks[5-1];
>  	}
> -	BUG_ON(i >= 3);
> -
> -	p = blocks[5-2];
> -	q = blocks[5-1];
> +	BUG_ON(good == -1);
>  	g = blocks[good];
>  
>  	/* Compute syndrome with zero for the missing data pages
> @@ -317,11 +335,13 @@ __2data_recov_n(int disks, size_t bytes, int faila, int failb,
>   * @faila: first failed drive index
>   * @failb: second failed drive index
>   * @blocks: array of source pointers where the last two entries are p and q
> + * @is_ddf: flag to indicate whether 'blocks' is in the ddf layout
>   * @submit: submission/completion modifiers
>   */
>  struct dma_async_tx_descriptor *
>  async_raid6_2data_recov(int disks, size_t bytes, int faila, int failb,
> -			struct page **blocks, struct async_submit_ctl *submit)
> +			struct page **blocks, bool is_ddf,
> +			struct async_submit_ctl *submit)
>  {
>  	BUG_ON(faila == failb);
>  	if (failb < faila)
> @@ -356,13 +376,23 @@ async_raid6_2data_recov(int disks, size_t bytes, int faila, int failb,
>  		 * operation (in contrast to the synchronous case), so
>  		 * explicitly handle the 4 disk special case
>  		 */
> -		return __2data_recov_4(bytes, faila, failb, blocks, submit);
> +		return __2data_recov_4(bytes, faila, failb, blocks, false, submit);
>  	case 5:
>  		/* dma devices do not uniformly understand a single
>  		 * source pq operation (in contrast to the synchronous
>  		 * case), so explicitly handle the 5 disk special case
>  		 */
> -		return __2data_recov_5(bytes, faila, failb, blocks, submit);
> +		return __2data_recov_5(bytes, faila, failb, blocks, false, submit);
> +	case 6:
> +		if (is_ddf)
> +			return __2data_recov_4(bytes, faila, failb, blocks,
> +					       true, submit);
> +		/* fall through */
> +	case 7:
> +		if (is_ddf)
> +			return __2data_recov_5(bytes, faila, failb, blocks,
> +					       true, submit);
> +		/* fall through */
>  	default:
>  		return __2data_recov_n(disks, bytes, faila, failb, blocks, submit);
>  	}
> @@ -375,11 +405,13 @@ EXPORT_SYMBOL_GPL(async_raid6_2data_recov);
>   * @bytes: block size
>   * @faila: failed drive index
>   * @blocks: array of source pointers where the last two entries are p and q
> + * @is_ddf: flag to indicate whether 'blocks' is in the ddf layout
>   * @submit: submission/completion modifiers
>   */
>  struct dma_async_tx_descriptor *
>  async_raid6_datap_recov(int disks, size_t bytes, int faila,
> -			struct page **blocks, struct async_submit_ctl *submit)
> +			struct page **blocks, bool is_ddf,
> +			struct async_submit_ctl *submit)
>  {
>  	struct dma_async_tx_descriptor *tx = NULL;
>  	struct page *p, *q, *dq;
> @@ -423,10 +455,11 @@ async_raid6_datap_recov(int disks, size_t bytes, int faila,
>  	blocks[faila] = NULL;
>  	blocks[disks-1] = dq;
>  
> -	/* in the 4 disk case we only need to perform a single source
> -	 * multiplication
> +	/* in the 4-disk (or 6-disk ddf layout) case we only need to
> +	 * perform a single source multiplication with the one good data
> +	 * block.
>  	 */
> -	if (disks == 4) {
> +	if (disks == 4 && !is_ddf) {
>  		int good = faila == 0 ? 1 : 0;
>  		struct page *g = blocks[good];
>  
> @@ -437,6 +470,29 @@ async_raid6_datap_recov(int disks, size_t bytes, int faila,
>  		init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL,
>  				  scribble);
>  		tx = async_mult(dq, g, raid6_gfexp[good], bytes, submit);
> +	} else if (disks == 6 && is_ddf) {
> +		struct page *g;
> +		int good = -1;
> +		int i;
> +
> +		for (i = 0; i < 6-2; i++) {
> +			if (blocks[i] == NULL)
> +				continue;
> +			if (i == faila)
> +				continue;
> +			BUG_ON(good != -1);
> +			good = i;
> +		}
> +		BUG_ON(good == -1);
> +		g = blocks[good];
> +
> +		init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL,
> +				  scribble);
> +		tx = async_memcpy(p, g, 0, 0, bytes, submit);
> +
> +		init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL,
> +				  scribble);
> +		tx = async_mult(dq, g, raid6_gfexp[good], bytes, submit);
>  	} else {
>  		init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL,
>  				  scribble);
> diff --git a/crypto/async_tx/raid6test.c b/crypto/async_tx/raid6test.c
> index 3ec27c7..9d7b3e1 100644
> --- a/crypto/async_tx/raid6test.c
> +++ b/crypto/async_tx/raid6test.c
> @@ -108,11 +108,13 @@ static void raid6_dual_recov(int disks, size_t bytes, int faila, int failb, stru
>  		if (failb == disks-2) {
>  			/* data+P failure. */
>  			init_async_submit(&submit, 0, NULL, NULL, NULL, addr_conv);
> -			tx = async_raid6_datap_recov(disks, bytes, faila, ptrs, &submit);
> +			tx = async_raid6_datap_recov(disks, bytes, faila, ptrs,
> +						     false, &submit);
>  		} else {
>  			/* data+data failure. */
>  			init_async_submit(&submit, 0, NULL, NULL, NULL, addr_conv);
> -			tx = async_raid6_2data_recov(disks, bytes, faila, failb, ptrs, &submit);
> +			tx = async_raid6_2data_recov(disks, bytes, faila, failb,
> +						     ptrs, false, &submit);
>  		}
>  	}
>  	init_completion(&cmp);
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 81abefc..18d6ed4 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -888,12 +888,14 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
>  			/* We're missing D+P. */
>  			return async_raid6_datap_recov(syndrome_disks+2,
>  						       STRIPE_SIZE, faila,
> -						       blocks, &submit);
> +						       blocks, sh->ddf_layout,
> +						       &submit);
>  		} else {
>  			/* We're missing D+D. */
>  			return async_raid6_2data_recov(syndrome_disks+2,
>  						       STRIPE_SIZE, faila, failb,
> -						       blocks, &submit);
> +						       blocks, sh->ddf_layout,
> +						       &submit);
>  		}
>  	}
>  }
> diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
> index a1c486a..7520204 100644
> --- a/include/linux/async_tx.h
> +++ b/include/linux/async_tx.h
> @@ -199,11 +199,13 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int src_cnt,
>  
>  struct dma_async_tx_descriptor *
>  async_raid6_2data_recov(int src_num, size_t bytes, int faila, int failb,
> -			struct page **ptrs, struct async_submit_ctl *submit);
> +			struct page **ptrs, bool is_ddf,
> +			struct async_submit_ctl *submit);
>  
>  struct dma_async_tx_descriptor *
>  async_raid6_datap_recov(int src_num, size_t bytes, int faila,
> -			struct page **ptrs, struct async_submit_ctl *submit);
> +			struct page **ptrs, bool is_ddf,
> +			struct async_submit_ctl *submit);
>  
>  void async_tx_quiesce(struct dma_async_tx_descriptor **tx);
>  #endif /* _ASYNC_TX_H_ */
