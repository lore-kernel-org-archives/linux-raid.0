Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33114C4361B
	for <linux-raid@archiver.kernel.org>; Tue, 15 Dec 2020 22:29:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1C8822BE9
	for <linux-raid@archiver.kernel.org>; Tue, 15 Dec 2020 22:29:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730733AbgLOW3w (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Dec 2020 17:29:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730571AbgLOWXh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 15 Dec 2020 17:23:37 -0500
Received: from mail1.84.tech (mail1.84.tech [IPv6:2001:bc8:321a:200:fa7:a55:d1e7:f00d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6353C0617A6
        for <linux-raid@vger.kernel.org>; Tue, 15 Dec 2020 14:22:40 -0800 (PST)
Received: from localhost (localhost [IPv6:::1])
        by mail1.84.tech (Postfix) with ESMTP id 800A450535C;
        Tue, 15 Dec 2020 23:22:39 +0100 (CET)
Received: from mail1.84.tech ([IPv6:::1])
        by localhost (mail1.84.tech [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id pwi1bdxHEE_7; Tue, 15 Dec 2020 23:22:39 +0100 (CET)
Received: from localhost (localhost [IPv6:::1])
        by mail1.84.tech (Postfix) with ESMTP id 33DC9505670;
        Tue, 15 Dec 2020 23:22:39 +0100 (CET)
X-Virus-Scanned: amavisd-new at 84.tech
Received: from mail1.84.tech ([IPv6:::1])
        by localhost (mail1.84.tech [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id FhVqAHYFJrEG; Tue, 15 Dec 2020 23:22:39 +0100 (CET)
Received: from mail.seblu.net (mail.seblu.net [IPv6:2001:bc8:3173:101:bad:cafe:bad:c0de])
        by mail1.84.tech (Postfix) with ESMTPS id 2278250535C;
        Tue, 15 Dec 2020 23:22:39 +0100 (CET)
Received: from localhost (localhost [IPv6:::1])
        by mail.seblu.net (Postfix) with ESMTP id E7BBF52FCB91;
        Tue, 15 Dec 2020 23:22:38 +0100 (CET)
Received: from mail.seblu.net ([IPv6:::1])
        by localhost (mail.seblu.net [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id RRXzrqOgHWlw; Tue, 15 Dec 2020 23:22:38 +0100 (CET)
Received: from localhost (localhost [IPv6:::1])
        by mail.seblu.net (Postfix) with ESMTP id 61D5B53839DF;
        Tue, 15 Dec 2020 23:22:38 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.seblu.net 61D5B53839DF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seblu.net; s=pipa;
        t=1608070958; bh=/zd7Sner6T3xDx5su9MidJdvD7b/9uel6qay+OmGkOM=;
        h=Message-ID:From:To:Date:MIME-Version;
        b=dNFPdx/Th+HMemKUDZ8zPo8PTGAe8IOBXlx1whP6EMLjvTTMkKJu0Wo3KZ56e+gWH
         a2uuUbT02pUs41EVhdpWNZtVQQzQo39AecCwTJcFXrmR5Xft/8GfX6gZ5LEL1IKsX+
         Vl6smBgjTHgMTXMzCXMSaZoV7hf6G3WhuFFCkQPKnAqiIf1HJQCB13cEaPHB/7JlZv
         9GC0D3gnBLRHkpObdFftOlOkgIXLyfak1uO6xeOo0+PHosnp0hoXWOzPr2QAcX8Rg5
         OaFP5a7YIq9E/xrG0ohNfHtIDw9SPkAwmAnN1yMYVx2cFAyQ7A1L9QWWsvvgfUGjZo
         OFrn81Ctao2QQ==
X-Virus-Scanned: amavisd-new at seblu.net
Received: from mail.seblu.net ([IPv6:::1])
        by localhost (mail.seblu.net [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id kt6oPYk8wDln; Tue, 15 Dec 2020 23:22:38 +0100 (CET)
Received: from [IPv6:2a01:e0a:1f8:6b42:be57:b00b:a2e:b19] (unknown [IPv6:2a01:e0a:1f8:6b42:be57:b00b:a2e:b19])
        by mail.seblu.net (Postfix) with ESMTPSA id 3D59352FCB91;
        Tue, 15 Dec 2020 23:22:38 +0100 (CET)
Message-ID: <1368d8f7aee0e49519f8d9ac9c7c156ab25a0e50.camel@seblu.net>
Subject: Re: RE Array size dropped from 40TB to 7TB when upgrading to 5.10
From:   =?ISO-8859-1?Q?S=E9bastien?= Luttringer <seblu@seblu.net>
To:     Ian Kumlien <ian.kumlien@gmail.com>, linux-raid@vger.kernel.org
Date:   Tue, 15 Dec 2020 23:22:37 +0100
In-Reply-To: <CAA85sZt+MV=LY7xCvKqccD_gK35hwSnczPSKenW81rQ3yK7JTA@mail.gmail.com>
References: <CAA85sZt+MV=LY7xCvKqccD_gK35hwSnczPSKenW81rQ3yK7JTA@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha384";
        protocol="application/pgp-signature"; boundary="=-QQcioVIw8En3JS8W1yiA"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


--=-QQcioVIw8En3JS8W1yiA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2020-12-15 at 21:08 +0100, Ian Kumlien wrote:
> the same thing happened to me, but it was a raid6...
With the same kernel (5.10) or an older one?

> Eventually I just gave up and did a:
> mdadm --grow /dev/md3 --size=3Dmax (since it reflects the size it used to=
 be)
This doesn't removed your data?
I wondering if the flag --assume-clean is mandatory to keep the data untouc=
hed.

> After a few hours of syncing, everything was ok again
> (according to btrfs check which also took a few hours =3D))
>=20
> But remember to do this with a 5.0.1 kernel ;)
You mean 5.10?

Regards,

S=C3=A9bastien "Seblu" Luttringer


--=-QQcioVIw8En3JS8W1yiA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iHUEABYJAB0WIQSTtRpKFHmOS6hn0ULluymEcK1OQQUCX9k3LQAKCRDluymEcK1O
Qe3rAPwNiXIJDRdRaMih0t89XfvAE3P7JvNgruRQF/zX9Z5MgAEAjBcQh+siQSr1
xh5uMpQCZ8KVX+sdiUzg+qLRgVaimQs=
=v9gf
-----END PGP SIGNATURE-----

--=-QQcioVIw8En3JS8W1yiA--

