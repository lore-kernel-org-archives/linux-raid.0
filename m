From: NeilBrown <neilb@suse.de>
Subject: Re: RAID6 rmw - new numbers
Date: Thu, 4 Sep 2014 17:09:29 +1000
Message-ID: <20140904170929.4dce55ad@notabene.brown>
References: <12EF8D94C6F8734FB2FF37B9FBEDD173586419F5@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/8EMvg/amfx8C_zufuuo21nJ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD173586419F5@EXCHANGE.collogia.de>
Sender: linux-raid-owner@vger.kernel.org
To: Markus Stockhausen <stockhausen@collogia.de>
Cc: "john@stoffel.org" <john@stoffel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/8EMvg/amfx8C_zufuuo21nJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 31 Aug 2014 16:05:50 +0000 Markus Stockhausen
<stockhausen@collogia.de> wrote:

> Hello,
>=20
> I had some time for additional benchmarks. My initial numbers
> were too low because I didn't push the system to its limits with
> high parallelism.
>=20
> Test program http://www.corpit.ru/mjt/iot.c
> settings: 180 seconds random write, 3 runs, 64 threads, direct I/O
> command line: iot -d -W64 -b <blocksize> -t 180 /dev/md0
>=20
> bsize    w/o patch   w/o patch   w/o patch
>                min         avg         max
>    4K      317KB/s     318KB/s     319KB/s
>    8K      611KB/s     614KB/s     617KB/s
>   16K     1153KB/s    1153KB/s    1154KB/s
>   32K     2239KB/s    2253KB/s    2263KB/s
>   64K     3944KB/s    3959KB/s    3978KB/s
>  128K     7792KB/s    7891KB/s    8025KB/s
>  256K    15456KB/s   15574KB/s   15805KB/s
>  512K    32406KB/s   32564KB/s   32799KB/s
> 1024K    57378KB/s   57965KB/s   58550KB/s
>=20
> bsize   with patch  with patch  with patch    real  math gain
>                min         avg         max    gain  in theory
>    4K      417KB/s     420KB/s     423KB/s  +32,1%       +66%
>    8K      806KB/s     818KB/s     826KB/s  +33,2%       +66%
>   16K     1504KB/s    1518KB/s    1531KB/s  +31,6%       +66%
>   32K     2993KB/s    3001KB/s    3016KB/s  +33,2%       +66%
>   64K     5396KB/s    5477KB/s    5543KB/s  +38,3%       +66%
>  128K     8971KB/s    9082KB/s    9169KB/s  +15,1%       +25%
>  256K    15406KB/s   15545KB/s   15751KB/s   -0,2%         0%
>  512K    32361KB/s   32619KB/s   32981KB/s   +0,1%         0%
> 1024K    58134KB/s   58239KB/s   58419KB/s   +0,4%         0%
>=20
> As I got no feedback from Neil until now:
>=20
> - Shall I resend the patches with the new numbers?
> - What else can I do to push the patches further?

Sorry I've been silent - there has been lots of other stuff happening.
Thanks for the extra testing - it definitely looks good.
I'll try to move this along soon, no need to resend.

Thanks,
NeilBrown


--Sig_/8EMvg/amfx8C_zufuuo21nJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVAgQKTnsnt1WYoG5AQJnWhAAqXxUuuytadBG22GyawZ/F2uy0EI8puKD
Ws3Q0i+Jo85vfIaVGYHtSiO/khg1kYswiJ0o8o2rk3YiWOuDIHHnTJY6ZJEJ32JF
PJWUhmHNQIAtFB3e9PyKjsjY4EVXW2Q9ZlhzX4IuRG5aYkQ8OcAmrLcXR66Wxom3
o8ysj3kN1TukrSbFUmzgDmqezkzSRicev7uFZq4taYDyIGWaYzmk2YtMxMoLzv8N
LnAHvmVC2ksvMDgTr+4Wdqk0gfTf6BnRBP1WnhhMLJFqozR4K21LVyGRq/3q+32a
JQrlkBNeD7M6AI/YnzAXwgxLUZJwNJkH1aYPeG5B4m9ukbvhKBAg4HHaCSH2gVvq
QnPx04YKJYeGP7E+FpCw93m9tQ2VRSCUJxvOpBCpH5xz/ThKiLgI8/K+rMnH37og
mTv2a6UNpk1aBr3bX52QbmeLWMLsupk8DcWhGIuBENcBkqANW9yoVAjfr80yLzCq
NoGNjIw7gqthXjjMnchRH5S/LJo8V4aEnTtE5o00dTHMj9u7bP4fXsHeq8+wbcJl
JWskpDQw9SGeLIUS+xBHoKSCLoF0QTfZR2SwpV5cZJjnEVhRzLcyACwYWeMpNtmY
EjW73LLtPjVvqzdiuO5GcfM6jm9IBXBFlY19Ev59unaNB+XPPqFJybcquVQurYqd
KYDuat+AI8c=
=6yZ5
-----END PGP SIGNATURE-----

--Sig_/8EMvg/amfx8C_zufuuo21nJ--
