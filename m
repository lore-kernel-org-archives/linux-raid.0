From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v5 3/7] raid5-ppl: Partial Parity Log write logging
 implementation
Date: Thu, 9 Mar 2017 15:24:51 -0800
Message-ID: <20170309232451.4hw2pgizn7potlrj@kernel.org>
References: <20170309090003.13298-1-artur.paszkiewicz@intel.com>
 <20170309090003.13298-4-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170309090003.13298-4-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: shli@fb.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Mar 09, 2017 at 09:59:59AM +0100, Artur Paszkiewicz wrote:
> Implement the calculation of partial parity for a stripe and PPL write
> logging functionality. The description of PPL is added to the
> documentation. More details can be found in the comments in raid5-ppl.c.
> 
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
> Put the PPL metadata structures to md_p.h because userspace tools
> (mdadm) will also need to read/write PPL.
> 
> Warn about using PPL with enabled disk volatile write-back cache for
> now. It can be removed once disk cache flushing before writing PPL is
> implemented.
> 
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>

... snip ...

> +struct dma_async_tx_descriptor *
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

Since this should be done before biodrain, should this add ASYNC_TX_FENCE flag?

Thanks,
Shaohua
