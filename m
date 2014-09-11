From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: access to old raid1 partitions after reinstall on two new disks
Date: Thu, 11 Sep 2014 18:16:47 +0100
Message-ID: <20140911171647.GA7480@cthulhu.home.robinhill.me.uk>
References: <5411C7B1.1010205@yum.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5411C7B1.1010205@yum.de>
Sender: linux-raid-owner@vger.kernel.org
To: system.admin@yum.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Sep 11, 2014 at 06:02:57pm +0200, system.admin@yum.de wrote:

> Hello there,
>=20
> we have a machine running on four raid-1 partitions (2 disks). The
> system had to be reinstalled on two new disks since one of the old disks
> failed and we afterwards saw defective sectors on the remaining disk. So
> the system was restored from backup on two complete new disks. We now
> have the disk with the defective sectors on which the old system was
> installed as third disk installed in the machine. Since we could not
> recover everything from backup, we would like to start the old raid
> devices from the old disk again and try to access the old filesystems
> again.
>=20
> The fresh installed system has of course the same md0, md1, md2, md3
> devices as the old one had. Therefore I wonder how to access the old
> raid devices, which had the same names.
>=20
> Is there a way to get the old partitions running as additional raid
> devices like md4, md5, md6 and md7 (or under different names) and should
> it be possible to mount the filesystems of those new / old raid devices
> in the fresh installed system?
>=20
Yes, just specify the md device name as part of the assemble.
    mdadm -A /dev/md4 /dev/sdf1

If they're using RAID superblock versions 0.9 or 1.0 then you don't even
have to assemble the RAID - you can just mount any of the members
directly.

And yes, you should be able to mount the filesystems inside your new
system the same as with any other block device.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlQR2P8ACgkQShxCyD40xBL4BwCg2+hlCnK1pWNjkUDxz5CCE+hY
5sYAnifPBh12akSTPaSkW9J1K2EqkIRf
=u7ki
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
