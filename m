From: NeilBrown <neilb@suse.de>
Subject: Re: Shrinking number of devices on a RAID-10 (near 2) array
Date: Sun, 24 Aug 2014 13:09:39 +1000
Message-ID: <20140824130939.461501b4@notabene.brown>
References: <20140823163110.GE11855@bitfolk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/nXZUD7bVMFuU.aV5FeSzc72"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140823163110.GE11855@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@strugglers.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/nXZUD7bVMFuU.aV5FeSzc72
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 23 Aug 2014 16:31:10 +0000 Andy Smith <andy@strugglers.net> wrote:

> Hi,
>=20
> I am aware that for a very long time it was not possible to change
> the number of devices in an mdadm RAID-10. But then recently I am
> sure I saw threads here alluding to this being possible. e.g.:
>=20
>     http://marc.info/?l=3Dlinux-raid&m=3D140768923829685&w=3D2
>=20
> I have a 6 device RAID-10 near=3D2 array that I would like to shrink
> down to 4 devices.
>=20
> I have compiled mdadm 3.3.2 and am using kernel 3.16.0.
>=20
> $ sudo mdadm --detail /dev/md2
> /dev/md2:
>         Version : 0.90
>   Creation Time : Sun Jun  4 08:18:58 2006
>      Raid Level : raid10
>      Array Size : 471859200 (450.00 GiB 483.18 GB)
>   Used Dev Size : 309363520 (295.03 GiB 316.79 GB)
>    Raid Devices : 6
>   Total Devices : 6
> Preferred Minor : 2
>     Persistence : Superblock is persistent
>=20
>     Update Time : Sat Aug 23 15:23:38 2014
>           State : active=20
>  Active Devices : 6
> Working Devices : 6
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>          Layout : near=3D2
>      Chunk Size : 64K
>=20
>            UUID : 3905b303:ca604b72:be5949c4:ab051b7a
>          Events : 0.312149991
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8       51        0      active sync   /dev/sdd3
>        1       8       67        1      active sync   /dev/sde3
>        2       8       83        2      active sync   /dev/sdf3
>        3       8       19        3      active sync   /dev/sdb3
>        4       8       35        4      active sync   /dev/sdc3
>        5       8        3        5      active sync   /dev/sda3
>=20
> $ sudo ./mdadm --grow -n4 /dev/md2 --backup-file /var/tmp/mdadm.backup
> mdadm: Cannot set new_data_offset: RAID10 reshape not
>        supported on this kernel
>=20
> Is that not yet possible, then?
>=20
> (Each device is 320GB so it should all fit with only four of them)

raid10 reshape is only supported for v1.x metadata, and you have 0.90.
This is because it needs to move the data_offset and 0.90 cannot do that.

I see you have already adjusted the --array-size correctly - good.

You can achieve your result by:

 1/ stop the array and assemble with --update=3Dmetadata.  This will conver=
t the
    array to v1.0
 2/ "mdadm /dev/md2 --grow --disks=3D4"  That should perform the reshape.
    You don't need a --backup-file with RAID10 ... or with other arrays if =
you
    have recent tools and enough space before or after.

I guess the error message could be better....

NeilBrown

--Sig_/nXZUD7bVMFuU.aV5FeSzc72
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU/lXcznsnt1WYoG5AQIUIxAAw7wYVulXaninZqAHz/yKBQkFXtBubNws
MRqJ9w36qDXcbmptr7P+UAlwDmwVnno7+4mySPxZ6Y7Y8M4eV8iP9rf9NGPCN0EE
tYPeIZfcampp/I6AowmVLiJxF6xmT8+oQLObQ9EwqR2fZqIPNWdPWYHC0dP2AwT3
VAU2OoydJdibByqaM9YkOoUOcRID6/KYe4qAEri9V7lk6JdOtsdR0qG0hdTDtZhX
BBEgEgTFLEBKdQpRacJQcioG7/3EsnDIQzjQYFKC1nHkqTrWhDD3vsRuVF1pwsaW
BmrjOApQjCe30bPwLeQzvU2jmhnuZ80mLh859msvkdD5ijLAAHvXPRXj79agOYnv
BsP0n7nAryZAnsS3FuXMU352SyJKy76c3kHw5cLaDdd9R0XW2IQlN33vOHfJqFEE
ja+QGBgaBpnYZCMrFncJCx/o2/mKR/c9hxbj4p9DrkbIcCRDvPJiNtnUJI9F6ze5
7NBzRa4NIJByk2P+MuPBYa7y+b9WKsk5NjbxbcBw3agsPtNEI/6RMIm5jCERMPab
auRLVSYWKNwrwzcMosaLf+sqLbiVpqJDW2VKsoS4SCV/iRfNHLumpTNtCy+qAG9I
SQ1o25d5d0Bv+In1OVqLVgLJV5dD6TAs4C1l5yxfBdosES9Ta+jCmlJ+WLxCZniU
1YH8tyjsZ58=
=tFKN
-----END PGP SIGNATURE-----

--Sig_/nXZUD7bVMFuU.aV5FeSzc72--
