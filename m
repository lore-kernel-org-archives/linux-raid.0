Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A63ADC433F5
	for <linux-raid@archiver.kernel.org>; Tue, 16 Nov 2021 09:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8875B61C12
	for <linux-raid@archiver.kernel.org>; Tue, 16 Nov 2021 09:24:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbhKPJ1v (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 16 Nov 2021 04:27:51 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:51311 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233197AbhKPJ1U (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 16 Nov 2021 04:27:20 -0500
Received: from [192.168.0.2] (ip5f5aecf5.dynamic.kabel-deutschland.de [95.90.236.245])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 1FDD661EA193F;
        Tue, 16 Nov 2021 10:24:18 +0100 (CET)
Message-ID: <91d75292-401f-3788-63aa-f3c9aca8841c@molgen.mpg.de>
Date:   Tue, 16 Nov 2021 10:24:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] md: fix update super 1.0 on rdev size change
Content-Language: en-US
To:     Markus Hochholdinger <markus@hochholdinger.net>
References: <20211112142822.813606-1-markus@hochholdinger.net>
Cc:     song@kernel.org, linux-raid@vger.kernel.org, xni@redhat.com
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20211112142822.813606-1-markus@hochholdinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Markus,


Thank you for your patch.


Am 12.11.21 um 15:28 schrieb markus@hochholdinger.net:
> From: Markus Hochholdinger <markus@hochholdinger.net>
> 
> The superblock of version 1.0 doesn't get moved to the new position on a
> device size change. This leads to a rdev without a superblock on a known
> position, the raid can't be re-assembled.

> Fixes: commit d9c0fa509eaf ("md: fix max sectors calculation for super 1.0")

I think it’s common to not write *commit* in there, but just the short 
hash. `scripts/checkpatch.pl` does not mention that, but it mentions:

     ERROR: Missing Signed-off-by: line(s)

     total: 1 errors, 0 warnings, 7 lines checked

> ---
>   drivers/md/md.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 6c0c3d0d905a..ad968cfc883d 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2193,6 +2193,7 @@ super_1_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
>   
>   		if (!num_sectors || num_sectors > max_sectors)
>   			num_sectors = max_sectors;
> +		rdev->sb_start = sb_start;
>   	}
>   	sb = page_address(rdev->sb_page);
>   	sb->data_size = cpu_to_le64(num_sectors);
> 


Kind regards,

Paul
