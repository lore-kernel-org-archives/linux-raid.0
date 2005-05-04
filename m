From: Herta Van den Eynde <herta.vandeneynde@cc.kuleuven.be>
Subject: Re: mdadm create size problem
Date: Wed, 04 May 2005 11:51:32 +0200
Message-ID: <42789B24.6040206@cc.kuleuven.be>
References: <4277825A.1070405@cc.kuleuven.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4277825A.1070405@cc.kuleuven.be>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

OK, there's definitely something wrong here.  I ran a
# mdadm --zero-superblock --force /dev/sdX
followed by
# dd if=3D/dev/zero of=3D/dev/sdX bs=3D64k
where X=3D[g-in-p], and when I try to create a RAID 1 using two of thes=
e
devices, it still sets the size to 139904K.  When I create a RAID 0
using the same devices, mdadm does set the size correctly.

# mdadm --create --verbose /dev/md6 --level=3D1 --raid-devices=3D2 /dev=
/sdh
/dev/sdo
mdadm: size set to 139904K
mdadm: array /dev/md6 started.

# mdadm --create --verbose /dev/md6 --level=3D0 --raid-devices=3D2 /dev=
/sdh
/dev/sdo
mdadm: chunk size defaults to 64K
mdadm: array /dev/md6 started.
# mke2fs -j -v  /dev/md6
(...)
# mount /dev/md6 /mnt; df /mnt
=46ilesystem           1k-blocks      Used Available Use% Mounted on
/dev/md6             141124600     32828 133923052   1% /mnt

Is this a bug, or am I overlooking something?

Herta


Herta Van den Eynde wrote:
> Red Hat AS 2.1 mdadm 1.11
> I have two devices that used to be part of a now corrupt RAID10=20
> configuration.  When I try to reuse them to create a RAID1, it only u=
ses=20
> about 1 third of the diskspace available.
> # fdisk -l /dev/sdg
>=20
> Disk /dev/sdg: 255 heads, 63 sectors, 8924 cylinders
> Units =3D cylinders of 16065 * 512 bytes
>=20
>    Device Boot    Start       End    Blocks   Id  System
> /dev/sdg1             1      8924  71681998+  fd  Linux raid autodete=
ct
>=20
> # fdisk -l /dev/sdn
>=20
> Disk /dev/sdn: 255 heads, 63 sectors, 8924 cylinders
> Units =3D cylinders of 16065 * 512 bytes
>=20
>    Device Boot    Start       End    Blocks   Id  System
> /dev/sdn1             1      8924  71681998+  fd  Linux raid autodete=
ct
>=20
> # mdadm --create --verbose /dev/md5 --level=3D1 --raid-devices=3D2 /d=
ev/sdg=20
> /dev/sdn
> mdadm: /dev/sdg appears to contain an ext2fs file system
>     size=3D419520K  mtime=3DMon May  2 17:04:04 2005
> mdadm: /dev/sdn appears to contain an ext2fs file system
>     size=3D419520K  mtime=3DMon May  2 17:04:04 2005
> mdadm: size set to 139904K
> Continue creating array? n
>=20
> If I try to add the --size option, even a size that is 139904K or les=
s,=20
> it tells me the size is invalid:
>=20
> # mdadm --create --verbose /dev/md5 --level=3D1 --raid-devices=3D2 /d=
ev/sdg=20
> /dev/sdn --size=3D139904K
> mdadm: invalid size: 139904K
>=20
> I did reboot the system after fdisk'ing the devices.
>=20
> Do I need to low-level format these devices to be able to reuse them?
>=20
> Kind regards,
>=20
> Herta
>=20

--=20
Herta Van den Eynde              -=3D- Toledo system management
K.U. Leuven - Ludit              -=3D- phone: +32 (0)16 322 166
                                  -=3D- 50=B051'27" N 004=B040'39" E

"I wish I were two little cats.  Then I could play together."

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
