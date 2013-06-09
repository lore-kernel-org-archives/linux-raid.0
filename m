From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Enlarging device of linear array
Date: Sun, 9 Jun 2013 16:47:28 +0600
Message-ID: <20130609164728.6c21a2f6@natsu>
References: <20130608201810.26c19641@hoferr-x61s.hofer.rummelring>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WN9YntZNw+/bfYYLKt=A6Ga"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130608201810.26c19641@hoferr-x61s.hofer.rummelring>
Sender: linux-raid-owner@vger.kernel.org
To: Ramon Hofer <ramonhofer@bluewin.ch>
Cc: linux-raid@vger.kernel.org, Stan Hoeppner <stan@hardwarefreak.com>
List-Id: linux-raid.ids

--Sig_/WN9YntZNw+/bfYYLKt=A6Ga
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 8 Jun 2013 20:18:10 +0200
Ramon Hofer <ramonhofer@bluewin.ch> wrote:

> My home server with a linear raid (md0) containing three raid5 (md1,
> md2, md3) is still working wonderfully. Thanks again Stan!
>=20
> Now I'm planning to add a fourth raid5 to the linear array.

You should have used LVM instead of md linear to join your RAIDs into a sin=
gle
block device. LVM allows placing a single logical volume over physical exte=
nts
placed in all sorts of non-contiguous, fragmented, overlapping fashions. You
could also transparently migrate portions of those physical extents between
physical arrays without even having to unmount the filesystem that you have=
 on
the LV.

--=20
With respect,
Roman

--Sig_/WN9YntZNw+/bfYYLKt=A6Ga
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlG0XUAACgkQTLKSvz+PZwgv3gCdGqyLnRJQhOi9TsBdISRkzrpD
h/4An0ZGLBH0Mk5q3dcn1hgRLCBn8LGo
=QBTt
-----END PGP SIGNATURE-----

--Sig_/WN9YntZNw+/bfYYLKt=A6Ga--
