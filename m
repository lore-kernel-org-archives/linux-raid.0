From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC PATCH 3/3] md/isrt: write support
Date: Wed, 23 Apr 2014 23:19:00 -0700
Message-ID: <20140424061900.3187.3550.stgit@viggo.jf.intel.com>
References: <20140424061756.3187.2633.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140424061756.3187.2633.stgit@viggo.jf.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, jes.sorensen@redhat.com, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Dave Jiang <dave.jiang@intel.com>
List-Id: linux-raid.ids

The only case that requires special handling is a write to a
clean/cached sector.  Writes to an un-cached sector can be passed
directly to the target device.  Writes to a dirty sector can be passed
directly to the cache device.  For writes to a clean sector we mark the
frame dirty, flush the metadata write, and then write to the cache
device, which is power-fail safe.  The other cases are already handled
naturally by the recursive splitting implementation.

Use one global write_mutex for simplicity.  This implementation is meant
for read-mostly / sporadic write workloads, i.e. basic dual-boot
compatibility.

Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/isrt.c |  109 +++++++++++++++++++++++++++++++++++++++++++++++++----
 drivers/md/isrt.h |   10 +++++
 2 files changed, 111 insertions(+), 8 deletions(-)

diff --git a/drivers/md/isrt.c b/drivers/md/isrt.c
index 81ff9246e94d..c70be5890f85 100644
--- a/drivers/md/isrt.c
+++ b/drivers/md/isrt.c
@@ -21,7 +21,9 @@
 #include "md.h"
 #include "isrt.h"
 
-static void mpb_read_endio(struct bio *bio, int error)
+struct workqueue_struct *isrt_dirty_workqueue;
+
+static void metadata_endio(struct bio *bio, int error)
 {
 	struct mddev *mddev = bio->bi_private;
 	struct isrt_conf *conf = mddev->private;
@@ -49,7 +51,7 @@ static int isrt_mpb_read(struct mddev *mddev, struct page *page)
 	bio->bi_iter.bi_sector = 0;
 	bio->bi_private = mddev;
 	bio->bi_bdev = rdev->bdev;
-	bio->bi_end_io = mpb_read_endio;
+	bio->bi_end_io = metadata_endio;
 	bio_add_page(bio, page, size, 0);
 
 	atomic_inc(&conf->count);
@@ -79,7 +81,7 @@ static int isrt_read_packed_md(struct mddev *mddev)
 		bio->bi_iter.bi_sector = conf->packed_md_lba + (i >> 9);
 		bio->bi_private = mddev;
 		bio->bi_bdev = rdev->bdev;
-		bio->bi_end_io = mpb_read_endio;
+		bio->bi_end_io = metadata_endio;
 		bio_add_page(bio, page, PAGE_SIZE, 0);
 
 		atomic_inc(&conf->count);
@@ -199,6 +201,7 @@ static int isrt_init_conf(struct mddev *mddev, struct isrt_conf *conf)
 	conf->root = RB_ROOT;
 	init_waitqueue_head(&conf->eventq);
 	atomic_set(&conf->count, 0);
+	mutex_init(&conf->write_mutex);
 
 	if (!page)
 		return -ENOMEM;
@@ -304,6 +307,11 @@ static void isrt_free_conf(struct isrt_conf *conf)
 	if (!conf)
 		return;
 
+	mutex_lock(&conf->write_mutex);
+	clear_bit(ISRT_RUN, &conf->state);
+	flush_workqueue(isrt_dirty_workqueue);
+	mutex_unlock(&conf->write_mutex);
+
 	spin_lock(&conf->lock);
 	for (r = rb_first(&conf->root); r; ) {
 		struct isrt_page *p = to_cache_page(r);
@@ -425,6 +433,7 @@ static struct isrt_conf *isrt_setup_conf(struct mddev *mddev)
 
 	mddev->queue->backing_dev_info.congested_fn = isrt_congested;
 	mddev->queue->backing_dev_info.congested_data = mddev;
+	set_bit(ISRT_RUN, &conf->state);
 
 	return conf;
  abort:
@@ -545,6 +554,85 @@ static sector_t next_frame(sector_t sector)
 	return SECTORS_PER_FRAME - (sector & FRAME_MASK);
 }
 
+
+struct isrt_dirty_work *to_dirty_work(struct work_struct *work)
+{
+	return container_of(work, struct isrt_dirty_work, work);
+}
+
+static void do_mark_dirty(struct work_struct *work)
+{
+	struct isrt_dirty_work *dirty_work = to_dirty_work(work);
+	struct nv_cache_packed_md *frame = dirty_work->frame;
+	struct isrt_conf *conf = dirty_work->conf;
+	struct mddev *mddev = conf->mddev;
+	int frame_idx_align;
+	struct page *page;
+	sector_t sect_offset;
+	struct bio *bio;
+
+	if (frame->flags & NVC_PACKED_DIRTY)
+		return;
+
+	/* we do this once per write hit on a clean frame (most frames are
+	 * expected to be dirty or invalid)
+	 */
+	frame->flags |= NVC_PACKED_DIRTY;
+	frame_idx_align = to_frame_idx(conf, frame) & ~(((PAGE_SIZE/sizeof(*frame))-1));
+	bio = bio_alloc_mddev(GFP_NOIO, 1, mddev);
+	page = vmalloc_to_page(&conf->vmeta[frame_idx_align]);
+	sect_offset = (frame_idx_align * sizeof(*frame)) >> 9;
+
+	if (!bio) {
+		dirty_work->result = false;
+		return;
+	}
+	if (!page) {
+		bio_put(bio);
+		dirty_work->result = false;
+		return;
+	}
+
+	bio->bi_iter.bi_sector = conf->packed_md_lba + sect_offset;
+	bio->bi_private = mddev;
+	bio->bi_bdev = conf->dev[ISRT_DEV_IDX]->bdev;
+	bio->bi_end_io = metadata_endio;
+	bio_add_page(bio, page, PAGE_SIZE, 0);
+
+	pr_debug("%s: frame: %d align: %d sect_offset: %llu\n",
+		 __func__, to_frame_idx(conf, frame), frame_idx_align,
+		 (unsigned long long)sect_offset);
+
+	atomic_inc(&conf->count);
+	submit_bio(WRITE_FLUSH_FUA, bio);
+	wait_event(conf->eventq, atomic_read(&conf->count) == 0);
+
+	if (test_bit(ISRT_ERROR, &conf->state)) {
+		frame->flags &= ~NVC_PACKED_DIRTY;
+		dirty_work->result = false;
+	}
+}
+
+static bool mark_dirty(struct isrt_conf *conf, struct nv_cache_packed_md *frame)
+{
+	struct isrt_dirty_work dirty_work = {
+		.conf = conf,
+		.frame = frame,
+		.result = true,
+	};
+
+	INIT_WORK_ONSTACK(&dirty_work.work, do_mark_dirty);
+
+	mutex_lock(&conf->write_mutex);
+	if (test_bit(ISRT_RUN, &conf->state)) {
+		queue_work(isrt_dirty_workqueue, &dirty_work.work);
+		flush_work(&dirty_work.work);
+	}
+	mutex_unlock(&conf->write_mutex);
+
+	return dirty_work.result;
+}
+
 static void isrt_make_request(struct mddev *mddev, struct bio *bio)
 {
 	struct isrt_conf *conf = mddev->private;
@@ -558,11 +646,6 @@ static void isrt_make_request(struct mddev *mddev, struct bio *bio)
 		return;
 	}
 
-	if (bio_data_dir(bio) == WRITE) {
-		bio_endio(bio, -EOPNOTSUPP);
-		return;
-	}
-
 	if (WARN_ONCE(bio->bi_vcnt > 1,
 		      pr_fmt("%s: block bug: 1 segment supported, got: %d\n"),
 		      mdname(mddev), bio->bi_vcnt)) {
@@ -603,6 +686,12 @@ static void isrt_make_request(struct mddev *mddev, struct bio *bio)
 				sector_t offset = sector & FRAME_MASK;
 				sector_t frame_offset = frame_idx * SECTORS_PER_FRAME;
 
+				if (bio_data_dir(bio) == WRITE
+				    && !mark_dirty(conf, frame)) {
+					bio_io_error(bio);
+					return;
+				}
+
 				rdev = conf->dev[ISRT_DEV_IDX];
 				bio->bi_bdev = rdev->bdev;
 				bio->bi_iter.bi_sector = conf->cache_frame0_lba
@@ -637,12 +726,16 @@ static struct md_personality isrt_personality = {
 
 static int __init isrt_init(void)
 {
+	isrt_dirty_workqueue = create_workqueue("isrt");
+	if (!isrt_dirty_workqueue)
+		return -ENOMEM;
 	return register_md_personality(&isrt_personality);
 }
 
 static void isrt_exit(void)
 {
 	unregister_md_personality(&isrt_personality);
+	destroy_workqueue(isrt_dirty_workqueue);
 }
 
 module_init(isrt_init);
diff --git a/drivers/md/isrt.h b/drivers/md/isrt.h
index 31e354039eae..ee1311d9b1b0 100644
--- a/drivers/md/isrt.h
+++ b/drivers/md/isrt.h
@@ -264,9 +264,19 @@ struct isrt_conf {
 	spinlock_t lock;
 	#define ISRT_META_IO 0
 	#define ISRT_ERROR 1
+	#define ISRT_RUN 2
 	unsigned long state;
 	atomic_t count;
 	wait_queue_head_t eventq;
+	struct mutex write_mutex;
+};
+
+/* we can't wait for metadata updates inline */
+struct isrt_dirty_work {
+	bool result;
+	struct work_struct work;
+	struct isrt_conf *conf;
+	struct nv_cache_packed_md *frame;
 };
 
 static inline u32 to_seg_num(sector_t lba)

