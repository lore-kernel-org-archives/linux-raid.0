Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D0F8CCA47F
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 16:57:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237324AbiGSQ5y (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 12:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237261AbiGSQ5v (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 12:57:51 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A02051A15;
        Tue, 19 Jul 2022 09:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=r8Nqtkf1uaTzgdVUBUNTgArhA2QHvJON00ySwCfGbnw=; b=LZs0xg7tAI984GWphl8SIVXpSQ
        BHqShxF6W2+TDWCHTIUDskeWSuT5jgLDdHa0J1NuCg3fblmW6sHw38649uGvbtxbOMkGSuvXrUI4J
        SMXllIt89XXomoLNkqgdCyh0gypPHFkqB9Q7voKHXBoQwiGmJzrxGorwXOF5sGHDx9h/PYYTeo60Y
        9z6bzKfKxT1dnSvboRX5PLjhkh36D6XA1V/jORSOujQ2If2HnMySa3mTYg24wsPAVa86RqQmfRjaE
        GCMj/D3N3hSMTf0lO2X2EJO9Dv+KUulNwedxo3/uB4dxQHq2yGTUAcvM7uAyncF7px4AZTSj0eyC7
        CClF1Y7w==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oDqXa-001VeN-Ak; Tue, 19 Jul 2022 10:57:47 -0600
Message-ID: <909f1c33-27e3-3f3a-7d8d-ba6fdb57cdb3@deltatee.com>
Date:   Tue, 19 Jul 2022 10:57:45 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-CA
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <YtZ90ZYlrVvucwr9@kili>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <YtZ90ZYlrVvucwr9@kili>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: dan.carpenter@oracle.com, song@kernel.org, linux-raid@vger.kernel.org, kernel-janitors@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH] md/raid5: missing error code in setup_conf()
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-07-19 03:48, Dan Carpenter wrote:
> Return -ENOMEM if the allocation fails.  Don't return success.
> 
> Fixes: 8fbcba6b999b ("md/raid5: Cleanup setup_conf() error returns")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Oops, nice catch. 

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

Thanks,

Logan

> ---
>  drivers/md/raid5.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index a7db73d36cc4..f31012357572 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7492,7 +7492,9 @@ static struct r5conf *setup_conf(struct mddev *mddev)
>  		goto abort;
>  	conf->mddev = mddev;
>  
> -	if ((conf->stripe_hashtbl = kzalloc(PAGE_SIZE, GFP_KERNEL)) == NULL)
> +	ret = -ENOMEM;
> +	conf->stripe_hashtbl = kzalloc(PAGE_SIZE, GFP_KERNEL);
> +	if (!conf->stripe_hashtbl)
>  		goto abort;
>  
>  	/* We init hash_locks[0] separately to that it can be used
