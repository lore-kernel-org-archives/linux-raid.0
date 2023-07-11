Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ECA3EB64DC
	for <linux-raid@archiver.kernel.org>; Tue, 11 Jul 2023 12:55:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbjGKMzK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 11 Jul 2023 08:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbjGKMyl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 11 Jul 2023 08:54:41 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A8A19A9
        for <linux-raid@vger.kernel.org>; Tue, 11 Jul 2023 05:54:25 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4R0gN14vSWz4f3m8r
        for <linux-raid@vger.kernel.org>; Tue, 11 Jul 2023 20:36:17 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgAHuKvBTK1kjtDnNg--.19383S3;
        Tue, 11 Jul 2023 20:36:18 +0800 (CST)
Subject: Re: [PATCH v2 2/3] md/raid1: free old r1bio before retry write
To:     Xueshi Hu <xueshi.hu@smartx.com>, song@kernel.org
Cc:     linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20230709102956.1716708-1-hubachelar@gmail.com>
 <20230709102956.1716708-3-hubachelar@gmail.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <9291a33b-d764-5890-ab39-0790cc8a211d@huaweicloud.com>
Date:   Tue, 11 Jul 2023 20:36:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20230709102956.1716708-3-hubachelar@gmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgAHuKvBTK1kjtDnNg--.19383S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Zr17Zr13Ww4kGr4UZFWrKrg_yoW8GF4Dpa
        1jgFy8urZ8GrWYvF4DAFWUuFyrZw4vqF92krWxGw18ZF12qryq93WUXryYgrn8uFy3CwsF
        y3Z0k347G3y2vFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
        0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0E
        wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
        80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0
        I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
        k26cxKx2IYs7xG6Fyj6rWUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
        7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUrNtxDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

ÔÚ 2023/07/09 18:29, Xueshi Hu Ð´µÀ:
> From: Xueshi Hu <xueshi.hu@smartx.com>
> 
> allow_barrier() make reshape possible. Raid reshape changes the
> r1conf::raid_disks and mempool, so free the old r1bio and alloc a new one
> when retry write.
> 
LGTM, feel free to add:

Reviewed-by: Yu Kuai <yukuai3@huawei.com>
> Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
> ---
>   drivers/md/raid1.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index ce48cb3af301..6c54786067b4 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1373,6 +1373,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>   		return;
>   	}
>   
> + retry_write:
>   	r1_bio = alloc_r1bio(mddev, bio);
>   	r1_bio->sectors = max_write_sectors;
>   
> @@ -1388,7 +1389,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>   	 */
>   
>   	disks = conf->raid_disks * 2;
> - retry_write:
>   	blocked_rdev = NULL;
>   	rcu_read_lock();
>   	max_sectors = r1_bio->sectors;
> @@ -1468,7 +1468,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>   		for (j = 0; j < i; j++)
>   			if (r1_bio->bios[j])
>   				rdev_dec_pending(conf->mirrors[j].rdev, mddev);
> -		r1_bio->state = 0;
> +		free_r1bio(r1_bio);
>   		allow_barrier(conf, bio->bi_iter.bi_sector);
>   
>   		if (bio->bi_opf & REQ_NOWAIT) {
> 

