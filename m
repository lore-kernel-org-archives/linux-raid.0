From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: mdadm kernel log messages explained
Date: Sun, 16 Sep 2012 11:57:06 +0100
Message-ID: <20120916105706.GB26357@cthulhu.home.robinhill.me.uk>
References: <50559575.4090806@statystyka.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8P1HSweYDcXXzwPJ"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <50559575.4090806@statystyka.net>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--8P1HSweYDcXXzwPJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun Sep 16, 2012 at 11:01:41 +0200, Adam Ryczkowski wrote:

> Welcome.
>=20
> I try to recover from linux software raid failure. I am in a process of=
=20
> recreating the superblocks based on a syslog from the system when it was=
=20
> healthy. The log speaks about 2 md devices, each based on 5 500GB=20
> partitions. The RAID-5 /dev/md5 is composed from /dev/sd[b-f]6 and=20
> RAID-6 /dev/md6 is composed from /dev/sd[b-f]5. The relevant part dmesg=
=20
> log looks like this:
>=20
> Questions:
> #    What do the numbers on the line [ 5.979771] 4: w=3D1 pa=3D0 pr=3D5 m=
=3D1=20
> a=3D2 r=3D5 op1=3D0 op2=3D0 mean, including the first 4:?
4 is the raid device number
w=3D1 indicates the number of working disks found so far
pa=3D0 is the previous algorithm (used when reshaping)
pr=3D5 is the previous number of raid devices (used when reshaping)
m=3D1 is the maximum number of degraded disks allowed for the array to run
a=3D2 is the algorithm used
r=3D5 is the number of raid devices
op1=3D0 indicates that the disk is not a parity-only disk in the previous
      layout (used when reshaping)
op2=3D0 indicates that the disk is not a parity-only disk in the current
      layout

> #    What do the numbers on the line [ 6.039266] --- rd:5 wd:5] mean?
rd is the number of devices in the array
wd is the number of working devices in the array

> #    What do the numbers on the line [ 6.046856] disk 0, o:1, dev:sdb6 me=
an?
0 is the raid device number
o:1 indicates that it's operational (i.e. not marked as faulty)
dev:sdb6 indicates the kernel device name

> #    Does the line [ 6.096768] created bitmap (15 pages) for device md5=
=20
> tell anything about the place, where the bitmap is located and what is=20
> its size?
>=20
It doesn't tell you anything about the place. I've no idea how the
number of pages equates to the bitmap size/bitmap chunk size though.

In the above cases, the raid device number is its position within the
array, so from 0..N-1 for an N-device array. This will indicate the
order you'll need to use when recreating the array.

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--8P1HSweYDcXXzwPJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlBVsIAACgkQShxCyD40xBKBIQCeM4V7OeWDkTUSfTxnISwD7k4e
4hMAoKCI/nXMhcUicjElrfnubitea3ux
=iVur
-----END PGP SIGNATURE-----

--8P1HSweYDcXXzwPJ--
