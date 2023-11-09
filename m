Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EC8BC4167D
	for <linux-raid@archiver.kernel.org>; Thu,  9 Nov 2023 06:28:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbjKIG2b (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Nov 2023 01:28:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjKIG2a (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Nov 2023 01:28:30 -0500
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7C619A5
        for <linux-raid@vger.kernel.org>; Wed,  8 Nov 2023 22:28:28 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.163.216])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4SQsTd4C6Lz4f3m6j
        for <linux-raid@vger.kernel.org>; Thu,  9 Nov 2023 14:28:21 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
        by mail.maildlp.com (Postfix) with ESMTP id 687E01A0170
        for <linux-raid@vger.kernel.org>; Thu,  9 Nov 2023 14:28:25 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP1 (Coremail) with SMTP id cCh0CgBXWhAHfExlctq+AQ--.24285S3;
        Thu, 09 Nov 2023 14:28:25 +0800 (CST)
Subject: Re: [PATCH V3 2/2] Revert "md/raid5: Wait for MD_SB_CHANGE_PENDING in
 raid5d"
To:     Junxiao Bi <junxiao.bi@oracle.com>, linux-raid@vger.kernel.org
Cc:     song@kernel.org, logang@deltatee.com, yukuai1@huaweicloud.com,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20231108182216.73611-1-junxiao.bi@oracle.com>
 <20231108182216.73611-2-junxiao.bi@oracle.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <a08baf6c-ae35-f83d-2524-4715263c512a@huaweicloud.com>
Date:   Thu, 9 Nov 2023 14:28:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20231108182216.73611-2-junxiao.bi@oracle.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cCh0CgBXWhAHfExlctq+AQ--.24285S3
X-Coremail-Antispam: 1UD129KBjvJXoW7AFykuFyfJw15AFWrJFyfCrg_yoW8AF1Dp3
        93AF1YgF4UWry8CF9rCry7uFWq9anFy342qryfZ3WkJ392vr9rKayrCryDJrn5Za9Ika18
        t345Gry3Z3W5KrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
        IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_
        Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbU
        UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

ÔÚ 2023/11/09 2:22, Junxiao Bi Ð´µÀ:
> This reverts commit 5e2cf333b7bd5d3e62595a44d598a254c697cd74.
> 
> That commit introduced the following race and can cause system hung.
> 
>   md_write_start:             raid5d:
>   // mddev->in_sync == 1
>   set "MD_SB_CHANGE_PENDING"
>                              // running before md_write_start wakeup it
>                               waiting "MD_SB_CHANGE_PENDING" cleared
>                               >>>>>>>>> hung
>   wakeup mddev->thread
>   ...
>   waiting "MD_SB_CHANGE_PENDING" cleared
>   >>>> hung, raid5d should clear this flag
>   but get hung by same flag.
> 
> The issue reverted commit fixing is fixed by last patch in a new way.
> 
> Fixes: 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d")
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>

LGTM
Reviewed-by: Yu Kuai <yukuai3@huawei.com>

> ---
>   drivers/md/raid5.c | 12 ------------
>   1 file changed, 12 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index dc031d42f53b..fcc8a44dd4fd 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -36,7 +36,6 @@
>    */
>   
>   #include <linux/blkdev.h>
> -#include <linux/delay.h>
>   #include <linux/kthread.h>
>   #include <linux/raid/pq.h>
>   #include <linux/async_tx.h>
> @@ -6820,18 +6819,7 @@ static void raid5d(struct md_thread *thread)
>   			spin_unlock_irq(&conf->device_lock);
>   			md_check_recovery(mddev);
>   			spin_lock_irq(&conf->device_lock);
> -
> -			/*
> -			 * Waiting on MD_SB_CHANGE_PENDING below may deadlock
> -			 * seeing md_check_recovery() is needed to clear
> -			 * the flag when using mdmon.
> -			 */
> -			continue;
>   		}
> -
> -		wait_event_lock_irq(mddev->sb_wait,
> -			!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags),
> -			conf->device_lock);
>   	}
>   	pr_debug("%d stripes handled\n", handled);
>   
> 

