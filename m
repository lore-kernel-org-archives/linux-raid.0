From: NeilBrown <neilb@suse.de>
Subject: Re: Kernel says there is not a valid superblock, but there is
Date: Tue, 21 Oct 2014 08:09:37 +1100
Message-ID: <20141021080937.69aaf214@notabene.brown>
References: <544525C7.7000803@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/nuV2R+25Ala38tjz2r/F1OQ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <544525C7.7000803@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <phillsusi@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/nuV2R+25Ala38tjz2r/F1OQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Oct 2014 11:09:59 -0400 Phillip Susi <phillsusi@gmail.com> wrote:

> When trying to assemble, the kernel complains:

Which kernel?
  uname -a
and may as well add
  mdadm -V

as well.

NeilBrown

>=20
> md: md1 stopped.
> md: sda2 does not have a valid v1.2 superblock, not importing!
> md: md_import_device returned -22
> md: sdb2 does not have a valid v1.2 superblock, not importing!
> md: md_import_device returned -22
>=20
> Yet the superblock looks perfectly fine according to mdadm -E:
>=20
> /dev/sda2:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 34e89993:37821273:5498dc63:07233b2c
>            Name : devserv2:1
>   Creation Time : Mon Jun 16 11:24:00 2014
>      Raid Level : raid1
>    Raid Devices : 2
>=20
>  Avail Dev Size : 3900907520 (1860.10 GiB 1997.26 GB)
>      Array Size : 158334976 (151.00 GiB 162.14 GB)
>   Used Dev Size : 316669952 (151.00 GiB 162.14 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 40c38a87:88807f78:5bf71f34:4c9b2215
>=20
>     Update Time : Mon Oct 20 09:56:25 2014
>        Checksum : d2369656 - correct
>          Events : 303
>=20
>=20
>    Device Role : Active device 0
>    Array State : AA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> /dev/sdb2:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 34e89993:37821273:5498dc63:07233b2c
>            Name : devserv2:1
>   Creation Time : Mon Jun 16 11:24:00 2014
>      Raid Level : raid1
>    Raid Devices : 2
>=20
>  Avail Dev Size : 3900907520 (1860.10 GiB 1997.26 GB)
>      Array Size : 158334976 (151.00 GiB 162.14 GB)
>   Used Dev Size : 316669952 (151.00 GiB 162.14 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 0fb85e8f:e697a9a0:7bd6eac4:03b8851d
>=20
>     Update Time : Mon Oct 20 10:08:35 2014
>        Checksum : 9b63a13c - correct
>          Events : 311
>=20
>=20
>    Device Role : Active device 1
>    Array State : .A ('A' =3D=3D active, '.' =3D=3D missing)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/nuV2R+25Ala38tjz2r/F1OQ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVEV6ETnsnt1WYoG5AQL9Ag//QKYlY+k/ZLKSnRw/IIxUC/pAJnNv3ZTB
IlvBDhYk1xuEHLleU49/MSXI+dWpy/4TG38hbKlBftBTSC3CNMurb/lsm5dbA5eK
IKgrIrERey2zSDH8HCn/d84do9bJXvw3xoApqE+B1WDFsQO6CwRcVEeY6EY6/cYZ
aoVR7r7ffAx/JrUkagznjrdbbAO4qEG6vT1HsfiuqAfnHX655D1z4DKPCZnRc3fx
we9OYYqHLdmNatR0BqVKerZffKRDNlKF+QkXaz/5NoY+r7ix8/zY2P1+vyPutOKS
6SfMPMVVly/m8OmXlkvdUTOpW6OSX1OZOGdG486IN6M+wkHiO0k7zDrg+9A7l1AD
FfLIdsnQmxthHTicm6ztxaeK7onSHb84kAfPI6tgr/C9N6VXVBC2VvlXBkatOG17
s7ER6v7PCNnZvpUsUqJFwPEqu2bbTIQgqLoG8o9omtNxSeRJCSVaJi/8bAvP5y/k
ag6j8q67SBFF1JefE13DFYjiDC0WjzEkCnchUcuxdaxRjnQG5NER/A3truhxuqXm
YCyYd36rjqYspXc8UHkXUL9/8sb/ul6qIAqmzgzKqPWl54MJ8CAeZANFfe4ipGSG
GIi+EMNJI/OD2ca/SFySsfoWMMfH3l4gLw8ZtHj6D615OvQ5bbAX3BVOckwUcy5Z
ji8f1it3Yj8=
=uuRT
-----END PGP SIGNATURE-----

--Sig_/nuV2R+25Ala38tjz2r/F1OQ--
