From: NeilBrown <neilb@suse.de>
Subject: Re: possible bug - bitmap dirty pages status
Date: Wed, 16 Nov 2011 14:07:07 +1100
Message-ID: <20111116140707.162d07e2@notabene.brown>
References: <CAGqmV7oKNSj2UjEKyqwE2qKrTj9Gj5-OZxwUAVw+uMh1TTRXuA@mail.gmail.com>
	<CAGqmV7pjvEHaNWjuZzt+tSsUJOM28ZqDY6qUROzz8GtMGCxDow@mail.gmail.com>
	<CAECXXi5eo3J8PPXP5xTm-PrqazC_fkwNnjtiAGM4NtsGBMahHA@mail.gmail.com>
	<4E5E2F7D.1010306@anonymous.org.uk>
	<CAGqmV7p=oM_TJoBC-=he3TnJwcmbZBekq14yjiba_p90RC+0BQ@mail.gmail.com>
	<CAECXXi7Ui6T2kti1JjA6Txft7LXR_sM1QbUkmgXj92kSXPrfCg@mail.gmail.com>
	<CAGqmV7qKjV1QL_GgxGqmLL2BSui+HVxRo=82KHuW0oLONH1D_A@mail.gmail.com>
	<20110901154022.45f54657@notabene.brown>
	<4EC1A037.4080406@fastmail.fm>
	<CAGqmV7qpQBHLcJ9J9cP1zDw6kp6aLcaCMneFYEgcPOu7doXSMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/jiLtPvMdPfkon+B4dgJihR4"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGqmV7qpQBHLcJ9J9cP1zDw6kp6aLcaCMneFYEgcPOu7doXSMA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: linbloke <linbloke@fastmail.fm>, Paul Clements <paul.clements@us.sios.com>, John Robinson <john.robinson@anonymous.org.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/jiLtPvMdPfkon+B4dgJihR4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 16 Nov 2011 03:13:51 +0400 CoolCold <coolthecold@gmail.com> wrote:

> As I promised I was collecting data, but forgot to return to that
> problem, bumping thread returned me to that state ;)
> So, data was collected for almost the month - from 31 August to 26 Septem=
ber:
> root@gamma2:/root# grep -A 1 dirty component_examine.txt |head
>           Bitmap : 44054 bits (chunks), 190 dirty (0.4%)
> Wed Aug 31 17:32:16 MSD 2011
>=20
> root@gamma2:/root# grep -A 1 dirty component_examine.txt |tail -n 2
>           Bitmap : 44054 bits (chunks), 1 dirty (0.0%)
> Mon Sep 26 00:28:33 MSD 2011
>=20
> As i can understand from that dump, it was bitmap examination (-X key)
> of component /dev/sdc3 of raid /dev/md3.
> Decreasing happend, though after some increase on 23 of September, and
> first decrease to 0 happened on 24 of September (line number 436418).
>=20
> So almost for month, dirty count was no decreasing!
> I'm attaching that log, may be it will help somehow.

Thanks a lot.
Any idea what happened at on Fri Sep 23??
Between 6:23am and midnight the number of dirty bits dropped from 180 to 2.

This does seem to suggest that md is just losing track of some of the pages
of bits and once they are modified again md remembers to flush them and wri=
te
them out - which is a fairly safe way to fail.

The one issue I have found is that set_page_attr uses a non-atomic __set_bit
because it should always be called under a spinlock.  But bitmap_write_all()
- which is called when a spare is added - calls it without the spinlock so
that could corrupt some of the bits.

Thanks,
NeilBrown


--Sig_/jiLtPvMdPfkon+B4dgJihR4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTsMo2znsnt1WYoG5AQK81RAAp/xNDlUiDsrE4jAOxx7GzpaMJxT6RU61
n4Zvn02ldlHild8/fQPNn3DIei2hstPkMpHh0bbzsnywAIEJC9WN7oYHXxNO3u17
T5myeGC8Ugugbudy36Yay+jtKSpAVJxfys1ghbIuSraVyx08dBL/wZeiLOVNWlvR
IBMumqMP+921BAHNPLAYtLuRyUEVrWn30nZpJL9gHxQ0SRbtVeUYUSPHtOBklcux
gMZUCKgotrjz5L2SN6yMPhW4z5ia6irt1elR0XP28X0PN2PV7D3Q8ToEL+ZPbAi3
PQd5rnkXOxX0zGiJgYQSonjipLiINx+UJDzQogJPxqJwucvRd4U7pu0EZMj65ZMZ
qECtGOmj7OS2XYAY1C2LR080OClVsv7AYbPbQYsf8nAvrj5oSYAF4ojJzBVlOGcz
GQGNO50QyCxFabO9ldj7SndqoHsmoW+bKkYfwJPi+nIIk0wpP6CAnBHXAa/fJO4b
rP0VaxqG1WBM/H4rKPp1/VU94tyxB//bLuVNa9CuHdNjExRLB3W0C5cFv9k4JGGU
NuNWBxs2yKEZlA4jCg3/G0it7aJGjCeRLyW5oNpVe4KroUXFi6nmjZCEDwb1UfQP
7fnyQjnHDxcd76eZV1Fpl7uInKcS3DcAQHijJbFDU2vyWsSdDbsbRu6CjTMzpxKl
zXlwQU+la28=
=QsYd
-----END PGP SIGNATURE-----

--Sig_/jiLtPvMdPfkon+B4dgJihR4--
