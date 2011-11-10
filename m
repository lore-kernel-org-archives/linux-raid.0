From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Raid Problem - Unknown File System Type
Date: Thu, 10 Nov 2011 08:53:36 +0000
Message-ID: <20111110085336.GA3639@cthulhu.home.robinhill.me.uk>
References: <4EBAA68B.6090906@rogers.com>
 <20111109163933.GA26630@cthulhu.home.robinhill.me.uk>
 <4EBAB47C.5070002@rogers.com>
 <4EBACC88.8070403@turmel.org>
 <4EBADB1E.1070700@rogers.com>
 <4EBADD07.5030109@turmel.org>
 <4EBAE90F.2030104@rogers.com>
 <4EBAF46C.2030001@turmel.org>
 <4EBB46A5.8080305@rogers.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4EBB46A5.8080305@rogers.com>
Sender: linux-raid-owner@vger.kernel.org
To: William Colls <william.colls@rogers.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Nov 09, 2011 at 10:36:05PM -0500, William Colls wrote:

> [ .... ]
> >
> > OK. So that wasn't it.  GRUB is in the first sector, with a MBR
> > partition table identifying a single 750G partition starting at
> > sector 63.
>=20
> The array was not bootable in its original configuration, so I am=20
> surprised that GRUB would be on the disk, but the single partition of=20
> 750G is correct.
>=20
If the disk is partitioned then did you actually want the array made up
of the partitions rather than the whole disk? In which case stopping the
array and recreating using the partitions may be all that's needed:
    mdadm -S /dev/md0
    mdadm --create /dev/md0 --level=3D1 --raid-devices=3D2 /dev/sdb1
    /dev/sdc1 --assume-clean

That could cause further damage if that's not how it should be set up,
so I'd recommend thinking hard before running it!

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk67kRAACgkQShxCyD40xBImPgCbBgQMbsVLMZLpPKOvqfuViTbW
v/0An1w5PXjUWkp1fnbG2qWKuMB6cKli
=AY8A
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
