Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8DB5C433F5
	for <linux-raid@archiver.kernel.org>; Thu,  7 Apr 2022 11:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbiDGLB6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 7 Apr 2022 07:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbiDGLB4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 7 Apr 2022 07:01:56 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F124911437D
        for <linux-raid@vger.kernel.org>; Thu,  7 Apr 2022 03:59:53 -0700 (PDT)
Received: from [192.168.0.2] (ip5f5aef77.dynamic.kabel-deutschland.de [95.90.239.119])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 7E27361EA1927;
        Thu,  7 Apr 2022 12:59:52 +0200 (CEST)
Message-ID: <2b3c8e52-94fd-3dac-1e92-e28aee5d8b27@molgen.mpg.de>
Date:   Thu, 7 Apr 2022 12:59:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] mdadm: Fix array size mismatch after grow
Content-Language: en-US
To:     Lukasz Florczak <lukasz.florczak@linux.intel.com>
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org, colyli@suse.de
References: <20220407070202.50421-1-lukasz.florczak@linux.intel.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20220407070202.50421-1-lukasz.florczak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Lukasz,


Thank you for your patch.

Am 07.04.22 um 09:02 schrieb Lukasz Florczak:
> imsm_fix_size_mismatch() is invoked to fix the problem, but it couldn't proceed due to migration check.
> This patch allows for intended behavior.

Please reflow for 75 characters per line.

> Additionally remove some dead code.

It’d be great if you split this out into a separate commit with a 
comment, why u_size can never be smaller than 1.


Kind regards,

Paul


> Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>
> ---
>   super-intel.c | 7 ++-----
>   1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index d5fad102..be6aec90 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -11757,7 +11757,7 @@ static int imsm_fix_size_mismatch(struct supertype *st, int subarray_index)
>   		unsigned long long d_size = imsm_dev_size(dev);
>   		int u_size;
>   
> -		if (calc_size == d_size || dev->vol.migr_type == MIGR_GEN_MIGR)
> +		if (calc_size == d_size)
>   			continue;
>   
>   		/* There is a difference, confirm that imsm_dev_size is
> @@ -11772,10 +11772,7 @@ static int imsm_fix_size_mismatch(struct supertype *st, int subarray_index)
>   		geo.size = d_size;
>   		u_size = imsm_create_metadata_update_for_size_change(st, &geo,
>   								     &update);
> -		if (u_size < 1) {
> -			dprintf("imsm: Cannot prepare size change update\n");
> -			goto exit;
> -		}
> +
>   		imsm_update_metadata_locally(st, update, u_size);
>   		if (st->update_tail) {
>   			append_metadata_update(st, update, u_size);
