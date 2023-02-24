Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75102C77B6D
	for <linux-raid@archiver.kernel.org>; Fri, 24 Feb 2023 16:05:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjBXQFX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 24 Feb 2023 11:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBXQFW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 24 Feb 2023 11:05:22 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5C2168B1
        for <linux-raid@vger.kernel.org>; Fri, 24 Feb 2023 08:05:20 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 55A9160A26;
        Fri, 24 Feb 2023 16:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677254719; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EOr5uj75pPFD+ANUtITmOaJ1lB7ZKWcdpFqbCPYW9ec=;
        b=DAuhbAz9QfRt+iDuPGk8DpHQP/QIuk1FWI7gIAHm+6FujqFdAR54+rPspQlhiHALydXrK7
        e0CcuHJqPhJAAnMghy+gQyAxVwAaG7Php+fxOJC5ZE0lB1Rrn1GKgsv687L08P67YpmpN9
        XGiaQ1rcHHvSUO3yrqrAKKosetB7PkQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677254719;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EOr5uj75pPFD+ANUtITmOaJ1lB7ZKWcdpFqbCPYW9ec=;
        b=sSwCAkRy6DZ3p3U9NNqpIk0+08gMhDvZClVc/weRVuYLpuRh/vbRrU4oozde2yDu4ss8ym
        lBGZxcmoQ5kWpmBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9E96413A3A;
        Fri, 24 Feb 2023 16:05:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id GX4eGzzg+GPhJAAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 24 Feb 2023 16:05:16 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [PATCH mdadm v6 1/7] Create: goto abort_locked instead of return
 1 in error path
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20221123190954.95391-2-logang@deltatee.com>
Date:   Sat, 25 Feb 2023 00:05:04 +0800
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
Message-Id: <BDC81FFC-E695-4FFB-9D10-C50CDC162E8B@suse.de>
References: <20221123190954.95391-1-logang@deltatee.com>
 <20221123190954.95391-2-logang@deltatee.com>
To:     Logan Gunthorpe <logang@deltatee.com>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Nov 23, 2022 at 12:09:48PM -0700, Logan Gunthorpe wrote:
> The return 1 after the fstat_is_blkdev() check should be replaced
> with an error return that goes through the error path to unlock
> resources locked by this function.
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Acked-by: Kinga Tanska <kinga.tanska@linux.intel.com>

Acked-by: Coly Li <colyli@suse.de>

> ---
> Create.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Create.c b/Create.c
> index 953e73722518..2e8203ecdccd 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -939,7 +939,7 @@ int Create(struct supertype *st, char *mddev,
> 						goto abort_locked;
> 					}
> 					if (!fstat_is_blkdev(fd, dv->devname, &rdev))
> -						return 1;
> +						goto abort_locked;
> 					inf->disk.major = major(rdev);
> 					inf->disk.minor = minor(rdev);
> 				}
> -- 
> 2.30.2
> 

-- 
Coly Li
