Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5670BEB64DD
	for <linux-raid@archiver.kernel.org>; Tue, 11 Jul 2023 12:38:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbjGKMiw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 11 Jul 2023 08:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232512AbjGKMio (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 11 Jul 2023 08:38:44 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF05D199F
        for <linux-raid@vger.kernel.org>; Tue, 11 Jul 2023 05:38:20 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4R0gPl710Nz4f3pJY
        for <linux-raid@vger.kernel.org>; Tue, 11 Jul 2023 20:37:47 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgAHuKscTa1keuHnNg--.19412S3;
        Tue, 11 Jul 2023 20:37:48 +0800 (CST)
Subject: Re: [PATCH v2 3/3] md/raid1: keep holding the barrier in
 handle_read_error()
To:     Xueshi Hu <xueshi.hu@smartx.com>, song@kernel.org
Cc:     linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20230709102956.1716708-1-hubachelar@gmail.com>
 <20230709102956.1716708-4-hubachelar@gmail.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <8fef53f5-257f-ca0a-b8c5-b61d2db96f2b@huaweicloud.com>
Date:   Tue, 11 Jul 2023 20:37:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20230709102956.1716708-4-hubachelar@gmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgAHuKscTa1keuHnNg--.19412S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Zr17JrW5Gw18GryUZw1UKFg_yoW8Ar1kpw
        srCFZ3Zr9rG34a93W3AFWDuF9Y9wsYgFW8ArWxAw1I9rnFqr90kFyDGr9Ygr98urWrG347
        X3Z0k3srG3ZxtFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
        xK8VAvwI8IcIk0rVW3JVWrJr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
        1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1QVy3UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

ÔÚ 2023/07/09 18:29, Xueshi Hu Ð´µÀ:
> From: Xueshi Hu <xueshi.hu@smartx.com>
> 
> Raid reshape changes the r1conf::raid_disks and mempool. Keep holding the
> barrier in handle_read_error() to avoid raid reshape.
> 
> Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
> ---
>   drivers/md/raid1.c | 25 ++++++++++++-------------
>   1 file changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 6c54786067b4..43a9c095f94d 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1240,20 +1240,20 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
>   		rcu_read_unlock();
>   	}
>   
> -	/*
> -	 * Still need barrier for READ in case that whole
> -	 * array is frozen.
> -	 */
> -	if (!wait_read_barrier(conf, bio->bi_iter.bi_sector,
> -				bio->bi_opf & REQ_NOWAIT)) {
> -		bio_wouldblock_error(bio);
> -		return;
> -	}
> -
> -	if (!r1_bio)
> +	if (!r1_bio) {
> +		/*
> +		 * Still need barrier for READ in case that whole
> +		 * array is frozen.
> +		 */
> +		if (!wait_read_barrier(conf, bio->bi_iter.bi_sector,
> +					bio->bi_opf & REQ_NOWAIT)) {
> +			bio_wouldblock_error(bio);
> +			return;
> +		}
>   		r1_bio = alloc_r1bio(mddev, bio);
> -	else
> +	} else
>   		init_r1bio(r1_bio, mddev, bio);
> +
>   	r1_bio->sectors = max_read_sectors;
>   
>   	/*
> @@ -2527,7 +2527,6 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>   	}
>   
>   	rdev_dec_pending(rdev, conf->mddev);
> -	allow_barrier(conf, r1_bio->sector);

I think it's better to just move allow_barrier() to after
raid1_read_request().

Thanks,
Kuai
>   	bio = r1_bio->master_bio;
>   
>   	/* Reuse the old r1_bio so that the IO_BLOCKED settings are preserved */
> 

