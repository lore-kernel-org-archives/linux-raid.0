From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 02/28] md: expose max value of behind writes counter
Date: Thu, 15 Apr 2010 16:21:07 +1000
Message-ID: <20100415062107.5126.97018.stgit@notabene.brown>
References: <20100415061516.5126.53068.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415061516.5126.53068.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Paul Clements <paul.clements@steeleye.com>
List-Id: linux-raid.ids

From: Paul Clements <paul.clements@steeleye.com>

Keep track of the maximum number of concurrent write-behind requests
for an md array and exposed this number in sysfs at
   md/bitmap/max_backlog_used

Writing any value to this file will clear it.

This allows userspace to be involved in tuning bitmap/backlog.

Signed-off-by: Paul Clements <paul.clements@steeleye.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/bitmap.c |   29 ++++++++++++++++++++++++++++-
 drivers/md/bitmap.h |    1 +
 2 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 26ac8aa..6279393 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1292,9 +1292,14 @@ int bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sect
 	if (!bitmap) return 0;
 
 	if (behind) {
+		int bw;
 		atomic_inc(&bitmap->behind_writes);
+		bw = atomic_read(&bitmap->behind_writes);
+		if (bw > bitmap->behind_writes_used)
+			bitmap->behind_writes_used = bw;
+
 		PRINTK(KERN_DEBUG "inc write-behind count %d/%d\n",
-		  atomic_read(&bitmap->behind_writes), bitmap->max_write_behind);
+		       bw, bitmap->max_write_behind);
 	}
 
 	while (sectors) {
@@ -2006,6 +2011,27 @@ static ssize_t can_clear_store(mddev_t *mddev, const char *buf, size_t len)
 static struct md_sysfs_entry bitmap_can_clear =
 __ATTR(can_clear, S_IRUGO|S_IWUSR, can_clear_show, can_clear_store);
 
+static ssize_t
+behind_writes_used_show(mddev_t *mddev, char *page)
+{
+	if (mddev->bitmap == NULL)
+		return sprintf(page, "0\n");
+	return sprintf(page, "%lu\n",
+		       mddev->bitmap->behind_writes_used);
+}
+
+static ssize_t
+behind_writes_used_reset(mddev_t *mddev, const char *buf, size_t len)
+{
+	if (mddev->bitmap)
+		mddev->bitmap->behind_writes_used = 0;
+	return len;
+}
+
+static struct md_sysfs_entry max_backlog_used =
+__ATTR(max_backlog_used, S_IRUGO | S_IWUSR,
+       behind_writes_used_show, behind_writes_used_reset);
+
 static struct attribute *md_bitmap_attrs[] = {
 	&bitmap_location.attr,
 	&bitmap_timeout.attr,
@@ -2013,6 +2039,7 @@ static struct attribute *md_bitmap_attrs[] = {
 	&bitmap_chunksize.attr,
 	&bitmap_metadata.attr,
 	&bitmap_can_clear.attr,
+	&max_backlog_used.attr,
 	NULL
 };
 struct attribute_group md_bitmap_group = {
diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
index cb821d7..aa82b7c 100644
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -227,6 +227,7 @@ struct bitmap {
 	int allclean;
 
 	atomic_t behind_writes;
+	unsigned long behind_writes_used; /* highest actual value at runtime */
 
 	/*
 	 * the bitmap daemon - periodically wakes up and sweeps the bitmap


