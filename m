From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: How to un-degrade an array after a totally spurious failure?
Date: Mon, 8 Jun 2009 08:51:36 +0100
Message-ID: <20090608075136.GA3000@cthulhu.home.robinhill.me.uk>
References: <18988.28487.697258.566987@fisica.ufpr.br> <20090608015637783.ESCT2045@cdptpa-omta01.mail.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090608015637783.ESCT2045@cdptpa-omta01.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun Jun 07, 2009 at 08:56:42PM -0500, Leslie Rhorer wrote:

> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> > owner@vger.kernel.org] On Behalf Of Carlos Carvalho
> > Sent: Sunday, June 07, 2009 8:54 PM
> > To: linux-raid@vger.kernel.org
> > Subject: RE: How to un-degrade an array after a totally spurious failur=
e?
> >=20
> > Leslie Rhorer (lrhorer@satx.rr.com) wrote on 7 June 2009 20:43:
> >  >OK, what about a RAID 6 array with one failed disk?  Is the remove & =
add
> >  >the best option there, or should one apply a different method?
> >=20
> > It is, since that's what the raid is for. It's still operational.
> > We've done it here and it works.
>=20
> Well, yes, I know it should work.  The question is, "Is it the best metho=
d?"
>=20
Yes - as the array is still active then it's likely to have changed
since the drive failed.  This means that stopping the array and
re-assembling, forcing the failed drive active, could lead to
corruption.  Removing & adding it will ensure the data is updated to
match the current array state.

Of course, neither option should be pursued unless you know _exactly_
why the drive failed and know that it's safe to re-add it to the array.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkoswwYACgkQShxCyD40xBLtwwCeOnn0g1moETh+78oz041w2d09
3I8AoIjMjzA07ZbXS3FrjDMGfJk6JAT3
=6ybp
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
