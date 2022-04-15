Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD9CFC433F5
	for <linux-raid@archiver.kernel.org>; Fri, 15 Apr 2022 04:07:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241474AbiDOEJt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 15 Apr 2022 00:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238722AbiDOEJr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 15 Apr 2022 00:09:47 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DBBA889B
        for <linux-raid@vger.kernel.org>; Thu, 14 Apr 2022 21:07:20 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 01D88210E6;
        Fri, 15 Apr 2022 04:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649995639; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XG2J/b+vOhSkobI8M1mmZTNPm/b2yIX/1XTWkysYOE0=;
        b=zEWEsfYyJpUNXatWB2ph8o9HF2OF2BJputKBFQIgQcDBZyej9a9xj2tehZM6rJ08v16Z8H
        A5LPTgQpPu8wrxnuXE8fq2puyRBjl/vcUcDdZ6OjaraTss5wlef7SJpoMEfqbUrRJEkO0W
        H29Lx21SpKGUljN3hayoPMcRXyWcNhk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649995639;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XG2J/b+vOhSkobI8M1mmZTNPm/b2yIX/1XTWkysYOE0=;
        b=5lklxQtdBG+5wdXDkdOSECvDt63MZy3sb6jXAA7deWDK40xA+fBUgGWTYMW3kiY6VuN6qJ
        9BmQCHokdfD18hAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A2A5C13A9B;
        Fri, 15 Apr 2022 04:07:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id A4UfF3TvWGJoWQAAMHmgww
        (envelope-from <neilb@suse.de>); Fri, 15 Apr 2022 04:07:16 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Song Liu" <song@kernel.org>
Cc:     "Pascal Hambourg" <pascal@plouf.fr.eu.org>,
        "linux-raid" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH v2] md/raid0: Ignore RAID0 layout if the second zone has
 only one device
In-reply-to: <CAPhsuW5+Y4K+fNSgx5AYwHkAHPw8i9z01LWrXM5qOP8qvvzuCg@mail.gmail.com>
References: <7ffe1f1e-1054-6119-83a8-53edd89a902b@plouf.fr.eu.org>,
 <CAPhsuW5+Y4K+fNSgx5AYwHkAHPw8i9z01LWrXM5qOP8qvvzuCg@mail.gmail.com>
Date:   Fri, 15 Apr 2022 14:07:11 +1000
Message-id: <164999563146.7179.4204941865640770764@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 15 Apr 2022, Song Liu wrote:
> On Tue, Apr 12, 2022 at 11:54 PM Pascal Hambourg <pascal@plouf.fr.eu.org> w=
rote:
> >
> > The RAID0 layout is irrelevant if all members have the same size so the
> > array has only one zone. It is *also* irrelevant if the array has two
> > zones and the second zone has only one device, for example if the array
> > has two members of different sizes.
> >
> > So in that case it makes sense to allow assembly even when the layout is
> > undefined, like what is done when the array has only one zone.
> >
> > Reviewed-By: NeilBrown <neilb@suse.de>
> > Signed-off-by: Pascal Hambourg <pascal@plouf.fr.eu.org>
>=20
> Thanks for the patch and thanks Neil for the review.
>=20
> Applied to md-next with two minor changes:
>=20
> s/ENOTSUPP/EOPNOTSUPP/

Why did you change the error code that was returned?  If you want to do
that it should be a separate patch with explanation.

> s/Reviewed-By/Review-by/

Do you mean s/Reviewed-By/Reviewed-by/  - i.e. change the B to b ??

Since v5.0 there have only be 5 "Review-by" and over 100,000
"Reviewed-by" (and about 100 "Reviewed-By").

Thanks,
NeilBrown


>=20
> Thanks,
> Song
>=20
> > ---
> >
> > Changes since v1:
> > - add missing Signed-off-by
> > - add missing subsystem maintainer in recipients
> >
> > ---
> >   drivers/md/raid0.c | 31 ++++++++++++++++---------------
> >   1 file changed, 16 insertions(+), 15 deletions(-)
> >
> > diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> > index b21e101183f4..7623811cc11c 100644
> > --- a/drivers/md/raid0.c
> > +++ b/drivers/md/raid0.c
> > @@ -128,21 +128,6 @@ static int create_strip_zones(struct mddev *mddev, s=
truct r0conf **private_conf)
> >         pr_debug("md/raid0:%s: FINAL %d zones\n",
> >                  mdname(mddev), conf->nr_strip_zones);
> >
> > -       if (conf->nr_strip_zones =3D=3D 1) {
> > -               conf->layout =3D RAID0_ORIG_LAYOUT;
> > -       } else if (mddev->layout =3D=3D RAID0_ORIG_LAYOUT ||
> > -                  mddev->layout =3D=3D RAID0_ALT_MULTIZONE_LAYOUT) {
> > -               conf->layout =3D mddev->layout;
> > -       } else if (default_layout =3D=3D RAID0_ORIG_LAYOUT ||
> > -                  default_layout =3D=3D RAID0_ALT_MULTIZONE_LAYOUT) {
> > -               conf->layout =3D default_layout;
> > -       } else {
> > -               pr_err("md/raid0:%s: cannot assemble multi-zone RAID0 wit=
h default_layout setting\n",
> > -                      mdname(mddev));
> > -               pr_err("md/raid0: please set raid0.default_layout to 1 or=
 2\n");
> > -               err =3D -ENOTSUPP;
> > -               goto abort;
> > -       }
> >         /*
> >          * now since we have the hard sector sizes, we can make sure
> >          * chunk size is a multiple of that sector size
> > @@ -273,6 +258,22 @@ static int create_strip_zones(struct mddev *mddev, s=
truct r0conf **private_conf)
> >                          (unsigned long long)smallest->sectors);
> >         }
> >
> > +       if (conf->nr_strip_zones =3D=3D 1 || conf->strip_zone[1].nb_dev =
=3D=3D 1) {
> > +               conf->layout =3D RAID0_ORIG_LAYOUT;
> > +       } else if (mddev->layout =3D=3D RAID0_ORIG_LAYOUT ||
> > +                  mddev->layout =3D=3D RAID0_ALT_MULTIZONE_LAYOUT) {
> > +               conf->layout =3D mddev->layout;
> > +       } else if (default_layout =3D=3D RAID0_ORIG_LAYOUT ||
> > +                  default_layout =3D=3D RAID0_ALT_MULTIZONE_LAYOUT) {
> > +               conf->layout =3D default_layout;
> > +       } else {
> > +               pr_err("md/raid0:%s: cannot assemble multi-zone RAID0 wit=
h default_layout setting\n",
> > +                      mdname(mddev));
> > +               pr_err("md/raid0: please set raid0.default_layout to 1 or=
 2\n");
> > +               err =3D -ENOTSUPP;
> > +               goto abort;
> > +       }
> > +
> >         pr_debug("md/raid0:%s: done.\n", mdname(mddev));
> >         *private_conf =3D conf;
> >
> > --
> > 2.11.0
> >
>=20
