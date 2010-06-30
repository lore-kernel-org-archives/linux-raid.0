From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: Write-intent bitmap decreases or increase performance of RAID5?
Date: Wed, 30 Jun 2010 11:18:54 +0600
Message-ID: <20100630111854.006ec4d0@natsu>
References: <20100629201153.GA13018@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/uxjx5Lkgrq5fB/Ew8zUUmpt"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100629201153.GA13018@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Shaochun Wang <scwang@ios.ac.cn>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/uxjx5Lkgrq5fB/Ew8zUUmpt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Jun 2010 04:11:54 +0800
Shaochun Wang <scwang@ios.ac.cn> wrote:

> From what I read from the internet, write-intent bitmap decreases raid
> performance and provides more stability. But in my situation, it also
> increases raid performance dramatically!
>=20
> My RAID5 write speed without write-intent bitmap is 90MB/s, and is
> increased to 200MB/s after enabling internal write-intent bitmap. I
> use ext4 filesystem on this raid array.

How do you measure that speed exactly? The proper (and also quite simple) w=
ay
to do it is to run the following test several times (assuming that current =
dir
is some directory on the array):

  dd if=3D/dev/zero of=3Dzerofile bs=3D1M count=3D2048 conv=3Dfdatasync,not=
runc

Also, I see you run an 8-drive RAID5 on 1.5TB drives, so make sure you are
aware of the issues described in:
  http://hardware.slashdot.org/article.pl?sid=3D08/10/21/2126252
  http://louwrentius.blogspot.com/2008/08/why-raid-1-and-5-will-kill-you-so=
me-day.html

--=20
With respect,
Roman

--Sig_/uxjx5Lkgrq5fB/Ew8zUUmpt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwq074ACgkQTLKSvz+PZwg1WQCggKK+5E6T4AmOMMkXL6As1/1G
6F0An0iOsP4sI/sh+xGuXrszTIifG+OX
=otQq
-----END PGP SIGNATURE-----

--Sig_/uxjx5Lkgrq5fB/Ew8zUUmpt--
