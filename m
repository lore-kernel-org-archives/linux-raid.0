Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADB13C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 30 May 2022 10:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233075AbiE3KBL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 May 2022 06:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232856AbiE3KBK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 30 May 2022 06:01:10 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C6F71D8D
        for <linux-raid@vger.kernel.org>; Mon, 30 May 2022 03:01:09 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 632AD1FA1A;
        Mon, 30 May 2022 10:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653904868; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=71GqfoKP85twVICXBe7C+WhBuizQjMUyiNhhfNT/dPI=;
        b=noitPV9Vs0daX4DqgYZb2bSzEMRG5qgaqFqHMnYwi9vHzVHRkr2dr+V1pICHePW/W9KLpg
        VVV3Kib3e2qM55BYZXrg3dHEd0Pgay/i5u5eezOMiJCw+gCpYr5H0tsumfNCR5TThYzFTh
        ze33vyQdKwrpuDRlvfWGeZ4ZdiJNMOg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653904868;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=71GqfoKP85twVICXBe7C+WhBuizQjMUyiNhhfNT/dPI=;
        b=v7f+SQ+TUi4xHha8Sqqnw7XvNHO3QrWILmAjMXvsBPj/+Car3rweY183Y+6oNn8rdYrEFT
        /5pLSiLqt0RMnuBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 88D9913A84;
        Mon, 30 May 2022 10:01:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id PacoGOOVlGLzQgAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 30 May 2022 10:01:07 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH 1/2] mdadm: Fix array size mismatch after grow
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220407142739.60198-2-lukasz.florczak@linux.intel.com>
Date:   Mon, 30 May 2022 18:01:05 +0800
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org,
        pmenzel@molgen.mpg.de
Content-Transfer-Encoding: quoted-printable
Message-Id: <35B48024-E02A-45EB-AC5C-4C3DDB2055E3@suse.de>
References: <20220407142739.60198-1-lukasz.florczak@linux.intel.com>
 <20220407142739.60198-2-lukasz.florczak@linux.intel.com>
To:     Lukasz Florczak <lukasz.florczak@linux.intel.com>
X-Mailer: Apple Mail (2.3696.100.31)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Lukasz,


> 2022=E5=B9=B44=E6=9C=887=E6=97=A5 22:27=EF=BC=8CLukasz Florczak =
<lukasz.florczak@linux.intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> imsm_fix_size_mismatch() is invoked to fix the problem, but it =
couldn't
> proceed due to migration check. This patch allows for intended =
behavior.


Could you please explain a bit more about why =E2=80=9Cit couldn=E2=80=99t=
 proceed due to migration=E2=80=9D, and what is the =E2=80=9Cintended =
behavior=E2=80=9D?
It may help me to understand your change and response faster.

Thank you in advance.

Coly Li

>=20
> Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>
> ---
> super-intel.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index d5fad102..102689bc 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -11757,7 +11757,7 @@ static int imsm_fix_size_mismatch(struct =
supertype *st, int subarray_index)
> 		unsigned long long d_size =3D imsm_dev_size(dev);
> 		int u_size;
>=20
> -		if (calc_size =3D=3D d_size || dev->vol.migr_type =3D=3D =
MIGR_GEN_MIGR)
> +		if (calc_size =3D=3D d_size)
> 			continue;
>=20
> 		/* There is a difference, confirm that imsm_dev_size is
> --=20
> 2.27.0
>=20

