From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: mdadm 3.1.1: level change won't start
Date: Mon, 21 Dec 2009 09:35:28 +0000
Message-ID: <20091221093528.GA24168@cthulhu.home.robinhill.me.uk>
References: <73e903670912201941q44dae7b0t455d1a94f13f5c31@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <73e903670912201941q44dae7b0t455d1a94f13f5c31@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Dec 21, 2009 at 03:41:33AM +0000, Kristleifur Da=F0ason wrote:

> Hi all,
>=20
> I wish to convert my 3-drive RAID-5 array to a 6-drive RAID-6. I'm on
> Linux 2.6.32.2 and have mdadm version 3.1.1 with the 32-bit-array-size
> patch from here: http://osdir.com/ml/linux-raid/2009-11/msg00534.html
>=20
> I have three live drives and three spares added to the array. When I
> initialize the command, mdadm does the initial checks and aborts with
> a "cannot set device shape" without doing anything to the array.
>=20
> $ mdadm --grow /dev/md_d1 --level=3D6 --raid-devices=3D6
> --backup-file=3D/root/backup.md1_to_r6
> mdadm: metadata format 1.10 unknown, ignored.
> mdadm: metadata format 1.10 unknown, ignored.
> mdadm level of /dev/md_d1 changed to raid6
> mdadm: Need to backup 1024K of critical section..
> mdadm: Cannot set device shape for /dev/md_d1
> mdadm: aborting level change
>=20
I don't think you can grow and reshape simultaneously.  I think you'll
need to do this as two operations - either grow to a 5 disk RAID5 then
reshape to a 6 disk RAID6, or reshape to a 4 disk RAID6 then grow.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAksvQV0ACgkQShxCyD40xBK5BACgz8kL+BMihWJJcUsRrzxAaAB+
qgkAoIxUeK72V4+ZU5fC4o/P/i3b9wq4
=nbPi
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
