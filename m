From: Georgi Alexandrov <teh@amln.net>
Subject: write-behind performance ... or how behind can write-behind write
Date: Fri, 13 Feb 2009 18:36:00 +0200
Message-ID: <4995A170.4000000@amln.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFE5BD0F78FA30F5D6065E721"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFE5BD0F78FA30F5D6065E721
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello,

I've been going through the list archives to find a similar thread but
couldn't.

The setup:

debian lenny 2.6.26-1-amd64
raid1 array with 1 SSD disk and 1 regular SATA disk. It will be used for
a DB.

What I'm trying to achieve is to make the system read from the SSD disk
as long as the array is healthy and write delayed on the regular SATA
disk to benefit from the good random write performance of the SSD disk.

So far I've managed to achieve only the first goal - make the system
read from SSD on healthy array via the write-mostly option.

The problem is with the second option - write-behind. I've enabled it
and made two tests (one with healthy array and one with the SATA disk
marked as failed) with tiobench and the results are not good(1).

Generally with the healthy array I'm getting the write performance of
the SATA disk alone (in terms of requests/sec issued to the disk and
bytes/sec written). The SATA disk is obviously a bottleneck even with
the write-behind option set(2).

With a failed array (SSD active only) I'm getting the great write
performance of a SSD disk(3).



1. tiobench stats:

Unit information
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
File size =3D megabytes
Blk Size  =3D bytes
Rate      =3D megabytes per second
CPU%      =3D percentage of CPU used during the test
Latency   =3D milliseconds
Lat%      =3D percent of requests that took longer than X seconds
CPU Eff   =3D Rate divided by CPU% - throughput per cpu load

Healthy Array Random Writes (~4 MB/sec):

                              File  Blk   Num                   Avg
 Maximum      Lat%     Lat%    CPU
Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency
 Latency      >2s      >10s    Eff
---------------------------- ------ ----- ---  ------ ------ ---------
-----------  -------- -------- -----
2.6.26-1-amd64                2000  11264   1    4.34 0.687%     0.007
      0.03   0.00000  0.00000   632
2.6.26-1-amd64                2000  11264   2    4.26 2.299%     0.012
      0.04   0.00000  0.00000   185
2.6.26-1-amd64                2000  11264   4    4.12 6.018%     0.019
      0.13   0.00000  0.00000    68
2.6.26-1-amd64                2000  11264   8    4.13 7.611%     0.020
      8.94   0.00000  0.00000    54


SSD-Only Array Random Writes (~135 MB/s):

                              File  Blk   Num                   Avg
 Maximum      Lat%     Lat%    CPU
Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency
 Latency      >2s      >10s    Eff
---------------------------- ------ ----- ---  ------ ------ ---------
-----------  -------- -------- -----
2.6.26-1-amd64                2000  11264   1  138.12 21.85%     0.007
      0.03   0.00000  0.00000   632
2.6.26-1-amd64                2000  11264   2  135.82 70.80%     0.012
      0.05   0.00000  0.00000   192
2.6.26-1-amd64                2000  11264   4  135.10 176.0%     0.018
      0.07   0.00000  0.00000    77
2.6.26-1-amd64                2000  11264   8  145.38 380.3%     0.020
      3.45   0.00000  0.00000    38


2. healthy array iostat output (sda1 being the SSD disk):
Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
avgrq-sz avgqu-sz   await  svctm  %util
sda1              0.00 14183.50    0.00  220.50     0.00    56.27
522.59     5.23   23.70   1.25  27.60
sdc3              0.00 14272.00    0.00  129.50     0.00    56.99
901.22   137.77 1108.25   7.72 100.00


3. ssd-only array iostat output:

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
avgrq-sz avgqu-sz   await  svctm  %util
sda1              0.00 51941.50    0.00  483.00     0.00   209.70
889.16   140.81  282.74   2.07 100.00
sdc3              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00


So the questions is How behind can write-behind write? And can we get a
better performance in a similar setup.

thanks upfront!

--=20
regards,
Georgi Alexandrov
key server - pgp.mit.edu :: key id - 0x37B4B3EE
Key fingerprint =3D E429 BF93 FA67 44E9 B7D4  F89E F990 01C1 37B4 B3EE



--------------enigFE5BD0F78FA30F5D6065E721
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmVoXAACgkQ+ZABwTe0s+6DhwCgkgwy3sLV3Mr+LmvJ7TMxsAsI
daEAnRPYgnETm0MxB4w+Z7XNZwANnBEr
=U5Dc
-----END PGP SIGNATURE-----

--------------enigFE5BD0F78FA30F5D6065E721--
