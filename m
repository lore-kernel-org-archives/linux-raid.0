From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD for 4.6
Date: Sun, 20 Mar 2016 22:10:07 -0700
Message-ID: <20160321051007.GA2231@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.com
List-Id: linux-raid.ids

Hi Linus,

Could you please pull the MD update for 4.6? This update mainly fixes bugs.
- A raid5 discard related fix from Jes
- A MD multipath bio clone fix from Ming
- raid1 error handling deadlock fix from Nate and corresponding raid10 fix from
  myself
- A raid5 stripe batch fix from Neil
- A patch from Sebastian to avoid unnecessary uevent
- Several cleanup/debug patches

Thanks,
Shaohua

The following changes since commit 6dc390ad61ac8dfca5fa9b0823981fb6f7ec17a0:

  Merge tag 'arc-4.5-rc6-fixes-upd' of git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc (2016-02-24 14:06:17 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git tags/md/4.6-rc1

for you to fetch changes up to 1d034e68e2c256640eb1f44bd7dcd89f90806ccf:

  md/raid5: Cleanup cpu hotplug notifier (2016-03-17 14:30:15 -0700)

----------------------------------------------------------------
Anna-Maria Gleixner (1):
      md/raid5: Cleanup cpu hotplug notifier

Eric Engestrom (1):
      md/bitmap: remove redundant check

Guoqing Jiang (3):
      md/raid1: remove unnecessary BUG_ON
      md/bitmap: remove redundant return in bitmap_checkpage
      md: fix typos for stipe

Jes Sorensen (1):
      md/raid5: Compare apples to apples (or sectors to sectors)

Ming Lei (1):
      md: multipath: don't hardcopy bio in .make_request path

Nate Dailey (1):
      raid1: include bio_end_io_list in nr_queued to prevent freeze_array hang

NeilBrown (1):
      md/raid5: preserve STRIPE_PREREAD_ACTIVE in break_stripe_batch_list

Sebastian Parschauer (1):
      md: Drop sending a change uevent when stopping

Shaohua Li (6):
      RAID5: check_reshape() shouldn't call mddev_suspend
      RAID5: revert e9e4c377e2f563 to fix a livelock
      MD: warn for potential deadlock
      Update MD git tree URL
      md/raid5: output stripe state for debug
      raid10: include bio_end_io_list in nr_queued to prevent freeze_array hang

 MAINTAINERS            |  2 +-
 drivers/md/bitmap.c    |  4 +---
 drivers/md/bitmap.h    |  4 ++--
 drivers/md/md.c        |  2 +-
 drivers/md/multipath.c |  4 +++-
 drivers/md/raid1.c     |  8 ++++---
 drivers/md/raid10.c    |  7 ++++--
 drivers/md/raid5.c     | 63 +++++++++++++++++++++++++++++---------------------
 drivers/md/raid5.h     |  4 +++-
 9 files changed, 58 insertions(+), 40 deletions(-)
