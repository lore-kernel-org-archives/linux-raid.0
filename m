Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08B14C61DA4
	for <linux-raid@archiver.kernel.org>; Thu,  9 Mar 2023 06:36:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbjCIGg5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Mar 2023 01:36:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjCIGgz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Mar 2023 01:36:55 -0500
Received: from out-35.mta1.migadu.com (out-35.mta1.migadu.com [IPv6:2001:41d0:203:375::23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E8D2B9C2
        for <linux-raid@vger.kernel.org>; Wed,  8 Mar 2023 22:36:50 -0800 (PST)
Message-ID: <a2551c50-feea-bcbe-00ed-802456b5a19f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1678343803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oflCArd3KsWDijJ2FL/2wrJj33OV+66NpTMchMFSx0I=;
        b=rYuJ1a7okcyGLqyvNVBEaHxC7Sm9kdYqTKTop9wNMpGCpzjTB7CevmH6nMIdu30tDxzdft
        TIBx63a/DB/6Ydak3v+yIj3QF8+XzPOcDHkMLBHndLEBpRCknw1J2ZgFUMnYImEBftG4/N
        6SGxPD8BoG6OUL/4+nAXUmQEfxEsqbA=
Date:   Thu, 9 Mar 2023 14:36:35 +0800
MIME-Version: 1.0
Subject: Re: [PATCH -next] raid10: fix leak of io accounting
To:     Yu Kuai <yukuai1@huaweicloud.com>, song@kernel.org
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
References: <20230304070133.1134975-1-yukuai1@huaweicloud.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
In-Reply-To: <20230304070133.1134975-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

What do you mean 'leak' here?

On 3/4/23 15:01, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
>
> handle_read_error() will resumit r10_bio by raid10_read_request(), which
> will call bio_start_io_acct() again, while bio_end_io_acct() will only
> be called once.
>
> Fix the problem by don't account io again from handle_read_error().

My understanding is it caused inaccurate io stats for bio which had a read
error.

> Fixes: 528bc2cf2fcc ("md/raid10: enable io accounting")
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/md/raid10.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 6c66357f92f5..4f8edb6ea3e2 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1173,7 +1173,7 @@ static bool regular_request_wait(struct mddev *mddev, struct r10conf *conf,
>   }
>   
>   static void raid10_read_request(struct mddev *mddev, struct bio *bio,
> -				struct r10bio *r10_bio)
> +				struct r10bio *r10_bio, bool handle_error)
>   {
>   	struct r10conf *conf = mddev->private;
>   	struct bio *read_bio;
> @@ -1244,7 +1244,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
>   	}
>   	slot = r10_bio->read_slot;
>   
> -	if (blk_queue_io_stat(bio->bi_bdev->bd_disk->queue))
> +	if (!handle_error && blk_queue_io_stat(bio->bi_bdev->bd_disk->queue))
>   		r10_bio->start_time = bio_start_io_acct(bio);

I think a simpler way is just check R10BIO_ReadError here.

Thanks,
Guoqing
