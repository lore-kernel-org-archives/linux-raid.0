From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v5 0/8] raid5-cache: enabling cache features
Date: Wed, 12 Oct 2016 22:49:36 -0700
Message-ID: <20161013054944.1038806-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

These are the 5th version of patches to enable write cache part of
raid5-cache. The journal part was released with kernel 4.4.

The caching part uses same disk format of raid456 journal, and provides
acceleration to writes. Write operations are committed (bio_endio) once
the data is secured in journal. Reconstruct and RMW are postponed to
reclaim path, which is (hopefully) not on the critical path.

The changes are organized in 8 patches (details below).

Patch for chunk_aligned_read in earlier RFC is not included yet
(http://marc.info/?l=linux-raid&m=146432700719277). But we may still need
some optimizations later, especially for SSD raid devices.

Changes between v5 and v4 (http://marc.info/?l=linux-raid&m=147629531615172)
  1. Change the output/input of sysfs entry r5c_state
  2. Move heavy reclaim work from raid5_make_request() to r5c_do_reclaim()
  3. Fix an issue with orig_page handling in the write path

Changes between v4 and v3 (http://marc.info/?l=linux-raid&m=147573807306070):
  1. Make reclaim robust
  2. Fix a bug in recovery

Changes between v3 and v2 (http://marc.info/?l=linux-raid&m=147493266208102):
  1. Incorporate feedback from Shaohua
  2. Reorganize the patches, for hopefully easier review
  3. Make sure no change to write through mode (journal only)
  4. Change reclaim design to avoid deadlock due to log space

Thanks,
Song

Song Liu (8):
  md/r5cache: Check array size in r5l_init_log
  md/r5cache: move some code to raid5.h
  md/r5cache: State machine for raid5-cache write back mode
  md/r5cache: write part of r5cache
  md/r5cache: reclaim support
  md/r5cache: sysfs entry r5c_state
  md/r5cache: r5c recovery
  md/r5cache: handle SYNC and FUA

 drivers/md/raid5-cache.c | 1659 ++++++++++++++++++++++++++++++++++++++++------
 drivers/md/raid5.c       |  261 +++++---
 drivers/md/raid5.h       |  150 ++++-
 3 files changed, 1772 insertions(+), 298 deletions(-)

--
2.9.3
