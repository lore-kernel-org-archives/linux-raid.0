From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: standard performance (write speed 20Mb/s)
Date: Wed, 20 Jul 2011 19:02:04 -0500
Message-ID: <4E276C7C.9050103@hardwarefreak.com>
References: <201107181403.49563.raid1@fuckaround.org>	<4E26CAA7.8030201@hardwarefreak.com>	<c5a1a83b370a0ddb063cfc828f124e6d.squirrel@fuckaround.org> <CADNH=7HR7euaWem0tpLxJfRe0hYnRP5fwxJ6MC5vJeNf=T=PzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7HR7euaWem0tpLxJfRe0hYnRP5fwxJ6MC5vJeNf=T=PzA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
Cc: Pol Hallen <raid1@fuckaround.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7/20/2011 3:17 PM, Mathias Bur=C3=A9n wrote:

> FWIW this is my RAID6 setup:
>=20
> $ sudo fdisk -l /dev/sd[b,c,d,e,f,g,h]
> Password:

Are these indeed advanced format drives?  You didn't provide model#s or
manufacturer product line.  The only clue we have that they might be AF
drives is the 2048 offset you created.  Unless I simply missed it.

> Disk /dev/sdb: 2000.4 GB, 2000398934016 bytes
> 81 heads, 63 sectors/track, 765633 cylinders, total 3907029168 sector=
s
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x0e5b3a7a
>=20
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1            2048  3907029167  1953513560   fd  Linux raid
> autodetect
>=20
> Disk /dev/sdc: 2000.4 GB, 2000398934016 bytes
> 81 heads, 63 sectors/track, 765633 cylinders, total 3907029168 sector=
s
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x4fc36d54
>=20
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdc1            2048  3907029167  1953513560   fd  Linux raid
> autodetect
>=20
> Disk /dev/sdd: 2000.4 GB, 2000398934016 bytes
> 81 heads, 63 sectors/track, 765633 cylinders, total 3907029168 sector=
s
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x9e716ecb
>=20
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdd1            2048  3907029167  1953513560   fd  Linux raid
> autodetect
>=20
> Disk /dev/sde: 2000.4 GB, 2000398934016 bytes
> 81 heads, 63 sectors/track, 765633 cylinders, total 3907029168 sector=
s
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x629ab77f
>=20
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sde1            2048  3907029167  1953513560   fd  Linux raid
> autodetect
>=20
> Disk /dev/sdf: 2000.4 GB, 2000398934016 bytes
> 123 heads, 18 sectors/track, 1764692 cylinders, total 3907029168 sect=
ors
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x3d454f20
>=20
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdf1            2048  3907029167  1953513560   fd  Linux raid
> autodetect
>=20
> Disk /dev/sdg: 2000.4 GB, 2000398934016 bytes
> 81 heads, 63 sectors/track, 765633 cylinders, total 3907029168 sector=
s
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x918fae9f
>=20
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdg1            2048  3907029167  1953513560   fd  Linux raid
> autodetect
>=20
> Disk /dev/sdh: 2000.4 GB, 2000398934016 bytes
> 123 heads, 18 sectors/track, 1764692 cylinders, total 3907029168 sect=
ors
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x0ac81a1b
>=20
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdh1            2048  3907029167  1953513560   fd  Linux raid
> autodetect

--=20
Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
