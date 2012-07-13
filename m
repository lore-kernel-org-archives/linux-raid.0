From: NeilBrown <neilb@suse.de>
Subject: [PULL REQUEST] one new bugfix for md/RAID1
Date: Sat, 14 Jul 2012 09:41:09 +1000
Message-ID: <20120714094109.554bce65@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/NYRywZrtPpBMOtS23/Kl0lc"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux RAID <linux-raid@vger.kernel.org>, Arnold Schulz <arnysch@gmx.net>
List-Id: linux-raid.ids

--Sig_/NYRywZrtPpBMOtS23/Kl0lc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


The following changes since commit 10684112c9d154172ac34e48a2ab68649e8f63ac:

  md/raid10: fix careless build error (2012-07-04 09:35:35 +1000)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md-3.5-fixes

for you to fetch changes up to 2d4f4f3384d4ef4f7c571448e803a1ce721113d5:

  md/raid1: fix use-after-free bug in RAID1 data-check code. (2012-07-09 11=
:34:13 +1000)

----------------------------------------------------------------
md: One use-after-free bugfix for RAID1

----------------------------------------------------------------
NeilBrown (1):
      md/raid1: fix use-after-free bug in RAID1 data-check code.

 drivers/md/raid1.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


Thanks,
NeilBrown

--Sig_/NYRywZrtPpBMOtS23/Kl0lc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUACyFTnsnt1WYoG5AQJ+Og/9FiGutwHqh9OmwPStjlpLWntFk/WcsYoV
WRmjmkf1rde0e+sVOIa7cchcL7fvKOrYJjNmYUFM5/n68PsldWh47Mn1g7ZQzYMc
WLqjfE7i3ObrGGqwpWwbK1xU2D0YFf95lB47gY9Tk8Jf36O0pxyVEnZH1fNESqXs
dEUwOe/Jq8oZ7TrOvz3+UB5bBC1o5L9UGFwqmChi0tL959Zou3SqH6Dhh0AvzBQb
u3dGlL028OvGVpR8ZaceAiCbYVIurS8un2mN7NcQ2AreIwIlJ3BNLqmOvDRfEefH
/T/RcSPe1NJ/SG1dUgk71t/RmTYdqRm7HwiIRlVJOm7RGE3pAXxNbC/t2iiW7Lzv
g2NXHQOooeiCf6cKD2oVCfvxg/KOTFFnLu9U14rNJJPs/J8YEEDF0x+9r2SdXUpi
E0ujD+CfNe/TxFgE6nw1vXDHo8C5HhoT8mxJCEUwk5M+dY262W7vWO9ku0aRfCMA
9zHDC1D3o0myEdA7CSj9csd0ZEFRRnJy1MoSdfrVwu/P7sEC2mzTN6E5vp2QfR7O
waNdcbhHwV0jA3Qc02AcqMwcyKcshGLfU4J9qi9T4qrduVAfoWwzqHcpWwWMxf/I
d1xOvHu5pVXYeTff0Jxx1fmPtInme38QXx5JgB093vjnh1h2776MoKiRp/YinLCs
RHDYbdTnmes=
=v/19
-----END PGP SIGNATURE-----

--Sig_/NYRywZrtPpBMOtS23/Kl0lc--
