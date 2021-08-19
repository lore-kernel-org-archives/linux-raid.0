Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64A95C4338F
	for <linux-raid@archiver.kernel.org>; Thu, 19 Aug 2021 22:16:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D46A610A0
	for <linux-raid@archiver.kernel.org>; Thu, 19 Aug 2021 22:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235845AbhHSWR1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 Aug 2021 18:17:27 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:34572 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235676AbhHSWR0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 19 Aug 2021 18:17:26 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7740922190;
        Thu, 19 Aug 2021 22:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629411408; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QtS0xy9X84EbUHop4l1BtDHXqaTWehl0Uav6iJeDZ/8=;
        b=mpCHTEjCQL//bQ6/X3zVir9WRzHZhdchq3+p0BP2qFHgWXkKXgD+zUHesUQZf6nT8OIw5P
        7gWj/y63daSoZeLAOnmq26MxU7iRrbFewT0ceXDEoCCtyZf47CXCBXKhN816oV5PVYGjMp
        vlZb6e1PtgGftZMIdnPHlgmnp20c1PU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629411408;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QtS0xy9X84EbUHop4l1BtDHXqaTWehl0Uav6iJeDZ/8=;
        b=iMqeHUgQKXAvGBrry77sIYcnJuk62yEB8UYsJYjMxavp3GHymKAOnzZIYdf0HF5k/wjmbk
        nsUN+ru1tdbJsgAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D62E6133E7;
        Thu, 19 Aug 2021 22:16:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id M1+sJE7YHmH/AwAAMHmgww
        (envelope-from <neilb@suse.de>); Thu, 19 Aug 2021 22:16:46 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Nigel Croxon" <ncroxon@redhat.com>
Cc:     jes@trained-monkey.org, xni@redhat.com, linux-raid@vger.kernel.org,
        mariusz.tkaczyk@linux.intel.com
Subject: Re: [PATCH V2] Fix buffer size warning for strcpy
In-reply-to: <20210819131017.2511208-1-ncroxon@redhat.com>
References: <20210819131017.2511208-1-ncroxon@redhat.com>
Date:   Fri, 20 Aug 2021 08:16:43 +1000
Message-id: <162941140310.9892.4439598009992795158@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 19 Aug 2021, Nigel Croxon wrote:
> To meet requirements of Common Criteria certification vulnerability
> assessment. Static code analysis has been run and found the following
> error:
> buffer_size_warning: Calling "strncpy" with a maximum size
> argument of 16 bytes on destination array "ve->name" of
> size 16 bytes might leave the destination string unterminated.
> 
> The change is to make the destination size to fit the allocated size.

You really should explain here why we change from filling with spaces to
filling with nuls.

> 
> V2: Change from zero-terminated to zero-padded on memset and
> change from using strncpy to memcpy, feedback from Neil Brown.
> 
> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
> ---
>  super-ddf.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/super-ddf.c b/super-ddf.c
> index dc8e512..1771316 100644
> --- a/super-ddf.c
> +++ b/super-ddf.c
> @@ -2637,9 +2637,13 @@ static int init_super_ddf_bvd(struct supertype *st,
>  		ve->init_state = DDF_init_not;
>  
>  	memset(ve->pad1, 0xff, 14);
> -	memset(ve->name, ' ', 16);
> -	if (name)
> -		strncpy(ve->name, name, 16);
> +	memset(ve->name, '\0', sizeof(ve->name));
> +	if (name) {
> +		int l = strlen(ve->name);
> +		if (l > 16)
> +			l = 16;
> +		memcpy(ve->name, name, l);
> +	}

Reviewed-by: NeilBrown <neilb@suse.de>

Thanks,
NeilBrown

>  	ddf->virt->populated_vdes =
>  		cpu_to_be16(be16_to_cpu(ddf->virt->populated_vdes)+1);
>  
> -- 
> 2.29.2
> 
> 
