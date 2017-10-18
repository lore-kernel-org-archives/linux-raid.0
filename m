From: Shaohua Li <shli@kernel.org>
Subject: Re: [md PATCH 3/5] md: move suspend_hi/lo handling into core md code
Date: Tue, 17 Oct 2017 23:16:20 -0700
Message-ID: <20171018061620.alka3npi6pyd76py@kernel.org>
References: <150820826980.1646.6380214598725492144.stgit@noble>
 <150820840349.1646.9916811766142195995.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <150820840349.1646.9916811766142195995.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 17, 2017 at 01:46:43PM +1100, Neil Brown wrote:
> responding to ->suspend_lo and ->suspend_hi is similar
> to responding to ->suspended.  It is best to wait in
> the common core code without incrementing ->active_io.
> This allows mddev_suspend()/mddev_resume() to work while
> requests are waiting for suspend_lo/hi to change.
> This is will be important after a subsequent patch
> which uses mddev_suspend() to synchronize updating for
> suspend_lo/hi.
> 
> So move the code for testing suspend_lo/hi out of raid1.c
> and raid5.c, and place it in md.c
> 
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  drivers/md/md.c    |   29 +++++++++++++++++++++++------
>  drivers/md/raid1.c |   12 ++++--------
>  drivers/md/raid5.c |   22 ----------------------
>  3 files changed, 27 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 308456842d3e..f8d0e41120cb 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -266,16 +266,31 @@ static DEFINE_SPINLOCK(all_mddevs_lock);
>   * call has finished, the bio has been linked into some internal structure
>   * and so is visible to ->quiesce(), so we don't need the refcount any more.
>   */
> +static bool is_suspended(struct mddev *mddev, struct bio *bio)
> +{
> +	if (mddev->suspended)
> +		return true;
> +	if (bio_data_dir(bio) != WRITE)
> +		return false;
> +	if (mddev->suspend_lo >= mddev->suspend_hi)
> +		return false;
> +	if (bio->bi_iter.bi_sector >= mddev->suspend_hi)
> +		return false;
> +	if (bio_end_sector(bio) < mddev->suspend_lo)
> +		return false;
> +	return true;
> +}
> +
>  void md_handle_request(struct mddev *mddev, struct bio *bio)
>  {
>  check_suspended:
>  	rcu_read_lock();
> -	if (mddev->suspended) {
> +	if (is_suspended(mddev, bio)) {
>  		DEFINE_WAIT(__wait);
>  		for (;;) {
>  			prepare_to_wait(&mddev->sb_wait, &__wait,
>  					TASK_UNINTERRUPTIBLE);
> -			if (!mddev->suspended)
> +			if (!is_suspended(mddev, bio))
>  				break;
>  			rcu_read_unlock();
>  			schedule();
> @@ -4843,10 +4858,11 @@ suspend_lo_store(struct mddev *mddev, const char *buf, size_t len)
>  		goto unlock;
>  	old = mddev->suspend_lo;
>  	mddev->suspend_lo = new;
> -	if (new >= old)
> +	if (new >= old) {
>  		/* Shrinking suspended region */
> +		wake_up(&mddev->sb_wait);
>  		mddev->pers->quiesce(mddev, 2);

Do we still need the quiesce(mddev, 2)? sounds not to me.

> -	else {
> +	} else {
>  		/* Expanding suspended region - need to wait */
>  		mddev->pers->quiesce(mddev, 1);
>  		mddev->pers->quiesce(mddev, 0);
> @@ -4886,10 +4902,11 @@ suspend_hi_store(struct mddev *mddev, const char *buf, size_t len)
>  		goto unlock;
>  	old = mddev->suspend_hi;
>  	mddev->suspend_hi = new;
> -	if (new <= old)
> +	if (new <= old) {
>  		/* Shrinking suspended region */
> +		wake_up(&mddev->sb_wait);
>  		mddev->pers->quiesce(mddev, 2);
> -	else {
> +	} else {
>  		/* Expanding suspended region - need to wait */
>  		mddev->pers->quiesce(mddev, 1);
>  		mddev->pers->quiesce(mddev, 0);
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index f3f3e40dc9d8..277a145b3ff5 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1310,11 +1310,9 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>  	 */
>  
>  
> -	if ((bio_end_sector(bio) > mddev->suspend_lo &&
> -	    bio->bi_iter.bi_sector < mddev->suspend_hi) ||
> -	    (mddev_is_clustered(mddev) &&
> +	if (mddev_is_clustered(mddev) &&
>  	     md_cluster_ops->area_resyncing(mddev, WRITE,
> -		     bio->bi_iter.bi_sector, bio_end_sector(bio)))) {
> +		     bio->bi_iter.bi_sector, bio_end_sector(bio))) {
>  
>  		/*
>  		 * As the suspend_* range is controlled by userspace, we want
> @@ -1325,12 +1323,10 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>  			sigset_t full, old;
>  			prepare_to_wait(&conf->wait_barrier,
>  					&w, TASK_INTERRUPTIBLE);
> -			if (bio_end_sector(bio) <= mddev->suspend_lo ||
> -			    bio->bi_iter.bi_sector >= mddev->suspend_hi ||
> -			    (mddev_is_clustered(mddev) &&
> +			if (mddev_is_clustered(mddev) &&
>  			     !md_cluster_ops->area_resyncing(mddev, WRITE,
>  				     bio->bi_iter.bi_sector,
> -				     bio_end_sector(bio))))
> +				     bio_end_sector(bio)))
>  				break;
>  			sigfillset(&full);
>  			sigprocmask(SIG_BLOCK, &full, &old);
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 928e24a07133..4f40ccd21cbb 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5682,28 +5682,6 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
>  				goto retry;
>  			}
>  
> -			if (rw == WRITE &&
> -			    logical_sector >= mddev->suspend_lo &&
> -			    logical_sector < mddev->suspend_hi) {
> -				raid5_release_stripe(sh);
> -				/* As the suspend_* range is controlled by
> -				 * userspace, we want an interruptible
> -				 * wait.
> -				 */
> -				prepare_to_wait(&conf->wait_for_overlap,
> -						&w, TASK_INTERRUPTIBLE);
> -				if (logical_sector >= mddev->suspend_lo &&
> -				    logical_sector < mddev->suspend_hi) {
> -					sigset_t full, old;
> -					sigfillset(&full);
> -					sigprocmask(SIG_BLOCK, &full, &old);
> -					schedule();
> -					sigprocmask(SIG_SETMASK, &old, NULL);
> -					do_prepare = true;
> -				}
> -				goto retry;
> -			}
> -
>  			if (test_bit(STRIPE_EXPANDING, &sh->state) ||
>  			    !add_stripe_bio(sh, bi, dd_idx, rw, previous)) {
>  				/* Stripe is busy expanding or

I think we can remove the state == 2 branch in raid5_quiesce().

This leaves only raid1 and md-cluster needs the quiesce(2) calls. In the
future, we probably should abstract that md-cluster logic to separate API and
let raid1 use it for waitting. The quiesce(2) is a strange name for the wait
purpose.

Thanks,
Shaohua

