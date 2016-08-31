From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 0/5] raid5-cache: enabling cache features
Date: Wed, 31 Aug 2016 15:18:17 -0700
Message-ID: <1472681902-1172317-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

These patches enable write cache part of raid5-cache. The journal part was
released with kernel 4.4.

The caching part uses same disk format of raid456 journal, and provides
acceleration to writes. Write operations are committed (bio_endio) once
the data is secured in journal. Reconstruct and RMW are postponed to
reclaim path, which is (hopefully) not on the critical path.

The changes are organized in 5 patches (details below). Current reclaim
approach can be improved. So far it works OK in my tests with spinning
disks as raid device and SSD as journal.

I removed the patch for chunk_aligned_read in earlier RFC
(http://marc.info/?l=linux-raid&m=146432700719277). But we may still need
some optimizations later, especially for SSD raid devices.

Thanks,
Song

Song Liu (5):
  r5cache: write part of r5cache
  r5cache: sysfs entry r5c_state
  r5cache: naive reclaim approach
  r5cache: r5c recovery
  r5cache: handle SYNC and FUA

 drivers/md/raid5-cache.c | 1299 ++++++++++++++++++++++++++++++++++++++++------
 drivers/md/raid5.c       |  185 ++++++-
 drivers/md/raid5.h       |   30 +-
 3 files changed, 1327 insertions(+), 187 deletions(-)

--
2.8.0.rc2
