From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: emergency call for help: raid5 fallen apart
Date: Wed, 24 Feb 2010 15:22:28 +0000
Message-ID: <20100224152228.GB11039@cthulhu.home.robinhill.me.uk>
References: <4B853DB7.1060406@xunil.at>
 <4B854040.5080603@xunil.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B854040.5080603@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Feb 24, 2010 at 04:05:36PM +0100, Stefan G. Weichinger wrote:

> Am 24.02.2010 15:54, schrieb Stefan G. Weichinger:
>=20
> > What to try?
> >=20
> > This is a crucial server and I feel a lot of pressure.
> > Rebuilding that raid would mean a lot of restore-work etc.
> > So I would really appreciate a goo advice here.
>=20
> Followup:
>=20
> --examine shows different statii for the four partitions:
>=20
Hmm, that looks like sda4 dropped out after sdc4 was removed, failing
the array.  Can you force assemble the array?
    mdadm -A /dev/md4 -f /dev/sda4 /dev/sdb4

If that works, you'll want to re-add the hot spare so it rebuilds.
You'll also need to fsck the filesystem afterwards.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAkuFRDMACgkQShxCyD40xBLiBACgzz88VszDxC0NpEJJ8wQqUL3K
/2YAnjHBeWRlUPWkX6TIGrr5QiaQCyqU
=gOf4
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
