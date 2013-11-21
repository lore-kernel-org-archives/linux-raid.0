From: NeilBrown <neilb@suse.de>
Subject: Re: unused space before data offset mismatch
Date: Thu, 21 Nov 2013 14:33:30 +1100
Message-ID: <20131121143330.326f8d45@notabene.brown>
References: <528D118D.7090800@web.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6gZATOMTFO9lV=Mx_VddFa3"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <528D118D.7090800@web.de>
Sender: linux-raid-owner@vger.kernel.org
To: kustep <kustep@web.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/6gZATOMTFO9lV=Mx_VddFa3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 20 Nov 2013 20:46:21 +0100 kustep <kustep@web.de> wrote:

> Hello Everyone,
>=20
> is there an option to specifiy the "Unused Space : before=3D...."
> Superblock information in mdadm -C ....?

 --data-offset=3D....

or=20
  --data-offset=3Dvariable ... /dev/foo:16K  /dev/foo2:32K ....

You probably need mdadm 3.3.

NeilBrown

>=20
> My Raid crashed due to a controller error, but I was able to make the
> new superblock almost identical to the old one (using mdadm -C
> --assume-clean --level=3D6 --raid-devices=3D11 --chunk=3D256K --metadata=
=3D1.2
> --bitmap=3DNone --size=3D195328588 --data-offset=3D128768 /dev/md0
> /dev/mapper/disk[cdefmbjkh] missing). Looking at mdadm --examine the
> only difference left is:
> old layout: Unused Space : before=3D257456 sectors, after=3D197632 sectors
> new layout: Unused Space : before=3D257448 sectors, after=3D197632 sectors
>=20
> Is there an option to change that or anything else I can do to make the
> layouts identical? The assembled raid refuses to mount, and I suspect
> this difference to be the reason.
>=20
> Thanks in advance
> Stephan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/6gZATOMTFO9lV=Mx_VddFa3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUo1/Cjnsnt1WYoG5AQLMKBAAkmUwMVCAD0OeyBCdwFPulDBEhHKQ4Aze
TO7rmbrrhbDqcn7yE8usN+x40NpRaBUHh4qzynixK05z8gXHb/QzWWpJ5yZo5HPj
r8fYUo0T7BOb6sTwQqfsOCRVHh+WVUcfZrtRaRO+JvKJvxWoHof44U2N/lvswHU6
pTUR7Z1lx4eYg/FNymNGiqTuLt9nSfzdj2wRkmULMzi3JYhfHHD6C/1tZ/kFmUdC
nh7zq2mSTofOS28zkoP3AuWDhHaHGRV/SKOkqB+bO1/8DXeKr//uoXM5qtrMWtGU
LkHxdASnDFSmOajl5wZfcYKXtjyPh8ar/GEuEY1A4BP7PK6hh2CbQ7ArD/tG/hdq
Q4aKeL78vYKygmGqX+MuVSAtPA3oxOzOcHmm602nIQGpVX/OlFxuRSD4tIYzRuSQ
qlO6+iBgQMGMsu/nFtSM+xFl9cmMgnjJgGd3dr+6S0PLzr05i9mCnLWl1pbALVuF
msIGqgOUKCCdSAJZSFJ56x3+I5iJDNC6gDNJxEu05nQr7lLJCTH2OT5Yx6fXj22u
ukiqNAYypZrniVxlZqn7AayrBXGMWz0by0usvf2Ba101s62r1BAZhVWXYh4m0wi6
+WJeWg/ModTdwsY4fr4uhW5XrtSSoMZAi/bXosdlWBdWLzy38W8o44OE4d5UswRG
c5xyWBmDzQc=
=W8AT
-----END PGP SIGNATURE-----

--Sig_/6gZATOMTFO9lV=Mx_VddFa3--
