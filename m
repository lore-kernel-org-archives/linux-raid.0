From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 0/6] raid5-cache: enabling cache features
Date: Mon, 26 Sep 2016 16:30:44 -0700
Message-ID: <20160926233050.3351081-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

These are the second version of patches to enable write cache part of
raid5-cache. The journal part was released with kernel 4.4.

The caching part uses same disk format of raid456 journal, and provides
acceleration to writes. Write operations are committed (bio_endio) once
the data is secured in journal. Reconstruct and RMW are postponed to
reclaim path, which is (hopefully) not on the critical path.

The changes are organized in 6 patches (details below).

Patch for chunk_aligned_read in earlier RFC is not included yet
(http://marc.info/?l=linux-raid&m=146432700719277). But we may still need
some optimizations later, especially for SSD raid devices.

Changes from PATCH v1 (http://marc.info/?l=linux-raid&m=147268192718851):
  1. Improvements in reclaim patch
  2. Fixed issue with bitmap
  3. A fix by ZhengYuan Liu

Thanks,
Song

Song Liu (5):
  r5cache: write part of r5cache
  r5cache: sysfs entry r5c_state
  r5cache: reclaim support
  r5cache: r5c recovery
  r5cache: handle SYNC and FUA

ZhengYuan Liu (1):
  md/r5cache: decrease the counter after full-write stripe was reclaimed

 drivers/md/raid5-cache.c | 1433 ++++++++++++++++++++++++++++++++++++++++------
 drivers/md/raid5.c       |  219 ++++++-
 drivers/md/raid5.h       |   71 ++-
 3 files changed, 1508 insertions(+), 215 deletions(-)

--
2.9.3
