From: martin f krafft <madduck@madduck.net>
Subject: Re: mdadm 2.6.3 segfaults on assembly (v1 superblocks)
Date: Sun, 30 Sep 2007 12:37:16 +0100
Message-ID: <20070930113716.GB8924@lapse.madduck.net>
References: <20070907080901.GA16012@piper.oerlikon.madduck.net> <18167.15596.666216.853865@notabene.brown>
Reply-To: 444682@bugs.debian.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bCsyhTFzCvuiizWE"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18167.15596.666216.853865@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--bCsyhTFzCvuiizWE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Neil Brown <neilb@suse.de> [2007.09.24.0528 +0100]:
> Sure could.  Thanks for the report.
>=20
> This patch (already in .git) should fix it.

Apparently it does not, and it seems to be amd64-only since I saw it
on amd64 and a bunch of people reported success on i386:

  http://bugs.debian.org/444682

Any help appreciated. I don't have an amd64 system around for
another three weeks...

--=20
martin;              (greetings from the heart of the sun.)
  \____ echo mailto: !#^."<*>"|tr "<*> mailto:" net@madduck
=20
scientists will study your brain to learn
more about your distant cousin, man.
=20
spamtraps: madduck.bogus@madduck.net

--bCsyhTFzCvuiizWE
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG/4psIgvIgzMMSnURAu82AKDIBTG8vclLeZVSqgFwkUSl6VHz/wCgkT37
4mkWpfOzFeIRq7AazTJvMFI=
=jfmH
-----END PGP SIGNATURE-----

--bCsyhTFzCvuiizWE--
