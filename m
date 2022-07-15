Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AF75C43334
	for <linux-raid@archiver.kernel.org>; Fri, 15 Jul 2022 09:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbiGOJA0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 15 Jul 2022 05:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233135AbiGOJAZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 15 Jul 2022 05:00:25 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D576F13F1F;
        Fri, 15 Jul 2022 02:00:23 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1657875621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=12j3iMld1ch53mhNlAoPU+YqFWxzyt+n4RbnYXJPAdU=;
        b=Q5DfEMtJDW7HLDVDRXXq/7vsA83jNQq9CjYjsiRsw1i6he6bXkUVDbGjKy5HC9HSJw2Mqb
        q849+wiY1j9jiZEA+aFcOfgbqpVW717CWFEzXkyvRlAH0GlcMjygxSr3WbvbOgf+uOviBj
        1ODNngDH0wWzIenFQHtfkeoLa3deM5k=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: Re: [PATCH 3/9] md: rename md_free to md_kobj_release
To:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20220713113125.2232975-1-hch@lst.de>
 <20220713113125.2232975-4-hch@lst.de>
Message-ID: <6ab9c6db-7fd1-ebee-b2da-7a303c8a9417@linux.dev>
Date:   Fri, 15 Jul 2022 17:00:14 +0800
MIME-Version: 1.0
In-Reply-To: <20220713113125.2232975-4-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 7/13/22 7:31 PM, Christoph Hellwig wrote:
> The md_free name is rather misleading, so pick a better one.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> ---
>   drivers/md/md.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 2beaadd202c4e..3127dcb8102ce 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5590,7 +5590,7 @@ md_attr_store(struct kobject *kobj, struct attribute *attr,
>   	return rv;
>   }
>   
> -static void md_free(struct kobject *ko)
> +static void md_kobj_release(struct kobject **ko*)

While at it, how about rename it to kobj?

>   {
>   	struct mddev *mddev = container_of(ko, struct mddev, kobj);
>   
> @@ -5610,7 +5610,7 @@ static const struct sysfs_ops md_sysfs_ops = {
>   	.store	= md_attr_store,
>   };
>   static struct kobj_type md_ktype = {
> -	.release	= md_free,
> +	.release	= md_kobj_release,
>   	.sysfs_ops	= &md_sysfs_ops,
>   	.default_groups	= md_attr_groups,
>   };

Acked-by: Guoqing Jiang <guoqing.jiang@linux.dev>

Thanks,
Guoqing
