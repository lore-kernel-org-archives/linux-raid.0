From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid Problem - Unknown File System Type
Date: Wed, 09 Nov 2011 22:57:09 -0500
Message-ID: <4EBB4B95.6040309@turmel.org>
References: <4EBAA68B.6090906@rogers.com> <20111109163933.GA26630@cthulhu.home.robinhill.me.uk> <4EBAB47C.5070002@rogers.com> <4EBACC88.8070403@turmel.org> <4EBADB1E.1070700@rogers.com> <4EBADD07.5030109@turmel.org> <4EBAE90F.2030104@rogers.com> <4EBAF46C.2030001@turmel.org> <4EBB46A5.8080305@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EBB46A5.8080305@rogers.com>
Sender: linux-raid-owner@vger.kernel.org
To: William Colls <william.colls@rogers.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/09/2011 10:36 PM, William Colls wrote:
> [ .... ]
>>
>> OK. So that wasn't it.  GRUB is in the first sector, with a MBR part=
ition table identifying a single 750G partition starting at sector 63.
>=20
> The array was not bootable in its original configuration, so I am sur=
prised that GRUB would be on the disk, but the single partition of 750G=
 is correct.
>=20
>> So something else is wrong.  Maybe your kernel is different, and jus=
t doesn't have the module for the FS.  Or one of the BIOSes messes with=
 the apparent disk capacity.  Or something else is interfering.
>>
>> Please show:
>>
>> cat /proc/filesystems >
>=20
> nodev   sysfs
> nodev   rootfs
> nodev   bdev
> nodev   proc
> nodev   cgroup
> nodev   cpuset
> nodev   tmpfs
> nodev   devtmpfs
> nodev   debugfs
> nodev   securityfs
> odev   sockfs
> nodev   pipefs
> nodev   anon_inodefs
> nodev   inotifyfs
> nodev   devpts
>         ext3
>         ext2
>         ext4
> nodev   ramfs
> nodev   hugetlbfs
> nodev   ecryptfs
> nodev   fuse
>         fuseblk
> nodev   fusectl
> nodev   mqueue
>         vfat
>         iso9660

Hmmm.  None of the common extras, like reiserfs, xfs, or jfs.  Nor supp=
ort for DVDs w/ udf.

>> cat /proc/partitions
>=20
> major minor  #blocks  name
>=20
>    8        0  312571224 sda
>    8        1  306929664 sda1
>    8        2          1 sda2
>    8        5    5639168 sda5
>    8       16  732574584 sdb
>    8       32  732574584 sdc
>    9        0  732574464 md0
>  259        0  732572001 md0p1

OK.

>> fdisk -l
>=20
> Disk /dev/sda: 320.1 GB, 320072933376 bytes
> 255 heads, 63 sectors/track, 38913 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x000b9f04
>=20
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sda1   *           1       38212   306929664   83  Linux
> /dev/sda2           38212       38914     5639169    5  Extended
> /dev/sda5           38212       38914     5639168   82  Linux swap / =
Solaris
>=20
> Disk /dev/sdb: 750.2 GB, 750156374016 bytes
> 255 heads, 63 sectors/track, 91201 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x000bb73e
>=20
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1   *           1       91201   732572001   83  Linux
>=20
> Disk /dev/sdc: 750.2 GB, 750156374016 bytes
> 255 heads, 63 sectors/track, 91201 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x000bb73e
>=20
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdc1   *           1       91201   732572001   83  Linux
>=20
> Disk /dev/md0: 750.2 GB, 750156251136 bytes
> 255 heads, 63 sectors/track, 91201 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x000bb73e
>=20
>     Device Boot      Start         End      Blocks   Id  System
> /dev/md0p1   *           1       91201   732572001   83  Linux

OK.

>> lsdrv
>=20
> **Warning** The following utility(ies) failed to execute:
>   sginfo
>   pvs
>   lvs
> Some information may be missing.

Missing pvs and lvs means LVM is not installed.  Do you recall if the a=
rray was mounted directly?

> PCI [pata_atiixp] 00:14.1 IDE interface: ATI Technologies Inc SB600 I=
DE
>  =E2=94=9C=E2=94=80scsi 0:0:0:0 ATA WDC WD3200AAJB-0
>  =E2=94=82  =E2=94=94=E2=94=80sda: [8:0] Empty/Unknown 298.09g
>  =E2=94=82     =E2=94=9C=E2=94=80sda1: [8:1] Empty/Unknown 292.71g
>  =E2=94=82     =E2=94=82  =E2=94=94=E2=94=80Mounted as /dev/disk/by-u=
uid/0a85841d-6b71-43ba-8558-3f86dce72359 @ /
>  =E2=94=82     =E2=94=9C=E2=94=80sda2: [8:2] Empty/Unknown 1.00k
>  =E2=94=82     =E2=94=94=E2=94=80sda5: [8:5] Empty/Unknown 5.38g
>  =E2=94=94=E2=94=80scsi 1:x:x:x [Empty]
> PCI [ahci] 00:12.0 SATA controller: ATI Technologies Inc SB600 Non-Ra=
id-5 SATA
>  =E2=94=9C=E2=94=80scsi 2:0:0:0 ATA WDC WD7500AAKS-0
>  =E2=94=82  =E2=94=94=E2=94=80sdb: [8:16] Empty/Unknown 698.64g
>  =E2=94=82     =E2=94=94=E2=94=80md0: [9:0] Empty/Unknown 698.64g
>  =E2=94=82        =E2=94=94=E2=94=80md0p1: [259:0] Empty/Unknown 698.=
64g
>  =E2=94=9C=E2=94=80scsi 3:0:0:0 ASUS DRW-24B1ST   a {B2D0CL124266}
>  =E2=94=82  =E2=94=94=E2=94=80sr0: [11:0] Empty/Unknown 1.00g
>  =E2=94=9C=E2=94=80scsi 4:0:0:0 ATA WDC WD7500AAKS-0
>  =E2=94=82  =E2=94=94=E2=94=80sdc: [8:32] Empty/Unknown 698.64g
>  =E2=94=94=E2=94=80scsi 5:x:x:x [Empty]
> Other Block Devices
>  =E2=94=9C=E2=94=80ram0: [1:0] Empty/Unknown 64.00m
>  =E2=94=9C=E2=94=80ram1: [1:1] Empty/Unknown 64.00m
>  =E2=94=9C=E2=94=80ram2: [1:2] Empty/Unknown 64.00m
>  =E2=94=9C=E2=94=80ram3: [1:3] Empty/Unknown 64.00m
>  =E2=94=9C=E2=94=80ram4: [1:4] Empty/Unknown 64.00m
>  =E2=94=9C=E2=94=80ram5: [1:5] Empty/Unknown 64.00m
>  =E2=94=9C=E2=94=80ram6: [1:6] Empty/Unknown 64.00m
>  =E2=94=9C=E2=94=80ram7: [1:7] Empty/Unknown 64.00m
>  =E2=94=9C=E2=94=80ram8: [1:8] Empty/Unknown 64.00m
>  =E2=94=9C=E2=94=80ram9: [1:9] Empty/Unknown 64.00m
>  =E2=94=9C=E2=94=80ram10: [1:10] Empty/Unknown 64.00m
>  =E2=94=9C=E2=94=80ram11: [1:11] Empty/Unknown 64.00m
>  =E2=94=9C=E2=94=80ram12: [1:12] Empty/Unknown 64.00m
>  =E2=94=9C=E2=94=80ram13: [1:13] Empty/Unknown 64.00m
>  =E2=94=9C=E2=94=80ram14: [1:14] Empty/Unknown 64.00m
>  =E2=94=94=E2=94=80ram15: [1:15] Empty/Unknown 64.00m

No surprises, but not enough information.

>> ... and repeat on the old system if at all possible.  Preferably wit=
h one of the disks plugged back into it.
>=20
> The old system is not available

Unfortunate.

Please show a hexdump of the first 8k of /dev/md0p1.  That should give =
us a signature to hunt down.

In the meantime, consider installing some FS support packages:

xfsprogs
reiserfsprogs
jfsutils
btrfs-tools
udftools
lvm2


Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
