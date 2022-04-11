Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99F4DC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 11 Apr 2022 22:52:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245023AbiDKWya (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 11 Apr 2022 18:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232959AbiDKWy3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 11 Apr 2022 18:54:29 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A616576
        for <linux-raid@vger.kernel.org>; Mon, 11 Apr 2022 15:52:13 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4EC4521605;
        Mon, 11 Apr 2022 22:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649717532; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c4ej9cUj33UAK7nPUsU5JyNxrDOJ/8lrou+eyNWe9FI=;
        b=jqHNmE27BOS0oIFUBCwxr8/oAt7vQ2u5napAg3UW4aAXz5B3KwUdGRccHK97nxLsTDMbF6
        20zNZ8D7LEbkEtQwk6WONBeN3DcQ08pyAJ26Kll0M1Us8OsF7dACoYiAeIOKjtmX+ssuTt
        yvKfDpQNnRXkwf/LczaGhPo15y5CPD8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649717532;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c4ej9cUj33UAK7nPUsU5JyNxrDOJ/8lrou+eyNWe9FI=;
        b=9LBL7BPoqJ76kDqSwFTdjmMX5LeRQBkQFcIhrNeUGqnYO41MLweqh+MIzinoI8OEJbFkSh
        eNfV9fLBndEOjBBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3E6EB13A93;
        Mon, 11 Apr 2022 22:52:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 0QNuOxqxVGLucAAAMHmgww
        (envelope-from <neilb@suse.de>); Mon, 11 Apr 2022 22:52:10 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Pascal Hambourg" <pascal@plouf.fr.eu.org>,
        Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: Re: [PATCH] Ignore RAID0 layout if the second zone has only one device
In-reply-to: <23ea4d81-7c7e-0fea-8a15-52ee045da56f@plouf.fr.eu.org>
References: <7fb90df2-8913-717f-7078-550d59c94054@plouf.fr.eu.org>,
 <164919384282.10985.10644950304504061908@noble.neil.brown.name>,
 <3d16d210-2077-26bf-1eb7-6b9c5ab5fd24@plouf.fr.eu.org>,
 <164928572784.10985.3756904836293591231@noble.neil.brown.name>,
 <23ea4d81-7c7e-0fea-8a15-52ee045da56f@plouf.fr.eu.org>
Date:   Tue, 12 Apr 2022 08:52:08 +1000
Message-id: <164971752831.10985.13291052044828921468@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 08 Apr 2022, Pascal Hambourg wrote:
> Le 07/04/2022 =C3=A0 00:55, NeilBrown wrote:
> > On Wed, 06 Apr 2022, Pascal Hambourg wrote:
> >> On 05/04/2022, NeilBrown wrote:
> >>> On Wed, 06 Apr 2022, Pascal Hambourg wrote:
> >>>>
> >>>> This is a question about original/alternate layout enforcement for RAI=
D0
> >>>> arrays with members of different sizes introduced by commits
> >>>> c84a1372df929033cb1a0441fb57bd3932f39ac9 ("md/raid0: avoid RAID0 data
> >>>> corruption due to layout confusion.)" and
> >>>> 33f2c35a54dfd75ad0e7e86918dcbe4de799a56c ("md: add feature flag
> >>>> MD_FEATURE_RAID0_LAYOUT").
> >>>>
> >>>> The layout is irrelevant if all members have the same size so the array
> >>>> has only one zone. But isn't it also irrelevant if the array has two
> >>>> zones and the second zone has only one device, for example if the array
> >>>> has two members of different sizes ?
> >>>
> >>> Yes.
> >>
> >> So wouldn't it make sense to allow assembly even when the layout is
> >> undefined, like what is done when the array has only one zone ?
> >>
> > Yes.
> >=20
> > P.S.  maybe you would like to try making the code change yourself, and
> > posting the patch.
>=20
> Sure. In order to check the number of devices in the second zone I had
> to move the layout check after all zones are set up. Is this fine ?

Thanks!

Reviewed-By: NeilBrown <neilb@suse.de>

It might be nice to resend with a proper commit message.
Borrowing your words and teaking them a little, it could read:

  The RAID0 layout is irrelevant if all members have the same size so the
  array has only one zone.  It is *also*( irrelevant if the array has two
  zones and the second zone has only one device, for example if the array
  has two members of different sizes ?

  So in that case it makes sense to allow assembly even when the layout is
  undefined, like what is done when the array has only one zone

Thanks,
NeilBrown


>=20
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index b21e101183f4..7623811cc11c 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -128,21 +128,6 @@ static int create_strip_zones(struct mddev *mddev, str=
uct r0conf **private_conf)
>     	pr_debug("md/raid0:%s: FINAL %d zones\n",
>     		 mdname(mddev), conf->nr_strip_zones);
>=20
> -	if (conf->nr_strip_zones =3D=3D 1) {
> -		conf->layout =3D RAID0_ORIG_LAYOUT;
> -	} else if (mddev->layout =3D=3D RAID0_ORIG_LAYOUT ||
> -		   mddev->layout =3D=3D RAID0_ALT_MULTIZONE_LAYOUT) {
> -		conf->layout =3D mddev->layout;
> -	} else if (default_layout =3D=3D RAID0_ORIG_LAYOUT ||
> -		   default_layout =3D=3D RAID0_ALT_MULTIZONE_LAYOUT) {
> -		conf->layout =3D default_layout;
> -	} else {
> -		pr_err("md/raid0:%s: cannot assemble multi-zone RAID0 with default_layou=
t setting\n",
> -		       mdname(mddev));
> -		pr_err("md/raid0: please set raid0.default_layout to 1 or 2\n");
> -		err =3D -ENOTSUPP;
> -		goto abort;
> -	}
>     	/*
>     	 * now since we have the hard sector sizes, we can make sure
>     	 * chunk size is a multiple of that sector size
> @@ -273,6 +258,22 @@ static int create_strip_zones(struct mddev *mddev, str=
uct r0conf **private_conf)
>     			 (unsigned long long)smallest->sectors);
>     	}
>=20
> +	if (conf->nr_strip_zones =3D=3D 1 || conf->strip_zone[1].nb_dev =3D=3D 1)=
 {
> +		conf->layout =3D RAID0_ORIG_LAYOUT;
> +	} else if (mddev->layout =3D=3D RAID0_ORIG_LAYOUT ||
> +		   mddev->layout =3D=3D RAID0_ALT_MULTIZONE_LAYOUT) {
> +		conf->layout =3D mddev->layout;
> +	} else if (default_layout =3D=3D RAID0_ORIG_LAYOUT ||
> +		   default_layout =3D=3D RAID0_ALT_MULTIZONE_LAYOUT) {
> +		conf->layout =3D default_layout;
> +	} else {
> +		pr_err("md/raid0:%s: cannot assemble multi-zone RAID0 with default_layou=
t setting\n",
> +		       mdname(mddev));
> +		pr_err("md/raid0: please set raid0.default_layout to 1 or 2\n");
> +		err =3D -ENOTSUPP;
> +		goto abort;
> +	}
> +
>     	pr_debug("md/raid0:%s: done.\n", mdname(mddev));
>     	*private_conf =3D conf;
>=20
>=20
