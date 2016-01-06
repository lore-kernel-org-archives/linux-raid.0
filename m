From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/4] raid5-cache: handle flush request for journal hotadd
Date: Wed, 06 Jan 2016 12:12:05 +1100
Message-ID: <87d1tfy0ii.fsf@notabene.neil.brown.name>
References: <cover.1452028077.git.shli@fb.com> <7b8a15be93941a393a5a08232659fef9ead4610b.1452028077.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7b8a15be93941a393a5a08232659fef9ead4610b.1452028077.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, Jan 06 2016, Shaohua Li wrote:

> When we hotadd journal for array which isn't created with journal, the
> array might be running write requests. Such writes aren't protected by
> journal yet, so we can't skip disk flush. There is no easy way to know
> when all such writes are finished, but the time should be enough after
> reclaim runs once.

There is an easy way to know when such writes are finished.
Call mddev_suspend(mddev).  This is used for the more intrusive
reconfiguration such as initiating a reshape.
I think it would be perfectly appropriate to
  call mddev_suspend()
  attach the journal
  call mddev_resume()

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWjGnlAAoJEDnsnt1WYoG5oC8P/1lxVsysOUQCqkLcSNrl7pW4
EGi36kb4wjfHEm/2sFXQaCGMyGIabdsjGQDz8MrQ8ZTqui4UxySp5f1gKJL+oD56
YTY4rbTfUSrBRxwonkFqBxRB0gSAw5q8lAM294gBUfDYpZr1u+17egTsQbadafip
oPClqIthbkdEorR5ugP+84k5j1tRkDEbfaKPVwIR7QNfNjP7Yi5S/V8+s6+ChlTZ
+kyNpM8Amfcwgi4XuTa8nC9LYFOPB0uC1VsCssk6jqjLivNm608jYCmYORD6L9kD
4rQRndQW9lvdSkvDvNZxrmv2XXDzAhepjA9Dlze8WLos51dEjsA+RQfUnF0X2LkJ
xASRpP5M+2PFmTXxorNTgNVTbhJmWfSLFrk2PCdHu7DFdi6t3bBx6RjcD5dc9+Kk
JdKIQN0I03hyP3Neikm22vfuEpQYcLr5k9vVh1NRr4qoQGbYgv+EyRyGXxBTlwjh
kjsVzmCldpw6pLrE5Be8Jb8z1sfBeTxEcOuvoFtvm0AccPnlsnEzJIlgXlIHx1R9
wF9oGtxuUTtgrPnEbdQPLctnOD73tgOsA6cn4rllqC9U+of2dE+enIo04OaS4yTO
WWetIN3iJevFdmBVyBlXA4KBWBH6Iex/t6Q81v/x6u1mRYxvcOA4K0SusjQI51c3
knR5WSRVeJhA0B1agBRt
=Flf3
-----END PGP SIGNATURE-----
--=-=-=--
