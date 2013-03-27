From: Sam Bingner <sam@bingner.com>
Subject: Re: Need some information about mdadm 3.2.5
Date: Wed, 27 Mar 2013 10:51:32 +0000
Message-ID: <4243BB9A-D764-40FF-BD33-611F72C4C0E5@bingner.com>
References: <29343933.117831364361439771.JavaMail.weblogic@epml26>
 <3054921.TrJcO0kqP2@xrated>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3054921.TrJcO0kqP2@xrated>
Content-Language: en-US
Content-ID: <18D11573D2231941AD93C9DF4B7F3214@ds.sbdhi.com>
Sender: linux-raid-owner@vger.kernel.org
To: "tarak.anumolu@samsung.com" <tarak.anumolu@samsung.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mar 26, 2013, at 11:28 PM, Hans-Peter Jansen <hpj@urpla.net> wrote:

> Hi Tarak,
>=20
> On Mittwoch, 27. M=E4rz 2013 05:17:19 Tarak Anumolu wrote:
>> Hi
>>=20
>> My name is TARAK.
>>=20
>> We got some problem in using mdadm 3.2.5.
>>=20
>> We are trying to do RAID operation on 8 harddisks each of size 1TB w=
ith 7
>> harddisks as raid devices and 1 hard disk as spare device.
>=20
>> Command : mdadm -C /dev/md0 -f --meta-version 0.9 -l5 -n7 -x1 /dev/s=
d[a-h]1
>=20
> Obviously, you already created partitions on your harddisks.
>=20
>> After the RAID operation is completed when we check the status,
>=20
> Beware, the raid creation is a long process, working in background.
>=20
> To check your md, use: "cat /proc/mdstat". This is the most important=
 command=20
> in using linux md.
>=20
>> We are
>> getting the following errors.
>=20
>> # parted - s  /dev/md0 print
>> Model: Linux Software RAID Array (md)
>> Disk /dev/md0: 6001GB
>> Sector size (logical/physical): 512B/512B
>> Partition Table: gpt
>> Number Start End Size File system Name Flags
>> 1 1049kB 60.0GB 60.0GB xfs primary
>> 2 60.0GB 6001GB 5941GB primary
>=20
> Now, you want to access the md partition as a harddisk?!?
>=20
> What you're trying to do makes little sense. Think of the md partitio=
n as an=20
> ordinary one. Partitioning happens *before* md creation (if necessary=
 at all,=20
> as you can create your mds directly on the harddisks, as long as you =
need just=20
> one md, and don't want to boot from it). The *next* logical step here=
 is=20
> creating a filesystem on the md partition.=20
>=20
> E.g.: mkfs.xfs /dev/md0
>=20
> Then assign a mount point (in /etc/fstab), and use it. Call back (to =
this ML),=20
> when you reached this point, as there are a few more important steps =
to follow=20
> for maximum enjoyment.
>=20
> Cheers,
> Pete
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


I would only add that if you do want to split it into smaller sections,=
 you may be interested in LVM on RAID.  I also wonder why you chose met=
adata 0.9 as that limits you in the future if you ever wish to use larg=
e devices (>2TB or 4TB depending on your kernel)
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
