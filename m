From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: raid1 issue after disk failure: both disks of the array are
 still active
Date: Thu, 13 Sep 2012 11:34:32 +0100
Message-ID: <20120913103432.GA11764@cthulhu.home.robinhill.me.uk>
References: <5051AF17.8010501@linuxsystems.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5051AF17.8010501@linuxsystems.it>
Sender: linux-raid-owner@vger.kernel.org
To: =?iso-8859-1?Q?Niccol=F2?= Belli <darkbasic@linuxsystems.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Sep 13, 2012 at 12:01:59PM +0200, Niccol=F2 Belli wrote:

> Hi,
> I have a raid1 array with two disks, distro is Squeeze amd64. /dev/sda=20
> is slowly dying, here is a snippet of "smartctl -a /dev/sda":
>=20
> 197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always=
=20
>        -       2
> 198 Offline_Uncorrectable   0x0030   100   100   000    Old_age Offline=
=20
>       -       1
>=20
> The bad sector is in the second half-MB of the disk, in fact with "dd=20
> if=3D/dev/sda1 of=3D/dev/null bs=3D524228 count=3D1 skip=3D1" I get this =
output in=20
> /var/log/syslog:
>=20
> root@asterisk:~# dd if=3D/dev/sda1 of=3D/dev/null bs=3D524228 count=3D1 s=
kip=3D1
> 0+1 record dentro
> 0+1 record fuori
> 430140 byte (430 kB) copiati, 11,7265 s, 36,7 kB/s
>=20
<- snip dmesg output ->
>=20
> *Why doesn't it fail the first hard disk of the array!!??*
>=20
Has anything actually attempted to read from that part of the array?
Even if so, it may just have happened to read from the working disk
anyway. md can only detect the error when it tries to read/write that
sector of that disk.

Your best bet now is to do an array check:
    echo check > /sys/block/md0/md/sync_action

This will force a read of all disks in the array. This should trigger
the read error, causing an attempt to re-write the faulty block, in turn
causing the drive remap the bad sector (assuming the re-write fails).
This should also be scheduled to run regularly for all arrays in order
to pick up these sort of issues before they cause major problems during
a rebuild.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlBRtrcACgkQShxCyD40xBKl2QCdGukC6J8jm5w7Y7XKYnJsx9pi
mLEAn12qlt9vg/BJoXcBRyUVfo3RCS5l
=LHPh
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
