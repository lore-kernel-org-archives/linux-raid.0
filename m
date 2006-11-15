From: martin f krafft <madduck@madduck.net>
Subject: why not make everything partitionable?
Date: Wed, 15 Nov 2006 18:22:34 +0100
Message-ID: <20061115172234.GA32276@piper.oerlikon.madduck.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

you cannot create partitions within partitions, but you can well use
whole disks for a filesystem without any partitions.

Along the same lines, I wonder why md/mdadm distinguish between
partitionable and non-partitionable in the first place. Why isn't
everything partitionable?

Thanks for any explanation(s)!

--=20
martin;              (greetings from the heart of the sun.)
  \____ echo mailto: !#^."<*>"|tr "<*> mailto:" net@madduck
=20
spamtraps: madduck.bogus@madduck.net
=20
the reason that every major university
maintains a department of mathematics
is that it's cheaper than
institutionalizing all those people.

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature (GPG/PGP)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFW0zaIgvIgzMMSnURAtrGAJ93q9pK9znR1MzTGVOnD36RDiSDeQCg4GTn
rEkAodECBtKKbSEfyVO/Weg=
=X7za
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
