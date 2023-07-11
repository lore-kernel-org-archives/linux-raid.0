Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C446EEB64DC
	for <linux-raid@archiver.kernel.org>; Tue, 11 Jul 2023 12:51:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbjGKMvx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 11 Jul 2023 08:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbjGKMvq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 11 Jul 2023 08:51:46 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220B210EA
        for <linux-raid@vger.kernel.org>; Tue, 11 Jul 2023 05:51:45 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4R0gLn6m8Pz4f3pFv
        for <linux-raid@vger.kernel.org>; Tue, 11 Jul 2023 20:35:13 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgBH_rGBTK1k5cPnNg--.55600S3;
        Tue, 11 Jul 2023 20:35:14 +0800 (CST)
Subject: Re: [PATCH v2 1/3] md/raid1: gave up reshape in case there's queued
 io
To:     Xueshi Hu <xueshi.hu@smartx.com>, song@kernel.org
Cc:     linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20230709102956.1716708-1-hubachelar@gmail.com>
 <20230709102956.1716708-2-hubachelar@gmail.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <ff93bc7a-5ae2-7a85-91c9-9662d3c5a442@huaweicloud.com>
Date:   Tue, 11 Jul 2023 20:35:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20230709102956.1716708-2-hubachelar@gmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgBH_rGBTK1k5cPnNg--.55600S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Zr17uw43XFW7WrWkXFW3trb_yoW8GFW3pw
        s8JasxCFWUW34fKF45Xa4UuFyFvan7KryUKFZ5C34UZr13JFyxZrW8Kay5Kr1qvry3Gws2
        qF4rtrZ3Ca9Fqa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
        0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0E
        wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
        80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0
        I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
        k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
        1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1CPfJUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

ÔÚ 2023/07/09 18:29, Xueshi Hu Ð´µÀ:
> From: Xueshi Hu <xueshi.hu@smartx.com>
> 
> When an IO error happens, reschedule_retry() will increase
> r1conf::nr_queued, which makes freeze_array() unblocked. However, before
> all r1bio in the memory pool are released, the memory pool should not be
> modified.
> 

I didn't recieve these emails directly, I just notice this patchse...

It's right this is a problem, but I'm not sure about the fix, this fix
will work fine for the case that new reshape is started, however, for
the case that reshape is interrupted, this might cause that
md_check_recovery() can't continue to reshape atomically.

Perhaps raid1_reshape() can be improved that if oldpool and newpool is
the same, don't reallocate it.

Thanks,
Kuai
> Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
> ---
>   drivers/md/raid1.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index dd25832eb045..ce48cb3af301 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -3298,6 +3298,13 @@ static int raid1_reshape(struct mddev *mddev)
>   
>   	freeze_array(conf, 0);
>   
> +	if (unlikely(atomic_read(conf->nr_queued))) {
> +		kfree(newpoolinfo);
> +		mempool_exit(&newpool);
> +		unfreeze_array(conf);
> +		return -EBUSY;
> +	}
> +
>   	/* ok, everything is stopped */
>   	oldpool = conf->r1bio_pool;
>   	conf->r1bio_pool = newpool;
> 

