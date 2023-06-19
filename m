Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A10FDEB64D9
	for <linux-raid@archiver.kernel.org>; Mon, 19 Jun 2023 10:27:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbjFSK1v (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 19 Jun 2023 06:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbjFSK1t (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 19 Jun 2023 06:27:49 -0400
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DADAC6;
        Mon, 19 Jun 2023 03:27:47 -0700 (PDT)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 4493461E5FE03;
        Mon, 19 Jun 2023 12:27:01 +0200 (CEST)
Message-ID: <ac4c9d48-b8d2-b847-2721-11179fd922de@molgen.mpg.de>
Date:   Mon, 19 Jun 2023 12:26:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Re: [PATCH] raid10: avoid spin_lock from fastpath from
 raid10_unplug()
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     aligrudi@gmail.com, song@kernel.org, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, yukuai3@huawei.com,
        yi.zhang@huawei.com, yangerkun@huawei.com
References: <20230618142520.14662-1-yukuai1@huaweicloud.com>
Content-Language: en-US
In-Reply-To: <20230618142520.14662-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Yu,


Thank you for your patch. Some minor nits from my side, you can also ignore.

Am 18.06.23 um 16:25 schrieb Yu Kuai:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Commit 0c0be98bbe67 ("md/raid10: prevent unnecessary calls to wake_up()
> in fast path") missed one place, for example, while testing with:

… one place. For example, with

> 
> fio -direct=1 -rw=write/randwrite -iodepth=1 ...
> 
> Then plug and unplug will be called for each io, then wake_up() from

Maybe:

     fio -direct=1 -rw=write/randwrite -iodepth=1 ...

plug und unplug are called for each io, then …

> raid10_unplug() will cause lock contention as well.

Maybe paste the perf command and output?

> Avoid this contention by using wake_up_barrier() instead of wake_up(),
> where spin_lock is not held while waitqueue is empty.

It’d be great if you added also the test results to the commit message.

> By the way, in this scenario, each blk_plug_cb() will be allocated and
> freed for each io, this seems need to be optimized as well.
> 
> Reported-and-tested-by: Ali Gholami Rudi <aligrudi@gmail.com>
> Link: https://lore.kernel.org/all/20231606122233@laper.mirepesht/
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/md/raid10.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index d0de8c9fb3cf..fbaaa5e05edc 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1118,7 +1118,7 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
>   		spin_lock_irq(&conf->device_lock);
>   		bio_list_merge(&conf->pending_bio_list, &plug->pending);
>   		spin_unlock_irq(&conf->device_lock);
> -		wake_up(&conf->wait_barrier);
> +		wake_up_barrier(conf);
>   		md_wakeup_thread(mddev->thread);
>   		kfree(plug);
>   		return;
> @@ -1127,7 +1127,7 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
>   	/* we aren't scheduling, so we can do the write-out directly. */
>   	bio = bio_list_get(&plug->pending);
>   	raid1_prepare_flush_writes(mddev->bitmap);
> -	wake_up(&conf->wait_barrier);
> +	wake_up_barrier(conf);
>   
>   	while (bio) { /* submit pending writes */
>   		struct bio *next = bio->bi_next;

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
