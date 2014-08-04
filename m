From: NeilBrown <neilb@suse.de>
Subject: Re: On URE and RAID rebuild - again!
Date: Mon, 4 Aug 2014 17:13:29 +1000
Message-ID: <20140804171329.4b47ed8e@notabene.brown>
References: <53D8ACF0.1070202@assyoma.it>
	<alpine.DEB.2.02.1407301310100.7929@uplift.swm.pp.se>
	<53D8ED99.90606@assyoma.it>
	<20140731073121.38cd1773@notabene.brown>
	<53D9ED48.9000307@assyoma.it>
	<1370eb7a35b628323646a86094a26912@assyoma.it>
	<20140803134834.7773b0ab@notabene.brown>
	<alpine.DEB.2.02.1408040858220.7929@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/VpQoZSHrWKrIECgwCUVnchj"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1408040858220.7929@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Gionatan Danti <g.danti@assyoma.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/VpQoZSHrWKrIECgwCUVnchj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 4 Aug 2014 09:02:22 +0200 (CEST) Mikael Abrahamsson
<swmike@swm.pp.se> wrote:

> On Sun, 3 Aug 2014, NeilBrown wrote:

> >> 2) how UREs should be visible? Via error reporting through dmesg?
> >
> > If you want to see how the system responds when it hits a URE, you can =
use the
> > hdparm command and the "--make-bad-sector" option.  There is also a
> > "--repair-sector" option which will (hopefully) repair the sector when =
you
> > are done.
>=20
> Does this command do the same as with a real URE, ie will try until the=20
> timeout of the drive (which is what, 90 seconds on a consumer drive, 7=20
> seconds of an enterprise drive, right?).

All I know is what I read in "man hdparm".

NeilBrown

--Sig_/VpQoZSHrWKrIECgwCUVnchj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU98ymTnsnt1WYoG5AQIF5A/+KwkaNVUru5wUbMc/Cc66D5UpfJX1dGSb
Hpqb/H2QFRWHN8Kh/KXq6stJ3CYss9JoDZYIP4XB/RUvr/BdF2oUFDYC3/Os8qei
GX7jaj4jStpbK0fvA/za01YhbRjc9sl4iwHdxOHWiSfu5uZdKS9hR/Ycozi6VznF
aueDrn2lu7WW2xc8P6nDUB7SVAZdy+ONRNQbgV4TTgTrYGa4OsRhSPzWec5LIpOt
zY+MKWdoTUxUOyemy5qx9dE9VW3kDgJEV+JerZ4Gmhnba/VE5DoZDJEu8MY4HFgH
R69+/UajnMYKZYoKdFxTM6Aik+36+KKTNQVFyVtyMceQ5/XxJPIV0wVM5U8j61Do
l9rOGSC/K493gmQCbUPTqj7ABCye9LOyhc59laml2QjoeOLb392DJPUg69LDhj3u
Di6vioFVg8+xHpKRUy6hN/8E43eXvry5+eTXJjktQn1iie1C7j6FBHepcOLUl/Ec
jXMmIjhqs5LLGfuaffwXyJZo/f/O5geafSMDkidndVRsosvyzHb6+s5PCuQU/SRs
Jm0ZBKZTDMp88AvEtw19il/06sTbGsSpzzTMeZy3uhW8GjVMZOOS0IWvmO68tKzI
3iMAvBzzsael+SOTKLm85MUBMA+XG5FzlE+Pk+6e0VFJTlkX20pVcsGL8qgLTerh
51Yx294PIFw=
=q0B2
-----END PGP SIGNATURE-----

--Sig_/VpQoZSHrWKrIECgwCUVnchj--
