From: Neil Brown <neil@brown.name>
Subject: [GIT PULL REQUEST] md fixes for 4.3
Date: Sun, 04 Oct 2015 18:39:04 +1100
Message-ID: <8737xrhylj.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jes Sorensen <jes.sorensen@redhat.com>, Julia Lawall <julia.lawall@lip6.fr>, Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain


Hi Linus,
 a few md bug fixes.
Thanks,
NeilBrown

The following changes since commit bcee19f424a0d8c26ecf2607b73c690802658b29:

  Merge branch 'for-4.3-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup (2015-09-21 18:26:54 -0700)

are available in the git repository at:

  git://neil.brown.name/md tags/md/4.3-fixes

for you to fetch changes up to da6fb7a9e5bd6f04f7e15070f630bdf1ea502841:

  md/bitmap: don't pass -1 to bitmap_storage_alloc. (2015-10-02 17:24:13 +1000)

----------------------------------------------------------------
Assorted fixes for md in 4.3-rc

Two tagged for -stable
One is really a cleanup to match and improve kmemcache interface.

----------------------------------------------------------------
Jes Sorensen (1):
      md/raid1: Avoid raid1 resync getting stuck

Julia Lawall (1):
      md: drop null test before destroy functions

NeilBrown (4):
      md: wait for pending superblock updates before switching to read-only
      md/raid5: don't index beyond end of array in need_this_block().
      md/raid0: apply base queue limits *before* disk_stack_limits
      md/bitmap: don't pass -1 to bitmap_storage_alloc.

Shaohua Li (2):
      raid5: update analysis state for failed stripe
      md: clear CHANGE_PENDING in readonly array

 drivers/md/bitmap.c    |  3 ++-
 drivers/md/md.c        |  5 +++++
 drivers/md/multipath.c |  3 +--
 drivers/md/raid0.c     | 12 ++++++------
 drivers/md/raid1.c     | 11 ++++-------
 drivers/md/raid10.c    |  9 +++------
 drivers/md/raid5.c     | 11 +++++++----
 7 files changed, 28 insertions(+), 26 deletions(-)

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWENeYAAoJEDnsnt1WYoG5y0MP/inK/8lVlzQBgmPAuQAXrAsj
J7A0y7P6ZItbcg9az2Hc1/kee0ThHfc5D/AqPUtUnDy8XkDhrhzZD1Cj1Imr+u/a
nE5cZAH9pnKW2dzEERPzDwrsBOyQC9EJGyBmrqJZPedV4afk/aVnQq6x2IkZhe2h
9e4EqWy9OI0voRpDA2M+m5F0a7N9XwyCIltuxof+zj6JJRA1XZ1GIdEAGgXWZtoL
71M8lD0wl7uOT74c5FzZjDrJoyot9GuF57lE11TuKGVHpprPNJf0UZS8L1unEfU1
0YKVpm1foxkci7FQyEVzMyRT25XjVhX1TAjpAGdRKDtW0m6kRUF/VARpC9pkDKL+
MMEFicnwF5jR0FhVbq0N3eXDNvDNINSx1UCKkQrtTOuSfS/gedV1EeI+gER86/0j
C7deWrIXf0aeJUIC3dqXkt81VEPYUqO8ycL72kc7vTIfEbZl0eLEEHZx6Xniwzx8
75GeceqmP+QudI/6bvRUOz6e7P58IjTVgP16cKqoPBQWB2x7YEkQidNfjoqrms/P
7yT+dwqcAdTS9312et4PI8ULyTdFA3cQIND28M+VTMlThavtLCBBWIXt3t2JKIwa
BvNWhkFFbj3feFdD3/BpEewXegSZXdH8GiSmVPdTiUHQ1nSQCiF15zfSGtNbG5Gy
unjPbGro67jhLHy+mNnB
=s1DA
-----END PGP SIGNATURE-----
--=-=-=--
