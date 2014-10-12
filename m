From: NeilBrown <neilb@suse.de>
Subject: Re: Is it safe to shutdown while mdadm --grow is in progress.
Date: Sun, 12 Oct 2014 19:35:55 +1100
Message-ID: <20141012193555.69907c13@notabene.brown>
References: <543A15A6.5010508@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/4LQ0lGOqV7auPqne.7aSrqi"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <543A15A6.5010508@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/4LQ0lGOqV7auPqne.7aSrqi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 12 Oct 2014 00:46:14 -0500 Ram Ramesh <rramesh2400@gmail.com> wrote:

> I googled this topic and got differing answers. Some old ones report=20
> horror stories and others suggest rebuild continues after reboot=20
> normally. My array is rebuilding and it will take about 6 days to=20
> complete. I am expecting bad weather in a couple of days and would like=20
> to proactively shutdown the machine and reboot. Is this safe?
>=20
> If the information is already available in a clear manner, please let me=
=20
> know.
>=20
> uname: Linux xxx 3.13.0-37-generic #64-Ubuntu SMP Mon Sep 22 21:28:38=20
> UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
> mdadm - v3.2.5 - 18th May 2012
>=20
> Thanks for your help
>

It is certainly designed to be safe and my experience is that it is.
However it is difficult to test all corner cases so it is not impossible th=
at
someone what quite work right.
If something does go wrong:
 1/ don't panic
 2/ don't try to --create the array to fix it
 3/ report all details to this list and I'm 99.9% sure I can get your array
    running again with all your data safe.
But I suspect it won't come to that.

NeilBrown

--Sig_/4LQ0lGOqV7auPqne.7aSrqi
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVDo9aznsnt1WYoG5AQIsHxAAjxO5Cv3NDFSiU6OgqvzUH6GHmhwblnqF
Rc5mGKcdjSKPfLVPzGE+10LhL/RwrFxymImLY/9LhzJgC180ReNMVkywAEJqt9tP
kQPngKDqLkX3Z1W7RZWiAL4eReYubopLtgGePb+57JefLbalAkt5BIq+ff9bRgBN
lKNKbi7ovXYVbuz+LRH7vnJ/ftkl2pngL6wFYrznfn+g2yidOOhMAN/fBzAf310X
+otMq1yTtUOH6DMeV+2mj1jV/Ad4uDhLRjVn1aqA2OwYe65VaDIIN9W7KRBnBF9G
2sWU+8uC9ZWB3KwxVJuXyHz/1ooc/bYgTY+2JNM3N0JmkG9M80cZ9cwXSx/Q659t
HXgEw5C2Pn0h96AKx5ynsOJHbds6xxWi+XC7sfZV993NaKvithf0X6Y/RIsscN1D
3kGbml+QYk0Nd7h/IppGjyXnfM1ZQg8qk42x9g+fB9w+69UVET2HIsV8UF49+udY
AcbrZvuJMlsefBsKvIJev+nKmTP1z6wFVJuBQWzgwkysT86Wq1v2y73yi6FY7Eez
tKQgAC3WhU8wtC+2IQ9M6hQ7CpI8GMC3p0IMVuKsOcOtJ32RC0JYl+GTwidYs9BE
ktDMfkfePM7deYsW4VKstS8yqAbF412Zy6vJPK/8wliCgJz67qMCRxe/If+OUFUU
uHIThxDqllY=
=QF9N
-----END PGP SIGNATURE-----

--Sig_/4LQ0lGOqV7auPqne.7aSrqi--
