Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CB3DC4332F
	for <linux-raid@archiver.kernel.org>; Thu,  2 Nov 2023 01:24:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348035AbjKBBYK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Nov 2023 21:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235076AbjKBBYJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Nov 2023 21:24:09 -0400
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA9210C
        for <linux-raid@vger.kernel.org>; Wed,  1 Nov 2023 18:24:06 -0700 (PDT)
Received: from mail.maildlp.com (unknown [172.19.93.142])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4SLR3c5JxHz4f3jJ6
        for <linux-raid@vger.kernel.org>; Thu,  2 Nov 2023 09:23:56 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
        by mail.maildlp.com (Postfix) with ESMTP id EA2D01A0171
        for <linux-raid@vger.kernel.org>; Thu,  2 Nov 2023 09:24:02 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgAnvdwx+kJlqBJfEg--.42785S3;
        Thu, 02 Nov 2023 09:24:02 +0800 (CST)
Subject: Re: [RFC] md/raid5: fix hung by MD_SB_CHANGE_PENDING
To:     Junxiao Bi <junxiao.bi@oracle.com>, linux-raid@vger.kernel.org
Cc:     song@kernel.org, logang@deltatee.com,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20231101230214.57190-1-junxiao.bi@oracle.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <6183bbd0-09c2-3629-ed93-a7485c13e6bb@huaweicloud.com>
Date:   Thu, 2 Nov 2023 09:24:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20231101230214.57190-1-junxiao.bi@oracle.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgAnvdwx+kJlqBJfEg--.42785S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCr4rXF45XF1xJr48CFW8Xrb_yoW5Cw1rp3
        y8AFyY9F18Wrykua1xKasrWrWYvw1UKrW29rW3Za4ktwn2vry3Ka4rCFyDJr4vq3sayFs8
        J3y5G393G3WUC3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

ÔÚ 2023/11/02 7:02, Junxiao Bi Ð´µÀ:
> Looks like there is a race between md_write_start() and raid5d() which

Is this a real issue or just based on code review?
> can cause deadlock. Run into this issue while raid_check is running.
> 
>   md_write_start:                                                                        raid5d:
>   if (mddev->safemode == 1)
>       mddev->safemode = 0;
>   /* sync_checkers is always 0 when writes_pending is in per-cpu mode */
>   if (mddev->in_sync || mddev->sync_checkers) {
>       spin_lock(&mddev->lock);
>       if (mddev->in_sync) {
>           mddev->in_sync = 0;
>           set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
>           set_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags);
>                                                                                          >>> running before md_write_start wake up it
>                                                                                          if (mddev->sb_flags & ~(1 << MD_SB_CHANGE_PENDING)) {
>                                                                                                spin_unlock_irq(&conf->device_lock);
>                                                                                                md_check_recovery(mddev);
>                                                                                                spin_lock_irq(&conf->device_lock);
> 
>                                                                                                /*
>                                                                                                 * Waiting on MD_SB_CHANGE_PENDING below may deadlock
>                                                                                                 * seeing md_check_recovery() is needed to clear
>                                                                                                 * the flag when using mdmon.
>                                                                                                 */
>                                                                                                continue;
>                                                                                           }
> 
>                                                                                           wait_event_lock_irq(mddev->sb_wait,     >>>>>>>>>>> hung
>                                                                                               !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags),
>                                                                                               conf->device_lock);
>           md_wakeup_thread(mddev->thread);
>           did_change = 1;
>       }
>       spin_unlock(&mddev->lock);
>   }
> 
>   ...
> 
>   wait_event(mddev->sb_wait,    >>>>>>>>>> hung
>      !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) ||
>      mddev->suspended);
> 

This is not correct, if daemon thread is running, md_wakeup_thread()
will make sure that daemon thread will run again, see details how
THREAD_WAKEUP worked in md_thread().

Thanks,
Kuai

> commit 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d")
> introduced this issue, since it want to a reschedule for flushing blk_plug,
> let do it explicitly to address that issue.
> 
> Fixes: 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d")
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
>   block/blk-core.c   | 1 +
>   drivers/md/raid5.c | 9 +++++----
>   2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 9d51e9894ece..bc8757a78477 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1149,6 +1149,7 @@ void __blk_flush_plug(struct blk_plug *plug, bool from_schedule)
>   	if (unlikely(!rq_list_empty(plug->cached_rq)))
>   		blk_mq_free_plug_rqs(plug);
>   }
> +EXPORT_SYMBOL(__blk_flush_plug);
>   
>   /**
>    * blk_finish_plug - mark the end of a batch of submitted I/O
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 284cd71bcc68..25ec82f2813f 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6850,11 +6850,12 @@ static void raid5d(struct md_thread *thread)
>   			 * the flag when using mdmon.
>   			 */
>   			continue;
> +		} else {
> +			spin_unlock_irq(&conf->device_lock);
> +			blk_flush_plug(current);
> +			cond_resched();
> +			spin_lock_irq(&conf->device_lock);
>   		}
> -
> -		wait_event_lock_irq(mddev->sb_wait,
> -			!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags),
> -			conf->device_lock);
>   	}
>   	pr_debug("%d stripes handled\n", handled);
>   
> 

