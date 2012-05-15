From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm doesn't wont to grow - help please
Date: Tue, 15 May 2012 10:14:31 +1000
Message-ID: <20120515101431.786b117a@notabene.brown>
References: <4FB10D81.7070803@supersystem.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/TdOSDpocV+c2s3I3ye_+iL2"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FB10D81.7070803@supersystem.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Sergiusz =?UTF-8?Q?Brzezi=C5=84ski?= <Sergiusz.Brzezinski@supersystem.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/TdOSDpocV+c2s3I3ye_+iL2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 14 May 2012 15:49:53 +0200 Sergiusz Brzezi=C5=84ski
<Sergiusz.Brzezinski@supersystem.pl> wrote:

> Hi,
>=20
> I would like to grow the RAID1.
>=20
> - Raid1 size has about 50GB
> - two HD partition (sda2, sdb2) have about 80GB+ (each)
>=20
> I do:
>=20
> # mdadm --grow /dev/md0 --size=3Dmax
>=20
> and I get the info, that the new size is 50GB. And I wonder: why not 80GB=
? The=20
> size doesn't change! If I try to force size (--size=3Dxxxxx), I get the m=
essage=20
> that there is no space.
>=20
> What did I wrong?

Probably used an ancient version of mdadm - more than a couple of months
old :-)

If you=20
  for i in /sys/block/md0/md/dev*/size
  do echo 0 > $i
  done
then try again it might work better.

Newer mdadm (since May 2011) do this for you.

If you look at the "mdadm -E /dev/sda2" output before and after you will
notice that "Avail Dev Size" changes.

You can achieve the same effect by stopping the array, the assembling it
with --update=3Ddevicesize

  mdadm --stop /dev/md0
  mdadm --assemble /dev/md0 --update=3Ddevicesize /dev/sd[ab]2
  mdadm --grow /dev/md0 --size=3Dmax

NeilBrown


>=20
> Bellow some facts about my configuration.
>=20
> Please help.
>=20
> Thank You in advance
>=20
> Sergiusz Brzezi=C5=84ski
> -----------------------------------------------
>=20
> # mdadm --detail /dev/md0
>=20
> /dev/md0:
>          Version : 1.2
>    Creation Time : Wed Mar 30 07:25:47 2011
>       Raid Level : raid1
>       Array Size : 52427776 (50.00 GiB 53.69 GB)
>    Used Dev Size : 52427776 (50.00 GiB 53.69 GB)
>     Raid Devices : 2
>    Total Devices : 2
>      Persistence : Superblock is persistent
>=20
>      Update Time : Mon May 14 09:16:16 2012
>            State : clean
>   Active Devices : 2
> Working Devices : 2
>   Failed Devices : 0
>    Spare Devices : 0
>=20
>             Name : linux-uo1f.site:1
>             UUID : 603ab02b:f8e9c2b9:863ce780:7f8dfca7
>           Events : 5472151
>=20
>      Number   Major   Minor   RaidDevice State
>         2       8        2        0      active sync   /dev/sda2
>         4       8       18        1      active sync   /dev/sdb2
>=20
>=20
>=20
> # cat /proc/mdstat
>=20
> Personalities : [raid1]
> md0 : active raid1 sda2[2] sdb2[4]
>        52427776 blocks super 1.2 [2/2] [UU]
>=20
> unused devices: <none>
>=20
>=20
> # fdisk /dev/sdb
>=20
> Disk /dev/sdb: 320.1 GB, 320072933376 bytes
> 255 heads, 63 sectors/track, 38913 cylinders, total 625142448 sectors
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x0008f6dc
>=20
>     Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1   *        2048      208895      103424   83  Linux
> /dev/sdb2          208896   625142447   312466776   fd  Linux raid autode=
tect
>=20
>=20
> # fdisk /dev/sda
>=20
> Disk /dev/sda: 90.0 GB, 90028302336 bytes
> 255 heads, 63 sectors/track, 10945 cylinders, total 175836528 sectors
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x08e607c5
>=20
>     Device Boot      Start         End      Blocks   Id  System
> /dev/sda1            2048      208895      103424   83  Linux
> /dev/sda2          208896   175836527    87813816   fd  Linux raid autode=
tect
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/TdOSDpocV+c2s3I3ye_+iL2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7Gf5znsnt1WYoG5AQISCw//axofAF8SRq+Ks+/vK9FosdiHLyHHF/1T
F2eL9p+t8wkr3B1e2YZz49EW5K1Uz/nU/YlCP3Pz8Cqc6KCt3H2yC16vcnkGLf7S
Je0fdL8nQv9YiB1hppIsWKaHTakU7HZlwqpEQvIc+a8PvxRdyLjY0Q0vjG9AweGg
wSUsMCEKRdP6sDYT03OxCbjSRoHzVci4rMm/BEG1WVJHLbRLDGStCdZrrAS+QNSA
Yb6cjtxGzWJzif+MKUUFvPNhqf2UIWx0h767m1QaW/78my0ZTsiDi6La8c/6NUPI
u2b45RdMQVjFCXBwKgVgB7HQuUWoHRzca7Gh8g2heaRTBgTrVnrobYr5tCvDyy+E
dvtO2X2viOstZ1MVW8JzO0oupTnQyXdlbnZC8QLO46W3twxl6iNQwcRIoHEv2gCF
hRHY62w0qQFOUfQGgbczJhAn+5l9denE5MMo41RNb/fOu8hFH4OO/OaQlD0u760V
7ybrBQiGxXd5CqeuLd8gBk1xdRjp5OcJ2b7t2jRUP2rZHZKfT+4FGdLO1NFYyL9h
zIF8035slJOzNAyQke4XZglpMXYrvIBI0MNOidVaU7ye5yPP7ZhJT2t4LaB+VoFE
mXnR0pQAYJT7gdCFpJ203S0sEEFXLBnroiuX1eK/Hyp2khCEZidV3nhPxFpN/l7U
bU0V3p+rF0M=
=LIjL
-----END PGP SIGNATURE-----

--Sig_/TdOSDpocV+c2s3I3ye_+iL2--
