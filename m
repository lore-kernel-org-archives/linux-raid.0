From: Mike Frysinger <vapier@gentoo.org>
Subject: mdadm: error when using multiple ARRAY <ignore> lines in mdadm.conf
Date: Sun, 11 Nov 2012 03:43:42 -0500
Message-ID: <201211110343.43052.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1647637.gcNIhnlPI6";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--nextPart1647637.gcNIhnlPI6
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

the mdadm.conf documentation indicates that <ignore> is special and can be=
=20
specified multiple times.  unfortunately, that is not the case:
	mdadm: Device <ignore> given twice in config file
	mdadm: Duplicate MD device names in conf file were found.
=2Dmike

--nextPart1647637.gcNIhnlPI6
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJQn2U/AAoJEEFjO5/oN/WBwocP/j9dqMTAM3AUu0dGOT6sVGup
ku0CK2Cl2gORDa5ehToc9teySL9DMDTyFTZjy4XyLIpLf3+Admv3c1YdbmBtZOJS
No8U8/ED6eE1Sn1S5K7sQpzuKxi1y6sLaYPVuVWLBbUBmhy3GRmfcpEvIKQBwq9P
tttLBpQNb5oMqrRny05/3DpC9FhpK7mTEJaxXg/t1S+PbQB5HMyjGl85BuCATMQ8
MwUNTSAJ9L84KDahokHHgAKWaun3rrmUVwcp1HcWotT+HDLqAR/V/zgE881WUlhF
f3sGlElfOvBnEterkc0xG/Dv6SMY8iBw5ht/sUsPywfjiGkvzNZODBcTOc2UIcXm
9IIJ2lx+7C3YaoWtx4f+bppK6G1h1vxmwCzI0+t3mCOu5WnVVtfULrJBFeD2mOdm
Eq/qwlCpM1aFoAvGyj/qpeqa4G9i3WlnW56wgmEV56x7RTh6cVQEvQq4+pg4ZNEZ
lqQRhxwoNYsDgvnh0Av/6lqx72vkJggWju44J0VlJBdR17Ej/8YE4kdGzdZpZ9k6
cBu1ccHB9SnqIFnef0RfKM5/CukVDDbT/rLyTEWyYSOeuFcFAJ6woYBXvnhMcOLX
TsjNqUbotKpsKI2bZJnl8RhoIeBAUZZPfVbzslpbq7astrze4Y0nYEgTOQ5ZKwxG
mi+I8FtUQZE12LS1hGvH
=8VCR
-----END PGP SIGNATURE-----

--nextPart1647637.gcNIhnlPI6--
