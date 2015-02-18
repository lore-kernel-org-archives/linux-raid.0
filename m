From: NeilBrown <neilb@suse.de>
Subject: [GIT PULL REQUEST] some more bugfixes for md.
Date: Wed, 18 Feb 2015 12:31:46 +1100
Message-ID: <20150218123146.7424b524@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/l3B/WEN6I4r90s3WkBgePl9"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux RAID <linux-raid@vger.kernel.org>, Nate Dailey <nate.dailey@stratus.com>, Jes Sorensen <Jes.Sorensen@redhat.com>, Manibalan P <pmanibalan@amiindia.co.in>
List-Id: linux-raid.ids

--Sig_/l3B/WEN6I4r90s3WkBgePl9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


hi Linus,
Please pull these three fixes, one tagged for -stable.

Thanks,
NeilBrown


The following changes since commit 53a6ab4d3f6d6dc87ec8f14998b4b5536ee2968c:

  md/raid10: fix conversion from RAID0 to RAID10 (2015-02-12 14:09:57 +1100)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md/3.20-fixes

for you to fetch changes up to 26ac107378c4742978216be1005b7291b799c7b2:

  md/raid5: Fix livelock when array is both resyncing and degraded. (2015-0=
2-18 11:35:14 +1100)

----------------------------------------------------------------
3 bug md fixes for 3.20

yet-another-livelock in raid5, and a problem with write errors
to 4K-block devices.

----------------------------------------------------------------
Nate Dailey (1):
      md/raid1: round up to bdev_logical_block_size in narrow_write_error

NeilBrown (2):
      md/raid10: round up to bdev_logical_block_size in narrow_write_error.
      md/raid5: Fix livelock when array is both resyncing and degraded.

 drivers/md/raid1.c  | 3 ++-
 drivers/md/raid10.c | 3 ++-
 drivers/md/raid5.c  | 3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

--Sig_/l3B/WEN6I4r90s3WkBgePl9
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVOPrgjnsnt1WYoG5AQK3jRAAua7sp0/zsS5PGddFW9PxFh7nyUQCfjR+
1offdgBP9sWBdBO+GJTxBTkl0s98gSzq32/vnPifn8Dpcafv4Jy21rV9og5jdZN4
+RWq15Pq2Hh6F4RtYLaktdPbnHJ8+2YJ62g5U5db9vPEVuYels7McdIeloQ6AiYF
vQLP7OS05C24anZ/ayQoZBThyUiftDfHye3P7DYa/OQG4ZsO9Pd8s2ARgXovvups
oZJpeBzTct0rDYW03JrPiN0Ap7W9yqZoCo0E5XoZbEqCmagMNc1Mv675dcJJaaCY
uOSsCDteng9IcLSHtsTK9rFQQO8Twt4qkHtD1TvgVIiX3riFKrfcOp5OdxYL6ChY
haNHLgJC7S7Kr7kogc54+nx/0m44Z9anUwdzt3B7eD6rOPxwrKCQ1IzUzqoKIRcz
QSSkfmOwLD00Zy6Z5GqBtDjSiXKIgJ1Ws2HcBU/hj/oeO77l4m1f8W/DzbqulPZx
4t7zWYDZMantpOcbr7QaQPtHLuoblBn+Rw82IINLUDy3uBjUeyV1ouZGyGYX5ehT
vr3x9H0tezActfNV3a09QUTlxI5MEZ5CdPV4BhaR2MS2b5WHzqYg0XmnLecBG5wp
SmEe2yGDlXSdKw4v2z2n7rMDYsean+GsQYKsHoQYjQxDcsFfvpAZPr33HGi5R6/z
/h+CK45A4IU=
=qHYS
-----END PGP SIGNATURE-----

--Sig_/l3B/WEN6I4r90s3WkBgePl9--
