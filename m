From: Ming Zhang <mingz@ele.uri.edu>
Subject: fast build raid5
Date: Wed, 29 Jun 2005 13:52:46 -0400
Message-ID: <1120067566.7414.64.camel@localhost.localdomain>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JnyPw6+p7Z0ATNcmymyB"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-JnyPw6+p7Z0ATNcmymyB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I have 5 new disks and I want to build a raid5.

I am think which one is the better method.

1) build normally, so raid will do reconstruction and i probably want to
wait till it ends

2) zero all disks using dd. then build a raid without need to computer
checksum at all since 0xor0=3D0.=20

in fact, i am thinking which mdadm command can allow me to do (2)


Ming


--=-JnyPw6+p7Z0ATNcmymyB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBCwt/uSYbkL5BnVYoRAsF2AJ4w2JJKhKGkLb98zqLdmLQai0YoZwCfRSkq
5VeXPSN22394PwUGjj/Ciyw=
=mP86
-----END PGP SIGNATURE-----

--=-JnyPw6+p7Z0ATNcmymyB--

