From: NeilBrown <neilb@suse.de>
Subject: Re: Raid10 and page cache
Date: Wed, 7 Dec 2011 16:10:03 +1100
Message-ID: <20111207161003.0aa181d8@notabene.brown>
References: <CAJygYd16PWfKe8fK-b150N46CEwzBUqJn1N6dfsGR4yyTgGbTQ@mail.gmail.com>
	<CAJygYd3ofkHp9huD_Q1xoKVb_Q2LTDAnFHf-n+8xyG7ug3wC_Q@mail.gmail.com>
	<20111207092625.7140c5dc@notabene.brown>
	<CAJygYd3fM+wtnU0HkN7s7o=FPizbPNPET2A21jxWk-BJZgdFbA@mail.gmail.com>
	<20111207120133.70ca294c@notabene.brown>
	<CAJygYd3j5HwGyZ7rTKZj5dr=cXDOpy3jK=6AyOVKJY0PX3bdtA@mail.gmail.com>
	<20111207152853.42594fc9@notabene.brown>
	<CAJygYd0UeJ04KOZJLkjO1KoBf6t0Ko_jyCw=HerCtehgkG5DUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/gOH7Rg7IuJ9Dhlf8osiUZzx"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJygYd0UeJ04KOZJLkjO1KoBf6t0Ko_jyCw=HerCtehgkG5DUQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Yucong Sun (=?UTF-8?B?5Y+26Zuo6aOe?=)" <sunyucong@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/gOH7Rg7IuJ9Dhlf8osiUZzx
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 6 Dec 2011 20:50:48 -0800 Yucong Sun (=E5=8F=B6=E9=9B=A8=E9=A3=9E) =
<sunyucong@gmail.com>
wrote:

> I'm not sure whether it is what I mean,  to illustrate my problem let
> me put iostat -x -d 1 output  as below
>=20
> Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s
> avgrq-sz avgqu-sz   await  svctm  %util
> sdb               0.00     0.00  163.00    1.00  1304.00     8.00
> 8.00     0.26    1.59   1.59  26.00
> sdc               0.00     0.00   93.00    1.00   744.00     8.00
> 8.00     0.24    2.55   2.45  23.00
> sde               0.00     0.00   56.00    1.00   448.00     8.00
> 8.00     0.22    3.86   3.86  22.00
> sdd               0.00     0.00   88.00    1.00   704.00     8.00
> 8.00     0.18    2.02   2.02  18.00
> md_d0             0.00     0.00  401.00    0.00  3208.00     0.00
> 8.00     0.00    0.00   0.00   0.00
>=20
> =3D=3D> this is normal operation, because of page cache, there's only read
> being submitted to the MD device.
>=20
> Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s
> avgrq-sz avgqu-sz   await  svctm  %util
> sda               0.00     0.00    0.00    0.00     0.00     0.00
> 0.00     0.00    0.00   0.00   0.00
> sdb               0.00  1714.00    4.00  277.00    32.00 14810.00
> 52.82    34.04  105.05   2.92  82.00
> sdc               0.00  1685.00   12.00  270.00    96.00 14122.00
> 50.42    42.56  131.03   3.09  87.00
> sde               0.00  1385.00    8.00  261.00    64.00 12426.00
> 46.43    29.76   99.44   3.35  90.00
> sdd               0.00  1350.00    8.00  228.00    64.00 10682.00
> 45.53    40.93  133.56   3.69  87.00
> md_d0             0.00     0.00   32.00 16446.00   256.00 131568.00
>  8.00     0.00    0.00   0.00   0.00
>=20
> =3D=3D> Huge page flush kick in, note the read requests is saturated on M=
D device.
>=20
> Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s
> avgrq-sz avgqu-sz   await  svctm  %util
> sda               0.00     0.00    0.00    0.00     0.00     0.00
> 0.00     0.00    0.00   0.00   0.00
> sdb               0.00  1542.00    4.00  264.00    32.00 11760.00
> 44.00    66.58  230.22   3.73 100.00
> sdc               0.00  1185.00    0.00  272.00     0.00  9672.00
> 35.56    63.40  215.88   3.68 100.00
> sde               0.00  1352.00    0.00  298.00     0.00 12488.00
> 41.91    35.56  126.34   3.36 100.00
> sdd               0.00   996.00    0.00  294.00     0.00 10120.00
> 34.42    76.79  270.37   3.40 100.00
> md_d0             0.00     0.00    4.00    0.00    32.00     0.00
> 8.00     0.00    0.00   0.00   0.00
>=20
> =3D=3D> Huge page flush still working,  no read is being done.
>=20
> This is the problem , when page flush kick in, MD appears to refuse
> incoming read,  all under laying device is tuned to deadline scheduler
> and tuned to favor read, still, it don't work since MD simply don't
> submit new read to the underlying device.

The counters are update when a request completes, not when it is submitted,
so you cannot tell from this data if md is submitting the read requests or
not.

What kernel are you working with?  If it doesn't contain the commit
identified below can you try with that and see if it makes a difference?

Thanks,
NeilBrown



>=20
> 2011/12/6 NeilBrown <neilb@suse.de>:
> > On Tue, 6 Dec 2011 20:04:33 -0800 Yucong Sun (=E5=8F=B6=E9=9B=A8=E9=A3=
=9E) <sunyucong@gmail.com>
> > wrote:
> >
> >> The problem with using page-flush as a write cache here is that write
> >> to MD don't go through IO scheduler, which is a very big problem,
> >> because when flush thread decide to write to MD,  it's impossible to
> >> control the write speed, or prioritize them with read, every requests
> >> basically is a fifo,  and when flush size is big, no read can be
> >> served.
> >>
> >
> > I'm not sure I understand....
> >
> > Requests don't go through an IO scheduler before they hit md, but they =
do
> > after md sends them on down, so they can be re-ordered there.
> >
> > There was a bug where raid10 would allow an arbitrary number of writes =
to
> > queue up so that flushing code didn't know when to stop.
> >
> > This was fixed by
> >   commit 34db0cd60f8a1f4ab73d118a8be3797c20388223
> >
> > nearly 2 months ago :-)
> >
> > NeilBrown
> >


--Sig_/gOH7Rg7IuJ9Dhlf8osiUZzx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTt71Nznsnt1WYoG5AQJjtg/+NRivzNfmdCeUFySDUok9CcZCNNcCKYhK
wuXWcVhgJwNdayd5mXzidIPztprnmqsq3pV68DMqgFctpmHSAII97D+ok/KFEziK
SJFIURL/aP/yVLrhgdnU1iCJxyJiyqxrTW1N4jq48XrnkjNJiLf4EuoGAHOYcVmS
VrpG8dEjgB99QYQMDcB59u2PF5pl9/sHG3KDLnpEl109+ghguybg4jSy/ZUOQwca
/h7i4aperANBMj/GNVxlFEjYnL6C44317FsmKyFDVDjLG9oIiuMRY6EwK5uEfCJd
9CpwfETRjzZzjMndef2e03sndhyjmiUihqQ7u07yTU3OM1TDprUxDEjo51FZrHdA
tKAGfdBMSWbhAkgjRoV7pasFcIpyDQXQFhaEi/UHJWjwWfM3cU2gk/yPwkd8UhvA
d2hdHrLqSw28Whfp5VcdkVGLCcFb2fyboP5e0MyUZ+GiJ+XU5sDWJcuHYrL+/LHK
pVcUX37UhplR6apFpRBOXRynFXvGbVtQR43WmbkOSz4UD4fS8Izjn6Tl3J45u9ro
wzDDqOq/JR8dlPN0cK7KRoSgCnC2LPELHE0Ds0rqD/HA2nzG6fY25F1kU9YXNU3t
PA9sSAQwdMZr+aU/rb001It9+dehh658M4bcscSUK1KdhT47j+9PEfC8J8ObBjhf
sWy0Bl5ka9c=
=fP50
-----END PGP SIGNATURE-----

--Sig_/gOH7Rg7IuJ9Dhlf8osiUZzx--
