From: Norman Schmidt <norman.schmidt@chemie.uni-erlangen.de>
Subject: partitions on software raid revisited - more questions
Date: Thu, 06 May 2004 10:29:06 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4099F752.3020704@chemie.uni-erlangen.de>
Reply-To: schmidt@naa.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hallo there!

Some time ago there was a discussion about software raid and the new=20
partitionability feature.

Since I upgraded to kernel 2.6.6-rc3 with libata I now have this featur=
e=20
inside the "native" kernel and want to try it out.

The dynamically allocated major number seems to be 254 (according to=20
/proc/devices). This, however, could change when adding more dynamicall=
y=20
allocating drivers. Am I right?

My main problem at this moment is how I can access the devices via=20
/dev/something.

There should be something like /dev/md/d1p2 for example. This is not=20
existing per se on a Debian woody system (no wonder). How can I make=20
these entries, since mknod wants to have a major number to make these=20
devices? Do I have to use a newer mknod? Or does my kernel lack some=20
functionality? Perhaps then I wouldn=B4t need nodes at all?

One other thing: I put together a raid5 out of four identical sata hdds=
=20
(dev/sda and so on), then partitioned it (md9) with fdisk. fdisk -l of=20
the drives shows me no entries for sdb and sdc, however the following=20
(similar for sda and sdd):

> rossweisse:/# fdisk -l /dev/sdd
>=20
> Disk /dev/sdd: 255 heads, 63 sectors, 19457 cylinders
> Units =3D cylinders of 16065 * 512 bytes
>=20
>    Device Boot    Start       End    Blocks   Id  System
> /dev/sdd1             1        98    786434   83  Linux
> Partition 1 does not end on cylinder boundary:
>      phys=3D(1023, 1, 4) should be (1023, 254, 63)
> /dev/sdd2            98     38950 312074260   83  Linux
> Partition 2 does not end on cylinder boundary:
>      phys=3D(1023, 1, 4) should be (1023, 254, 63)
> /dev/sdd3         38950     58372 156011752   83  Linux
> Partition 3 does not end on cylinder boundary:
>      phys=3D(1023, 1, 4) should be (1023, 254, 63)

Is this normal?

Thanks for any help, Norman.
--=20
Norman Schmidt          Institut fuer Physikal. u. Theoret. Chemie
Dipl.-Chem. Univ.       Friedrich-Alexander-Universitaet
schmidt@naa.net         Erlangen-Nuernberg
                         IT-Systembetreuer Physikalische Chemie

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
