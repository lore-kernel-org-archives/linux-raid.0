From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: replacing drives
Date: Tue, 30 Apr 2013 15:22:26 +0100
Message-ID: <20130430142226.GB14347@cthulhu.home.robinhill.me.uk>
References: <517A8EB5.8080100@supsi.ch>
 <20130426155347.GA9928@cthulhu.home.robinhill.me.uk>
 <517FC46A.1080702@supsi.ch>
 <alpine.DEB.2.00.1304301519350.26743@uplift.swm.pp.se>
 <517FD12B.20608@supsi.ch>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oLBj+sq0vYjzfsbl"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <517FD12B.20608@supsi.ch>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Nunnari <roberto.nunnari@supsi.ch>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--oLBj+sq0vYjzfsbl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Apr 30, 2013 at 04:11:55PM +0200, Roberto Nunnari wrote:

> Mikael Abrahamsson wrote:
> > On Tue, 30 Apr 2013, Roberto Nunnari wrote:
> >=20
> >> How do I increase that timeout?
> >=20
> > for x in /sys/block/sd[a-z] ; do echo 180  > $x/device/timeout ; done
> >=20
>=20
> You believe that this is not enough? What's the unit? milliseconds?
> # for x in /sys/block/sd[a-z] ; do cat $x/device/timeout ; done
> 30
> 30
> 30
> 30
>=20
The units are seconds. According to WD[1], their drives can take up to 2
minutes to timeout, but other manufacturers may differ. 30 seconds is
definitely too short.

[1] http://wdc.custhelp.com/app/answers/detail/a_id/1397/p/227,283/session/=
L3RpbWUvMTMyMTQzOTc4NS9zaWQvdVhvYmpmSms%3D

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--oLBj+sq0vYjzfsbl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlF/06EACgkQShxCyD40xBKJXgCffrYLI4j87HHoxeaTut/d4j4W
9GgAoJWsehFCnMFwNfvTrNBsZU4G2GXS
=y67Z
-----END PGP SIGNATURE-----

--oLBj+sq0vYjzfsbl--
