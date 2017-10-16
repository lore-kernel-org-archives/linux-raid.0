From: Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH 0/4] RFC: attempt to remove md deadlocks with metadata
 without
Date: Mon, 16 Oct 2017 12:43:48 +0800
Message-ID: <ae3c04fa-a8d3-d46e-b8c7-30b9a2543ad5@redhat.com>
References: <150518076229.32691.13542756562323866921.stgit@noble>
 <874lrc28x8.fsf@notabene.neil.brown.name>
 <1345780738.18087591.1507512089744.JavaMail.zimbra@redhat.com>
 <87a810zznc.fsf@notabene.neil.brown.name>
 <441ae9fe-fd73-2aac-8bb1-c64da28cda27@redhat.com>
 <871smczx4j.fsf@notabene.neil.brown.name>
 <ebf97c38-c8e0-aa87-be84-efc8d56802f0@redhat.com>
 <87vajmwvgn.fsf@notabene.neil.brown.name>
 <960568852.19225619.1507689864371.JavaMail.zimbra@redhat.com>
 <87376nn1wm.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87376nn1wm.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 10/13/2017 11:48 AM, NeilBrown wrote:
> On Tue, Oct 10 2017, Xiao Ni wrote:
>> I added the stack traces as an attachment.
>>
> Thanks.  very helpful.
> I think I can see the problem.  The following patch might
> fix it.
> Thanks for your ongoing testing!
>
> NeilBrown
>
> From: NeilBrown <neilb@suse.com>
> Date: Fri, 13 Oct 2017 14:46:37 +1100
> Subject: [PATCH] md: move suspend_hi/lo handling into core md code
>
> responding to ->suspend_lo and ->suspend_hi is similar
> to responding to ->suspended.  It is best to wait in
> the common core code without incrementing ->active_io.
> This allows mddev_suspend()/mddev_resume() to work while
> requesting are waiting for suspend_lo/hi to change.
> This is particularly important as the code to update these
> values now uses mddev_suspend().
>
> So move the code for testing suspend_lo/hi out of raid1.c
> and raid5.c, and place it in md.c

Hi Neil

I applied the 6 patches
[PATCH 0/4] RFC: attempt to remove md deadlocks with metadata without
[PATCH] md: fix deadlock error in recent patch.
and this patch.

I've ran the test for more than 24 hours and it can't happen again. 
These patches
can fix the problem. Thanks for your help.

Best Regards
Xiao
>
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>   drivers/md/md.c    | 29 +++++++++++++++++++++++------
>   drivers/md/raid1.c | 12 ++++--------
>   drivers/md/raid5.c | 22 ----------------------
>   3 files changed, 27 insertions(+), 36 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ae531666f127..93ba3a526718 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -266,16 +266,31 @@ static DEFINE_SPINLOCK(all_mddevs_lock);
>    * call has finished, the bio has been linked into some internal structure
>    * and so is visible to ->quiesce(), so we don't need the refcount any more.
>    */
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
>   void md_handle_request(struct mddev *mddev, struct bio *bio)
>   {
>   check_suspended:
>   	rcu_read_lock();
> -	if (mddev->suspended) {
> +	if (is_suspended(mddev, bio)) {
>   		DEFINE_WAIT(__wait);
>   		for (;;) {
>   			prepare_to_wait(&mddev->sb_wait, &__wait,
>   					TASK_UNINTERRUPTIBLE);
> -			if (!mddev->suspended)
> +			if (!is_suspended(mddev, bio))
>   				break;
>   			rcu_read_unlock();
>   			schedule();
> @@ -4854,10 +4869,11 @@ suspend_lo_store(struct mddev *mddev, const char *buf, size_t len)
>   		goto unlock;
>   	old = mddev->suspend_lo;
>   	mddev->suspend_lo = new;
> -	if (new >= old)
> +	if (new >= old) {
>   		/* Shrinking suspended region */
> +		wake_up(&mddev->sb_wait);
>   		mddev->pers->quiesce(mddev, 2);
> -	else {
> +	} else {
>   		/* Expanding suspended region - need to wait */
>   		mddev_suspend(mddev);
>   		mddev_resume(mddev);
> @@ -4897,10 +4913,11 @@ suspend_hi_store(struct mddev *mddev, const char *buf, size_t len)
>   		goto unlock;
>   	old = mddev->suspend_hi;
>   	mddev->suspend_hi = new;
> -	if (new <= old)
> +	if (new <= old) {
>   		/* Shrinking suspended region */
> +		wake_up(&mddev->sb_wait);
>   		mddev->pers->quiesce(mddev, 2);
> -	else {
> +	} else {
>   		/* Expanding suspended region - need to wait */
>   		mddev_suspend(mddev);
>   		mddev_resume(mddev);
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index f3f3e40dc9d8..277a145b3ff5 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1310,11 +1310,9 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>   	 */
>   
>   
> -	if ((bio_end_sector(bio) > mddev->suspend_lo &&
> -	    bio->bi_iter.bi_sector < mddev->suspend_hi) ||
> -	    (mddev_is_clustered(mddev) &&
> +	if (mddev_is_clustered(mddev) &&
>   	     md_cluster_ops->area_resyncing(mddev, WRITE,
> -		     bio->bi_iter.bi_sector, bio_end_sector(bio)))) {
> +		     bio->bi_iter.bi_sector, bio_end_sector(bio))) {
>   
>   		/*
>   		 * As the suspend_* range is controlled by userspace, we want
> @@ -1325,12 +1323,10 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>   			sigset_t full, old;
>   			prepare_to_wait(&conf->wait_barrier,
>   					&w, TASK_INTERRUPTIBLE);
> -			if (bio_end_sector(bio) <= mddev->suspend_lo ||
> -			    bio->bi_iter.bi_sector >= mddev->suspend_hi ||
> -			    (mddev_is_clustered(mddev) &&
> +			if (mddev_is_clustered(mddev) &&
>   			     !md_cluster_ops->area_resyncing(mddev, WRITE,
>   				     bio->bi_iter.bi_sector,
> -				     bio_end_sector(bio))))
> +				     bio_end_sector(bio)))
>   				break;
>   			sigfillset(&full);
>   			sigprocmask(SIG_BLOCK, &full, &old);
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 51c9dac6e744..1f9f2d80c004 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5685,28 +5685,6 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
>   				goto retry;
>   			}
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
>   			if (test_bit(STRIPE_EXPANDING, &sh->state) ||
>   			    !add_stripe_bio(sh, bi, dd_idx, rw, previous)) {
>   				/* Stripe is busy expanding or

