Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1CB1C4332F
	for <linux-raid@archiver.kernel.org>; Tue, 20 Dec 2022 11:14:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiLTLOP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 20 Dec 2022 06:14:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbiLTLOE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 20 Dec 2022 06:14:04 -0500
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55683617B
        for <linux-raid@vger.kernel.org>; Tue, 20 Dec 2022 03:14:03 -0800 (PST)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id DCACC61CCD7B0;
        Tue, 20 Dec 2022 12:14:01 +0100 (CET)
Message-ID: <47f2228a-54c0-7e9c-47c5-6d6983a05c75@molgen.mpg.de>
Date:   Tue, 20 Dec 2022 12:14:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] Grow: fix possible memory leak.
Content-Language: en-US
To:     Blazej Kucman <blazej.kucman@intel.com>
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org, colyli@suse.de
References: <20221220110751.27354-1-blazej.kucman@intel.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20221220110751.27354-1-blazej.kucman@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Blazej,


Thank you for the patch.

Am 20.12.22 um 12:07 schrieb Blazej Kucman:

It’d be great, if you removed the dot/period at the end of the commit 
message.

Also, please elaborate on the memory leak in the commit message. Where 
was `mdi` allocated?

> Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
> ---
>   Grow.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/Grow.c b/Grow.c
> index e362403a..b73ec2ae 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -432,6 +432,7 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
>   			if (((disk.state & (1 << MD_DISK_WRITEMOSTLY)) == 0) &&
>   			   (strcmp(s->bitmap_file, "clustered") == 0)) {
>   				pr_err("%s disks marked write-mostly are not supported with clustered bitmap\n",devname);
> +				free(mdi);
>   				return 1;
>   			}
>   			fd2 = dev_open(dv, O_RDWR);
> @@ -453,8 +454,10 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
>   				pr_err("failed to load super-block.\n");
>   			}
>   			close(fd2);
> -			if (rv)
> +			if (rv) {
> +				free(mdi);
>   				return 1;
> +			}
>   		}
>   		if (offset_setable) {
>   			st->ss->getinfo_super(st, mdi, NULL);


Kind regards,

Paul
