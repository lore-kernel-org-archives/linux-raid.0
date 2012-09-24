From: =?ISO-8859-1?Q?G=FCnther_J=2E?= Niederwimmer <gjn@gjn.priv.at>
Subject: Re: Hello,Re: GPT Table broken on a Raid1
Date: Mon, 24 Sep 2012 09:28:10 +0200
Message-ID: <4838005.Z2kBBljtsi@techz>
References: <4961154.0TR9MeFlIq@techz> <1822898.lj0EyHG9Nm@techz> <8CD3CA16-FC0C-462E-BAA5-70F993300867@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8CD3CA16-FC0C-462E-BAA5-70F993300867@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Chris,

Am Sonntag, 23. September 2012, 01:17:43 schrieb Chris Murphy:
> On Sep 23, 2012, at 12:47 AM, G=FCnther J. Niederwimmer wrote:
> > OK, the system is running but never start parted or a other tool an=
d say
> > to
> > anything yes, then you have a destroyed system :(
>=20
> This will not destroy anything
>=20
> parted -l

Error: The backup GPT table is not at the end of the disk, as it should=
 be.
This might mean that another operating system believes the disk is smal=
ler.
=46ix, by moving the backup to the end (and removing the old backup)?
=46ix/Ignore/Cancel? =20

Now I know, do NOT Fix ;).

Error: The backup GPT table is not at the end of the disk, as it should=
 be.
This might mean that another operating system believes the disk is smal=
ler.
=46ix, by moving the backup to the end (and removing the old backup)?
=46ix/Ignore/Cancel? i                                                 =
    =20
Warning: Not all of the space available to /dev/sda appears to be used,=
 you=20
can fix the GPT to use all
of the space (an extra 4784 blocks) or continue with the current settin=
g?=20
=46ix/Ignore? i                                                        =
    =20
Model: ATA ST3320620AS (scsi)
Disk /dev/sda: 320GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt_sync_mbr

Number  Start   End    Size    File system  Name                       =
  =20
=46lags
 1      1049kB  106MB  105MB   fat32        EFI system partition       =
   boot
 2      106MB   240MB  134MB                Microsoft reserved partitio=
n =20
msftres
 3      240MB   105GB  105GB   ntfs         Basic data partition
 4      105GB   190GB  84,9GB  ntfs         Basic data partition
 5      190GB   212GB  22,0GB  ntfs         Basic data partition
 6      212GB   268GB  55,6GB  ext4         Basic data partition


Error: The backup GPT table is not at the end of the disk, as it should=
 be. =20
This might mean that
another operating system believes the disk is smaller.  Fix, by moving =
the=20
backup to the end (and
removing the old backup)?
=46ix/Ignore/Cancel? I                                                 =
    =20
Model: ATA ST3320620AS (scsi)
Disk /dev/sdb: 320GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt_sync_mbr

Number  Start   End    Size    File system  Name                       =
  =20
=46lags
 1      1049kB  106MB  105MB   fat32        EFI system partition       =
   boot
 2      106MB   240MB  134MB                Microsoft reserved partitio=
n =20
msftres
 3      240MB   105GB  105GB   ntfs         Basic data partition
 4      105GB   190GB  84,9GB  ntfs         Basic data partition
 5      190GB   212GB  22,0GB  ntfs         Basic data partition
 6      212GB   268GB  55,6GB  ext4         Basic data partition


Model: ATA ST3320613AS (scsi)
Disk /dev/sdc: 320GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos

Number  Start   End    Size   Type     File system  Flags
 1      1049kB  320GB  320GB  primary  ext4         type=3D83


Model: ATA ST3320613AS (scsi)
Disk /dev/sdd: 320GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos

Number  Start   End     Size    Type     File system     Flags
 1      1049kB  4392MB  4391MB  primary  linux-swap(v1)  type=3D82
 2      4392MB  320GB   316GB   primary  ext4            type=3D83


Model: ATA OCZ-VERTEX4 (scsi)
Disk /dev/sde: 256GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End    Size   File system  Name     Flags
 1      1049kB  181MB  180MB  fat32        primary  boot
 2      181MB   116GB  116GB               primary


Model: Linux Software RAID Array (md)
Disk /dev/md126: 320GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt_sync_mbr

Number  Start   End    Size    File system  Name                       =
  =20
=46lags
 1      1049kB  106MB  105MB   fat32        EFI system partition       =
   boot
 2      106MB   240MB  134MB                Microsoft reserved partitio=
n =20
msftres
 3      240MB   105GB  105GB   ntfs         Basic data partition
 4      105GB   190GB  84,9GB  ntfs         Basic data partition
 5      190GB   212GB  22,0GB  ntfs         Basic data partition
 6      212GB   268GB  55,6GB  ext4         Basic data partition


> or
>=20
> gdisk -l /dev/sda

GPT fdisk (gdisk) version 0.8.5

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

=46ound valid GPT with protective MBR; using GPT.
Disk /dev/sda: 625142448 sectors, 298.1 GiB
Logical sector size: 512 bytes
Disk identifier (GUID): AD126626-066E-448E-ABA2-1ACFDCBA8326
Partition table holds up to 128 entries
=46irst usable sector is 34, last usable sector is 625137630
Partitions will be aligned on 2048-sector boundaries
Total free space is 102406077 sectors (48.8 GiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048          206847   100.0 MiB   EF00  EFI system par=
tition
   2          206848          468991   128.0 MiB   0C01  Microsoft rese=
rved=20
part
   3          468992       205297663   97.7 GiB    0700  Basic data par=
tition
   4       205297664       371181567   79.1 GiB    0700  Basic data par=
tition
   5       371181568       414189567   20.5 GiB    0700  Basic data par=
tition
   6       414189568       522733567   51.8 GiB    0700  Basic data par=
tition


> gdisk -l /dev/sdb

GPT fdisk (gdisk) version 0.8.5

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

=46ound valid GPT with protective MBR; using GPT.
Disk /dev/sdb: 625142448 sectors, 298.1 GiB
Logical sector size: 512 bytes
Disk identifier (GUID): AD126626-066E-448E-ABA2-1ACFDCBA8326
Partition table holds up to 128 entries
=46irst usable sector is 34, last usable sector is 625137630
Partitions will be aligned on 2048-sector boundaries
Total free space is 102406077 sectors (48.8 GiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048          206847   100.0 MiB   EF00  EFI system par=
tition
   2          206848          468991   128.0 MiB   0C01  Microsoft rese=
rved=20
part
   3          468992       205297663   97.7 GiB    0700  Basic data par=
tition
   4       205297664       371181567   79.1 GiB    0700  Basic data par=
tition
   5       371181568       414189567   20.5 GiB    0700  Basic data par=
tition
   6       414189568       522733567   51.8 GiB    0700  Basic data par=
tition


> gdisk -l /dev/md126

GPT fdisk (gdisk) version 0.8.5

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

=46ound valid GPT with protective MBR; using GPT.
Disk /dev/md126: 625137664 sectors, 298.1 GiB
Logical sector size: 512 bytes
Disk identifier (GUID): AD126626-066E-448E-ABA2-1ACFDCBA8326
Partition table holds up to 128 entries
=46irst usable sector is 34, last usable sector is 625137630
Partitions will be aligned on 2048-sector boundaries
Total free space is 102406077 sectors (48.8 GiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048          206847   100.0 MiB   EF00  EFI system par=
tition
   2          206848          468991   128.0 MiB   0C01  Microsoft rese=
rved=20
part
   3          468992       205297663   97.7 GiB    0700  Basic data par=
tition
   4       205297664       371181567   79.1 GiB    0700  Basic data par=
tition
   5       371181568       414189567   20.5 GiB    0700  Basic data par=
tition
   6       414189568       522733567   51.8 GiB    0700  Basic data par=
tition



> I think those disks have latent GPTs on them and that's the source of=
 the
> (likely ignorable) problem.
;)=20

I mean this is a little to high for me :(.


But I have one Question more.

Is this also the same Problem with the GPT Table.

I make a Test installation before, with dmraid for the Raid1. The /home=
=20
Directory on the Raid1, all other on the SSD.

After the Installation the most time the System have a Problem to mount=
 the=20
"/home" or a other Partition on the Raid1 and fall down in the repair m=
ode.

But the good thing from this, Grub2 found my Windows 7 Installation on =
the=20
Raid1 and Make a Start Entry, with mdadm this is not working, Grub2 don=
't=20
found the windows?

--=20
mit freundlichen Gr=FC=DFen / best Regards.

  G=FCnther J. Niederwimmer
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
