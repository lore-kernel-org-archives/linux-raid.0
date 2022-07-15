Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E56C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 15 Jul 2022 09:01:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233221AbiGOJBx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 15 Jul 2022 05:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233906AbiGOJBv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 15 Jul 2022 05:01:51 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5B113F1F;
        Fri, 15 Jul 2022 02:01:50 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1657875708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mXw7BAQIZgx9JYTFv/Se880Nn0ENWKUmfsnlGG8fij0=;
        b=SrqlLnjpoC5I3FNoKN++Vz1SkqMWKySWAB1nT9cGem7fwTaxny+7hWPVdqKrmTAlL32uYq
        Mb5Vgnwa8qPE3Mo87djG7UbLX0KuQKSi+nSAB6ljqUWdK15Wh04YjYt/7mjlGgpcIYTdHt
        Qz50WWI/Gl6vVaOeR2UzEq7Mlu1/4oE=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: Re: [PATCH 4/9] md: factor out the rdev overlaps check from
 rdev_size_store
To:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20220713113125.2232975-1-hch@lst.de>
 <20220713113125.2232975-5-hch@lst.de>
Message-ID: <787a004b-321b-2b6c-3e54-d0587e3ad02e@linux.dev>
Date:   Fri, 15 Jul 2022 17:01:43 +0800
MIME-Version: 1.0
In-Reply-To: <20220713113125.2232975-5-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 7/13/22 7:31 PM, Christoph Hellwig wrote:
> This splits the code into nicely readable chunks and also avoids
> the refcount inc/dec manipulations.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> ---
>   drivers/md/md.c | 84 +++++++++++++++++++++++--------------------------
>   1 file changed, 39 insertions(+), 45 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 3127dcb8102ce..5346135ab51c8 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -3344,14 +3344,33 @@ rdev_size_show(struct md_rdev *rdev, char *page)
>   	return sprintf(page, "%llu\n", (unsigned long long)rdev->sectors / 2);
>   }
>   
> -static int overlaps(sector_t s1, sector_t l1, sector_t s2, sector_t l2)
> +static int md_rdevs_overlap(struct md_rdev *a, struct md_rdev *b)
>   {
>   	/* check if two start/length pairs overlap */
> -	if (s1+l1 <= s2)
> -		return 0;
> -	if (s2+l2 <= s1)
> -		return 0;
> -	return 1;
> +	if (a->data_offset + a->sectors <= b->data_offset)
> +		return false;
> +	if (b->data_offset + b->sectors <= a->data_offset)
> +		return false;
> +	return true;
> +}

Given it returns true or false, better to change the return type to bool.

> +
> +static bool md_rdev_overlaps(struct md_rdev *rdev)
> +{

The two names (md_rdevs_overlap/md_rdev_overlaps) are quite similar ...

Thanks,
Guoqing
