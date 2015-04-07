From: NeilBrown <neilb@suse.de>
Subject: Re: openSUSE 13.2: md - Need advice which raid1 super format
 (1.0/1.2) is preferred
Date: Tue, 7 Apr 2015 11:14:29 +1000
Message-ID: <20150407111429.670b925a@notabene.brown>
References: <309b2c5704621339acbe84a19d84f766@mail.ud03.udmedia.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/zjwN=z/hKxaU0AZ6mT3nZ=E"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <309b2c5704621339acbe84a19d84f766@mail.ud03.udmedia.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dieter =?UTF-8?B?TsO8dHplbA==?= <Dieter@nuetzel-hh.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/zjwN=z/hKxaU0AZ6mT3nZ=E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 01 Apr 2015 01:55:18 +0200 Dieter N=C3=BCtzel <Dieter@nuetzel-hh.de=
> wrote:

> Hello List,
>=20
> I need advice from the 'gurus' which raid1 md super format (1.0 or 1.2)=20
> is preferred for SSD/'old' SATA disks.

It depends on what you want.

If you want the filesystem in the partition to be visible without configuri=
ng
RAID, then 1.0.
If you explicitly don't.  i.e. you don't see the filesystem until you
assemble the raid1, then 1.2.

Personally, I prefer 1.2, but your needs might be different.

If you boot off the raid1 array, then your boot loader might have a
preference.

NeilBrown


>=20
> Currently I have this on my gfx devel machine (Xeon X3430):
>=20
> cat /=E2=81=A0proc/=E2=81=A0mdstat
> Personalities : [raid1]
> md2 : active raid1 sdc1[0] sdd1[1]
>        156288896 blocks super 1.0 [2/=E2=81=A02] [UU]
>        bitmap: 0/=E2=81=A02 pages [0KB], 65536KB chunk
>=20
> md1 : active raid1 sdb2[1] sda2[0]
>        60391744 blocks super 1.2 [2/=E2=81=A02] [UU]
>=20
> md0 : active raid1 sdb1[1] sda1[0]
>        2095104 blocks super 1.2 [2/=E2=81=A02] [UU]
>=20
> unused devices: <none>
>=20
> md0 and md1
> are on my SSD's which I've created by 'hand' (with mdadm) under openSUSE=
=20
> 13.2.
>=20
> md2
> is on my SATAs which I've created 'automatically' under yast2.
>=20
> My question to you is:
> Looks this sane (chunk only for super 1.0 on real SATAs and super 1.2 on=
=20
> SSDs) or should I change anything, here.
>=20
> I'll nuke md0 (swap) and merge it with md1 (root) 'cause I've upgraded=20
> my RAM from 4 GB to 16 GB (soon to 24/32 GB max) and do not need swap=20
> anylonger.
>=20
> Any hints?
>=20
> -=E2=81=A0Dieter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/zjwN=z/hKxaU0AZ6mT3nZ=E
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVSMvdjnsnt1WYoG5AQIx0w//Tpz0RXm1o5O+7b/EpyIP7IR/EPKOPr3u
rYX0cku+PWBXCfTDX+hwFwpGWw9nakhx0s1hajv9vfb5IF8cAdMnxjlPyOQoi0Nh
TCb6cF98ZJPUFYMzRpN8tA93PYz4Xdg0+H7Kt/qYNbcB+TKy54Be8i90pvhwFRky
PtVXvcnklPnEENthtzkfGWMoXBSe2HWHAe6eiQ5h7afFDfKUSrKKjT7LQFXfre1Z
m9Byk41bODe9uy5/90pCHYfH5rrIIVcnBvsumjk+shcZV1WtXM3Sx4Pq322b2jVB
uZeYEP8K+KpedV37il3SH0zF3VzpP+ZE6jqIvlupLlVzbXNBmL6Wy2Fw8WOO9Cuq
/KBGXD2TLITrByPEUNXNKHsXJT6u7/8c1j9Xymv9/JI6EvlWYAyyHHpLwxbuCLSB
yz8TM59lQ32V+tum7akfJ+FJ9gFXQRGCrx9c9Baw9GUcTlru/MWGNLppigDI19b8
m3lUdQJn6qj54cD+47W1NxNcZSO5xttn4VBDU7fdy+y2Wl49+PwPaFsvDCAuKLJI
qS6a7OzX9pjTjt1V4wwR6x432us8B+hG/YMONHstIEPLw5le1SxGOGSf2gxGI+cR
E0q/anSoI+ek+8giblYhaqVQ/0f1bS/vDXqQGaVhystTuwALbEo1TYH4tjJzb+9R
/UFt/CsNQhc=
=GJV6
-----END PGP SIGNATURE-----

--Sig_/zjwN=z/hKxaU0AZ6mT3nZ=E--
