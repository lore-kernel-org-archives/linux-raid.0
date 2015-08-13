From: Shaohua Li <shli@fb.com>
Subject: [patch v2 00/11]md: fix raid5 write hole
Date: Thu, 13 Aug 2015 14:31:53 -0700
Message-ID: <cover.1439500639.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

Hi Neil,

This is the updated patch for the raid5 write hole issue. I thought I addressed
most of issues from you and Christoph. Please let me know if anything is
missed. Something not done yet:

- Still use NOFAIL allocation. I don't think 2-element mempool is ok. An
  io_unit will have several bio (> 2), 2 element bioset isn't ok. We can
dispatch all bio of the io_unit if bio allocation fails, but this will increase
complexity. I'd prefer using NOFAIL allocation now for simplicity and fix it
later if necessary
- Add flag for reshape handling in disk format, but don't support it yet

Thanks,
Shaohua


Shaohua Li (9):
  md: override md superblock recovery_offset for journal device
  raid5: export some functions
  raid5: add a new state for stripe log handling
  raid5: add basic stripe log
  raid5: log reclaim support
  raid5: log recovery
  raid5: disable batch with log enabled
  raid5: don't allow resize/reshape with cache(log) support
  raid5: enable log for raid array with cache disk

Song Liu (2):
  MD: replace special disk roles with macros
  MD: add a new disk role to present write journal device

 drivers/md/Makefile            |    2 +-
 drivers/md/md.c                |   44 +-
 drivers/md/md.h                |   13 +-
 drivers/md/raid5-cache.c       | 1094 ++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid5.c             |  137 +++--
 drivers/md/raid5.h             |   20 +
 include/uapi/linux/raid/md_p.h |   70 ++-
 7 files changed, 1320 insertions(+), 60 deletions(-)
 create mode 100644 drivers/md/raid5-cache.c

-- 
1.8.1

