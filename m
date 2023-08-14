Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46179C04A6A
	for <linux-raid@archiver.kernel.org>; Mon, 14 Aug 2023 12:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbjHNMii (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Aug 2023 08:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbjHNMib (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Aug 2023 08:38:31 -0400
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D741703
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 05:38:22 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4RPYpc2z75z4f3mKy
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 20:38:16 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgA3x6k6INpk_krHAg--.41276S3;
        Mon, 14 Aug 2023 20:38:19 +0800 (CST)
Subject: Re: [PATCH v5 3/3] md/raid1: keep the barrier held until
 handle_read_error() finished
To:     Xueshi Hu <xueshi.hu@smartx.com>, song@kernel.org,
        djeffery@redhat.com, dan.j.williams@intel.com, neilb@suse.de,
        akpm@linux-foundation.org, neilb@suse.com
Cc:     linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20230814085108.991040-1-xueshi.hu@smartx.com>
 <20230814085108.991040-4-xueshi.hu@smartx.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <4d7938bf-07e7-608b-8b0a-c7707e7b5e6c@huaweicloud.com>
Date:   Mon, 14 Aug 2023 20:38:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20230814085108.991040-4-xueshi.hu@smartx.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgA3x6k6INpk_krHAg--.41276S3
X-Coremail-Antispam: 1UD129KBjvJXoW7KF18XF4kAr17WFW8JF48Crg_yoW8Xr43pa
        1UGas7ZrWDJFWY93WqyFWDua4Fv3sYgFW8CrWkWwn7uF1vqrZ0kFWUWa45Wrn8Cr45W342
        qF1DK39rAF4jyFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
        0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0E
        wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
        80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0
        I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04
        k26cxKx2IYs7xG6Fyj6rWUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
        7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUrcTmDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

ÔÚ 2023/08/14 16:51, Xueshi Hu Ð´µÀ:
> handle_read_error() will call allow_barrier() to match the former barrier
> raising. However, it should put the allow_barrier() at the end to avoid an
> concurrent raid reshape.
> 
> Fixes: 689389a06ce7 ("md/raid1: simplify handle_read_error().")

LGTM

Reviewed-by: Yu Kuai <yukuai3@huawei.com>

> Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
> ---
>   drivers/md/raid1.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 5f17f30a00a9..5a5eb5f1a224 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2499,6 +2499,7 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>   	struct mddev *mddev = conf->mddev;
>   	struct bio *bio;
>   	struct md_rdev *rdev;
> +	sector_t sector;
>   
>   	clear_bit(R1BIO_ReadError, &r1_bio->state);
>   	/* we got a read error. Maybe the drive is bad.  Maybe just
> @@ -2528,12 +2529,13 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
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

