From: NeilBrown <neilb@suse.com>
Subject: Re: raid-1  starting with 1 drive after brief hiatus with cruddy controller.
Date: Mon, 19 Jun 2017 06:59:18 +1000
Message-ID: <871sqh57x5.fsf@notabene.neil.brown.name>
References: <20170618001410.6fa96469@e20>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170618001410.6fa96469@e20>
Sender: linux-raid-owner@vger.kernel.org
To: "r23@anchordrop.net" <r23@anchordrop.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Sun, Jun 18 2017, r23@anchordrop.net wrote:
>
> root@mars:~/raid/bin# mdadm --misc --examine /dev/sdb2
> /dev/sdb2:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : 2a3489a6:b430c744:2c89a792:98521913
>            Name : debian:0
>   Creation Time : Sat May  9 17:44:25 2015
>      Raid Level : raid1
>    Raid Devices : 2
>
>  Avail Dev Size : 9765179392 (4656.40 GiB 4999.77 GB)
>      Array Size : 4882589696 (4656.40 GiB 4999.77 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262056 sectors, after=0 sectors
>           State : clean
>     Device UUID : 4697b088:5d3b1ae5:55d30f65:516df63d
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Wed Jun 14 23:53:27 2017
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 1f245410 - expected 1f249410

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

checksum is wrong.

> root@mars:~/raid/bin/util/lsdrv#  mdadm --assemble /dev/md/debian:0  -v /dev/sdb2 --run
> mdadm: looking for devices for /dev/md/debian:0
> mdadm: /dev/sdb2 is identified as a member of /dev/md/debian:0, slot 1.
> mdadm: no uptodate device for slot 0 of /dev/md/debian:0
> mdadm: failed to add /dev/sdb2 to /dev/md/debian:0: Invalid argument

Bad checksum caused kernel to reject the device.

There is no obvious way to correct the checksum, but I think you can
force it by using the --update option to --assemble
e.g.

  mdadm --assemble /dev/md/debian:0 --update=name -v /dev/sdb2

When doing that, you should check that other fields all look correct
first, because something must have changed to affect the bitmap.
(I cannot see anything that looks wrong)

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAllG6agACgkQOeye3VZi
gbk30A/+Nm/n6CFEG82jnrY2GW9C1U3h2ooJYhKMTPzAmOM0lzRzDRsVpKkiN9kt
KEYLvF3n4GZ8ssUQxtp8O+gUZhAdB/xXtMMV62X+M7E5+8RJTeQaKxHx/vxYU7X6
BnVI+SDajALz9CtPs8+YQ41sVPdkGnUZU5GZ8Uqsx4CDIzKVjIhY9k0JcQp0J1nN
ibSw11dAeY/nMMSXZUXE4bkP+9SVADJ6J88WwfVtWozvAMA0g1ELGVMqp8DrshYi
i7z4HcuBuoYJ3Ha32lyByKSb0D4CR2WwNQtUo2O3XBoE5w34AGBGIwkFvkK27dQv
Vt5HS4yfGm/R29KYXWdqWHio1AaBOeRw1bzoBCW9u5nrgnZXgeBRIY1E/AbYbSNP
N3xTEan+wc/TDMGUIFp72HUIgxbdsU7922xPpg9vg439GKqCvVXDhMApx4TyliHl
yRawgnPVuttDpGqr4AbhhyovgBejO9SB0r+QKhTE97Z6Uat2xR9eeiavpYKMY4Zh
Yujqa2yrfUEfzTRIeyLlvol3veHrKSiU8IsC/4nQ0STkCtRSwilY2IQrfWv8vnks
Y+A88m536q1IJgOKhwkO/5bQXkZZNf8Zl1NVkxmGBN5zUI4tXpHGt5iuNxR/ep/V
9AXpTkwjJpQacpYwU2jkVP38ww8Y61YxrVqn13rem45k1H4ze/s=
=GkaP
-----END PGP SIGNATURE-----
--=-=-=--
