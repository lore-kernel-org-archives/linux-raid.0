From: Aaron Sowry <aaron@cendio.se>
Subject: RAID10 Performance
Date: Wed, 02 Mar 2011 09:50:47 +0100
Message-ID: <4D6E04E7.6060605@cendio.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5409455D807E329E53458B64"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5409455D807E329E53458B64
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,

I have been testing different RAID configurations on a 2-disk setup, and
have a couple of questions regarding performance. The information I have
found online so far seems to contradict itself fairly regularly so I was
hoping for a more coherent answer :)

1) As I understand it, a RAID10 'near' configuration using two disks is
essentially equivalent to a RAID1 configuration. Is this correct?

2) Does md RAID1 support 'striped' reads? If not, is RAID1 read
performance in any way related to the number of disks in the array?

3) From what I have read so far, a RAID10 'far' configuration on 2 disks
provides increased read performance over an equivalent 'near'
configuration, however I am struggling to understand exactly why. I
understand the difference between the 'near' and 'far' configurations,
but not *why* this should provide any speed increases. What am I missing?=


4) I have performed a(n admittedly fairly basic) benchmark on the same
system under two different configurations - RAID10,n2 and RAID10,f2
using tiobench with default settings. In short, the results showed a
significant speed increase for single-threaded sequential reads (83Mb/s
vs 166MB/s), some increase for single-threaded random reads (1.85Mb/s vs
2.25Mb/s), but a decrease for every other metric, including
multi-threaded sequential and random reads. I was expecting write
performance to decrease slightly under RAID10,f2 compared to RAID10,n2,
but am slightly confused about the multi-threaded read performance. Is
it my expectations or my testing that needs to be reviewed?

Cheers,
Aaron


--------------enig5409455D807E329E53458B64
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNbgTrAAoJECw8YUUfeQL9afEH/3OV3CK5ysUB/5RsNeUhlY7R
8NVc09BxNHfT0b13Co20I8jI+GWjjfmiwY0emQrFI4C/Gpc45CcKlru6r27zD9qE
X++S+gb5G3O+syP1oyX4yM8OP/oA1tcqm88QfmkpDfO/+UfeH5jjhNCenZDq1YZj
DL/1B5tjB0OMp0+5enZfvx241nOFDTC+m1ZeYQfNCwXjzGLeHQYlh1/YZ+L7aAfu
qidH+iKt8ubh3DLcxkLBDkv4AKL8jR+aeRjyRArxt8DvIojU+0RthGUm9vSNT6Dl
Ci6SPcnP2FYzQUsx4L4MOdYLgEoET3luf2QXLeFHNHtl80RMLDr3SEU8qXVzUlE=
=Joih
-----END PGP SIGNATURE-----

--------------enig5409455D807E329E53458B64--
