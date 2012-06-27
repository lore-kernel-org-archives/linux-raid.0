From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/2] Modify read error handle for RAID-4,5,6.
Date: Wed, 27 Jun 2012 14:32:28 +1000
Message-ID: <20120627143228.21ee4baa@notabene.brown>
References: <201205261052422815923@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/j0a_i1aJG_jCqqbs=TUyfGj"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201205261052422815923@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/j0a_i1aJG_jCqqbs=TUyfGj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 26 May 2012 10:52:50 +0800 "majianpeng" <majianpeng@gmail.com> wrot=
e:

> When RAID-4,5,6 degraded and met read-error, it will eject the rdev.And t=
hen
> the RAID will fail and lost data.Because the function of set-badsector,wh=
en=20
> this occur,it will set-badsector,not ejecting the rdev.
> When RAID-4,5,6 met read-error, it will re-write if RAID was not degrade.=
But if=20
> re-write error,it will eject the rdev and RAID will degrade and it will t=
ake too
> long time for recoverying.So I add judgement for controling how may re-wr=
ite-error
> can eject the rdev.
>=20
> I do those for flexible controling the read-error for different situation.
> =09

Thanks.

>=20
> majianpeng (2):
>   md/raid456: When readed error and raid was degraded,it try to
>     set badsector, not ejecting the rdev.

I've applied this one.  I also added 'set_bad =3D 1' in the case where
the re-write failed.

>   md/raid456:Add interface for contorling eject rdev when re-write
>     failed.

I haven't applied this.  I'm not entirely sure what the point of counting
the errors was, but I don't think it is necessary.

Thanks,
NeilBrown


>=20
>  drivers/md/md.c    |   35 +++++++++++++++++++++++++++++++++++
>  drivers/md/md.h    |    2 ++
>  drivers/md/raid5.c |   28 +++++++++++++++++++---------
>  3 files changed, 56 insertions(+), 9 deletions(-)
>=20


--Sig_/j0a_i1aJG_jCqqbs=TUyfGj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+qM3Dnsnt1WYoG5AQKffA/+JwQ0TAZZXZ4+mjXG7TSGCkqmLomhotCT
z0gfi+8KHFaxvyAamIeeJlsRAl+9iT2sDyZ2Ja1FfZsXKnCEtATMbZJQPUvmm4Fy
6QZ558gttw+oqQh9bvb4eBQbckBjDAd8KAM7CmW1zwefgO70eOWxObDzVapL3vsW
q0WcG9i9OI0LyuHL9NOKj/VWSfd2ChVGBk7FArwlaQ4naHlVL0YjPWhfO0dNA1eN
sJaT8tVk/FiDl3+VOK1/K4mHZuDsF4gORltr4mB80zTpi+zdeiXVTFsFD2OC1pL2
Rgy/rVqD1d8Ljx5NCrl2ZXid+BvFzgcQp/0Jad6UKxnTzGYjovY7Kj9dEYNphhV2
hzqX+va+Z3vrHeSxGAlmSorwjUYn25sPNpjCtN/c3iK7aSuwl5DbqMtMb0YklhKn
it4e5JUf7cgmS/tzSgPbkYrDLaATRlxmL1g8XBlyFe/zC7iTNvyalKsqpgPq7KzH
ktX/B5kuvHdN4CDdVKsB/z5ISWRXx6HAP0KfkxD0oMZ85RiFkjT60D0wQzGWRTg4
8b2iU5uWLvtRVt60JQXB0lUYozk7odIrE/NL5HaalB5xNG8ETXwsOqQYeEKYQP7w
japa4x84XTudMig2kvlObL5+TojAXSUwMQzBLd2TC+KEaEdWD+X4gqOrcSD4gfmS
B0IKtt7qTYw=
=HvlO
-----END PGP SIGNATURE-----

--Sig_/j0a_i1aJG_jCqqbs=TUyfGj--
