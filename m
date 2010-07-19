From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: messed up changing chunk size
Date: Mon, 19 Jul 2010 09:53:51 +0600
Message-ID: <20100719095351.4536a252@natsu>
References: <4C439D19.4070906@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_emPz57YQbqzixbXDzAkxDy"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C439D19.4070906@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Konstantin Svist <fry.kun@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/_emPz57YQbqzixbXDzAkxDy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 18 Jul 2010 17:32:25 -0700
Konstantin Svist <fry.kun@gmail.com> wrote:

> I looked around and found that chunk size=20
> of 512 should work better.

Not true, at least with RAID5/6 a chunk size of 64K performs faster, see
http://louwrentius.blogspot.com/2010/05/raid-level-and-chunk-size-benchmark=
s.html
http://alephnull.com/benchmarks/sata2009/chunksize.html

--=20
With respect,
Roman

--Sig_/_emPz57YQbqzixbXDzAkxDy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxDzE8ACgkQTLKSvz+PZwhEFQCeKDDjM9nqDBs2YYcHhIMF8r5z
CQ0An1s7OsYUDCufwCSWHgz5aaFL9eU1
=C54o
-----END PGP SIGNATURE-----

--Sig_/_emPz57YQbqzixbXDzAkxDy--
