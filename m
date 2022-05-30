Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32BC6C433F5
	for <linux-raid@archiver.kernel.org>; Mon, 30 May 2022 10:05:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbiE3KFX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 May 2022 06:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235053AbiE3KFW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 30 May 2022 06:05:22 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D02627980B
        for <linux-raid@vger.kernel.org>; Mon, 30 May 2022 03:05:20 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8935A21B57;
        Mon, 30 May 2022 10:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653905119; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YoC8vcucl3syrXKhOgTj1imnVP5FrU317dKFLp0EHso=;
        b=ihg6GqiQ+41tdLgVxXzEHuWyUXQbeg3F0tlHTlm1zNkZwnntAh+2TINLgrjMiG8jK0iIxg
        d7C9uhr9EzbUPWd7jQuI7aTtrxi8NsFsNL1btLUHfPv0L2DmQ+pBtU1i+OIC3qKdLNR0MW
        lEAzgsbkGMXiwiRMVxsW7v+E2hLfEJc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653905119;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YoC8vcucl3syrXKhOgTj1imnVP5FrU317dKFLp0EHso=;
        b=+xtUdP31lkG7dxfEFH+IShANgUsHr2IDTw2xKDb7kO0tbWyXXZrdwPfV6S6wcSrLKuYuht
        gRFdJ56RkzGJPfDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7916013A84;
        Mon, 30 May 2022 10:05:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 94CCEd6WlGLJRAAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 30 May 2022 10:05:18 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH 2/2] mdadm: Remove dead code in imsm_fix_size_mismatch
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220407142739.60198-3-lukasz.florczak@linux.intel.com>
Date:   Mon, 30 May 2022 18:05:15 +0800
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org,
        pmenzel@molgen.mpg.de
Content-Transfer-Encoding: quoted-printable
Message-Id: <BF3DD9C9-408D-4DDD-9A94-1E8288693B43@suse.de>
References: <20220407142739.60198-1-lukasz.florczak@linux.intel.com>
 <20220407142739.60198-3-lukasz.florczak@linux.intel.com>
To:     Lukasz Florczak <lukasz.florczak@linux.intel.com>
X-Mailer: Apple Mail (2.3696.100.31)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B44=E6=9C=887=E6=97=A5 22:27=EF=BC=8CLukasz Florczak =
<lukasz.florczak@linux.intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> imsm_create_metadata_update_for_size_change() that returns u_size =
value
> could return 0 in the past. As its behavior changed, and returned =
value
> is always the size of imsm_update_size_change structure, check for
> u_size is no longer needed.
>=20
> Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>

It looks good to me.

Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li

> ---
> super-intel.c | 4 ----
> 1 file changed, 4 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index 102689bc..cb5292e1 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -11772,10 +11772,6 @@ static int imsm_fix_size_mismatch(struct =
supertype *st, int subarray_index)
> 		geo.size =3D d_size;
> 		u_size =3D =
imsm_create_metadata_update_for_size_change(st, &geo,
> 								     =
&update);
> -		if (u_size < 1) {
> -			dprintf("imsm: Cannot prepare size change =
update\n");
> -			goto exit;
> -		}
> 		imsm_update_metadata_locally(st, update, u_size);
> 		if (st->update_tail) {
> 			append_metadata_update(st, update, u_size);
> --=20
> 2.27.0
>=20

