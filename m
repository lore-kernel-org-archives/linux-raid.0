From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v6 00/11] raid5-cache: enabling cache features
Date: Thu, 10 Nov 2016 12:46:12 -0800
Message-ID: <20161110204623.3484694-1-songliubraving@fb.com>
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
writing-out phase, which is usually not on the critical path.

The changes are organized in 11 patches (details below).

Patch for chunk_aligned_read in earlier RFC is not included yet
(http://marc.info/?l=linux-raid&m=146432700719277). But we may still need
some optimizations later, especially for SSD raid devices.

Changes between v5 and v4 (http://marc.info/?l=linux-raid&m=147629531615172):
 1. Incorporate feedbacks;
 2. Split reclaim patch into 3 smaller patches for (hopefully) easier review;
 3. Rename different modes of a stripe to "caching" and "writing-out";
 4. Remove flag R5_WantCache;
 5. Rename flag R5_InCache to R5_InJournal;
 6. Remove flag STRIPE_R5C_WRITTEN and use R5_InJournal bit of dev[pd_idx].flags instead;
 7. Remove dev_in_cache from stripe_head;
 8. Add logic to handle alloc_page() failure in handle_stripe_dirtying();

Song Liu (11):
  md/r5cache: Check array size in r5l_init_log
  md/r5cache: move some code to raid5.h
  md/r5cache: State machine for raid5-cache write back mode
  md/r5cache: caching mode of r5cache
  md/r5cache: write-out mode and reclaim support
  md/r5cache: sysfs entry r5c_journal_mode
  md/r5cache: refactoring journal recovery code
  md/r5cache: r5cache recovery: part 1
  md/r5cache: r5cache recovery: part 2
  md/r5cache: handle SYNC and FUA
  md/r5cache: handle alloc_page failure

 drivers/md/raid5-cache.c | 1822 +++++++++++++++++++++++++++++++++++++++++-----
 drivers/md/raid5.c       |  322 +++++---
 drivers/md/raid5.h       |  154 +++-
 3 files changed, 1987 insertions(+), 311 deletions(-)

--
2.9.3
