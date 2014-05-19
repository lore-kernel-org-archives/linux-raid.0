From: Shaohua Li <shli@kernel.org>
Subject: Re: [RFC]raid5: adjust operation order of handle_stripe
Date: Mon, 19 May 2014 10:21:17 +0800
Message-ID: <20140519022117.GA1644@kernel.org>
References: <20140512011659.GA13135@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140512011659.GA13135@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

Ping!

On Mon, May 12, 2014 at 09:16:59AM +0800, Shaohua Li wrote:
> 
> For a full stripe write, the ideal operation order is handle_stripe_dirtying(),
> raid_run_ops(), set R5_Wantwrite bit, and ops_run_io(). In this way, one
> handle_stripe() will dispatch IO for the stripe, otherwise there are more extra
> rounds of handle_stripe(). In a high speed raid5 array, handle_stripe()
> consumes considered cpu time. Reducing its overhead has around 10% performance
> boost.
> 
> This patch makes handle_stripe() operations follow the ideal order. It also
> moves handle_stripe_clean_event() up, as it handles completed stripe. And if I
> don't change handle_stripe_clean_event() order, I saw some states confused with
> other changes.
> 
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/raid5.c |   39 +++++++++++++++++++++------------------
>  1 file changed, 21 insertions(+), 18 deletions(-)
> 
> Index: linux/drivers/md/raid5.c
> ===================================================================
> --- linux.orig/drivers/md/raid5.c	2014-05-06 17:19:13.868225752 +0800
> +++ linux/drivers/md/raid5.c	2014-05-06 17:20:25.367326852 +0800
> @@ -1633,7 +1633,7 @@ static void ops_run_check_pq(struct stri
>  			   &sh->ops.zero_sum_result, percpu->spare_page, &submit);
>  }
>  
> -static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
> +static void raid_run_ops(struct stripe_head *sh, unsigned long *ops_request)
>  {
>  	int overlap_clear = 0, i, disks = sh->disks;
>  	struct dma_async_tx_descriptor *tx = NULL;
> @@ -1644,12 +1644,12 @@ static void raid_run_ops(struct stripe_h
>  
>  	cpu = get_cpu();
>  	percpu = per_cpu_ptr(conf->percpu, cpu);
> -	if (test_bit(STRIPE_OP_BIOFILL, &ops_request)) {
> +	if (test_and_clear_bit(STRIPE_OP_BIOFILL, ops_request)) {
>  		ops_run_biofill(sh);
>  		overlap_clear++;
>  	}
>  
> -	if (test_bit(STRIPE_OP_COMPUTE_BLK, &ops_request)) {
> +	if (test_and_clear_bit(STRIPE_OP_COMPUTE_BLK, ops_request)) {
>  		if (level < 6)
>  			tx = ops_run_compute5(sh, percpu);
>  		else {
> @@ -1659,26 +1659,26 @@ static void raid_run_ops(struct stripe_h
>  				tx = ops_run_compute6_2(sh, percpu);
>  		}
>  		/* terminate the chain if reconstruct is not set to be run */
> -		if (tx && !test_bit(STRIPE_OP_RECONSTRUCT, &ops_request))
> +		if (tx && !test_and_clear_bit(STRIPE_OP_RECONSTRUCT, ops_request))
>  			async_tx_ack(tx);
>  	}
>  
> -	if (test_bit(STRIPE_OP_PREXOR, &ops_request))
> +	if (test_and_clear_bit(STRIPE_OP_PREXOR, ops_request))
>  		tx = ops_run_prexor(sh, percpu, tx);
>  
> -	if (test_bit(STRIPE_OP_BIODRAIN, &ops_request)) {
> +	if (test_and_clear_bit(STRIPE_OP_BIODRAIN, ops_request)) {
>  		tx = ops_run_biodrain(sh, tx);
>  		overlap_clear++;
>  	}
>  
> -	if (test_bit(STRIPE_OP_RECONSTRUCT, &ops_request)) {
> +	if (test_and_clear_bit(STRIPE_OP_RECONSTRUCT, ops_request)) {
>  		if (level < 6)
>  			ops_run_reconstruct5(sh, percpu, tx);
>  		else
>  			ops_run_reconstruct6(sh, percpu, tx);
>  	}
>  
> -	if (test_bit(STRIPE_OP_CHECK, &ops_request)) {
> +	if (test_and_clear_bit(STRIPE_OP_CHECK, ops_request)) {
>  		if (sh->check_state == check_state_run)
>  			ops_run_check_p(sh, percpu);
>  		else if (sh->check_state == check_state_run_q)
> @@ -3780,6 +3780,41 @@ static void handle_stripe(struct stripe_
>  			handle_failed_sync(conf, sh, &s);
>  	}
>  
> +	/*
> +	 * might be able to return some write requests if the parity blocks
> +	 * are safe, or on a failed drive
> +	 */
> +	pdev = &sh->dev[sh->pd_idx];
> +	s.p_failed = (s.failed >= 1 && s.failed_num[0] == sh->pd_idx)
> +		|| (s.failed >= 2 && s.failed_num[1] == sh->pd_idx);
> +	qdev = &sh->dev[sh->qd_idx];
> +	s.q_failed = (s.failed >= 1 && s.failed_num[0] == sh->qd_idx)
> +		|| (s.failed >= 2 && s.failed_num[1] == sh->qd_idx)
> +		|| conf->level < 6;
> +
> +	if (s.written &&
> +	    (s.p_failed || ((test_bit(R5_Insync, &pdev->flags)
> +			     && !test_bit(R5_LOCKED, &pdev->flags)
> +			     && (test_bit(R5_UPTODATE, &pdev->flags) ||
> +				 test_bit(R5_Discard, &pdev->flags))))) &&
> +	    (s.q_failed || ((test_bit(R5_Insync, &qdev->flags)
> +			     && !test_bit(R5_LOCKED, &qdev->flags)
> +			     && (test_bit(R5_UPTODATE, &qdev->flags) ||
> +				 test_bit(R5_Discard, &qdev->flags))))))
> +		handle_stripe_clean_event(conf, sh, disks, &s.return_bi);
> +
> +	/* Now to consider new write requests and what else, if anything
> +	 * should be read.  We do not handle new writes when:
> +	 * 1/ A 'write' operation (copy+xor) is already in flight.
> +	 * 2/ A 'check' operation is in flight, as it may clobber the parity
> +	 *    block.
> +	 */
> +	if (s.to_write && !sh->reconstruct_state && !sh->check_state)
> +		handle_stripe_dirtying(conf, sh, &s, disks);
> +
> +	if (s.ops_request)
> +		raid_run_ops(sh, &s.ops_request);
> +
>  	/* Now we check to see if any write operations have recently
>  	 * completed
>  	 */
> @@ -3817,29 +3852,6 @@ static void handle_stripe(struct stripe_
>  			s.dec_preread_active = 1;
>  	}
>  
> -	/*
> -	 * might be able to return some write requests if the parity blocks
> -	 * are safe, or on a failed drive
> -	 */
> -	pdev = &sh->dev[sh->pd_idx];
> -	s.p_failed = (s.failed >= 1 && s.failed_num[0] == sh->pd_idx)
> -		|| (s.failed >= 2 && s.failed_num[1] == sh->pd_idx);
> -	qdev = &sh->dev[sh->qd_idx];
> -	s.q_failed = (s.failed >= 1 && s.failed_num[0] == sh->qd_idx)
> -		|| (s.failed >= 2 && s.failed_num[1] == sh->qd_idx)
> -		|| conf->level < 6;
> -
> -	if (s.written &&
> -	    (s.p_failed || ((test_bit(R5_Insync, &pdev->flags)
> -			     && !test_bit(R5_LOCKED, &pdev->flags)
> -			     && (test_bit(R5_UPTODATE, &pdev->flags) ||
> -				 test_bit(R5_Discard, &pdev->flags))))) &&
> -	    (s.q_failed || ((test_bit(R5_Insync, &qdev->flags)
> -			     && !test_bit(R5_LOCKED, &qdev->flags)
> -			     && (test_bit(R5_UPTODATE, &qdev->flags) ||
> -				 test_bit(R5_Discard, &qdev->flags))))))
> -		handle_stripe_clean_event(conf, sh, disks, &s.return_bi);
> -
>  	/* Now we might consider reading some blocks, either to check/generate
>  	 * parity, or to satisfy requests
>  	 * or to load a block that is being partially written.
> @@ -3851,15 +3863,6 @@ static void handle_stripe(struct stripe_
>  	    || s.expanding)
>  		handle_stripe_fill(sh, &s, disks);
>  
> -	/* Now to consider new write requests and what else, if anything
> -	 * should be read.  We do not handle new writes when:
> -	 * 1/ A 'write' operation (copy+xor) is already in flight.
> -	 * 2/ A 'check' operation is in flight, as it may clobber the parity
> -	 *    block.
> -	 */
> -	if (s.to_write && !sh->reconstruct_state && !sh->check_state)
> -		handle_stripe_dirtying(conf, sh, &s, disks);
> -
>  	/* maybe we need to check and possibly fix the parity for this stripe
>  	 * Any reads will already have been scheduled, so we just see if enough
>  	 * data is available.  The parity check is held off while parity
> @@ -4014,7 +4017,7 @@ finish:
>  		}
>  
>  	if (s.ops_request)
> -		raid_run_ops(sh, s.ops_request);
> +		raid_run_ops(sh, &s.ops_request);
>  
>  	ops_run_io(sh, &s);
>  
