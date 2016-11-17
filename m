From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v7 00/10] raid5-cache: enabling cache features
Date: Thu, 17 Nov 2016 15:24:35 -0800
Message-ID: <20161117232445.1798305-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

These are the 7th version of patches to enable write cache part of
raid5-cache. The journal part was released with kernel 4.4.

The caching part uses same disk format of raid456 journal, and provides
acceleration to writes. Write operations are committed (bio_endio) once
the data is secured in journal. Reconstruct and RMW are postponed to
writing-out phase, which is usually not on the critical path.

The changes are organized in 10 patches (details below).

Patch for chunk_aligned_read in earlier RFC is not included yet
(http://marc.info/?l=linux-raid&m=146432700719277). But we may still need
some optimizations later, especially for SSD raid devices.

Changes between v7 and v6 (http://marc.info/?l=linux-raid&m=147881079931937):
 1. Incorprate feedbacks;
 2. Modify representation of write-back state machine to use STRIPE_R5C_CACHING
    instead of STRIPE_R5C_WRITE_OUT. This reduces state trasitions in
    write-through mode;
 3. For prexor, allocate extra orig_page instead of page;
 4. Rename and refactor of some functions and variables;
 5. Remove path 11 (handle alloc_page failure). I will propose a simpler retry
    patch later.

Song Liu (10):
  md/r5cache: Check array size in r5l_init_log
  md/r5cache: move some code to raid5.h
  md/r5cache: State machine for raid5-cache write back mode
  md/r5cache: caching phase of r5cache
  md/r5cache: write-out phase and reclaim support
  md/r5cache: sysfs entry journal_mode
  md/r5cache: refactoring journal recovery code
  md/r5cache: r5cache recovery: part 1
  md/r5cache: r5cache recovery: part 2
  md/r5cache: handle SYNC and FUA

 drivers/md/raid5-cache.c | 1798 ++++++++++++++++++++++++++++++++++++++++------
 drivers/md/raid5.c       |  301 +++++---
 drivers/md/raid5.h       |  166 ++++-
 3 files changed, 1935 insertions(+), 330 deletions(-)

--
2.9.3
