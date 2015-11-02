From: Neil Brown <neil@brown.name>
Subject: [GIT PULL REQUEST] md updates for 4.4
Date: Mon, 02 Nov 2015 13:37:39 +1100
Message-ID: <87bnbdjfd8.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Guoqing Jiang <gqjiang@suse.com>, Shaohua Li <shli@fb.com>, Song Liu <songliubraving@fb.com>, kbuild test robot <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

The following changes since commit 25cb62b76430a91cc6195f902e61c2cb84ade622:

  Linux 4.3-rc5 (2015-10-11 11:09:45 -0700)

are available in the git repository at:

  git://neil.brown.name/md tags/md/4.4

for you to fetch changes up to 339421def582abb14c2217aa8c8f28bb2e299174:

  MD: when RAID journal is missing/faulty, block RESTART_ARRAY_RW (2015-11-01 13:48:29 +1100)

----------------------------------------------------------------
md updates for 4.4.

Two major components to this update.

1/ the clustered-raid1 support from SUSE is nearly
  complete.  There are a few outstanding issues being
  worked on.  Maybe half a dozen patches will bring
  this to a usable state.

2/ The first stage of journalled-raid5 support from
   Facebook makes an appearance.  With a journal
   device configured (typically NVRAM or SSD), the
   "RAID5 write hole" should be closed - a crash
   during degraded operations cannot result in data
   corruption.

   The next stage will be to use the journal as a
   write-behind cache so that latency can be reduced
   and in some cases throughput increased by
   performing more full-stripe writes.

----------------------------------------------------------------
Christoph Hellwig (12):
      raid5-cache: move functionality out of __r5l_set_io_unit_state
      raid5-cache: free I/O units earlier
      raid5-cache: rename flushed_ios to finished_ios
      raid5-cache: factor out a helper to run all stripes for an I/O unit
      raid5-cache: simplify state machine when caches flushes are not needed
      raid5-cache: clean up r5l_get_meta
      raid5-cache: refactor bio allocation
      raid5-cache: take rdev->data_offset into account early on
      raid5-cache: inline r5l_alloc_io_unit into r5l_new_meta
      raid5-cache: new helper: r5_reserve_log_entry
      raid5-cache: small log->seq cleanup
      raid5-cache: use bio chaining

Goldwyn Rodrigues (11):
      md-cluster: complete all write requests before adding suspend_info
      md: Increment version for clustered bitmaps
      md-cluster: Use a small window for resync
      md-cluster: Wake up suspended process
      md: remove_and_add_spares() to activate specific rdev
      md-cluster: Improve md_reload_sb to be less error prone
      md-cluster: Perform a lazy update
      md-cluster: Perform resync/recovery under a DLM lock
      md-cluster: Fix adding of new disk with new reload code
      md-cluster: Do not printk() every received message
      md-cluster: Call update_raid_disks() if another node --grow's raid_disks

Guoqing Jiang (9):
      md-cluster: send BITMAP_NEEDS_SYNC when node is leaving cluster
      md-cluster: make other members of cluster_msg is handled by little endian funcs
      md-cluster: remove unnecessary setting for slot
      md-cluster: make sure the node do not receive it's own msg
      md-cluster: zero cmsg before it was sent
      md-cluster: Add 'SUSE' as author for md-cluster.c
      md-cluster: only call kick_rdev_from_array after remove disk successfully
      md: check the return value for metadata_update_start
      md-cluster: Fix warnings when build with CF=-D__CHECK_ENDIAN__

NeilBrown (5):
      Merge branch 'md-next' of git://github.com/goldwynr/linux into for-next
      md-cluster: metadata_update_finish: consistently use cmsg.raid_slot as le32
      md-cluster: discard unused sb_mutex.
      md-cluster: don't cast void pointers when assigning them.
      md-cluster: remove mddev arg from add_resync_info()

Shaohua Li (24):
      md: override md superblock recovery_offset for journal device
      raid5: export some functions
      raid5: add a new state for stripe log handling
      raid5: add basic stripe log
      raid5: log reclaim support
      raid5: log recovery
      raid5-cache: use crc32c checksum
      raid5: disable batch with log enabled
      raid5: don't allow resize/reshape with cache(log) support
      raid5: enable log for raid array with cache disk
      raid5-cache: switching to state machine for log disk cache flush
      raid5-cache: fix a user-after-free bug
      raid5-cache: optimize FLUSH IO with log enabled
      md: skip resync for raid array with journal
      raid5-cache: check stripe finish out of order
      raid5-cache: don't delay stripe captured in log
      md: show journal for journal disk in disk state sysfs
      raid5-cache: move reclaim stop to quiesce
      MD: fix info output for journal disk
      raid5-cache: add trim support for log
      raid5: journal disk can't be removed
      raid5-cache: IO error handling
      raid5-cache: start raid5 readonly if journal is missing
      MD: set journal disk ->raid_disk

Song Liu (6):
      MD: replace special disk roles with macros
      MD: add a new disk role to present write journal device
      skip match_mddev_units check for special roles
      MD: add new bit to indicate raid array with journal
      MD: kick out journal disk if it's not fresh
      MD: when RAID journal is missing/faulty, block RESTART_ARRAY_RW

 drivers/md/Makefile            |    2 +-
 drivers/md/bitmap.c            |   14 +-
 drivers/md/bitmap.h            |    4 +-
 drivers/md/md-cluster.c        |  228 ++++----
 drivers/md/md-cluster.h        |   12 +-
 drivers/md/md.c                |  495 ++++++++++++-----
 drivers/md/md.h                |   17 +-
 drivers/md/raid1.c             |   41 +-
 drivers/md/raid1.h             |    7 +
 drivers/md/raid10.c            |    2 +-
 drivers/md/raid5-cache.c       | 1191 ++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid5.c             |  189 +++++--
 drivers/md/raid5.h             |   24 +
 include/uapi/linux/raid/md_p.h |   73 ++-
 14 files changed, 1989 insertions(+), 310 deletions(-)
 create mode 100644 drivers/md/raid5-cache.c

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWNsx0AAoJEDnsnt1WYoG5MNQQAIltuKMDfnELobNjBlZLaCiU
eKlRnNZJESSjet6H7y1c4l8jtGYW2v3UgAMES6AOIAYk08S0CobOW3r9WhKEwU3q
iwi6qScUkWREI/ZAcrOSsIFqR731cLzbi7CgNS1Bu4lolaF3sMEWKE+ekdVosOqi
Aizgs0oKBs3ph6UQaU93HcSecsL6C6Ays+vS0SRCvSMY4Ah3sgKa5m5NIaCL1tGb
ly8H9vsrYSbUbUalvVgfgD6Z27vtZu7vIy8Kv6+5HVx3r9r2ioD6ODU09j1T4Q/x
kriV2s/5Q23N8GIMJKP4DgQ6Ba31fratErrFoqTy0JWeoWjnXBunJGNkXVxmq9l6
tYwj2KHh3H8gF6nsea1fs0ne8RwzUXmHlOx8fsnqlLAA4QX9rwXn+X5P3gJm2jS3
XYHgDUGsHL8pOaH/AV1p3o9IE3sW6LiA6FcNN8TLRfLbYgs5Ts8p6LARPer69tBa
E3rhvjoFFqRQj9VvAe1neef+cI4eyDR40uIGMwKi/VPYUxSbRg6PoW5U86GqEm39
vdBR9cQuw5hlYevKtbyGD1YKm223+kAVDiXf3Ukz5upF+eRXy7MmEiN8nMXFImvD
5URzZKcL+B4qBgIfXSunVTpEVrqBDS6tCnfu4U0u5kBhWRPev9AtsRhwj9eqDda6
MAz3+sl/uJDMMqBBI+lK
=McAD
-----END PGP SIGNATURE-----
--=-=-=--
