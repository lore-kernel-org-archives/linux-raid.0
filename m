From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: Write-intent bitmap decreases or increase performance of RAID5?
Date: Wed, 30 Jun 2010 14:23:28 +0600
Message-ID: <20100630142328.6451f910@natsu>
References: <20100629201153.GA13018@localhost>
	<20100630111854.006ec4d0@natsu>
	<alpine.DEB.1.10.1006300729150.8623@uplift.swm.pp.se>
	<20100630115927.090751dd@natsu>
	<alpine.DEB.1.10.1006300857300.8623@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/p7C.tAJtqP7o7HvzsSqMpm2"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1006300857300.8623@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Shaochun Wang <scwang@ios.ac.cn>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/p7C.tAJtqP7o7HvzsSqMpm2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Jun 2010 08:58:28 +0200 (CEST)
Mikael Abrahamsson <swmike@swm.pp.se> wrote:

> On Wed, 30 Jun 2010, Roman Mamedov wrote:
>=20
> > This is not necessary. See the dd man page about the conv=3Dfdatasync s=
witch.
> > You can even test with just 256 MB this way, and still get an extremely
> > accurate result.
>=20
> You're right, for writing this is ok. For read tests it's important to us=
e=20
> more than ram though, to avoid doing performance testing from block cache=
=20
> instead of from the actual drives.

Yeah, though there's also an alternative way of mitigating the effect of
the cache when testing read speed, see http://linux-mm.org/Drop_Caches

--=20
With respect,
Roman

--Sig_/p7C.tAJtqP7o7HvzsSqMpm2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwq/wAACgkQTLKSvz+PZwivlQCeJRy8PWiUw+Snq+uhkW9e+wOM
4qsAn0zirsmYAIr4a+aptN4IAduoMfDu
=U1zb
-----END PGP SIGNATURE-----

--Sig_/p7C.tAJtqP7o7HvzsSqMpm2--
