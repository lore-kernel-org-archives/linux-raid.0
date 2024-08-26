Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632DE4A2C;
	Mon, 26 Aug 2024 08:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724661034; cv=none; b=CgeM0bmmJVeRU374E71cAzyX0Q8xRClpneqRz8h+spruk/eKCXvhVjsZTMR2R7xD8Tsgl9zZM4uibqITZMivkPm3My4B/6UNh+9h5a1Aly2qzpaXnhrJjcHh/HLCfzKFcLtLd8FL98fR0CPDqTXV2KV7M1+Fp1Nk9aWN21BMPzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724661034; c=relaxed/simple;
	bh=2vgRqpd15fdua6iB1cN1Xzf0nXOlvMPcwqiwr9OZ4Mc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=IdxL8SI96NBon13NG5jgLzfrYByS/Vt8ABbKxMOsBCZ8GLrmKqRqc+b0u3aLU3kdmUIQSSZRRfTaCT1IPJ1mbvBLAH2YAzWj4iVGThjvvTLobulsvbjLrYmP2WbJ9SqtwAa0Voiqm9HYW7gMBjNz6+CqT7g9l4uWQBuz+Rybq6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.53] (ip5f5aead7.dynamic.kabel-deutschland.de [95.90.234.215])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 5206861E5FE05;
	Mon, 26 Aug 2024 10:30:10 +0200 (CEST)
Message-ID: <471242c4-4ddd-4b8e-b05d-4ccbbc495062@molgen.mpg.de>
Date: Mon, 26 Aug 2024 10:30:09 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH md-6.12] md: remove flush handling
From: Paul Menzel <pmenzel@molgen.mpg.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com,
 yangerkun@huawei.com, Li Nan <linan122@huawei.com>
References: <20240826074843.1575099-1-yukuai1@huaweicloud.com>
 <9eaf862f-0c00-4d58-994a-bd1b3c6f1518@molgen.mpg.de>
Content-Language: en-US
In-Reply-To: <9eaf862f-0c00-4d58-994a-bd1b3c6f1518@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

[Add one more finding]

Am 26.08.24 um 10:19 schrieb Paul Menzel:
> Dear Kuai,
> 
> 
> Thank you for your patch.
> 
> 
> Am 26.08.24 um 09:48 schrieb Yu Kuai:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> For flush request, md has a special flush handling to merge concurrent
>> flush request into single one, however, the whole mechanism is based on
>> a disk level spin_lock 'mddev->lock'. And fsync can be called quite
>> often in some user cases, for consequence, spin lock from IO fast path 
>> can
>> cause performance degration.

degradation

>> Fortunately, the block layer already have flush handling to merge
> 
> s/have/has/
> 
>> concurrent flush request, and it only acquire hctx level spin lock(see
> 
> 1.  acquire*s*
> 2.  Please add a space before the (.
> 
>> details in blk-flush.c).
>>
>> This patch remove the flush handling in md, and convert to use general
>> block layer flush handling in underlying disks.
> 
> remove*s*, convert*s*
> 
>> Flush test for 4 nvme raid10:
>> start 128 threads to do fsync 100000 times, on arm64, see how long it
>> takes.
> 
> Please share the script, so it’s easier to reproduce?
> 
>> Test result: about 10 times faster for high concurrency.
>> Before this patch: 50943374 microseconds
>> After this patch:  5096347  microseconds
>>
>> BTW, this patch can fix the same problem as commit 611d5cbc0b35 ("md: fix
>> deadlock between mddev_suspend and flush bio").
> 
> So, should that be reverted? (Cc: +Li Nan)
> 
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>   drivers/md/md.c | 137 ++++--------------------------------------------
>>   drivers/md/md.h |  10 ----
>>   2 files changed, 11 insertions(+), 136 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index a38981de8901..4d675f7cc2a7 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -546,137 +546,23 @@ static int 
>> mddev_set_closing_and_sync_blockdev(struct mddev *mddev, int opener_n
>>       return 0;
>>   }
>> -/*
>> - * Generic flush handling for md
>> - */
>> -
>> -static void md_end_flush(struct bio *bio)
>> -{
>> -    struct md_rdev *rdev = bio->bi_private;
>> -    struct mddev *mddev = rdev->mddev;
>> -
>> -    bio_put(bio);
>> -
>> -    rdev_dec_pending(rdev, mddev);
>> -
>> -    if (atomic_dec_and_test(&mddev->flush_pending))
>> -        /* The pre-request flush has finished */
>> -        queue_work(md_wq, &mddev->flush_work);
>> -}
>> -
>> -static void md_submit_flush_data(struct work_struct *ws);
>> -
>> -static void submit_flushes(struct work_struct *ws)
>> +bool md_flush_request(struct mddev *mddev, struct bio *bio)
>>   {
>> -    struct mddev *mddev = container_of(ws, struct mddev, flush_work);
>>       struct md_rdev *rdev;
>> +    struct bio *new;
>> -    mddev->start_flush = ktime_get_boottime();
>> -    INIT_WORK(&mddev->flush_work, md_submit_flush_data);
>> -    atomic_set(&mddev->flush_pending, 1);
>> -    rcu_read_lock();
>> -    rdev_for_each_rcu(rdev, mddev)
>> -        if (rdev->raid_disk >= 0 &&
>> -            !test_bit(Faulty, &rdev->flags)) {
>> -            struct bio *bi;
>> -
>> -            atomic_inc(&rdev->nr_pending);
>> -            rcu_read_unlock();
>> -            bi = bio_alloc_bioset(rdev->bdev, 0,
>> -                          REQ_OP_WRITE | REQ_PREFLUSH,
>> -                          GFP_NOIO, &mddev->bio_set);
>> -            bi->bi_end_io = md_end_flush;
>> -            bi->bi_private = rdev;
>> -            atomic_inc(&mddev->flush_pending);
>> -            submit_bio(bi);
>> -            rcu_read_lock();
>> -        }
>> -    rcu_read_unlock();
>> -    if (atomic_dec_and_test(&mddev->flush_pending))
>> -        queue_work(md_wq, &mddev->flush_work);
>> -}
>> -
>> -static void md_submit_flush_data(struct work_struct *ws)
>> -{
>> -    struct mddev *mddev = container_of(ws, struct mddev, flush_work);
>> -    struct bio *bio = mddev->flush_bio;
>> -
>> -    /*
>> -     * must reset flush_bio before calling into md_handle_request to 
>> avoid a
>> -     * deadlock, because other bios passed md_handle_request suspend 
>> check
>> -     * could wait for this and below md_handle_request could wait for 
>> those
>> -     * bios because of suspend check
>> -     */
>> -    spin_lock_irq(&mddev->lock);
>> -    mddev->prev_flush_start = mddev->start_flush;
>> -    mddev->flush_bio = NULL;
>> -    spin_unlock_irq(&mddev->lock);
>> -    wake_up(&mddev->sb_wait);
>> -
>> -    if (bio->bi_iter.bi_size == 0) {
>> -        /* an empty barrier - all done */
>> -        bio_endio(bio);
>> -    } else {
>> -        bio->bi_opf &= ~REQ_PREFLUSH;
>> -
>> -        /*
>> -         * make_requst() will never return error here, it only
>> -         * returns error in raid5_make_request() by dm-raid.
>> -         * Since dm always splits data and flush operation into
>> -         * two separate io, io size of flush submitted by dm
>> -         * always is 0, make_request() will not be called here.
>> -         */
>> -        if (WARN_ON_ONCE(!mddev->pers->make_request(mddev, bio)))
>> -            bio_io_error(bio);
>> -    }
>> -
>> -    /* The pair is percpu_ref_get() from md_flush_request() */
>> -    percpu_ref_put(&mddev->active_io);
>> -}
>> +    rdev_for_each(rdev, mddev) {
>> +        if (rdev->raid_disk < 0 || test_bit(Faulty, &rdev->flags))
>> +            continue;
>> -/*
>> - * Manages consolidation of flushes and submitting any flushes needed for
>> - * a bio with REQ_PREFLUSH.  Returns true if the bio is finished or is
>> - * being finished in another context.  Returns false if the flushing is
>> - * complete but still needs the I/O portion of the bio to be processed.
>> - */
>> -bool md_flush_request(struct mddev *mddev, struct bio *bio)
>> -{
>> -    ktime_t req_start = ktime_get_boottime();
>> -    spin_lock_irq(&mddev->lock);
>> -    /* flush requests wait until ongoing flush completes,
>> -     * hence coalescing all the pending requests.
>> -     */
>> -    wait_event_lock_irq(mddev->sb_wait,
>> -                !mddev->flush_bio ||
>> -                ktime_before(req_start, mddev->prev_flush_start),
>> -                mddev->lock);
>> -    /* new request after previous flush is completed */
>> -    if (ktime_after(req_start, mddev->prev_flush_start)) {
>> -        WARN_ON(mddev->flush_bio);
>> -        /*
>> -         * Grab a reference to make sure mddev_suspend() will wait for
>> -         * this flush to be done.
>> -         *
>> -         * md_flush_reqeust() is called under md_handle_request() and
>> -         * 'active_io' is already grabbed, hence percpu_ref_is_zero()
>> -         * won't pass, percpu_ref_tryget_live() can't be used because
>> -         * percpu_ref_kill() can be called by mddev_suspend()
>> -         * concurrently.
>> -         */
>> -        WARN_ON(percpu_ref_is_zero(&mddev->active_io));
>> -        percpu_ref_get(&mddev->active_io);
>> -        mddev->flush_bio = bio;
>> -        spin_unlock_irq(&mddev->lock);
>> -        INIT_WORK(&mddev->flush_work, submit_flushes);
>> -        queue_work(md_wq, &mddev->flush_work);
>> -        return true;
>> +        new = bio_alloc_bioset(rdev->bdev, 0,
>> +                       REQ_OP_WRITE | REQ_PREFLUSH, GFP_NOIO,
>> +                       &mddev->bio_set);
>> +        bio_chain(new, bio);
>> +        submit_bio(new);
>>       }
>> -    /* flush was performed for some other bio while we waited. */
>> -    spin_unlock_irq(&mddev->lock);
>> -    if (bio->bi_iter.bi_size == 0) {
>> -        /* pure flush without data - all done */
>> +    if (bio_sectors(bio) == 0) {
>>           bio_endio(bio);
>>           return true;
>>       }
>> @@ -763,7 +649,6 @@ int mddev_init(struct mddev *mddev)
>>       atomic_set(&mddev->openers, 0);
>>       atomic_set(&mddev->sync_seq, 0);
>>       spin_lock_init(&mddev->lock);
>> -    atomic_set(&mddev->flush_pending, 0);
>>       init_waitqueue_head(&mddev->sb_wait);
>>       init_waitqueue_head(&mddev->recovery_wait);
>>       mddev->reshape_position = MaxSector;
>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>> index 1c6a5f41adca..5d2e6bd58e4d 100644
>> --- a/drivers/md/md.h
>> +++ b/drivers/md/md.h
>> @@ -572,16 +572,6 @@ struct mddev {
>>                              */
>>       struct bio_set            io_clone_set;
>> -    /* Generic flush handling.
>> -     * The last to finish preflush schedules a worker to submit
>> -     * the rest of the request (without the REQ_PREFLUSH flag).
>> -     */
>> -    struct bio *flush_bio;
>> -    atomic_t flush_pending;
>> -    ktime_t start_flush, prev_flush_start; /* prev_flush_start is when the previous completed
>> -                        * flush was started.
>> -                        */
>> -    struct work_struct flush_work;
>>       struct work_struct event_work;    /* used by dm to report failure event */
>>       mempool_t *serial_info_pool;
>>       void (*sync_super)(struct mddev *mddev, struct md_rdev *rdev);
> 
> Code removal is always nice to see.
> 
> 
> Kind regards,
> 
> Paul
