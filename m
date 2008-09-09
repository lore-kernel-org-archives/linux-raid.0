From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Addition of a partition to an existing RAID1 array overwrites
	disk partition table
Date: Tue, 9 Sep 2008 13:06:23 +0100
Message-ID: <20080909120623.GB20086@cthulhu.home.robinhill.me.uk>
References: <e49f63fe0809090446v326ce59ag9d0095d05f85a43b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e49f63fe0809090446v326ce59ag9d0095d05f85a43b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Sep 09, 2008 at 01:46:56PM +0200, Jacobo Cabaleiro wrote:

> Take a look at: http://pastebin.com/m341ee953. Real results executed
> some minutes ago.
>=20
> Is there something obvious my stupid brain is not seeing? I've already
> tried a search on kernel bugzilla and debian bugs, having not found
> anything of interest.  Bug # 4211 is obviously not the problem here,
> as I'm adding the partition to the array, not the full disk. Can this
> be a bug?
>=20
The disk is actually reporting a different size here (7482 cylinders vs
8924 in the original report) so something very odd is happening.  Could
be related to
http://www.linux.org/docs/ldp/howto/LVM-HOWTO/sundisklabels.html?

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkjGZr4ACgkQShxCyD40xBI3wQCeOkKxy+haFaE7Bb0TrD6QXn9y
QesAoKE0ZXeuX22BqxcMwrYz0fd8T2Wo
=iz8d
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
