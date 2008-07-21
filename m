From: Neil Brown <neilb@suse.de>
Subject: [PULL REQUEST] md patches for merge window
Date: Mon, 21 Jul 2008 20:03:29 +1000
Message-ID: <18564.24305.197130.749555@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


There is a whole bunch of stuff here for 2.6.27.
 - raid5 cleanups from Dan Williams
 - general code cleanup from Andre Noll
 - various minor improvements and bug fixes.

Thanks,
NeilBrown

The following changes since commit 5b664cb235e97afbf34db9c4d77f08ebd725335e:
  Linus Torvalds (1):
        Merge branch 'upstream-linus' of git://git.kernel.org/.../mfasheh/ocfs2

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

Andre Noll (21):
      md: md_ioctl(): Fix misleading indentation.
      md: md_getgeo(): Move comment to proper position.
      md: do_md_run(): Fix misleading error message.
      md: sync_speed_show(): Trivial cleanups.
      md: Fix typo in array_state comment.
      md: Fix a typo in the comment to cmd_match().
      md: sb_equal(): Fix misleading printk.
      md: Simplify uuid_equal().
      md: Simplify sb_equal().
      md: alloc_disk_sb(): Return proper error value.
      md: Simplify restart_array().
      md: get_disk_info(): Don't convert between signed and unsigned and back.
      md: Make update_size() take the number of sectors.
      md: Replace calc_dev_size() by calc_num_sectors().
      md: Make calc_dev_sboffset() return a sector count.
      md: Turn rdev->sb_offset into a sector-based quantity.
      md: Remove some unused macros.
      md: Fix check for overlapping devices.
      md: Make super_type->rdev_size_change() take sector-based sizes.
      md: Make mddev->array_size sector-based.
      md: linear: Make array_size sector-based and rename it to array_sectors.

Chris Webb (1):
      Support changing rdev size on running arrays.

Dan Williams (12):
      md: kill STRIPE_OP_MOD_DMA in raid5 offload
      md: kill STRIPE_OP_IO flag
      md: use stripe_head_state in ops_run_io()
      md: unify raid5/6 i/o submission
      md: replace STRIPE_OP_CHECK with 'check_states'
      md: replace STRIPE_OP_BIOFILL with STRIPE_BIOFILL_RUN
      md: replace STRIPE_OP_COMPUTE_BLK with STRIPE_COMPUTE_RUN
      md: replace STRIPE_OP_{BIODRAIN,PREXOR,POSTXOR} with 'reconstruct_states'
      md: replace R5_WantPrexor with R5_WantDrain, add 'prexor' reconstruct_states
      md: handle operation chaining in raid5_run_ops
      md: rationalize raid5 function names
      md: resolve external metadata handling deadlock in md_allow_write

Neil Brown (19):
      use bio_endio instead of a call to bi_end_io
      Improve setting of "events_cleared" for write-intent bitmaps.
      Allow setting start point for requested check/repair
      Close race in md_probe
      Don't try to make md arrays dirty if that is not meaningful.
      Enable setting of 'offset' and 'size' of a hot-added spare.
      Support adding a spare to a live md array with external metadata.
      rationalise return value for ->hot_add_disk method.
      Don't reject HOT_REMOVE_DISK request for an array that is not yet started.
      Make sure all changes to md/array_state are notified.
      Make sure all changes to md/sync_action are notified.
      Make sure all changes to md/degraded are notified.
      Make sure all changes to md/dev-XX/state are notified
      Merge branch 'master' into for-next
      Merge branch 'for-neil' of git://git.kernel.org/.../djbw/md into for-next
      Merge branch 'for-2.6.26' into for-next
      Merge branch 'master' into for-next
      md: Better control of when do_md_stop is allowed to stop the array.
      md: Tidy up rdev_size_store a bit:

NeilBrown (2):
      md: only count actual openers as access which prevent a 'stop'
      md: Protect access to mddev->disks list using RCU

Nikanth Karthikesan (1):
      linear: correct disk numbering error check

 Documentation/md.txt        |   30 ++-
 drivers/md/bitmap.c         |   54 +++-
 drivers/md/faulty.c         |    2 +-
 drivers/md/linear.c         |   20 +-
 drivers/md/md.c             |  615 +++++++++++++++++++++++-------------
 drivers/md/multipath.c      |   17 +-
 drivers/md/raid0.c          |    8 +-
 drivers/md/raid1.c          |   30 ++-
 drivers/md/raid10.c         |   22 +-
 drivers/md/raid5.c          |  745 +++++++++++++++----------------------------
 include/linux/raid/bitmap.h |    1 +
 include/linux/raid/linear.h |    2 +-
 include/linux/raid/md.h     |    2 +-
 include/linux/raid/md_k.h   |   17 +-
 include/linux/raid/md_p.h   |    3 -
 include/linux/raid/raid5.h  |   64 +++--
 16 files changed, 842 insertions(+), 790 deletions(-)
