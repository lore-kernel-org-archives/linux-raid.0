From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: when read error ,where do we rewrite?
Date: Thu, 7 Jan 2010 13:18:56 +0000
Message-ID: <20100107131855.GA10915@cthulhu.home.robinhill.me.uk>
References: <6c394cc31001070441r1287f635q9c58dc836ce488b7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6c394cc31001070441r1287f635q9c58dc836ce488b7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Jan 07, 2010 at 08:41:20PM +0800, dong wu wrote:

> when read error and can rewrite,where do we rewrite?
> It can't be rewrited to the old block.
> It should be rewrite to other place,where can we find the 'other place'?
> In the source code,I don't find the place that should be rewrited to.
>=20
It's rewritten to the same block - it's up to the low-level device (the
disk) to attempt a write and transparently remap the block if the write
fails.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAktF3z8ACgkQShxCyD40xBL2SACePJTCXbfRiA67sFHITqI9uzvD
KSIAoLjHvql8cWiRBc9Nb/q6RmK70q7f
=0u/J
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
