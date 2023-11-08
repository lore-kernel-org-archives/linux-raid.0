Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 012B2C4332F
	for <linux-raid@archiver.kernel.org>; Wed,  8 Nov 2023 01:05:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234473AbjKHBFD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Nov 2023 20:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235260AbjKHBFC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Nov 2023 20:05:02 -0500
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281E810E
        for <linux-raid@vger.kernel.org>; Tue,  7 Nov 2023 17:05:00 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.93.142])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4SQ6Lt3Sd7z4f3k6Z
        for <linux-raid@vger.kernel.org>; Wed,  8 Nov 2023 09:04:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
        by mail.maildlp.com (Postfix) with ESMTP id C84C41A0199
        for <linux-raid@vger.kernel.org>; Wed,  8 Nov 2023 09:04:56 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP1 (Coremail) with SMTP id cCh0CgDX2hC33kplBfZPAQ--.44736S3;
        Wed, 08 Nov 2023 09:04:56 +0800 (CST)
Subject: Re: [PATCH V2 1/2] md: bypass block throttle for superblock update
To:     Junxiao Bi <junxiao.bi@oracle.com>, linux-raid@vger.kernel.org
Cc:     song@kernel.org, logang@deltatee.com, yukuai1@huaweicloud.com,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20231107212412.51470-1-junxiao.bi@oracle.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <28594dd9-f0c4-8230-b112-742dfec41729@huaweicloud.com>
Date:   Wed, 8 Nov 2023 09:04:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20231107212412.51470-1-junxiao.bi@oracle.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cCh0CgDX2hC33kplBfZPAQ--.44736S3
X-Coremail-Antispam: 1UD129KBjvJXoW7KFW8CrWDCr48tFW7Cr1Dtrb_yoW8Gw1Dpr
        WxA3WY9rWUAr1kC3ZrJFy8uFyrW3WIy3y2yry3Cw48ZFWYqryUG3WFk3yvqFyDZr9a9F17
        JF1UWF93X3W8ZrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
        Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UU
        UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

ÔÚ 2023/11/08 5:24, Junxiao Bi Ð´µÀ:
> commit 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d")
> introduced a hung bug and will be reverted in next patch, since the issue
> that commit is fixing is due to md superblock write is throttled by wbt,
> to fix it, we can have superblock write bypass block layer throttle.
> 
> Fixes: 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d")
> Suggested-by: Yu Kuai <yukuai1@huaweicloud.com>
Plese use this address, yukuai3@huawei.com
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> ---

LGTM
Reviewed-by: Yu Kuai <yukuai3@huawei.com>

Thanks
>   v2 <- v1:
>   - swap the order of the patch
>   - small tweak of the patch log
> 
>   drivers/md/md.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 4ee4593c874a..7a5a22097365 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1013,9 +1013,10 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
>   		return;
>   
>   	bio = bio_alloc_bioset(rdev->meta_bdev ? rdev->meta_bdev : rdev->bdev,
> -			       1,
> -			       REQ_OP_WRITE | REQ_SYNC | REQ_PREFLUSH | REQ_FUA,
> -			       GFP_NOIO, &mddev->sync_set);
> +			      1,
> +			      REQ_OP_WRITE | REQ_SYNC | REQ_IDLE | REQ_META
> +				  | REQ_PREFLUSH | REQ_FUA,
> +			      GFP_NOIO, &mddev->sync_set);
>   
>   	atomic_inc(&rdev->nr_pending);
>   
> 

