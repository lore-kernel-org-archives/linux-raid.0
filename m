From: NeilBrown <neilb@suse.de>
Subject: [PULL REQUEST]  one more md patch for 3.4
Date: Sat, 19 May 2012 09:06:50 +1000
Message-ID: <20120519090650.74b80e93@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/s7C_EGRprXcgnZq5Hp6XPnF"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>, Hannes Reinecke <hare@suse.de>
List-Id: linux-raid.ids

--Sig_/s7C_EGRprXcgnZq5Hp6XPnF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable



That last fix for raid10 contained a nasty typo.  I've double-checked
and I'm pretty sure there aren't any more :-(
(With thanks to Hannes Reinecke for all his testing!)

Thanks,
NeilBrown



The following changes since commit 0d9f4f135eb6dea06bdcb7065b1e4ff78274a5e9:

  MD: Add del_timer_sync to mddev_suspend (fix nasty panic) (2012-05-17 10:=
38:24 +1000)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md-3.4-fixes

for you to fetch changes up to b0d634d5683f0b186b242ce6a4f3b041edb8b956:

  md/raid10: fix transcription error in calc_sectors conversion. (2012-05-1=
9 09:01:13 +1000)

----------------------------------------------------------------
Fix bug in recent fix to RAID10.

Without this patch, recovery will crash

----------------------------------------------------------------
NeilBrown (1):
      md/raid10: fix transcription error in calc_sectors conversion.

 drivers/md/raid10.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--Sig_/s7C_EGRprXcgnZq5Hp6XPnF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7bWCjnsnt1WYoG5AQJ9gw/8CVHZH2cOzc7VaAZsQz3OqH6JWAcHGO/p
68F5+VQYxhWGDXsglt60Evg9KkHrI3BAzM4/e1EpAlzK2/UiLn1iO/JcYqQPJ+To
q8+ecRAatFYdwE7ak8pDULzd3Zhjc6eAgU5tZtBIHJ37Cm97TFaRuTkJJ/ezfXyf
xzyCJ60HboEdU4zoaGyv9SGLO2+Fatm6AER5XUqw5j6wLP0PEMhyHD7/ORNwqsBd
ceua5xugF1zQirbbibyhxfB8PK7Ev644N9Fm30B5K5j+3etNRYNRU3N+nCvR8z37
O3Vs9ijIo8FRnPGpLjRNSTsBGCaktMWKdigIiX8ujHxpka2Gvd8o0oP021XyMCk5
8Ig5YrNLPoQw7YAKLj/nruE3YqOgy/qS+m+FRIp3KESBE+dfvy0AtXNePLrRCb7H
YEnFFiluYP7h/9kVLaEiS+jl6MMsrN2MJGL8kkg36p3Xmr8MUiK3hYROZCaQ3yoW
9VwAYI6guZYKePb7uiag7FsIZvz6eXzAY8X7BqB/KyloT7eU/c5/5Sdpc3J24Kti
dW84dMDR30tAvBVar8EA+oLfZDZ9nHyhEqGQckep2iY2U03wo4msS0eTMwLqg8Hf
Sya5/byJh/rwi3OvixYW0h5/vHTTjp1t54yVXLIxZm5NJTkzdovAbeGGgkmsDZIt
4L9R4WlBmaI=
=xCtZ
-----END PGP SIGNATURE-----

--Sig_/s7C_EGRprXcgnZq5Hp6XPnF--
