From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm creates corrupt superblock
Date: Wed, 29 Oct 2014 08:00:19 +1100
Message-ID: <20141029080019.272bc844@notabene.brown>
References: <544FDB1C.5030306@hanswkraus.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/wZBM0.Y0dJE_TAnFuJwhzYf"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <544FDB1C.5030306@hanswkraus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hans Kraus <hans@hanswkraus.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/wZBM0.Y0dJE_TAnFuJwhzYf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Oct 2014 19:06:20 +0100 Hans Kraus <hans@hanswkraus.com> wrote:

> Hi,
>=20
> I debugged my problem a bit more: it seems that mdadm creates a defect
> superblock. That's repeatedly happening, but only for one drive. I
> copied zeros to that drive (via ddrescue /dev/zero ...) and the drive
> looks OK. The info I got:
>

and you send me the metadata of all your devices please?

   mkdir /tmp/dump
   mdadm --dump /tmp/dump /dev/sde1
   tar czvf /tmp/dump.tgz /tmp/dump

and then send /tmp/dump.tgz

Thanks.

NeilBrown

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> root@nashorn:/home/kraush/work/smartctrl# mdadm --zero-superblock /dev/sd=
e1
> mdadm: Unrecognised md component device - /dev/sde1
> root@nashorn:/home/kraush/work/smartctrl# mdadm --add /dev/md126 /dev/sde1
> mdadm: add new device failed for /dev/sde1 as 4: Invalid argument
> root@nashorn:/home/kraush/work/smartctrl# mdadm -E /dev/sde1
> /dev/sde1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x1
>       Array UUID : e7caa5d1:b33fd2a5:7782fb0c:9d8d9d5b
>             Name : nashorn:126  (local to host nashorn)
>    Creation Time : Mon Oct 27 15:58:38 2014
>       Raid Level : raid1
>     Raid Devices : 2
>=20
>   Avail Dev Size : 1953260976 (931.39 GiB 1000.07 GB)
>       Array Size : 0
>    Used Dev Size : 0
>      Data Offset : 262144 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=3D262056 sectors, after=3D1953260976 sectors
>            State : clean
>      Device UUID : 4d1420c6:79978477:e86412b1:24beebfc
>=20
> Internal Bitmap : 8 sectors from superblock
>      Update Time : Tue Oct 28 11:53:49 2014
>    Bad Block Log : 512 entries available at offset 72 sectors
>         Checksum : 6f02d040 - expected 891eedff
>           Events : 0
>=20
>=20
>     Device Role : spare
>     Array State : RR ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D r=
eplacing)
> root@nashorn:/home/kraush/work/smartctrl#
> -------------------------------------------------------------------------=
----------------------------------
> root@nashorn:/home/kraush/work/smartctrl# cat /proc/mdstat
> Personalities : [raid1] [raid6] [raid5] [raid4]
> md127 : active (auto-read-only) raid6 sda1[0] sdk1[6](S) sdl2[7](S)=20
> sdh1[5] sdg1[4] sdf1[3] sdc1[2] sdb1[1]
>        1953017856 blocks super 1.2 level 6, 512k chunk, algorithm 2=20
> [6/6] [UUUUUU]
>        bitmap: 0/4 pages [0KB], 65536KB chunk
>=20
> md10 : active (auto-read-only) raid1 sdi2[0] sdl3[1]
>        87833408 blocks super 1.2 [2/2] [UU]
>        bitmap: 0/1 pages [0KB], 65536KB chunk
>=20
> md126 : active raid1 sdd1[3] sdj1[2]
>        488254464 blocks super 1.2 [2/2] [UU]
>        bitmap: 0/4 pages [0KB], 65536KB chunk
>=20
> md0 : active raid1 sdl1[4] sdd2[3] sdi1[5]
>        156157824 blocks super 1.2 [3/1] [U__]
>        [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>.]  rec=
overy =3D 95.6% (149290048/156157824)=20
> finish=3D8.4min speed=3D13496K/sec
>        bitmap: 1/2 pages [4KB], 65536KB chunk
>=20
> unused devices: <none>
> root@nashorn:/home/kraush/work/smartctrl#
> -------------------------------------------------------------------------=
----------------------------------
> dmesg:
> [33299.387382] md: invalid superblock checksum on sde1
> [33299.387385] md: sde1 does not have a valid v1.2 superblock, not=20
> importing!
> [33299.387408] md: md_import_device returned -22
> root@nashorn:/home/kraush/work/smartctrl#
> -------------------------------------------------------------------------=
----------------------------------
> root@nashorn:/home/kraush/work/mdadm# mdadm --version
> mdadm - v3.3-161-gfed12d4 - 21st August 2014
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Kind regards, Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/wZBM0.Y0dJE_TAnFuJwhzYf
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVFAD4znsnt1WYoG5AQL8kBAAjou4cacfmG5sg1siy/XiMKP3itkZTdr7
P9IEF2UJ7W50RDZELwUb0Oo7SgrhyHG9DdamK7NXgJ3IsC2DD5yLuVWuxBnxF8cc
EgONRfVgbF+Ahy6iNf6eLlilGTWMm/NvLJdnbq6p3vN7vXfa4g41pvpW5GoffIhF
polhgk/Y7aoycgxMBUC898Oru7TGWwgpVxhIkTvIngKttUGCs5oWKiXd2cmYSkHA
MVc8mJLjdE3RZnL4q/E0q8NybiGsvQTa+AUG9Yn6vcDEoSr6MTjtkQyyv94fYcpC
kUhrkL4yCs+V2z1u+xUFvWH9kwzgBC0wjRIxaWWFJm7mXLcJPpLkLJpOmvfJgrHM
902x+P7z39pGQqKocuQHzy0k5gArqyaYij0Dn6ZBwtq+Q2hEZC+ZstpGyz+jhsz0
mhJE6/mh+8QcemSnkN55hUtGUWdKPfsOwAQkMqeuP7vC6fIWPfLNBkJnVEd3Rr4z
8J4Zu4lIg+dRS8rLn+UztOvp5di9Vp1sLJHA44PNw6S4U1C3yXwkr3EjEv8eLbfR
Lx5woTFsxyx+i5GYsDtP5Mv9dg4aNSmVszBzc5OxMHWHRc1l7NNn21z5m62XQ5JW
E0u/GWY6tD5LGae57nKzzw3dvDGnEXhYCQcUdb9euPqDoUHsb+29u1QxVVz1JojH
z0W/LWbXIw8=
=kyAL
-----END PGP SIGNATURE-----

--Sig_/wZBM0.Y0dJE_TAnFuJwhzYf--
