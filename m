Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF75213B7AF;
	Mon, 26 Aug 2024 08:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724661115; cv=none; b=Vaxk1jV9edkB7DChAyOtcT3TxRYNi5Jps/GJ4cER+Z5uq4+y+LlCSjDLfXI+/6H+IK2f0xIFi+F6qqLKFW93BtmtzaWptPf8Q3btgSiiKULQT737dwXiF5liQzxL1AKvAvL9+iCAm83v31cXfTokBhPrL/5YVCTejwGMLRCkNOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724661115; c=relaxed/simple;
	bh=mIn1G4FjW1m3IfAcBZ1Fjj5leOqGoZvu0OGa5/JQ9fg=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=HGkYC5Ux3WMx6xNTx5GiKYaOLZt8xi3OprYQtLORzoEnLz3o6UFFI+hT4+u8tEMnr7Ic/6TTB+NHfshsJllzhqBC7zhKQuROOsu8VzW+ZbX8U1L+LkktPN+hlK80C91tMhMj6QoahoRGTDkvt+xy8/tso13U3KSLOW27KFZmAYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WskRV6tprz4f3js2;
	Mon, 26 Aug 2024 16:31:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6B66D1A0359;
	Mon, 26 Aug 2024 16:31:49 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgBnj4V0PcxmASsHCw--.19953S3;
	Mon, 26 Aug 2024 16:31:49 +0800 (CST)
Subject: Re: [PATCH md-6.12] md: remove flush handling
To: Paul Menzel <pmenzel@molgen.mpg.de>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 Li Nan <linan122@huawei.com>, "yukuai (C)" <yukuai3@huawei.com>
References: <20240826074843.1575099-1-yukuai1@huaweicloud.com>
 <9eaf862f-0c00-4d58-994a-bd1b3c6f1518@molgen.mpg.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <456cf112-2de2-f2c8-9a05-5a1486b8f2cd@huaweicloud.com>
Date: Mon, 26 Aug 2024 16:31:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <9eaf862f-0c00-4d58-994a-bd1b3c6f1518@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBnj4V0PcxmASsHCw--.19953S3
X-Coremail-Antispam: 1UD129KBjvJXoW3tw17KFy3Ww4DCry5Jw18Xwb_yoWkCr4fpF
	WktFy5JrWUJw1rJr18Jr1DJry5Xr4UX3WDJr43XF1UAr47AF1jgr45Xryvgr1UAr4rWr48
	Jr1UJrnruFy5XrUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Cr0_Gr1UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWI
	evJa73UjIFyTuYvjfUoWlkDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/08/26 16:19, Paul Menzel 写道:
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
>>
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
The script is simple, I can add it in the next version.

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/time.h>

#define THREADS 128
#define FSYNC_COUNT 100000

void* thread_func(void* arg) {
     int fd = *(int*)arg;
     for (int i = 0; i < FSYNC_COUNT; i++) {
         fsync(fd);
     }
     return NULL;
}

int main() {
     int fd = open("/dev/md0", O_RDWR);
     if (fd < 0) {
         perror("open");
         exit(1);
     }

     pthread_t threads[THREADS];
     struct timeval start, end;

     gettimeofday(&start, NULL);

     for (int i = 0; i < THREADS; i++) {
         pthread_create(&threads[i], NULL, thread_func, &fd);
     }

     for (int i = 0; i < THREADS; i++) {
         pthread_join(threads[i], NULL);
     }

     gettimeofday(&end, NULL);

     close(fd);

     long long elapsed = (end.tv_sec - start.tv_sec) * 1000000LL + 
(end.tv_usec - start.tv_usec);
     printf("Elapsed time: %lld microseconds\n", elapsed);

     return 0;
}

> 
>> Test result: about 10 times faster for high concurrency.
>> Before this patch: 50943374 microseconds
>> After this patch:  5096347  microseconds
>>
>> BTW, this patch can fix the same problem as commit 611d5cbc0b35 ("md: fix
>> deadlock between mddev_suspend and flush bio").
> 
> So, should that be reverted? (Cc: +Li Nan)

I put a particular emphasis on this becasue 611d5cbc0b35 is the fix
patch for CVE-2024-43855, and this can help people fix the CVE in low
kernel version if they care like us.

Revert is not necessary, I think.

Thanks,
Kuai

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
>> - * Manages consolidation of flushes and submitting any flushes needed 
>> for
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
>> -    ktime_t start_flush, prev_flush_start; /* prev_flush_start is 
>> when the previous completed
>> -                        * flush was started.
>> -                        */
>> -    struct work_struct flush_work;
>>       struct work_struct event_work;    /* used by dm to report 
>> failure event */
>>       mempool_t *serial_info_pool;
>>       void (*sync_super)(struct mddev *mddev, struct md_rdev *rdev);
> 
> Code removal is always nice to see.
> 
> 
> Kind regards,
> 
> Paul
> .
> 

