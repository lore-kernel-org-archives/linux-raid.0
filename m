From: NeilBrown <neilb@suse.de>
Subject: Re: --assemble --scan --no-degrades assembles+run degraded RAID1?
Date: Sat, 20 Jul 2013 11:51:17 +1000
Message-ID: <20130720115117.52cd203a@notabene.brown>
References: <1374274071.5229.19.camel@fermat.scientia.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/b/ASuF_nufiqMpr4vfSuRnP"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1374274071.5229.19.camel@fermat.scientia.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/b/ASuF_nufiqMpr4vfSuRnP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 20 Jul 2013 00:47:51 +0200 Christoph Anton Mitterer
<calestyo@scientia.net> wrote:

> Hi.
>=20
> This is just some minor thing I've noticed:
>=20
> I intentionally degraded a 2-device RAID1,... and try to auto assemble
> it via:
> --assemble --scan --no-degrade
>=20
> It seems this not only assembles the array but also runs it, at least I
> can write to the /dev/md/foo file.
>=20
> I'd have expected that this does not work... but it does...
>=20
>=20
> Did I get anything wrong here?

"--no-degraded" is a slight misnomer.  It should be
 "--no-degraded-unless-known-to-be-degraded".

The case that it stops is when you shut down the array with the array worki=
ng
perfectly, remove a drive, the try to start the array up again.
In this case the array doesn't know that it is degraded, so "--no-degraded"
will stop it from being assembled.

This is useful when device discovery is slow or unreliable.

NeilBrown


>=20
>=20
> Cheers,
> Chris.


--Sig_/b/ASuF_nufiqMpr4vfSuRnP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUentFTnsnt1WYoG5AQIxVQ//RTcr+8SPiPS64tBkCSeatn7JGG5OFDr4
yW6CkJQRLrw/WBME9dWH67czp1KCjZnomkm1wYfqBGszHWVvPOVD2XGRLE3bDVA0
E21WILqkOhWf/tkb/UqRMrOLa3j+QXKmC6bsbig8TYBH6C5h1x2ADDbX1tTpzGrA
j2KoPApkncrn1WyMfHQgiDQZ2Bj4pKZh68Bw+7/Pk/PS5stud3IdQSt0XXNIyj+X
ThnwUybQuZlZ8VUQjpcLFJ0AjBNTqAO8pQf5p34kj5R/N5UJqzyBi/X1HuPpiSpX
9uaSPq2hsU+cPj31587IWT3p2dgmR/dPBkhQ/5fVcbJqZONxQkjYN7N4TzttcKX4
lgfYwMVq/sSIS/tKxaq6djnSxfTN5cBn8AqX6hqywEAmuH9FJ4tvPn3ZiYcMyu+r
cAB4cKNPuww6iQxsqZIDyPZUcBwaNJlZWxvZ2M5d5cUVrF0Yu8i98Az5e0XlvPv2
BZFmBRGHawOZip8AJCeqHPyBrVQ+R7PKrj6H6ptUu5A/9Xqwuf2KlU0hv2ounYWM
ejZf8M7xsLvSDo6TQheJ/mG1d3dbkL4pR63GCBkmh1kV6rIKaXKlkRtdkhLD+bVv
sGJItcGJQrHhvse5TI/eZ3KYKyHXNlhEfhVJnuL9o8wHZTRew+eV5IEPdfvVv1xf
KRIrPQSDxzM=
=oFKT
-----END PGP SIGNATURE-----

--Sig_/b/ASuF_nufiqMpr4vfSuRnP--
