From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: raid1 performance
Date: Sun, 25 Jul 2010 21:19:26 +0600
Message-ID: <20100725211926.7547c12e@natsu>
References: <443220.14357.qm@web28508.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hiwnSqvTzAbwR+zqwTNqD=l"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <443220.14357.qm@web28508.mail.ukl.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marco <jjletho67-diar@yahoo.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/hiwnSqvTzAbwR+zqwTNqD=l
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 25 Jul 2010 14:58:37 +0000 (GMT)
Marco <jjletho67-diar@yahoo.it> wrote:

> doing a simple performance tests i obtained some very unexpected results:=
 if
> i issue hdparm -t /dev/md2 i obtain 61 - 65 MB/s while issuing the same t=
est=20
> directly on the partitions which compose md2 (/dev/sda3 and /dev/sdb3) i
> obtain 84 - 87 MB/s. I didn't expect a so big difference between md2 and =
one
> of its member. What can cause  this difference ?=20

Maybe their read-ahead settings are different?
Check out "blockdev --getra /dev/md2", and compare that with the same
setting of the member disks. You can experiment with changing it by using
"--setra" as well.

--=20
With respect,
Roman

--Sig_/hiwnSqvTzAbwR+zqwTNqD=l
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxMVf8ACgkQTLKSvz+PZwjEBgCfXOpL88YeOPcCjQL5dW2VzoxP
UGQAn3Grq6KnsaqrK0EnZifYu6i9U0Py
=/O2a
-----END PGP SIGNATURE-----

--Sig_/hiwnSqvTzAbwR+zqwTNqD=l--
