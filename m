Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7624FC54E76
	for <linux-raid@archiver.kernel.org>; Mon, 20 Nov 2023 01:05:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbjKTBFU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 19 Nov 2023 20:05:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjKTBFT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 19 Nov 2023 20:05:19 -0500
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6138FF2
        for <linux-raid@vger.kernel.org>; Sun, 19 Nov 2023 17:05:14 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.163.235])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4SYTnd21Byz4f3lwC
        for <linux-raid@vger.kernel.org>; Mon, 20 Nov 2023 09:05:09 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
        by mail.maildlp.com (Postfix) with ESMTP id CEBEA1A0176
        for <linux-raid@vger.kernel.org>; Mon, 20 Nov 2023 09:05:10 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP1 (Coremail) with SMTP id cCh0CgCnqxHEsFplA8eZBQ--.60700S3;
        Mon, 20 Nov 2023 09:05:08 +0800 (CST)
Subject: Re: [PATCH] md: fix bi_status reporting in md_end_clone_io
To:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
Cc:     Bhanu Victor DiCara <00bvd0+linux@gmail.com>,
        Xiao Ni <xni@redhat.com>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20231118003958.2740032-1-song@kernel.org>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <b2adc12a-66f5-501e-b121-788da97ba21b@huaweicloud.com>
Date:   Mon, 20 Nov 2023 09:05:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20231118003958.2740032-1-song@kernel.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cCh0CgCnqxHEsFplA8eZBQ--.60700S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar4kKr18tw13Cw4rAF4kXrb_yoW8Wr1Upa
        yxCFW5CrZ8XF409ayUGa4j9a4Fqa1DXrW2vFW8Jw1xZFn0vr98Zr4xWas8Xr1DCFyUCry2
        yF1kua9ruw4YyrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
        xK8VAvwI8IcIk0rVW8JVW3JwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
        7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUOyCJDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

ÔÚ 2023/11/18 8:39, Song Liu Ð´µÀ:
> md_end_clone_io() may overwrite error status in orig_bio->bi_status with
> BLK_STS_OK. This could happen when orig_bio has BIO_CHAIN (split by
> md_submit_bio => bio_split_to_limits, for example). As a result, upper
> layer may miss error reported from md (or the device) and consider the
> failed IO was successful.
> 
> Fix this by only update orig_bio->bi_status when current bio reports
> error and orig_bio is BLK_STS_OK. This is the same behavior as
> __bio_chain_endio().

LGTM
Reviewed-by: Yu Kuai <yukuai3@huawei.com>

> 
> Fixes: 10764815ff47 ("md: add io accounting for raid0 and raid5")
> Reported-by: Bhanu Victor DiCara <00bvd0+linux@gmail.com>
> Closes: https://lore.kernel.org/regressions/5727380.DvuYhMxLoT@bvd0/
> Signed-off-by: Song Liu <song@kernel.org>
> Tested-by: Xiao Ni <xni@redhat.com>
> Cc: Guoqing Jiang <guoqing.jiang@linux.dev>
> ---
>   drivers/md/md.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 4ee4593c874a..c94373d64f2c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8666,7 +8666,8 @@ static void md_end_clone_io(struct bio *bio)
>   	struct bio *orig_bio = md_io_clone->orig_bio;
>   	struct mddev *mddev = md_io_clone->mddev;
>   
> -	orig_bio->bi_status = bio->bi_status;
> +	if (bio->bi_status && !orig_bio->bi_status)
> +		orig_bio->bi_status = bio->bi_status;
>   
>   	if (md_io_clone->start_time)
>   		bio_end_io_acct(orig_bio, md_io_clone->start_time);
> 

