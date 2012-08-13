From: NeilBrown <neilb@suse.de>
Subject: Re: RFC: Add WWN in superblock
Date: Tue, 14 Aug 2012 09:54:59 +1000
Message-ID: <20120814095459.009ad345@notabene.brown>
References: <201208131829289067947@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/8QbqvJX1HjcME.e2kquPmcH"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201208131829289067947@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jianpeng Ma <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/8QbqvJX1HjcME.e2kquPmcH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Aug 2012 18:29:31 +0800 "Jianpeng Ma" <majianpeng@gmail.com> wro=
te:

> Hi neil:
> 	In mailist, many people ask the question about disk order.
> But because the reboot or anthor probelm, the disk-name maybe change.
> So we can't get disk-order.But if we can add WWN(Now,most harddisk has th=
is attribute),
> we can find the orders anything.
>=20
> Thanks!

What exactly do you propose doing with a WWN - how would you use it.

The metadata already contains enough information to determine the correct
disk order.

NeilBrown

--Sig_/8QbqvJX1HjcME.e2kquPmcH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUCmT0znsnt1WYoG5AQJl2g//Xs1kjT6eo992ulQ4bkO4NMGKLINC2vEb
ui/4ixVHL43hSDuk7XIEutXg3RcA11LUcNCkh18rUNSIHunm6oim6o0SICC+2VZQ
y7mUFM6EMgzd1n8ztEWk9KuaEa6/f93fBq2I6P+uc2eg5J/pWEIcam7Xo4ieFnMB
7D9eqIe6X2pRF00rBaC9Vf4nq1X9otn6egv+Kk5YgIK30bB+gUPLWvi5cRcnKnE+
GlSh3KWdlLxkQV/HrS7R062TfJVS1pDqwjLzRIuT9mjEoCJWPWEikiZpU+K86Bcp
xmGVN00775FzjmF5g7jEXrH/AVoUq1Z8SJfx/wvYWZpNqi79rx521Alvhc8HqeG6
XWa44rxD7Tp5gStR9z/wyQKO5k3IwBkoZacPV2HDRNY7dFcY55X4y2AAUa7rPr4k
1/rqnwuL+TXovBOc3/r4Qk0aHnULjmwUTWGGtsz/9vF3p2TkKa+3e/cMjpVX4+Vg
Yt6eM/Ve55iWWdxnpzvZNisHWNYQaOuapMYiq47Tjg0kIYmWSAjaJ9zJYZ1f81jy
B4DOu5eOTFFWjBSuyxcTDMmIKLZyKjgiJ+gHxrl1bmlKY3v93vVvwzXQUim1oE7n
DK30WRy5qmmFwpY2hgYrqwSA2GBh7nyFMv404izQNJyEOWRpH4TLSJ6HeomTbYkW
yaBRJQZZg/I=
=2dAJ
-----END PGP SIGNATURE-----

--Sig_/8QbqvJX1HjcME.e2kquPmcH--
