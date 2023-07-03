Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42EF0EB64DC
	for <linux-raid@archiver.kernel.org>; Mon,  3 Jul 2023 12:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjGCMfI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 3 Jul 2023 08:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjGCMfH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 3 Jul 2023 08:35:07 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBCD2BB
        for <linux-raid@vger.kernel.org>; Mon,  3 Jul 2023 05:35:05 -0700 (PDT)
Received: from kwepemm600009.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QvlfT5FHqzMqBW;
        Mon,  3 Jul 2023 20:31:45 +0800 (CST)
Received: from [10.174.176.73] (10.174.176.73) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 3 Jul 2023 20:34:58 +0800
Subject: Re: [PATCH] raid1: prevent unnecessary call to wake_up() in fast path
To:     Jack Wang <jinpu.wang@ionos.com>, <linux-raid@vger.kernel.org>,
        <song@kernel.org>, "yukuai (C)" <yukuai3@huawei.com>
References: <20230703080119.11464-1-jinpu.wang@ionos.com>
From:   Yu Kuai <yukuai3@huawei.com>
Message-ID: <8f42de3a-4b31-949b-4a00-1537d42d76c0@huawei.com>
Date:   Mon, 3 Jul 2023 20:34:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20230703080119.11464-1-jinpu.wang@ionos.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.73]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600009.china.huawei.com (7.193.23.164)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

ÔÚ 2023/07/03 16:01, Jack Wang Ð´µÀ:
> wake_up is called unconditionally in fast path such as make_request(),
> which cause lock contention under high concurrency
>      raid1_end_write_request
>       wake_up
>        __wake_up_common_lock
>         spin_lock_irqsave
> 
> Improve performance by only call wake_up() if waitqueue is not empty
> 
> Fio test script:
> 
> [global]
> name=random reads and writes
> ioengine=libaio
> direct=1
> readwrite=randrw
> rwmixread=70
> iodepth=64
> buffered=0
> filename=/dev/md0
> size=1G
> runtime=30
> time_based
> randrepeat=0
> norandommap
> refill_buffers
> ramp_time=10
> bs=4k
> numjobs=400
> group_reporting=1
> [job1]
> 
> Test result with ramdisk raid1 on a EPYC:
> 
> 	Before this patch       With this patch
> 	READ	BW=4621MB/s	BW=7337MB/s
> 	WRITE	BW=1980MB/s	BW=1675MB/s

This is weird, I don't understand how write can be worse.
> 
> The patch is inspired by Yu Kuai's change for raid10:
> https://lore.kernel.org/r/20230621105728.1268542-1-yukuai1@huaweicloud.com
> 
> Cc: Yu Kuai <yukuai3@huawei.com>
> Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>   drivers/md/raid1.c | 17 ++++++++++++-----
>   1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index f834d99a36f6..808c91f338e6 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -789,11 +789,17 @@ static int read_balance(struct r1conf *conf, struct r1bio *r1_bio, int *max_sect
>   	return best_disk;
>   }
>   
> +static void wake_up_barrier(struct r1conf *conf)
> +{
> +	if (wq_has_sleeper(&conf->wait_barrier))
> +		wake_up(&conf->wait_barrier);
> +}
> +
>   static void flush_bio_list(struct r1conf *conf, struct bio *bio)
>   {
>   	/* flush any pending bitmap writes to disk before proceeding w/ I/O */
>   	raid1_prepare_flush_writes(conf->mddev->bitmap);
> -	wake_up(&conf->wait_barrier);
> +	wake_up_barrier(conf);
>   
>   	while (bio) { /* submit pending writes */
>   		struct bio *next = bio->bi_next;
> @@ -835,6 +841,7 @@ static void flush_pending_writes(struct r1conf *conf)
>   		spin_unlock_irq(&conf->device_lock);
>   }
>   
> +

Please remove this new line.
>   /* Barriers....
>    * Sometimes we need to suspend IO while we do something else,
>    * either some resync/recovery, or reconfigure the array.
> @@ -970,7 +977,7 @@ static bool _wait_barrier(struct r1conf *conf, int idx, bool nowait)
>   	 * In case freeze_array() is waiting for
>   	 * get_unqueued_pending() == extra
>   	 */
> -	wake_up(&conf->wait_barrier);
> +	wake_up_barrier(conf);

This is not fast path, this is only called when array is frozen or
barrier is grabbed, and this is also called with 'resync_lock' held.
>   	/* Wait for the barrier in same barrier unit bucket to drop. */
>   
>   	/* Return false when nowait flag is set */
> @@ -1013,7 +1020,7 @@ static bool wait_read_barrier(struct r1conf *conf, sector_t sector_nr, bool nowa
>   	 * In case freeze_array() is waiting for
>   	 * get_unqueued_pending() == extra
>   	 */
> -	wake_up(&conf->wait_barrier);
> +	wake_up_barrier(conf);

same above.
>   	/* Wait for array to be unfrozen */
>   
>   	/* Return false when nowait flag is set */
> @@ -1042,7 +1049,7 @@ static bool wait_barrier(struct r1conf *conf, sector_t sector_nr, bool nowait)
>   static void _allow_barrier(struct r1conf *conf, int idx)
>   {
>   	atomic_dec(&conf->nr_pending[idx]);
> -	wake_up(&conf->wait_barrier);
> +	wake_up_barrier(conf);
>   }
>   
>   static void allow_barrier(struct r1conf *conf, sector_t sector_nr)
> @@ -1171,7 +1178,7 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool from_schedule)
>   		spin_lock_irq(&conf->device_lock);
>   		bio_list_merge(&conf->pending_bio_list, &plug->pending);
>   		spin_unlock_irq(&conf->device_lock);
> -		wake_up(&conf->wait_barrier);
> +		wake_up_barrier(conf);
>   		md_wakeup_thread(mddev->thread);
>   		kfree(plug);
>   		return;
> 

And you missed raid1_write_request().

Thanks,
Kuai
