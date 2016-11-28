From: Coly Li <colyli@suse.de>
Subject: Re: [RFC PATCH 1/2] RAID1: a new I/O barrier implementation to remove
 resync window
Date: Mon, 28 Nov 2016 15:33:53 +0800
Message-ID: <0bfdd1c7-5953-a282-dd37-3a8595c90844@suse.de>
References: <1479765241-15528-1-git-send-email-colyli@suse.de>
 <58369819.1070203@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58369819.1070203@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>, linux-raid@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>, Neil Brown <neilb@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-raid.ids

On 2016/11/24 下午3:34, Guoqing Jiang wrote:
> Hi Coly,
> 
> Please see below comments, just FYI.
> 
> On 11/22/2016 05:54 AM, Coly Li wrote:
>>   - In raid1_make_request(), wait_barrier() is replaced by,
>>     a) wait_read_barrier(): wait barrier in regular read I/O code path
>>     b) wait_barrier(): wait barrier in regular write I/O code path
>>     The differnece is wait_read_barrier() only waits if array is
>> frozen, I
>>     am not able to combile them into one function, because they must
>> receive
>>     differnet data types in their arguments list.
> 
> Maybe it is possible to add a parameter to distinguish read and write, then
> the two functions can be unified.

Hi Guoqing,

read_balance() will make sure a regular read won't access a non-synced
disk, therefore regular read only needs to wait when the whole raid1 is
frozen. That's why wait_read_barrier() only waits for
!conf->array_frozen, but _wait_barrier() will waits for both
!conf->array_frozen and !conf->barrier[idx].

Combine them is possible, but the code won't be simpler, because,
- inside the function I still need to wait two wait_event_lock_irq() for
different wait condition, and if I use sector_t as the function
parameter, in wait_all_barrier() I have to send bogus sector number
(calculated by bucket index) into _wait_barrier().

that's why I choose current implementation.

> 
>>   - align_to_barrier_unit_end() is called to make sure both regular and
>>     resync I/O won't go across the border of a barrier unit size.
>>   Open question:
>>   - Need review from md clustring developer, I don't touch related
>> code now.
> 
> I don't find problems with some tests so far.

In raid1_sync_request(), I see,
conf->cluster_sync_low = mddev->curr_resync_completed;
conf->cluster_sync_high = conf->cluster_sync_low +
CLUSTER_RESYNC_WINDOW_SECTORS;

Is it possible that LBA range [conf->cluster_sync_low,
conf->cluster_sync_high] goes across the border of a barrier unit size ?


> 
>>   static void reschedule_retry(struct r1bio *r1_bio)
>> @@ -215,10 +214,15 @@ static void reschedule_retry(struct r1bi
>>       unsigned long flags;
>>       struct mddev *mddev = r1_bio->mddev;
>>       struct r1conf *conf = mddev->private;
>> +    sector_t sector_nr;
>> +    long idx;
>> +
>> +    sector_nr = r1_bio->sector;
>> +    idx = get_barrier_bucket_idx(sector_nr);
> 
> Isn't "idx = get_barrier_bucket_idx(r1_bio->sector)" enough here?

Nice catch! I will modify this in next version.

> 
>>   @@ -255,19 +257,14 @@ static void call_bio_endio(struct r1bio
>>       if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
>>           bio->bi_error = -EIO;
>>   -    if (done) {
>> +    if (done)
>>           bio_endio(bio);
>> -        /*
>> -         * Wake up any possible resync thread that waits for the device
>> -         * to go idle.
>> -         */
>> -        allow_barrier(conf, start_next_window, bi_sector);
>> -    }
>>   }
>>     static void raid_end_bio_io(struct r1bio *r1_bio)
>>   {
>>       struct bio *bio = r1_bio->master_bio;
>> +    struct r1conf *conf = r1_bio->mddev->private;
>>         /* if nobody has done the final endio yet, do it now */
>>       if (!test_and_set_bit(R1BIO_Returned, &r1_bio->state)) {
>> @@ -278,6 +275,12 @@ static void raid_end_bio_io(struct r1bio
>>             call_bio_endio(r1_bio);
>>       }
>> +
>> +    /*
>> +     * Wake up any possible resync thread that waits for the device
>> +     * to go idle.
>> +     */
>> +    allow_barrier(conf, r1_bio->sector);
>>       free_r1bio(r1_bio);
>>   }
> 
> I am not sure it is safe for above changes since call_bio_endio is not only
> called within raid_end_bio_io.
> 

This is safe. I move it here because location of wait_barrier() is
changed and replaced by wait_read_barrier() for READ I/O, and
wait_barrier() for WRITE I/O. In this patch, conf->nr_pending[idx] is
raised for each ri_bio, so allow_barrier() should be called for each
r1_bio destroy to decrease corresponding conf->nr_pending[idx].


>>   @@ -311,6 +314,7 @@ static int find_bio_disk(struct r1bio *r
>>       return mirror;
>>   }
>>   +/* bi_end_io callback for regular READ bio */
> 
> Not related to the patch itself, it would be better to make the similar
> changes in other patches.
> 

OK, I will move it into another separated patch.


>> -static bool need_to_wait_for_sync(struct r1conf *conf, struct bio *bio)
>> +/* A regular I/O should wait when,
>> + * - The whole array is frozen (both READ and WRITE)
>> + * - bio is WRITE and in same barrier bucket conf->barrier[idx] raised
>> + */
>> +static void _wait_barrier(struct r1conf *conf, long idx)
>>   {
>> -    bool wait = false;
>> -
>> -    if (conf->array_frozen || !bio)
>> -        wait = true;
>> -    else if (conf->barrier && bio_data_dir(bio) == WRITE) {
>> -        if ((conf->mddev->curr_resync_completed
>> -             >= bio_end_sector(bio)) ||
>> -            (conf->next_resync + NEXT_NORMALIO_DISTANCE
>> -             <= bio->bi_iter.bi_sector))
>> -            wait = false;
>> -        else
>> -            wait = true;
>> +    spin_lock_irq(&conf->resync_lock);
>> +    if (conf->array_frozen || conf->barrier[idx]) {
>> +        conf->nr_waiting[idx]++;
>> +        /* Wait for the barrier to drop. */
>> +        wait_event_lock_irq(
>> +            conf->wait_barrier,
>> +            !conf->array_frozen && !conf->barrier[idx],
>> +            conf->resync_lock);
>> +        conf->nr_waiting[idx]--;
>>       }
>>   -    return wait;
>> +    conf->nr_pending[idx]++;
>> +    spin_unlock_irq(&conf->resync_lock);
>>   }
>>   -static sector_t wait_barrier(struct r1conf *conf, struct bio *bio)
>> +static void wait_read_barrier(struct r1conf *conf, sector_t sector_nr)
>>   {
>> -    sector_t sector = 0;
>> +    long idx = get_barrier_bucket_idx(sector_nr);
>>         spin_lock_irq(&conf->resync_lock);
>> -    if (need_to_wait_for_sync(conf, bio)) {
>> -        conf->nr_waiting++;
>> -        /* Wait for the barrier to drop.
>> -         * However if there are already pending
>> -         * requests (preventing the barrier from
>> -         * rising completely), and the
>> -         * per-process bio queue isn't empty,
>> -         * then don't wait, as we need to empty
>> -         * that queue to allow conf->start_next_window
>> -         * to increase.
>> -         */
>> -        wait_event_lock_irq(conf->wait_barrier,
>> -                    !conf->array_frozen &&
>> -                    (!conf->barrier ||
>> -                     ((conf->start_next_window <
>> -                       conf->next_resync + RESYNC_SECTORS) &&
>> -                      current->bio_list &&
>> -                      !bio_list_empty(current->bio_list))),
>> -                    conf->resync_lock);
>> -        conf->nr_waiting--;
>> -    }
>> -
>> -    if (bio && bio_data_dir(bio) == WRITE) {
>> -        if (bio->bi_iter.bi_sector >= conf->next_resync) {
>> -            if (conf->start_next_window == MaxSector)
>> -                conf->start_next_window =
>> -                    conf->next_resync +
>> -                    NEXT_NORMALIO_DISTANCE;
>> -
>> -            if ((conf->start_next_window + NEXT_NORMALIO_DISTANCE)
>> -                <= bio->bi_iter.bi_sector)
>> -                conf->next_window_requests++;
>> -            else
>> -                conf->current_window_requests++;
>> -            sector = conf->start_next_window;
>> -        }
>> +    if (conf->array_frozen) {
>> +        conf->nr_waiting[idx]++;
>> +        /* Wait for array to unfreeze */
>> +        wait_event_lock_irq(
>> +            conf->wait_barrier,
>> +            !conf->array_frozen,
>> +            conf->resync_lock);
>> +        conf->nr_waiting[idx]--;
>>       }
>> -
>> -    conf->nr_pending++;
>> +    conf->nr_pending[idx]++;
>>       spin_unlock_irq(&conf->resync_lock);
>> -    return sector;
>>   }
>>   -static void allow_barrier(struct r1conf *conf, sector_t
>> start_next_window,
>> -              sector_t bi_sector)
>> +static void wait_barrier(struct r1conf *conf, sector_t sector_nr)
>> +{
>> +    long idx = get_barrier_bucket_idx(sector_nr);
>> +
>> +    _wait_barrier(conf, idx);
>> +}
>> +
> 
> I personally prefer to use one wait_barrier to cover both read and
> write, something like:
> 
> wait_barrier(struct r1conf *conf, long idx, int direction)
> 

As I explain previous, combine them together won't make the code
simpler, maybe more complexed. Let me try to see, if there is any better
solution to make current patch more simpler.


> BTW: there are some unnecessary changes inside the patch, maybe you can
> remove it
> or introduce other patches for them.

Yes, great suggestion, I will do this in next version.

Thanks for your review !

Coly

