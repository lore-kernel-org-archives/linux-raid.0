From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: emergency call for help: raid5 fallen apart
Date: Wed, 24 Feb 2010 18:12:19 +0000
Message-ID: <20100224181219.GA8043@cthulhu.home.robinhill.me.uk>
References: <4B853DB7.1060406@xunil.at>
 <4B854040.5080603@xunil.at>
 <20100224152228.GB11039@cthulhu.home.robinhill.me.uk>
 <4B85467C.5020008@xunil.at>
 <4B855621.5010000@xunil.at>
 <4B855987.1010605@xunil.at>
 <20100224170951.GC11039@cthulhu.home.robinhill.me.uk>
 <4B856372.6000900@xunil.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B856372.6000900@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Feb 24, 2010 at 06:35:46PM +0100, Stefan G. Weichinger wrote:

> Am 24.02.2010 18:09, schrieb Robin Hill:
>=20
> > If these are the only disks with up-to-date data, and sda4 is still
> > failing, I can only suggest stopping the array and using dd/dd_rescue to
> > copy sda4 onto a working disk.  You should then be able to reassemble
> > the array with sdb4 and the new disk, then add in a hot spare to
> > recover.
>=20
> Currently sdd isn't in use at all.
>=20
> So I could
>=20
>=20
> mdadm --stop /dev/md4
>=20
> ddrescue /dev/sda4 /dev/sdd4
>=20
> mdadm --assemble --force /dev/md4 /dev/sdb4 /dev/sdd4
>=20
> ??
>=20
Yes, that'd be what I'd recommend - the ddrescue will only need to make
a single pass across sda4 (except for failed blocks of course), so will
have the lowest risk of exacerbating the disk problems.  Of course, the
practicality of doing the assemble will depend on the number of
unreadable blocks found by ddrescue.

Good luck!
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAkuFbAMACgkQShxCyD40xBK4MwCfXpF8wP7+klkBY9PGHChRHjuX
e1cAoIQCZyRW7/me2xr2xFJGxAIgPp//
=SYkX
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
