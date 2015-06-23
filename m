From: Shaohua Li <shli@fb.com>
Subject: [PATCH V4 00/13] MD: a caching layer for raid5/6
Date: Tue, 23 Jun 2015 14:37:50 -0700
Message-ID: <cover.1435094582.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

Hi,

This is the V4 version of the raid5/6 caching layer patches. The patches add
a caching layer for raid5/6. The caching layer uses a SSD as a cache for a raid
5/6. It works like the similar way of a hardware raid controller. The purpose
is to improve raid performance (reduce read-modify-write) and fix write hole
issue.

I split the patch to into smaller ones and hopefuly they are easier to
understand. The splitted patches will not break bisect. Functions of main parts
are divided well, though some data structures not.

I detached the multiple reclaim thread patch, the patch set is aimed to make
basic logic ready, and we can improve performance later (as long as we can make
sure current logic is flexible to have improvement space for performance).

Neil,

For the issue if flush_start block is required, I double checked it. You are
right we don't really need it, the data/parity checksum stored in cache disk
will guarantee data integrity, but we can't use a simple disk cache flush as
there is ordering issue. So the flush_start block does increase overhead, but
might not too much. I didn't delete it yet, but I'm open to do it.

Thanks,
Shaohua

V4:
-split patche into smaller ones
-add more comments into code and some code cleanup
-bug fixes in recovery code
-fix the feature bit

V3:
-make reclaim multi-thread
-add statistics in sysfs
-bug fixes

V2:
-metadata write doesn't use FUA
-discard request is only issued when necessary
-bug fixes and cleanup

Shaohua Li (12):
  raid5: directly use mddev->queue
  raid5: cache log handling
  raid5: cache part of raid5 cache
  raid5: cache reclaim support
  raid5: cache IO error handling
  raid5: cache device quiesce support
  raid5: cache recovery support
  raid5: add some sysfs entries
  raid5: don't allow resize/reshape with cache support
  raid5: guarantee cache release stripes in correct way
  raid5: enable cache for raid array with cache disk
  raid5: skip resync if caching is enabled

Song Liu (1):
  MD: add a new disk role to present cache device

 drivers/md/Makefile            |    2 +-
 drivers/md/md.c                |   24 +-
 drivers/md/md.h                |    4 +
 drivers/md/raid5-cache.c       | 3755 ++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid5.c             |  176 +-
 drivers/md/raid5.h             |   24 +
 include/uapi/linux/raid/md_p.h |   79 +
 7 files changed, 4016 insertions(+), 48 deletions(-)
 create mode 100644 drivers/md/raid5-cache.c

-- 
1.8.1

