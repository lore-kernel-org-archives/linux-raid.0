From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: [PATCH] md: make the code more readable in the for-loop
Date: Mon, 9 May 2016 09:33:39 +1000
Message-ID: <572FCCD3.4070907@eyal.emu.id.au>
References: <318e71b0.3d4e.1549071292b.Coremail.kernelpatch@126.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <318e71b0.3d4e.1549071292b.Coremail.kernelpatch@126.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I do not see how this change makes it clearer. The original form is actually a very common and clear
	scan an array in reverse order

Eyal

On 08/05/16 22:56, Tiezhu Yang wrote:
> This patch modifies raid1.c, raid10.c and raid5.c
> to make the code more readable in the for-loop
> and also fixes the scripts/checkpatch.pl error:
> ERROR: trailing statements should be on next line.
>
> Signed-off-by: Tiezhu Yang <kernelpatch@126.com>
> ---
>   drivers/md/raid1.c  |  6 +++---
>   drivers/md/raid10.c |  2 +-
>   drivers/md/raid5.c  | 59 +++++++++++++++++++++++++++--------------------------
>   3 files changed, 34 insertions(+), 33 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index a7f2b9c..760de56 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -109,7 +109,7 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
>   	/*
>   	 * Allocate bios : 1 for reading, n-1 for writing
>   	 */
> -	for (j = pi->raid_disks ; j-- ; ) {
> +	for (j = pi->raid_disks - 1; j >= 0; j--) {
>   		bio = bio_kmalloc(gfp_flags, RESYNC_PAGES);
>   		if (!bio)
>   			goto out_free_bio;
> @@ -166,7 +166,7 @@ static void r1buf_pool_free(void *__r1_bio, void *data)
>   	struct r1bio *r1bio = __r1_bio;
>
>   	for (i = 0; i < RESYNC_PAGES; i++)
> -		for (j = pi->raid_disks; j-- ;) {
> +		for (j = pi->raid_disks - 1; j >= 0; j--) {
>   			if (j == 0 ||
>   			    r1bio->bios[j]->bi_io_vec[i].bv_page !=
>   			    r1bio->bios[0]->bi_io_vec[i].bv_page)
> @@ -1976,7 +1976,7 @@ static void process_checks(struct r1bio *r1_bio)
>   		sbio->bi_error = 0;
>
>   		if (!error) {
> -			for (j = vcnt; j-- ; ) {
> +			for (j = vcnt - 1; j >= 0; j--) {
>   				struct page *p, *s;
>   				p = pbio->bi_io_vec[j].bv_page;
>   				s = sbio->bi_io_vec[j].bv_page;
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 84e24e6..52f1e07 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -157,7 +157,7 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
>   	/*
>   	 * Allocate bios.
>   	 */
> -	for (j = nalloc ; j-- ; ) {
> +	for (j = nalloc - 1; j >= 0; j--) {
>   		bio = bio_kmalloc(gfp_flags, RESYNC_PAGES);
>   		if (!bio)
>   			goto out_free_bio;
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 4d31b23..db978ab 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -536,7 +536,7 @@ retry:
>   	stripe_set_idx(sector, conf, previous, sh);
>   	sh->state = 0;
>
> -	for (i = sh->disks; i--; ) {
> +	for (i = sh->disks - 1; i >= 0; i--) {
>   		struct r5dev *dev = &sh->dev[i];
>
>   		if (dev->toread || dev->read || dev->towrite || dev->written ||
> @@ -890,7 +890,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
>
>   	if (r5l_write_stripe(conf->log, sh) == 0)
>   		return;
> -	for (i = disks; i--; ) {
> +	for (i = disks - 1; i >= 0; i--) {
>   		int rw;
>   		int replace_only = 0;
>   		struct bio *bi, *rbi;
> @@ -1175,7 +1175,7 @@ static void ops_complete_biofill(void *stripe_head_ref)
>   		(unsigned long long)sh->sector);
>
>   	/* clear completed biofills */
> -	for (i = sh->disks; i--; ) {
> +	for (i = sh->disks - 1; i >= 0; i--) {
>   		struct r5dev *dev = &sh->dev[i];
>
>   		/* acknowledge completion of a biofill operation */
> @@ -1216,7 +1216,7 @@ static void ops_run_biofill(struct stripe_head *sh)
>   	pr_debug("%s: stripe %llu\n", __func__,
>   		(unsigned long long)sh->sector);
>
> -	for (i = sh->disks; i--; ) {
> +	for (i = sh->disks - 1; i >= 0; i--) {
>   		struct r5dev *dev = &sh->dev[i];
>   		if (test_bit(R5_Wantfill, &dev->flags)) {
>   			struct bio *rbi;
> @@ -1307,7 +1307,7 @@ ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
>   		__func__, (unsigned long long)sh->sector, target);
>   	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
>
> -	for (i = disks; i--; )
> +	for (i = disks - 1; i >= 0; i--)
>   		if (i != target)
>   			xor_srcs[count++] = sh->dev[i].page;
>
> @@ -1407,7 +1407,7 @@ ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
>   	} else {
>   		/* Compute any data- or p-drive using XOR */
>   		count = 0;
> -		for (i = disks; i-- ; ) {
> +		for (i = disks - 1; i >= 0; i--) {
>   			if (i == target || i == qd_idx)
>   				continue;
>   			blocks[count++] = sh->dev[i].page;
> @@ -1492,7 +1492,7 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
>   				data_target = target;
>
>   			count = 0;
> -			for (i = disks; i-- ; ) {
> +			for (i = disks - 1; i >= 0; i--) {
>   				if (i == data_target || i == qd_idx)
>   					continue;
>   				blocks[count++] = sh->dev[i].page;
> @@ -1554,7 +1554,7 @@ ops_run_prexor5(struct stripe_head *sh, struct raid5_percpu *percpu,
>   	pr_debug("%s: stripe %llu\n", __func__,
>   		(unsigned long long)sh->sector);
>
> -	for (i = disks; i--; ) {
> +	for (i = disks - 1; i >= 0; i--) {
>   		struct r5dev *dev = &sh->dev[i];
>   		/* Only process blocks that are known to be uptodate */
>   		if (test_bit(R5_Wantdrain, &dev->flags))
> @@ -1598,7 +1598,7 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
>   	pr_debug("%s: stripe %llu\n", __func__,
>   		(unsigned long long)sh->sector);
>
> -	for (i = disks; i--; ) {
> +	for (i = disks - 1; i >= 0; i--) {
>   		struct r5dev *dev;
>   		struct bio *chosen;
>
> @@ -1663,13 +1663,13 @@ static void ops_complete_reconstruct(void *stripe_head_ref)
>   	pr_debug("%s: stripe %llu\n", __func__,
>   		(unsigned long long)sh->sector);
>
> -	for (i = disks; i--; ) {
> +	for (i = disks - 1; i >= 0; i--) {
>   		fua |= test_bit(R5_WantFUA, &sh->dev[i].flags);
>   		sync |= test_bit(R5_SyncIO, &sh->dev[i].flags);
>   		discard |= test_bit(R5_Discard, &sh->dev[i].flags);
>   	}
>
> -	for (i = disks; i--; ) {
> +	for (i = disks - 1; i >= 0; i--) {
>   		struct r5dev *dev = &sh->dev[i];
>
>   		if (dev->written || i == pd_idx || i == qd_idx) {
> @@ -1734,14 +1734,14 @@ again:
>   	if (head_sh->reconstruct_state == reconstruct_state_prexor_drain_run) {
>   		prexor = 1;
>   		xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
> -		for (i = disks; i--; ) {
> +		for (i = disks - 1; i >= 0; i--) {
>   			struct r5dev *dev = &sh->dev[i];
>   			if (head_sh->dev[i].written)
>   				xor_srcs[count++] = dev->page;
>   		}
>   	} else {
>   		xor_dest = sh->dev[pd_idx].page;
> -		for (i = disks; i--; ) {
> +		for (i = disks - 1; i >= 0; i--) {
>   			struct r5dev *dev = &sh->dev[i];
>   			if (i != pd_idx)
>   				xor_srcs[count++] = dev->page;
> @@ -1872,7 +1872,7 @@ static void ops_run_check_p(struct stripe_head *sh, struct raid5_percpu *percpu)
>   	count = 0;
>   	xor_dest = sh->dev[pd_idx].page;
>   	xor_srcs[count++] = xor_dest;
> -	for (i = disks; i--; ) {
> +	for (i = disks - 1; i >= 0; i--) {
>   		if (i == pd_idx || i == qd_idx)
>   			continue;
>   		xor_srcs[count++] = sh->dev[i].page;
> @@ -1970,7 +1970,7 @@ static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
>   	}
>
>   	if (overlap_clear && !sh->batch_head)
> -		for (i = disks; i--; ) {
> +		for (i = disks - 1; i >= 0; i--) {
>   			struct r5dev *dev = &sh->dev[i];
>   			if (test_and_clear_bit(R5_Overlap, &dev->flags))
>   				wake_up(&sh->raid_conf->wait_for_overlap);
> @@ -2861,7 +2861,7 @@ schedule_reconstruction(struct stripe_head *sh, struct stripe_head_state *s,
>
>   	if (rcw) {
>
> -		for (i = disks; i--; ) {
> +		for (i = disks - 1; i >= 0; i--) {
>   			struct r5dev *dev = &sh->dev[i];
>
>   			if (dev->towrite) {
> @@ -2897,7 +2897,7 @@ schedule_reconstruction(struct stripe_head *sh, struct stripe_head_state *s,
>   			(!(test_bit(R5_UPTODATE, &sh->dev[qd_idx].flags) ||
>   			   test_bit(R5_Wantcompute, &sh->dev[qd_idx].flags))));
>
> -		for (i = disks; i--; ) {
> +		for (i = disks - 1; i >= 0; i--) {
>   			struct r5dev *dev = &sh->dev[i];
>   			if (i == pd_idx || i == qd_idx)
>   				continue;
> @@ -3072,7 +3072,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
>   {
>   	int i;
>   	BUG_ON(sh->batch_head);
> -	for (i = disks; i--; ) {
> +	for (i = disks - 1; i >= 0; i--) {
>   		struct bio *bi;
>   		int bitmap_end = 0;
>
> @@ -3386,7 +3386,7 @@ static int fetch_block(struct stripe_head *sh, struct stripe_head_state *s,
>   			 * do it if failed >= 2
>   			 */
>   			int other;
> -			for (other = disks; other--; ) {
> +			for (other = disks - 1; other >= 0; other--) {
>   				if (other == disk_idx)
>   					continue;
>   				if (!test_bit(R5_UPTODATE,
> @@ -3433,7 +3433,7 @@ static void handle_stripe_fill(struct stripe_head *sh,
>   	 */
>   	if (!test_bit(STRIPE_COMPUTE_RUN, &sh->state) && !sh->check_state &&
>   	    !sh->reconstruct_state)
> -		for (i = disks; i--; )
> +		for (i = disks - 1; i >= 0; i--)
>   			if (fetch_block(sh, s, i, disks))
>   				break;
>   	set_bit(STRIPE_HANDLE, &sh->state);
> @@ -3455,7 +3455,7 @@ static void handle_stripe_clean_event(struct r5conf *conf,
>   	struct stripe_head *head_sh = sh;
>   	bool do_endio = false;
>
> -	for (i = disks; i--; )
> +	for (i = disks - 1; i >= 0; i--)
>   		if (sh->dev[i].written) {
>   			dev = &sh->dev[i];
>   			if (!test_bit(R5_LOCKED, &dev->flags) &&
> @@ -3573,7 +3573,8 @@ static void handle_stripe_dirtying(struct r5conf *conf,
>   		pr_debug("force RCW rmw_level=%u, recovery_cp=%llu sh->sector=%llu\n",
>   			 conf->rmw_level, (unsigned long long)recovery_cp,
>   			 (unsigned long long)sh->sector);
> -	} else for (i = disks; i--; ) {
> +	} else
> +	for (i = disks - 1; i >= 0; i--) {
>   		/* would I have to read this buffer for read_modify_write */
>   		struct r5dev *dev = &sh->dev[i];
>   		if ((dev->towrite || i == sh->pd_idx || i == sh->qd_idx) &&
> @@ -3606,7 +3607,7 @@ static void handle_stripe_dirtying(struct r5conf *conf,
>   			blk_add_trace_msg(conf->mddev->queue,
>   					  "raid5 rmw %llu %d",
>   					  (unsigned long long)sh->sector, rmw);
> -		for (i = disks; i--; ) {
> +		for (i = disks - 1; i >= 0; i--) {
>   			struct r5dev *dev = &sh->dev[i];
>   			if ((dev->towrite || i == sh->pd_idx || i == sh->qd_idx) &&
>   			    !test_bit(R5_LOCKED, &dev->flags) &&
> @@ -3631,7 +3632,7 @@ static void handle_stripe_dirtying(struct r5conf *conf,
>   		/* want reconstruct write, but need to get some data */
>   		int qread =0;
>   		rcw = 0;
> -		for (i = disks; i--; ) {
> +		for (i = disks - 1; i >= 0; i--) {
>   			struct r5dev *dev = &sh->dev[i];
>   			if (!test_bit(R5_OVERWRITE, &dev->flags) &&
>   			    i != sh->pd_idx && i != sh->qd_idx &&
> @@ -4021,7 +4022,7 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
>
>   	/* Now to look around and see what can be done */
>   	rcu_read_lock();
> -	for (i=disks; i--; ) {
> +	for (i = disks - 1; i >= 0; i--) {
>   		struct md_rdev *rdev;
>   		sector_t first_bad;
>   		int bad_sectors;
> @@ -4391,7 +4392,7 @@ static void handle_stripe(struct stripe_head *sh)
>   		BUG_ON(sh->qd_idx >= 0 &&
>   		       !test_bit(R5_UPTODATE, &sh->dev[sh->qd_idx].flags) &&
>   		       !test_bit(R5_Discard, &sh->dev[sh->qd_idx].flags));
> -		for (i = disks; i--; ) {
> +		for (i = disks - 1; i >= 0; i--) {
>   			struct r5dev *dev = &sh->dev[i];
>   			if (test_bit(R5_LOCKED, &dev->flags) &&
>   				(i == sh->pd_idx || i == sh->qd_idx ||
> @@ -4539,7 +4540,7 @@ static void handle_stripe(struct stripe_head *sh)
>
>   		sh->reconstruct_state = reconstruct_state_idle;
>   		clear_bit(STRIPE_EXPANDING, &sh->state);
> -		for (i = conf->raid_disks; i--; ) {
> +		for (i = conf->raid_disks - 1; i >= 0; i--) {
>   			set_bit(R5_Wantwrite, &sh->dev[i].flags);
>   			set_bit(R5_LOCKED, &sh->dev[i].flags);
>   			s.locked++;
> @@ -4579,7 +4580,7 @@ finish:
>   	}
>
>   	if (s.handle_bad_blocks)
> -		for (i = disks; i--; ) {
> +		for (i = disks - 1; i >= 0; i--) {
>   			struct md_rdev *rdev;
>   			struct r5dev *dev = &sh->dev[i];
>   			if (test_and_clear_bit(R5_WriteError, &dev->flags)) {
> @@ -5486,7 +5487,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
>   		/* If any of this stripe is beyond the end of the old
>   		 * array, then we need to zero those blocks
>   		 */
> -		for (j=sh->disks; j--;) {
> +		for (j = sh->disks - 1; j >= 0; j--) {
>   			sector_t s;
>   			if (j == sh->pd_idx)
>   				continue;
>

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
