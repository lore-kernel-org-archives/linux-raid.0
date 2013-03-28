From: Hans-Peter Jansen <hpj@urpla.net>
Subject: Re: Problem with mdadm 3.2.5
Date: Thu, 28 Mar 2013 11:58:01 +0100
Message-ID: <12895316.zdg42hPEm0@xrated>
References: <F5.7A.08014.E1C14515@epcpsbgx2.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F5.7A.08014.E1C14515@epcpsbgx2.samsung.com>
Sender: linux-raid-owner@vger.kernel.org
To: tarak.anumolu@samsung.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keep ML cc'ed, please.

On Donnerstag, 28. M=E4rz 2013 10:31:58 Tarak Anumolu wrote:
> Hi Mr Peter
> Actually we are trying to implement RAID for an embedded device [NVR-=
Network
> Video Recorder]. For our device we need to have two partitions.
> Its a device structure in our legacy code.
> It's complicated to change into one partition so we are using the exi=
sting
> thing in our implementation.=20
> We will consider your suggestion to use LVM for making partitions.

Better partition your harddisks beforehand, eg.=20

sda1, sda2
sdb1, sdb2
=2E..

and create two mds:

md0: sda1, sdb1
md1: sda2, sdb2

=46or partitioning, you can do it once, and use sfdisk to copy partitio=
n tables=20
over, eg.:

fdisk /dev/sda

sfdisk -d /dev/sda | sfdisk /dev/sdb

What others said about the metadata version is still relevant.

Cheers,
Pete

> Thanks for the response
> Tarak
> =20
> =20
> =20
> =20
> =20
> ------- Original Message -------
> Sender : Hans-Peter Jansen<hpj@urpla.net>
> Date : Mar 28, 2013 18:45 (GMT+09:00)
> Title : Re: Problem with mdadm 3.2.5
> =20
>=20
> On Donnerstag, 28. M=E4rz 2013 06:36:03 Tarak Anumolu wrote:
> > Hi
> >=20
> > FYI, We followed the below steps and At the end you can see the pro=
blem
> > with the file system.
>=20
> Tarak, could you do me a flavor, and reread, what I've already writte=
n last
> time? Then, attempt to answer the single question below, please.
>=20
> > RAID operation on 8 harddisks each of size 1TB with 7 harddisks as =
raid
> > devices and 1 hard disk as spare device got succeed.
> >=20
> > #parted -s /dev/md0 print
> > Model: Linux Software RAID Array (md)
> > Disk /dev/md0: 6001GB
> > Sector size (logical/physical): 512B/512B
> > Partition Table: gpt
> > Number  Start   End     Size    File system  Name     Flags
> >
> >  1      1049kB  60.0GB  60.0GB  xfs          primary
> >  2      60.0GB  6001GB  5941GB  xfs          primary
> >
> > Then We create 2 partitions md0p1 and md0p2.
> >=20
> > #cat /proc/partitions
> > major minor  #blocks  name
> >
> >   31        0       8192 mtdblock0
> >   31        1     131072 mtdblock1
> >    8        0  976762584 sda
> >    8        1  976760832 sda1
> >    8       16  976762584 sdb
> >    8       17  976760832 sdb1
> >    8       32  976762584 sdc
> >    8       33  976760832 sdc1
> >    8       48  976762584 sdd
> >    8       49  976760832 sdd1
> >    8       64  976762584 sde
> >    8       65  976760832 sde1
> >    8       80  976762584 sdf
> >    8       81  976760832 sdf1
> >    8       96  976762584 sdg
> >    8       97  976760832 sdg1
> >    8      112  976762584 sdh
> >    8      113  976760832 sdh1
> >    9        0 5860563456 md0
> >  259        0   58604544 md0p1
> >  259        1 5801957376 md0p2
>=20
> Why do you insist in creating partitions in an already partitioned de=
vice?
>=20
> Just do:
>=20
> mkfs.xfs /dev/md0
> mount /dev/md0 /mnt
>=20
> and be done. It *is* that easy.
>=20
> md0p1 and md0p2 are obsolete in this scenario. If you need a more
> complicated setup, check out lvm.
>=20
> Pete
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
