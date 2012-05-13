From: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Subject: Failed, but "md: cannot remove active disk..."
Date: Sun, 13 May 2012 20:21:48 +0200
Message-ID: <1336933308.2831.4.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-73aDwLFNm4OpK9ewdPsk"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-73aDwLFNm4OpK9ewdPsk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey,

I've a weird issue with a RAID6 setup, /proc/mdstat says:

> md126 : active raid6 sda1[3] sdh1[6] sdg1[0](F) sdf1[5] sdi1[1] sdc[8] sd=
b[7]
>       9767559680 blocks super 1.2 level 6, 512k chunk, algorithm 2 [7/6] =
[_UUUUUU]

So sdg1 is (F)ailed, yet `mdadm --remove` yields:

> md: cannot remove active disk sdg1 from md126 ...

in dmesg...

`mdadm --examine` shows:

> /dev/sdg1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : ff9e032c:446ed0bd:fc9473f3:f8e090ed
>            Name : media:store  (local to host media)
>   Creation Time : Tue Sep 13 21:36:43 2011
>      Raid Level : raid6
>    Raid Devices : 7
>=20
> Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)
>      Array Size : 19535119360 (9315.07 GiB 10001.98 GB)
>   Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 4bcee8e2:709419b6:fbeb3a8e:5c9bb68a
>=20
>     Update Time : Sat May 12 21:57:27 2012
>        Checksum : ffb03189 - correct
>          Events : 304564
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>    Device Role : Active device 0
>    Array State : AAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)

So that superblock thinks it's active, but that's normal, right? It
wasn't updated due to fail? Others correctly show:

> dev/sdc:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : ff9e032c:446ed0bd:fc9473f3:f8e090ed
>            Name : media:store  (local to host media)
>   Creation Time : Tue Sep 13 21:36:43 2011
>      Raid Level : raid6
>    Raid Devices : 7
>=20
>  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
>      Array Size : 19535119360 (9315.07 GiB 10001.98 GB)
>   Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : b713fd2b:eef145b0:ce91de0a:9077554b
>=20
>     Update Time : Sat May 12 21:57:57 2012
>        Checksum : 80345876 - correct
>          Events : 304581
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>    Device Role : Active device 2
>    Array State : .AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)

Any ideas?

Cheers,
--=20
Micha=C5=82 Sawicz <michal@sawicz.net>

--=-73aDwLFNm4OpK9ewdPsk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPr/u8AAoJEGnv7NPGHSZFSeYQAMxZcZkJw4ttSK+Ten/3cGt1
LUc1Qu01s4XFB7CSZwRNZkM8BmYuZRCVBte9JndMOBzXUkiflUkz5/Brs600L3qB
wH1+7WQCjIC9NepqE8SkEGigYEDSzgpf6SVIf15s2wtsrb3gnsMT6mRU6Z1F1uSZ
x5bjZH5ADvU6pvOQDtKRVObO60aR5/TRXH9PP/7ViFU1uLJ3oj6XaO5NrP3uhPkn
S8VSw4x9HYHxJZPaSTkbJjr3CbFR0nF0CdaGqLA2h7hz5eDJTyk/Kq9vPnbKSidL
/ThqswuSHiRziXMIeF6pNwAQXzd9gfTnWvPrPbp3yKFNPIC50U0sIJqEANlrXkJn
b7vwcqxGg4blzLqliHHcABNr2fR9BUC7OX5CAoWW5fBm/c9KvDxSh4t1MtNjMt8U
RMnKdNkQ1WFnossoKFVWPtcPSASiEJiZKey2np1mmKGEviX0c36Ble4oKvp3F7r2
I70Z9wFxH1iBOOk0V41nfOmqgwZQPR+LM53bPInwO4amFJPX3FJgp1FSOGOly/3h
ayQzMUABiAvt4LPPeKzJbqxKoGk/EfLDNCmLNp0Z+Dp+grmih+AbcUcsRo19Lc1H
J7fEhyaYI+uEE78efjWwZ81YmYFg53pKZqf2hJfYItTCxaHSONtnQqXrHnOAl4QK
rE0fkoxhqee0i1xo4fjF
=MzKb
-----END PGP SIGNATURE-----

--=-73aDwLFNm4OpK9ewdPsk--

