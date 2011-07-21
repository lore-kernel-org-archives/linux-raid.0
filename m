From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 00/34] md patches for 3.1 - part 1
Date: Thu, 21 Jul 2011 12:32:24 +1000
Message-ID: <20110721022537.6728.90204.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Namhyung Kim <namhyung@gmail.com>, Akinobu Mita <akinobu.mita@gmail.com>, Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>, Jonathan Brassow <jbrassow@redhat.com>
List-Id: linux-raid.ids

As 3.0 is fast approaching it is long past time to publish my patch
queue for 3.1.  Much of it has been in -next for a while and while
that enabled testing it doesn't really encourage review.

So this is the first of 2 patch-bombs I will be sending which comprise
all of the changes is (currently) plan to submit for 3.1.

This set is mostly ad-hoc bits and pieces.  Code clean up and minor
bugs fixes and so forth.  Probably the strongest theme is some
refactoring in raid5 to reduce code duplication between RAID5 and
RAID6.  (almost) all similar code has been factored into common
routines.

All "Reviewed-by" lines gratefully accepted ... until early-ish next
week when I will submit that code to Linus.  If anyone is keen to do
some review, the RAID5 changes is where I would be most happy to have
it focused.  Remember: if something doesn't look right, it probably
isn't.

Some of these patches have been seen on the list already, but I
thought it best to simply include them all for completeness.

NeilBrown


---

Akinobu Mita (1):
      md: use proper little-endian bitops

Christian Dietrich (1):
      md/raid: use printk_ratelimited instead of printk_ratelimit

Jonathan Brassow (2):
      MD bitmap: Revert DM dirty log hooks
      MD: raid1 s/sysfs_notify_dirent/sysfs_notify_dirent_safe

Namhyung Kim (11):
      md/raid10: move rdev->corrected_errors counting
      md/raid5: move rdev->corrected_errors counting
      md/raid1: move rdev->corrected_errors counting
      md: get rid of unnecessary casts on page_address()
      md: remove ro check in md_check_recovery()
      md: introduce link/unlink_rdev() helpers
      md/raid5: get rid of duplicated call to bio_data_dir()
      md/raid5: use kmem_cache_zalloc()
      md/raid10: share pages between read and write bio's during recovery
      md/raid10: factor out common bio handling code
      md/raid10: get rid of duplicated conditional expression

NeilBrown (19):
      md/raid5: Avoid BUG caused by multiple failures.
      md/raid10: Improve decision on whether to fail a device with a read error.
      md/raid10: Make use of new recovery_disabled handling
      md: change managed of recovery_disabled.
      md/raid5: finalise new merged handle_stripe.
      md/raid5: move some more common code into handle_stripe
      md/raid5: move more common code into handle_stripe
      md/raid5: unite handle_stripe_dirtying5 and handle_stripe_dirtying6
      md/raid5: unite fetch_block5 and fetch_block6
      md/raid5: rearrange a test in fetch_block6.
      md/raid5: move more code into common handle_stripe
      md/raid5: Move code for finishing a reconstruction into handle_stripe.
      md/raid5: move stripe_head_state and more code into handle_stripe.
      md/raid5:  add some more fields to stripe_head_state
      md/raid5: unify stripe_head_state and r6_state
      md/raid5: move common code into handle_stripe
      md/raid5: replace sh->lock with an 'active' flag.
      md/raid5: Protect some more code with ->device_lock.
      md/raid5: Remove use of sh->lock in sync_request


 drivers/md/bitmap.c |  137 +++-----
 drivers/md/bitmap.h |    5 
 drivers/md/md.c     |   77 ++---
 drivers/md/md.h     |   28 +-
 drivers/md/raid1.c  |   66 ++--
 drivers/md/raid1.h  |    6 
 drivers/md/raid10.c |  214 +++++++------
 drivers/md/raid10.h |    5 
 drivers/md/raid5.c  |  832 ++++++++++++++-------------------------------------
 drivers/md/raid5.h  |   45 +--
 10 files changed, 505 insertions(+), 910 deletions(-)

-- 
Signature

