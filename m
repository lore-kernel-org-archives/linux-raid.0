From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v3 4/9] raid5: calculate partial parity for a stripe
Date: Tue, 7 Feb 2017 13:25:28 -0800
Message-ID: <20170207212528.m6u47y3f2jot2kng@kernel.org>
References: <20170130185953.30428-1-artur.paszkiewicz@intel.com>
 <20170130185953.30428-5-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170130185953.30428-5-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.com, jes.sorensen@gmail.com
List-Id: linux-raid.ids

On Mon, Jan 30, 2017 at 07:59:48PM +0100, Artur Paszkiewicz wrote:
> Attach a page for holding the partial parity data to stripe_head.
> Allocate it only if mddev has the MD_HAS_PPL flag set.
> 
> Partial parity is the xor of not modified data chunks of a stripe and is
> calculated as follows:
> 
> - reconstruct-write case:
>   xor data from all not updated disks in a stripe
> 
> - read-modify-write case:
>   xor old data and parity from all updated disks in a stripe
> 
> Implement it using the async_tx API and integrate into raid_run_ops().
> It must be called when we still have access to old data, so do it when
> STRIPE_OP_BIODRAIN is set, but before ops_run_prexor5(). The result is
> stored into sh->ppl_page.
> 
> Partial parity is not meaningful for full stripe write and is not stored
> in the log or used for recovery, so don't attempt to calculate it when
> stripe has STRIPE_FULL_WRITE.
> 
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
>  drivers/md/raid5.c | 98 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/md/raid5.h |  2 ++
>  2 files changed, 100 insertions(+)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index d1cba941951e..e1e238da32ba 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -466,6 +466,11 @@ static void shrink_buffers(struct stripe_head *sh)
>  		sh->dev[i].page = NULL;
>  		put_page(p);
>  	}
> +
> +	if (sh->ppl_page) {
> +		put_page(sh->ppl_page);
> +		sh->ppl_page = NULL;
> +	}
>  }
>  
>  static int grow_buffers(struct stripe_head *sh, gfp_t gfp)
> @@ -482,6 +487,13 @@ static int grow_buffers(struct stripe_head *sh, gfp_t gfp)
>  		sh->dev[i].page = page;
>  		sh->dev[i].orig_page = page;
>  	}
> +
> +	if (test_bit(MD_HAS_PPL, &sh->raid_conf->mddev->flags)) {

I think the test should be something like:
	if (raid5_ppl_enabled())

Having the feature doesn't mean the feature is enabled.

>  	pr_debug("%s: stripe %llu locked: %d ops_request: %lx\n",
>  		__func__, (unsigned long long)sh->sector,
>  		s->locked, s->ops_request);
> @@ -3105,6 +3175,34 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx,
>  	if (*bip && (*bip)->bi_iter.bi_sector < bio_end_sector(bi))
>  		goto overlap;
>  
> +	if (forwrite && test_bit(MD_HAS_PPL, &conf->mddev->flags)) {
> +		/*
> +		 * With PPL only writes to consecutive data chunks within a
> +		 * stripe are allowed. Not really an overlap, but
> +		 * wait_for_overlap can be used to handle this.
> +		 */

Please describe why the data must be consecutive.

Thanks,
Shaohua
