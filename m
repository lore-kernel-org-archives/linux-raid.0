From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD update for 4.10
Date: Tue, 13 Dec 2016 22:23:16 -0800
Message-ID: <20161214062316.br6uje3whezynkqs@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Hi Linus,

Please pull MD changes for 4.10. This update includes:
- A raid5 writeback cache feature. The goal is to aggregate writes to make full
  stripe write and reduce read-modify-write. It's helpful for workload which
  does sequential write and follows fsync for example. This feature is
  experimental and off by default right now.
- FAILFAST support. This fails IOs to broken raid disks quickly, so can improve
  latency. It's mainly for DASD storage, but some patches help normal raid
  array too.
- Support bad block for raid array with external metadata
- AVX2 instruction support for raid6 parity calculation
- Normalize MD info output
- Add missing blktrace
- Other bug fixes

Thanks,
Shaohua

The following changes since commit b78b499a67c3f77aeb6cd0b54724bc38b141255d:

  Merge tag 'char-misc-4.10-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc (2016-12-13 12:11:01 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git for-linus

for you to fetch changes up to 20737738d397dfadbca1ea50dcc00d7259f500cf:

  Merge branch 'md-next' into md-linus (2016-12-13 12:40:15 -0800)

----------------------------------------------------------------
Dan Carpenter (1):
      md/r5cache: enable IRQs on error path

Gayatri Kammela (1):
      lib/raid6: Add AVX2 optimized xor_syndrome functions

Guoqing Jiang (1):
      md/bitmap: call bitmap_file_unmap once bitmap_storage_alloc returns -ENOMEM

JackieLiu (8):
      raid5-cache: restrict the use area of the log_offset variable
      md/raid5-cache: remove unnecessary function parameters
      md/raid5-cache: use ring add to prevent overflow
      md/raid5-cache: release the stripe_head at the appropriate location
      md/raid5-cache: remove the unnecessary next_cp_seq field from the r5l_log
      md/raid5-cache: do not need to set STRIPE_PREREAD_ACTIVE repeatedly
      md/raid5-cache: adjust the write position of the empty block if no data blocks
      md/raid5-cache: no recovery is required when create super-block

Konstantin Khlebnikov (1):
      md/raid5: limit request size according to implementation limits

NeilBrown (26):
      md: fix some issues with alloc_disk_sb()
      md: change all printk() to pr_err() or pr_warn() etc.
      md/bitmap: change all printk() to pr_*()
      md/linear: replace printk() with pr_*()
      md/multipath: replace printk() with pr_*()
      md/raid0: replace printk() with pr_*()
      md/raid1: change printk() to pr_*()
      md/raid10: change printk() to pr_*()
      md/raid5: change printk() to pr_*()
      md: perform async updates for metadata where possible.
      md/raid1: abort delayed writes when device fails.
      md/raid10: abort delayed writes when device fails.
      md/bitmap: Don't write bitmap while earlier writes might be in-flight
      md/raid1: fix: IO can block resync indefinitely
      md: define mddev flags, recovery flags and r1bio state bits using enums
      md: remove md_super_wait() call after bitmap_flush()
      md: add block tracing for bio_remapping
      md/bitmap: add blktrace event for writes to the bitmap
      md/raid1, raid10: add blktrace records when IO is delayed
      md/failfast: add failfast flag for md to be used by some personalities.
      md: Use REQ_FAILFAST_* on metadata writes where appropriate
      md/raid1: add failfast handling for reads.
      md/raid1: add failfast handling for writes.
      md/raid10: add failfast handling for reads.
      md/raid10: add failfast handling for writes.
      md: fix refcount problem on mddev when stopping array.

Shaohua Li (8):
      raid5-cache: fix lockdep warning
      md: add blktrace event for writes to superblock
      raid5-cache: suspend reclaim thread instead of shutdown
      md: stop write should stop journal reclaim
      md: takeover should clear unrelated bits
      md: MD_RECOVERY_NEEDED is set for mddev->recovery
      md: separate flags for superblock changes
      Merge branch 'md-next' into md-linus

Song Liu (14):
      md/r5cache: Check array size in r5l_init_log
      md/r5cache: move some code to raid5.h
      md/r5cache: State machine for raid5-cache write back mode
      md/r5cache: caching phase of r5cache
      md/r5cache: write-out phase and reclaim support
      md/r5cache: sysfs entry journal_mode
      md/r5cache: refactoring journal recovery code
      md/r5cache: r5cache recovery: part 1
      md/r5cache: r5cache recovery: part 2
      md/r5cache: handle FLUSH and FUA
      md/r5cache: handle alloc_page failure
      md/r5cache: run_no_space_stripes() when R5C_LOG_CRITICAL == 0
      md/raid5-cache: fix crc in rewrite_data_only_stripes()
      md/r5cache: after recovery, increase journal seq by 10000

Tomasz Majchrzak (4):
      md: add bad block support for external metadata
      md: don't fail an array if there are unacknowledged bad blocks
      md: wake up personality thread after array state update
      raid5: revert commit 11367799f3d1

Zhengyuan Liu (3):
      raid5-cache: add another check conditon before replaying one stripe
      raid5-cache: don't set STRIPE_R5C_PARTIAL_STRIPE flag while load stripe into cache
      md/r5cache: do r5c_update_log_state after log recovery

 drivers/md/bitmap.c            |  166 ++--
 drivers/md/dm-raid.c           |    4 +-
 drivers/md/linear.c            |   31 +-
 drivers/md/md.c                |  701 ++++++++-------
 drivers/md/md.h                |  108 ++-
 drivers/md/multipath.c         |   92 +-
 drivers/md/raid0.c             |  107 ++-
 drivers/md/raid1.c             |  247 ++++--
 drivers/md/raid1.h             |   19 +-
 drivers/md/raid10.c            |  295 ++++---
 drivers/md/raid10.h            |    2 +
 drivers/md/raid5-cache.c       | 1885 +++++++++++++++++++++++++++++++++++-----
 drivers/md/raid5.c             |  623 +++++++------
 drivers/md/raid5.h             |  172 +++-
 include/uapi/linux/raid/md_p.h |    7 +-
 lib/raid6/avx2.c               |  232 ++++-
 16 files changed, 3429 insertions(+), 1262 deletions(-)
