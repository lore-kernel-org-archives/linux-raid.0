From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH v2 2/9] md/raid6: asynchronous raid6 operations
Date: Tue, 15 Sep 2009 15:32:41 +1000
Message-ID: <19119.9977.918785.459683@notabene.brown>
References: <20090831163914.1696.55782.stgit@dwillia2-linux.ch.intel.com>
	<20090831164114.1696.62367.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Monday August 31
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>, Ilya Yanok <yanok@emcraft.com>, Yuri Tikhonov <yur@emcraft.com>
List-Id: linux-raid.ids


And just some tiny things in this patch....

>  
> +/* set_syndrome_sources - populate source buffers for gen_syndrome
> + * @srcs - (struct page *) array of size sh->disks
> + * @sh - stripe_head to parse
> + *
> + * Populates srcs in proper layout order for the stripe and returns the
> + * 'count' of sources to be used in a call to async_gen_syndrome.  The P
> + * destination buffer is recorded in srcs[count] and the Q destination
> + * is recorded in srcs[count+1]].
                                  ^  extra ']'

> + */


> +
> +static struct dma_async_tx_descriptor *
> +ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
> +{
> +	int i, count, disks = sh->disks;
> +	int syndrome_disks = sh->ddf_layout ? disks : disks-2;
> +	int d0_idx = raid6_d0(sh);
> +	int faila = -1, failb = -1;
> +	int target = sh->ops.target;
> +	int target2 = sh->ops.target2;
> +	struct r5dev *tgt = &sh->dev[target];
> +	struct r5dev *tgt2 = &sh->dev[target2];
> +	struct dma_async_tx_descriptor *tx;
> +	struct page **blocks = percpu->scribble;
> +	struct async_submit_ctl submit;
> +
> +	pr_debug("%s: stripe %llu block1: %d block2: %d\n",
> +		 __func__, (unsigned long long)sh->sector, target, target2);
> +	BUG_ON(target < 0 || target2 < 0);
> +	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
> +	BUG_ON(!test_bit(R5_Wantcompute, &tgt2->flags));
> +
> +	/* we need to open-code set_syndrome_sources to handle to the
                                                               ^^
remove the 'to'.

> +	 * slot number conversion for 'faila' and 'failb'
> +	 */
> +	for (i = 0; i < disks ; i++)
> +		blocks[i] = (void *)raid6_empty_zero_page;
> +	count = 0;
> +	i = d0_idx;
> +	do {
> +		int slot = raid6_idx_to_slot(i, sh, &count, syndrome_disks);
> +
> +		blocks[slot] = sh->dev[i].page;
> +
> +		if (i == target)
> +			faila = slot;
> +		if (i == target2)
> +			failb = slot;
> +		i = raid6_next_disk(i, disks);
> +	} while (i != d0_idx);
> +	BUG_ON(count != syndrome_disks);
> +
> +	BUG_ON(faila == failb);
> +	if (failb < faila)
> +		swap(faila, failb);
> +	pr_debug("%s: stripe: %llu faila: %d failb: %d\n",
> +		 __func__, (unsigned long long)sh->sector, faila, failb);
> +
> +	atomic_inc(&sh->count);
> +
> +	if (failb == syndrome_disks+1) {
> +		/* Q disk is one of the missing disks */
> +		if (faila == syndrome_disks) {
> +			/* Missing P+Q, just recompute */
> +			init_async_submit(&submit, 0, NULL, ops_complete_compute,
> +					  sh, to_addr_conv(sh, percpu));
> +			return async_gen_syndrome(blocks, 0, count+2,
> +						  STRIPE_SIZE, &submit);
> +		} else {
....
> +			init_async_submit(&submit, 0, tx, ops_complete_compute,
> +					  sh, to_addr_conv(sh, percpu));
> +			return async_gen_syndrome(blocks, 0, count+2,
> +						  STRIPE_SIZE, &submit);
> +		}
> +	}

Can we have an ' else { ' here? extending down to....

> +
> +	init_async_submit(&submit, 0, NULL, ops_complete_compute, sh,
> +			  to_addr_conv(sh, percpu));
> +	if (failb == syndrome_disks) {
> +		/* We're missing D+P. */
> +		return async_raid6_datap_recov(syndrome_disks+2, STRIPE_SIZE,
> +					       faila, blocks, &submit);
> +	} else {
> +		/* We're missing D+D. */
> +		return async_raid6_2data_recov(syndrome_disks+2, STRIPE_SIZE,
> +					       faila, failb, blocks, &submit);
> +	}

... here please.  It is correct as it stands, but the fact that every
branch in the 'if' part ends with a 'return' isn't immediately
obvious, so it is clearer if we are explicit about the 
 if / then / else
structure.

Thanks,
NeilBrown
