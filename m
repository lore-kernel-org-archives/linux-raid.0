From: NeilBrown <neilb@suse.de>
Subject: Re: md/raid5:Fix recover/replace stop if handle stipe failed
Date: Wed, 28 Mar 2012 12:40:51 +1100
Message-ID: <20120328124051.65436de2@notabene.brown>
References: <201203141507458909278@gmail.com>
	<201203141727412189832@gmail.com>
	<20120327142642.3e40547d@notabene.brown>
	<201203271533149067900@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/m1n3j461fKS.1qeiWylaALd"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201203271533149067900@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/m1n3j461fKS.1qeiWylaALd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Mar 2012 15:33:25 +0800 "majianpeng" <majianpeng@gmail.com> wrot=
e:

> I tested and corrected some bug.

Thanks.
I added the compile-error fix.

However I don't agree that we need to set 'abort =3D 1' in the non-RECOVERY
case.

As the comment that I added says:

>         /* There is nothing more to do for sync/check/repair.
> +        * Don't even need to abort as that is handled elsewhere
> +        * if needed, and not always wanted e.g. if there is a known
> +        * bad block here.

Thanks,
NeilBrown


--Sig_/m1n3j461fKS.1qeiWylaALd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3JsIznsnt1WYoG5AQLdmg//aDag+54jA2gLN3BFvh/FLW7HS3XN7Qg2
Wl+xkgZbluy3bdy3fhXWfc34F/ArDXQ46F/lOQ9p8Ul14nkA1VS/uYGk/qp6N4/P
89HzhQNClrarUpqKaXTG/WyDkkyNz5dsiHIjzTBRZgyZNMcG8wcrVDjR2nk8XZHg
5W6acazBzw4EtRebbmFdgvL4tIMcpKNhqZ5pUR/gOFARRzVuGWeKF3QqyXXVyfeN
SFh/sJlIiV3BXeGHRJ92lCDCDahbywxHxvgzyRWotHthI1Mdiul+c+sUQNjRW4E8
zA0+Zfk5xDemf8852Ja1zLLoEOd99qrVKuH50+zL/h5s4mli/bsu3YBFJl0IChpg
mqGQs8sFE7gMB3VOrFg1liTHMcF1M02+nw4Mvbauxzv7u2kSYM0HVOi7pLDnH9f2
CxjAahKe38wH5RANNNdSBgdFnmJnoElJ0zkldRl6cXvfNUVDHmJpD3pxzxdxwON3
DNfe+gpf38bbpsch9CTBBVtTDw/qEiD9lu7cXUyqfu5efu/od696FNdtTdnwcjZQ
IBnMhU1Pi7TCM8Fl3QSTyNc0vTPK0S6khX3BkV0Es9EZ9jy2bctNlPahdv8ClV4L
ZYSJtFOK7XRQsW3YnFu2RpB0p+Um8E/XBU9XuP3aFzuVOR4erK6bbUkNECd2OG45
1s5k+0wVs9s=
=bDPv
-----END PGP SIGNATURE-----

--Sig_/m1n3j461fKS.1qeiWylaALd--
