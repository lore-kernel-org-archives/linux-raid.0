From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: I was dump, I need help.
Date: Mon, 2 May 2016 13:41:13 +0100
Message-ID: <20160502124113.GA1973@cthulhu.home.robinhill.me.uk>
References: <5725DCA9.9010901@pboenig.de>
 <20160501113034.GA24215@cthulhu.home.robinhill.me.uk>
 <5726128E.9090309@pboenig.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5726128E.9090309@pboenig.de>
Sender: linux-raid-owner@vger.kernel.org
To: Patrice <mailinglist@pboenig.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun May 01, 2016 at 04:28:30PM +0200, Patrice wrote:

> Hi Robin,
>=20
> thank you for your reply.
> Ok, I try not to panic but in my opinion that sounds bad. It seems to me=
=20
> like a mess.
> Why is there a RAID 1 und 6? I need a RAID 5.
>
It looks like you have a RAID1, a RAID6 and a RAID5. I'd guess that the
RAID1 and RAID6 store the OS for the NAS system, and the RAID5 is the
data.

>  > are there any others which should be being
>  > assembled into another array?
>=20
> There are no others. At least there should be only one partition on each=
=20
> HDD. I didn`t do partitioning.
>=20
>=20
> fdisk -l output:
> ------------------
>=20
> Disk /dev/sda: 4000.8 GB, 4000787030016 bytes
> 256 heads, 63 sectors/track, 484501 cylinders, total 7814037168 sectors
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 4096 bytes
> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> Disk identifier: 0x00000000
>=20
>     Device Boot      Start         End      Blocks   Id  System
> /dev/sda1               1  4294967295  2147483647+  ee  GPT
> Partition 1 does not start on physical sector boundary.
>=20
> WARNING: GPT (GUID Partition Table) detected on '/dev/sdb'! The util=20
> fdisk doesn't support GPT. Use GNU Parted.
>=20
>=20
> Disk /dev/sdb: 4000.8 GB, 4000787030016 bytes
> 256 heads, 63 sectors/track, 484501 cylinders, total 7814037168 sectors
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 4096 bytes
> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> Disk identifier: 0x00000000
>=20
>     Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1               1  4294967295  2147483647+  ee  GPT
> Partition 1 does not start on physical sector boundary.
>=20
> WARNING: GPT (GUID Partition Table) detected on '/dev/sdc'! The util=20
> fdisk doesn't support GPT. Use GNU Parted.
>=20
>=20
> Disk /dev/sdc: 4000.8 GB, 4000787030016 bytes
> 256 heads, 63 sectors/track, 484501 cylinders, total 7814037168 sectors
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 4096 bytes
> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> Disk identifier: 0x00000000
>=20
>     Device Boot      Start         End      Blocks   Id  System
> /dev/sdc1               1  4294967295  2147483647+  ee  GPT
> Partition 1 does not start on physical sector boundary.
>=20
> WARNING: GPT (GUID Partition Table) detected on '/dev/sdd'! The util=20
> fdisk doesn't support GPT. Use GNU Parted.
>=20
>=20
> Disk /dev/sdd: 4000.8 GB, 4000787030016 bytes
> 256 heads, 63 sectors/track, 484501 cylinders, total 7814037168 sectors
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 4096 bytes
> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> Disk identifier: 0x00000000
>=20
>     Device Boot      Start         End      Blocks   Id  System
> /dev/sdd1               1  4294967295  2147483647+  ee  GPT
> Partition 1 does not start on physical sector boundary.
>=20
> -------------------------------------------------------------------------
>=20
Okay, so there's 4 4TB drives - they're using GPT partitions so fdisk
doesn't report anything useful here.

>=20
> mdadm -E /dev/sd* output:
> --------------------------
>=20
> /dev/sda3:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : 632ff5fd:65342524:9c9798d7:80e47e94
>             Name : 119c1bce:data-0  (local to host 119c1bce)
>    Creation Time : Sun Apr  3 06:27:49 2016
>       Raid Level : raid5
>     Raid Devices : 4
>=20
>   Avail Dev Size : 7804333680 (3721.40 GiB 3995.82 GB)
>       Array Size : 11706500352 (11164.19 GiB 11987.46 GB)
>    Used Dev Size : 7804333568 (3721.40 GiB 3995.82 GB)
>      Data Offset : 262144 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=3D262056 sectors, after=3D112 sectors
>            State : clean
>      Device UUID : 38adc372:3e0eba36:0f819758:950a0411
>=20
>      Update Time : Sat Apr 30 23:03:32 2016
>    Bad Block Log : 512 entries available at offset 72 sectors
>         Checksum : d7f5b303 - correct
>           Events : 266
>=20
>           Layout : left-symmetric
>       Chunk Size : 64K
>=20
>     Device Role : Active device 0
>     Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
>=20
>=20
> /dev/sdb3:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : 632ff5fd:65342524:9c9798d7:80e47e94
>             Name : 119c1bce:data-0  (local to host 119c1bce)
>    Creation Time : Sun Apr  3 06:27:49 2016
>       Raid Level : raid5
>     Raid Devices : 4
>=20
>   Avail Dev Size : 7804333680 (3721.40 GiB 3995.82 GB)
>       Array Size : 11706500352 (11164.19 GiB 11987.46 GB)
>    Used Dev Size : 7804333568 (3721.40 GiB 3995.82 GB)
>      Data Offset : 262144 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=3D262056 sectors, after=3D112 sectors
>            State : clean
>      Device UUID : 655ee144:43c43771:0d8a6157:9b556584
>=20
>      Update Time : Sat Apr 30 23:03:32 2016
>    Bad Block Log : 512 entries available at offset 72 sectors
>         Checksum : 56bc6e3b - correct
>           Events : 266
>=20
>           Layout : left-symmetric
>       Chunk Size : 64K
>=20
>     Device Role : Active device 1
>     Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
>=20
>=20
> /dev/sdc3:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : 632ff5fd:65342524:9c9798d7:80e47e94
>             Name : 119c1bce:data-0  (local to host 119c1bce)
>    Creation Time : Sun Apr  3 06:27:49 2016
>       Raid Level : raid5
>     Raid Devices : 4
>=20
>   Avail Dev Size : 7804333680 (3721.40 GiB 3995.82 GB)
>       Array Size : 11706500352 (11164.19 GiB 11987.46 GB)
>    Used Dev Size : 7804333568 (3721.40 GiB 3995.82 GB)
>      Data Offset : 262144 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=3D262056 sectors, after=3D112 sectors
>            State : clean
>      Device UUID : d066d1aa:ffd1e432:e9ecdd9d:08540efa
>=20
>      Update Time : Sat Apr 30 23:17:27 2016
>    Bad Block Log : 512 entries available at offset 72 sectors
>         Checksum : 3a7ce8f6 - correct
>           Events : 273
>=20
>           Layout : left-symmetric
>       Chunk Size : 64K
>=20
>     Device Role : Active device 2
>     Array State : ..AA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
>=20
>=20
> /dev/sdd3:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : 632ff5fd:65342524:9c9798d7:80e47e94
>             Name : 119c1bce:data-0  (local to host 119c1bce)
>    Creation Time : Sun Apr  3 06:27:49 2016
>       Raid Level : raid5
>     Raid Devices : 4
>=20
>   Avail Dev Size : 7804333680 (3721.40 GiB 3995.82 GB)
>       Array Size : 11706500352 (11164.19 GiB 11987.46 GB)
>    Used Dev Size : 7804333568 (3721.40 GiB 3995.82 GB)
>      Data Offset : 262144 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=3D262056 sectors, after=3D112 sectors
>            State : clean
>      Device UUID : b8a43a56:2f833e72:7dd9f166:6f80b5a2
>=20
>      Update Time : Sat Apr 30 23:17:27 2016
>    Bad Block Log : 512 entries available at offset 72 sectors
>         Checksum : 96faf109 - correct
>           Events : 273
>=20
>           Layout : left-symmetric
>       Chunk Size : 64K
>=20
>     Device Role : Active device 3
>     Array State : ..AA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
>=20
I've removed the info for the first two partitions on each disk as those
arrays are assembling fine. The third partitions look to contain your
data array - the events for sda3 and sdb3 match at 266, and sdc3 and
sdd3 are on 273 (and show sda3 & sdb3 missing). A forced assembly should
work without any issues here - the array name would look to be
/dev/md/data-0, so:
  mdadm -Af /dev/md/data-0 /dev/sd[abcd]3

That should assemble the array from 3 of the disks (probably sda3, sdc3
and sdd3) - you'll then need to add the other one back in and allow the
rebuild to complete. You should also do a check on the filesystem to
ensure there's no corruption.

Cheers,
    Robin

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlcnSukACgkQShxCyD40xBJ1DQCg3qplSsfa25Bcl/qVnrxRgnE7
E44An0P6V3aMbdwaEIh12XKHAWNSfEYs
=RqIV
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
