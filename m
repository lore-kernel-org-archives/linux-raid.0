From: NeilBrown <neilb@suse.de>
Subject: Re: raid5 reshape is stuck
Date: Wed, 27 May 2015 21:34:49 +1000
Message-ID: <20150527213449.6e017deb@notabene.brown>
References: <1612858661.15347659.1431671671467.JavaMail.zimbra@redhat.com>
	<20150521094837.6a2d29c4@notabene.brown>
	<1552584910.2141570.1432179477679.JavaMail.zimbra@redhat.com>
	<1822959676.2432469.1432211518647.JavaMail.zimbra@redhat.com>
	<20150525135001.43d1083a@notabene.brown>
	<427651758.4121803.1432637303447.JavaMail.zimbra@redhat.com>
	<20150527100253.221ab553@notabene.brown>
	<20150527111004.5f136f23@notabene.brown>
	<2129908770.5092770.1432726084717.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/6J6EJky6zCq6jbFV0o6VZNm"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2129908770.5092770.1432726084717.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/6J6EJky6zCq6jbFV0o6VZNm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 27 May 2015 07:28:04 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:


> [root@intel-waimeabay-hedt-01 mdadm]# cat /usr/lib/systemd/system/mdadm-g=
row-continue\@.service=20
> #  This file is part of mdadm.
> #
> #  mdadm is free software; you can redistribute it and/or modify it
> #  under the terms of the GNU General Public License as published by
> #  the Free Software Foundation; either version 2 of the License, or
> #  (at your option) any later version.
>=20
> [Unit]
> Description=3DManage MD Reshape on /dev/%I
> DefaultDependencies=3Dno
>=20
> [Service]
> ExecStart=3D/usr/sbin/mdadm --grow --continue /dev/%I --backup-file=3D/ro=
ot/tmp0

Please remove the ---backup-file=3D/root/tmp0 for further testing.  The pat=
ch I
provided should make that unnecessary.

> StandardInput=3Dnull
> StandardOutput=3Dnull
> StandardError=3Dnull

Could you try removing these - that might allow error messages to appear.
I wonder why I included them - they shouldn't be needed.

Thanks,
NeilBrown


--Sig_/6J6EJky6zCq6jbFV0o6VZNm
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWWr2Tnsnt1WYoG5AQLyjhAAh534CwXB4j7Dt0MY+ztwcSJqqKDihsnR
Y1skxtgIcXd1g80hEsyXaoaD1oP0QPXIK4HsEuhEclwYsLYHGKvDFXnnQ56sBAhy
qu5K6ch5EFvRiScib1Zbrx1XqbEK6YcsuCZdBksyOPsIyzQQKgyCVRJ58Gi2/LJX
lnasSqyzAuSAYjxV5XVkW+uDmcQ5I1LiZktoTa0fmMezGVvXTCh09lQvhfDV3AOM
LtsVHGw/lxSdowepAQ4TSKGQbNzkhB/K+3lhDvRWUiXJj5C77oyYKuHNRScJoOD0
VPbKiQKzb+SvW7fNP59d9LUUfkdapZn39GF39Gs8Eg7i1GkR5GTjvXZBYQ2gwh9b
mZvyNZBYDT3/68GgZzqmPsnh/cfbSo70nSnG60R7EdrdaG6R5l1kG/I+8+ph+WeI
cB5vuYCpnIxK89v4FA4207HgFX+D0ZYPOWPmUbCjRPIstsBIUPqONUXIUboyFhgD
7afJJFxMKcdkSe25b2d7tMOX779TikPngcjxOHPV+Z7FO6VN01x5zT9Bw6peB0+U
a2Msb7MMaFGAgUM1Nh+n8GP+Cn8At0Jyvb0dfPRp95spgw6vbWkwJ8pZpCWrrHe5
6LLO2tzwYfk00hCbzyuuKUxrAfNBEpVdd7oJ2BYK5e6Oa3ruynPv6sxxhzvfS3Wx
yvMgRXLyQO8=
=mcFV
-----END PGP SIGNATURE-----

--Sig_/6J6EJky6zCq6jbFV0o6VZNm--
