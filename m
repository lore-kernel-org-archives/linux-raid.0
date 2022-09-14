Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BE1FECAAD3
	for <linux-raid@archiver.kernel.org>; Wed, 14 Sep 2022 15:03:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiINPDf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Sep 2022 11:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbiINPDb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Sep 2022 11:03:31 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C2F7392E
        for <linux-raid@vger.kernel.org>; Wed, 14 Sep 2022 08:03:30 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0EA5A3393A;
        Wed, 14 Sep 2022 15:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663167809; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OcgsIgCkM+BzqsKpUMb+SFe/yoJnCOnWSnx/CHjA5Hg=;
        b=X31g+2Z7XI2ledURVLMDaKr1rjM9/4VOjO/Y0VO1IUPWTQT9JXWiHdbz37G7IR8ZD5i+vq
        m6vsFzuw/uYaPYp41F4heT1e1qil60JzvojCdSXf6ZU+tQlWv2CEjWD4luOev6yqATV58a
        rkbp+I8j4JEunbVOlE7Y4b+ZrW33tsc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663167809;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OcgsIgCkM+BzqsKpUMb+SFe/yoJnCOnWSnx/CHjA5Hg=;
        b=edoAhG19gEnUCKs+Brm97/CyYc4E/p2en6jeUrllqPGM+l1lXBXwxm3qMivzgFrsnJwWF/
        CY03j2ysQDvv25BA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 84397134B3;
        Wed, 14 Sep 2022 15:03:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4Gi0ET/tIWNdRAAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 14 Sep 2022 15:03:27 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH 07/10] super-intel: refactor the code for enum
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220818145621.21982-8-mateusz.kusiak@intel.com>
Date:   Wed, 14 Sep 2022 23:03:26 +0800
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Jes Sorensen <jes@trained-monkey.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <78011938-BC68-4E12-BD0A-F49F1EE6FA65@suse.de>
References: <20220818145621.21982-1-mateusz.kusiak@intel.com>
 <20220818145621.21982-8-mateusz.kusiak@intel.com>
To:     Mateusz Kusiak <mateusz.kusiak@intel.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B48=E6=9C=8818=E6=97=A5 22:56=EF=BC=8CMateusz Kusiak =
<mateusz.kusiak@intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> It prepares super-intel for change context->update to enum.
>=20
> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
> ---
> super-intel.c | 38 +++++++++++++++++++++++++-------------
> 1 file changed, 25 insertions(+), 13 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index 672f946e..3de3873e 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -3930,7 +3930,8 @@ static int update_super_imsm(struct supertype =
*st, struct mdinfo *info,
>=20
> 	mpb =3D super->anchor;
>=20
> -	if (strcmp(update, "uuid") =3D=3D 0) {
> +	switch (map_name(update_options, update)) {
> +	case UOPT_UUID:
> 		/* We take this to mean that the family_num should be =
updated.
> 		 * However that is much smaller than the uuid so we =
cannot really
> 		 * allow an explicit uuid to be given.  And it is hard =
to reliably
> @@ -3954,10 +3955,14 @@ static int update_super_imsm(struct supertype =
*st, struct mdinfo *info,
> 		}
> 		if (rv =3D=3D 0)
> 			mpb->orig_family_num =3D info->uuid[0];
> -	} else if (strcmp(update, "assemble") =3D=3D 0)
> +		break;
> +	case UOPT_SPEC_ASSEMBLE:
> 		rv =3D 0;
> -	else
> +		break;
> +	default:
> 		rv =3D -1;
> +		break;
> +	}
>=20
> 	/* successful update? recompute checksum */
> 	if (rv =3D=3D 0)
> @@ -7888,18 +7893,25 @@ static int kill_subarray_imsm(struct supertype =
*st, char *subarray_id)
>=20
> 	return 0;
> }
> -
> -static int get_rwh_policy_from_update(char *update)
> +/**
> + * get_rwh_policy_from_update() - Get the rwh policy for update =
option.
> + * @update: Update option.
> + */


The above comment format is not the existed code comments style.

For example for getinfo_super_disks_imsm() in same file,

 3862 /* allocates memory and fills disk in mdinfo structure
 3863  * for each disk in array */
 3864 struct mdinfo *getinfo_super_disks_imsm(struct supertype *st)


[snipped]

The rested part is fine to me.

Thanks.

Coly Li=
