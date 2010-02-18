From: martin f krafft <madduck@madduck.net>
Subject: Re: (boot time consequences of) Linux mdadm superblock question.
Date: Thu, 18 Feb 2010 17:40:04 +1300
Message-ID: <20100218044004.GC5136@lapse.rw.madduck.net>
References: <201002140251.59668.volkerarmin@googlemail.com>
 <alpine.DEB.2.00.1002170932010.4721@asgard.lang.hm>
 <20100217181016.GA14983@emergent.ellipticsemi.com>
 <201002171927.07051.volkerarmin@googlemail.com>
 <20100217183703.GA15446@emergent.ellipticsemi.com>
 <alpine.DEB.2.00.1002171040350.4721@asgard.lang.hm>
 <20100218102407.49f73d67@notabene.brown>
 <20100218025809.GA20358@khazad-dum.debian.net>
 <20100218032610.GB1991@lapse.rw.madduck.net>
 <1266465801.11568.183.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-ripemd160;
	protocol="application/pgp-signature"; boundary="yNb1oOkm5a9FJOVX"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1266465801.11568.183.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Reurich <daniel@centurion.net.nz>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--yNb1oOkm5a9FJOVX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Daniel Reurich <daniel@centurion.net.nz> [2010.02.18.1703 +1300=
]:
> > Debian experimental. But so far, I was unable to get rid of
> > mdadm.conf because it only works without the info in that file if
> > the homehost is correctly encoded in the metadata. So the challenge
> > I am facing is http://bugs.debian.org/567468.
>=20
> Why not use an installation generated uuid like that of the root
> filesystem for the homehost identifier.  It's less likely to change then
> just about any other system identifier.

This is a great idea. While I would still have to store that UUID in
the initrd, as you say, it's 99% likely to remain constant, and when
it changes, it's 99% likely that the admin is doing something that
will require more work, so we can resort to 100% hoping that s/he
knows what she's doing.

Neil?

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
"when a woman marries again it is because she detested her first husband.
 when a man marries again it is because he adored his first wife.
 women try their luck; men risk theirs."
                                                        -- oscar wilde
=20
spamtraps: madduck.bogus@madduck.net

--yNb1oOkm5a9FJOVX
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEUEAREDAAYFAkt8xKQACgkQIgvIgzMMSnVjjwCY6yzpa0tPEVbSmxSMV/2yWMsA
OgCeKoKM7axzK8wVgqh0e4IQVz4supk=
=I9GP
-----END PGP SIGNATURE-----

--yNb1oOkm5a9FJOVX--
