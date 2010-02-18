From: martin f krafft <madduck@madduck.net>
Subject: Re: (boot time consequences of) Linux mdadm superblock question.
Date: Thu, 18 Feb 2010 18:22:41 +1300
Message-ID: <20100218052241.GB7178@lapse.rw.madduck.net>
References: <20100217181016.GA14983@emergent.ellipticsemi.com>
 <201002171927.07051.volkerarmin@googlemail.com>
 <20100217183703.GA15446@emergent.ellipticsemi.com>
 <alpine.DEB.2.00.1002171040350.4721@asgard.lang.hm>
 <20100218102407.49f73d67@notabene.brown>
 <20100218025809.GA20358@khazad-dum.debian.net>
 <20100218032610.GB1991@lapse.rw.madduck.net>
 <1266465801.11568.183.camel@localhost.localdomain>
 <20100218044004.GC5136@lapse.rw.madduck.net>
 <1266470264.11568.191.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-ripemd160;
	protocol="application/pgp-signature"; boundary="5/uDoXvLw7AC5HRs"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1266470264.11568.191.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Reurich <daniel@centurion.net.nz>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--5/uDoXvLw7AC5HRs
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Daniel Reurich <daniel@centurion.net.nz> [2010.02.18.1817 +1300=
]:
> > This is a great idea. While I would still have to store that UUID in
> > the initrd, as you say, it's 99% likely to remain constant, and when
> > it changes, it's 99% likely that the admin is doing something that
> > will require more work, so we can resort to 100% hoping that s/he
> > knows what she's doing.
>=20
> It'd already be there if they used it in /etc/fstab.  (I wish they would
> as it would solve a whole lot of other media portability problems as
> well, but that's another issue.)

/etc/fstab is not copied into the initrd.

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
"the duration of passion is proportionate
 with the original resistance of the woman."
                                                   -- honor=E9 de balzac
=20
spamtraps: madduck.bogus@madduck.net

--5/uDoXvLw7AC5HRs
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEAREDAAYFAkt8zqAACgkQIgvIgzMMSnUj3gCg1nwD2zxOzY6z3BhnHBqKrczN
ToQAoMneqYaonsDBWxPUNCxA4dy187OG
=WpX+
-----END PGP SIGNATURE-----

--5/uDoXvLw7AC5HRs--
