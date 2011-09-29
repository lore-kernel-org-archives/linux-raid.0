From: NeilBrown <neilb@suse.de>
Subject: Re: error injection
Date: Thu, 29 Sep 2011 12:12:26 +1000
Message-ID: <20110929121226.72d2a0e1@notabene.brown>
References: <CAJD3hpWbkSGeiWDgYHP3ewnw7akoEY-ydoRJKLxwcp8+up5zKw@mail.gmail.com>
	<20110929091128.1488f267@notabene.brown>
	<CAJD3hpUNkLDRGQxNuo6m7=OQjBu3uc5xV7Fzy-XLvrUFHQJbiw@mail.gmail.com>
	<20110929110836.1dc9944d@notabene.brown>
	<CAJD3hpU5YE5S93tDV1iK3_YReESh5NDnX877YMWc4JMMQkaN0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BcsNVUd+dpG6M/L3DkhTyoX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJD3hpU5YE5S93tDV1iK3_YReESh5NDnX877YMWc4JMMQkaN0A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jojy Varghese <jojy.varghese@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/BcsNVUd+dpG6M/L3DkhTyoX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Sep 2011 19:06:17 -0700 Jojy Varghese <jojy.varghese@gmail.com>
wrote:

> Thanks Neil. Also, is there any way to find the current fault blocks bein=
g set?
>=20

No.  All you can get is what is shown in "/proc/mdstat".

It wouldn't be too hard to add something to /proc/mdstat or /sys/.... to sh=
ow
that information.

NeilBrown


--Sig_/BcsNVUd+dpG6M/L3DkhTyoX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOg9QKG5fc6gV+Wb0RAsAGAKDHpnlM+cdCLfAKgj9kCtvGQqhWJACdHtET
AuGVx1ZkzZry3Df/l6jleyQ=
=qrR+
-----END PGP SIGNATURE-----

--Sig_/BcsNVUd+dpG6M/L3DkhTyoX--
