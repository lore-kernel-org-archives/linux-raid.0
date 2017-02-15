From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v2 5/5] md: fast clone bio in bio_clone_mddev()
Date: Wed, 15 Feb 2017 15:19:00 -0800
Message-ID: <20170215231900.omsehusrjdgva67t@kernel.org>
References: <1487086143-10255-1-git-send-email-tom.leiming@gmail.com>
 <1487086143-10255-6-git-send-email-tom.leiming@gmail.com>
 <20170214160109.GA32705@infradead.org>
 <20170215192025.fo7jsew7pvagp5hv@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170215192025.fo7jsew7pvagp5hv@kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <tom.leiming@gmail.com>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

On Wed, Feb 15, 2017 at 11:20:25AM -0800, Shaohua Li wrote:
> On Tue, Feb 14, 2017 at 08:01:09AM -0800, Christoph Hellwig wrote:
> > On Tue, Feb 14, 2017 at 11:29:03PM +0800, Ming Lei wrote:
> > > Firstly bio_clone_mddev() is used in raid normal I/O and isn't
> > > in resync I/O path.
> > > 
> > > Secondly all the direct access to bvec table in raid happens on
> > > resync I/O except for write behind of raid1, in which we still
> > > use bio_clone() for allocating new bvec table.
> > > 
> > > So this patch replaces bio_clone() with bio_clone_fast()
> > > in bio_clone_mddev().
> > > 
> > > Also kill bio_clone_mddev() and call bio_clone_fast() directly, as
> > > suggested by Christoph Hellwig.
> > > 
> > > Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> > 
> > Looks fine,
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> > Btw, can you also tack on another patch to kill bio_alloc_mddev
> > to be consistent?
> 
> I'll take care of this

Hmm, bio_alloc_mddev is a little different, it could be called without the
bio_set. We can only guarantee the bio_set is valid for bio for md personality
not for metadata. Fully fixing the bio_set issue will need rework mddev struct
allocation, don't think it's worthy doing. So below is one removing the export
of the wrap.

From eaf70c32e5cca68110a0cf7a0311ef0ac97f4d42 Mon Sep 17 00:00:00 2001
Message-Id: <eaf70c32e5cca68110a0cf7a0311ef0ac97f4d42.1487200103.git.shli@fb.com>
From: Shaohua Li <shli@fb.com>
Date: Wed, 15 Feb 2017 11:41:21 -0800
Subject: [PATCH] md: don't export bio_alloc_mddev

When mddev is running, it has a valid bio_set, so the bio_alloc_mddev
wrap is unncessary. The problem is we run some IO (eg, load superblock)
before mddev is fully initialized. At that time bio_set isn't
initialized. Moving bio_set creation to md_alloc doesn't help either,
because dm-raid doesn't use it.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c     | 12 ++++++------
 drivers/md/md.h     |  2 --
 drivers/md/raid1.c  |  2 +-
 drivers/md/raid10.c |  2 +-
 4 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 55e7e7a..bef1863 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -171,11 +171,12 @@ static const struct block_device_operations md_fops;
 
 static int start_readonly;
 
-/* bio_clone_mddev
- * like bio_clone, but with a local bio set
+/*
+ * This is only required for meta data related bio, where bio_set might not be
+ * initialized yet. dm-raid doesn't use md_alloc, so we can't alloc bio_set
+ * there.
  */
-
-struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
+static struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
 			    struct mddev *mddev)
 {
 	struct bio *b;
@@ -188,7 +189,6 @@ struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
 		return NULL;
 	return b;
 }
-EXPORT_SYMBOL_GPL(bio_alloc_mddev);
 
 /*
  * We have a system wide 'event count' that is incremented
@@ -393,7 +393,7 @@ static void submit_flushes(struct work_struct *ws)
 			atomic_inc(&rdev->nr_pending);
 			atomic_inc(&rdev->nr_pending);
 			rcu_read_unlock();
-			bi = bio_alloc_mddev(GFP_NOIO, 0, mddev);
+			bi = bio_alloc_bioset(GFP_NOIO, 0, mddev->bio_set);
 			bi->bi_end_io = md_end_flush;
 			bi->bi_private = rdev;
 			bi->bi_bdev = rdev->bdev;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b8859cb..44fe227 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -673,8 +673,6 @@ extern void md_rdev_clear(struct md_rdev *rdev);
 
 extern void mddev_suspend(struct mddev *mddev);
 extern void mddev_resume(struct mddev *mddev);
-extern struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
-				   struct mddev *mddev);
 
 extern void md_unplug(struct blk_plug_cb *cb, bool from_schedule);
 extern void md_reload_sb(struct mddev *mddev, int raid_disk);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index ad5c948..2180a9a 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2281,7 +2281,7 @@ static int narrow_write_error(struct r1bio *r1_bio, int i)
 				vcnt--;
 			}
 
-			wbio = bio_alloc_mddev(GFP_NOIO, vcnt, mddev);
+			wbio = bio_alloc_bioset(GFP_NOIO, vcnt, mddev->bio_set);
 			memcpy(wbio->bi_io_vec, vec, vcnt * sizeof(struct bio_vec));
 
 			wbio->bi_vcnt = vcnt;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index ade7d69..a1f8e98 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4473,7 +4473,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 		return sectors_done;
 	}
 
-	read_bio = bio_alloc_mddev(GFP_KERNEL, RESYNC_PAGES, mddev);
+	read_bio = bio_alloc_bioset(GFP_KERNEL, RESYNC_PAGES, mddev->bio_set);
 
 	read_bio->bi_bdev = rdev->bdev;
 	read_bio->bi_iter.bi_sector = (r10_bio->devs[r10_bio->read_slot].addr
-- 
2.9.3
