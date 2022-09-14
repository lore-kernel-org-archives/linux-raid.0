Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEFD8C6FA82
	for <linux-raid@archiver.kernel.org>; Wed, 14 Sep 2022 15:03:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiINPC7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Sep 2022 11:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiINPC6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Sep 2022 11:02:58 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850E16DAEA
        for <linux-raid@vger.kernel.org>; Wed, 14 Sep 2022 08:02:57 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 407401FD5B;
        Wed, 14 Sep 2022 15:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663167776; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ByGCllj7X+SLq8EHYDNIzvuVqx3cofl2MfnuwFufH90=;
        b=Jxx4CWhmD48QP7EAt+i9dJG5a0qOi/AzF22EYaK3t/O9f6UIobfT5vzW7W62aEGy2L0TQq
        pE+W9MvES7/0uUSMq7SmekigfCQiWHThxwriPeKelWos/BfVVIFxb9UbFtWoWrm3Fp+mu8
        maU56zOmDvxpW57o0iwN3XUywBW1do0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663167776;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ByGCllj7X+SLq8EHYDNIzvuVqx3cofl2MfnuwFufH90=;
        b=dyXK8nYC8wKiAsOnecL/eop5Oj3dYWN3WETlaMaKqjLzcL1ia3QV3I34GRUjCUrILWnAUx
        e0J66992apL4XvCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2DE49134B3;
        Wed, 14 Sep 2022 15:02:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id b7QONh7tIWNdRAAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 14 Sep 2022 15:02:54 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH 02/10] Fix --update-subarray on active volume
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220818145621.21982-3-mateusz.kusiak@intel.com>
Date:   Wed, 14 Sep 2022 23:02:51 +0800
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <CFEFDA36-D5C7-4B52-A008-A49AB5EFF17F@suse.de>
References: <20220818145621.21982-1-mateusz.kusiak@intel.com>
 <20220818145621.21982-3-mateusz.kusiak@intel.com>
To:     Mateusz Kusiak <mateusz.kusiak@intel.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B48=E6=9C=8818=E6=97=A5 22:56=EF=BC=8CMateusz Kusiak =
<mateusz.kusiak@intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Options: bitmap, ppl and name should not be updated when array is =
active.
> Those features are mutually exclusive and share the same data area in =
IMSM (danger of overwriting by kernel).
> Remove check for active subarrays from super-intel.
> Since ddf is not supported, apply it globally for all options.
>=20
> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>


Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li


> ---
> Manage.c      | 7 +++++++
> super-intel.c | 5 -----
> 2 files changed, 7 insertions(+), 5 deletions(-)
>=20
> diff --git a/Manage.c b/Manage.c
> index e5e6abe4..b9f0b184 100644
> --- a/Manage.c
> +++ b/Manage.c
> @@ -1694,6 +1694,13 @@ int Update_subarray(char *dev, char *subarray, =
char *update, struct mddev_ident
> 		goto free_super;
> 	}
>=20
> +	if (is_subarray_active(subarray, st->devnm)) {
> +		if (verbose >=3D 0)
> +			pr_err("Subarray %s in %s is active, cannot =
update %s\n",
> +			       subarray, dev, update);
> +		goto free_super;
> +	}
> +
> 	if (mdmon_running(st->devnm))
> 		st->update_tail =3D &st->updates;
>=20
> diff --git a/super-intel.c b/super-intel.c
> index 4ddfcf94..672f946e 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -7914,11 +7914,6 @@ static int update_subarray_imsm(struct =
supertype *st, char *subarray,
> 		char *ep;
> 		int vol;
>=20
> -		if (is_subarray_active(subarray, st->devnm)) {
> -			pr_err("Unable to update name of active =
subarray\n");
> -			return 2;
> -		}
> -
> 		if (!check_name(super, name, 0))
> 			return 2;
>=20
> --=20
> 2.26.2
>=20

