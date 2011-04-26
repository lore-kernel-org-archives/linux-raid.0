From: Tobias Powalowski <t.powa@gmx.de>
Subject: mdadm 3.2.1 doesn't compile with gcc 4.6.0
Date: Tue, 26 Apr 2011 09:00:17 +0200
Message-ID: <201104260900.20791.t.powa@gmx.de>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2127035.D4yJT9B19a";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

--nextPart2127035.D4yJT9B19a
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi guys,
mdadm.c:106:6: error: variable 'auto_update_home' set but not used [-
Werror=3Dunused-but-set-variable]


any help would be much appreciated.
thanks
greetings
tpowa
=2D-=20
Tobias Powalowski
Archlinux Developer & Package Maintainer (tpowa)
http://www.archlinux.org
tpowa@archlinux.org

--nextPart2127035.D4yJT9B19a
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk22bYEACgkQ81yYyRqLOvj/mQCeLSW5G6ICJV8fGX/OKG5I646J
GAIAn0IUHAcXlCs4TXVoiBF7ZaQiSXjv
=zmZi
-----END PGP SIGNATURE-----

--nextPart2127035.D4yJT9B19a--
