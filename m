Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40336C6FA82
	for <linux-raid@archiver.kernel.org>; Wed, 14 Sep 2022 15:03:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiINPDe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Sep 2022 11:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiINPD3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Sep 2022 11:03:29 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC00674DD3
        for <linux-raid@vger.kernel.org>; Wed, 14 Sep 2022 08:03:22 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9C6F51FD9D;
        Wed, 14 Sep 2022 15:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663167801; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kv8ZYy3Xs5BUjelQCFhN4XZyijAeUwCbF2qwUcQUcaI=;
        b=pTXeSIwH0GOq2otBkEsFAWjolonm4N9+TBH7L2wzBrm7jIyfv6IA4xci25HMfMMqbCsnOx
        oPNHQG3/XQdn1k01DZl5dKOsjw5OiSwyCy5r05CkozCVPLJ6wWyvCoFuPnfhLaK21INMHF
        9joVtSjk+Vh3byzQyEt5zvK4nawlfhE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663167801;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kv8ZYy3Xs5BUjelQCFhN4XZyijAeUwCbF2qwUcQUcaI=;
        b=to/B+na8b9jYBSIjEul9WPtkysiZLiVmFAgDhUseXF7HCymigpwEbfARM2vYinDnafPnp0
        d/ArxEinBHZSvoCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 21CBB134B3;
        Wed, 14 Sep 2022 15:03:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id gKALMzftIWNdRAAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 14 Sep 2022 15:03:19 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH 06/10] super1: refactor the code for enum
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220818145621.21982-7-mateusz.kusiak@intel.com>
Date:   Wed, 14 Sep 2022 23:03:19 +0800
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <79C06B27-C8DD-4E87-9C40-72160D26C641@suse.de>
References: <20220818145621.21982-1-mateusz.kusiak@intel.com>
 <20220818145621.21982-7-mateusz.kusiak@intel.com>
To:     Mateusz Kusiak <mateusz.kusiak@intel.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B48=E6=9C=8818=E6=97=A5 22:56=EF=BC=8CMateusz Kusiak =
<mateusz.kusiak@intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> It prepares update_super1 for change context->update to enum.
> Change if else statements into switch.
>=20
> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
> ---
> super1.c | 149 ++++++++++++++++++++++++++++++++-----------------------
> 1 file changed, 87 insertions(+), 62 deletions(-)
>=20
> diff --git a/super1.c b/super1.c
> index 71af860c..6c81c1b9 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -1212,30 +1212,53 @@ static int update_super1(struct supertype *st, =
struct mdinfo *info,
> 	int rv =3D 0;
> 	struct mdp_superblock_1 *sb =3D st->sb;
> 	bitmap_super_t *bms =3D (bitmap_super_t*)(((char*)sb) + =
MAX_SB_SIZE);
> +	enum update_opt update_enum =3D map_name(update_options, =
update);
>=20
> -	if (strcmp(update, "homehost") =3D=3D 0 &&
> -	    homehost) {
> -		/* Note that 'homehost' is special as it is really
> +	if (update_enum =3D=3D UOPT_HOMEHOST && homehost) {
> +		/*
> +		 * Note that 'homehost' is special as it is really
> 		 * a "name" update.
> 		 */
> 		char *c;
> -		update =3D "name";
> +		update_enum =3D UOPT_NAME;
> 		c =3D strchr(sb->set_name, ':');
> 		if (c)
> -			strncpy(info->name, c+1, 31 - (c-sb->set_name));
> +			snprintf(info->name, sizeof(info->name), "%s", =
c+1);
> 		else
> -			strncpy(info->name, sb->set_name, 32);
> -		info->name[32] =3D 0;
> +			snprintf(info->name, sizeof(info->name), "%s", =
sb->set_name);
> 	}
>=20
> -	if (strcmp(update, "force-one")=3D=3D0) {
> +	switch (update_enum) {
> +	case UOPT_NAME:
> +		if (!info->name[0])
> +			snprintf(info->name, sizeof(info->name), "%d", =
info->array.md_minor);
> +		memset(sb->set_name, 0, sizeof(sb->set_name));
> +		int namelen;
> +

The above variable =E2=80=99namelen=E2=80=99 might be declared at =
beginning of this code block.


> +		namelen =3D strnlen(homehost, MD_NAME_MAX) + 1 + =
strnlen(info->name, MD_NAME_MAX);
> +		if (homehost &&
> +		    strchr(info->name, ':') =3D=3D NULL &&
> +		    namelen < MD_NAME_MAX) {
> +			strcpy(sb->set_name, homehost);
> +			strcat(sb->set_name, ":");
> +			strcat(sb->set_name, info->name);
> +		} else {
> +			namelen =3D min((int)strnlen(info->name, =
MD_NAME_MAX),
> +				      (int)sizeof(sb->set_name) - 1);
> +			memcpy(sb->set_name, info->name, namelen);
> +			memset(&sb->set_name[namelen], '\0',
> +			       sizeof(sb->set_name) - namelen);
> +		}
> +		break;
>=20
[snipped]
> @@ -1569,32 +1589,37 @@ static int update_super1(struct supertype *st, =
struct mdinfo *info,
> 			}
> 		done:;
> 		}
> -	} else if (strcmp(update, "_reshape_progress") =3D=3D 0)
> +		break;
> +	case UOPT_SPEC__RESHAPE_PROGRESS:
> 		sb->reshape_position =3D =
__cpu_to_le64(info->reshape_progress);
> -	else if (strcmp(update, "writemostly") =3D=3D 0)
> -		sb->devflags |=3D WriteMostly1;
> -	else if (strcmp(update, "readwrite") =3D=3D 0)
> +		break;
> +	case UOPT_SPEC_READWRITE:
> 		sb->devflags &=3D ~WriteMostly1;
> -	else if (strcmp(update, "failfast") =3D=3D 0)

Writemostly-setting is removed here, is it on purpose ?

[snip]

Thanks.

Coly Li=
