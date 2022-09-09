Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C7B2ECAAD3
	for <linux-raid@archiver.kernel.org>; Fri,  9 Sep 2022 04:53:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbiIIExl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 9 Sep 2022 00:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbiIIExj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 9 Sep 2022 00:53:39 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC11123EE7;
        Thu,  8 Sep 2022 21:53:38 -0700 (PDT)
Received: from [192.168.0.6] (ip5f5aedd0.dynamic.kabel-deutschland.de [95.90.237.208])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 7E82861EA1929;
        Fri,  9 Sep 2022 06:53:35 +0200 (CEST)
Message-ID: <4ccf5784-9e7f-6faf-a710-a97273ebd737@molgen.mpg.de>
Date:   Fri, 9 Sep 2022 06:53:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 2/3] md: Remove extra mddev_get() in md_seq_start()
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     Song Liu <song@kernel.org>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Christoph Hellwig <hch@lst.de>
References: <20220908161516.4361-1-logang@deltatee.com>
 <20220908161516.4361-3-logang@deltatee.com>
Content-Language: en-US
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20220908161516.4361-3-logang@deltatee.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Logan,


Thank you for the updated series. One nit below, which could be 
corrected by the maintainer before applying.

Am 08.09.22 um 18:15 schrieb Logan Gunthorpe:
> A regression is seen where mddev devices stay permanently after they
> are stopped due to an elevated reference count.
> 
> This was tracked down to an extra mddev_get() in md_seq_start().
> 
> It only happened rarely because most of the time the md_seq_start()
> is called with a zero offset. The path with an extra mddev_get() only
> happens when it starts with a non-zero offset.
> 
> The commit noted below changed an mddev_get() to check its success
> but inadevrtantly left the original call in. Remove the extra call.

inadvertently

> Fixes: 12a6caf27324 ("md: only delete entries from all_mddevs when the disk is freed")
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Guoqing Jiang <Guoqing.jiang@linux.dev>
> ---
>   drivers/md/md.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index afaf36b2f6ab..9dc0175280b4 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8154,7 +8154,6 @@ static void *md_seq_start(struct seq_file *seq, loff_t *pos)
>   	list_for_each(tmp,&all_mddevs)
>   		if (!l--) {
>   			mddev = list_entry(tmp, struct mddev, all_mddevs);
> -			mddev_get(mddev);
>   			if (!mddev_get(mddev))
>   				continue;
>   			spin_unlock(&all_mddevs_lock);


Kind regards,

Paul
