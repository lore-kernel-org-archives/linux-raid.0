From: =?UTF-8?B?TWljaGHFgiBTYXdpY3o=?= <michal@sawicz.net>
Subject: Help with data recovery - RAID6 with 2 failed drives and another
 with broken sectors
Date: Tue, 01 Oct 2013 01:23:08 +0200
Message-ID: <524A07DC.1040002@sawicz.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="BcsxtSELLPH2C4uqVi5c6O47lj38JjTPc"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BcsxtSELLPH2C4uqVi5c6O47lj38JjTPc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hey all,

So the nightmare came for me - I've a 7x2TB setup under RAID6, and one
of the drives started showing uncorrectable sectors a few days ago, but
I didn't yet have time to address that. I had two-disk redundancy, after
all...

Soon thereafter the cables / controller spew a slew of errors and the
array was stopped. A --force --assemble later it was back up, rebuilding
onto 2 spares - I was left with no redundancy. If only the bad sectors
drive was one of those two, everything would be fine. Unfortunately
that's not the case, so I'm now left with an array with read errors. So
it fails during rebuild due to those.

What I'd like to do first is to make sure the array rebuilds onto the 6
healthy drives, regardless of the bad blocks, I can probably recover the
data (assuming I can find out which files were affected - any
pointers?), but if the array doesn't rebuild correctly, I'm afraid it's
gonna get worse, and soon.

I could probably use the data from the two spares to correct the few
broken blocks, but it's probably not worth it - I'd rather have a
working array with a few bad files than to fight with an unprotected arra=
y.

Please find some details about my array below, and let me know if I can
supply more.

As a side note... I've a full array scrub enabled on the array every now
and again - and it did run after the disk started failing blocks, but
they never got reallocated, they all remain pending / uncorrectable. Is
that expected?

> # mdadm --examine /dev/sda
> /dev/sda:
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
>     Device UUID : 3b40e74a:c9b652ce:6810bdcd:d2648b69
>=20
>     Update Time : Tue Oct  1 01:06:35 2013
>        Checksum : a0ddd145 - correct
>          Events : 753179
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>    Device Role : Active device 3
>    Array State : AAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)


> # cat /proc/mdstat=20
> Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]=20
> md126 : active raid6 sdg[9] sdb[8] sdh1[6] sdc[7] sdf1[5] sda[10] sdi[1=
1]
>       9767559680 blocks super 1.2 level 6, 512k chunk, algorithm 2 [7/5=
] [UU_UUU_]
>       [=3D=3D=3D=3D=3D=3D=3D=3D>............]  recovery =3D 44.4% (8676=
04356/1953511936) finish=3D605.9min speed=3D29866K/sec

Thanks and best regards,
--=20
Micha=C5=82 (Saviq) Sawicz <michal@sawicz.net>


--BcsxtSELLPH2C4uqVi5c6O47lj38JjTPc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSSgffAAoJEGnv7NPGHSZFBKkQALsXmjnQ+dYk5FY/8GCJHSD7
nbXyKt5439kr3c4SdYp0dDv0cbUvFDb7xkO5md8+/X0BVU0p2CWP6UEwhg7EdmTE
wHvuUknwKzw4P5tybCKoGzQ1RX1mgltJYYt7kc6oLrgDkjIVc95jZzMzRi7EThuT
aq2Npdyiuqd9bHKyKbwN0og96AkLeYi6eMuHZsc4MohjVYrFJ5J2rJu7+5rsqQmK
d9R6UZ+W4IO7a96gZplEo8KBUwe56127hvpqbgDa5IU9ltODiIZwpcPyFuxRSpl/
JyTnoM9jEx4Zdzsn45Sqv1rrEQk4DlZjPV17IAWdiViB+JiZHRoQEyjM4BW7hyJ7
3s/Y4BgNZttS+exZFwiAL/YblRN0HQ+aqK7Yer2a3qembqOqkqCYOkKHLWJYYfAj
xaA2pfHq+VbehNTksWi39QEklH49OYwo2pghBo4QZb//RcT7g7aKngZJ3bIE1IDN
1pYoDhz56DIqgCMrICepdmUTQp9zBWX9+31nj5fUtPBw8knHbZknHrriQPoo+xnn
AuxP2II2knLNA72sOcgqrkHjqjlL+1/qfyhg41gXRVHxl387Cd8LHFcfdWoJTSVt
kaLj6P4qCj08KDHK9fxg/ZUF6+Rkvv1RSHQhfCOZ6dcqwHSnoYRYWI779zMV7dYF
RZ5ocmUgIg5cpgZch5oD
=xkdh
-----END PGP SIGNATURE-----

--BcsxtSELLPH2C4uqVi5c6O47lj38JjTPc--
