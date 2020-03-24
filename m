From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/21] block: move disk_name and related helpers out of partition-generic.c
Date: Tue, 24 Mar 2020 08:25:12 +0100
Message-ID: <20200324072530.544483-4-hch@lst.de>
References: <20200324072530.544483-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <20200324072530.544483-1-hch@lst.de>
Sender: reiserfs-devel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, reiserfs-devel@vger.kernel.org
List-Id: linux-raid.ids

Thes functions aren't really related to partition support, so move them
to a more suitable place.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c               |  6 ++++++
 block/genhd.c             | 21 +++++++++++++++++++++
 block/partition-generic.c | 32 --------------------------------
 3 files changed, 27 insertions(+), 32 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 0985f3422556..209715765a7a 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -680,6 +680,12 @@ struct bio *bio_clone_fast(struct bio *bio, gfp_t gfp_mask, struct bio_set *bs)
 }
 EXPORT_SYMBOL(bio_clone_fast);
 
+const char *bio_devname(struct bio *bio, char *buf)
+{
+	return disk_name(bio->bi_disk, bio->bi_partno, buf);
+}
+EXPORT_SYMBOL(bio_devname);
+
 static inline bool page_is_mergeable(const struct bio_vec *bv,
 		struct page *page, unsigned int len, unsigned int off,
 		bool *same_page)
diff --git a/block/genhd.c b/block/genhd.c
index c5d20a48b4de..2484348d1850 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -69,6 +69,27 @@ void set_capacity_revalidate_and_notify(struct gendisk *disk, sector_t size,
 
 EXPORT_SYMBOL_GPL(set_capacity_revalidate_and_notify);
 
+/*
+ * Format the device name of the indicated disk into the supplied buffer and
+ * return a pointer to that same buffer for convenience.
+ */
+char *disk_name(struct gendisk *hd, int partno, char *buf)
+{
+	if (!partno)
+		snprintf(buf, BDEVNAME_SIZE, "%s", hd->disk_name);
+	else if (isdigit(hd->disk_name[strlen(hd->disk_name)-1]))
+		snprintf(buf, BDEVNAME_SIZE, "%sp%d", hd->disk_name, partno);
+	else
+		snprintf(buf, BDEVNAME_SIZE, "%s%d", hd->disk_name, partno);
+
+	return buf;
+}
+
+const char *bdevname(struct block_device *bdev, char *buf)
+{
+	return disk_name(bdev->bd_disk, bdev->bd_part->partno, buf);
+}
+EXPORT_SYMBOL(bdevname);
 
 void part_inc_in_flight(struct request_queue *q, struct hd_struct *part, int rw)
 {
diff --git a/block/partition-generic.c b/block/partition-generic.c
index 98256e6beabb..6bf5aec2a0dc 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -25,38 +25,6 @@
 extern void md_autodetect_dev(dev_t dev);
 #endif
  
-/*
- * disk_name() is used by partition check code and the genhd driver.
- * It formats the devicename of the indicated disk into
- * the supplied buffer (of size at least 32), and returns
- * a pointer to that same buffer (for convenience).
- */
-
-char *disk_name(struct gendisk *hd, int partno, char *buf)
-{
-	if (!partno)
-		snprintf(buf, BDEVNAME_SIZE, "%s", hd->disk_name);
-	else if (isdigit(hd->disk_name[strlen(hd->disk_name)-1]))
-		snprintf(buf, BDEVNAME_SIZE, "%sp%d", hd->disk_name, partno);
-	else
-		snprintf(buf, BDEVNAME_SIZE, "%s%d", hd->disk_name, partno);
-
-	return buf;
-}
-
-const char *bdevname(struct block_device *bdev, char *buf)
-{
-	return disk_name(bdev->bd_disk, bdev->bd_part->partno, buf);
-}
-
-EXPORT_SYMBOL(bdevname);
-
-const char *bio_devname(struct bio *bio, char *buf)
-{
-	return disk_name(bio->bi_disk, bio->bi_partno, buf);
-}
-EXPORT_SYMBOL(bio_devname);
-
 static ssize_t part_partition_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
-- 
2.25.1
