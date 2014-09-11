From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Add disks and convert level 0 to level 5
Date: Thu, 11 Sep 2014 08:27:32 +0100
Message-ID: <20140911072732.GA12582@cthulhu.home.robinhill.me.uk>
References: <loom.20140831T143354-68@post.gmane.org>
 <20140901083137.4772c8c5@notabene.brown>
 <8CF94689-0AD6-4B87-BC0C-815F794549E7@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8CF94689-0AD6-4B87-BC0C-815F794549E7@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Muratet <muratetm@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Sep 10, 2014 at 11:15:24AM -0500, Michael Muratet wrote:

> I have a two-disk RAID0 system that is working splendidly, thanks to
> the list for the help.
>=20
> I managed to get my hands on more identical disks and since I have the
> disks and because I'm adding precious data, I'd like to add two more
> disks and grow to RAID5.
>=20
> I have partitioned the two new drives to type 'fd', /dev/sde and /dev/sdf
>=20
> I believe the command to accomplish the change is this:
>=20
> mdadm /dev/md0 --grow --level=3D5 --add /dev/sde /dev/sdf
>=20
If you've partitioned the drives then presumably you'd want to use the
partitions here (/dev/sde1 and /dev/sdf1?) rather than the full drives.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlQRTuMACgkQShxCyD40xBKxHQCeKr7bgXAj9NRvyqacdOYzCzyp
HXIAoNEOOWPkM6BVwMfVjxnDmz3P4Sl/
=SWp/
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
