Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DADCC001B0
	for <linux-raid@archiver.kernel.org>; Thu, 20 Jul 2023 01:47:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjGTBrj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 Jul 2023 21:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjGTBri (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 19 Jul 2023 21:47:38 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6415F1FDF
        for <linux-raid@vger.kernel.org>; Wed, 19 Jul 2023 18:47:37 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4R5wYK5920z4f3lDg
        for <linux-raid@vger.kernel.org>; Thu, 20 Jul 2023 09:47:33 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgAHuKs1krhkkdp7OQ--.27370S3;
        Thu, 20 Jul 2023 09:47:34 +0800 (CST)
Subject: Re: [PATCH v3 2/3] md/raid1: don't allow_barrier() before r1bio got
 freed
To:     Xueshi Hu <xueshi.hu@smartx.com>, song@kernel.org
Cc:     linux-raid@vger.kernel.org, yukuai1@huaweicloud.com,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20230719070954.3084379-1-xueshi.hu@smartx.com>
 <20230719070954.3084379-3-xueshi.hu@smartx.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <f572ebcf-bfc7-739e-68f1-506d16d0ff31@huaweicloud.com>
Date:   Thu, 20 Jul 2023 09:47:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20230719070954.3084379-3-xueshi.hu@smartx.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgAHuKs1krhkkdp7OQ--.27370S3
X-Coremail-Antispam: 1UD129KBjvJXoWxuryrXF4UZF1DuryfGFWUCFg_yoW5Ar45pw
        4UWF1kurZ8JrW5ZwnrtFWDuF1F939YgFyxCrWxWwnYgFn2grZ8KF18XryYgr15CFW5Wry7
        A3Z8C39rGrW2vFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkE14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
        IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j
        6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JU918
        9UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

ÔÚ 2023/07/19 15:09, Xueshi Hu Ð´µÀ:
> allow_barrier() make reshape possible. Raid reshape changes the
> r1conf::raid_disks and mempool. Free the r1bio firstly and then call
> allow_barrier()
> 

After adding fixes tags, feel free to add:

Reviewed-by: Yu Kuai <yukuai3@huawei.com>
> Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
> ---
>   drivers/md/raid1.c | 15 +++++++++------
>   1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 5605c9680818..62e86b7d1561 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -313,6 +313,7 @@ static void raid_end_bio_io(struct r1bio *r1_bio)
>   {
>   	struct bio *bio = r1_bio->master_bio;
>   	struct r1conf *conf = r1_bio->mddev->private;
> +	sector_t sector = r1_bio->sector;
>   
>   	/* if nobody has done the final endio yet, do it now */
>   	if (!test_and_set_bit(R1BIO_Returned, &r1_bio->state)) {
> @@ -323,13 +324,13 @@ static void raid_end_bio_io(struct r1bio *r1_bio)
>   
>   		call_bio_endio(r1_bio);
>   	}
> +
> +	free_r1bio(r1_bio);
>   	/*
>   	 * Wake up any possible resync thread that waits for the device
>   	 * to go idle.  All I/Os, even write-behind writes, are done.
>   	 */
> -	allow_barrier(conf, r1_bio->sector);
> -
> -	free_r1bio(r1_bio);
> +	allow_barrier(conf, sector);
>   }
>   
>   /*
> @@ -1404,6 +1405,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>   		return;
>   	}
>   
> + retry_write:
>   	r1_bio = alloc_r1bio(mddev, bio);
>   	r1_bio->sectors = max_write_sectors;
>   
> @@ -1419,7 +1421,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>   	 */
>   
>   	disks = conf->raid_disks * 2;
> - retry_write:
>   	blocked_rdev = NULL;
>   	rcu_read_lock();
>   	max_sectors = r1_bio->sectors;
> @@ -1499,7 +1500,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>   		for (j = 0; j < i; j++)
>   			if (r1_bio->bios[j])
>   				rdev_dec_pending(conf->mirrors[j].rdev, mddev);
> -		r1_bio->state = 0;
> +		free_r1bio(r1_bio);
>   		allow_barrier(conf, bio->bi_iter.bi_sector);
>   
>   		if (bio->bi_opf & REQ_NOWAIT) {
> @@ -2529,6 +2530,7 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>   	struct mddev *mddev = conf->mddev;
>   	struct bio *bio;
>   	struct md_rdev *rdev;
> +	sector_t sector;
>   
>   	clear_bit(R1BIO_ReadError, &r1_bio->state);
>   	/* we got a read error. Maybe the drive is bad.  Maybe just
> @@ -2558,12 +2560,13 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>   	}
>   
>   	rdev_dec_pending(rdev, conf->mddev);
> -	allow_barrier(conf, r1_bio->sector);
> +	sector = r1_bio->sector;
>   	bio = r1_bio->master_bio;
>   
>   	/* Reuse the old r1_bio so that the IO_BLOCKED settings are preserved */
>   	r1_bio->state = 0;
>   	raid1_read_request(mddev, bio, r1_bio->sectors, r1_bio);
> +	allow_barrier(conf, sector);
>   }
>   
>   static void raid1d(struct md_thread *thread)
> 

