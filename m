From: Zoltan Szecsei <zoltans@geograph.co.za>
Subject: Re: Confusion with setting up new RAID6 with mdadm
Date: Mon, 15 Nov 2010 14:27:45 +0200
Message-ID: <4CE12741.6070803@geograph.co.za>
References: <4CE00206.4000301@geograph.co.za> <alpine.DEB.1.10.1011141745400.1154@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1011141745400.1154@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2010-11-14 18:48, Mikael Abrahamsson wrote:
>
>> *What is the correct fdisk or parted method get rid of the DOS & GPT=
=20
>> flags, and create a correctly aligned partition, and should this be =
a=20
>> 0xda partiton (& then I use metatdata 1.2 for mdadm)?
>
> I just "dd if=3D/dev/zero of=3D/dev/sdX bs=3D1024000 count=3D1" to ze=
ro the=20
> first megabyte of the drive to get rid of the partition table (you ge=
t=20
> rid of the v1.2 metadata at the same time actually). Then you know fo=
r=20
> sure you're correctly aligned as well as md is 4k aligned.
I did this on all 8 drives (/dev/sd[a-h])
root@gs0:/etc# dd if=3D/dev/zero of=3D/dev/sdb bs=3D1024000 count=3D1
1+0 records in
1+0 records out
1024000 bytes (1.0 MB) copied, 0.0103209 s, 99.2 MB/s
root@gs0:/etc# dd if=3D/dev/zero of=3D/dev/sdc bs=3D1024000 count=3D1

But the GPT id has not disappeared. I am going to use these drives=20
unpartitioned, so is this a problem?

Thanks,
Zoltan

root@gs0:/etc# fdisk -lu

WARNING: GPT (GUID Partition Table) detected on '/dev/sda'! The util=20
fdisk doesn't support GPT. Use GNU Parted.


Disk /dev/sda: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

Disk /dev/sda doesn't contain a valid partition table

WARNING: GPT (GUID Partition Table) detected on '/dev/sdb'! The util=20
fdisk doesn't support GPT. Use GNU Parted.


Disk /dev/sdb: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

Disk /dev/sdb doesn't contain a valid partition table

WARNING: GPT (GUID Partition Table) detected on '/dev/sdc'! The util=20
fdisk doesn't support GPT. Use GNU Parted.


Disk /dev/sdc: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

Disk /dev/sdc doesn't contain a valid partition table

WARNING: GPT (GUID Partition Table) detected on '/dev/sdd'! The util=20
fdisk doesn't support GPT. Use GNU Parted.


Disk /dev/sdd: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

Disk /dev/sdd doesn't contain a valid partition table

WARNING: GPT (GUID Partition Table) detected on '/dev/sde'! The util=20
fdisk doesn't support GPT. Use GNU Parted.


Disk /dev/sde: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

Disk /dev/sde doesn't contain a valid partition table

WARNING: GPT (GUID Partition Table) detected on '/dev/sdf'! The util=20
fdisk doesn't support GPT. Use GNU Parted.


Disk /dev/sdf: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

Disk /dev/sdf doesn't contain a valid partition table

WARNING: GPT (GUID Partition Table) detected on '/dev/sdg'! The util=20
fdisk doesn't support GPT. Use GNU Parted.


Disk /dev/sdg: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

Disk /dev/sdg doesn't contain a valid partition table

WARNING: GPT (GUID Partition Table) detected on '/dev/sdh'! The util=20
fdisk doesn't support GPT. Use GNU Parted.


Disk /dev/sdh: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

Disk /dev/sdh doesn't contain a valid partition table

Disk /dev/sdi: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders, total 976773168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000e30c7

    Device Boot      Start         End      Blocks   Id  System
/dev/sdi1   *        2048      391167      194560   83  Linux
Partition 1 does not end on cylinder boundary.
/dev/sdi2          393214   976771071   488188929    5  Extended
/dev/sdi5          393216    98047999    48827392   83  Linux
/dev/sdi6        98050048   110047231     5998592   82  Linux swap / So=
laris
/dev/sdi7       110049280   976771071   433360896   83  Linux
root@gs0:/etc#




--=20

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Zoltan Szecsei PrGISc [PGP0031]
Geograph (Pty) Ltd.
P.O. Box 7, Muizenberg 7950, South Africa.

65 Main Road, Muizenberg 7945
Western Cape, South Africa.

34=B0 6'16.35"S 18=B028'5.62"E

Tel: +27-21-7884897  Mobile: +27-83-6004028
=46ax: +27-86-6115323     www.geograph.co.za
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D



-----
No virus found in this message.
Checked by AVG - www.avg.com
Version: 10.0.1153 / Virus Database: 424/3257 - Release Date: 11/14/10

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
