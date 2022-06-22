Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67B2FC43334
	for <linux-raid@archiver.kernel.org>; Wed, 22 Jun 2022 02:15:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355471AbiFVCPL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 21 Jun 2022 22:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiFVCPK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 21 Jun 2022 22:15:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2113230570
        for <linux-raid@vger.kernel.org>; Tue, 21 Jun 2022 19:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655864107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nAF9uJDAJOO4/FSOAPwbKJV+7udaVeqmZOgkD10CgzU=;
        b=O2C9WxhBn7VG0tJORpBySb2J5OSCr4vfcaau2J/ORGLY+qdIhN17eGAe95pw3TezGgrgTA
        y0cYcGnMEXrWQ9LGzxqka2ctITD6CZBkWR8O1l/oZd12bMreTEPdz9lJTSVQLgl6NpzbiS
        EM1XWqWdrNGE45pLhhHPiUO/3MzwaNU=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-461-LdyNrDV_NoKO5QIHIO0Qvw-1; Tue, 21 Jun 2022 22:15:05 -0400
X-MC-Unique: LdyNrDV_NoKO5QIHIO0Qvw-1
Received: by mail-qv1-f69.google.com with SMTP id kj4-20020a056214528400b0044399a9bb4cso16012102qvb.15
        for <linux-raid@vger.kernel.org>; Tue, 21 Jun 2022 19:15:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:organization:user-agent:mime-version;
        bh=nAF9uJDAJOO4/FSOAPwbKJV+7udaVeqmZOgkD10CgzU=;
        b=SElmjvzCORWVDmHS9j6qTUw2Y1OE7M0BVPjv/RwjB1QPvbvTsZ3HUwbXGztXo20Cj/
         DLRR8JwRfIvytZAHmDV8w/ob2tLoh0K/lu2ibGRf/j7vViGYYUjX9Mv/u7uX+apXa8dZ
         VQf1XUs6wl7wUSc306ST1TLzCymX5kWppAYubaA8WeDyebjWpk4ALTh5SPIaGuuCCqoL
         EGTuEyhGB/+F00ODz+fY82s+DVUkvQVdywHjA7J5qRr5PChNqLcmMmI/0WAWlFNzAKdp
         +7NkeWmft05ixVhO1eqBlcJ2n0ulTKOMyW10sfN6yEHH4L32iqVaz40NOqh7Gsi46aNa
         vN6A==
X-Gm-Message-State: AJIora9B3YeK3Wcjgw32iVRBY4Q3JGQa/3INYwHvPqAMLBzy/QDOhZfA
        bGKWlx+shjvluCQdAICr5Fq2kMP2C7kj0+SGUlMyBs8utg49AhnWJ86N0g032JdxNjV3bbQEnEY
        eioxqHXlxNeV80PMAGwJsxg==
X-Received: by 2002:ac8:5c43:0:b0:315:a78a:4cbe with SMTP id j3-20020ac85c43000000b00315a78a4cbemr1136925qtj.420.1655864105275;
        Tue, 21 Jun 2022 19:15:05 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1syCWBq2aCBZwpnuVMCc5xkyBqS/3fIksvrt4tcxVHLP8kR+W74PlK2W6u7x8mn6dTy1vEVPA==
X-Received: by 2002:ac8:5c43:0:b0:315:a78a:4cbe with SMTP id j3-20020ac85c43000000b00315a78a4cbemr1136915qtj.420.1655864105028;
        Tue, 21 Jun 2022 19:15:05 -0700 (PDT)
Received: from linux-ws.nc.xsintricity.com (104-15-26-233.lightspeed.rlghnc.sbcglobal.net. [104.15.26.233])
        by smtp.gmail.com with ESMTPSA id cp8-20020a05622a420800b00304bc2acc25sm13733106qtb.6.2022.06.21.19.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 19:15:04 -0700 (PDT)
Message-ID: <87cb53c4f08cc7b18010e62b9b3178ed70e06e8d.camel@redhat.com>
Subject: Re: About the md-bitmap behavior
From:   Doug Ledford <dledford@redhat.com>
To:     Wols Lists <antlists@youngman.org.uk>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-raid@vger.kernel.org,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Date:   Tue, 21 Jun 2022 22:15:01 -0400
In-Reply-To: <06365833-bd91-7dcf-4541-f8e15ed3bef2@youngman.org.uk>
References: <d4163d9f-8900-1ec1-ffb8-c3834c512279@gmx.com>
         <63a9cfb7-4999-d902-a7df-278e2ec37593@youngman.org.uk>
         <1704788b-fb7d-b532-4911-238e4f7fd448@gmx.com>
         <06365833-bd91-7dcf-4541-f8e15ed3bef2@youngman.org.uk>
Organization: Red Hat, Inc.
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-3IS5LZq5RI504sawv6lh"
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


--=-3IS5LZq5RI504sawv6lh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2022-06-20 at 10:56 +0100, Wols Lists wrote:
> On 20/06/2022 08:56, Qu Wenruo wrote:
> > > The write-hole has been addressed with journaling already, and
> > > this will
> > > be adding a new and not-needed feature - not saying it wouldn't be
> > > nice
> > > to have, but do we need another way to skin this cat?
> >=20
> > I'm talking about the BTRFS RAID56, not md-raid RAID56, which is a
> > completely different thing.
> >=20
> > Here I'm just trying to understand how the md-bitmap works, so that
> > I
> > can do a proper bitmap for btrfs RAID56.
>=20
> Ah. Okay.
>=20
> Neil Brown is likely to be the best help here as I believe he wrote a=20
> lot of the code, although I don't think he's much involved with md-
> raid=20
> any more.

I can't speak to how it is today, but I know it was *designed* to be
sync flush of the dirty bit setting, then lazy, async write out of the
clear bits.  But, yes, in order for the design to be reliable, you must
flush out the dirty bits before you put writes in flight.

One thing I'm not sure about though, is that MD RAID5/6 uses fixed
stripes.  I thought btrfs, since it was an allocation filesystem, didn't
have to use full stripes?  Am I wrong about that?  Because it would seem
that if your data isn't necessarily in full stripes, then a bitmap might
not work so well since it just marks a range of full stripes as
"possibly dirty, we were writing to them, do a parity resync to make
sure".

In any case, Wols is right, probably want to ping Neil on this.  Might
need to ping him directly though.  Not sure he'll see it just on the
list.

--=20
Doug Ledford <dledford@redhat.com>
=C2=A0=C2=A0=C2=A0=C2=A0GPG KeyID: B826A3330E572FDD
=C2=A0=C2=A0=C2=A0=C2=A0Fingerprint =3D AE6B 1BDA 122B 23B4 265B=C2=A0=C2=
=A01274 B826 A333 0E57 2FDD

--=-3IS5LZq5RI504sawv6lh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAmKyeyUACgkQuCajMw5X
L90rAhAAjdD3Vb062jIe2NEUyJrAyeCHkxDNA20ja8gxSCcuEyrCJQ/NcCaK2gnA
Z1JFxlxfpFf4kb2ZGTYXdA1qbWCwEixHTUV97PodDyfVFIarad0kLZNGmn1ssmyN
Y33aFl/pqbEGmIZq6YHDc7N3zPgTaM6kKWtQtamklz7TFHZCNfBK1H7EDk/jun8Y
q7Dhvgtz1W2OpjYjr49sdo0plNSLTfRj8v1h535mXl1sC1g+YvGONgDmdNmNPn12
f9kbAuSFhVy2FPpbdQlduClAHPjEmLZomEJoy4rr1VOuqir8Yfb0O3s76TDpHs9O
FydAOfvMabTyF6goZpz+hPN2A70TzNVvOyYnygAVjqq7g+Du+1Ug850htFM4xajQ
gsIX2NV9HUbURWxbpLq+x2RD8DsjvO79ezEUtS+wY7szE3U7x6Gb2llpFVLPAb6e
6v7JZ3a49U+zvjJm7hNpisKXE5Y+KwtDyLCmQib+6kG0oSnbSIZCHyZgG4Uejjqz
GLqrj+yqw+YoVZyOumkUaEY7U0Fl+MhEe25+okj3LsHIeDv9n+JNqHlss4Yp91+Y
I3LbmummpNbeEmwrNy7o03bnkbuEsHbSd7GCKm/kP4vAqNPHDyBpatN+Lyi5y/FZ
8P8UTFDZDgHGvsfh7bNvi2ZVCpo9Yhne5LvsURu4hsKALsELeVY=
=lgLm
-----END PGP SIGNATURE-----

--=-3IS5LZq5RI504sawv6lh--

