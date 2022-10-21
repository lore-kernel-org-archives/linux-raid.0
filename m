Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9159CC4332F
	for <linux-raid@archiver.kernel.org>; Fri, 21 Oct 2022 06:49:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbiJUGtj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 21 Oct 2022 02:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiJUGtf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 21 Oct 2022 02:49:35 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FC12709
        for <linux-raid@vger.kernel.org>; Thu, 20 Oct 2022 23:49:22 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 716B321890;
        Fri, 21 Oct 2022 06:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1666334960; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k0DKSlCj/yhJSHT5kjq4ciFRsov6zhyn/UowZdUUefI=;
        b=u1qiNHnXrQrjmegE0U2s4ybNFnBxTbwpMleFmwytGgfiphmNEPO+24Dw35izzkXTGff8tg
        iIHKnDKjGy6HGrJFK2y56UXd9C+MXTTIlp/8WiwWtUwg9GtxK8i1tXKn17o9Jdzb5Ocv2J
        xpaDMO71BG13/FffSy6k8dIvqYLbNks=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1666334960;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k0DKSlCj/yhJSHT5kjq4ciFRsov6zhyn/UowZdUUefI=;
        b=v2rj6lDa+N1e5p9txSv+LhOt/pVI90JzPWw98wHy+ERuqEIlQXD85ZeW8fnrpxw7whzeai
        Qr1K/V7yNwq6QBBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8DD741331A;
        Fri, 21 Oct 2022 06:49:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id KGG2Fe9AUmPxHQAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 21 Oct 2022 06:49:19 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH] super-intel: make freesize not required for chunk size
 migration
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20221020045903.19950-1-kinga.tanska@intel.com>
Date:   Fri, 21 Oct 2022 14:49:16 +0800
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D036A378-7504-46EF-9EB6-802EA147CCB9@suse.de>
References: <20221020045903.19950-1-kinga.tanska@intel.com>
To:     Kinga Tanska <kinga.tanska@intel.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B410=E6=9C=8820=E6=97=A5 12:59=EF=BC=8CKinga Tanska =
<kinga.tanska@intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Freesize is not required when chunk size migration is performed. Fix
> return value when superblock is not set.

Hi Kinga,

Could you please provide a bit more information why freesize is =
unnecessary in this situation?

Thanks.

Coly Li


>=20
> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
> ---
> super-intel.c | 10 +++++-----
> 1 file changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index 4d82af3d..37c59da5 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -7714,11 +7714,11 @@ static int validate_geometry_imsm(struct =
supertype *st, int level, int layout,
> 		struct intel_super *super =3D st->sb;
>=20
> 		/*
> -		 * Autolayout mode, st->sb and freesize must be set.
> +		 * Autolayout mode, st->sb must be set.
> 		 */
> -		if (!super || !freesize) {
> -			pr_vrb("freesize and superblock must be set for =
autolayout, aborting\n");
> -			return 1;
> +		if (!super) {
> +			pr_vrb("superblock must be set for autolayout, =
aborting\n");
> +			return 0;
> 		}
>=20
> 		if (!validate_geometry_imsm_orom(st->sb, level, layout,
> @@ -7726,7 +7726,7 @@ static int validate_geometry_imsm(struct =
supertype *st, int level, int layout,
> 						 verbose))
> 			return 0;
>=20
> -		if (super->orom) {
> +		if (super->orom && freesize) {
> 			imsm_status_t rv;
> 			int count =3D count_volumes(super->hba, =
super->orom->dpa,
> 					      verbose);
> --=20
> 2.26.2
>=20

