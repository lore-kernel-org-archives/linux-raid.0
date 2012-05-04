From: NeilBrown <neilb@suse.de>
Subject: [PULL REQUEST] one bugfix for md in 3.4.
Date: Fri, 4 May 2012 17:13:24 +1000
Message-ID: <20120504171324.110117df@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/TXzsv2S0KIP6jYsKCfOol7F"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>, Karl Newman <siliconfiend@gmail.com>
List-Id: linux-raid.ids

--Sig_/TXzsv2S0KIP6jYsKCfOol7F
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Thanks,
NeilBrown


The following changes since commit 69964ea4c7b68c9399f7977aa5b9aa6539a6a98a:

  Linux 3.4-rc5 (2012-04-29 15:19:10 -0700)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md-3.4-fixes

for you to fetch changes up to b16b1b6cd052acbacc0a15f934bca9b354534d48:

  md/bitmap: fix calculation of 'chunks' - missing shift. (2012-05-04 17:03=
:18 +1000)

----------------------------------------------------------------
One small fix for md/bitmaps

This fixes a regression that was introduced in the merge window.

----------------------------------------------------------------
NeilBrown (1):
      md/bitmap: fix calculation of 'chunks' - missing shift.

 drivers/md/bitmap.c |    3 +--
 drivers/md/bitmap.h |    3 ---
 2 files changed, 1 insertion(+), 5 deletions(-)

--Sig_/TXzsv2S0KIP6jYsKCfOol7F
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6OBlDnsnt1WYoG5AQK12A//dEOWMxgp8lv1B7mRhjTXl8O4YN3Qx6Km
su78y+HRXCN8c5CtFRJZnNtqCdqs6H1lBKTUcmlc6Er7PlDT/K10nZPCh1/50Udd
zq7/cV3h1eX3Cmw5b4ytpwWzPzWjw0+iaekkYnOjbZ0Y8gggn8xOcQtbpIVLGgS0
jZ3i2/IggqqPTYEnDYIwUwTqBDws91GWfDUUYBLEJTf1EA1dsbOZe5Kgeb2CoRWT
3Vm+BcmDg/V1f6e38lYvrV5jZY/r5GMSuYDUBIYcdg549NgD9G4wfZn3xzfBfEG2
ZMkprS+C5CWy6IEHutwLSQklYxP/wdSOhMawHzny9wlLoNX9eZ1RiTwvbIBdC32C
YfzknGDkE/GmZ8S/A5qXRaAbHq35CK1ZGi1ArTA33XW/bzZUj0rob4Cs+z1XoBir
zmi0vfJc0yec+mpUVoXlia48HuI+dCq8ISXdwenpIoK3lSdr3X+q2Z3xGltwl91W
ubMv2qQwlBROQcte2rQC4aSbmj/E/EoK/LyR+PhiVGcVJpiGhz7aLU/24HR0JfyV
4NFTo2ho0lqRPO0onnnM8oRm6u/pyCrh5xdnWcFI76hnMUuv9z9tfKljrHLRuGDf
ovDjbIIwtX1kHK1YSVvMeeMuol3Yvox+/s8c8Ua8xele0Z5xpkN5KtacEmpMPk8Z
F4qxaqK4UzQ=
=Gg/E
-----END PGP SIGNATURE-----

--Sig_/TXzsv2S0KIP6jYsKCfOol7F--
