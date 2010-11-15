From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: Confusion with setting up new RAID6 with mdadm
Date: Mon, 15 Nov 2010 10:30:10 +0500
Message-ID: <20101115103010.6ccb2c07@natsu>
References: <4CE00206.4000301@geograph.co.za>
	<20101115091326.42b38b84@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/dzhXupKHPRszOn1SqzUinG."; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101115091326.42b38b84@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Zoltan Szecsei <zoltans@geograph.co.za>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/dzhXupKHPRszOn1SqzUinG.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 15 Nov 2010 09:13:26 +1100
Neil Brown <neilb@suse.de> wrote:

> Depending on which version of mdadm you are using, the default chunk size
> will be 64K or 512K.  I would recommend using 512K even if you have an ol=
der
> mdadm.  64K appears to be too small for modern hardware, particularly if =
you
> are storing large files.

According to some benchmarks I found, 64 or 128K still provide the sweet-sp=
ot
performance on RAID5 and RAID6, especially on writes.
http://louwrentius.blogspot.com/2010/05/raid-level-and-chunk-size-benchmark=
s.html
http://blog.jamponi.net/2008/07/raid56-and-10-benchmarks-on-26255_10.html#r=
aid-5-performance
http://alephnull.com/benchmarks/sata2009/chunksize.html

> I agree with what Mikael and Luca suggested - particularly the suggested =
for
> "--bitmap internal".  You really want that.

It will also help to increase the --bitmap-chunk value to reduce its
performance impact, I suggest using 131072 or more.

--=20
With respect,
Roman

--Sig_/dzhXupKHPRszOn1SqzUinG.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkzgxWIACgkQTLKSvz+PZwhf7gCfW1qnpejn2/EJCDjXHtBvXJqG
JvMAnR0tEzA3HELnKorIUxOeWE0BVwvb
=LKLb
-----END PGP SIGNATURE-----

--Sig_/dzhXupKHPRszOn1SqzUinG.--
