Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 901ABC4338F
	for <linux-raid@archiver.kernel.org>; Wed, 18 Aug 2021 19:59:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C553610A5
	for <linux-raid@archiver.kernel.org>; Wed, 18 Aug 2021 19:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbhHRT7p (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 18 Aug 2021 15:59:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43984 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233262AbhHRT7o (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 18 Aug 2021 15:59:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629316749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f1SzR9yKYaeM3AbxBrXTUWtf4gta2BIlzl2nMTkdH8s=;
        b=AR4gNE3bZTyVwuwZlIZ+Ob49H5ts+9K0NJ/g0GVPVbNw1poxB2W6gaIPj2XTGjQgZ4ZJjY
        dH5+76RFz5p+vSi4xpZ7hR8aKHVW5FdDkAi2/Y5RyFRFx6TPBKJKdIqojHduQosB93J6pW
        0BnL25rtrQB+iL5WqVO04RaajmDN318=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-S4z4nzYLPIa-ze8hXzSYfA-1; Wed, 18 Aug 2021 15:59:07 -0400
X-MC-Unique: S4z4nzYLPIa-ze8hXzSYfA-1
Received: by mail-qt1-f199.google.com with SMTP id m8-20020a05622a0548b029028e6910f18aso1507238qtx.4
        for <linux-raid@vger.kernel.org>; Wed, 18 Aug 2021 12:59:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:organization:user-agent:mime-version;
        bh=f1SzR9yKYaeM3AbxBrXTUWtf4gta2BIlzl2nMTkdH8s=;
        b=JpzxdU5P2ZpbpnD6KDiTZzg9Ov64ZZwPr/O4N9iPDSMnYoOpQlJB6kS1hwkKFMkwNw
         WjwUtLdfI/uANLYOpdv3ZFyeJzAPoRJDvA77OmYyenxBXpsGIUSznCASnvAkjARobSjr
         ywXeElV760AMbivFILLxP1bH1pWJLgql0QaGIQP8yrP+lu4xG537fFr9gvLkCrxLQp7/
         wwk/08u2ejlLp58hM5ILqPs2mSi3mixIXJ/bmOMGjzvnP33siMkjTS+c20WMag6HwsGX
         h/mBLvPqEUwGLysY1K5wdsLrpYxMtiVCEl6MDYbjiDk3D4JehVLK9j/asOpl8U4S/bp9
         1Wvg==
X-Gm-Message-State: AOAM532whSINLNDW0M++sN43199F04CkDVhIFpageLVA6fMwTL3NhIb6
        q6CuOGzo9vQmpXfqcYckCt0W3Qa9dya9H2EzLYl2pEWQRx6b4kzCYuakGQ5y+STuu2sivrCwRWx
        r2J7Tn6QK+YywSdB82CKN9w==
X-Received: by 2002:a05:622a:5d3:: with SMTP id d19mr9371754qtb.211.1629316747061;
        Wed, 18 Aug 2021 12:59:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxvr3pXAtZaR/z16isZ16ELYZJgDW9fB5kNKUzF8h/y7eStJDDF5ocAQzL7uzSCdKeUEzZ4PQ==
X-Received: by 2002:a05:622a:5d3:: with SMTP id d19mr9371744qtb.211.1629316746900;
        Wed, 18 Aug 2021 12:59:06 -0700 (PDT)
Received: from linux-ws.nc.xsintricity.com (104-15-26-233.lightspeed.rlghnc.sbcglobal.net. [104.15.26.233])
        by smtp.gmail.com with ESMTPSA id 19sm213832qkf.127.2021.08.18.12.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 12:59:06 -0700 (PDT)
Message-ID: <aa5c7b6aa143ca75c0d5840af1700b1a85b05efd.camel@redhat.com>
Subject: Re: [Non-DoD Source] Can't get RAID5/RAID6 NVMe randomread IOPS -
 AMD ROME what am I missing?????
From:   Doug Ledford <dledford@redhat.com>
To:     "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>,
        'Matt Wallis' <mattw@madmonks.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Date:   Wed, 18 Aug 2021 15:59:04 -0400
In-Reply-To: <5EAED86C53DED2479E3E145969315A238585E1AD@UMECHPA7B.easf.csd.disa.mil>
References: <5EAED86C53DED2479E3E145969315A2385841062@UMECHPA7B.easf.csd.disa.mil>
         <AS8PR04MB799205817C4647DAC740DE9A91EA9@AS8PR04MB7992.eurprd04.prod.outlook.com>
         <5EAED86C53DED2479E3E145969315A2385856AD0@UMECHPA7B.easf.csd.disa.mil>
         <5EAED86C53DED2479E3E145969315A2385856AF7@UMECHPA7B.easf.csd.disa.mil>
         <5EAED86C53DED2479E3E145969315A2385856B25@UMECHPA7B.easf.csd.disa.mil>
         <5EAED86C53DED2479E3E145969315A2385856B62@UMECHPA7B.easf.csd.disa.mil>
         <5EAED86C53DED2479E3E145969315A2385856B85@UMECHPA7B.easf.csd.disa.mil>
         <20210808174331.1e444db9@gofri-dell>
         <5EAED86C53DED2479E3E145969315A2385857258@UMECHPA7B.easf.csd.disa.mil>
         <5EAED86C53DED2479E3E145969315A238585E0EF@UMECHPA7B.easf.csd.disa.mil>
         <300042B9-F46F-42CF-8FD7-F1C2FE0965E5@madmonks.org>
         <5EAED86C53DED2479E3E145969315A238585E1AD@UMECHPA7B.easf.csd.disa.mil>
Organization: Red Hat, Inc.
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-TPkqY/ZNqj5svmPVonKi"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


--=-TPkqY/ZNqj5svmPVonKi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> > The question I have for the list, given my large drive sizes, it
> > takes me a day to set up and build an mdraid/lvm configuration.=C2=A0=
=C2=A0=C2=A0
> > Has anybody found the "sweet spot" for how many partitions per
> > drive?=C2=A0=C2=A0=C2=A0 I now have a script to generate the drive part=
itions, a
> > script for building the mdraid volumes, and a procedure for
> > unwinding from all of this and starting again.=C2=A0=C2=A0=C2=A0=20

I don't have a feeling for the sweet spot on the number of partitions,
but if you put too many devices in a raid5/6 array, you virtually
guarantee all writes will have to be read-modify-write writes instead of
full stripe writes.

So, when dealing with keeping the parity on the array in sync, a full
stripe write allows you to simply write all blocks in the stripe,
calculate the parity as you do so, and then write the parity out.  For a
partial stripe write, you either have to read in the blocks you aren't
writing and then treat it as a full stripe write and calculate the
parity, or you have to read in the blocks being written and the current
parity block, xor the blocks being over written out of the existing
parity block and then xor the blocks you are writing over the old ones
into the parity block, then write the new blocks and new parity out.

For that reason, I usually try to keep my arrays to no more than 7 or 8
members.  A lot of times, for streaming testing, really high numbers of
drives in a parity raid array will seem to perform fine, but when under
real world conditions might not do so well.  There are also several
filesystems that will optimize their metadata layout when put on an
mdraid device (xfs and ext4), but I'm pretty sure that gets blocked when
you put lvm between the filesystem and the mdraid device.

--=20
Doug Ledford <dledford@redhat.com>
=C2=A0=C2=A0=C2=A0=C2=A0GPG KeyID: B826A3330E572FDD
=C2=A0=C2=A0=C2=A0=C2=A0Fingerprint =3D AE6B 1BDA 122B 23B4 265B=C2=A0=C2=
=A01274 B826 A333 0E57 2FDD

--=-TPkqY/ZNqj5svmPVonKi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAmEdZogACgkQuCajMw5X
L93+Dw//b8AVF0yDhUIjhLLPZOr0gVLXRkWfWWitaCC8N+HkiRC6/eExPiU7a4Ma
Cd7etXuKZwi0l+qr7AubYJk8Dkpfg8nAce4VhVZH/ayNx4xJHtPPCAGnS/5solGQ
uyNHxEJ8zoUT35TTj1YQc3nIqYZazAp4/7elhk0rylV6OEoWlGl8+ciMKPeOpm83
wjVcZ0hA8VseCuVk92QpAjvA2pROSjr15ZhifaqYI7OEThaWdWloEjLQ3owVKeEK
niqJOzU3Y272irHXQSlh2y0iWPXtFTvxokylVVXkGR6lo9ho1MqGm8qKSJolwaLH
2G99i5hk0J2GdcQGLG61fC0UAdUjO8cPcOJwhECeFyGKPn6BSk7zVijwogmQ5eu7
0Fb9cIOxNHves3g6RGzfvpuLc3Tu9gnAf2bcfZxgvVHUh+cM5z9dITlP7/o0srRj
uczfetZiSlvVZYqNcG74gXm+66NEMv87BH8OE0CfYmOYMoFow2TrQTp5BzsAFvFq
wZwZhptgnSfJkZAU6cBAjyBA7gR4wZKD0Q98YLWbn4VU4wDnnwibFJ0mAJ3lOREU
a/5Lfim4jxcFxnDeW1hsWFYvaFwsBylnOHe0iWwkLwcIbAtDHtQBtU2WYNqs9c9k
NvonD6dcpovxyxjLOBl5+H2fWAAOTR/XLbx6GXdoeJOlWxcpfi0=
=A3xu
-----END PGP SIGNATURE-----

--=-TPkqY/ZNqj5svmPVonKi--

