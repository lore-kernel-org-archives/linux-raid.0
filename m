Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AA15C4361B
	for <linux-raid@archiver.kernel.org>; Wed, 16 Dec 2020 02:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23A69224BE
	for <linux-raid@archiver.kernel.org>; Wed, 16 Dec 2020 02:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725771AbgLPCVV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Dec 2020 21:21:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbgLPCVV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 15 Dec 2020 21:21:21 -0500
Received: from mail1.84.tech (mail1.84.tech [IPv6:2001:bc8:321a:200:fa7:a55:d1e7:f00d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95C7C0613D6
        for <linux-raid@vger.kernel.org>; Tue, 15 Dec 2020 18:20:40 -0800 (PST)
Received: from localhost (localhost [IPv6:::1])
        by mail1.84.tech (Postfix) with ESMTP id A19EB50566F;
        Wed, 16 Dec 2020 03:20:39 +0100 (CET)
Received: from mail1.84.tech ([IPv6:::1])
        by localhost (mail1.84.tech [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id vYcvUPieRPm0; Wed, 16 Dec 2020 03:20:39 +0100 (CET)
Received: from localhost (localhost [IPv6:::1])
        by mail1.84.tech (Postfix) with ESMTP id 3F206505670;
        Wed, 16 Dec 2020 03:20:39 +0100 (CET)
X-Virus-Scanned: amavisd-new at 84.tech
Received: from mail1.84.tech ([IPv6:::1])
        by localhost (mail1.84.tech [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id tBB0wB-zQ6FI; Wed, 16 Dec 2020 03:20:39 +0100 (CET)
Received: from mail.seblu.net (mail.seblu.net [IPv6:2001:bc8:3173:101:bad:cafe:bad:c0de])
        by mail1.84.tech (Postfix) with ESMTPS id 28BA850566F;
        Wed, 16 Dec 2020 03:20:39 +0100 (CET)
Received: from localhost (localhost [IPv6:::1])
        by mail.seblu.net (Postfix) with ESMTP id B3D325381665;
        Wed, 16 Dec 2020 03:20:38 +0100 (CET)
Received: from mail.seblu.net ([IPv6:::1])
        by localhost (mail.seblu.net [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id NPHkU6rp2RlL; Wed, 16 Dec 2020 03:20:38 +0100 (CET)
Received: from localhost (localhost [IPv6:::1])
        by mail.seblu.net (Postfix) with ESMTP id 3B8C553839FD;
        Wed, 16 Dec 2020 03:20:38 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.seblu.net 3B8C553839FD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seblu.net; s=pipa;
        t=1608085238; bh=67sdZ2yQ13aUWnf9VpUsK46G/55NJuPndobrci8wu0o=;
        h=Message-ID:From:To:Date:MIME-Version;
        b=Trzuskm3Nu9f8rp8T8C24aus8LojY25wDWfbovFMJaWaTB4cmqzt0ZBh8Lw80IiNB
         TKRPqC7vL4WG5h4ke5bh/tzQ1UfbqHO+mIQwf87FTwn39t6oIYSAtw6WvKUgCXB8AI
         /i32i3A/pHXn3/ag4xQuqu3i8z7KL7hkB+zdFoA83skYcGsGvwdgDFxXAbD/fxPnIG
         AQ4tAb+YMdB7WRJs9S2ZSvwC6tZ/SNrKkYkidBZnb7ZRkGEOtCOWLbW/0mG0BButDD
         EOKxDsHFZckqwm1BQ//e5WkUd5xw3t+X9/sVTUjmNxjPzkTy5DySRCF/tT5UB0C6J/
         0UHZJJIQjif1Q==
X-Virus-Scanned: amavisd-new at seblu.net
Received: from mail.seblu.net ([IPv6:::1])
        by localhost (mail.seblu.net [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id CnpQTeIxMGCz; Wed, 16 Dec 2020 03:20:38 +0100 (CET)
Received: from [IPv6:2a01:e0a:1f8:6b42:be57:b00b:a2e:b19] (unknown [IPv6:2a01:e0a:1f8:6b42:be57:b00b:a2e:b19])
        by mail.seblu.net (Postfix) with ESMTPSA id 252CB5381665;
        Wed, 16 Dec 2020 03:20:38 +0100 (CET)
Message-ID: <5d57edd9de751d009023407666f97e72a31f1459.camel@seblu.net>
Subject: Re: Array size dropped from 40TB to 7TB when upgrading to 5.10
From:   =?ISO-8859-1?Q?S=E9bastien?= Luttringer <seblu@seblu.net>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Date:   Wed, 16 Dec 2020 03:20:37 +0100
In-Reply-To: <CAPhsuW4upOOUq13argQ_0VK0Xwrof7K9vzKO8NjKxL7qPMKtDg@mail.gmail.com>
References: <89d2eb88e6a300631862718024e687fc3102a4e1.camel@seblu.net>
         <CAPhsuW4upOOUq13argQ_0VK0Xwrof7K9vzKO8NjKxL7qPMKtDg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha384";
        protocol="application/pgp-signature"; boundary="=-7QADuM+FMDWMGIQrvfvI"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


--=-7QADuM+FMDWMGIQrvfvI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


On Tue, 2020-12-15 at 15:53 -0800, Song Liu wrote:
> On Tue, Dec 15, 2020 at 10:40 AM S=C3=A9bastien Luttringer <seblu@seblu.n=
et>
> wrote:
>=20
>=20
> Hi,
>=20
> I am very sorry for this problem. This is a bug in 5.10 which is fixed
> in 5.10.1.
> To fix it, please upgrade your kernel to 5.10.1 (or downgrade to previous
> version). In many cases, the array should be back normal. If not, please =
try
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mdadm --grow --size <size> /dev/mdXX=
X.
>=20
> If the original array uses the full disk/partition, you can use "max" for
> <size>
> to safe some calculation.
>=20
> Please let me know if you have future problem with it.

Hello,

The array didn't returned to normal after a reboot on 5.10.1. The `mdadm --=
grow
--size max /dev/md0` command did the trick. The e2fsck detect no error, so =
we
are back online.

Thanks you for your help and especially your quick answer.


S=C3=A9bastien "Seblu" Luttringer


--=-7QADuM+FMDWMGIQrvfvI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iHUEABYJAB0WIQSTtRpKFHmOS6hn0ULluymEcK1OQQUCX9lu9QAKCRDluymEcK1O
QeRuAPkBjKrjRj7KycPvp5qsa9oCYpaLW6qEnnop098ld1LJNgD9F91MDOVrP8aS
XDK+oWoGM2N+BSYFfxWIgI6ISoiiWw0=
=05L8
-----END PGP SIGNATURE-----

--=-7QADuM+FMDWMGIQrvfvI--

