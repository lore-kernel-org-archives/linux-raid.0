Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8B64EB64D9
	for <linux-raid@archiver.kernel.org>; Mon,  3 Jul 2023 01:44:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjGCBoO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 2 Jul 2023 21:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjGCBoN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 2 Jul 2023 21:44:13 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05910194
        for <linux-raid@vger.kernel.org>; Sun,  2 Jul 2023 18:44:07 -0700 (PDT)
Received: from kwepemm600009.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QvTCR2v5vzMq7M;
        Mon,  3 Jul 2023 09:40:51 +0800 (CST)
Received: from [10.174.176.73] (10.174.176.73) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 3 Jul 2023 09:44:03 +0800
Subject: Re: [PATCH] md/raid1: freeze block layer queue during reshape
To:     Xueshi Hu <xueshi.hu@smartx.com>, <linux-raid@vger.kernel.org>
CC:     <song@kernel.org>, "yukuai (C)" <yukuai3@huawei.com>
References: <vsag6vp4jokp2k5fkoqb5flklghpakxmglr75vpzgkmzejc47u@ih2255x374rp>
From:   Yu Kuai <yukuai3@huawei.com>
Message-ID: <658e3fbc-d7bd-3fc9-b82e-0ecb86fd8c49@huawei.com>
Date:   Mon, 3 Jul 2023 09:44:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <vsag6vp4jokp2k5fkoqb5flklghpakxmglr75vpzgkmzejc47u@ih2255x374rp>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.73]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600009.china.huawei.com (7.193.23.164)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

ÔÚ 2023/07/02 18:04, Xueshi Hu Ð´µÀ:
> When a raid device is reshaped, in-flight bio may reference outdated
> r1conf::raid_disks and r1bio::poolinfo. This can trigger a bug in
> three possible paths:
> 
> 1. In function "raid1d". If a bio fails to submit, it will be resent to
> raid1d for retrying the submission, which increases r1conf::nr_queued.
> If the reshape happens, the in-flight bio cannot be freed normally as
> the old mempool has been destroyed.
> 2. In raid1_write_request. If one raw device is blocked, the kernel will
> allow the barrier and wait for the raw device became ready, this makes
> the raid reshape possible. Then, the local variable "disks" before the
> label "retry_write" is outdated. Additionally, the kernel cannot reuse the
> old r1bio.
> 3. In raid_end_bio_io. The kernel must free the r1bio first and then
> allow the barrier.
> 
> By freezing the queue, we can ensure that there are no in-flight bios
> during reshape. This prevents bio from referencing the outdated
> r1conf::raid_disks or r1bio::poolinfo.

I didn't look into the details of the problem you described, but even if
the problem exist, freeze queue can't help at all, blk_mq_freeze_queue()
for bio-based device can't guarantee that threre are no in-flight bios.

Thanks,
Kuai
> 
> Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
> ---
>   drivers/md/raid1.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index dd25832eb045..d8d6825d0af6 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -3247,6 +3247,7 @@ static int raid1_reshape(struct mddev *mddev)
>   	unsigned long flags;
>   	int d, d2;
>   	int ret;
> +	struct request_queue *q = mddev->queue;
>   
>   	memset(&newpool, 0, sizeof(newpool));
>   	memset(&oldpool, 0, sizeof(oldpool));
> @@ -3296,6 +3297,7 @@ static int raid1_reshape(struct mddev *mddev)
>   		return -ENOMEM;
>   	}
>   
> +	blk_mq_freeze_queue(q);
>   	freeze_array(conf, 0);
>   
>   	/* ok, everything is stopped */
> @@ -3333,6 +3335,7 @@ static int raid1_reshape(struct mddev *mddev)
>   	md_wakeup_thread(mddev->thread);
>   
>   	mempool_exit(&oldpool);
> +	blk_mq_unfreeze_queue(q);
>   	return 0;
>   }
>   
> 
