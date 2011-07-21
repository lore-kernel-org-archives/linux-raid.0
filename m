From: Erwan Leroux <erwan.lerou@gmail.com>
Subject: Re: standard performance (write speed 20Mb/s)
Date: Thu, 21 Jul 2011 10:55:14 +0200
Message-ID: <CAHX8RiR0MV1iL_OfrVAKGjr0gj7zxtuxFSzMijSgNfKcs0Zz0Q@mail.gmail.com>
References: <201107181403.49563.raid1@fuckaround.org> <4E26CAA7.8030201@hardwarefreak.com>
 <c5a1a83b370a0ddb063cfc828f124e6d.squirrel@fuckaround.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c5a1a83b370a0ddb063cfc828f124e6d.squirrel@fuckaround.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

following is how i configured advanced format drives for raid 5
i created one partition on each disk

fdisk -u /dev/sdX
# -u change the unit displayed by fdisk to sector instead of
cylinders, this way it's easier to configure

# the table partition isn't really modifier until you send the w
command, so if you messed up use the q to quit and restart

#delete first partition of the disk, repeat until you had cleared the d=
isk
d

# create a new partition
n

# select primary parition
p

#select number one (don't know if number is important, i guess it's
means /dev/sdX1)
1

#select first sector, here is the catch, to properly align the disk, se=
lect 64
64

#select default for the last sector
<enter>

# Change type of partition

#https://raid.wiki.kernel.org/index.php/Partition_Types
#according to this link if you use the option --metadata 1.2 with
madadm --create
# it's better to use the type DA (Non-FS data) instead of FD (Linux
raid auto) but i can't found why
# you can stick to FD, it's what is i used
t
DA or FD

# commit the change so double check the setup with the p command before=
 do it
w

Repeat the setup for each advanced format drives and you should be good

to show you the result, here is the result of fdisk -l
WARNING: GPT (GUID Partition Table) detected on '/dev/sda'! The util
fdisk doesn't support GPT. Use GNU Parted.


Disk /dev/sda: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1      243202  1953514552   fd  Linux raid auto=
detect

WARNING: GPT (GUID Partition Table) detected on '/dev/sdb'! The util
fdisk doesn't support GPT. Use GNU Parted.


Disk /dev/sdb: 2000.4 GB, 2000398934016 bytes
256 heads, 63 sectors/track, 242251 cylinders
Units =3D cylinders of 16128 * 512 =3D 8257536 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1      242252  1953514552   fd  Linux raid auto=
detect

Disk /dev/sdc: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x78e9148d

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1      243202  1953514552   fd  Linux raid auto=
detect

WARNING: GPT (GUID Partition Table) detected on '/dev/sdd'! The util
fdisk doesn't support GPT. Use GNU Parted.


Disk /dev/sdd: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1      243202  1953514552   fd  Linux raid auto=
detect

WARNING: GPT (GUID Partition Table) detected on '/dev/sde'! The util
fdisk doesn't support GPT. Use GNU Parted.


Disk /dev/sde: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sde1               1      243202  1953514552   fd  Linux raid auto=
detect

WARNING: GPT (GUID Partition Table) detected on '/dev/sdf'! The util
fdisk doesn't support GPT. Use GNU Parted.


Disk /dev/sdf: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdf1               1      243202  1953514552   fd  Linux raid auto=
detect

Disk /dev/md0: 10002.0 GB, 10001978490880 bytes
2 heads, 4 sectors/track, -1853078016 cylinders
Units =3D cylinders of 8 * 512 =3D 4096 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 2097152 bytes / 10485760 bytes
Disk identifier: 0x00000000

Disk /dev/md0 doesn't contain a valid partition table


2011/7/20 Pol Hallen <raid1@fuckaround.org>
>
> > This mishmash combo of drives, including two WD Green Advanced Form=
at
> > drives, is likely the cause of the horrible write performance. =A0Y=
ou're
> > assembling the array from partitions.
>
> first of all: sorry but my english is not good :-(
>
> In many howto I read:
>
> "create a partition of disk and change it to "fd" code: linux raid
> autodetect"
>
> Now I re-done whole raid (I already have a backup)
>
> I have to create a partition on sigle disk? or remove any partition a=
nd stop?
>
> > =A0The partitions on the WD20EARS
> > drives are undoubtedly not 4KB sector aligned, causing excessive
> > read-modify-write cycles. =A0See:
> > http://en.wikipedia.org/wiki/Advanced_Format
> > Repartition the Green drives with proper alignment. =A0If you still=
 have
> > issues we'll go from there. =A0Note: =A0Having 3 dissimilar drives =
in an
> > array is never going to be an optimally performing solution.
>
> Now I re-create a new raid system with 6 disks (everyone 2Tb wd)
>
> How do about 4Kb sector align?
>
> thanks!
>
> Pol
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
