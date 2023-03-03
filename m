Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95EAFC64EC4
	for <linux-raid@archiver.kernel.org>; Fri,  3 Mar 2023 10:35:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjCCKf0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Mar 2023 05:35:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjCCKfZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Mar 2023 05:35:25 -0500
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1232CFD5
        for <linux-raid@vger.kernel.org>; Fri,  3 Mar 2023 02:35:24 -0800 (PST)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id A1D0661CC40F9;
        Fri,  3 Mar 2023 11:35:21 +0100 (CET)
Message-ID: <a4929e12-a2da-be8f-7d24-9f7ae4abed59@molgen.mpg.de>
Date:   Fri, 3 Mar 2023 11:35:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH mdadm v7 4/7] mdadm: Introduce pr_info()
Content-Language: en-US
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Kinga Tanska <kinga.tanska@linux.intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>
References: <20230301204135.39230-1-logang@deltatee.com>
 <20230301204135.39230-5-logang@deltatee.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230301204135.39230-5-logang@deltatee.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Logan,


Am 01.03.23 um 21:41 schrieb Logan Gunthorpe:
> Feedback was given to avoid informational pr_err() calls that print
> to stderr, even though that's done all through out the code.
> 
> Using printf() directly doesn't maintain the same format (an "mdadm"
> prefix on every line.

Just a nit, that the closing ) is missing.

In the summary you could use: Introduce and use pr_info()

> So introduce pr_info() which prints to stdout with the same format
> and use it for a couple informational pr_err() calls in Create().
> 
> Future work can make this call used in more cases.
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Acked-by: Kinga Tanska <kinga.tanska@linux.intel.com>
> Reviewed-by: Xiao Ni <xni@redhat.com>
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> Acked-by: Coly Li <colyli@suse.de>
> ---
>   Create.c | 7 ++++---
>   mdadm.h  | 2 ++
>   2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/Create.c b/Create.c
> index 6a0446644e04..4acda30c5256 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -984,11 +984,12 @@ int Create(struct supertype *st, char *mddev,
>   
>   			mdi = sysfs_read(-1, devnm, GET_VERSION);
>   
> -			pr_err("Creating array inside %s container %s\n",
> +			pr_info("Creating array inside %s container %s\n",
>   				mdi?mdi->text_version:"managed", devnm);
>   			sysfs_free(mdi);
>   		} else
> -			pr_err("Defaulting to version %s metadata\n", info.text_version);
> +			pr_info("Defaulting to version %s metadata\n",
> +				info.text_version);
>   	}
>   
>   	map_update(&map, fd2devnm(mdfd), info.text_version,
> @@ -1145,7 +1146,7 @@ int Create(struct supertype *st, char *mddev,
>   			ioctl(mdfd, RESTART_ARRAY_RW, NULL);
>   		}
>   		if (c->verbose >= 0)
> -			pr_err("array %s started.\n", mddev);
> +			pr_info("array %s started.\n", mddev);
>   		if (st->ss->external && st->container_devnm[0]) {
>   			if (need_mdmon)
>   				start_mdmon(st->container_devnm);
> diff --git a/mdadm.h b/mdadm.h
> index 13f8b4cb5a6b..8bd65fba1887 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1852,6 +1852,8 @@ static inline int xasprintf(char **strp, const char *fmt, ...) {
>   #endif
>   #define cont_err(fmt ...) fprintf(stderr, "       " fmt)
>   
> +#define pr_info(fmt, args...) printf("%s: "fmt, Name, ##args)
> +
>   void *xmalloc(size_t len);
>   void *xrealloc(void *ptr, size_t len);
>   void *xcalloc(size_t num, size_t size);

Acked-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
