From: Neil Brown <neilb@suse.de>
Subject: [PULL REQUEST] md updates for 2.6.31
Date: Thu, 18 Jun 2009 09:34:46 +1000
Message-ID: <19001.32150.348268.35201@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Hi Linus,
 here is the merge-window pull request for md.

 The only real functional change is that we now support non-power-of-2
 chunk sizes in raid0.
 Apart from that there is a lot of simplification and clean up in
 raid0 and linear, some minor refactorisation, and assorted bug fixes.

thanks,
NeilBrown

The following changes since commit 45e3e1935e2857c54783291107d33323b3ef33c8:
  Linus Torvalds (1):
        Merge branch 'master' of git://git.kernel.org/.../sam/kbuild-next

are available in the git repository at:

  git://neil.brown.name/md for-linus

Andre Noll (13):
      md: raid0: Replace hash table lookup by looping over all strip_zones.
      md: raid0: Remove hash table.
      md: raid0: Remove hash spacing and sector shift.
      md: raid0: Make raid0_run() return a proper error code.
      md: raid0: Allocate all buffers for the raid0 configuration in one function.
      md: raid0: Fix a memory leak when stopping a raid0 array.
      md: Make mddev->chunk_size sector-based.
      md: Convert mddev->new_chunk to sectors.
      md: convert conf->chunk_size and conf->prev_chunk to sectors.
      md/raid5: Use is_power_of_2() in raid5_reconfig()/raid6_reconfig().
      md: fix some comments.
      md: Push down reconstruction log message to personality code.
      md: Move check for bitmap presence to personality code.

Dan Williams (1):
      md/raid5: add missing call to schedule() after prepare_to_wait()

NeilBrown (14):
      md/raid0: two cleanups in create_stripe_zones.
      md: raid0: remove ->sectors from the strip_zone structure.
      md: raid0: remove ->dev pointer from strip_zone structure
      md: raid0:  remove setting of segment boundary.
      md: remove mddev_to_conf "helper" macro
      md: raid0: chunk_sectors cleanups.
      md: raid5: check stripe cache is large enough in start_reshape
      md: remove unnecessary arguments from ->reconfig method.
      md: merge reconfig and check_reshape methods.
      md: move assignment of ->utime so that it never gets skipped.
      md: raid0/linear: ensure device sizes are rounded to chunk size.
      md: remove chunksize rounding from common code.
      md/linear: use call_rcu to free obsolete 'conf' structures.
      md/raid5: correctly update sync_completed when we reach max_resync

Sandeep K Sinha (3):
      md: Removal of hash table in linear raid
      md: Removing num_sector and replacing start_sector with end_sector
      md: Binary search in linear raid

SandeepKsinha (1):
      md linear: Protecting mddev with rcu locks to avoid races

raz ben yehuda (7):
      md: have raid0 compile with MD_DEBUG on
      md: have raid0 report its formation
      md: raid0: chunk size check in raid0_run
      md: raid10: chunk size check in run
      md: raid5: chunk size check in setup_conf
      md: prepare for non-power-of-two chunk sizes
      md: raid0 :Enables chunk size other than powers of 2.

 drivers/md/faulty.c       |   21 ++-
 drivers/md/linear.c       |  218 ++++++++++--------------
 drivers/md/linear.h       |   12 +-
 drivers/md/md.c           |  196 +++++++++--------------
 drivers/md/md.h           |   14 +-
 drivers/md/multipath.c    |   23 ++-
 drivers/md/multipath.h    |    6 -
 drivers/md/raid0.c        |  403 +++++++++++++++++++++++---------------------
 drivers/md/raid0.h        |   10 +-
 drivers/md/raid1.c        |   46 +++---
 drivers/md/raid1.h        |    6 -
 drivers/md/raid10.c       |   62 ++++---
 drivers/md/raid10.h       |    6 -
 drivers/md/raid5.c        |  218 +++++++++++++------------
 drivers/md/raid5.h        |    8 +-
 include/linux/raid/md_p.h |    2 +-
 16 files changed, 588 insertions(+), 663 deletions(-)
