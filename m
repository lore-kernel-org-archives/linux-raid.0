From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Best practice for setting up "ordinary" RAID
Date: Fri, 11 Oct 2013 09:15:08 +0100
Message-ID: <20131011081508.GA4995@cthulhu.home.robinhill.me.uk>
References: <CAPbD+RckkbYXF4Wpr_yzboJ0B+TBZayf0LbT3f4O3xQ-JN3gaA@mail.gmail.com>
 <alpine.DEB.2.02.1310110827350.20065@uplift.swm.pp.se>
 <CAPbD+Rc-EDpVvm=-Ge5nWJNgJRBVWseqJKwnfCdDLoBjzC4hzg@mail.gmail.com>
 <alpine.DEB.2.02.1310110900400.20065@uplift.swm.pp.se>
 <CAPbD+Rc81u=_VrK0VSNvOdfQxYK4CHse+DYa8-vS1r==b_AN_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPbD+Rc81u=_VrK0VSNvOdfQxYK4CHse+DYa8-vS1r==b_AN_Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guillaume Betous <guillaume.betous@gmail.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Oct 11, 2013 at 09:14:24AM +0200, Guillaume Betous wrote:

> > What is it about RAID6 that you are not comfortable with?
>=20
> I've never use it :)
>=20
> Here the deal : I have 5 drives on my NAS, I can't have more in my
> tower (1 drive for the system, 5 drives for the NAS). From Adam's
> message, it should be enough for setting up a good RAID 6.
>=20
> For now, I have a RAID 5 with a spare, meaning that I have 3x(drive
> size) as available size. I can have 2 hard drive failures.
> If I setup a RAID 6, if I understand well, I'll also have 3x(drive
> size) as available size, I will also can have 2 drive failures.
>=20
RAID 5 + hot spare can only handle 2 drive failures if the second one
occurs after the rebuild onto the hot spare has completed. Any read
error or drive failure during the rebuild and you're in trouble. With
RAID 6 you can handle 2 drive failures at any time, and after a single
drive failure it can still handle read errors without needing to fail
the array.

Rebuilds will put a lot of load on the array, so errors are not
uncommon, especially with modern large hard drives (where a rebuild can
easily take over 24 hours).

> As I read that algorithm on the RAID 6 are way more complex, and
> rebuild time is longer, as I have only a Atom D510 as CPU, I consider
> that RAID 5 is a better option.
>=20
They are more complex, but not enough so to trouble any modern CPU - you
might have issues on a 386/486, but I doubt you'll see any difference on
an Atom.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlJXs4sACgkQShxCyD40xBIvAACfeS/BZ4U6Jr3aC5C8jfcxd+/s
ocIAoMYQQ+57UOP6NUkHOPsuupaX1gmv
=J0Nq
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
