Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4294C6FA8A
	for <linux-raid@archiver.kernel.org>; Wed, 14 Sep 2022 15:03:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbiINPDT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Sep 2022 11:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiINPDR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Sep 2022 11:03:17 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E3E74B9B
        for <linux-raid@vger.kernel.org>; Wed, 14 Sep 2022 08:03:15 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A36991FDAF;
        Wed, 14 Sep 2022 15:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663167794; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NexBwOUzfZG3iM8Z+2DQU1oae9JXsN0GSvfxQ32kVI4=;
        b=W6OEccpvDstsNZKNbGcPjtXvY5NLx6XYCWpYi3o4bxi7k6tlLM94c9YZn1X8ldmg4JRjYY
        FQS1ofvejGYaVUeVrWCzT9deDWy1mZ7YiAIrWAe8cQ3i+WDKNHmGnzvnPcL0dg0T50VEeM
        rMQlzj6Fj2jPY0MCoeuy4pDSbbOk6Js=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663167794;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NexBwOUzfZG3iM8Z+2DQU1oae9JXsN0GSvfxQ32kVI4=;
        b=RnVL016B7sbHysmWk2dNYxqNjBBILHVQC4JRTLvajT31VuYYXGUzhdaHy7thU8Xo8I4tMB
        7TV4Lmk59UyXe2Bw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8544A134B3;
        Wed, 14 Sep 2022 15:03:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6PYnEjHtIWNdRAAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 14 Sep 2022 15:03:13 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH 05/10] super0: refactor the code for enum
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220818145621.21982-6-mateusz.kusiak@intel.com>
Date:   Wed, 14 Sep 2022 23:03:12 +0800
Cc:     linux-raid <linux-raid@vger.kernel.org>, jes@trained-monkey.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <4E9ADC20-2C7C-4438-A11A-766DF7078AC6@suse.de>
References: <20220818145621.21982-1-mateusz.kusiak@intel.com>
 <20220818145621.21982-6-mateusz.kusiak@intel.com>
To:     Mateusz Kusiak <mateusz.kusiak@intel.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B48=E6=9C=8818=E6=97=A5 22:56=EF=BC=8CMateusz Kusiak =
<mateusz.kusiak@intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> It prepares update_super0 for change context->update to enum.
> Change if else statements to switch.
>=20
> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>


This patch is fine to me almost, except for 2 questions I placed in =
line.



> ---
> super0.c | 102 ++++++++++++++++++++++++++++++++++---------------------
> 1 file changed, 63 insertions(+), 39 deletions(-)
>=20
> diff --git a/super0.c b/super0.c
> index 37f595ed..4e53f41e 100644
> --- a/super0.c
> +++ b/super0.c
> @@ -502,19 +502,39 @@ static int update_super0(struct supertype *st, =
struct mdinfo *info,
> 	int rv =3D 0;
> 	int uuid[4];
> 	mdp_super_t *sb =3D st->sb;
> +	enum update_opt update_enum =3D map_name(update_options, =
update);
>=20
> -	if (strcmp(update, "homehost") =3D=3D 0 &&
> -	    homehost) {
> -		/* note that 'homehost' is special as it is really
> +	if (update_enum =3D=3D UOPT_HOMEHOST && homehost) {
> +		/*
> +		 * note that 'homehost' is special as it is really
> 		 * a "uuid" update.
> 		 */
> 		uuid_set =3D 0;
> -		update =3D "uuid";
> +		update_enum =3D UOPT_UUID;
> 		info->uuid[0] =3D sb->set_uuid0;
> 		info->uuid[1] =3D sb->set_uuid1;
> 	}
>=20
> -	if (strcmp(update, "sparc2.2")=3D=3D0 ) {
> +	switch (update_enum) {
> +	case UOPT_UUID:
> +		if (!uuid_set && homehost) {
> +			char buf[20];
> +			memcpy(info->uuid+2,
> +			       sha1_buffer(homehost, strlen(homehost), =
buf),
> +			       8);
> +		}
> +		sb->set_uuid0 =3D info->uuid[0];
> +		sb->set_uuid1 =3D info->uuid[1];
> +		sb->set_uuid2 =3D info->uuid[2];
> +		sb->set_uuid3 =3D info->uuid[3];
> +		if (sb->state & (1<<MD_SB_BITMAP_PRESENT)) {
> +			struct bitmap_super_s *bm;
> +			bm =3D (struct bitmap_super_s *)(sb+1);
> +			uuid_from_super0(st, uuid);
> +			memcpy(bm->uuid, uuid, 16);
> +		}
> +		break;
> +	case UOPT_SPARC22: {
> 		/* 2.2 sparc put the events in the wrong place
> 		 * So we copy the tail of the superblock
> 		 * up 4 bytes before continuing
> @@ -527,12 +547,15 @@ static int update_super0(struct supertype *st, =
struct mdinfo *info,
> 		if (verbose >=3D 0)
> 			pr_err("adjusting superblock of %s for 2.2/sparc =
compatibility.\n",
> 			       devname);
> -	} else if (strcmp(update, "super-minor") =3D=3D0) {
> +		break;
> +	}


Wondering there isn't compiler warning for unmatched case/break pair, =
since this break is inside the {} code block.

Should the =E2=80=98break=E2=80=99 be placed after {} pair to match key =
word =E2=80=98case=E2=80=99?


>=20
[snipped]
> @@ -628,29 +659,15 @@ static int update_super0(struct supertype *st, =
struct mdinfo *info,
> 		sb->disks[info->disk.number].minor =3D info->disk.minor;
> 		sb->disks[info->disk.number].raid_disk =3D =
info->disk.raid_disk;
> 		sb->disks[info->disk.number].state =3D info->disk.state;
> -	} else if (strcmp(update, "resync") =3D=3D 0) {
> -		/* make sure resync happens */
> +		break;
> +	case UOPT_RESYNC:
> +		/**
> +		 *make sure resync happens
> +		 */


The above change doesn=E2=80=99t follow existing code style for =
comments. How about using the previous one line version?

[snipped]

Thanks.

Coly Li=
