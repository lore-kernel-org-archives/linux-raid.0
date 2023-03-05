Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFACDC678DB
	for <linux-raid@archiver.kernel.org>; Sun,  5 Mar 2023 22:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjCEWhF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 5 Mar 2023 17:37:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjCEWhD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 5 Mar 2023 17:37:03 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D47C650
        for <linux-raid@vger.kernel.org>; Sun,  5 Mar 2023 14:37:01 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4BBDF1FD97;
        Sun,  5 Mar 2023 22:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678055820; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XCPTT2qdMX0LWixM9/JMiuBntMsiAprVzL7P/LgHMAA=;
        b=iPglPnA+JiWCy70pak1dbGwOnqOoz3x1Mok3iQiGzXa56q0X1zG5d2hGShUrCdJ2fOxA7F
        +3aewihldu8Ob7nyM5iSqjHLb4lJcMo9XWnCb1v/Rww7NQ5MiVMRDp146MIRPw4tLpDcIK
        PnnNUd7fB/RrPGINEMVk61eIQs9Zp1k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678055820;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XCPTT2qdMX0LWixM9/JMiuBntMsiAprVzL7P/LgHMAA=;
        b=8CG8nqHDPadF9LZ9ffemTdyv7JGSv/dwCWNyd0lIhakvys3jPN8BGaaYD6HkGsMbkALp6L
        WMFcTkZR5mCZJ2Cg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0FF8F1339E;
        Sun,  5 Mar 2023 22:36:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id MZlfLYoZBWT1GAAAMHmgww
        (envelope-from <neilb@suse.de>); Sun, 05 Mar 2023 22:36:58 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Dan Carpenter" <error27@gmail.com>
Cc:     linux-raid@vger.kernel.org,
        "cip-dev" <cip-dev@lists.cip-project.org>
Subject: Re: [bug report] md: range check slot number when manually adding a spare.
In-reply-to: <e664f254-90a0-42df-8fc8-ad808f6dedeb@kili.mountain>
References: <e664f254-90a0-42df-8fc8-ad808f6dedeb@kili.mountain>
Date:   Mon, 06 Mar 2023 09:36:55 +1100
Message-id: <167805581590.8008.4986328374228396650@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, 04 Mar 2023, Dan Carpenter wrote:
> [ Ancient code, but you're still at the same email address...  -dan ]

Patch sent.  Thanks for the report.

NeilBrown

>=20
> Hello NeilBrown,
>=20
> The patch ba1b41b6b4e3: "md: range check slot number when manually
> adding a spare." from Jan 14, 2011, leads to the following Smatch
> static checker warning:
>=20
> drivers/md/md.c:3170 slot_store() warn: no lower bound on 'slot'
> drivers/md/md.c:3172 slot_store() warn: no lower bound on 'slot'
> drivers/md/md.c:3190 slot_store() warn: no lower bound on 'slot'
>=20
> drivers/md/md.c
>     3117 static ssize_t
>     3118 slot_store(struct md_rdev *rdev, const char *buf, size_t len)
>     3119 {
>     3120         int slot;
>     3121         int err;
>     3122=20
>     3123         if (test_bit(Journal, &rdev->flags))
>     3124                 return -EBUSY;
>     3125         if (strncmp(buf, "none", 4)=3D=3D0)
>     3126                 slot =3D -1;
>     3127         else {
>     3128                 err =3D kstrtouint(buf, 10, (unsigned int *)&slot);
>=20
> slot comes from the user.
>=20
>     3129                 if (err < 0)
>     3130                         return err;
>     3131         }
>     3132         if (rdev->mddev->pers && slot =3D=3D -1) {
>     3133                 /* Setting 'slot' on an active array requires also
>     3134                  * updating the 'rd%d' link, and communicating
>     3135                  * with the personality with ->hot_*_disk.
>     3136                  * For now we only support removing
>     3137                  * failed/spare devices.  This normally happens au=
tomatically,
>     3138                  * but not when the metadata is externally managed.
>     3139                  */
>     3140                 if (rdev->raid_disk =3D=3D -1)
>     3141                         return -EEXIST;
>     3142                 /* personality does all needed checks */
>     3143                 if (rdev->mddev->pers->hot_remove_disk =3D=3D NULL)
>     3144                         return -EINVAL;
>     3145                 clear_bit(Blocked, &rdev->flags);
>     3146                 remove_and_add_spares(rdev->mddev, rdev);
>     3147                 if (rdev->raid_disk >=3D 0)
>     3148                         return -EBUSY;
>     3149                 set_bit(MD_RECOVERY_NEEDED, &rdev->mddev->recovery=
);
>     3150                 md_wakeup_thread(rdev->mddev->thread);
>     3151         } else if (rdev->mddev->pers) {
>     3152                 /* Activating a spare .. or possibly reactivating
>     3153                  * if we ever get bitmaps working here.
>     3154                  */
>     3155                 int err;
>     3156=20
>     3157                 if (rdev->raid_disk !=3D -1)
>     3158                         return -EBUSY;
>     3159=20
>     3160                 if (test_bit(MD_RECOVERY_RUNNING, &rdev->mddev->re=
covery))
>     3161                         return -EBUSY;
>     3162=20
>     3163                 if (rdev->mddev->pers->hot_add_disk =3D=3D NULL)
>     3164                         return -EINVAL;
>     3165=20
>     3166                 if (slot >=3D rdev->mddev->raid_disks &&
>     3167                     slot >=3D rdev->mddev->raid_disks + rdev->mdde=
v->delta_disks)
>     3168                         return -ENOSPC;
>=20
> -1 is valid, but should this check if slot < -1?
>=20
>     3169=20
> --> 3170                 rdev->raid_disk =3D slot;
>=20
>=20
> regards,
> dan carpenter
>=20

