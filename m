Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AE5BC0015E
	for <linux-raid@archiver.kernel.org>; Sat, 12 Aug 2023 08:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233570AbjHLIGz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 12 Aug 2023 04:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235237AbjHLIGx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 12 Aug 2023 04:06:53 -0400
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018DB26A0
        for <linux-raid@vger.kernel.org>; Sat, 12 Aug 2023 01:06:39 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4RNCt04tsZz4f44QK
        for <linux-raid@vger.kernel.org>; Sat, 12 Aug 2023 16:06:32 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgAnBaiJPddkMuEXAg--.44504S3;
        Sat, 12 Aug 2023 16:06:35 +0800 (CST)
Subject: Re: [PATCH v4] md/raid1: don't allow_barrier() before r1bio got freed
To:     Xueshi Hu <xueshi.hu@smartx.com>, song@kernel.org,
        djeffery@redhat.com, dan.j.williams@intel.com, neilb@suse.de,
        akpm@linux-foundation.org, shli@fb.com, neilb@suse.com
Cc:     linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20230808033211.197383-1-xueshi.hu@smartx.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <f9524fe8-8178-b83b-ec55-2a902c4f998c@huaweicloud.com>
Date:   Sat, 12 Aug 2023 16:06:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20230808033211.197383-1-xueshi.hu@smartx.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgAnBaiJPddkMuEXAg--.44504S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJF1fZF18WrykJF4fJF47urg_yoWrXw43pa
        yUGFna9rZ8JrWY9wnrtFWDCFyF9wsYqFy7ArWxWw18u3ZYgrZ0kFW8WFyYgryrAry5Wr42
        y3WDC39rZrW2vFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvIb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
        0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7I2V7IY0VAS
        07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
        02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_
        GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
        CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE
        14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf
        9x07UQzVbUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

ÔÚ 2023/08/08 11:32, Xueshi Hu Ð´µÀ:
> Because raid reshape changes the r1conf::raid_disks and the mempool, it
> orders that there's no in-flight r1bio when reshaping. However, the
> current caller of allow_barrier() allows the reshape
> operation to proceed even if the old r1bio requests have not been freed.
> 
> Free the r1bio firstly before allow_barrier()
> 
> Fixes: c91114c2b89d ("md/raid1: release pending accounting for an I/O only after write-behind is also finished")
> Fixes: 6bfe0b499082 ("md: support blocking writes to an array on device failure")
> Fixes: 689389a06ce7 ("md/raid1: simplify handle_read_error().")

It's just a suggestion, you can split this patch into 3 patches, one for
each fix.

> Reviewed-by: Yu Kuai <yukuai3@huawei.com>
> Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
> ---
> -> v2:
> 	- fix the problem one by one instead of calling
> 	blk_mq_freeze_queue() as suggested by Yu Kuai
> -> v3:
> 	- add freeze_array_totally() to replace freeze_array() instead
> 	  of gave up in raid1_reshape()
> 	- add a missed fix in raid_end_bio_io()
> 	- add a small check at the start of raid1_reshape()
> -> v4:
> 	- add fix tag and revise the commit message
> 	- drop patch 1 as there is an ongoing systematic fix for the bug

I think it's okay to fix the bug as I suggested in v3, the refactor is a
long term...

Thanks,
Kuai

> 	- drop patch 3 as it's unrelated which will be sent in
> 	another patch
> 
>   drivers/md/raid1.c | 15 +++++++++------
>   1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index dd25832eb045..5a5eb5f1a224 100644
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
> @@ -1373,6 +1374,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>   		return;
>   	}
>   
> + retry_write:
>   	r1_bio = alloc_r1bio(mddev, bio);
>   	r1_bio->sectors = max_write_sectors;
>   
> @@ -1388,7 +1390,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>   	 */
>   
>   	disks = conf->raid_disks * 2;
> - retry_write:
>   	blocked_rdev = NULL;
>   	rcu_read_lock();
>   	max_sectors = r1_bio->sectors;
> @@ -1468,7 +1469,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>   		for (j = 0; j < i; j++)
>   			if (r1_bio->bios[j])
>   				rdev_dec_pending(conf->mirrors[j].rdev, mddev);
> -		r1_bio->state = 0;
> +		free_r1bio(r1_bio);
>   		allow_barrier(conf, bio->bi_iter.bi_sector);
>   
>   		if (bio->bi_opf & REQ_NOWAIT) {
> @@ -2498,6 +2499,7 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>   	struct mddev *mddev = conf->mddev;
>   	struct bio *bio;
>   	struct md_rdev *rdev;
> +	sector_t sector;
>   
>   	clear_bit(R1BIO_ReadError, &r1_bio->state);
>   	/* we got a read error. Maybe the drive is bad.  Maybe just
> @@ -2527,12 +2529,13 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
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

