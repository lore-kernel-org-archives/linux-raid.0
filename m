Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C1CFC433F5
	for <linux-raid@archiver.kernel.org>; Wed, 27 Apr 2022 02:11:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357086AbiD0COv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 26 Apr 2022 22:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245545AbiD0COu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 26 Apr 2022 22:14:50 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D996F39BA3;
        Tue, 26 Apr 2022 19:11:40 -0700 (PDT)
Subject: Re: [PATCH v2 06/12] md/raid5: Drop the do_prepare flag in
 raid5_make_request()
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1651025499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4zcgcTHO2pu2dTvJsagOhXIB+wtZrPIwubiqxHKUeVs=;
        b=FpipnnjmNRFjlnBuwceh8dhq7lNlykI8+CtJMr1A3IvianCXAY0Fe7vFCNw9s2VNCTv6br
        tQHAVQ4GKDc/NFLlORBrCVNp6PVL3fW0JmIO+WE3e8NsCUXppDGDEbz7AJqITFxKVy8yDP
        DJb4bXBa62Zmu9LRI1y8jygGCiNh1FM=
To:     Logan Gunthorpe <logang@deltatee.com>,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
References: <20220420195425.34911-1-logang@deltatee.com>
 <20220420195425.34911-7-logang@deltatee.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <9948c2c0-307b-aa99-c95c-f63a61e1f86b@linux.dev>
Date:   Wed, 27 Apr 2022 10:11:36 +0800
MIME-Version: 1.0
In-Reply-To: <20220420195425.34911-7-logang@deltatee.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 4/21/22 3:54 AM, Logan Gunthorpe wrote:
> prepare_to_wait() can be reasonably called after schedule instead of
> setting a flag and preparing in the next loop iteration.
>
> This means that prepare_to_wait() will be called before
> read_seqcount_begin(), but there shouldn't be any reason that
> the order matters here. On the first iteration of the loop
> prepare_to_wait() is already called first.
>
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> ---
>   drivers/md/raid5.c | 8 ++------
>   1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 5a7334ba0997..b9f618356446 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5915,7 +5915,6 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
>   	const int rw = bio_data_dir(bi);
>   	enum stripe_result res;
>   	DEFINE_WAIT(w);
> -	bool do_prepare;
>   
>   	if (unlikely(bi->bi_opf & REQ_PREFLUSH)) {
>   		int ret = log_handle_flush_request(conf, bi);
> @@ -5973,12 +5972,8 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
>   	for (; logical_sector < last_sector; logical_sector += RAID5_STRIPE_SECTORS(conf)) {
>   		int seq;
>   
> -		do_prepare = false;
>   	retry:
>   		seq = read_seqcount_begin(&conf->gen_lock);
> -		if (do_prepare)
> -			prepare_to_wait(&conf->wait_for_overlap, &w,
> -				TASK_UNINTERRUPTIBLE);
>   
>   		res = make_stripe_request(mddev, conf, &ctx, logical_sector,
>   					  bi, seq);
> @@ -5988,7 +5983,8 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
>   			goto retry;
>   		} else if (res == STRIPE_SCHEDULE_AND_RETRY) {
>   			schedule();
> -			do_prepare = true;
> +			prepare_to_wait(&conf->wait_for_overlap, &w,
> +					TASK_UNINTERRUPTIBLE);
>   			goto retry;
>   		}
>   	}

Reviewed-by: Guoqing Jiang <guoqing.jiang@linux.dev>

Thanks,
Guoqing
