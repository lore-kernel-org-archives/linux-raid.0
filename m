From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: RAID5 with two drive sizes question
Date: Tue, 5 Jun 2012 23:39:53 +0600
Message-ID: <20120605233953.2086cc4c@natsu>
References: <4FCE4199.7030705@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/z_9IU=z8y=LNad/CZ+IGMzu"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FCE4199.7030705@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Joachim Otahal (privat)" <Jou@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/z_9IU=z8y=LNad/CZ+IGMzu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 05 Jun 2012 19:27:53 +0200
"Joachim Otahal (privat)" <Jou@gmx.net> wrote:

> Hi,
> Debian 6.0.4 / superblock 1.2
> sdc1 =3D 1.5 TB
> sdd1 =3D 1.5 TB (cannot be used during --create, contains still data)
> sde1 =3D 1 TB
> sdf1 =3D 1 TB
> sdg1 =3D 1 TB
>=20
> Target: RADI5 with 4.5 TB capacity.
>=20
> The normal case would be:
> mdadm -C /dev/md3 --bitmap=3Dinternal -l 5 -n 5 /dev/sdc1 /dev/sdd1=20
> /dev/sde1 /dev/sdf1 /dev/sdg1
> What I expect: since the first and the second drive are 1.5 TB size the=20
> third fouth and fifth drive are treated like 2*1.5 TB, creating a 4.5 TB=
=20
> RAID.

Lolwhat.

> What would really be created: I know here are people that know and not=20
> guess : ).

5x1TB RAID5. Lowest common device size across all RAID members is utilized =
in
an array.

But what you do after that, is you also create a separate 2x0.5TB RAID1 from
the 1.5TB drives' "tails", and join both arrays into a single larger volume=
 using LVM.

The result: 4.5 TB of usable space, with one-drive-loss tolerance (provided=
 by
RAID5 in the first 4 TB, and by RAID1 in the 0.5TB "tail").

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/z_9IU=z8y=LNad/CZ+IGMzu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/ORGoACgkQTLKSvz+PZwg4xgCglw2NM6gHQS2JmWzPejmB+LG8
JL4AoJC1NrSD7XoVpqTDKQJtecGoNaGe
=Z+ff
-----END PGP SIGNATURE-----

--Sig_/z_9IU=z8y=LNad/CZ+IGMzu--
