Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 944C0EB64DD
	for <linux-raid@archiver.kernel.org>; Thu,  6 Jul 2023 06:14:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233519AbjGFGOy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 6 Jul 2023 02:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233071AbjGFGOx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 6 Jul 2023 02:14:53 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C841B6
        for <linux-raid@vger.kernel.org>; Wed,  5 Jul 2023 23:14:51 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QxR861w6lz4f3jJK
        for <linux-raid@vger.kernel.org>; Thu,  6 Jul 2023 14:14:46 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgD3mp7UW6ZkRAVJNQ--.24985S3;
        Thu, 06 Jul 2023 14:14:45 +0800 (CST)
Subject: Re: [PATCHv3] md/raid1: Avoid lock contention from wake_up()
To:     Jack Wang <jinpu.wang@ionos.com>, linux-raid@vger.kernel.org,
        song@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20230705113227.148494-1-jinpu.wang@ionos.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <04cc9d64-1683-caac-35ff-9275af6ce508@huaweicloud.com>
Date:   Thu, 6 Jul 2023 14:14:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20230705113227.148494-1-jinpu.wang@ionos.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgD3mp7UW6ZkRAVJNQ--.24985S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAFW8uFWrWF17Ww4fAry7ZFb_yoWrAryxpw
        4FqayYqFWDJFyYyw4DJFWDu3WY93WkKFWxCFyIk3s7ZF10qF9Y9F1xGF98uryjkrZ3GrW7
        AFsYy3sxGr1jqFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1CPfJUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

ÔÚ 2023/07/05 19:32, Jack Wang Ð´µÀ:
> wake_up is called unconditionally in a few paths such as make_request(),
> which cause lock contention under high concurrency workload like below
>      raid1_end_write_request
>       wake_up
>        __wake_up_common_lock
>         spin_lock_irqsave
> 
> Improve performance by only call wake_up() if waitqueue is not empty
> 
LGTM

Reviewed-by: Yu Kuai <yukuai3@huawei.com>

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
> Test result with 2 ramdisk in raid1 on a Intel Broadwell 56 cores server.
> 
> 	Before this patch       With this patch
> 	READ	BW=4621MB/s	BW=7337MB/s
> 	WRITE	BW=1980MB/s	BW=3144MB/s
> 
> The patch is inspired by Yu Kuai's change for raid10:
> https://lore.kernel.org/r/20230621105728.1268542-1-yukuai1@huaweicloud.com
> 
> Cc: Yu Kuai <yukuai3@huawei.com>
> Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
> ---
> v3: rephrase the commit message, no code change.
> 
> v2: addressed comments from Kuai
> * Removed newline
> * change the missing case in raid1_write_request
> * I still kept the change for _wait_barrier and wait_read_barrier, as I did
>   performance tests without them there are still lock contention from
>   __wake_up_common_lock
> 
>   drivers/md/raid1.c | 18 ++++++++++++------
>   1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index f834d99a36f6..0c76c36d8cb1 100644
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
> @@ -970,7 +976,7 @@ static bool _wait_barrier(struct r1conf *conf, int idx, bool nowait)
>   	 * In case freeze_array() is waiting for
>   	 * get_unqueued_pending() == extra
>   	 */
> -	wake_up(&conf->wait_barrier);
> +	wake_up_barrier(conf);
>   	/* Wait for the barrier in same barrier unit bucket to drop. */
>   
>   	/* Return false when nowait flag is set */
> @@ -1013,7 +1019,7 @@ static bool wait_read_barrier(struct r1conf *conf, sector_t sector_nr, bool nowa
>   	 * In case freeze_array() is waiting for
>   	 * get_unqueued_pending() == extra
>   	 */
> -	wake_up(&conf->wait_barrier);
> +	wake_up_barrier(conf);
>   	/* Wait for array to be unfrozen */
>   
>   	/* Return false when nowait flag is set */
> @@ -1042,7 +1048,7 @@ static bool wait_barrier(struct r1conf *conf, sector_t sector_nr, bool nowait)
>   static void _allow_barrier(struct r1conf *conf, int idx)
>   {
>   	atomic_dec(&conf->nr_pending[idx]);
> -	wake_up(&conf->wait_barrier);
> +	wake_up_barrier(conf);
>   }
>   
>   static void allow_barrier(struct r1conf *conf, sector_t sector_nr)
> @@ -1171,7 +1177,7 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool from_schedule)
>   		spin_lock_irq(&conf->device_lock);
>   		bio_list_merge(&conf->pending_bio_list, &plug->pending);
>   		spin_unlock_irq(&conf->device_lock);
> -		wake_up(&conf->wait_barrier);
> +		wake_up_barrier(conf);
>   		md_wakeup_thread(mddev->thread);
>   		kfree(plug);
>   		return;
> @@ -1574,7 +1580,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>   	r1_bio_write_done(r1_bio);
>   
>   	/* In case raid1d snuck in to freeze_array */
> -	wake_up(&conf->wait_barrier);
> +	wake_up_barrier(conf);
>   }
>   
>   static bool raid1_make_request(struct mddev *mddev, struct bio *bio)
> 

