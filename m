From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 00/14] remove all abuse of bi_phys_segments
Date: Thu, 16 Feb 2017 15:39:01 +1100
Message-ID: <148721992248.7521.17160361058957519076.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

This series removes all abuse of bi_phys_segments from
md/raid.
Most of the effort is for raid5 - raid1 and raid10 are
comparatively straight forward.

I've also include some optimization of md_write_start() which is now
used more heavily.  This is the most "interesting" code, so it is at
the end, allowing it to easily be postponed.

The raid1 parts will conflict with Coly's raid1 resync changes.  The
conflicts aren't serious.  Which ever goes in last can easily be
adjusted to work with the other.

As you can see below, we save over 100 lines of code :-)

I've reviewed these a couple of times and done some light testing.
More review and testing would be welcome.

Thanks,
NeilBrown



---

NeilBrown (14):
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
      MD: use per-cpu counter for writes_pending


 block/bio.c              |    3 +
 drivers/md/dm.c          |    1 
 drivers/md/md.c          |  161 ++++++++++++++++++++++++++++++++------------
 drivers/md/md.h          |    3 +
 drivers/md/raid1.c       |  106 ++++++++++-------------------
 drivers/md/raid10.c      |   82 +++++++----------------
 drivers/md/raid5-cache.c |   14 +---
 drivers/md/raid5.c       |  167 ++++++++++++----------------------------------
 drivers/md/raid5.h       |   51 +-------------
 9 files changed, 235 insertions(+), 353 deletions(-)

--
Signature

