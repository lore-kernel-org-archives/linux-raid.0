From: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Subject: Need pointers to shrinking an array
Date: Sun, 18 Sep 2011 16:50:00 +0200
Message-ID: <1316357406.15583.7.camel@michal-laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-/nFifDoB4Hh7HQTFrOI6"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-/nFifDoB4Hh7HQTFrOI6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi again,

Given an array with --examine like so:
> /dev/sdf1:
>           Magic : a92b4efc
>         Version : 1.1
>     Feature Map : 0x0
>      Array UUID : 9ce41f94:7489a7f2:6897e4b5:269c8b3b
>            Name : media:2  (local to host media)
>   Creation Time : Sun Jan 24 22:32:58 2010
>      Raid Level : raid6
>    Raid Devices : 10
>=20
> Avail Dev Size : 1953519738 (931.51 GiB 1000.20 GB)
>      Array Size : 15628156928 (7452.09 GiB 8001.62 GB)
>   Used Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
>     Data Offset : 264 sectors
>    Super Offset : 0 sectors
>           State : clean
>     Device UUID : 97945e4f:9f439aec:951cb289:47862ad7
>=20
>     Update Time : Sun Sep 18 16:31:52 2011
>        Checksum : 4da159ea - correct
>          Events : 4381317
>=20
>          Layout : left-symmetric
>      Chunk Size : 256K
>=20
>    Device Role : Active device 7
>    Array State : AAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)

On it, a resized filesystem:
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/md2             1982282708 1970782580  11500128 100% /mnt/store.tmp

I now need to shrink the array to as few drives as possible. I know
`mdadm --grow --array-size=3Dx` will let me check if the resulting FS is
still fine. Is x in Kibibytes, same as for --size? What's the best way
of determining x?=20

Then, a `mdadm --grow --raid-devices=3Dy` will let me reduce the number of
drives used. Is there a way to tell _which_ drives are to be active and
which - spares in the resulting array?

Is there anything else I should know?

Regards,
--=20
Micha=C5=82 (Saviq) Sawicz <michal@sawicz.net>

--=-/nFifDoB4Hh7HQTFrOI6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOdgUYAAoJEGnv7NPGHSZFTigP/0atu5LE3IqL4BalOBISSMMX
ZkeHoQn70C8FE+uXccC1Xhf4ThwqfdP2gpchK7VkjkIUVpza1S1QzQ4Yt8j+ZFKO
okc2yjKjaNVb07J+hCOIpXPDnMXyJ2qt8n5wegmh+OVXbaCgX5jMom4zoKIG1cxF
XgqXQgHb9dyqQHrD1xg9zgFA9uwUs1rVAXEGWscxu/O3/aLYEK5DDHQogaROaaAA
EOg2igCxyXMkjxegg49wezls4ryIPmbBi0sPa4OStxlMhyG2vzPJewF7heyPXK+0
opxNdoscHub5cLal3BIPq0Hfd6LVJu5q9lEphBizYjig1V74J7QOvgCgaZp0EtwL
6up0Xm72ljfyDdg9p2neZI5jDtSNK/YzgFprB93jdKRWReqk0VnDK21VAVBd6MoI
0OHIf1VvgL7qQ0gDY2zH/3EagAZqoAMLCckIzN12/27+KvZNKyzyDZ0k0prh8v1a
sf6A+a6bw6N4eYcS3fmCZ3U4vgxxOUySa0pgZ4hpZsseU8oAmB19mlBpaz/iVDEO
vaTqWOhqjPEMdI4iInOWCMOh10bWKlZGfBOkN+hn1UrYl/TwLRT6WHXYNLGjJLOy
s9msfrbiWzFE2UUupVqfBXLk5ibaYuKuQ/RJC42TFFbOxvxgcuStT38L+57kydnD
hNpxSeStwU5aB9b0TgOR
=ob7x
-----END PGP SIGNATURE-----

--=-/nFifDoB4Hh7HQTFrOI6--

