Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 981E3C001DB
	for <linux-raid@archiver.kernel.org>; Mon, 14 Aug 2023 12:35:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjHNMf0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Aug 2023 08:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbjHNMfN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Aug 2023 08:35:13 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0700E10C1
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 05:35:07 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4RPYkv4V3rz4f3lXw
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 20:35:03 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgBH16l2H9pkFiTHAg--.52952S3;
        Mon, 14 Aug 2023 20:35:03 +0800 (CST)
Subject: Re: [PATCH v5 1/3] md/raid1: call free_r1bio() before allow_barrier()
To:     Xueshi Hu <xueshi.hu@smartx.com>, song@kernel.org,
        djeffery@redhat.com, dan.j.williams@intel.com, neilb@suse.de,
        akpm@linux-foundation.org, neilb@suse.com
Cc:     linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20230814085108.991040-1-xueshi.hu@smartx.com>
 <20230814085108.991040-2-xueshi.hu@smartx.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <76f086c8-17e9-2336-a241-6c030a8ccd9b@huaweicloud.com>
Date:   Mon, 14 Aug 2023 20:35:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20230814085108.991040-2-xueshi.hu@smartx.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgBH16l2H9pkFiTHAg--.52952S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ur17urW7JF4DtFyxKF1xZrb_yoW8AFyUpa
        1UG3sa93ykJFya9w4DtF4UuFyrZanYgFyrC393Wws5WFn2qFZ8KF1UXF15Wr18ZFs3KF47
        t3Z5C3y3X3yYyaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
        0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0E
        wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
        80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0
        I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
        k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UWE__UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

ÔÚ 2023/08/14 16:51, Xueshi Hu Ð´µÀ:
> After allow_barrier(), an concurrent raid1_reshape() will replace old
> mempool and r1conf::raid_disks, which are necessary when freeing the
> r1bio. Change the execution order of free_r1bio() and allow_barrier() so
> that kernel can free r1bio safely.
> 
> Fixes: c91114c2b89d ("md/raid1: release pending accounting for an I/O only after write-behind is also finished")

This fix tag is not correct, before c91114c2b89d, allow_barrier() is
still called before free_r1bio(). And this behaviour goes all the way
back to Linux-2.6.12-rc2.

I think it's okay just to remove the fix tag for this patch.

After removing the tag, feel free to add

Reviewed-by: Yu Kuai <yukuai3@huawei.com>

> Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
> ---
>   drivers/md/raid1.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index dd25832eb045..dbbee0c14a5b 100644
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
> 

