Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E870AC77B6F
	for <linux-raid@archiver.kernel.org>; Fri, 24 Feb 2023 16:05:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjBXQF2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 24 Feb 2023 11:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjBXQF0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 24 Feb 2023 11:05:26 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1761C168B1
        for <linux-raid@vger.kernel.org>; Fri, 24 Feb 2023 08:05:25 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8D3863EA4C;
        Fri, 24 Feb 2023 16:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677254724; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cvAsOuyYceVEYx64bx/4Pppph2ZuKBLDdIFWKdreBeI=;
        b=C/vY318X4pr0OXObP21x9cb34NCqIwOI9uSJvpXuXg3byPNnAgJaPxFsJ6mGXn6wZ36+ko
        553neYnw/BHxLuJEOTjxjhH2Z7GkCT0TXVCpCPA5q6BhYg/vgS6Kwb7CQY4eti+q0f0ibR
        tvLncePVcVmaPLtmYD7A3rjdydC+FJI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677254724;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cvAsOuyYceVEYx64bx/4Pppph2ZuKBLDdIFWKdreBeI=;
        b=02DgN+Z8Z6QV8sGz7oTyRO93N3Bp4t8t1TlOKNIWQEzJavKLgwSECSXPrOGi+ULPenhacQ
        /ijEEjbzgcAF2eBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9E51813A3A;
        Fri, 24 Feb 2023 16:05:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ku/7GEHg+GPmJAAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 24 Feb 2023 16:05:21 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [PATCH mdadm v6 2/7] Create: remove safe_mode_delay local
 variable
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20221123190954.95391-3-logang@deltatee.com>
Date:   Sat, 25 Feb 2023 00:05:08 +0800
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Jes Sorensen <jes@trained-monkey.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Kinga Tanska <kinga.tanska@linux.intel.com>
Content-Transfer-Encoding: 7bit
Message-Id: <34AE30DE-BD4A-4760-B2F2-F9FAE36C190F@suse.de>
References: <20221123190954.95391-1-logang@deltatee.com>
 <20221123190954.95391-3-logang@deltatee.com>
To:     Logan Gunthorpe <logang@deltatee.com>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Nov 23, 2022 at 12:09:49PM -0700, Logan Gunthorpe wrote:
> All .getinfo_super() call sets the info.safe_mode_delay variables
> to a constant value, so no matter what the current state is
> that function will always set it to the same value.
> 
> Create() calls .getinfo_super() multiple times while creating the array.
> The value is stored in a local variable for every disk in the loop
> to add disks (so the last disc call takes precedence). The local
> variable is then used in the call to sysfs_set_safemode().
> 
> This can be simplified by using info.safe_mode_delay directly. The info
> variable had .getinfo_super() called on it early in the function so, by the
> reasoning above, it will have the same value as the local variable which
> can thus be removed.
> 
> Doing this allows for factoring out code from Create() in a subsequent
> patch.
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Acked-by: Kinga Tanska <kinga.tanska@linux.intel.com>

Acked-by: Coly Li <colyli@suse.de>

Thanks.

> ---
> Create.c | 4 +---
> 1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/Create.c b/Create.c
> index 2e8203ecdccd..8ded81dc265d 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -137,7 +137,6 @@ int Create(struct supertype *st, char *mddev,
> 	int did_default = 0;
> 	int do_default_layout = 0;
> 	int do_default_chunk = 0;
> -	unsigned long safe_mode_delay = 0;
> 	char chosen_name[1024];
> 	struct map_ent *map = NULL;
> 	unsigned long long newsize;
> @@ -952,7 +951,6 @@ int Create(struct supertype *st, char *mddev,
> 					goto abort_locked;
> 				}
> 				st->ss->getinfo_super(st, inf, NULL);
> -				safe_mode_delay = inf->safe_mode_delay;
> 
> 				if (have_container && c->verbose > 0)
> 					pr_err("Using %s for device %d\n",
> @@ -1065,7 +1063,7 @@ int Create(struct supertype *st, char *mddev,
> 						    "readonly");
> 				break;
> 			}
> -			sysfs_set_safemode(&info, safe_mode_delay);
> +			sysfs_set_safemode(&info, info.safe_mode_delay);
> 			if (err) {
> 				pr_err("failed to activate array.\n");
> 				ioctl(mdfd, STOP_ARRAY, NULL);
> -- 
> 2.30.2
> 

-- 
Coly Li
