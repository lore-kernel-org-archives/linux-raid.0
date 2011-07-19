From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: data corruption after rebuild
Date: Tue, 19 Jul 2011 23:38:56 +0600
Message-ID: <20110719233856.32334e5b@natsu>
References: <2073005.NH8LALaxuD@bloomfield>
	<20110719211240.2578bba6@natsu>
	<8745665.3py2GtsBIG@bloomfield>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1yR60B0yhe3dT4txqvfizAV"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8745665.3py2GtsBIG@bloomfield>
Sender: linux-raid-owner@vger.kernel.org
To: Pavel Herrmann <morpheus.ibis@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/1yR60B0yhe3dT4txqvfizAV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 19 Jul 2011 18:18:56 +0200
Pavel Herrmann <morpheus.ibis@gmail.com> wrote:

> On Tuesday 19 of July 2011 21:12:40 Roman Mamedov wrote:
> > Hello,
> >=20
> > On Tue, 19 Jul 2011 15:55:35 +0200
> >=20
> > Pavel Herrmann <morpheus.ibis@gmail.com> wrote:
> > > the problem is that the rebuilt array is corrupted. most of the data =
is
> > > fine, but every several MB there is an error (which doesn't look like
> > > being caused by a crash), effectively invalidating all data on the
> > > drive (about 7TB, mainly HD video)
> >=20
> > Which model of SATA controller/HBA do you use?
>=20
> 4 drives on ahci (ICH10R), 4 drives on sata_mv (adaptec 1430SA)

OK, one more guess - any Samsung drives, F4EG? http://sourceforge.net/apps/=
trac/smartmontools/wiki/SamsungF4EGBadBlocks

--=20
With respect,
Roman

--Sig_/1yR60B0yhe3dT4txqvfizAV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4lwTAACgkQTLKSvz+PZwgaBQCgiMP447qps3/+MiO6pQ1litHc
5TIAoIkWEbLNBp68bm2mKw3VpiRcUV1b
=+JwA
-----END PGP SIGNATURE-----

--Sig_/1yR60B0yhe3dT4txqvfizAV--
