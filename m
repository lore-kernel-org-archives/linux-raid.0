From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm "Used Dev Size" on 3TB drives
Date: Sat, 22 Oct 2011 09:40:16 +1100
Message-ID: <20111022094016.02e8c800@notabene.brown>
References: <1C43E501-9252-4502-BAC7-0C67C15DC68E@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/AF0=7R/Xkp7AKvwO2l4+Yn0"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1C43E501-9252-4502-BAC7-0C67C15DC68E@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew <andyukguy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/AF0=7R/Xkp7AKvwO2l4+Yn0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 21 Oct 2011 11:18:58 +0100 Andrew <andyukguy@gmail.com> wrote:

> Hi,
>=20
> A fresh installation of mdadm in a raid1 profile on 2x3TB drives is repor=
ting as follows:
>=20
> /dev/md1:
>         Version : 01.00
>   Creation Time : Fri Oct 21 01:03:57 2011
>      Raid Level : raid1
>      Array Size : 2930147192 (2794.41 GiB 3000.47 GB)
>   Used Dev Size : 5860294384 (5588.81 GiB 6000.94 GB)

This looks like a bug that was fixed in Feb 2009 and so should not be prese=
nt
after 2.6.9.

What version of mdadm are you using?

   mdadm -V


NeilBrown


>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 1
>     Persistence : Superblock is persistent
>=20
>     Update Time : Fri Oct 21 10:40:09 2011
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>            Name : 1
>            UUID : 639ae43a:c079a412:3a0be350:72ff20be
>          Events : 46
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8        2        0      active sync   /dev/sda2
>        1       8       18        1      active sync   /dev/sdb2
>=20
> While everything looks in order I've not seen Used Dev Size report double=
 the disk size before on a mdadm raid1 array. Indeed on the /boot partition=
 (md0) on the same drives it doesn't:
>=20
> /dev/md0:
>         Version : 00.90
>   Creation Time : Fri Oct 21 01:03:40 2011
>      Raid Level : raid1
>      Array Size : 115648 (112.96 MiB 118.42 MB)
>   Used Dev Size : 115648 (112.96 MiB 118.42 MB)
>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 0
>     Persistence : Superblock is persistent
>=20
>     Update Time : Fri Oct 21 06:53:22 2011
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>            UUID : e4d1bc12:51cd306a:de6491bb:b01e719b
>          Events : 0.18
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8        3        0      active sync   /dev/sda3
>        1       8       19        1      active sync   /dev/sdb3
>=20
> and on other arrays on different servers it doesn't for any partition. Th=
e only thing I can see is that (oddly) the version number of mdadm changes =
between the md0 and md1 array. Is this simply a bug in v01.00 or should I b=
e worried about the array's functionality and integrity?
>=20
> Further info:
>=20
> Model: ATA Hitachi HDS72303 (scsi)
> Disk /dev/sda: 3001GB
> Sector size (logical/physical): 512B/512B
> Partition Table: gpt
>=20
> Number  Start   End     Size    File system  Name  Flags
>  1      1049kB  3146kB  2097kB                     bios_grub
>  3      3146kB  122MB   118MB   ext3               raid
>  2      122MB   3001GB  3000GB  ext4               raid
>=20
> Model: ATA Hitachi HDS72303 (scsi)
> Disk /dev/sdb: 3001GB
> Sector size (logical/physical): 512B/512B
> Partition Table: gpt
>=20
> Number  Start   End     Size    File system  Name  Flags
>  1      1049kB  3146kB  2097kB                     bios_grub
>  3      3146kB  122MB   118MB   ext3               raid
>  2      122MB   3001GB  3000GB  ext4               raid
>=20
> /dev/sda2:
>           Magic : a92b4efc
>         Version : 1.0
>     Feature Map : 0x0
>      Array UUID : 639ae43a:c079a412:3a0be350:72ff20be
>            Name : 1
>   Creation Time : Fri Oct 21 01:03:57 2011
>      Raid Level : raid1
>    Raid Devices : 2
>=20
>  Avail Dev Size : 5860294384 (2794.41 GiB 3000.47 GB)
>      Array Size : 5860294384 (2794.41 GiB 3000.47 GB)
>    Super Offset : 5860294640 sectors
>           State : clean
>     Device UUID : 0ed46f31:1b100aa1:e2933dd4:f93716c1
>=20
>     Update Time : Fri Oct 21 11:17:42 2011
>        Checksum : 22b01b3e - correct
>          Events : 46
>=20
>=20
>     Array Slot : 0 (0, 1)
>    Array State : Uu
>=20
> /dev/sdb2:
>           Magic : a92b4efc
>         Version : 1.0
>     Feature Map : 0x0
>      Array UUID : 639ae43a:c079a412:3a0be350:72ff20be
>            Name : 1
>   Creation Time : Fri Oct 21 01:03:57 2011
>      Raid Level : raid1
>    Raid Devices : 2
>=20
>  Avail Dev Size : 5860294384 (2794.41 GiB 3000.47 GB)
>      Array Size : 5860294384 (2794.41 GiB 3000.47 GB)
>    Super Offset : 5860294640 sectors
>           State : clean
>     Device UUID : f992deee:76530588:337f82d3:b18e523e
>=20
>     Update Time : Fri Oct 21 11:17:42 2011
>        Checksum : 439b5f8e - correct
>          Events : 46
>=20
>=20
>     Array Slot : 1 (0, 1)
>    Array State : uU
>=20
> Thanks.--
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/AF0=7R/Xkp7AKvwO2l4+Yn0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTqH00Dnsnt1WYoG5AQLRXA/+MEyRFrWVSfn6y+i9LKyrJ1/HZ8M6bJlO
9CfbZevtng6gY2neFC8dVzro8bipeqptRZRbKJcE1hyfFUJeeOJ2Sr63bXYTb2NP
pGv/xmIhZGo5cmQL0aSTda5w5sE3mzAPl5oDcVg0SNHdLXDhai1KiKzKWSIOsfQ8
bXqPDC70RKpzHMGPCAzPfGlgR6XtW/gwBRES1Lgj1U5LVOoc7WJTsSDYQrHPXPpP
9+4uI1cmh2rDMdyeOTXN11Xp/f6IF5LKEjy1UKYQdmgbNWhZDoCWdXUAglDIkuqS
iftsb69GI2PKzGHHG8m0EKx27PifvG22ET76JV6zxG8ml6e4N6Ia8XAN0k5i2JyK
pWXVbJo1sNeWmK6igGsLNxPPMkLV7TAv+IaN3WcdxqB8nwYC4TMvBw52rAYp2xua
om36fDfixGVjI3e+dgUc6OmmsUNFev4ue04Dkm3ZSzy+TBMreFGrqVYYuo38UnRf
By5hV2q/9gCAWk/cgeDYkFwB0TgrZhUuN6KJOtQnHI75MqYH/6Xf35dqM6mXr8s6
Sl0OAxUWkohn8hHEzbYPLIgmDqDacmSyxVaqCA4G2LShH2Uyf+TC8nqe+xU3OprB
gkCCUzFrAd+9tO6jmCzqx35DnsgsnSJMAEzHekuDtgAH4l5dobpFWyHcSjdg2PhS
DpIok1PL5e4=
=+7vt
-----END PGP SIGNATURE-----

--Sig_/AF0=7R/Xkp7AKvwO2l4+Yn0--
