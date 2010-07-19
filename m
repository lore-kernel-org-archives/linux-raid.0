From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: messed up changing chunk size
Date: Mon, 19 Jul 2010 20:58:16 +0600
Message-ID: <20100719205816.222ea76e@natsu>
References: <4C439D19.4070906@gmail.com>
	<20100719095351.4536a252@natsu>
	<4C4451FC.30505@oxfordinspire.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0oFRqMzxceXlN+5pbk5Erae"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C4451FC.30505@oxfordinspire.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Jools Wills <jools@oxfordinspire.co.uk>
Cc: Konstantin Svist <fry.kun@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/0oFRqMzxceXlN+5pbk5Erae
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 19 Jul 2010 14:24:12 +0100
Jools Wills <jools@oxfordinspire.co.uk> wrote:

> >> I looked around and found that chunk size
> >> of 512 should work better.
> >
> > Not true, at least with RAID5/6 a chunk size of 64K performs faster, see
> > http://louwrentius.blogspot.com/2010/05/raid-level-and-chunk-size-bench=
marks.html
> > http://alephnull.com/benchmarks/sata2009/chunksize.html
>=20
> There is no mention in this benchmark tests if he modified the stripe=20
> cache. With an increased stripe size a larger stripe cache would be=20
> needed for good performance (at least from my experience)

That's true, but increasing the stripe cache helps across all chunk sizes, =
even
with relatively low 128K, see [1]. And I don't think that a large-chunk(512=
K)
configuration will significantly, if at all, outperform a small-chunks(64K)
one at any given stripe cache size (set to the same value in both cases).

There's also an opinion I heard from a couple of sources, that the stripe s=
ize
better be chosen so that either one stripe, or a whole stride fits inside t=
he
CPU's L2 or L3 cache. Sounds logical, though I am not convinced that this is
what causes the performance difference between various stripe sizes.


[1]
http://peterkieser.com/2009/11/29/raid-mdraid-stripe_cache_size-vs-write-tr=
ansfer/

--=20
With respect,
Roman

--Sig_/0oFRqMzxceXlN+5pbk5Erae
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxEaAgACgkQTLKSvz+PZwiVmgCfZXowCHOVnZ6kYJzuZ/dEqZwp
HkUAnjNAIbvy19TWVSTP+qRhJRQscUCX
=zEoe
-----END PGP SIGNATURE-----

--Sig_/0oFRqMzxceXlN+5pbk5Erae--
