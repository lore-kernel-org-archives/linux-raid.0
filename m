From: NeilBrown <neilb@suse.de>
Subject: Re: RAID0 size over 2 TB
Date: Mon, 8 Sep 2014 17:00:37 +1000
Message-ID: <20140908170037.451e2376@notabene.brown>
References: <20140906230928.BB645CEE@pobox.sk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/L9EaTe6wm8hIe1LQQu2Zxe4"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140906230928.BB645CEE@pobox.sk>
Sender: linux-raid-owner@vger.kernel.org
To: azurIt <azurit@pobox.sk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/L9EaTe6wm8hIe1LQQu2Zxe4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 06 Sep 2014 23:09:28 +0200 "azurIt" <azurit@pobox.sk> wrote:

> Hi,
>=20
> i'm having problems with growing my RAID0 array over 2 TB. I installed tw=
o 4 TB drives, created 4 TB partitions but array cannot be resized over 2 T=
B. Superblock versoin is 0.90 and kernel version is 3.2.53 - according to l=
inux RAID wiki, it should support 4 TB component/array size:
> https://raid.wiki.kernel.org/index.php/RAID_superblock_formats#The_versio=
n-0.90_Superblock_Format
>=20
> Some more info:
>=20
> # mdadm --detail /dev/md2
> /dev/md2:
>         Version : 0.90
>   Creation Time : Tue Sep 28 16:54:04 2010
>      Raid Level : raid1
>      Array Size : 2147483520 (2048.00 GiB 2199.02 GB)
>   Used Dev Size : 2147483520 (2048.00 GiB 2199.02 GB)
>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 2
>     Persistence : Superblock is persistent
>=20
>     Update Time : Sat Sep  6 23:04:44 2014
>           State : clean=20
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>            UUID : 9a363004:ad04abfe:2e31e1c3:caf66df4
>          Events : 0.77066
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8       33        0      active sync   /dev/sdc1
>        1       8       49        1      active sync   /dev/sdd1
>=20
>=20
>=20
>=20
>=20
>=20
>=20
> # fdisk /dev/sdd
>=20
> WARNING: GPT (GUID Partition Table) detected on '/dev/sdd'! The util fdis=
k doesn't support GPT. Use GNU Parted.

Why are you using "fdisk" even though "fdisk" is telling you not to use it?

What does
  cat /proc/partitions

say about the sizes of the partitions?

NeilBrown

--Sig_/L9EaTe6wm8hIe1LQQu2Zxe4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVA1UFTnsnt1WYoG5AQKcQxAAknFhixpx7Js6PJmEAzEAjEGTT19Q7dVQ
TaA29DhWmx86pk8eqOQcVnW3rcFi8+asovQlNVGZPtiv8hMyfCI2yLbEq45VEV1C
BOjeBrhdHtU2hJEETrpGGEWAgjTGtILxpphzNQIk5h8vF3tb4S1To6oUr/1JZqhS
Xc6uY3sY+Rotm+ctqv2Ffn5vDIhEoXV5LakOy10JKtXp/NaeAxy8DV+l8UaZbALe
DfiVUpNC1+u947k4HsjRhNpDOtP6omDbpuYSi9CmAnf33I90iPObD7/NMnMU1LHd
Nm+z2I/xZ6RRDnfOH+FOmUnT/PV+RQOBq1QaPV6rJUdEihMNPrIZ93Cc76IiQptP
Slba1blgfxBVI2KSZeVtJZF08wHLZNQtZhAA3fXsvctiSlOmxyoenVEwM7xfKbMY
QRBV4KEpuU1esLFI6fogMcYexVhI3/Rm7JlpVnskFUtip1H1y+TwejKAA+K+MhY8
fJJOJw9oOfXl65hYAWl/8ERwq25KR+2fj8qZTryUKAiKqseAop7arnXxACq5Wq1v
Ky125eAAcV8xTyqDFWfZNGbngebqf1wJ+BvW5InGMjViPcxG4MemDPBuc5Io6D/L
ygbiHElluyfBq2TNl2vHxd1RaQaIumu/26xafT85z9WFFnpGO7ZI9X6692oBwAqF
q9u+rcjOhJU=
=13M+
-----END PGP SIGNATURE-----

--Sig_/L9EaTe6wm8hIe1LQQu2Zxe4--
