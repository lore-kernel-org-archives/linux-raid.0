From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 00/23] md patches heading for 3.4
Date: Wed, 14 Mar 2012 15:40:39 +1100
Message-ID: <20120314043555.7978.75486.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Following are a bunch of patches that I'm planing to submit in the
next merge window (which I expect to open just after LWN publishes
this week :-).

There is nothing really exciting - mostly clean-up patches that are
the product of the development some other features that I'm still
working on (like reshaping some RAID10 arrays to more devices).

The features here are:
 - RAID10 can grow or shrink to match changes in the underlying
   devices.
 - linear, RAID0, RAID1, RAID10 now call the merge_bvec_fn in
   member devices, so that if you stack one of these atop
   LVM or RAID0 or similar, it won't insist on breaking all
   requests up into single page requests for the path through the
   multiple layers.

Review, as always, is most welcome.

NeilBrown

---

NeilBrown (20):
      md: fix clearing of the 'changed' flags for the bad blocks list.
      md/bitmap: discard CHUNK_BLOCK_SHIFT macro
      md/bitmap: remove unnecessary indirection when allocating.
      md/bitmap: remove some pointless locking.
      md/bitmap: change a 'goto' to a normal 'if' construct.
      md/bitmap: move printing of bitmap status to bitmap.c
      md/bitmap: remove some unused noise from bitmap.h
      md/raid10 - support resizing some RAID10 arrays.
      md/raid1: handle merge_bvec_fn in member devices.
      md/raid10: handle merge_bvec_fn in member devices.
      md: add proper merge_bvec handling to RAID0 and Linear.
      md: tidy up rdev_for_each usage.
      md/raid1,raid10: avoid deadlock during resync/recovery.
      md/bitmap: ensure to load bitmap when creating via sysfs.
      md: don't set md arrays to readonly on shutdown.
      md: allow re-add to failed arrays.
      md: allow last device to be forcibly removed from RAID1/RAID10.
      md/raid5: removed unused 'added_devices' variable.
      md/raid10: remove unnecessary smp_mb() from end_sync_write
      md/raid5: make sure reshape_position is cleared on error path.

majianpeng (3):
      md: Add judgement bb->unacked_exist in function md_ack_all_badblocks().
      md/raid5: use atomic_dec_return() instead of atomic_dec() and atomic_read().
      md: Use existed macros instead of numbers


 drivers/md/bitmap.c       |  152 ++++++++++++++++-----------------
 drivers/md/bitmap.h       |   22 -----
 drivers/md/dm-raid.c      |   16 ++-
 drivers/md/faulty.c       |    2 
 drivers/md/linear.c       |   32 +++----
 drivers/md/md.c           |  156 ++++++++++++++--------------------
 drivers/md/md.h           |   17 +++-
 drivers/md/multipath.c    |    8 +-
 drivers/md/raid0.c        |  164 ++++++++++++++++++++----------------
 drivers/md/raid0.h        |   11 ++
 drivers/md/raid1.c        |  111 +++++++++++++++++-------
 drivers/md/raid10.c       |  206 ++++++++++++++++++++++++++++++++-------------
 drivers/md/raid5.c        |   35 +++-----
 include/linux/raid/md_p.h |    6 +
 14 files changed, 531 insertions(+), 407 deletions(-)

-- 
Signature

