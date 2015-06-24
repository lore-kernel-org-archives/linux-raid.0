From: NeilBrown <neilb@suse.com>
Subject: Re: (R) in mdstat output, clean && degraded
Date: Thu, 25 Jun 2015 08:52:01 +1000
Message-ID: <20150625085201.4b2c6995@noble>
References: <51364598-D6AA-43E7-B9A1-C3C09255D3D4@puck.nether.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51364598-D6AA-43E7-B9A1-C3C09255D3D4@puck.nether.net>
Sender: linux-raid-owner@vger.kernel.org
To: Jared Mauch <jared@puck.nether.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 23 Jun 2015 14:56:09 -0400 Jared Mauch <jared@puck.nether.net>
wrote:

> I=E2=80=99ve been searching high and low the past few days and have b=
een unable to diagnose what this (R) is in my raid1 mdstat output indic=
ates.
>=20
> It seems something is =E2=80=98stuck=E2=80=99 somehow as I=E2=80=99m =
not sure how the array is both clean and degraded at the same time.
>=20
> Some insights are welcome.
>=20
> kernel 4.0.5-300.fc22 (fedora 22)
>=20
> /proc/mdstat
>=20
> md127 : active raid1 sdg1[2](R) sdd1[3]
>       976630464 blocks super 1.2 [2/1] [U_]
>       bitmap: 8/8 pages [32KB], 65536KB chunk

Hmm.....

It isn't at all clear to me how you could get into this state, but I
think I can describe the state the array is in.

The array is degraded, but the one working device has been "replaced"
almost completely.
The data has all been copied from sdd1 to sdg1, but sdg1 hasn't been
marked 'faulty' yet.  Normally when the 'replace' finishes, the
original gets marked 'faulty' as the new device is being marked
'in-sync'.
Once it is faulty it is removed from the array.

Some how, your replacement device got marked 'in-sync' but the original
didn't get marked 'faulty'.

Currently I believe that all writes are going to both devices, and all
reads are being served by the replacement: sdg1.
You could verify this by looking at io stats (e.g. /proc/diskstats,
though the meanings of the columns aren't obvious...)

You should be able to turn this into a fully functional RAID1 array by:

 mdadm /dev/md127 --fail /dev/sdd1=20
 mdadm /dev/md127 --remove /dev/sdd1
 mdadm /dev/md127 --re-add /dev/sdd1

When you fail sdd1, sdg1 will change from being a 'replacement' to bein=
g
a regular member.
When you --re-add /dev/sdd1 you benefit from the fact that raid1
doesn't really care which device is in which slot (unlike raid5).
So re-adding something marked for slot 0 into slot 1 is perfectly
acceptable.
As the bitmap is present and uptodate, the recovery will be very fast.

I would recommend doing some basic checks for data consistency after
removing sdd1 and before re-adding it.  I might be wrong about
something and sdg1 might contain complete garbage - it never hurts to
check :-)

NeilBrown



>=20
>=20
> # mdadm -D /dev/md127 ; mdadm -E /dev/sdg1 ; mdadm -E /dev/sdd1
> /dev/md127:
>         Version : 1.2
>   Creation Time : Sat Jan 24 10:22:05 2015
>      Raid Level : raid1
>      Array Size : 976630464 (931.39 GiB 1000.07 GB)
>   Used Dev Size : 976630464 (931.39 GiB 1000.07 GB)
>    Raid Devices : 2
>   Total Devices : 2
>     Persistence : Superblock is persistent
>=20
>   Intent Bitmap : Internal
>=20
>     Update Time : Tue Jun 23 14:53:50 2015
>           State : clean, degraded=20
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>            Name : jail-lnx:ssd-array
>            UUID : a6277db4:da27d506:916a2c7a:d144aed6
>          Events : 9594760
>=20
>     Number   Major   Minor   RaidDevice State
>        2       8       97        0      active sync   /dev/sdg1
>        3       8       49        0      active sync   /dev/sdd1
>        2       0        0        2      removed
> /dev/sdg1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x11
>      Array UUID : a6277db4:da27d506:916a2c7a:d144aed6
>            Name : jail-lnx:ssd-array
>   Creation Time : Sat Jan 24 10:22:05 2015
>      Raid Level : raid1
>    Raid Devices : 2
>=20
>  Avail Dev Size : 1953261038 (931.39 GiB 1000.07 GB)
>      Array Size : 976630464 (931.39 GiB 1000.07 GB)
>   Used Dev Size : 1953260928 (931.39 GiB 1000.07 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=3D262056 sectors, after=3D110 sectors
>           State : clean
>     Device UUID : d5fd7437:1fd04c64:a9327851:b22e8008
>=20
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue Jun 23 14:53:50 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : fa563013 - correct
>          Events : 9594760
>=20
>=20
>    Device Role : Replacement device 0
>    Array State : R. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
> /dev/sdd1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : a6277db4:da27d506:916a2c7a:d144aed6
>            Name : jail-lnx:ssd-array
>   Creation Time : Sat Jan 24 10:22:05 2015
>      Raid Level : raid1
>    Raid Devices : 2
>=20
>  Avail Dev Size : 1953261038 (931.39 GiB 1000.07 GB)
>      Array Size : 976630464 (931.39 GiB 1000.07 GB)
>   Used Dev Size : 1953260928 (931.39 GiB 1000.07 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=3D262056 sectors, after=3D110 sectors
>           State : clean
>     Device UUID : fa65731c:d8c703be:bbf05cfe:c89740f2
>=20
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue Jun 23 14:53:50 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : cfb0b70c - correct
>          Events : 9594760
>=20
>=20
>    Device Role : Active device 0
>    Array State : R. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
