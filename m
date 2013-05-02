From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: replacing drives
Date: Thu, 2 May 2013 15:54:11 +0100
Message-ID: <20130502145411.GA18405@cthulhu.home.robinhill.me.uk>
References: <517A8EB5.8080100@supsi.ch>
 <20130426155347.GA9928@cthulhu.home.robinhill.me.uk>
 <518270A6.4090706@supsi.ch>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <518270A6.4090706@supsi.ch>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Nunnari <roberto.nunnari@supsi.ch>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu May 02, 2013 at 03:56:54PM +0200, Roberto Nunnari wrote:

> Robin Hill wrote:
> > The safest option would be:
> >  - add in the new disks
> >  - partition to at least the same size as your existing partitions (they
> >    can be larger)
> >  - add the new partitions into the arrays (they'll go in as spares)
> >  - grow the arrays to 4 members (this avoids any loss of redundancy)
> >  - wait for the resync to complete
> >  - install grub/lilo/syslinux to the new disks
>=20
> Ok.. got here.
>=20
>=20
> >  - fail and remove the old disk partitions from the arrays
>=20
> Now.. I may need some guidance for the next steps.. please correct me if=
=20
> I'm wrong..
>=20
> to fail the old disk partition from the arrays I should:
> mdadm -f /dev/md0 /dev/sda1
> mdadm -f /dev/md1 /dev/sda2
> mdadm -f /dev/md2 /dev/sda3
> mdadm -f /dev/md0 /dev/sdc1
> mdadm -f /dev/md1 /dev/sdc2
> mdadm -f /dev/md2 /dev/sdc3
>=20
> and to remove the old disk partition from the arrays I should:
> mdadm -r /dev/md0 /dev/sda1
> mdadm -r /dev/md1 /dev/sda2
> mdadm -r /dev/md2 /dev/sda3
> mdadm -r /dev/md0 /dev/sdc1
> mdadm -r /dev/md1 /dev/sdc2
> mdadm -r /dev/md2 /dev/sdc3
>=20
> correct?
>=20
Assuming sda & sdc are your old drives, yes (they were sda & sdb in your
original mail, but possibly they've been reordered if you've rebooted
with the new drives in).

>=20
> >  - shrink the arrays back down to 2 members
>=20
> to shrink the arrays back down to two members:
> mdadm --grow --raid-devices=3D2 /dev/md0
> mdadm --grow --raid-devices=3D2 /dev/md1
> mdadm --grow --raid-devices=3D2 /dev/md2
>=20
> correct?
>=20
Yes, that's all correct.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlGCfhAACgkQShxCyD40xBJwtwCgko5UvdIpCGcDu2CIih43Sg6b
0XgAoN5TKZBOnn/lUB0vvAjXJrh9aEDf
=zvw4
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
