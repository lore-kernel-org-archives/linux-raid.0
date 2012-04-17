From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 02/24] md/bitmap: add new 'space' attribute for bitmaps.
Date: Tue, 17 Apr 2012 18:43:39 +1000
Message-ID: <20120417084339.6433.49111.stgit@notabene.brown>
References: <20120417084324.6433.68345.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120417084324.6433.68345.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If we are to allow bitmaps to be resized when the array is resized,
we need to know how much space there is.

So create an attribute to store this information and set appropriate
defaults.

It can be set more precisely via sysfs, or future metadata extensions
may allow it to be recorded.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |   39 +++++++++++++++++++++++++++++++++++++++
 drivers/md/md.c     |   33 +++++++++++++++++++++++++++++++--
 drivers/md/md.h     |    3 +++
 3 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index a515e5b..c894aa4 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1935,6 +1935,44 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 static struct md_sysfs_entry bitmap_location =
 __ATTR(location, S_IRUGO|S_IWUSR, location_show, location_store);
 
+/* 'bitmap/space' is the space available at 'location' for the
+ * bitmap.  This allows the kernel to know when it is safe to
+ * resize the bitmap to match a resized array.
+ */
+static ssize_t
+space_show(struct mddev *mddev, char *page)
+{
+	return sprintf(page, "%lu\n", mddev->bitmap_info.space);
+}
+
+static ssize_t
+space_store(struct mddev *mddev, const char *buf, size_t len)
+{
+	unsigned long sectors;
+	int rv;
+
+	rv = kstrtoul(buf, 10, &sectors);
+	if (rv)
+		return rv;
+
+	if (sectors == 0)
+		return -EINVAL;
+
+	if (mddev->bitmap &&
+	    sectors  < ((mddev->bitmap->file_pages - 1) * PAGE_SIZE
+			+ mddev->bitmap->last_page_size + 511) >> 9)
+		return -EFBIG; /* Bitmap is too big for this small space */
+
+	/* could make sure it isn't too big, but that isn't really
+	 * needed - user-space should be careful.
+	 */
+	mddev->bitmap_info.space = sectors;
+	return len;
+}
+
+static struct md_sysfs_entry bitmap_space =
+__ATTR(space, S_IRUGO|S_IWUSR, space_show, space_store);
+
 static ssize_t
 timeout_show(struct mddev *mddev, char *page)
 {
@@ -2110,6 +2148,7 @@ __ATTR(max_backlog_used, S_IRUGO | S_IWUSR,
 
 static struct attribute *md_bitmap_attrs[] = {
 	&bitmap_location.attr,
+	&bitmap_space.attr,
 	&bitmap_timeout.attr,
 	&bitmap_backlog.attr,
 	&bitmap_chunksize.attr,
diff --git a/drivers/md/md.c b/drivers/md/md.c
index e763fc1..64b86c7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1197,7 +1197,10 @@ static int super_90_validate(struct mddev *mddev, struct md_rdev *rdev)
 		mddev->dev_sectors = ((sector_t)sb->size) * 2;
 		mddev->events = ev1;
 		mddev->bitmap_info.offset = 0;
+		mddev->bitmap_info.space = 0;
+		/* bitmap can use 60 K after the 4K superblocks */
 		mddev->bitmap_info.default_offset = MD_SB_BYTES >> 9;
+		mddev->bitmap_info.default_space = 64*2 - (MD_SB_BYTES >> 9);
 		mddev->reshape_backwards = 0;
 
 		if (mddev->minor_version >= 91) {
@@ -1234,9 +1237,12 @@ static int super_90_validate(struct mddev *mddev, struct md_rdev *rdev)
 		mddev->max_disks = MD_SB_DISKS;
 
 		if (sb->state & (1<<MD_SB_BITMAP_PRESENT) &&
-		    mddev->bitmap_info.file == NULL)
+		    mddev->bitmap_info.file == NULL) {
 			mddev->bitmap_info.offset =
 				mddev->bitmap_info.default_offset;
+			mddev->bitmap_info.space =
+				mddev->bitmap_info.space;
+		}
 
 	} else if (mddev->pers == NULL) {
 		/* Insist on good event counter while assembling, except
@@ -1677,7 +1683,12 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 		mddev->dev_sectors = le64_to_cpu(sb->size);
 		mddev->events = ev1;
 		mddev->bitmap_info.offset = 0;
+		mddev->bitmap_info.space = 0;
+		/* Default location for bitmap is 1K after superblock
+		 * using 3K - total of 4K
+		 */
 		mddev->bitmap_info.default_offset = 1024 >> 9;
+		mddev->bitmap_info.default_space = (4096-1024) >> 9;
 		mddev->reshape_backwards = 0;
 
 		mddev->recovery_cp = le64_to_cpu(sb->resync_offset);
@@ -1686,9 +1697,23 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 		mddev->max_disks =  (4096-256)/2;
 
 		if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_BITMAP_OFFSET) &&
-		    mddev->bitmap_info.file == NULL )
+		    mddev->bitmap_info.file == NULL) {
 			mddev->bitmap_info.offset =
 				(__s32)le32_to_cpu(sb->bitmap_offset);
+			/* Metadata doesn't record how much space is available.
+			 * For 1.0, we assume we can use up to the superblock
+			 * if before, else to 4K beyond superblock.
+			 * For others, assume no change is possible.
+			 */
+			if (mddev->minor_version > 0)
+				mddev->bitmap_info.space = 0;
+			else if (mddev->bitmap_info.offset > 0)
+				mddev->bitmap_info.space =
+					8 - mddev->bitmap_info.offset;
+			else
+				mddev->bitmap_info.space =
+					-mddev->bitmap_info.offset;
+		}
 
 		if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_RESHAPE_ACTIVE)) {
 			mddev->reshape_position = le64_to_cpu(sb->reshape_position);
@@ -5280,6 +5305,7 @@ static void md_clean(struct mddev *mddev)
 	mddev->merge_check_needed = 0;
 	mddev->bitmap_info.offset = 0;
 	mddev->bitmap_info.default_offset = 0;
+	mddev->bitmap_info.default_space = 0;
 	mddev->bitmap_info.chunksize = 0;
 	mddev->bitmap_info.daemon_sleep = 0;
 	mddev->bitmap_info.max_write_behind = 0;
@@ -6076,6 +6102,7 @@ static int set_array_info(struct mddev * mddev, mdu_array_info_t *info)
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 
 	mddev->bitmap_info.default_offset = MD_SB_BYTES >> 9;
+	mddev->bitmap_info.default_space = 64*2 - (MD_SB_BYTES >> 9);
 	mddev->bitmap_info.offset = 0;
 
 	mddev->reshape_position = MaxSector;
@@ -6258,6 +6285,8 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 				return -EINVAL;
 			mddev->bitmap_info.offset =
 				mddev->bitmap_info.default_offset;
+			mddev->bitmap_info.space =
+				mddev->bitmap_info.default_space;
 			mddev->pers->quiesce(mddev, 1);
 			rv = bitmap_create(mddev);
 			if (!rv)
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 3609373..7b4a3c3 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -393,10 +393,13 @@ struct mddev {
 						 * For external metadata, offset
 						 * from start of device. 
 						 */
+		unsigned long		space; /* space available at this offset */
 		loff_t			default_offset; /* this is the offset to use when
 							 * hot-adding a bitmap.  It should
 							 * eventually be settable by sysfs.
 							 */
+		unsigned long		default_space; /* space available at
+							* default offset */
 		struct mutex		mutex;
 		unsigned long		chunksize;
 		unsigned long		daemon_sleep; /* how many jiffies between updates? */


