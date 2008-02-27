From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Is 'fd' partition type of any use ?
Date: Wed, 27 Feb 2008 14:54:00 +0000
Message-ID: <20080227145400.GA10625@cthulhu.home.robinhill.me.uk>
References: <1204121589.11126.14.camel@franck-gusty>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1204121589.11126.14.camel@franck-gusty>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Feb 27, 2008 at 03:13:09PM +0100, Franck Routier wrote:

> it is not clear to me if 'fd' partition type is of any use for building
> a md raid array. I am under the impression that this is only a legacy
> trick that is not necessary anymore.
> But most information regarding md raid on the net seems to take for
> granted that 'fd' partition type is mandatory.
>=20
The 'fd' partition type is required (along with version 0.9 superblocks)
for in-kernel autoassembly of arrays.  They are not required for
assembling arrays using mdadm (via initrd or after boot) though they are
useful in that they clearly indicate, to either the user or
applications, that the partitions are part of a RAID array.

HTH,
        Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHxXmHShxCyD40xBIRAox8AKCT9X+MABtoY1Eh/uuG9Vcq+YmpFQCeKLOI
/0sUg5dq21BWeJgawVO0zP4=
=EhV0
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
