From: Shaohua Li <shli@fb.com>
Subject: [PATCH 0/5] a caching layer for raid 5/6
Date: Wed, 6 May 2015 16:57:10 -0700
Message-ID: <cover.1430954848.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

Hi,

These are the patches to add a caching layer for raid5/6. It uses a SSD as a
cache for a raid 5/6. It works like the similar way of a hardware raid
controller. The purpose is to improve raid performance (reduce
read-modify-write) and fix write hole issue. The main patch is patch 3 and the
description has all details about the implementation.

This also requires mdadm utility changes, which Song will send out later.

Comments and suggestions are welcome!

Thanks,
Shaohua


Shaohua Li (4):
  raid5: directly use mddev->queue
  A caching layer for RAID5/6
  raid5-cache: add some sysfs entries
  md: don't allow resize/reshape with cache support

Song Liu (1):
  MD: add a new disk role to present cache device

 drivers/md/Makefile            |    2 +-
 drivers/md/md.c                |   14 +-
 drivers/md/md.h                |    4 +
 drivers/md/raid5-cache.c       | 3252 ++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid5.c             |   90 +-
 drivers/md/raid5.h             |   16 +-
 include/uapi/linux/raid/md_p.h |   73 +
 7 files changed, 3431 insertions(+), 20 deletions(-)
 create mode 100644 drivers/md/raid5-cache.c

-- 
1.8.1

