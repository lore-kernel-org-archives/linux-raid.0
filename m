From: "Richard F. Rebel" <rrebel@whenu.com>
Subject: Multipath questions...
Date: Fri, 17 Dec 2004 13:02:40 -0500
Message-ID: <1103306560.18363.533.camel@rebel.corp.whenu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mZGNTtN2oP0aI3LEJK6q"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-mZGNTtN2oP0aI3LEJK6q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hello,

I have 4 luns available on two controllers, similtaniously, thus making
the 4 luns visible twice.  I have 4 FCAL connections to multiple
switches, leaving me with 32 scsi devices, only 4 of which are unique.

When I create md's with the multipath option, which one is 'active'??
The first one created?  The first one probed by mdadm when it scans for
them upon boot?

When a path fails, which of the other paths is used?   If the original
path is restored does the traffic fail back to the original path?

Thanks!

--=20
Richard F. Rebel

cat /dev/null > `tty`

--=-mZGNTtN2oP0aI3LEJK6q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBBwx9Ax1ZaISfnBu0RAmgZAJkBM8pmAdS2lHx1MbyH4yboIb7RBwCeKYXV
s2tPi8frojw1HmHoHV1jYlk=
=pUh8
-----END PGP SIGNATURE-----

--=-mZGNTtN2oP0aI3LEJK6q--

