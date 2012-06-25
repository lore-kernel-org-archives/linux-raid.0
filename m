From: NeilBrown <neilb@suse.de>
Subject: Re: Help with the loss of a software raid (5)
Date: Tue, 26 Jun 2012 09:44:01 +1000
Message-ID: <20120626094401.6a827f8e@notabene.brown>
References: <20120625114435.10700@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/vC/Lh1oCSV3VP4wfVHD1Eyo"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120625114435.10700@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Matthias Herrmanny <Matthias.Herrmanny@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/vC/Lh1oCSV3VP4wfVHD1Eyo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 25 Jun 2012 13:44:35 +0200 "Matthias Herrmanny"
<Matthias.Herrmanny@gmx.de> wrote:

> Good day, sorry for my English schelchtes.
>=20
> I have a little problem with my two raid 5 system.
> I have been in use Ubuntu 11.xx and then I lost 2 hard drives with a hard=
ware defect, whereupon I have my new hard drives 2TB concerned. Since Ubunt=
u can not handle drives larger than 2TB, I've also changed Centos 6.2.
> One of my two Raid 5 5x (250Gb) system, I can write off. Since there are =
two disc finally broken (hardware failure)
> The other raid 5 system (3x 80G) I have then taken. Now on a disc that ha=
s no partition disappears, the second one was a spare Displayed and the thi=
rd has no superblock more.
> [root@sonne ~]# fdisk -l
> Disk /dev/sdg: 82.0 GB, 81964302336 bytes
> 255 heads, 63 sectors/track, 9964 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x00032373
>=20
>    Device Boot      Start         End      Blocks   Id  System
>=20
> Disk /dev/sde: 120.1 GB, 120060444672 bytes
> 255 heads, 63 sectors/track, 14596 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x00037e0a
>=20
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sde1               1        9970    80076800   fd  Linux raid autode=
tect
> /dev/sde2            9970       14597    37167105    5  Extended
> /dev/sde5            9970       14597    37167104   fd  Linux raid autode=
tect
>=20
> Disk /dev/sdf: 82.0 GB, 81964302336 bytes
> 255 heads, 63 sectors/track, 9964 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x00050d72
>=20
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdf1               1        9965    80041984   fd  Linux raid autode=
tect
>  =20
>  =20
>   [root@sonne ~]# mdadm --examine /dev/sdf1
> /dev/sdf1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 5874972e:5326304f:37228c78:dd15d965
>            Name : sonne:5
>   Creation Time : Sun Nov 27 03:44:57 2011
>      Raid Level : -unknown-
>    Raid Devices : 0
>=20
>  Avail Dev Size : 160081920 (76.33 GiB 81.96 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 8bc40fb6:73fe82b4:c1c001f6:046775d4
>=20
>     Update Time : Mon Jun 18 01:35:12 2012
>        Checksum : 59fcdac3 - correct
>          Events : 2
>=20
>=20
>    Device Role : spare
>    Array State :  ('A' =3D=3D active, '.' =3D=3D missing)
>=20
>   =20
>    [root@sonne ~]#   mdadm --examine /dev/sde1
> /dev/sde1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 5874972e:5326304f:37228c78:dd15d965
>            Name : sonne:5
>   Creation Time : Sun Nov 27 03:44:57 2011
>      Raid Level : -unknown-
>    Raid Devices : 0
>=20
>  Avail Dev Size : 160151552 (76.37 GiB 82.00 GB)
>   Used Dev Size : 160081920 (76.33 GiB 81.96 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : eab5a0b6:f7034d85:b143bc4c:4f3b5054
>=20
>     Update Time : Mon Jun 18 01:35:12 2012
>        Checksum : 1ee38df - correct
>          Events : 2
>=20
>=20
>    Device Role : spare
>    Array State :  ('A' =3D=3D active, '.' =3D=3D missing)
>=20
>=20
> Now I've put some try to run the RAID system again. Unfortunately, all to=
 no avail.
> mdadm -A /dev/md125 /dev/sde1 /dev/sdf1 /dev/sdg1
> mdadm: cannot open device /dev/sde1: Device or resource busy
> mdadm: /dev/sde1 has no superblock - assembly aborted
>=20
> mdadm -Av /md/md5 --uuid5874972e:5326304f:37228c78:dd15d965 /dev/*
>=20
> mdadm --manage /dev/md125 --re-add /dev/sdg1
> mdadm: cannot get array info for /dev/md125
> mdadm --assemble /dev/md125 --auto=3Dyes --scan --update=3Dsummaries --ve=
rbose
> mdadm: /dev/md125 not identified in config file.
> mdadm -Cv /dev/md125 -e 1.20 --assume-clean -n3 -l5 /dev/sde1 /dev/sdf1 /=
dev/sdg1
> mdadm: unrecognised metadata identifier: 1.20
> mdadm -Cv /dev/md125 -e 1.20 --assume-clean -n3 -l5 /dev/sde1 /dev/sdf1 /=
dev/sdg1 --force
> mdadm: unrecognised metadata identifier: 1.20
>=20
>=20
> I hope you still have an idea how I got the raid again and running quickl=
y.
> Thanks in advance.

Hi.
You have suffered from this bug:

  http://neil.brown.name/blog/20120615073245

http://www.heise.de/newsticker/meldung/Fehler-im-Linux-Kernel-kann-Software=
-RAIDs-zerstoeren-1620896.html
is a brief article in German referring to it.

You need to=20
  mdadm --stop /dev/md....
any array that is listed as "inactive" in /proc/mdstat, then
try something like:

  mdadm -C /dev/md125 -e 1.2 --assume-clean -n 3 -l 5 /dev/sde1 /dev/sdf1 m=
issing

Note that I didn't include sdg as something looks strange with sdg - it
doesn't have any partitions.  Maybe you included "/dev/sdg" in the array
rather than "/dev/sdg1" ??
What does "mdadm -E /dev/sdg"  show?

If that looks like an array member, then you might try

  mdadm -C /dev/md125 -e 1.2 --assume-clean -n 3 -l 5 \
     /dev/sde1 /dev/sdf1 /dev/sdg

Then try "fsck -n" or similar.  If that fails, stop the array and try again
with a different ordering of devices.

Feel free to ask if something isn't clear or if you want to confirm your ne=
xt
step before you take it.

NeilBrown


--Sig_/vC/Lh1oCSV3VP4wfVHD1Eyo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+j3wTnsnt1WYoG5AQJD6RAAgC86RIXjL+/QxsbdBiQue7cWHoEPYS/9
BToLQZ4mx3VXcY8FMVIJlu3adVqDtTh+Hd6wadHuDvCJ2q+IH1Dn77MizRwUTGBk
iTWVEglitPgjgSfki4lcZ28o2WdP55iDFiibD8OyoMxwZUUgVTkElPwuCvohJYaa
gt9DR2zjaabRGYCVlF5HrI4xfqnk6zHYqlbu0rOfcW2uQcomZfP0JlnQE5+2LrlE
BqdXynwU7STSUHpphfkYyDwEkHmTUPu1Y1HPW/5uFMppci8D7m7OVVfZJKcPioqQ
thDAmmDJ9br7BYc+mV0bB0ptwWkcPGi9enKYyFn2C5sJbrpsqBcUUL693htHmE0H
jEVTa3UEDAPPkB3xlo4qQLERx3W+BsOHLDBPfNtpdTrC/zERMbIb6D7DGba3zeDO
iiuwS4zReWJzAqIAFnNW9pATCqIWE9Do6s9v0GWZJrQ+HqLdfxIplRj52xWyqgQP
gYntOlE5JxbqPZ/gP6LmWAoeVSqN4RyhExDja5Pmr+t5kcDZwFufr1QqDSt4hksx
m4+AsqnnHSWAkQ7vjAkiRsmFr6CLPvpjzKF5+up4rpqP1MLJ88HZaTxCSUFwcV3b
nMSIFK4JOUspQmyjCfNYjcCm7SCtmI43Pt2t5B8dHzFriLibE/8d+QYCdUnaEc+e
37DEUEVGJHs=
=X3RP
-----END PGP SIGNATURE-----

--Sig_/vC/Lh1oCSV3VP4wfVHD1Eyo--
