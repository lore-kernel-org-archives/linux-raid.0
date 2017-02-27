From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v4 2/7] raid5: calculate partial parity for a stripe
Date: Mon, 27 Feb 2017 15:45:14 -0800
Message-ID: <20170227234514.3bo5jxf35ie7vhor@kernel.org>
References: <20170221194401.18733-1-artur.paszkiewicz@intel.com>
 <20170221194401.18733-3-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170221194401.18733-3-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: shli@fb.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 21, 2017 at 08:43:56PM +0100, Artur Paszkiewicz wrote:
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
>  drivers/md/raid5.c | 100 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/md/raid5.h |   3 ++
>  2 files changed, 103 insertions(+)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 7b7722bb2e8d..02e02fe5b04e 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -463,6 +463,11 @@ static void shrink_buffers(struct stripe_head *sh)
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
> @@ -479,6 +484,13 @@ static int grow_buffers(struct stripe_head *sh, gfp_t gfp)
>  		sh->dev[i].page = page;
>  		sh->dev[i].orig_page = page;
>  	}
> +
> +	if (test_bit(MD_HAS_PPL, &sh->raid_conf->mddev->flags)) {
> +		sh->ppl_page = alloc_page(gfp);
> +		if (!sh->ppl_page)
> +			return 1;
> +	}
> +
>  	return 0;
>  }
>  
> @@ -1974,6 +1986,55 @@ static void ops_run_check_pq(struct stripe_head *sh, struct raid5_percpu *percpu
>  			   &sh->ops.zero_sum_result, percpu->spare_page, &submit);
>  }
>  
> +static struct dma_async_tx_descriptor *
> +ops_run_partial_parity(struct stripe_head *sh, struct raid5_percpu *percpu,
> +		       struct dma_async_tx_descriptor *tx)
> +{
> +	int disks = sh->disks;
> +	struct page **xor_srcs = flex_array_get(percpu->scribble, 0);
> +	int count = 0, pd_idx = sh->pd_idx, i;
> +	struct async_submit_ctl submit;
> +
> +	pr_debug("%s: stripe %llu\n", __func__, (unsigned long long)sh->sector);
> +
> +	/*
> +	 * Partial parity is the XOR of stripe data chunks that are not changed
> +	 * during the write request. Depending on available data
> +	 * (read-modify-write vs. reconstruct-write case) we calculate it
> +	 * differently.
> +	 */
> +	if (sh->reconstruct_state == reconstruct_state_prexor_drain_run) {
> +		/* rmw: xor old data and parity from updated disks */
> +		for (i = disks; i--;) {
> +			struct r5dev *dev = &sh->dev[i];
> +			if (test_bit(R5_Wantdrain, &dev->flags) || i == pd_idx)
> +				xor_srcs[count++] = dev->page;
> +		}
> +	} else if (sh->reconstruct_state == reconstruct_state_drain_run) {
> +		/* rcw: xor data from all not updated disks */
> +		for (i = disks; i--;) {
> +			struct r5dev *dev = &sh->dev[i];
> +			if (test_bit(R5_UPTODATE, &dev->flags))
> +				xor_srcs[count++] = dev->page;
> +		}
> +	} else {
> +		return tx;
> +	}
> +
> +	init_async_submit(&submit, ASYNC_TX_XOR_ZERO_DST, tx, NULL, sh,
> +			  flex_array_get(percpu->scribble, 0)
> +			  + sizeof(struct page *) * (sh->disks + 2));
> +
> +	if (count == 1)
> +		tx = async_memcpy(sh->ppl_page, xor_srcs[0], 0, 0, PAGE_SIZE,
> +				  &submit);
> +	else
> +		tx = async_xor(sh->ppl_page, xor_srcs, 0, count, PAGE_SIZE,
> +			       &submit);
> +
> +	return tx;
> +}

Can you put this function to raid5-ppl.c? I'd like to keep all the log related
out raid5.c if possible.

Thanks,
Shaohua
