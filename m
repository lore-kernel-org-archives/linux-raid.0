From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Problem with raid1 read error patch
Date: Mon, 20 Sep 2004 18:14:27 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1095696866.8380.23.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.58.0409201700460.12286@tux.rsn.bth.se>
	 <414EF709.7040505@steeleye.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Zb49rqfpk5B5lpRprXlR"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <414EF709.7040505@steeleye.com>
To: Paul Clements <paul.clements@steeleye.com>
Cc: neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-Zb49rqfpk5B5lpRprXlR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2004-09-20 at 17:28, Paul Clements wrote:

Hi Paul

> > After backing that patch out, with some minor modifications because the
> > code has changed a little bit, I get a number of scsi-errors and after =
a
> > while the drive gets disabled like above but life continues like before
> > the patch went in. That is, no infinite loop and everything works :)
> >=20
> > Any ideas to what went wrong?
>=20
> Yes. You're getting the infinite retries because the BIO_UPTODATE flag=20
> in the bio is not set.

Ah

> I've been debugging the same problem just recently. In addition to this=20
> patch from Neil, you'll also need a patch that I posted here last week,=20
> which does a bio_put() and a bio_clone() to get rid of the old bio that=20
> the read error occurred on, and create a new (clean) bio to retry the=20
> read against:
>=20
> http://marc.theaimsgroup.com/?l=3Dlinux-raid&m=3D109527014728404&w=3D2

Thanks, will try it out tomorrow when I'm back in front of the machine.
Didn't expect an answer so soon :)

--=20
/Martin

--=-Zb49rqfpk5B5lpRprXlR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBBTwHiWm2vlfa207ERAjloAKCxjak5blzpbSrAlaag6jwizA1fTACfdsqw
xpCsOK8eBOTYieEeyEktrTQ=
=6rLd
-----END PGP SIGNATURE-----

--=-Zb49rqfpk5B5lpRprXlR--
