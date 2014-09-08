From: NeilBrown <neilb@suse.de>
Subject: Re: RAID0 size over 2 TB
Date: Mon, 8 Sep 2014 17:28:32 +1000
Message-ID: <20140908172832.7543b241@notabene.brown>
References: <20140906230928.BB645CEE@pobox.sk>
	<20140908170037.451e2376@notabene.brown>
	<20140908091811.1DD1140C@pobox.sk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/QxEfmeq_J0g/xz3xCnFp/kf"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140908091811.1DD1140C@pobox.sk>
Sender: linux-raid-owner@vger.kernel.org
To: azurIt <azurit@pobox.sk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/QxEfmeq_J0g/xz3xCnFp/kf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 08 Sep 2014 09:18:11 +0200 "azurIt" <azurit@pobox.sk> wrote:

> >
> > CC: linux-raid@vger.kernel.org
> >On Sat, 06 Sep 2014 23:09:28 +0200 "azurIt" <azurit@pobox.sk> wrote:
> >
> >> Hi,
> >>=20
> >> i'm having problems with growing my RAID0 array over 2 TB. I installed=
 two 4 TB drives, created 4 TB partitions but array cannot be resized over =
2 TB. Superblock versoin is 0.90 and kernel version is 3.2.53 - according t=
o linux RAID wiki, it should support 4 TB component/array size:
> >> https://raid.wiki.kernel.org/index.php/RAID_superblock_formats#The_ver=
sion-0.90_Superblock_Format
> >>=20
> >> Some more info:
> >>=20
> >> # mdadm --detail /dev/md2
> >> /dev/md2:
> >>         Version : 0.90
> >>   Creation Time : Tue Sep 28 16:54:04 2010
> >>      Raid Level : raid1
> >>      Array Size : 2147483520 (2048.00 GiB 2199.02 GB)
> >>   Used Dev Size : 2147483520 (2048.00 GiB 2199.02 GB)
> >>    Raid Devices : 2
> >>   Total Devices : 2
> >> Preferred Minor : 2
> >>     Persistence : Superblock is persistent
> >>=20
> >>     Update Time : Sat Sep  6 23:04:44 2014
> >>           State : clean=20
> >>  Active Devices : 2
> >> Working Devices : 2
> >>  Failed Devices : 0
> >>   Spare Devices : 0
> >>=20
> >>            UUID : 9a363004:ad04abfe:2e31e1c3:caf66df4
> >>          Events : 0.77066
> >>=20
> >>     Number   Major   Minor   RaidDevice State
> >>        0       8       33        0      active sync   /dev/sdc1
> >>        1       8       49        1      active sync   /dev/sdd1
> >>=20
> >>=20
> >>=20
> >>=20
> >>=20
> >>=20
> >>=20
> >> # fdisk /dev/sdd
> >>=20
> >> WARNING: GPT (GUID Partition Table) detected on '/dev/sdd'! The util f=
disk doesn't support GPT. Use GNU Parted.
> >
> >Why are you using "fdisk" even though "fdisk" is telling you not to use =
it?
> >
> >What does
> >  cat /proc/partitions
> >
> >say about the sizes of the partitions?
> >
> >NeilBrown
> >
>=20
>=20
>=20
> I, of course, didn't use fdisk to create partitions - they were created u=
sing cgdisk, but it's graphical tool so i wasn't able to send output from i=
t, so i get output from fdisk to prove, that partitions are large enough.

Yet fdisk *didn't* prove that the partitions are large enough - it said the
partitions were:

/dev/sdd1               1  4294967295  2147483647+  ee  GPT
                                       ^^^^^^^^^^^

2 Gig.

And /proc/partitions tells me:

>=20
>=20
> # cat /proc/partitions
> major minor  #blocks  name
>=20
>    9        2 2147483520 md2
>    8       32 3907018584 sdc
>    8       33 2147483647 sdc1
>    8       48 3907018584 sdd
>    8       49 2147483647 sdd1

that the partitions are 2Gig.  You need to sort the partition size out.  I
cannot help you.  I have no experience with GPT.  Maybe a reboot?

NeilBrown

--Sig_/QxEfmeq_J0g/xz3xCnFp/kf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVA1aoDnsnt1WYoG5AQLXRg/9H0nXE5fHnYLW0qLjN22TxoO+cYCjsCBj
GZhKR8ShhoQylLbymxw1udiVtSAwrv1mYUabzk73c4PJ5n3Kn3IFrc6k6hrFaJH9
uoP0cEaPysyDhMe1qDlIX20inJFOpIr1qN5z6IOiWjTsvE32/dk09LF2fCzJ2/Nn
p010yxRB4OYmo9l4DLu83SXW97CnetKNrYJEJDU2zchiOnZcDD39xriXZtn1PAgi
nLa4Z9rYWXwOBKEJUqwONpFvcReOIREi3kkOpTN+JRb+CjQc/OdzUpGHwlARXSeB
d1NkYSP4lT1WV6AU4k2LYoGlIrF+rITV+kyzGyST7ApC82Epeha5AJN5K9xIyhVn
gm6wi976Llj+v0ahFOkIYZX0jDYOfZmpFbF4C18c+smHS0gssqI56NltkgLM19Xf
62E5fRTvz0WOFDxZ0oRrpwPsuyUdmWY3HLLfBgh0DAFCseBfdtvOV9zwGpu/CiY+
I9igrBCD4eXOy2S9X/j1ju2zrbnTRWWU8/+w24/xQkAv3+MPTizTdnvmx0atuad/
dI7RzwvmYLhC4BJXYb9G5PuTqtDJ/rbEf6GUpFdOE5nVMDQi6R5Zupa/UHXq1+4P
a9Z90Br9WAao2tmrcwUDLn+1GzdGjYLpDYpQiY3bkB26ax+0xGBSZ5NbPV92vCGN
d775ezfU17c=
=Q4Ej
-----END PGP SIGNATURE-----

--Sig_/QxEfmeq_J0g/xz3xCnFp/kf--
