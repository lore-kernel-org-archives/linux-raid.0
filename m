Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D77EB64DA
	for <linux-raid@archiver.kernel.org>; Wed, 19 Jul 2023 07:39:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjGSHjN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 Jul 2023 03:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjGSHjC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 19 Jul 2023 03:39:02 -0400
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745DFE43
        for <linux-raid@vger.kernel.org>; Wed, 19 Jul 2023 00:38:58 -0700 (PDT)
Received: from [192.168.0.2] (ip5f5ae978.dynamic.kabel-deutschland.de [95.90.233.120])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id D9BE461E5FE01;
        Wed, 19 Jul 2023 09:38:26 +0200 (CEST)
Message-ID: <30e1e157-5ce9-3c11-29e1-232756ecffec@molgen.mpg.de>
Date:   Wed, 19 Jul 2023 09:38:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 3/3] md/raid1: check array size before reshape
Content-Language: en-US
To:     Xueshi Hu <xueshi.hu@smartx.com>
Cc:     song@kernel.org, linux-raid@vger.kernel.org,
        yukuai1@huaweicloud.com
References: <20230719070954.3084379-1-xueshi.hu@smartx.com>
 <20230719070954.3084379-4-xueshi.hu@smartx.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230719070954.3084379-4-xueshi.hu@smartx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Xueshi,


Thank you for your patches.

Am 19.07.23 um 09:09 schrieb Xueshi Hu:
> If array size doesn't changed, nothing need to do.

Maybe: … nothing needs to be done.

Do you have a test case to reproduce it?


Kind regards,

Paul


> Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
> ---
>   drivers/md/raid1.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 62e86b7d1561..5840b8b0f9b7 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -3282,9 +3282,6 @@ static int raid1_reshape(struct mddev *mddev)
>   	int d, d2;
>   	int ret;
>   
> -	memset(&newpool, 0, sizeof(newpool));
> -	memset(&oldpool, 0, sizeof(oldpool));
> -
>   	/* Cannot change chunk_size, layout, or level */
>   	if (mddev->chunk_sectors != mddev->new_chunk_sectors ||
>   	    mddev->layout != mddev->new_layout ||
> @@ -3295,6 +3292,12 @@ static int raid1_reshape(struct mddev *mddev)
>   		return -EINVAL;
>   	}
>   
> +	if (mddev->delta_disks == 0)
> +		return 0; /* nothing to do */
> +
> +	memset(&newpool, 0, sizeof(newpool));
> +	memset(&oldpool, 0, sizeof(oldpool));
> +
>   	if (!mddev_is_clustered(mddev))
>   		md_allow_write(mddev);
>   
