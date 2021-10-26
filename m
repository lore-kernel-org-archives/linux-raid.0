Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA28BC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 26 Oct 2021 08:26:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99AF960F92
	for <linux-raid@archiver.kernel.org>; Tue, 26 Oct 2021 08:26:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233763AbhJZI3O (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 26 Oct 2021 04:29:14 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:53477 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231283AbhJZI3H (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 26 Oct 2021 04:29:07 -0400
Received: from [192.168.0.2] (ip5f5aef5c.dynamic.kabel-deutschland.de [95.90.239.92])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 1001E61E6478B;
        Tue, 26 Oct 2021 10:26:42 +0200 (CEST)
Message-ID: <ab607667-888b-11bf-ac13-a69577f067dd@molgen.mpg.de>
Date:   Tue, 26 Oct 2021 10:26:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH] md/raid5: Fix implicit type conversion
Content-Language: en-US
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Song Liu <song@kernel.org>
References: <1635235957-2446919-1-git-send-email-jiasheng@iscas.ac.cn>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <1635235957-2446919-1-git-send-email-jiasheng@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Jiasheng,


On 26.10.21 10:12, Jiasheng Jiang wrote:
> The variable 'cpu' is defined as ULONG.
> However in the for_each_present_cpu, its value is assigned to -1.
> That doesn't make sense and in the cpumask_next() it is implicitly
> type conversed to INT.

The description of the macro in `include/linux/cpumask.h` says:

>  * for_each_cpu - iterate over every cpu in a mask
>  * @cpu: the (optionally unsigned) integer iterator
>  * @mask: the cpumask pointer


> It is universally accepted that the implicit type conversion is
> terrible.
> Also, having the good programming custom will set an example for
> others.
> Thus, it might be better to change the definition of 'cpu' from UINT
> to INT.

Maybe get the macro description fixed first, and then update the users?

> Fixes: 738a273 ("md/raid5: fix allocation of 'scribble' array.")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
>   drivers/md/raid5.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 7d4ff8a..c7b88eb 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2425,7 +2425,7 @@ static int scribble_alloc(struct raid5_percpu *percpu,
>   
>   static int resize_chunks(struct r5conf *conf, int new_disks, int new_sectors)
>   {
> -	unsigned long cpu;
> +	int cpu;

Why not `long cpu`?

>   	int err = 0;
>   
>   	/*
> 


Kind regards,

Paul
