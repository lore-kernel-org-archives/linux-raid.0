From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC]raid5: add an option to avoid copy data from bio to stripe
 cache
Date: Thu, 29 May 2014 17:01:20 +1000
Message-ID: <20140529170120.63ef0bdc@notabene.brown>
References: <20140428065841.GA28726@kernel.org>
	<20140428101748.GA17026@infradead.org>
	<20140428204407.226c88e4@notabene.brown>
	<20140429020124.GA24123@kernel.org>
	<20140429170725.0b4687a8@notabene.brown>
	<20140429111358.GA10584@kernel.org>
	<20140521170112.16ae2d11@notabene.brown>
	<20140521095744.GA5158@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/vxmMpx7tUAFTkpV_yeMFkKK"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140521095744.GA5158@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/vxmMpx7tUAFTkpV_yeMFkKK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 21 May 2014 17:57:44 +0800 Shaohua Li <shli@kernel.org> wrote:


> > I've removed this patch for now.  It causes a nasty crash when running =
the
> > 07changelevels test in the mdadm test suite.
> > I've haven't looked at why this might be.
>=20
> Forgot to reset orig_page in resize_stripes(), fixed now.

Thanks.  This new version appears to pass my tests so it should appear in
-next soon.

thanks,
NeilBrown


--Sig_/vxmMpx7tUAFTkpV_yeMFkKK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU4bbQDnsnt1WYoG5AQL/3A/+OFsGfaG2q7cx/hq+cFKHLV1F/mg5hsMp
yQq7qKB9r1yWBxArUEfqZaSXNNVrHSzjG+zddgPGkpKwsTwzvepjff2cnuAcJv8S
AA49Bg2IkGVmcVeMfvy7aH8OveGMRqqdx8n0kLQ6WPAyOLu42sHmYLUn0ZUYRaIr
t1tqZbhY03AoSXtI5InA4lEPfjR3+vD+HYEVPRUdG4CcoS1JFdtzdc7GMAQVgyQL
CcFJ+jfRE+PEvnnzGAf1gOCTEo2bH9atbKGoQ2W44zzAeCztXKnxOQLO+BRwlI5v
HiqYgvPJzGSUQnsP6yUueWBNn66D6ZyD/ePNYsRaixuvcn2RC+nwCQ2XTBN9J0Go
xVhgqYzCcs3tOSl6OLj5XfQbnS2OJhv9CULmVmq90LoEyTM/1g/XuDNsO2eIG/QV
QarCTlpjSR3doQoweQT4nD8z2qrkBSk8h9SFHZvHn++em6oxBfhaAUYGgMXzt8OO
kgKDovxYWZ1Wx4N9zHFN+KEpUUnnjMBCKshXgKtBn1YS02MBkaKA4+Dn81MAmlbp
2xXiYFh2A10OzhKRUdQ+efT9+3QzOssitL1MNY7oy+U6pbFwR7UAUNEPHvCUn75y
el2T064yYA6BffNHl/QFpw/polCKtKG12jftMgR2+Go/2KdqUcofya/+NUgzuXKQ
qbWfwAEgzXY=
=vhaF
-----END PGP SIGNATURE-----

--Sig_/vxmMpx7tUAFTkpV_yeMFkKK--
