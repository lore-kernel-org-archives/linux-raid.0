From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Converting system to raid
Date: Fri, 10 Apr 2009 22:51:29 +0100
Message-ID: <20090410215129.GD21242@cthulhu.home.robinhill.me.uk>
References: <003801c9b96d$21a0f420$0a00a8c0@vorg> <49DF0D06.8030705@musmo.com> <20090410195303.GB21242@cthulhu.home.robinhill.me.uk> <00cc01c9ba1d$3aefecf0$0a00a8c0@vorg> <20090410205942.GC21242@cthulhu.home.robinhill.me.uk> <00f301c9ba23$032025f0$0a00a8c0@vorg>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RYJh/3oyKhIjGcML"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <00f301c9ba23$032025f0$0a00a8c0@vorg>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--RYJh/3oyKhIjGcML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Apr 10, 2009 at 02:26:26PM -0700, Timothy D. Lenz wrote:

> Strange:
> -----------------
> sudo mdadm -D /dev/md0
> /dev/md0:
>         Version : 00.90
>   Creation Time : Fri Mar 27 16:49:37 2009
>      Raid Level : raid1
>      Array Size : 24418688 (23.29 GiB 25.00 GB)
>   Used Dev Size : 24418688 (23.29 GiB 25.00 GB)
>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 0
>     Persistence : Superblock is persistent
>=20
>     Update Time : Fri Apr 10 12:58:59 2009
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>            UUID : 27ce9bd9:4ce6ceb2:670e265f:82e0c670 (local to host LLLx=
64-32)
>          Events : 0.38
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8        1        0      active sync   /dev/sda1
>        1       8       17        1      active sync   /dev/sdb1
> -----------------
>=20
> Seems ok, but then:
> -----------------
> sudo mdadm -E /dev/md0
> mdadm: No md superblock detected on /dev/md0.
>
Not really - as I said, "mdadm -E" on the partition, so:
    mdadm -E /dev/sda1
or
    mdadm -E /dev/sdb1

But these'll give the same results as you've already got - it is using a
version 0.9 superblock, so ought to get auto-assembled by the kernel.
If it doesn't, you'll get an error about being unable to find/mount the
block device.  From your original email, it looks like this stage is
working okay anyway.  The "Unable to open initial console" error you got
comes after the root FS has been mounted, and would suggest a problem
with the device nodes.  I'd guess that there's some static device nodes
which are needed before udev is mounted - because you did the copy with
a mounted udev, you've missed these.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--RYJh/3oyKhIjGcML
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAknfv10ACgkQShxCyD40xBJG/ACgpW76d5jbMiWSBNTF++42I7Ii
1d8AmgIqJ+Vf7adSu5zsSX+9Hj7K/tkz
=QnJE
-----END PGP SIGNATURE-----

--RYJh/3oyKhIjGcML--
