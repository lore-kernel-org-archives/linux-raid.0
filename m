From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [RFC PATCH 1/2] RAID1: a new I/O barrier implementation to remove
 resync window
Date: Thu, 24 Nov 2016 15:34:49 +0800
Message-ID: <58369819.1070203@suse.com>
References: <1479765241-15528-1-git-send-email-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1479765241-15528-1-git-send-email-colyli@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>, Neil Brown <neilb@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-raid.ids

Hi Coly,

Please see below comments, just FYI.

On 11/22/2016 05:54 AM, Coly Li wrote:
>   - In raid1_make_request(), wait_barrier() is replaced by,
>     a) wait_read_barrier(): wait barrier in regular read I/O code path
>     b) wait_barrier(): wait barrier in regular write I/O code path
>     The differnece is wait_read_barrier() only waits if array is frozen, I
>     am not able to combile them into one function, because they must receive
>     differnet data types in their arguments list.

Maybe it is possible to add a parameter to distinguish read and write, then
the two functions can be unified.

>   - align_to_barrier_unit_end() is called to make sure both regular and
>     resync I/O won't go across the border of a barrier unit size.
>   
> Open question:
>   - Need review from md clustring developer, I don't touch related code now.

I don't find problems with some tests so far.

>   static void reschedule_retry(struct r1bio *r1_bio)
> @@ -215,10 +214,15 @@ static void reschedule_retry(struct r1bi
>   	unsigned long flags;
>   	struct mddev *mddev = r1_bio->mddev;
>   	struct r1conf *conf = mddev->private;
> +	sector_t sector_nr;
> +	long idx;
> +
> +	sector_nr = r1_bio->sector;
> +	idx = get_barrier_bucket_idx(sector_nr);

Isn't "idx = get_barrier_bucket_idx(r1_bio->sector)" enough here?

>   @@ -255,19 +257,14 @@ static void call_bio_endio(struct r1bio
>   	if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
>   		bio->bi_error = -EIO;
>   
> -	if (done) {
> +	if (done)
>   		bio_endio(bio);
> -		/*
> -		 * Wake up any possible resync thread that waits for the device
> -		 * to go idle.
> -		 */
> -		allow_barrier(conf, start_next_window, bi_sector);
> -	}
>   }
>   
>   static void raid_end_bio_io(struct r1bio *r1_bio)
>   {
>   	struct bio *bio = r1_bio->master_bio;
> +	struct r1conf *conf = r1_bio->mddev->private;
>   
>   	/* if nobody has done the final endio yet, do it now */
>   	if (!test_and_set_bit(R1BIO_Returned, &r1_bio->state)) {
> @@ -278,6 +275,12 @@ static void raid_end_bio_io(struct r1bio
>   
>   		call_bio_endio(r1_bio);
>   	}
> +
> +	/*
> +	 * Wake up any possible resync thread that waits for the device
> +	 * to go idle.
> +	 */
> +	allow_barrier(conf, r1_bio->sector);
>   	free_r1bio(r1_bio);
>   }

I am not sure it is safe for above changes since call_bio_endio is not only
called within raid_end_bio_io.

>   
> @@ -311,6 +314,7 @@ static int find_bio_disk(struct r1bio *r
>   	return mirror;
>   }
>   
> +/* bi_end_io callback for regular READ bio */

Not related to the patch itself, it would be better to make the similar
changes in other patches.

> -static bool need_to_wait_for_sync(struct r1conf *conf, struct bio *bio)
> +/* A regular I/O should wait when,
> + * - The whole array is frozen (both READ and WRITE)
> + * - bio is WRITE and in same barrier bucket conf->barrier[idx] raised
> + */
> +static void _wait_barrier(struct r1conf *conf, long idx)
>   {
> -	bool wait = false;
> -
> -	if (conf->array_frozen || !bio)
> -		wait = true;
> -	else if (conf->barrier && bio_data_dir(bio) == WRITE) {
> -		if ((conf->mddev->curr_resync_completed
> -		     >= bio_end_sector(bio)) ||
> -		    (conf->next_resync + NEXT_NORMALIO_DISTANCE
> -		     <= bio->bi_iter.bi_sector))
> -			wait = false;
> -		else
> -			wait = true;
> +	spin_lock_irq(&conf->resync_lock);
> +	if (conf->array_frozen || conf->barrier[idx]) {
> +		conf->nr_waiting[idx]++;
> +		/* Wait for the barrier to drop. */
> +		wait_event_lock_irq(
> +			conf->wait_barrier,
> +			!conf->array_frozen && !conf->barrier[idx],
> +			conf->resync_lock);
> +		conf->nr_waiting[idx]--;
>   	}
>   
> -	return wait;
> +	conf->nr_pending[idx]++;
> +	spin_unlock_irq(&conf->resync_lock);
>   }
>   
> -static sector_t wait_barrier(struct r1conf *conf, struct bio *bio)
> +static void wait_read_barrier(struct r1conf *conf, sector_t sector_nr)
>   {
> -	sector_t sector = 0;
> +	long idx = get_barrier_bucket_idx(sector_nr);
>   
>   	spin_lock_irq(&conf->resync_lock);
> -	if (need_to_wait_for_sync(conf, bio)) {
> -		conf->nr_waiting++;
> -		/* Wait for the barrier to drop.
> -		 * However if there are already pending
> -		 * requests (preventing the barrier from
> -		 * rising completely), and the
> -		 * per-process bio queue isn't empty,
> -		 * then don't wait, as we need to empty
> -		 * that queue to allow conf->start_next_window
> -		 * to increase.
> -		 */
> -		wait_event_lock_irq(conf->wait_barrier,
> -				    !conf->array_frozen &&
> -				    (!conf->barrier ||
> -				     ((conf->start_next_window <
> -				       conf->next_resync + RESYNC_SECTORS) &&
> -				      current->bio_list &&
> -				      !bio_list_empty(current->bio_list))),
> -				    conf->resync_lock);
> -		conf->nr_waiting--;
> -	}
> -
> -	if (bio && bio_data_dir(bio) == WRITE) {
> -		if (bio->bi_iter.bi_sector >= conf->next_resync) {
> -			if (conf->start_next_window == MaxSector)
> -				conf->start_next_window =
> -					conf->next_resync +
> -					NEXT_NORMALIO_DISTANCE;
> -
> -			if ((conf->start_next_window + NEXT_NORMALIO_DISTANCE)
> -			    <= bio->bi_iter.bi_sector)
> -				conf->next_window_requests++;
> -			else
> -				conf->current_window_requests++;
> -			sector = conf->start_next_window;
> -		}
> +	if (conf->array_frozen) {
> +		conf->nr_waiting[idx]++;
> +		/* Wait for array to unfreeze */
> +		wait_event_lock_irq(
> +			conf->wait_barrier,
> +			!conf->array_frozen,
> +			conf->resync_lock);
> +		conf->nr_waiting[idx]--;
>   	}
> -
> -	conf->nr_pending++;
> +	conf->nr_pending[idx]++;
>   	spin_unlock_irq(&conf->resync_lock);
> -	return sector;
>   }
>   
> -static void allow_barrier(struct r1conf *conf, sector_t start_next_window,
> -			  sector_t bi_sector)
> +static void wait_barrier(struct r1conf *conf, sector_t sector_nr)
> +{
> +	long idx = get_barrier_bucket_idx(sector_nr);
> +
> +	_wait_barrier(conf, idx);
> +}
> +

I personally prefer to use one wait_barrier to cover both read and 
write, something like:

wait_barrier(struct r1conf *conf, long idx, int direction)

BTW: there are some unnecessary changes inside the patch, maybe you can 
remove it
or introduce other patches for them.

Regards,
Guoqing
