From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 00/15 v2] remove all abuse of bi_phys_segments
Date: Wed, 15 Mar 2017 14:05:11 +1100
Message-ID: <148954692173.18641.1294690639716682540.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

This is a revised version of my series to remove all abuse of
bi_phys_segments from md/raid.

Most of the effort is for raid5 - raid1 and raid10 are
comparatively straight forward.

I've also include some optimization of md_write_start() which is now
used more heavily.  This now uses percpu-refcount, which needed a
small modification.

As noted in some of these changelogs, a couple of bugs are fixed
in raid1/raid10.  We should probably create fixes suitable for
-stable.

In this series there is a 'block' patch and a 'percpu-refcount' patch,
which should probably go in through other trees.  I might send those
off as appropriate soonish.

Thanks,
NeilBrown


---

NeilBrown (15):
      md/raid5: use md_write_start to count stripes, not bios
      md/raid5: simplfy delaying of writes while metadata is updated.
      md/raid5: call bio_endio() directly rather than queueing for later.
      block: trace completion of all bios.
      md/raid5: use bio_inc_remaining() instead of repurposing bi_phys_segments as a counter
      md/raid5: remove over-loading of ->bi_phys_segments.
      Revert "md/raid5: limit request size according to implementation limits"
      md/raid1,raid10: move rXbio accounting closer to allocation.
      md/raid10: stop using bi_phys_segments
      md/raid1: stop using bi_phys_segment
      md/raid5: don't test ->writes_pending in raid5_remove_disk
      md: factor out set_in_sync()
      md: close a race with setting mddev->in_sync
      percpu-refcount: support synchronous switch to atomic mode.
      MD: use per-cpu counter for writes_pending


 block/bio.c                     |    3 +
 drivers/md/dm.c                 |    1 
 drivers/md/md.c                 |  136 ++++++++++++++++++++-----------
 drivers/md/md.h                 |    4 +
 drivers/md/raid1.c              |   95 ++++++----------------
 drivers/md/raid10.c             |   82 ++++++-------------
 drivers/md/raid5-cache.c        |   14 +--
 drivers/md/raid5-log.h          |    2 
 drivers/md/raid5.c              |  170 +++++++++++----------------------------
 drivers/md/raid5.h              |   49 -----------
 include/linux/percpu-refcount.h |    1 
 lib/percpu-refcount.c           |   18 ++++
 12 files changed, 216 insertions(+), 359 deletions(-)

--
Signature

