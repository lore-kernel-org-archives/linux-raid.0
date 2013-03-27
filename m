From: Hans-Peter Jansen <hpj@urpla.net>
Subject: Re: Need some information about mdadm 3.2.5
Date: Wed, 27 Mar 2013 10:28:23 +0100
Message-ID: <3054921.TrJcO0kqP2@xrated>
References: <29343933.117831364361439771.JavaMail.weblogic@epml26>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <29343933.117831364361439771.JavaMail.weblogic@epml26>
Sender: linux-raid-owner@vger.kernel.org
To: tarak.anumolu@samsung.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Tarak,

On Mittwoch, 27. M=E4rz 2013 05:17:19 Tarak Anumolu wrote:
> Hi
>=20
> My name is TARAK.
>=20
> We got some problem in using mdadm 3.2.5.
>=20
> We are trying to do RAID operation on 8 harddisks each of size 1TB wi=
th 7
> harddisks as raid devices and 1 hard disk as spare device.
=20
> Command : mdadm -C /dev/md0 -f --meta-version 0.9 -l5 -n7 -x1 /dev/sd=
[a-h]1

Obviously, you already created partitions on your harddisks.

> After the RAID operation is completed when we check the status,

Beware, the raid creation is a long process, working in background.

To check your md, use: "cat /proc/mdstat". This is the most important c=
ommand=20
in using linux md.

> We are
> getting the following errors.
=20
>  # parted - s  /dev/md0 print
>  Model: Linux Software RAID Array (md)
>  Disk /dev/md0: 6001GB
>  Sector size (logical/physical): 512B/512B
>  Partition Table: gpt
>  Number Start End Size File system Name Flags
>  1 1049kB 60.0GB 60.0GB xfs primary
>  2 60.0GB 6001GB 5941GB primary

Now, you want to access the md partition as a harddisk?!?

What you're trying to do makes little sense. Think of the md partition =
as an=20
ordinary one. Partitioning happens *before* md creation (if necessary a=
t all,=20
as you can create your mds directly on the harddisks, as long as you ne=
ed just=20
one md, and don't want to boot from it). The *next* logical step here i=
s=20
creating a filesystem on the md partition.=20

E.g.: mkfs.xfs /dev/md0

Then assign a mount point (in /etc/fstab), and use it. Call back (to th=
is ML),=20
when you reached this point, as there are a few more important steps to=
 follow=20
for maximum enjoyment.

Cheers,
Pete

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
