From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 0/4] more sector_t conversions
Date: Fri, 18 Jul 2008 14:00:15 +0200
Message-ID: <1216382419-2560-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

here's the next batch of patches against Neil's for-next branch that
change some of the remaining 1k-based representations to sector-based
representations.

Patch #1 fixes what I believe is a bug in the check for overlapping
partitions. This patch might also be suitable for -stable while #2-#4
are definitely material for -next.

Patch #2 changes the rdev_size_change function pointer of struct
super_type. The patched version takes the number of sectors instead
of the number of blocks.

Patches #3 and #4 convert the array_size fields of struct mddev_s
and of struct linear_private_data to sector-based representations
respectively.

Please review.
Andre
---

 drivers/md/faulty.c         |    2 +-
 drivers/md/linear.c         |   18 +++++++-------
 drivers/md/md.c             |   52 ++++++++++++++++++++----------------------
 drivers/md/multipath.c      |    2 +-
 drivers/md/raid0.c          |    8 +++---
 drivers/md/raid1.c          |   10 ++++----
 drivers/md/raid10.c         |    2 +-
 drivers/md/raid5.c          |   14 +++++-----
 include/linux/raid/linear.h |    2 +-
 include/linux/raid/md_k.h   |    2 +-
 10 files changed, 55 insertions(+), 57 deletions(-)
