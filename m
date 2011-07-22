From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [md PATCH 10/34] md/raid5: unify stripe_head_state and r6_state
Date: Fri, 22 Jul 2011 13:49:37 +0900
Message-ID: <878vrqex7i.fsf@gmail.com>
References: <20110721022537.6728.90204.stgit@notabene.brown>
	<20110721023225.6728.40355.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721023225.6728.40355.stgit@notabene.brown> (NeilBrown's
	message of "Thu, 21 Jul 2011 12:32:25 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:

> 'struct stripe_head_state' stores state about the 'current' stripe
> that is passed around while handling the stripe.
> For RAID6 there is an extension structure: r6_state, which is also
> passed around.
> There is no value in keeping these separate, so move the fields from
> the latter into the former.
>
> This means that all code now needs to treat s->failed_num as an small
> array, but this is a small cost.
>
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>
>  drivers/md/raid5.c |   79 ++++++++++++++++++++++++++--------------------------
>  drivers/md/raid5.h |    8 +----
>  2 files changed, 41 insertions(+), 46 deletions(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index dfb3d9f..c32ffb5 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2318,7 +2318,7 @@ static int fetch_block5(struct stripe_head *sh, struct stripe_head_state *s,
>  			int disk_idx, int disks)
>  {
>  	struct r5dev *dev = &sh->dev[disk_idx];
> -	struct r5dev *failed_dev = &sh->dev[s->failed_num];
> +	struct r5dev *failed_dev = &sh->dev[s->failed_num[0]];
>  
>  	/* is the data in this block needed, and can we get it? */
>  	if (!test_bit(R5_LOCKED, &dev->flags) &&
> @@ -2334,7 +2334,7 @@ static int fetch_block5(struct stripe_head *sh, struct stripe_head_state *s,
>  		 * otherwise read it if the backing disk is insync
>  		 */
>  		if ((s->uptodate == disks - 1) &&
> -		    (s->failed && disk_idx == s->failed_num)) {
> +		    (s->failed && disk_idx == s->failed_num[0])) {
>  			set_bit(STRIPE_COMPUTE_RUN, &sh->state);
>  			set_bit(STRIPE_OP_COMPUTE_BLK, &s->ops_request);
>  			set_bit(R5_Wantcompute, &dev->flags);
> @@ -2388,11 +2388,11 @@ static void handle_stripe_fill5(struct stripe_head *sh,
>   * 0 to tell the loop in handle_stripe_fill6 to continue
>   */
>  static int fetch_block6(struct stripe_head *sh, struct stripe_head_state *s,
> -			 struct r6_state *r6s, int disk_idx, int disks)
> +			int disk_idx, int disks)
>  {
>  	struct r5dev *dev = &sh->dev[disk_idx];
> -	struct r5dev *fdev[2] = { &sh->dev[r6s->failed_num[0]],
> -				  &sh->dev[r6s->failed_num[1]] };
> +	struct r5dev *fdev[2] = { &sh->dev[s->failed_num[0]],
> +				  &sh->dev[s->failed_num[1]] };
>  
>  	if (!test_bit(R5_LOCKED, &dev->flags) &&
>  	    !test_bit(R5_UPTODATE, &dev->flags) &&
> @@ -2409,8 +2409,8 @@ static int fetch_block6(struct stripe_head *sh, struct stripe_head_state *s,
>  		BUG_ON(test_bit(R5_Wantcompute, &dev->flags));
>  		BUG_ON(test_bit(R5_Wantread, &dev->flags));
>  		if ((s->uptodate == disks - 1) &&
> -		    (s->failed && (disk_idx == r6s->failed_num[0] ||
> -				   disk_idx == r6s->failed_num[1]))) {
> +		    (s->failed && (disk_idx == s->failed_num[0] ||
> +				   disk_idx == s->failed_num[1]))) {
>  			/* have disk failed, and we're requested to fetch it;
>  			 * do compute it
>  			 */
> @@ -2465,7 +2465,7 @@ static int fetch_block6(struct stripe_head *sh, struct stripe_head_state *s,
>   * handle_stripe_fill6 - read or compute data to satisfy pending requests.
>   */
>  static void handle_stripe_fill6(struct stripe_head *sh,
> -			struct stripe_head_state *s, struct r6_state *r6s,
> +			struct stripe_head_state *s,
>  			int disks)
>  {
>  	int i;
> @@ -2477,7 +2477,7 @@ static void handle_stripe_fill6(struct stripe_head *sh,
>  	if (!test_bit(STRIPE_COMPUTE_RUN, &sh->state) && !sh->check_state &&
>  	    !sh->reconstruct_state)
>  		for (i = disks; i--; )
> -			if (fetch_block6(sh, s, r6s, i, disks))
> +			if (fetch_block6(sh, s, i, disks))
>  				break;
>  	set_bit(STRIPE_HANDLE, &sh->state);
>  }
> @@ -2625,7 +2625,7 @@ static void handle_stripe_dirtying5(raid5_conf_t *conf,
>  
>  static void handle_stripe_dirtying6(raid5_conf_t *conf,
>  		struct stripe_head *sh,	struct stripe_head_state *s,
> -		struct r6_state *r6s, int disks)
> +		int disks)
>  {
>  	int rcw = 0, pd_idx = sh->pd_idx, i;
>  	int qd_idx = sh->qd_idx;
> @@ -2688,7 +2688,7 @@ static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
>  			s->uptodate--;
>  			break;
>  		}
> -		dev = &sh->dev[s->failed_num];
> +		dev = &sh->dev[s->failed_num[0]];
>  		/* fall through */
>  	case check_state_compute_result:
>  		sh->check_state = check_state_idle;
> @@ -2760,7 +2760,7 @@ static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
>  
>  static void handle_parity_checks6(raid5_conf_t *conf, struct stripe_head *sh,
>  				  struct stripe_head_state *s,
> -				  struct r6_state *r6s, int disks)
> +				  int disks)
>  {
>  	int pd_idx = sh->pd_idx;
>  	int qd_idx = sh->qd_idx;
> @@ -2779,14 +2779,14 @@ static void handle_parity_checks6(raid5_conf_t *conf, struct stripe_head *sh,
>  	switch (sh->check_state) {
>  	case check_state_idle:
>  		/* start a new check operation if there are < 2 failures */
> -		if (s->failed == r6s->q_failed) {
> +		if (s->failed == s->q_failed) {
>  			/* The only possible failed device holds Q, so it
>  			 * makes sense to check P (If anything else were failed,
>  			 * we would have used P to recreate it).
>  			 */
>  			sh->check_state = check_state_run;
>  		}
> -		if (!r6s->q_failed && s->failed < 2) {
> +		if (!s->q_failed && s->failed < 2) {
>  			/* Q is not failed, and we didn't use it to generate
>  			 * anything, so it makes sense to check it
>  			 */
> @@ -2828,13 +2828,13 @@ static void handle_parity_checks6(raid5_conf_t *conf, struct stripe_head *sh,
>  		 */
>  		BUG_ON(s->uptodate < disks - 1); /* We don't need Q to recover */
>  		if (s->failed == 2) {
> -			dev = &sh->dev[r6s->failed_num[1]];
> +			dev = &sh->dev[s->failed_num[1]];
>  			s->locked++;
>  			set_bit(R5_LOCKED, &dev->flags);
>  			set_bit(R5_Wantwrite, &dev->flags);
>  		}
>  		if (s->failed >= 1) {
> -			dev = &sh->dev[r6s->failed_num[0]];
> +			dev = &sh->dev[s->failed_num[0]];
>  			s->locked++;
>  			set_bit(R5_LOCKED, &dev->flags);
>  			set_bit(R5_Wantwrite, &dev->flags);
> @@ -2922,7 +2922,7 @@ static void handle_parity_checks6(raid5_conf_t *conf, struct stripe_head *sh,
>  }
>  
>  static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
> -				struct r6_state *r6s)
> +				    struct stripe_head_state *r6s)
>  {
>  	int i;
>  
> @@ -2964,7 +2964,7 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
>  			set_bit(R5_UPTODATE, &sh2->dev[dd_idx].flags);
>  			for (j = 0; j < conf->raid_disks; j++)
>  				if (j != sh2->pd_idx &&
> -				    (!r6s || j != sh2->qd_idx) &&
> +				    (r6s || j != sh2->qd_idx) &&

Why is this changed?


>  				    !test_bit(R5_Expanded, &sh2->dev[j].flags))
>  					break;
>  			if (j == conf->raid_disks) {
> @@ -3082,7 +3082,7 @@ static void handle_stripe5(struct stripe_head *sh)
>  			clear_bit(R5_Insync, &dev->flags);
>  		if (!test_bit(R5_Insync, &dev->flags)) {
>  			s.failed++;
> -			s.failed_num = i;
> +			s.failed_num[0] = i;
>  		}
>  	}
>  	spin_unlock_irq(&conf->device_lock);
> @@ -3107,7 +3107,7 @@ static void handle_stripe5(struct stripe_head *sh)
>  	pr_debug("locked=%d uptodate=%d to_read=%d"
>  		" to_write=%d failed=%d failed_num=%d\n",
>  		s.locked, s.uptodate, s.to_read, s.to_write,
> -		s.failed, s.failed_num);
> +		s.failed, s.failed_num[0]);
>  	/* check if the array has lost two devices and, if so, some requests might
>  	 * need to be failed
>  	 */
> @@ -3127,7 +3127,7 @@ static void handle_stripe5(struct stripe_head *sh)
>  	     ((test_bit(R5_Insync, &dev->flags) &&
>  	       !test_bit(R5_LOCKED, &dev->flags) &&
>  	       test_bit(R5_UPTODATE, &dev->flags)) ||
> -	       (s.failed == 1 && s.failed_num == sh->pd_idx)))
> +	       (s.failed == 1 && s.failed_num[0] == sh->pd_idx)))
>  		handle_stripe_clean_event(conf, sh, disks, &return_bi);
>  
>  	/* Now we might consider reading some blocks, either to check/generate
> @@ -3198,11 +3198,11 @@ static void handle_stripe5(struct stripe_head *sh)
>  	 * the repair/check process
>  	 */
>  	if (s.failed == 1 && !conf->mddev->ro &&
> -	    test_bit(R5_ReadError, &sh->dev[s.failed_num].flags)
> -	    && !test_bit(R5_LOCKED, &sh->dev[s.failed_num].flags)
> -	    && test_bit(R5_UPTODATE, &sh->dev[s.failed_num].flags)
> +	    test_bit(R5_ReadError, &sh->dev[s.failed_num[0]].flags)
> +	    && !test_bit(R5_LOCKED, &sh->dev[s.failed_num[0]].flags)
> +	    && test_bit(R5_UPTODATE, &sh->dev[s.failed_num[0]].flags)
>  		) {
> -		dev = &sh->dev[s.failed_num];
> +		dev = &sh->dev[s.failed_num[0]];
>  		if (!test_bit(R5_ReWrite, &dev->flags)) {
>  			set_bit(R5_Wantwrite, &dev->flags);
>  			set_bit(R5_ReWrite, &dev->flags);
> @@ -3292,7 +3292,6 @@ static void handle_stripe6(struct stripe_head *sh)
>  	struct bio *return_bi = NULL;
>  	int i, pd_idx = sh->pd_idx, qd_idx = sh->qd_idx;
>  	struct stripe_head_state s;
> -	struct r6_state r6s;
>  	struct r5dev *dev, *pdev, *qdev;
>  	mdk_rdev_t *blocked_rdev = NULL;
>  	int dec_preread_active = 0;
> @@ -3370,7 +3369,7 @@ static void handle_stripe6(struct stripe_head *sh)
>  			clear_bit(R5_Insync, &dev->flags);
>  		if (!test_bit(R5_Insync, &dev->flags)) {
>  			if (s.failed < 2)
> -				r6s.failed_num[s.failed] = i;
> +				s.failed_num[s.failed] = i;
>  			s.failed++;
>  		}
>  	}
> @@ -3396,7 +3395,7 @@ static void handle_stripe6(struct stripe_head *sh)
>  	pr_debug("locked=%d uptodate=%d to_read=%d"
>  	       " to_write=%d failed=%d failed_num=%d,%d\n",
>  	       s.locked, s.uptodate, s.to_read, s.to_write, s.failed,
> -	       r6s.failed_num[0], r6s.failed_num[1]);
> +	       s.failed_num[0], s.failed_num[1]);
>  	/* check if the array has lost >2 devices and, if so, some requests
>  	 * might need to be failed
>  	 */
> @@ -3413,17 +3412,17 @@ static void handle_stripe6(struct stripe_head *sh)
>  	 * are safe, or on a failed drive
>  	 */
>  	pdev = &sh->dev[pd_idx];
> -	r6s.p_failed = (s.failed >= 1 && r6s.failed_num[0] == pd_idx)
> -		|| (s.failed >= 2 && r6s.failed_num[1] == pd_idx);
> +	s.p_failed = (s.failed >= 1 && s.failed_num[0] == pd_idx)
> +		|| (s.failed >= 2 && s.failed_num[1] == pd_idx);
>  	qdev = &sh->dev[qd_idx];
> -	r6s.q_failed = (s.failed >= 1 && r6s.failed_num[0] == qd_idx)
> -		|| (s.failed >= 2 && r6s.failed_num[1] == qd_idx);
> +	s.q_failed = (s.failed >= 1 && s.failed_num[0] == qd_idx)
> +		|| (s.failed >= 2 && s.failed_num[1] == qd_idx);
>  
> -	if ( s.written &&
> -	     ( r6s.p_failed || ((test_bit(R5_Insync, &pdev->flags)
> +	if (s.written &&
> +	    (s.p_failed || ((test_bit(R5_Insync, &pdev->flags)
>  			     && !test_bit(R5_LOCKED, &pdev->flags)
>  			     && test_bit(R5_UPTODATE, &pdev->flags)))) &&
> -	     ( r6s.q_failed || ((test_bit(R5_Insync, &qdev->flags)
> +	    (s.q_failed || ((test_bit(R5_Insync, &qdev->flags)
>  			     && !test_bit(R5_LOCKED, &qdev->flags)
>  			     && test_bit(R5_UPTODATE, &qdev->flags)))))
>  		handle_stripe_clean_event(conf, sh, disks, &return_bi);
> @@ -3434,7 +3433,7 @@ static void handle_stripe6(struct stripe_head *sh)
>  	 */
>  	if (s.to_read || s.non_overwrite || (s.to_write && s.failed) ||
>  	    (s.syncing && (s.uptodate + s.compute < disks)) || s.expanding)
> -		handle_stripe_fill6(sh, &s, &r6s, disks);
> +		handle_stripe_fill6(sh, &s, disks);
>  
>  	/* Now we check to see if any write operations have recently
>  	 * completed
> @@ -3472,7 +3471,7 @@ static void handle_stripe6(struct stripe_head *sh)
>  	 *    block.
>  	 */
>  	if (s.to_write && !sh->reconstruct_state && !sh->check_state)
> -		handle_stripe_dirtying6(conf, sh, &s, &r6s, disks);
> +		handle_stripe_dirtying6(conf, sh, &s, disks);
>  
>  	/* maybe we need to check and possibly fix the parity for this stripe
>  	 * Any reads will already have been scheduled, so we just see if enough
> @@ -3483,7 +3482,7 @@ static void handle_stripe6(struct stripe_head *sh)
>  	    (s.syncing && s.locked == 0 &&
>  	     !test_bit(STRIPE_COMPUTE_RUN, &sh->state) &&
>  	     !test_bit(STRIPE_INSYNC, &sh->state)))
> -		handle_parity_checks6(conf, sh, &s, &r6s, disks);
> +		handle_parity_checks6(conf, sh, &s, disks);
>  
>  	if (s.syncing && s.locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
>  		md_done_sync(conf->mddev, STRIPE_SECTORS,1);
> @@ -3495,7 +3494,7 @@ static void handle_stripe6(struct stripe_head *sh)
>  	 */
>  	if (s.failed <= 2 && !conf->mddev->ro)
>  		for (i = 0; i < s.failed; i++) {
> -			dev = &sh->dev[r6s.failed_num[i]];
> +			dev = &sh->dev[s.failed_num[i]];
>  			if (test_bit(R5_ReadError, &dev->flags)
>  			    && !test_bit(R5_LOCKED, &dev->flags)
>  			    && test_bit(R5_UPTODATE, &dev->flags)
> @@ -3557,7 +3556,7 @@ static void handle_stripe6(struct stripe_head *sh)
>  
>  	if (s.expanding && s.locked == 0 &&
>  	    !test_bit(STRIPE_COMPUTE_RUN, &sh->state))
> -		handle_stripe_expansion(conf, sh, &r6s);
> +		handle_stripe_expansion(conf, sh, &s);
>  
>   unlock:
>  
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index 217a9d4..d3c61d3 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -245,13 +245,9 @@ struct stripe_head_state {
>  	int syncing, expanding, expanded;
>  	int locked, uptodate, to_read, to_write, failed, written;
>  	int to_fill, compute, req_compute, non_overwrite;
> -	int failed_num;
> +	int failed_num[2];
>  	unsigned long ops_request;
> -};
> -
> -/* r6_state - extra state data only relevant to r6 */
> -struct r6_state {
> -	int p_failed, q_failed, failed_num[2];
> +	int p_failed, q_failed;
>  };
>  
>  /* Flags */
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
