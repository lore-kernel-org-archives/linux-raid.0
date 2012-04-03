From: NeilBrown <neilb@suse.de>
Subject: [PULL REQUEST] md bugfixes  for 3.4-rc
Date: Tue, 3 Apr 2012 15:45:49 +1000
Message-ID: <20120403154549.5b4b0bef@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/8=JecXJQ6i0VHoVNzTMpBQq"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/8=JecXJQ6i0VHoVNzTMpBQq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Linus,
 a few md updates.

Thanks,
NeilBrown


The following changes since commit dd775ae2549217d3ae09363e3edb305d0fa19928:

  Linux 3.4-rc1 (2012-03-31 16:24:09 -0700)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md-3.4-fixes

for you to fetch changes up to 5020ad7d143ccfcf8149974096220d59e5572120:

  md/raid1,raid10: don't compare excess byte during consistency check. (201=
2-04-03 15:39:23 +1000)

----------------------------------------------------------------
md: Assort fixes for 3.4-rc

- some RAID levels didn't clear up properly if md_integrity_register
  failed
- a 'check' of RAID5/RAID6 doesn't actually read any data
  since a recent patch - so fix that (and mark for -stable)
- a couple of other minor bugs.

----------------------------------------------------------------
Jes Sorensen (1):
      md: Avoid OOPS when reshaping raid1 to raid0

NeilBrown (2):
      md/raid5: fix handling of bad blocks during recovery.
      md/raid1,raid10: don't compare excess byte during consistency check.

majianpeng (5):
      md/linear: If md_integrity_register() fails, linear_run() must free t=
he mem.
      md/raid0: If md_integrity_register() fails, raid0_run() must free the=
 mem.
      md/raid1: If md_integrity_register() failed,run() must free the mem
      md/raid1:Remove unnecessary rcu_dereference(conf->mirrors[i].rdev).
      md/raid5: Fix a bug about judging if the operation is syncing or repl=
acing

 drivers/md/linear.c |    9 +++++++-
 drivers/md/raid0.c  |   27 +++++++++++++++++++++--
 drivers/md/raid1.c  |   13 ++++++++----
 drivers/md/raid10.c |    2 +-
 drivers/md/raid5.c  |   59 ++++++++++++++++++++++++++++-------------------=
----
 5 files changed, 75 insertions(+), 35 deletions(-)

--Sig_/8=JecXJQ6i0VHoVNzTMpBQq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3qOjTnsnt1WYoG5AQLqGw//ZIsolwVOWQ2VFUVWaaztW3zEhxCVbWbD
4SxXxjnLmcFlmDq4xk5+qFshxnGPuWixAL79s6ZM/znayccyqDGvz4HE96J9Q1LX
yKUPknJrVTZZGtDdYSElEX/PftLVPd4SgWofAE/7IERVbzw0Sf/ywfjBmJzll81o
BC8KCqRk7EOtvoKaNyX58gKX01P2wgPf9gidcA8TP5fHTdDd+A2n+jHmsMOS7to2
chn1jwgt8BtZwmvPyQJr7aDLC/B5TaaqKy92yDgXUslQfDIekW+BE18EWgzO8ZZW
lqugyvY/4H2pqwx4jCg0VV+D1R5SDTp+1aQkcKL8DpZouDln7CGCv7/f/K1aP1yt
ItFhU/QKfxtYEUoKfeuaA+nLy+qtYwE03b+30CkDniM4qCixPOpB0qBV2yLdfq22
2xzgzEgjb9CEE1whd/lViM/LSlOIUxPZfqmerObMajM79hIPhVi8z6H+CP1bjFlO
xYN0uqXQXbuPqIJsaG/43vyd0xyu39C6Ge8MMfRLDxR9b62vOd4BVkYrTGvE5uVn
hkhBNHhElXZPEeOE+wMn56b1KKTDqz/JkTKamwSqb/mlsW7Iw2RkGZ+K5+aQ1fHl
bXQZtr9vGcbCc4KoU/pdWdVd9Ke+4BdRC2+v+hQnkNa9l352MWv5KfP4ZOr78qL/
IcGGZdmsW8o=
=LC6D
-----END PGP SIGNATURE-----

--Sig_/8=JecXJQ6i0VHoVNzTMpBQq--
