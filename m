From: Shaohua Li <shli@fb.com>
Subject: [PATCH 0/9]raid5: fix write hole
Date: Wed, 29 Jul 2015 17:38:40 -0700
Message-ID: <cover.1438215986.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

Neil,

These are the patches to fix write hole issue. It did everything you requested.
- one meta data type format
- no super block
- format suitable for future extention of caching.
- just fix write hole issue, no caching support

The recovery doesn't use stripe cache yet, need further tweak of the stripe
cache code. I hope it's easy enough. Please let me know how you think.

Thanks,
Shaohua

Shaohua Li (8):
  md: override md superblock recovery_offset for cache device
  raid5: add basic stripe log
  raid5: log reclaim support
  raid5: log recovery
  raid5: disable batch with log enabled
  raid5: don't allow resize/reshape with cache(log) support
  raid5: enable log for raid array with cache disk
  raid5: skip resync if cache(log) is enabled

Song Liu (1):
  MD: add a new disk role to present cache device

 drivers/md/Makefile            |    2 +-
 drivers/md/md.c                |   28 +-
 drivers/md/md.h                |    4 +
 drivers/md/raid5-cache.c       | 1242 ++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid5.c             |   51 +-
 drivers/md/raid5.h             |   19 +
 include/uapi/linux/raid/md_p.h |   51 ++
 7 files changed, 1388 insertions(+), 9 deletions(-)
 create mode 100644 drivers/md/raid5-cache.c

-- 
1.8.5.6

