From: Hans-Peter Jansen <hpj@urpla.net>
Subject: Re: Problem with mdadm 3.2.5
Date: Thu, 28 Mar 2013 10:45:31 +0100
Message-ID: <9631874.mmRWitZ0Mk@xrated>
References: <11024273.158671364452562535.JavaMail.weblogic@epml26>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <11024273.158671364452562535.JavaMail.weblogic@epml26>
Sender: linux-raid-owner@vger.kernel.org
To: tarak.anumolu@samsung.com
Cc: Sam Bingner <sam@bingner.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Donnerstag, 28. M=E4rz 2013 06:36:03 Tarak Anumolu wrote:
> Hi
>=20
> FYI, We followed the below steps and At the end you can see the probl=
em with
> the file system.

Tarak, could you do me a flavor, and reread, what I've already written =
last=20
time? Then, attempt to answer the single question below, please.
=20
> RAID operation on 8 harddisks each of size 1TB with 7 harddisks as ra=
id
> devices and 1 hard disk as spare device got succeed.
=20
> #parted -s /dev/md0 print
> Model: Linux Software RAID Array (md)
> Disk /dev/md0: 6001GB
> Sector size (logical/physical): 512B/512B
> Partition Table: gpt
> Number  Start   End     Size    File system  Name     Flags
>  1      1049kB  60.0GB  60.0GB  xfs          primary
>  2      60.0GB  6001GB  5941GB  xfs          primary
>=20
>=20
> Then We create 2 partitions md0p1 and md0p2.
>=20
> #cat /proc/partitions
> major minor  #blocks  name
>   31        0       8192 mtdblock0
>   31        1     131072 mtdblock1
>    8        0  976762584 sda
>    8        1  976760832 sda1
>    8       16  976762584 sdb
>    8       17  976760832 sdb1
>    8       32  976762584 sdc
>    8       33  976760832 sdc1
>    8       48  976762584 sdd
>    8       49  976760832 sdd1
>    8       64  976762584 sde
>    8       65  976760832 sde1
>    8       80  976762584 sdf
>    8       81  976760832 sdf1
>    8       96  976762584 sdg
>    8       97  976760832 sdg1
>    8      112  976762584 sdh
>    8      113  976760832 sdh1
>    9        0 5860563456 md0
>  259        0   58604544 md0p1
>  259        1 5801957376 md0p2


Why do you insist in creating partitions in an already partitioned devi=
ce?

Just do:

mkfs.xfs /dev/md0
mount /dev/md0 /mnt

and be done. It *is* that easy.

md0p1 and md0p2 are obsolete in this scenario. If you need a more compl=
icated=20
setup, check out lvm.=20

Pete
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
