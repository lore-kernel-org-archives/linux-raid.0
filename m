From: NeilBrown <neilb@suse.com>
Subject: [GIT PULL REQUEST] md updates for 4.5
Date: Fri, 15 Jan 2016 17:30:04 +1100
Message-ID: <87fuxz5p8z.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Deepa Dinamani <deepa.kernel@gmail.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Guoqing Jiang <gqjiang@suse.com>, Mike Snitzer <snitzer@redhat.com>, Roman Gushchin <klamm@yandex-team.ru>, Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain


The following changes since commit 168309855a7d1e16db751e9c647119fe2d2dc878:

  Linux 4.4-rc8 (2016-01-03 15:15:37 -0800)

are available in the git repository at:

  git://neil.brown.name/md tags/md/4.5

for you to fetch changes up to 1501efadc524a0c99494b576923091589a52d2a4:

  md/raid: only permit hot-add of compatible integrity profiles (2016-01-14 11:49:57 +1100)

----------------------------------------------------------------
md updates for 4.5

Mostly clustered-raid1 and raid5 journal updates.
one Y2038 fix and other minor stuff.

One patch removes me from the MAINTAINERS file and adds a record of
my md maintainership to Credits.

----------------------------------------------------------------
Arnd Bergmann (1):
      md: avoid warning for 32-bit sector_t

Christoph Hellwig (5):
      raid5-cache: simplify r5l_move_io_unit_list
      raid5-cache: free meta_page earlier
      raid5-cache: use a bio_set
      raid5-cache: use a mempool for the metadata block
      raid5: allow r5l_io_unit allocations to fail

Dan Williams (1):
      md/raid: only permit hot-add of compatible integrity profiles

Deepa Dinamani (1):
      drivers: md: use ktime_get_real_seconds()

Goldwyn Rodrigues (3):
      md-cluster: Avoid the resync ping-pong
      md-cluster: Fix the remove sequence with the new MD reload code
      md-cluster: Allow spare devices to be marked as faulty

Guoqing Jiang (8):
      md-cluster: remove a disk asynchronously from cluster environment
      md-cluster: append some actions when change bitmap from clustered to none
      md-cluster: update the documentation
      md-cluster: Defer MD reloading to mddev->thread
      md-cluster: Protect communication with mutexes
      md-cluster: update comments for MD_CLUSTER_SEND_LOCKED_ALREADY
      md: update comment for md_allow_write
      md: remove unnecesary md_new_event_inintr

NeilBrown (2):
      md: Remove 'ready' field from mddev.
      Remove myself as MD Maintainer, and add to Credits.

Roman Gushchin (1):
      md/raid5: remove redundant check in stripe_add_to_batch_list()

Shaohua Li (4):
      raid5-cache: add journal hot add/remove support
      md: set MD_HAS_JOURNAL in correct places
      MD: add journal with array suspended
      raid5-cache: handle journal hotadd in quiesce

 CREDITS                        |   1 +
 Documentation/md-cluster.txt   | 314 ++++++++++++++++++++++++++++++-----------
 MAINTAINERS                    |   1 -
 drivers/md/md-cluster.c        | 164 +++++++++++++++++++--
 drivers/md/md-cluster.h        |   2 +
 drivers/md/md.c                | 171 +++++++++++++---------
 drivers/md/md.h                |  11 +-
 drivers/md/multipath.c         |   6 +-
 drivers/md/raid1.c             |   6 +-
 drivers/md/raid10.c            |   6 +-
 drivers/md/raid5-cache.c       | 158 ++++++++++++++++-----
 drivers/md/raid5.c             |  36 +++--
 include/uapi/linux/raid/md_u.h |   4 +-
 13 files changed, 649 insertions(+), 231 deletions(-)

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWmJHsAAoJEDnsnt1WYoG5bowP/iS+GiTjsNIRPtey2Rg3wfD3
sQVSe0P3eIUxJ4vxpLa2bxyWj+QMsso27egMI4xHXjjIScZk9q79u1y1PFa2VsGN
5/aC1dnX6jFhmVEQW1ooQ5JoHOXZbE38dqwINdN+DYnzg0yA0yIPViWEmCKgD/nB
isy8/FkKLNVqcpTkPZIK3nswFOjF5paFA/54sl2qirJcU4Ea8pJtQsJ0szydVF31
+jVwbzm1at2hJgcb6d5xAt3DYWGqqbnPZP9RaJWm2W7Oa4e+BFv/s1OiyJ/Venao
jd/WLWQpkI9Tq+28qbFHQ4HoGkuLYwOYBO/WMKLD3vVgjrYLBJK3ZlxzOJguDR1I
cblmRQNEGgYDorOBm30Z5KFxFDtDScrXFJwONSgprH5TAlr0tejwdUanEf6RbR3S
dUZvyMn9Uekcso0cafIq74GHOO3eQqJHfjzCy3XAwxG9rrJ1MReymzVzmyACh/a1
VjPV8YaKNBcphFwmZTgpXUABShvsGQVG2beCX7u2J5qFMCMCCVIkUWC4ZcYXY0ed
+wZDk5yIUnGF5x4xclpAK/OKJqTM2inltEhoQlwQxPy4fnzchP3Cfsle2gjzOEiT
H5EFtM4QtT2lt6s7JzaA7sJyDSQvbuG+jMxI88afA3T8HETXBIkEdc+La8CY52sS
7KfbOUxLc8BYviaJKVlx
=kxAM
-----END PGP SIGNATURE-----
--=-=-=--
