Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86246C77B6F
	for <linux-raid@archiver.kernel.org>; Fri, 24 Feb 2023 16:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjBXQFf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 24 Feb 2023 11:05:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBXQFf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 24 Feb 2023 11:05:35 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFCC1969B
        for <linux-raid@vger.kernel.org>; Fri, 24 Feb 2023 08:05:34 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7F88D3EA45;
        Fri, 24 Feb 2023 16:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677254732; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MAGPF2guCFBz2Mc0mwI406NuHmCCCohoWQE7LYbqmtw=;
        b=1LhbEF49MguS0jsswedOSm4DE4huRnKK5+Xof8vevnWYn23SLbwkpmqu2BZzNBhZkASFcz
        LyOZUGJ3PpROHKcScBL+IspJs55n2VJdk6+VeAjLHRnpsOS+61kD2DtNu3uH+Da/NzrhN9
        Y29hQfJf0CVT9M+NqZyCop6m4xd2iOA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677254732;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MAGPF2guCFBz2Mc0mwI406NuHmCCCohoWQE7LYbqmtw=;
        b=889dSo8ANxxEpHp7XqOKB2BpKmbcn4ChM5g0avuBOywSwZ05pfIRNSS13kv4J/wHsNAfAD
        cpWuKUdYPAwyqXCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DE22A13A3A;
        Fri, 24 Feb 2023 16:05:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id uBaOKkng+GPhJAAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 24 Feb 2023 16:05:29 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [PATCH mdadm v6 4/7] mdadm: Introduce pr_info()
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20221123190954.95391-5-logang@deltatee.com>
Date:   Sat, 25 Feb 2023 00:05:19 +0800
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
Content-Transfer-Encoding: quoted-printable
Message-Id: <18D96267-ADCB-4358-9896-DCE3E7260DCD@suse.de>
References: <20221123190954.95391-1-logang@deltatee.com>
 <20221123190954.95391-5-logang@deltatee.com>
To:     Logan Gunthorpe <logang@deltatee.com>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Nov 23, 2022 at 12:09:51PM -0700, Logan Gunthorpe wrote:
> Feedback was given to avoid informational pr_err() calls that print
> to stderr, even though that's done all through out the code.
>=20
> Using printf() directly doesn't maintain the same format (an "mdadm"
> prefix on every line.
>=20
> So introduce pr_info() which prints to stdout with the same format
> and use it for a couple informational pr_err() calls in Create().
>=20
> Future work can make this call used in more cases.
>=20
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Acked-by: Kinga Tanska <kinga.tanska@linux.intel.com>

Acked-by: Coly Li <colyli@suse.de>

Thanks.

> ---
> Create.c | 7 ++++---
> mdadm.h  | 2 ++
> 2 files changed, 6 insertions(+), 3 deletions(-)
>=20
> diff --git a/Create.c b/Create.c
> index 6a0446644e04..4acda30c5256 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -984,11 +984,12 @@ int Create(struct supertype *st, char *mddev,
>=20
> 			mdi =3D sysfs_read(-1, devnm, GET_VERSION);
>=20
> -			pr_err("Creating array inside %s container =
%s\n",
> +			pr_info("Creating array inside %s container =
%s\n",
> 				mdi?mdi->text_version:"managed", devnm);
> 			sysfs_free(mdi);
> 		} else
> -			pr_err("Defaulting to version %s metadata\n", =
info.text_version);
> +			pr_info("Defaulting to version %s metadata\n",
> +				info.text_version);
> 	}
>=20
> 	map_update(&map, fd2devnm(mdfd), info.text_version,
> @@ -1145,7 +1146,7 @@ int Create(struct supertype *st, char *mddev,
> 			ioctl(mdfd, RESTART_ARRAY_RW, NULL);
> 		}
> 		if (c->verbose >=3D 0)
> -			pr_err("array %s started.\n", mddev);
> +			pr_info("array %s started.\n", mddev);
> 		if (st->ss->external && st->container_devnm[0]) {
> 			if (need_mdmon)
> 				start_mdmon(st->container_devnm);
> diff --git a/mdadm.h b/mdadm.h
> index 3673494e560b..18c24915e94c 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1798,6 +1798,8 @@ static inline int xasprintf(char **strp, const =
char *fmt, ...) {
> #endif
> #define cont_err(fmt ...) fprintf(stderr, "       " fmt)
>=20
> +#define pr_info(fmt, args...) printf("%s: "fmt, Name, ##args)
> +
> void *xmalloc(size_t len);
> void *xrealloc(void *ptr, size_t len);
> void *xcalloc(size_t num, size_t size);
> --=20
> 2.30.2
>=20

--=20
Coly Li
