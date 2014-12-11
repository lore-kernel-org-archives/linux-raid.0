From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Growing RAID-10 (near-2) array - which kernel needed?
Date: Thu, 11 Dec 2014 19:21:39 +0000
Message-ID: <20141211192139.GA4233@cthulhu.home.robinhill.me.uk>
References: <b906dbe55e09c7cf24abcacfbf97efed@kruemel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b906dbe55e09c7cf24abcacfbf97efed@kruemel.org>
Sender: linux-raid-owner@vger.kernel.org
To: cvb@kruemel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Dec 11, 2014 at 07:31:31PM +0100, cvb@kruemel.org wrote:

> Apologies for raising this topic again, but I can't seem to find=20
> anything googling, and man mdadm doesn't also give me a clue. Which=20
> kernel version is needed to grow a near-2 RAID 10 array?
>=20
Full reshape support (changing number of devices, layout or chunk size)
was introduced in 3.5 (http://kernelnewbies.org/Linux_3.5).

> I'm currently running kernel 3.13.0 with mdadm 3.2.5. But I could also=20
> use a live CD with a newer kernel, if needed.
>=20
It also requires mdadm 3.3 or above.

> I have replaced the 4 disks here with larger ones (2TB drives -> 4 TB=20
> drives), and this is what the array currently looks like:
>=20
> # mdadm --detail /dev/md0
> /dev/md0:
>          Version : 1.2
>    Creation Time : Sat Aug 20 08:15:07 2011
>       Raid Level : raid10
>       Array Size : 3906764800 (3725.78 GiB 4000.53 GB)
>    Used Dev Size : 1953382400 (1862.89 GiB 2000.26 GB)
>     Raid Devices : 4
>    Total Devices : 4
>      Persistence : Superblock is persistent
>=20
>      Update Time : Thu Dec 11 08:31:15 2014
>            State : clean
>   Active Devices : 4
> Working Devices : 4
>   Failed Devices : 0
>    Spare Devices : 0
>=20
>           Layout : near=3D2
>       Chunk Size : 512K
>=20
>             Name : alpha:0  (local to host alpha)
>             UUID : 8199e640:58fc3a04:99b52fe6:80a1574d
>           Events : 918971
>=20
>      Number   Major   Minor   RaidDevice State
>         6       8        1        0      active sync   /dev/sda1
>         5       8       33        1      active sync   /dev/sdc1
>         7       8       17        2      active sync   /dev/sdb1
>         4       8       49        3      active sync   /dev/sdd1
>=20
I can't find anything explicitly covering growing a RAID 10 by just
increasing the device sizes. I would have thought that would be an
easier task than doing so by adding disks, so should be supported in an
earlier version. mdadm 3.2.1 mentions supporting converting between
RAID-10 and RAID-1, which can definitely be grown.

Have you tried doing a grow with the versions you have?

Cheers,
    Robin

--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlSJ7sMACgkQShxCyD40xBILTQCfTcTzRhOJdUuc6/T28C+MO/TA
sugAoLdkiBe8pOX7cOxhM4X2wzP2HwCI
=l0L5
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
