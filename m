From: Neil Brown <neilb@suse.com>
Subject: [GIT PULL REQUEST] last minute bug fixes for md.
Date: Sat, 31 Oct 2015 12:26:14 +1100
Message-ID: <87pozvvnex.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nate Dailey <nate.dailey@stratus.com>, Roman Gushchin <klamm@yandex-team.ru>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain


they just keep coming in :-(

The following changes since commit 8bce6d35b308d73cdb2ee273c95d711a55be688c:

  md/raid10: fix the 'new' raid10 layout to work correctly. (2015-10-24 16:24:25 +1100)

are available in the git repository at:

  git://neil.brown.name/md tags/md/4.3-rc7-fixes

for you to fetch changes up to d01552a76d71f9879af448e9142389ee9be6e95b:

  Revert "md: allow a partially recovered device to be hot-added to an array." (2015-10-31 11:00:56 +1100)

----------------------------------------------------------------
two more bug fixes for md.

One bugfix for a list corruption in raid5 because of incorrect
locking.

Other for possible data corruption when a recovering device is failed,
removed, and re-added.

Both tagged for -stable.

----------------------------------------------------------------
NeilBrown (1):
      Revert "md: allow a partially recovered device to be hot-added to an array."

Roman Gushchin (1):
      md/raid5: fix locking in handle_stripe_clean_event()

 drivers/md/md.c    | 3 +--
 drivers/md/raid5.c | 6 ++++--
 2 files changed, 5 insertions(+), 4 deletions(-)

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWNBi2AAoJEDnsnt1WYoG5ANsP/2VsTNW6zlYl8i0TxSzeRxAC
FxVCZP4vwUK1emg+rFQ/AODPFVs45j3XrmICHGgffm7F7m2R/cBpWSooy/L7g9c8
7HsOePcvdFtT31oemYAU1uEO53zj4MGombMuFueGCA3DtoMUstjj0LzEQD0y1FUn
ml9uUJo+vF6/NnPfYULHCjddIIvfJ6hGCc5LY1jrSNnn7QQXBbLjReZrw5TVSRWo
qJsqfYyuGtQ1d+M8LC5bYdA6UtbDI2R5XuWaESPZzlXnDTl3Zbl/xGEgIpFD1pWr
xi8cG9wA3iBBkwkcjQsMDjyx0fgBskub0jpfaemS6W/+dhVLaDFV5DDAS5p1MkEC
cGW/muE0WQnJdB93Bl1BXxx5q3W+03Cv53mpnL1ebHYMMthFVKKgQTM5BbZExhBQ
ksEXgTVSZF4Y6DYgSMrG7aQdj5JERk6463vWxyTBUM7liUthDg41Sk40eJU6sw5e
wV52sVIgPUqIJuprQp5dm0yOjPYZB9N+Mgem9mY4vBNudObwQ1FkWmBUDRGevmHC
5rvTYzMeNM3ARSLtMX609Ip64ZrlZO3/7saKY0O1YdTbelA0YIZS4fRo2U0EJUqD
TuMrVLKwXzp+XbcZZioepkY2dCduFtBsIBPWOdcP8A3GkGHih2ao5cAau+lVqM+8
jlSQ1MFqAjOT94w0kINk
=cnar
-----END PGP SIGNATURE-----
--=-=-=--
