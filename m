From: NeilBrown <neilb@suse.de>
Subject: [PULL REQUEST] md updates for 3.10
Date: Thu, 4 Jul 2013 16:58:45 +1000
Message-ID: <20130704165845.3f58171d@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/jRxdVMw02St99Ty+MAn6GPV"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Martin Wilck <mwilck@arcor.de>, Jonathan Brassow <jbrassow@redhat.com>, Jingoo Han <jg1.han@samsung.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-raid.ids

--Sig_/jRxdVMw02St99Ty+MAn6GPV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Mostly just bug fixes.
A couple marked for -stable including one recent bug which causes a RAID10
reshape to complete without moving any data :-(

A couple more bugfixes (at least) to come, but haven't confirmed the right
solution yet.

NeilBrown


The following changes since commit 25e33ed9c711c8d64c403a17d4a2cdeac213800b:

  Merge tag 'acpi-3.10-rc6' of git://git.kernel.org/pub/scm/linux/kernel/gi=
t/rafael/linux-pm (2013-06-13 13:09:50 -0700)

are available in the git repository at:


  git://neil.brown.name/md/ tags/md-3.11

for you to fetch changes up to 1376512065b23f39d5f9a160948f313397dde972:

  md/raid10: fix bug which causes all RAID10 reshapes to move no data. (201=
3-07-04 16:42:57 +1000)

----------------------------------------------------------------
md updates for 3.11

Mostly fixes with a few minor features (e.g. "last_sync_action" sysfs file).

----------------------------------------------------------------
CoolCold (1):
      md: remove doubled description for sync_max, merging it within sync_m=
in/sync_max

Hannes Reinecke (1):
      md: Wait for md_check_recovery before attempting device removal.

Jingoo Han (1):
      md: replace strict_strto*() with kstrto*()

Jonathan Brassow (4):
      DM RAID: Add ability to restore transiently failed devices on resume
      DM RAID: Break-up untidy function
      DM RAID: Fix raid_resume not reviving failed devices in all cases
      MD: Remember the last sync operation that was performed

NeilBrown (7):
      dm-raid: silence compiler warning on rebuilds_per_group.
      md/raid10: locking changes for 'enough()'.
      md/raid10: check In_sync flag in 'enough()'.
      md: fix buglet in RAID5 -> RAID0 conversion.
      md/raid10: fix two bugs affecting RAID10 reshape.
      md/raid5: allow 5-device RAID6 to be reshaped to 4-device.
      md/raid10: fix bug which causes all RAID10 reshapes to move no data.

 Documentation/device-mapper/dm-raid.txt |  2 +
 Documentation/md.txt                    | 13 +++---
 drivers/md/bitmap.c                     |  8 ++--
 drivers/md/dm-raid.c                    | 76 +++++++++++++++++++++++++++---
 drivers/md/md.c                         | 53 ++++++++++++++-------
 drivers/md/md.h                         |  8 ++++
 drivers/md/raid0.c                      |  1 +
 drivers/md/raid1.c                      |  7 +--
 drivers/md/raid10.c                     | 83 +++++++++++++++++++++--------=
----
 drivers/md/raid5.c                      |  6 +--
 10 files changed, 187 insertions(+), 70 deletions(-)

--Sig_/jRxdVMw02St99Ty+MAn6GPV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUdUdJTnsnt1WYoG5AQJXiRAApRwUMWhMVBdiarvpIiMArEDFT847nnIO
uigRgBDPbUmxpcXIbAhiU4oIss/4nO7krue7RoRaF45pHijWbHtvNkMhrHfsvDtq
5y5mjlDFCddwLfF11+BUottCor4vM6JNRmMWYv7LX1jXWRjuXm6fxgS1Wfoqo65N
HMBrb6KUGD/XUjpamJnrsse8Bw8h+VcKWdMO7ChxndMjb88qe38wg2YgIQt8kgKb
FA64Y7CZ+Jg6f7HfM7XklmsYD+oPKU4UO/XwBemeUde8mwVLa4LB2midDE64zxEi
TSBakwWg9C4hkpLZc/0QEWgvFm6QNrUI6QMtKXXrK/Ah7y0BwibxbcW2j6X6HmEx
kwrmvQK5ZERQfiEGAt9GaqAYGGHGskLdUSlMp8EG4jXuAHhIocHtBPa8wIDkSVuw
1H4j1YC5irryLN0DYVxjAV/Fs6aB64EEoRxMP7039UBormh6N/YsM7vBFQaCz1uS
DUWmCyHoJyovI3rY1sm0OaSTtiqwyUumaBkKfaTdUEo40hYu8s/Bz0BNrfxJvh5B
ubNxi76JbIcMcmaSVNM/7qV7wOWowhFroyMfcfhx/Gnp6/49qA84ki6afRl6WmTa
JZWT6ZLHaYUGNeaQCa0kNDnAeo7R+8cCsERMLB/QefiBRJ7WXRQMGDwF9FqUYeAK
UIn8ptFZ0jI=
=uBFc
-----END PGP SIGNATURE-----

--Sig_/jRxdVMw02St99Ty+MAn6GPV--
