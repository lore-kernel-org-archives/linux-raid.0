From: NeilBrown <neilb@suse.de>
Subject: Problem with DISCARD and RAID5
Date: Thu, 1 Nov 2012 17:38:54 +1100
Message-ID: <20121101173854.62061307@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/j6eYuHkAH2w63CaJKxOfIEX"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux RAID <linux-raid@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/j6eYuHkAH2w63CaJKxOfIEX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Shaohua,
 I've been doing some testing and discovered a problem with your discard
 support for RAID5.

 The code in blkdev_issue_discard assumes that the 'granularity' is a power
 of 2, and for example subtracts 1 to get a mask.

 However RAID5 sets the granularity to be the stripe size which often is not
 a power of two.  When this happens you can easily get into an infinite loo=
p.

 I suspect that to make this work properly, blkdev_issue_discard will need =
to
 be changed to allow 'granularity' to be an arbitrary value.
 When it is a power of two, the current masking can be used.
 When it is anything else, it will need to use sector_div().

 Could you look into this please?

Thanks,
NeilBrown

--Sig_/j6eYuHkAH2w63CaJKxOfIEX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUJIY/jnsnt1WYoG5AQK7mQ/+KFhc+tpDbo4B4OKz+LkG4tM0tVXBfA6+
s2i0lAWDYpPP4NnzhTYkDzuI6GkudVQshKRfZflsFYkyjl5ozoqqO53/RFDNmsNh
lklKSyXy+hkMBKNUJv2pV66wUtv8xD3Q2RBrUAQpvyU2zLcE+pFxHZIRMi4C1SF7
gzxq4Jt572xGn4djbflWqPXxkyO2zNh+AOIsNVvWSYJ9mN+VDotzAP8ldgTaix5q
sMh7Av191x2X6MtAf5AVrJKI9DLXILbMK95rEAuUNJR6O8PMpiqdF2MLz4hoLSSf
5+LSsXVaWNA+lzIo/AciNy6JVpg2J/cRmdnig6WM9unFS+V1hNvoNzhyj/axm0ZC
4Wy3Rf3oQwYrjl+IJgaoLbI2gtDqQg1NvN+bG9PG2WHM4v+8LZqPScCyuruvK1K9
vldzRKuz9jVIdsiPjNh8qSZYh4dUtJQjaAIZYi7LCJ9rpkoMYJrgAJj5/lnySlbc
Q3DGUKu+CI3AOF4JS4t9K9LzvoTy7pYF00sjeG4KUKEgfRk1HcxF8rh37Df+k828
WkdneY+tzcJ2w9lMhuw8MpVijpC1Dl2Ipngq1ApbqlVapzwXFefhrz/nHMxsfSft
/4u31mk+Jl0yXABvX+qj1hBMOb+OItkT8mskGZuYt3IYFxblDKUpAqr1u959F3Zs
WjovdL93D+c=
=WpqW
-----END PGP SIGNATURE-----

--Sig_/j6eYuHkAH2w63CaJKxOfIEX--
