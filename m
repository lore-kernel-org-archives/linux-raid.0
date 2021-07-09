Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60D59C07E96
	for <linux-raid@archiver.kernel.org>; Fri,  9 Jul 2021 00:21:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43CB36142D
	for <linux-raid@archiver.kernel.org>; Fri,  9 Jul 2021 00:21:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhGIAYD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 8 Jul 2021 20:24:03 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:49056 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhGIAYC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 8 Jul 2021 20:24:02 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3C49420250;
        Fri,  9 Jul 2021 00:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1625790079; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mI+xgAWKKF+ba+HR1xtAVXGZHO29JiuNWl0AizM5IRg=;
        b=LPDorf1wKa1K/2wGhoRVptbUXBcxdbPoDjIPVmHEgwO5AFoMa+WkieL0+U2tGyw/eWE0dC
        druWlhZKfFgDsjrtJF252QQZZJVJnwIA8ZCUePbv564SLc6WiRA98VsPRM1dMB3fy/guyo
        gzOwXoyd4mdhnkUMhCyAiBHrn8Gy67c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1625790079;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mI+xgAWKKF+ba+HR1xtAVXGZHO29JiuNWl0AizM5IRg=;
        b=gYZlcIv1ONiK+GFw2dJt8sTMfCxZXd4fYMgUa72zRRWcB5an7A3VFuHc9aQPJRz3/lX1j8
        crJJqU2DOL1y0TAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EA76213AEA;
        Fri,  9 Jul 2021 00:21:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id XnJ2Jn2W52DEAwAAMHmgww
        (envelope-from <neilb@suse.de>); Fri, 09 Jul 2021 00:21:17 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Wakko Warner" <wakko@animx.eu.org>
Cc:     "Reindl Harald" <h.reindl@thelounge.net>,
        linux-raid@vger.kernel.org
Subject: Re: bad sector and unused area.
In-reply-to: <YOeKl6vWvy9iYliT@animx.eu.org>
References: <YOdyyGBnFKHr7Xyc@animx.eu.org>,
 <c2e60c47-68fd-4be2-6a8b-633d651bc2e2@thelounge.net>,
 <YOeKl6vWvy9iYliT@animx.eu.org>
Date:   Fri, 09 Jul 2021 10:21:11 +1000
Message-id: <162579007144.31036.14874903367678850529@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 09 Jul 2021, Wakko Warner wrote:
> Reindl Harald wrote:
> >=20
> >=20
> > Am 08.07.21 um 23:48 schrieb Wakko Warner:
> > > I have a raid5 of 3 disks.
> > >=20
> > > 2 of them have bad sectors.  Sector 1110 and 1118.
> > >=20
> > > I'm curious to know if these sectors actually contain any data or if th=
ey
> > > can just be overwritten.
> >=20
> > the RAID layer don't know anything about data by definition, it even don't
> > care what filesystem is running on top
>=20
> So did you actually read what I said?
>=20
>     Data Offset : 262144 sectors
>    Super Offset : 0 sectors
>=20
> This is /dev/sda1 which starts at sector 128 of /dev/sda.  Sector 1110 on
> /dev/sda is bad.  That would place it between super offset and data offset.=
=20
> Thus, there wouldn't be a filesystem there.  I'm asking if it contains any
> "data" that might be "used" by "something".  My /dev/md0 data starts at
> offset 262144 of /dev/sda1 which is well beyond sector 1110 of /dev/sda.

If you had an unusually large bitmap, it might use those bad sectors,
but unlikely.
If you reshaped the array to more devices, it would reduce the Data
Offset, so might start writing in that space.

Otherwise you should be safe.

NeilBrown


>=20
> --=20
>  Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
>  million bugs.
>=20
>=20
