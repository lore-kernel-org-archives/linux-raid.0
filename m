From: NeilBrown <neilb@suse.de>
Subject: Re: Mirroring seek optimization resend
Date: Tue, 9 Sep 2014 12:21:13 +1000
Message-ID: <20140909122113.16b6b953@notabene.brown>
References: <9300C887-1255-4AE6-806B-390332D10382@k9heritage.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/=Upg=tCoDE5zoy/bD447gB="; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9300C887-1255-4AE6-806B-390332D10382@k9heritage.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Long <boblong@k9heritage.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/=Upg=tCoDE5zoy/bD447gB=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 8 Sep 2014 10:13:12 -0700 Robert Long <boblong@k9heritage.com> wrot=
e:

> Hi Again,
>=20
> First, the code base that I was working from is now 2 years old. While I =
doubt that the raid1.c code has changed significantly I could be very wrong=
. At that time the load balancing algorithm was simply to attempt to split =
the actively seeked area of the disk into two parts, and have one disk take=
 the low half and one take the high half. The effect of that, in read inten=
sive applications, is to cut in half the overall seek length for each disk =
in the mirror, resulting in considerable seek time savings and overall high=
er throughput. A moving average of sector addresses needs to be maintained =
to make this work, but this is quite easily done. The more writing happens,=
 the more this advantage is lost. The problem with this approach, though no=
t a large one, is that is that a numerical average is not actually represen=
tative of the middle of the work area due to outliers, clusters of reads, e=
tc.
>=20
> A solution to this is to maintain a running median of the sector address.=
 When this is done you get a measurable increase in throughput, at the cost=
 of greater computational overhead. The method that I used to maintain a mo=
ving median involves the creation of an equal sized min heap and max heap c=
onnected together at the head of each. This connection point represents the=
 current median sector of access requests to the mirror.
>=20
> Today I fired up the machine that I used to develop and test this modific=
ation. It took some time just to locate the modified raid1.c file :) The ma=
chine, in addition to the boot drive, is equipped with a couple of 1 TB Hit=
achi disk drives that were used for test purposes. To be honest I don=E2=80=
=99t remember the name of the test software that I used, but it seems that =
it was a pretty performance standard utility, not something I put together =
myself. Perhaps you could jog my memory. As I mentioned previously the impr=
ovement was around 7% with read only testing of random seeks.
>=20
> If this is of interest I will gladly post the NOT PRODUCTION READY code. =
(I took some shortcuts in the code for testing purposes, primarily in the a=
ssignment of drives to the array so that I didn=E2=80=99t have to figure ou=
t how the existing code does such a nice job of drive allocation.)
>=20
> On the other hand, if the improvement is deemed to be insufficient then I=
 will chuck the code into the dust bin of history. Given the continued rise=
 in the use of SSDs, seek optimization becomes less relevant every day.
>=20
> Please give me some feedback, even if you are not interested let me know =
why.
>=20

Hi Bob,
 If you post the code I'll try to find time to look at it.  If you don't, I
 won't :-)

 I personally have no pressing desire to improve RAID1 read performance, but
 others have occasionally shown an interest in the past.  Maybe they aren't
 paying attention or have lost interest.  Maybe they don't think their
 interest matters (which wouldn't be true).

 To be honest, "I've got some code that once did something good with some
 tests that I don't remember and probably isn't production ready and may not
 even work" just doesn't sound exciting.
 On the other hand "here is some code" at least provides something concrete
 to look at.

NeilBrown

--Sig_/=Upg=tCoDE5zoy/bD447gB=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVA5kGTnsnt1WYoG5AQLkEBAAw1NPG0jLddrItS24ewd6InFHaJmgJlx7
Oj/wSjHv3a3NzcNCl/bFPwn3mcbnFpIJn9lPAbiyDGLR1aaJ3BSnGdcjhbEKhfBZ
22f9yu3MOpkFLmfGIF7puEOthaE8lhUJJX/ytesue3G6uIlkOkFUlO7QUtg7ggud
/yH97BPl80DdEsMXAT3q7Rx0ASMYNjn38GQyEwc8rPJoeM76+sa3r5U3kYbXYDXN
fojUwSdBbfK85lCrGWGwbMfhWVM5t1iWxhlZTW2Gmm2zN/4faQye5kMEy0qgJ1gh
cNCKR0lHN2kgnRIlgkV4OFVTJ8+DmUaFFChzjzYvXjvZsQ7kNnbyfwr0XQz4wTTl
DKV5x90WwL1Ck4zHaTGpWtLcwcvGfbh2HxGYpPVrDLND3HEnazpOMQmkDMJMgnzt
6hU6pPAdh/tQpzZDltXxeY6M9CQF54ld3Iu2jk/u8eGpOBm/ShXYsoUlceuf0FTG
VNqcv749e/t7UDJX3+OFiaiyzygGx5WbTVx0d8I2jRb/oiK9GsWp9LrAx4Pf7DAB
zbZTAo2XoTSLRqlx4fX6diplHfNlV5xZ09gdPnk/fkFSBh7zrUH8I6/CXBZrXeBi
IF16C+TyrmqyFaSO/QdEFdKvSd2zRhL03bwjuy8B6FzpnV8R/m/ViEuKmY1mbtIe
g6/6UQsD/6w=
=RDMp
-----END PGP SIGNATURE-----

--Sig_/=Upg=tCoDE5zoy/bD447gB=--
