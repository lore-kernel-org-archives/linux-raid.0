From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD update for 4.15-rc1
Date: Tue, 14 Nov 2017 11:56:51 -0800
Message-ID: <20171114195651.zxo3hz3odpc2j24d@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Please pull MD patches for 4.15. This update mostly includes bug fixes:
- md-cluster now supports raid10 from Guoqing
- raid5 PPL fixes from Artur
- badblock regression fix from Bo
- suspend hang related fixes from Neil
- raid5 reshape fixes from Neil
- raid1 freeze deadlock fix from Nate
- memleak fixes from Zdenek
- bitmap related fixes from Me and Tao
- other fixes and cleanup

Thanks,
Shaohua

The following changes since commit 9e66317d3c92ddaab330c125dfe9d06eee268aff:

  Linux 4.14-rc3 (2017-10-01 14:54:54 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git for-next

for you to fetch changes up to 0868b99c214a3d55486c700de7c3f770b7243e7c:

  md: free unused memory after bitmap resize (2017-11-10 11:45:13 -0800)

----------------------------------------------------------------
Artur Paszkiewicz (3):
      raid5-ppl: don't resync after rebuild
      raid5-ppl: check recovery_offset when performing ppl recovery
      md: don't check MD_SB_CHANGE_CLEAN in md_allow_write

Colin Ian King (3):
      md-cluster: make function cluster_check_sync_size static
      md: raid10: remove a couple of redundant variables and initializations
      md: remove redundant variable q

Guoqing Jiang (7):
      md: always set THREAD_WAKEUP and wake up wqueue if thread existed
      md-cluster: fix wrong condition check in raid1_write_request
      md-cluster/raid10: set "do_balance = 0" if area is resyncing
      md-cluster: Suspend writes in RAID10 if within range
      md-cluster: Use a small window for raid10 resync
      raid1: remove obsolete code in raid1_write_request
      md-cluster: update document for raid10

Hou Tao (1):
      md/bitmap: clear BITMAP_WRITE_ERROR bit before writing it to sb

Liu Bo (1):
      badblocks: fix wrong return value in badblocks_set if badblocks are disabled

Matthias Kaehlcke (1):
      md: raid10: remove VLAIS

Mike Snitzer (1):
      md: rename some drivers/md/ files to have an "md-" prefix

Mikulas Patocka (1):
      md: use TASK_IDLE instead of blocking signals

Nate Dailey (1):
      raid1: prevent freeze_array/wait_all_barriers deadlock

NeilBrown (10):
      md: fix deadlock error in recent patch.
      raid5: Set R5_Expanded on parity devices as well as data.
      md: forbid a RAID5 from having both a bitmap and a journal.
      md: always hold reconfig_mutex when calling mddev_suspend()
      md: don't call bitmap_create() while array is quiesced.
      md: move suspend_hi/lo handling into core md code
      md: use mddev_suspend/resume instead of ->quiesce()
      md: allow metadata update while suspending.
      md: remove special meaning of ->quiesce(.., 2)
      md: be cautious about using ->curr_resync_completed for ->recovery_offset

Shaohua Li (2):
      md/bitmap: revert a patch
      md: use lockdep_assert_held

Zdenek Kabelac (2):
      md: release allocated bitset sync_set
      md: free unused memory after bitmap resize

 Documentation/md/md-cluster.txt            |   3 +-
 MAINTAINERS                                |   7 +-
 block/badblocks.c                          |   2 +-
 drivers/md/Kconfig                         |   5 +-
 drivers/md/Makefile                        |   5 +-
 drivers/md/dm-raid.c                       |  12 +-
 drivers/md/{bitmap.c => md-bitmap.c}       |  27 ++++-
 drivers/md/{bitmap.h => md-bitmap.h}       |   0
 drivers/md/md-cluster.c                    |  12 +-
 drivers/md/{faulty.c => md-faulty.c}       |   0
 drivers/md/{linear.c => md-linear.c}       |   2 +-
 drivers/md/{linear.h => md-linear.h}       |   0
 drivers/md/{multipath.c => md-multipath.c} |   4 +-
 drivers/md/{multipath.h => md-multipath.h} |   0
 drivers/md/md.c                            | 147 ++++++++++++++++---------
 drivers/md/md.h                            |  20 ++--
 drivers/md/raid0.c                         |   2 +-
 drivers/md/raid1.c                         |  78 ++++---------
 drivers/md/raid10.c                        | 169 +++++++++++++++++++++++++----
 drivers/md/raid10.h                        |   6 +
 drivers/md/raid5-cache.c                   |  44 +++++---
 drivers/md/raid5-log.h                     |   2 +-
 drivers/md/raid5-ppl.c                     |   6 +-
 drivers/md/raid5.c                         |  79 +++++++-------
 24 files changed, 409 insertions(+), 223 deletions(-)
 rename drivers/md/{bitmap.c => md-bitmap.c} (99%)
 rename drivers/md/{bitmap.h => md-bitmap.h} (100%)
 rename drivers/md/{faulty.c => md-faulty.c} (100%)
 rename drivers/md/{linear.c => md-linear.c} (99%)
 rename drivers/md/{linear.h => md-linear.h} (100%)
 rename drivers/md/{multipath.c => md-multipath.c} (99%)
 rename drivers/md/{multipath.h => md-multipath.h} (100%)
