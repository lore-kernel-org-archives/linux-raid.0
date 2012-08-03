From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: RAID6 Reshape Gone Awry
Date: Fri, 3 Aug 2012 20:53:30 +0600
Message-ID: <20120803205330.7c5f5172@natsu>
References: <8C493F417CC49C6619BBAF45@ryoohko.kodachi.com>
	<501BB374.9020607@hardwarefreak.com>
	<501BD420.10203@hesbynett.no>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/nLM8k3nNzpgjJEsykLVqe+_"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <501BD420.10203@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: stan@hardwarefreak.com, Flynn <flynn@kodachi.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/nLM8k3nNzpgjJEsykLVqe+_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 03 Aug 2012 15:37:36 +0200
David Brown <david.brown@hesbynett.no> wrote:

> That's not how I understand the disk layout - if I'm right, it is still=20
> a monstrosity, but one that will offer protection on disk failure.
>=20
> As I read it, he has this (prior to adding the new disk):
>=20
> md0 =3D raid6(sda5, sdb5, sdc5, sdd5, sde5)
> md1 =3D raid6(sda6, sdb6, sdc6, sdd6, sde6)
> ...
> md9 =3D raid6(sda14, sdb14, sdc14, sdd14, sde14)
>=20
> If that's the case, then it will be an administrative mess (as the OP is=
=20
> now experiencing), but it will protect the data, and if the LVM is a=20
> linear concatenation of these then performance normally will be okay.=20

If you want the RAID5/6 write performance to be okay, you will want to
increase stripe_cache_size to a good value [1] -- and that's per array, and=
 the
RAM consumption increases linearly with disk count - so on 10 five-member
arrays you won't have anywhere near enough RAM to have a sufficient
stripe_cache on all of them.

In other words, one more aspect in which this multi-array configuration is
highly suboptimal. :)

[1]
http://peterkieser.com/2009/11/29/raid-mdraid-stripe_cache_size-vs-write-tr=
ansfer/

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/nLM8k3nNzpgjJEsykLVqe+_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlAb5eoACgkQTLKSvz+PZwiOYwCfdRS+N5+81afY1UJHCcI9CnYZ
nMgAniuqL4V6Fvm7i955cM7QJYQM3Yy/
=Exqb
-----END PGP SIGNATURE-----

--Sig_/nLM8k3nNzpgjJEsykLVqe+_--
