From: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Subject: Re: Auto-assembling RAID6 over RAID0?
Date: Thu, 27 Oct 2011 14:59:52 -0400
Message-ID: <1319741992.26486.9.camel@michal-laptop.sawicz.net>
References: <1319740079.26486.7.camel@michal-laptop.sawicz.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-y1X2qwJRI2pvgQX/Npyh"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1319740079.26486.7.camel@michal-laptop.sawicz.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-y1X2qwJRI2pvgQX/Npyh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dnia 2011-10-27, czw o godzinie 14:27 -0400, Micha=C5=82 Sawicz pisze:
> I have a RAID6, one member of which is a RAID0 (see attached --examine
> output).

The missing examine for the raid0 array:
> /dev/md/substore:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : ff9e032c:446ed0bd:fc9473f3:f8e090ed
>            Name : media:store  (local to host media)
>   Creation Time : Tue Sep 13 21:36:43 2011
>      Raid Level : raid6
>    Raid Devices : 7
>=20
> Avail Dev Size : 3907033088 (1863.02 GiB 2000.40 GB)
>      Array Size : 19535119360 (9315.07 GiB 10001.98 GB)
>   Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 726ec7f2:23b9f207:21796e85:5300ccaf
>=20
>     Update Time : Thu Oct 27 20:11:50 2011
>        Checksum : 7caaaa92 - correct
>          Events : 225384
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>    Device Role : Active device 5
>    Array State : AAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)

--=20
Micha=C5=82 (Saviq) Sawicz <michal@sawicz.net>

--=-y1X2qwJRI2pvgQX/Npyh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOqaooAAoJEGnv7NPGHSZFcAQP/R1TTZGj7fBdGMnR086pM7+T
Y9YsVLvLZHNthltyCN905d7hkvERPzjXHNHeU+M6+j00w3F15bBh5nnKf+dtWlol
7M/kKXL6Ho3RevDVrfTMW2MqVhN+zO8aMO+wEW6FDnwdsxCIc04EBM6SVejXrWb0
YPPw/pHuwmsxqv+iqQLAH3VYALysho8JBpcGMrzK046J+hYzNdCqEIHbdN7Zc3L9
kIg5DzSkev23KCy4J6CFkwFrTubIIrrFupexUJs5iFt7VzYq4bdlzVr6JqdallbL
S4iznUJOHmAvJQkvvDLEPUPzcxTyiga0igHbubOSfsyXZ88n5KSIhmREso8ob5D2
S0fouLH9KxGY14pyHWMxYkfGgApKpe9yNhimaWAuG5jjboNkM3ehOOJVzd/6Y/EC
3xTeq6A3AGidyanikEcEnPYioMWj5gar/L3ND9TGY+QQrjycPQ9btqeGASdCIK1s
LfPF2r0iXQ5dbQ5yj/bRVGyEd+Jf1oXXAGeBBBm+kcsVpuSFgWhGA6RhnPu+HpIo
2YK+k3TkWh2mXBvCK4FijvOcMRH3uTRPdhhT3ag9cBscebvR3XCr1BldKKADRoQI
5Ms054AwR48pTSurqXeVY/9bkQeDKmdFvXmOrkoqcNn61G9Kp1esSSnQ4lbw5+SU
eRiW1amNdPnoLfsxgojz
=j0wy
-----END PGP SIGNATURE-----

--=-y1X2qwJRI2pvgQX/Npyh--

