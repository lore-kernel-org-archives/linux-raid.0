Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80261C43334
	for <linux-raid@archiver.kernel.org>; Fri, 15 Jul 2022 09:04:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234243AbiGOJED (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 15 Jul 2022 05:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234164AbiGOJEC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 15 Jul 2022 05:04:02 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD71326F4;
        Fri, 15 Jul 2022 02:03:59 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1657875837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WPXhRGaB5wWkfgqzF6hiNAnMCSLA9BFfN8O2CbZzIk8=;
        b=fsC8cukxlB7/Camcv619ubW+9amqdGR2Gz9Eh1WY1UfmivUxs9tMQaRvVI+7XmF+3yP5mW
        VL3A/mugbDcicK+F8zQpOKo1YN5ge9sWwTCy4DDGpWUB8AoczJ1Y3JLcCfx8MJRvPQvAHT
        E5HF89sWiY4AqbMVhF05HZuYx+ML/To=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: Re: [PATCH 8/9] md: only delete entries from all_mddevs when the disk
 is freed
To:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20220713113125.2232975-1-hch@lst.de>
 <20220713113125.2232975-9-hch@lst.de>
Message-ID: <0117b8d7-b318-df06-4ada-2d4eaefea68a@linux.dev>
Date:   Fri, 15 Jul 2022 17:03:53 +0800
MIME-Version: 1.0
In-Reply-To: <20220713113125.2232975-9-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 7/13/22 7:31 PM, Christoph Hellwig wrote:
> This ensures device names don't get prematurely reused.*Instead*  add a
> deleted flag to skip already deleted devices in mddev_get and other
> places that only want to see live mddevs.

The patch actually adds a deleted member to struct mddev , so the 
"Instead" here
is at least confusing to me.

> Reported-by; Logan Gunthorpe<logang@deltatee.com>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> ---
>   drivers/md/md.c | 56 +++++++++++++++++++++++++++++++++----------------
>   drivers/md/md.h |  1 +
>   2 files changed, 39 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index df99a16892bce..f3ff61e540ee0 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -625,6 +625,10 @@ EXPORT_SYMBOL(md_flush_request);
>   
>   static inline struct mddev *mddev_get(struct mddev *mddev)
>   {
> +	lockdep_assert_held(&all_mddevs_lock);
> +
> +	if (mddev->deleted)
> +		return NULL;
>   	atomic_inc(&mddev->active);

...

> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 1a85dbe78a71c..bc870e1f1e8c2 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -503,6 +503,7 @@ struct mddev {
>   
>   	atomic_t			max_corr_read_errors; /* max read retries */
>   	struct list_head		all_mddevs;
> +	bool				deleted;
>   
>   	const struct attribute_group	*to_remove;

Thanks,
Guoqing
