From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
Subject: 32bit variables on >2T arrays
Date: Sun, 3 May 2009 16:13:00 +0200
Message-ID: <20090503141300.GA30773@darkside.22.kls.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello again :)

there seems to be another (minor) 32bit-issue...

md7 : active raid10 sdh1[5] sdg1[3] sdf1[1] sdc1[0] sde1[4] sdd1[2]
      4395406848 blocks 512K chunks 2 near-copies [6/6] [UUUUUU]
      [>....................]  check =3D  0.6% (28034560/4395406848) finish=
=3D4.7min speed=3D254624K/sec
      bitmap: 0/131 pages [0KB], 16384KB chunk

the time-to-finish calculation seems to be quite optimistic :)


Mario
--=20
What I need is an exact list of specific unknown problems we might encounte=
r.
                                -- Manager, Lykes Lines Shipping

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEVAwUBSf2mbBS+e2HeSPbpAQLWhwf+J+gXMMyShjFzVNQb9ojG03R2aAFsYnE3
TcyDiv2Pb0kqpbpSe8ae9T1vID2twskFsQgNDbW+E4QjsrsBYYOL3SpB6oN3qoQh
pGj7VoC91tviGPA3yIQLq6CTG6/fNhaX8TLEbtluHrouwwz/68hufG9j8LiAr7e9
wePpYDG3WnktC57ALxxAc+qJ7qqTyb4/jKbuuTQ3VNkGt59I2vD6jczUymd/zAkD
hbUL8A5vfgSzPSIvbgG0vFNE/BittRVIQBr7Bt050MhfJdUzbFuOj0DOaih8AMRZ
r8wTTMWqjZ4fjhkpcnDeTTEISuS7uXSXte4/rF3iCLpP+Zm9+ludVw==
=LdoE
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
