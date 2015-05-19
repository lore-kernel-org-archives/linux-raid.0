From: Shaohua Li <shli@fb.com>
Subject: [PATCH v2 0/6] a caching layer for raid5/6
Date: Mon, 18 May 2015 19:57:28 -0700
Message-ID: <cover.1432003804.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

Hi,

This is the second version of the raid5/6 caching layer patches. The patches add a
caching layer for raid5/6. The caching layer uses a SSD as a cache for a raid
5/6. It works like the similar way of a hardware raid controller. The purpose
is to improve raid performance (reduce read-modify-write) and fix write hole
issue. The main patch is patch 3 and the description has all details about the
implementation.

Main changes of V2 are to improve performance. Meta data write doesn't use FUA
any more. Discard request is only dispatched when discard range is big enough.
Also have some bug fixing and code cleanup. Please review!

Thanks,
Shaohua


Shaohua Li (5):
  raid5: directly use mddev->queue
  raid5: A caching layer for RAID5/6
  raid5: add some sysfs entries
  md: don't allow resize/reshape with cache support
  raid5: skip resync if caching is enabled

Song Liu (1):
  MD: add a new disk role to present cache device

 drivers/md/Makefile            |    2 +-
 drivers/md/md.c                |   14 +-
 drivers/md/md.h                |    4 +
 drivers/md/raid5-cache.c       | 3519 ++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid5.c             |   97 +-
 drivers/md/raid5.h             |   16 +-
 include/uapi/linux/raid/md_p.h |   73 +
 7 files changed, 3705 insertions(+), 20 deletions(-)
 create mode 100644 drivers/md/raid5-cache.c

-- 
1.8.1

