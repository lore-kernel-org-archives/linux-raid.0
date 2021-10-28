Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92512C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 28 Oct 2021 06:33:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AF086058D
	for <linux-raid@archiver.kernel.org>; Thu, 28 Oct 2021 06:33:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbhJ1Gfc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Oct 2021 02:35:32 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:60295 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229762AbhJ1Gfb (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 28 Oct 2021 02:35:31 -0400
Received: from [192.168.0.2] (ip5f5aef59.dynamic.kabel-deutschland.de [95.90.239.89])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 94DC261E64846;
        Thu, 28 Oct 2021 08:33:02 +0200 (CEST)
Message-ID: <0e1c2fd6-c792-a77c-4105-b7f6f5104357@molgen.mpg.de>
Date:   Thu, 28 Oct 2021 08:33:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH] raid5-ppl: use swap() to make code cleaner
Content-Language: en-US
To:     Yang Guang <yang.guang5@zte.com.cn>
Cc:     Yang Guang <cgel.zte@gmail.com>, Zeal Robot <zealci@zte.com.cn>,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Song Liu <song@kernel.org>
References: <20211028010053.7609-1-yang.guang5@zte.com.cn>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20211028010053.7609-1-yang.guang5@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Yang,


Thank you for the patch.

On 28.10.21 03:00, Yang Guang wrote:
> Using swap() make it more readable.

make*s*

Maybe:

Use the macro `swap()` defined in `include/linux/minmax.h` to avoid 
opencoding it.

By the way, there is also the Coccinelle script 
`scripts/coccinelle/misc/swap.cocci`.

> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
> ---
>   drivers/md/raid5-ppl.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
> index 3ddc2aa0b530..4ab417915d7f 100644
> --- a/drivers/md/raid5-ppl.c
> +++ b/drivers/md/raid5-ppl.c
> @@ -1081,7 +1081,7 @@ static int ppl_load_distributed(struct ppl_log *log)
>   	struct ppl_conf *ppl_conf = log->ppl_conf;
>   	struct md_rdev *rdev = log->rdev;
>   	struct mddev *mddev = rdev->mddev;
> -	struct page *page, *page2, *tmp;
> +	struct page *page, *page2;
>   	struct ppl_header *pplhdr = NULL, *prev_pplhdr = NULL;
>   	u32 crc, crc_stored;
>   	u32 signature;
> @@ -1156,9 +1156,7 @@ static int ppl_load_distributed(struct ppl_log *log)
>   		prev_pplhdr_offset = pplhdr_offset;
>   		prev_pplhdr = pplhdr;
>   
> -		tmp = page;
> -		page = page2;
> -		page2 = tmp;
> +		swap(page, page2);
>   
>   		/* calculate next potential ppl offset */
>   		for (i = 0; i < le32_to_cpu(pplhdr->entries_count); i++)
> 


Kind regards,

Paul
