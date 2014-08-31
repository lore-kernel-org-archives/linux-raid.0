From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Converting RAID5 to RAID0
Date: Sun, 31 Aug 2014 18:13:27 +0100
Message-ID: <20140831171327.GB25561@cthulhu.home.robinhill.me.uk>
References: <loom.20140831T143354-68@post.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O5XBE6gyVG5Rl6Rj"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <loom.20140831T143354-68@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Muratet <muratetm@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--O5XBE6gyVG5Rl6Rj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun Aug 31, 2014 at 12:43:26PM +0000, Mike Muratet wrote:

> I am doing some experiments with mdadm to combine two 1TB disks into a RA=
ID
> array. I used fdisk to create the partitions and mdadm to create a two di=
sk
> RAID5 array. I would like to have more space and I can live without
> redundancy. I searched the man pages and boards for a way to do that and =
found:
>=20
> $ sudo mdadm /dev/md0 -f /dev/sdd
> mdadm: set /dev/sdd faulty in /dev/md0
> $ sudo mdadm /dev/md0 -r /dev/sdd
> mdadm: hot removed /dev/sdd from /dev/md0
> $ sudo echo raid0 > /sys/block/md0/md/level
>=20
> -bash: /sys/block/md0/md/level: Permission denied
>=20
> which was not the result I expected.
>=20
> Is it possible to convert RAID5 to RAID0?
>=20
It should be, yes. I'd use "mdadm --grow --level=3D0" rather than direct
interaction with sysfs though. You may need to add "--force" in order to
get a 1-disk RAID0 array though (it's mentioned as being required for
create anyway).

> There are no data on the disk. Is there a way to start over?
>=20
Sure. Just stop the arrays (mdadm -S /dev/md0) and then run a new create
command. You'll be prompted about an existing array (and filesystem, if
you'd created that) but can continue to overwrite with the new settings.

Cheers,
    Robin

--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--O5XBE6gyVG5Rl6Rj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlQDV7UACgkQShxCyD40xBJeFACgkYVVvIsL2V1l45U3q6X62WM6
IIIAoKdeVzysHTwINcNYeQsTt+gbB9Bq
=drtp
-----END PGP SIGNATURE-----

--O5XBE6gyVG5Rl6Rj--
