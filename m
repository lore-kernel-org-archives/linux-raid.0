From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v2] md/r5cache: gracefully handle journal device errors
 for writeback mode
Date: Mon, 17 Apr 2017 20:18:40 +0000
Message-ID: <DC3F96B4-EA7B-4431-B5F8-BEC053052B7C@fb.com>
References: <20170329080013.1445439-1-songliubraving@fb.com>
 <20170410162149.due7ihii7ibrz5pl@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170410162149.due7ihii7ibrz5pl@kernel.org>
Content-Language: en-US
Content-ID: <91713DC073CD9141A636599C31431A6C@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, NeilBrown <neilb@suse.com>, Kernel Team <Kernel-team@fb.com>, Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@infradead.org>, "jes.sorensen@gmail.com" <jes.sorensen@gmail.com>
List-Id: linux-raid.ids


> On Apr 10, 2017, at 9:21 AM, Shaohua Li <shli@kernel.org> wrote:
>=20
> On Wed, Mar 29, 2017 at 01:00:13AM -0700, Song Liu wrote:
>> For the raid456 with writeback cache, when journal device failed during
>> normal operation, it is still possible to persist all data, as all
>> pending data is still in stripe cache. However, it is necessary to handl=
e
>> journal failure gracefully.
>>=20
>> During journal failures, this patch makes the follow changes to land dat=
a
>> in cache to raid disks gracefully:
>>=20
>> 1. In raid5_remove_disk(), flush all cached stripes;
>> 2. In handle_stripe(), allow stripes with data in journal (s.injournal >=
 0)
>>   to make progress;
>> 3. In delay_towrite(), only process data in the cache (skip dev->towrite=
);
>> 4. In __get_priority_stripe(), set try_loprio to true, so no stripe stuc=
k
>>   in loprio_list
>> 5. In r5l_do_submit_io(), submit io->split_bio first (see inline comment=
s
>>   for details).=20
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>> drivers/md/raid5-cache.c | 27 ++++++++++++++++++---------
>> drivers/md/raid5.c       | 28 ++++++++++++++++++++++++----
>> 2 files changed, 42 insertions(+), 13 deletions(-)
>>=20
>> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
>> index b6194e0..0838617 100644
>> --- a/drivers/md/raid5-cache.c
>> +++ b/drivers/md/raid5-cache.c
>> @@ -632,20 +632,29 @@ static void r5l_do_submit_io(struct r5l_log *log, =
struct r5l_io_unit *io)
>> 	__r5l_set_io_unit_state(io, IO_UNIT_IO_START);
>> 	spin_unlock_irqrestore(&log->io_list_lock, flags);
>>=20
>> +	/*
>> +	 * In case of journal device failures, submit_bio will get error
>> +	 * and calls endio, then active stripes will continue write
>> +	 * process. Therefore, it is not necessary to check Faulty bit
>> +	 * of journal device here.
>> +	 *
>> +	 * However, calling r5l_log_endio(current_bio) may change
>> +	 * split_bio. Therefore, it is necessary to check split_bio before
>> +	 * submit current_bio.
>> +	 */
>=20
> sorry, for the delay. what did you mean 'calling r5l_log_endio may change
> split_bio'? The split_bio is chained into current_bio. The endio of
> current_bio(r5l_log_endio) is only called after all chained bio completio=
n. I
> didn't get the point why this change.

This happens when io->split_bio is NULL. In such cases, r5l_log_endio() may=
=20
free the io_unit, and thus change io->split_bio. I will revise the comments=
.=20

>=20
>> +	if (io->split_bio) {
>> +		if (io->has_flush)
>> +			io->split_bio->bi_opf |=3D REQ_PREFLUSH;
>> +		if (io->has_fua)
>> +			io->split_bio->bi_opf |=3D REQ_FUA;
>> +		submit_bio(io->split_bio);
>> +	}
>> +
>> 	if (io->has_flush)
>> 		io->current_bio->bi_opf |=3D REQ_PREFLUSH;
>> 	if (io->has_fua)
>> 		io->current_bio->bi_opf |=3D REQ_FUA;
>> 	submit_bio(io->current_bio);
>> -
>> -	if (!io->split_bio)
>> -		return;
>> -
>> -	if (io->has_flush)
>> -		io->split_bio->bi_opf |=3D REQ_PREFLUSH;
>> -	if (io->has_fua)
>> -		io->split_bio->bi_opf |=3D REQ_FUA;
>> -	submit_bio(io->split_bio);
>> }
>>=20
>> /* deferred io_unit will be dispatched here */
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 6036d5e..4d3d1ab 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -3054,6 +3054,11 @@ sector_t raid5_compute_blocknr(struct stripe_head=
 *sh, int i, int previous)
>>  *      When LOG_CRITICAL, stripes with injournal =3D=3D 0 will be sent =
to
>>  *      no_space_stripes list.
>>  *
>> + *   3. during journal failure
>> + *      In journal failure, we try to flush all cached data to raid dis=
ks
>> + *      based on data in stripe cache. The array is read-only to upper
>> + *      layers, so we would skip all pending writes.
>> + *
>>  */
>> static inline bool delay_towrite(struct r5conf *conf,
>> 				 struct r5dev *dev,
>> @@ -3067,6 +3072,9 @@ static inline bool delay_towrite(struct r5conf *co=
nf,
>> 	if (test_bit(R5C_LOG_CRITICAL, &conf->cache_state) &&
>> 	    s->injournal > 0)
>> 		return true;
>> +	/* case 3 above */
>> +	if (s->log_failed && s->injournal)
>> +		return true;
>> 	return false;
>> }
>>=20
>> @@ -4689,10 +4697,15 @@ static void handle_stripe(struct stripe_head *sh=
)
>> 	       " to_write=3D%d failed=3D%d failed_num=3D%d,%d\n",
>> 	       s.locked, s.uptodate, s.to_read, s.to_write, s.failed,
>> 	       s.failed_num[0], s.failed_num[1]);
>> -	/* check if the array has lost more than max_degraded devices and,
>> +	/*
>> +	 * check if the array has lost more than max_degraded devices and,
>> 	 * if so, some requests might need to be failed.
>> +	 *
>> +	 * When journal device failed (log_failed), we will only process
>> +	 * the stripe if there is data need write to raid disks
>> 	 */
>> -	if (s.failed > conf->max_degraded || s.log_failed) {
>> +	if (s.failed > conf->max_degraded ||
>> +	    (s.log_failed && s.injournal =3D=3D 0)) {
>> 		sh->check_state =3D 0;
>> 		sh->reconstruct_state =3D 0;
>> 		break_stripe_batch_list(sh, 0);
>> @@ -5272,7 +5285,8 @@ static struct stripe_head *__get_priority_stripe(s=
truct r5conf *conf, int group)
>> 	struct list_head *handle_list =3D NULL;
>> 	struct r5worker_group *wg;
>> 	bool second_try =3D !r5c_is_writeback(conf->log);
>> -	bool try_loprio =3D test_bit(R5C_LOG_TIGHT, &conf->cache_state);
>> +	bool try_loprio =3D test_bit(R5C_LOG_TIGHT, &conf->cache_state) ||
>> +		r5l_log_disk_error(conf);
>>=20
>> again:
>> 	wg =3D NULL;
>> @@ -7526,6 +7540,7 @@ static int raid5_remove_disk(struct mddev *mddev, =
struct md_rdev *rdev)
>> 	int number =3D rdev->raid_disk;
>> 	struct md_rdev **rdevp;
>> 	struct disk_info *p =3D conf->disks + number;
>> +	unsigned long flags;
>>=20
>> 	print_raid5_conf(conf);
>> 	if (test_bit(Journal, &rdev->flags) && conf->log) {
>> @@ -7535,7 +7550,12 @@ static int raid5_remove_disk(struct mddev *mddev,=
 struct md_rdev *rdev)
>> 		 * neilb: there is no locking about new writes here,
>> 		 * so this cannot be safe.
>> 		 */
>> -		if (atomic_read(&conf->active_stripes)) {
>> +		if (atomic_read(&conf->active_stripes) ||
>> +		    atomic_read(&conf->r5c_cached_full_stripes) ||
>> +		    atomic_read(&conf->r5c_cached_partial_stripes)) {
>> +			spin_lock_irqsave(&conf->device_lock, flags);
>> +			r5c_flush_cache(conf, INT_MAX);
>> +			spin_unlock_irqrestore(&conf->device_lock, flags);
>> 			return -EBUSY;
>=20
> It's weird this is called in raid5_remove_disk, shouldn't this be called =
in log
> disk error in case user doesn't remove the log disk? And this is a policy
> change. User might not want to do the flush, as this exposes write hole. =
I
> think at least we should print info out here to warn user the flush.

Yeah, it is better to flush cache in in raid5_error(). Let me try that.=20

I think flushing cache here is the best solution so far, as valid data is o=
nly=20
stored in DRAM before the flush. I will add a warning.=20

Thanks,
Song=
