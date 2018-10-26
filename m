From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD update for 4.20
Date: Fri, 26 Oct 2018 11:27:13 -0700
Message-ID: <20181026182713.GA93048@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
Please pull MD update for 4.20. This pull mainly improves raid10 cluster and
fixes some bugs.
- raid10 cluster improvements from Guoqing
- Memory leak fixes from Jack and Xiao
- raid10 hang fix from Alex
- raid5 block faulty device fix from Mariusz
- metadata update fix from Neil
- Invalid disk role fix from Me
- Other clearnups

Thanks,
Shaohua

The following changes since commit f151f57bfd97fb8c76bbef9e181ecba5dd750f2a:

  Merge tag 'drm-fixes-2018-09-28' of git://anongit.freedesktop.org/drm/drm (2018-09-28 18:55:17 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git for-next

for you to fetch changes up to af9b926de9c5986ab009e64917de87c9758bab10:

  MD: Memory leak when flush bio size is zero (2018-10-22 09:15:26 -0700)

----------------------------------------------------------------
Alex Wu (1):
      md/raid10: Fix raid10 replace hang when new added disk faulty

Colin Ian King (1):
      md: remove redundant code that is no longer reachable

Guoqing Jiang (8):
      md-cluster/raid10: resize all the bitmaps before start reshape
      md-cluster/raid10: support add disk under grow mode
      md-cluster: introduce resync_info_get interface for sanity check
      md-cluster/raid10: call update_size in md_reap_sync_thread
      md-cluster/raid10: don't call remove_and_add_spares during reshaping stage
      md-cluster/bitmap: don't call md_bitmap_sync_with_cluster during reshaping stage
      md-cluster: send BITMAP_NEEDS_SYNC message if reshaping is interrupted
      md-cluster: remove suspend_info

Jack Wang (2):
      md/bitmap: use mddev_suspend/resume instead of ->quiesce()
      md: fix memleak for mempool

Mariusz Tkaczyk (1):
      raid5: block failing device if raid will be failed

NeilBrown (1):
      md: allow metadata updates while suspending an array - fix

Shaohua Li (2):
      MD: fix invalid stored role for a disk
      MD: fix invalid stored role for a disk - try2

Xiao Ni (1):
      MD: Memory leak when flush bio size is zero

 drivers/md/md-bitmap.c   |   9 +-
 drivers/md/md-cluster.c  | 234 ++++++++++++++++++++++++++++++++---------------
 drivers/md/md-cluster.h  |   2 +
 drivers/md/md.c          | 113 +++++++++++++++++------
 drivers/md/md.h          |   1 +
 drivers/md/raid1.c       |   1 +
 drivers/md/raid10.c      | 109 ++++++++++++++++++----
 drivers/md/raid5-cache.c |   2 -
 drivers/md/raid5.c       |  12 +++
 9 files changed, 356 insertions(+), 127 deletions(-)
