Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBF2EECAAD3
	for <linux-raid@archiver.kernel.org>; Wed, 14 Sep 2022 15:03:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiINPDL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Sep 2022 11:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiINPDK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Sep 2022 11:03:10 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316C35F112
        for <linux-raid@vger.kernel.org>; Wed, 14 Sep 2022 08:03:09 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E16F61FD58;
        Wed, 14 Sep 2022 15:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663167787; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wAyTVxWCDiV8LbCTaUkT5YQFqxDiuxZtRuUqiMUOm3c=;
        b=ZSxZ+MHKAN7eR0KyqHDF8jDEqf6djZZpPqzJVQOkvX6pTDVudHUZ3aXeJlGNCbaasw9E0o
        BGhPuvHNx7TKfysJwtJVP5OJph1UyNz/wCyZgL1g22WhuVRSXuYGzFZydc1ZeYJgw7Irrx
        pkmJSr4S0pd7/Wcci4JB2nlz/F+sCdQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663167787;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wAyTVxWCDiV8LbCTaUkT5YQFqxDiuxZtRuUqiMUOm3c=;
        b=3X6ZGZ2qFfxuZV8dxitqoBchPJtHJWDS3JezU+ZXTRcXIMq5n1rA1fqBbeir8alcP9JzjE
        yi8LwioytGMw4sAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CC983134B3;
        Wed, 14 Sep 2022 15:03:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 0O1nICrtIWNdRAAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 14 Sep 2022 15:03:06 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH 04/10] super-ddf: Remove update_super_ddf.
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220818145621.21982-5-mateusz.kusiak@intel.com>
Date:   Wed, 14 Sep 2022 23:03:06 +0800
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <C26393F1-8796-45DF-ADAC-51548453DC84@suse.de>
References: <20220818145621.21982-1-mateusz.kusiak@intel.com>
 <20220818145621.21982-5-mateusz.kusiak@intel.com>
To:     Mateusz Kusiak <mateusz.kusiak@intel.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B48=E6=9C=8818=E6=97=A5 22:56=EF=BC=8CMateusz Kusiak =
<mateusz.kusiak@intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> This is not supported by ddf.
> It hides errors by returning success status for some updates.
> Remove update_super_dff().
>=20
> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>


Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li


> ---
> super-ddf.c | 70 -----------------------------------------------------
> 1 file changed, 70 deletions(-)
>=20
> diff --git a/super-ddf.c b/super-ddf.c
> index 949e7d15..ec59b8af 100644
> --- a/super-ddf.c
> +++ b/super-ddf.c
> @@ -2139,75 +2139,6 @@ static void getinfo_super_ddf_bvd(struct =
supertype *st, struct mdinfo *info, cha
> 		}
> }
>=20
> -static int update_super_ddf(struct supertype *st, struct mdinfo =
*info,
> -			    char *update,
> -			    char *devname, int verbose,
> -			    int uuid_set, char *homehost)
> -{
> -	/* For 'assemble' and 'force' we need to return non-zero if any
> -	 * change was made.  For others, the return value is ignored.
> -	 * Update options are:
> -	 *  force-one : This device looks a bit old but needs to be =
included,
> -	 *        update age info appropriately.
> -	 *  assemble: clear any 'faulty' flag to allow this device to
> -	 *		be assembled.
> -	 *  force-array: Array is degraded but being forced, mark it =
clean
> -	 *	   if that will be needed to assemble it.
> -	 *
> -	 *  newdev:  not used ????
> -	 *  grow:  Array has gained a new device - this is currently for
> -	 *		linear only
> -	 *  resync: mark as dirty so a resync will happen.
> -	 *  uuid:  Change the uuid of the array to match what is given
> -	 *  homehost:  update the recorded homehost
> -	 *  name:  update the name - preserving the homehost
> -	 *  _reshape_progress: record new reshape_progress position.
> -	 *
> -	 * Following are not relevant for this version:
> -	 *  sparc2.2 : update from old dodgey metadata
> -	 *  super-minor: change the preferred_minor number
> -	 *  summaries:  update redundant counters.
> -	 */
> -	int rv =3D 0;
> -//	struct ddf_super *ddf =3D st->sb;
> -//	struct vd_config *vd =3D find_vdcr(ddf, info->container_member);
> -//	struct virtual_entry *ve =3D find_ve(ddf);
> -
> -	/* we don't need to handle "force-*" or "assemble" as
> -	 * there is no need to 'trick' the kernel.  When the metadata is
> -	 * first updated to activate the array, all the implied =
modifications
> -	 * will just happen.
> -	 */
> -
> -	if (strcmp(update, "grow") =3D=3D 0) {
> -		/* FIXME */
> -	} else if (strcmp(update, "resync") =3D=3D 0) {
> -//		info->resync_checkpoint =3D 0;
> -	} else if (strcmp(update, "homehost") =3D=3D 0) {
> -		/* homehost is stored in controller->vendor_data,
> -		 * or it is when we are the vendor
> -		 */
> -//		if (info->vendor_is_local)
> -//			strcpy(ddf->controller.vendor_data, homehost);
> -		rv =3D -1;
> -	} else if (strcmp(update, "name") =3D=3D 0) {
> -		/* name is stored in virtual_entry->name */
> -//		memset(ve->name, ' ', 16);
> -//		strncpy(ve->name, info->name, 16);
> -		rv =3D -1;
> -	} else if (strcmp(update, "_reshape_progress") =3D=3D 0) {
> -		/* We don't support reshape yet */
> -	} else if (strcmp(update, "assemble") =3D=3D 0 ) {
> -		/* Do nothing, just succeed */
> -		rv =3D 0;
> -	} else
> -		rv =3D -1;
> -
> -//	update_all_csum(ddf);
> -
> -	return rv;
> -}
> -
> static void make_header_guid(char *guid)
> {
> 	be32 stamp;
> @@ -5211,7 +5142,6 @@ struct superswitch super_ddf =3D {
> 	.match_home	=3D match_home_ddf,
> 	.uuid_from_super=3D uuid_from_super_ddf,
> 	.getinfo_super  =3D getinfo_super_ddf,
> -	.update_super	=3D update_super_ddf,
>=20
> 	.avail_size	=3D avail_size_ddf,
>=20
> --=20
> 2.26.2
>=20

