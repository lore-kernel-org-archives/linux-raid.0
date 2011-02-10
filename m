From: Phil Turmel <philip@turmel.org>
Subject: Re: Linux software RAID assistance
Date: Thu, 10 Feb 2011 13:24:22 -0500
Message-ID: <4D542D56.1090802@turmel.org>
References: <4D540F6C.6050904@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D540F6C.6050904@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: simonmcnair@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Simon,

On 02/10/2011 11:16 AM, Simon McNair wrote:
>=20
[trim /]
>=20
> So I tried running mdadm --create --verbose /dev/md0 --metadata=3D1.1
> --level=3D5 --raid-devices=3D10 missing /dev/sde1 /dev/sdf1 /dev/sdg1
> /dev/sdh1 /dev/sdi1 /dev/sdj1 /dev/sdk1 /dev/sdl1 /dev/sdm1 --chunk=3D=
64

Uh-Oh.  You told mdadm to create an array with a missing member, but yo=
u didn't tell it to assume-clean.

> as it seemed that /dev/sdd1 failed to be added to the array.  This di=
d nothing.

According to your mdadm -E output below, it did what you asked:  it cre=
ated a new array from the devices given (note the new array UUID on the=
 nine devices).  Since you have one device missing, it can't rebuild, s=
o you might not have lost your data yet.

That mdadm -E /dev/sdd1 reports its array assembled and clean is odd.

Please show us the output of /proc/mdstat and then "mdadm -D /dev/md*" =
or "mdadm -D /dev/md/*"

Phil

>=20
> dmesg contains:
>=20
> md: invalid superblock checksum on sdd1
> md: sdd1 does not have a valid v1.1 superblock, not importing!
> md: md_import_device returned -22
>=20
> The output of mdadm -E is as follows:
>=20
> proxmox:~# mdadm -E /dev/sd[d-m]1
> /dev/sdd1:
>          Magic : a92b4efc
>        Version : 1.1
>    Feature Map : 0x0
>     Array UUID : c4f62f32:4244a1db:b7746203:f10b5227
>           Name : pro=C3=B8lox:0
>  Creation Time : Sat Aug 21 19:16:38 2010
>     Raid Level : raid5
>   Raid Devices : 10
>=20
>  Avail Dev Size : 1953099512 (931.31 GiB 999.99 GB)
>     Array Size : 17577894528 (8381.79 GiB 8999.88 GB)
>  Used Dev Size : 1953099392 (931.31 GiB 999.99 GB)
>    Data Offset : 264 sectors
>   Super Offset : 0 sectors
>          State : clean
>    Device UUID : b0ffd0a1:866676af:3ae4c03c:d219676e
>=20
>    Update Time : Mon Feb  7 21:08:29 2011
>       Checksum : 13aa9685 - expected 93aa9672
>         Events : 60802
>=20
>         Layout : left-symmetric
>     Chunk Size : 64K
>=20
>   Device Role : Active device 0
>   Array State : AAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sde1:
>          Magic : a92b4efc
>        Version : 1.1
>    Feature Map : 0x0
>     Array UUID : 7d55c29e:273c35da:f6438197:0365f95f
>           Name : ubuntu:0
>  Creation Time : Thu Feb 10 11:59:48 2011
>     Raid Level : raid5
>   Raid Devices : 10
>=20
>  Avail Dev Size : 1953099512 (931.31 GiB 999.99 GB)
>     Array Size : 17577894528 (8381.79 GiB 8999.88 GB)
>  Used Dev Size : 1953099392 (931.31 GiB 999.99 GB)
>    Data Offset : 264 sectors
>   Super Offset : 0 sectors
>          State : clean
>    Device UUID : 4121fa31:7543218c:f42a937d:fddf04e8
>=20
>    Update Time : Thu Feb 10 12:17:59 2011
>       Checksum : 5f965c84 - correct
>         Events : 4
>=20
>         Layout : left-symmetric
>     Chunk Size : 64K
>=20
>   Device Role : Active device 1
>   Array State : .AAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
