Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0CF7C678D4
	for <linux-raid@archiver.kernel.org>; Fri,  3 Mar 2023 10:22:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjCCKWu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Mar 2023 05:22:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCCKWt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Mar 2023 05:22:49 -0500
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03EF1815F
        for <linux-raid@vger.kernel.org>; Fri,  3 Mar 2023 02:22:47 -0800 (PST)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id B8F7C61CC457B;
        Fri,  3 Mar 2023 11:22:45 +0100 (CET)
Message-ID: <5dbde3af-3a3a-51ad-3646-71de21127e4d@molgen.mpg.de>
Date:   Fri, 3 Mar 2023 11:22:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 1/6] util.c: code cleanup for parse_layout_faulty()
Content-Language: en-US
To:     Coly Li <colyli@suse.de>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
References: <20230303083323.3406-1-colyli@suse.de>
 <20230303083323.3406-2-colyli@suse.de>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230303083323.3406-2-colyli@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Coly,


Am 03.03.23 um 09:33 schrieb Coly Li:
> Resort the code lines in parse_layout_faulty() to make it more
> comfortable, no logic change.

Maybe use a more specific subject line and make it a statement by using 
a verb (imperative mood):

util.c: Reorder code lines in `parse_layout_faulty()`

> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>   util.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/util.c b/util.c
> index 7fc881bf..b0b7aec4 100644
> --- a/util.c
> +++ b/util.c
> @@ -421,12 +421,15 @@ int parse_layout_10(char *layout)
>   
>   int parse_layout_faulty(char *layout)
>   {
> +	int ln, mode;
> +	char *m;
> +
>   	if (!layout)
>   		return -1;
> +
>   	/* Parse the layout string for 'faulty' */
> -	int ln = strcspn(layout, "0123456789");
> -	char *m = xstrdup(layout);
> -	int mode;
> +	ln = strcspn(layout, "0123456789");
> +	m = xstrdup(layout);
>   	m[ln] = 0;
>   	mode = map_name(faultylayout, m);
>   	if (mode == UnSet)

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
