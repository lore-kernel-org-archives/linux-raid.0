Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFACBC07E95
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jul 2021 09:38:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C98C76128D
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jul 2021 09:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234645AbhGPJlc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 16 Jul 2021 05:41:32 -0400
Received: from out0.migadu.com ([94.23.1.103]:11810 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231490AbhGPJlc (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 16 Jul 2021 05:41:32 -0400
Subject: Re: [PATCH RFC 11/13] md/bitmap: simplify the printing with '%pD'
 specifier
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1626428315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J72JuxSngQZaWzLOzv0G6shaAgUYqNCFE3FGN5rN/CA=;
        b=s8hzU4tfUWh2GYAeE7FV7fKMd1sAMZnLK7zdzZPUhIS8fbXsrs8yXnbiHI/iwZQza76ZbG
        NLwMklJwUU71mgxv3gJcKxp5Au+Qw9rOLPgKrjOi7Zw4Jh/1k2jEncdE8KFQ5MAsi9mVCB
        LFjpnbkCstySATn20/qEyidi2pSTdTE=
To:     Jia He <justin.he@arm.com>, linux-kernel@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, nd@arm.com,
        Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
References: <20210715031533.9553-1-justin.he@arm.com>
 <20210715031533.9553-12-justin.he@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <51d24b1a-7146-bacd-87ee-4be487c455d8@linux.dev>
Date:   Fri, 16 Jul 2021 17:38:25 +0800
MIME-Version: 1.0
In-Reply-To: <20210715031533.9553-12-justin.he@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 7/15/21 11:15 AM, Jia He wrote:
> After the behavior of '%pD' is changed to print the full path of file,
> the log printing can be simplified.
>
> Given the space with proper length would be allocated in vprintk_store(),
> it is worthy of dropping kmalloc()/kfree() to avoid additional space
> allocation. The error case is well handled in d_path_unsafe(), the error
> string would be copied in '%pD' buffer, no need to additionally handle
> IS_ERR().
>
> Cc: Song Liu <song@kernel.org>
> Cc: linux-raid@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Jia He <justin.he@arm.com>
> ---
>   drivers/md/md-bitmap.c | 13 ++-----------
>   1 file changed, 2 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index e29c6298ef5c..a82f1c2ef83c 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -862,21 +862,12 @@ static void md_bitmap_file_unmap(struct bitmap_storage *store)
>    */
>   static void md_bitmap_file_kick(struct bitmap *bitmap)
>   {
> -	char *path, *ptr = NULL;
> -
>   	if (!test_and_set_bit(BITMAP_STALE, &bitmap->flags)) {
>   		md_bitmap_update_sb(bitmap);
>   
>   		if (bitmap->storage.file) {
> -			path = kmalloc(PAGE_SIZE, GFP_KERNEL);
> -			if (path)
> -				ptr = file_path(bitmap->storage.file,
> -					     path, PAGE_SIZE);
> -
> -			pr_warn("%s: kicking failed bitmap file %s from array!\n",
> -				bmname(bitmap), IS_ERR(ptr) ? "" : ptr);
> -
> -			kfree(path);
> +			pr_warn("%s: kicking failed bitmap file %pD from array!\n",
> +				bmname(bitmap), bitmap->storage.file);
>   		} else
>   			pr_warn("%s: disabling internal bitmap due to errors\n",
>   				bmname(bitmap));

Looks good,  Acked-by: Guoqing Jiang <guoqing.jiang@linux.dev>

Thanks,
Guoqing
