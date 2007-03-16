From: "William L. Thomson Jr." <wltjr@gentoo.org>
Subject: mdadm file system type check
Date: Fri, 16 Mar 2007 19:57:04 -0400
Message-ID: <1174089424.22511.26.camel@wlt.obsidian-studios.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pqXwGbTIElCjwcAO0d0G"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-pqXwGbTIElCjwcAO0d0G
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

To whom it may concern,

	It seems mdadm does not check, warn, abort, or etc if a partition has
an incorrect file system type. This has come up for me on a few
occasions while building servers with software raid. On one occasion I
had a machine fully up and running on raid partitions that were ext3 not
linux auto raid/fd.

	If possible would really be nice if it could do a check for that. Since
one usually has to start over when they discover the problem and go to
correct it. Since raidtools is not deprecated, others migrating from it
on Gentoo are running into it at as well. At the present time mostly
developers. Really would not want users running into it :)

	Anyway if that could be addressed that would be great. Not sure if this
is the right place for this or not. If not please advise, thank you.

--=20
William L. Thomson Jr.
Gentoo/Java

--=-pqXwGbTIElCjwcAO0d0G
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBF+y7QPrChP8zZLyYRAuAVAJ4oYIACkD3el5MQAldH1fkETNsW5wCg3wA+
jhRdzghYVexgrCe7o0uSR3g=
=WdHi
-----END PGP SIGNATURE-----

--=-pqXwGbTIElCjwcAO0d0G--

