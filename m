From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 2/8] md/raid6: asynchronous raid6 operations
Date: Thu, 4 Jun 2009 16:33:26 +1000
Message-ID: <18983.27318.515651.789748@notabene.brown>
References: <20090604012709.11507.15528.stgit@dwillia2-linux.ch.intel.com>
	<20090604012908.11507.99162.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Wednesday June 3
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>, Ilya Yanok <yanok@emcraft.com>, Yuri Tikhonov <yur@emcraft.com>
List-Id: linux-raid.ids

On Wednesday June 3, dan.j.williams@intel.com wrote:
> [ Based on an original patch by Yuri Tikhonov ]
> 
> The raid_run_ops routine uses the asynchronous offload api and
> the stripe_operations member of a stripe_head to carry out xor+pq+copy
> operations asynchronously, outside the lock.
> 
> The operations performed by RAID-6 are the same as in the RAID-5 case
> except for no support of STRIPE_OP_PREXOR operations. All the others
> are supported:
> STRIPE_OP_BIOFILL
>  - copy data into request buffers to satisfy a read request
> STRIPE_OP_COMPUTE_BLK
>  - generate missing blocks (1 or 2) in the cache from the other blocks
> STRIPE_OP_BIODRAIN
>  - copy data out of request buffers to satisfy a write request
> STRIPE_OP_RECONSTRUCT
>  - recalculate parity for new data that has entered the cache
> STRIPE_OP_CHECK
>  - verify that the parity is correct
> 
> The flow is the same as in the RAID-5 case, and reuses some routines, namely:
> 1/ ops_complete_postxor (renamed to ops_complete_reconstruct)
> 2/ ops_complete_compute (updated to set up to 2 targets uptodate)
> 3/ ops_run_check (renamed to ops_run_check_p for xor parity checks)
> 
...
> +static struct dma_async_tx_descriptor *
> +ops_run_compute6_1(struct stripe_head *sh)
> +{
> +	int disks = sh->disks;
> +	struct page **blocks = sh->scribble;
> +	int target;
> +	int qd_idx = sh->qd_idx;
> +	struct dma_async_tx_descriptor *tx;
> +	struct async_submit_ctl submit;
> +	struct r5dev *tgt;
> +	struct page *dest;
> +	int i;
> +	int count;
> +
> +	if (sh->ops.target < 0)
> +		target = sh->ops.target2;
> +	else if (sh->ops.target2 < 0)
> +		target = sh->ops.target;
> +	else
> +		/* we should only have one valid target */
> +		BUG();
> +	BUG_ON(target < 0);

This looks wrong.
It seems to suggest that target2 can be >=0 while target < 0
and I don't think it can.  So while the code won't actually
malfunction, it is misleading.
Can we just have
    target = sh->ops.target;
    BUG_ON(target < 0);
    BUG_ON(sh->ops.target2 >= 0);
??

> @@ -926,9 +1166,16 @@ static void raid5_run_ops(struct stripe_head *sh, unsigned long ops_request)
>  	}
>  
>  	if (test_bit(STRIPE_OP_COMPUTE_BLK, &ops_request)) {
> -		tx = ops_run_compute5(sh);
> -		/* terminate the chain if postxor is not set to be run */
> -		if (tx && !test_bit(STRIPE_OP_POSTXOR, &ops_request))
> +		if (level < 6)
> +			tx = ops_run_compute5(sh);
> +		else {
> +			if (sh->ops.target2 < 0 || sh->ops.target < 0)
> +				tx = ops_run_compute6_1(sh);
> +			else
> +				tx = ops_run_compute6_2(sh);
> +		}

Similarly here.
  if (sh->ops.target2 >= 0)
	tx = ops_run_compute6_2(sh);
  else
        tx = ops_run_compute6_1(sh);

And if you add the "count == 1" branch to ops_run_compute6_1,
I think you can use it in place of ops_run_compute5.  Then you get
ride of a function, and the above nested ifs becomes a simple:

  if (sh->ops.target2 >= 0)
	tx = ops_run_compute6_2(sh);
  else
        tx = ops_run_compute_1(sh);

no need to check the level at all.
Would that be an improvement?
??

NeilBrown
