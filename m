From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 013 of 20] Count corrected read errors per drive.
Date: Mon, 12 Dec 2005 14:15:19 +1100
Message-ID: <1051212031519.5128@suse.de>
References: <20051212135705.4561.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Store this total in superblock (As appropriate),
and make it available to userspace via sysfs.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./Documentation/md.txt      |   11 +++++++++++
 ./drivers/md/md.c           |   27 ++++++++++++++++++++++++++-
 ./drivers/md/raid1.c        |    2 ++
 ./drivers/md/raid10.c       |   11 ++++++++---
 ./drivers/md/raid5.c        |    3 +++
 ./drivers/md/raid6main.c    |    3 +++
 ./include/linux/raid/md_k.h |    4 ++++
 7 files changed, 57 insertions(+), 4 deletions(-)

diff ./Documentation/md.txt~current~ ./Documentation/md.txt
--- ./Documentation/md.txt~current~	2005-12-12 11:33:35.000000000 +1100
+++ ./Documentation/md.txt	2005-12-12 11:34:21.000000000 +1100
@@ -222,6 +222,17 @@ Each directory contains:
 			 of being recoverred to
 	This list make grow in future.
 
+      errors
+        An approximate count of read errors that have been detected on
+        this device but have not caused the device to be evicted from
+        the array (either because they were corrected or because they
+	happened while the array was read-only).  When using version-1
+	metadata, this value persists across restarts of the array.
+
+	This value can be written while assembling an array thus
+	providing an ongoing count for arrays with metadata managed by
+	userspace.
+
 
 An active md device will also contain and entry for each active device
 in the array.  These are named

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-12-12 11:33:56.000000000 +1100
+++ ./drivers/md/md.c	2005-12-12 11:34:37.000000000 +1100
@@ -1000,6 +1000,7 @@ static int super_1_load(mdk_rdev_t *rdev
 	}
 	rdev->preferred_minor = 0xffff;
 	rdev->data_offset = le64_to_cpu(sb->data_offset);
+	atomic_set(&rdev->corrected_errors, le32_to_cpu(sb->cnt_corrected_read));
 
 	rdev->sb_size = le32_to_cpu(sb->max_dev) * 2 + 256;
 	bmask = queue_hardsect_size(rdev->bdev->bd_disk->queue)-1;
@@ -1139,6 +1140,8 @@ static void super_1_sync(mddev_t *mddev,
 	else
 		sb->resync_offset = cpu_to_le64(0);
 
+	sb->cnt_corrected_read = atomic_read(&rdev->corrected_errors);
+
 	if (mddev->bitmap && mddev->bitmap_file == NULL) {
 		sb->bitmap_offset = cpu_to_le32((__u32)mddev->bitmap_offset);
 		sb->feature_map = cpu_to_le32(MD_FEATURE_BITMAP_OFFSET);
@@ -1592,9 +1595,30 @@ super_show(mdk_rdev_t *rdev, char *page)
 }
 static struct rdev_sysfs_entry rdev_super = __ATTR_RO(super);
 
+static ssize_t
+errors_show(mdk_rdev_t *rdev, char *page)
+{
+	return sprintf(page, "%d\n", atomic_read(&rdev->corrected_errors));
+}
+
+static ssize_t
+errors_store(mdk_rdev_t *rdev, const char *buf, size_t len)
+{
+	char *e;
+	unsigned long n = simple_strtoul(buf, &e, 10);
+	if (*buf && (*e == 0 || *e == '\n')) {
+		atomic_set(&rdev->corrected_errors, n);
+		return len;
+	}
+	return -EINVAL;
+}
+static struct rdev_sysfs_entry rdev_errors =
+__ATTR(errors, 0644, errors_show, errors_store);
+
 static struct attribute *rdev_default_attrs[] = {
 	&rdev_state.attr,
 	&rdev_super.attr,
+	&rdev_errors.attr,
 	NULL,
 };
 static ssize_t
@@ -1674,6 +1698,7 @@ static mdk_rdev_t *md_import_device(dev_
 	rdev->data_offset = 0;
 	atomic_set(&rdev->nr_pending, 0);
 	atomic_set(&rdev->read_errors, 0);
+	atomic_set(&rdev->corrected_errors, 0);
 
 	size = rdev->bdev->bd_inode->i_size >> BLOCK_SIZE_BITS;
 	if (!size) {
@@ -4721,7 +4746,7 @@ static int set_ro(const char *val, struc
 	int num = simple_strtoul(val, &e, 10);
 	if (*val && (*e == '\0' || *e == '\n')) {
 		start_readonly = num;
-		return 0;;
+		return 0;
 	}
 	return -EINVAL;
 }

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-12-12 11:33:35.000000000 +1100
+++ ./drivers/md/raid1.c	2005-12-12 11:34:21.000000000 +1100
@@ -1265,6 +1265,7 @@ static void sync_request_write(mddev_t *
 					if (r1_bio->bios[d]->bi_end_io != end_sync_read)
 						continue;
 					rdev = conf->mirrors[d].rdev;
+					atomic_add(s, &rdev->corrected_errors);
 					if (sync_page_io(rdev->bdev,
 							 sect + rdev->data_offset,
 							 s<<9,
@@ -1463,6 +1464,7 @@ static void raid1d(mddev_t *mddev)
 							d = conf->raid_disks;
 						d--;
 						rdev = conf->mirrors[d].rdev;
+						atomic_add(s, &rdev->corrected_errors);
 						if (rdev &&
 						    test_bit(In_sync, &rdev->flags)) {
 							if (sync_page_io(rdev->bdev,

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2005-12-12 11:33:35.000000000 +1100
+++ ./drivers/md/raid10.c	2005-12-12 11:34:21.000000000 +1100
@@ -1122,9 +1122,13 @@ static int end_sync_read(struct bio *bio
 
 	if (test_bit(BIO_UPTODATE, &bio->bi_flags))
 		set_bit(R10BIO_Uptodate, &r10_bio->state);
-	else if (!test_bit(MD_RECOVERY_SYNC, &conf->mddev->recovery))
-		md_error(r10_bio->mddev,
-			 conf->mirrors[d].rdev);
+	else {
+		atomic_add(r10_bio->sectors,
+			   &conf->mirrors[d].rdev->corrected_errors);
+		if (!test_bit(MD_RECOVERY_SYNC, &conf->mddev->recovery))
+			md_error(r10_bio->mddev,
+				 conf->mirrors[d].rdev);
+	}
 
 	/* for reconstruct, we always reschedule after a read.
 	 * for resync, only after all reads
@@ -1430,6 +1434,7 @@ static void raid10d(mddev_t *mddev)
 						sl--;
 						d = r10_bio->devs[sl].devnum;
 						rdev = conf->mirrors[d].rdev;
+						atomic_add(s, &rdev->corrected_errors);
 						if (rdev &&
 						    test_bit(In_sync, &rdev->flags)) {
 							if (sync_page_io(rdev->bdev,

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-12-12 11:33:35.000000000 +1100
+++ ./drivers/md/raid5.c	2005-12-12 11:34:21.000000000 +1100
@@ -1400,6 +1400,9 @@ static void handle_stripe(struct stripe_
 			bi->bi_io_vec[0].bv_offset = 0;
 			bi->bi_size = STRIPE_SIZE;
 			bi->bi_next = NULL;
+			if (rw == WRITE &&
+			    test_bit(R5_ReWrite, &sh->dev[i].flags))
+				atomic_add(STRIPE_SECTORS, &rdev->corrected_errors);
 			generic_make_request(bi);
 		} else {
 			if (rw == 1)

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2005-12-12 11:33:35.000000000 +1100
+++ ./drivers/md/raid6main.c	2005-12-12 11:34:21.000000000 +1100
@@ -1562,6 +1562,9 @@ static void handle_stripe(struct stripe_
 			bi->bi_io_vec[0].bv_offset = 0;
 			bi->bi_size = STRIPE_SIZE;
 			bi->bi_next = NULL;
+			if (rw == WRITE &&
+			    test_bit(R5_ReWrite, &sh->dev[i].flags))
+				atomic_add(STRIPE_SECTORS, &rdev->corrected_errors);
 			generic_make_request(bi);
 		} else {
 			if (rw == 1)

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2005-12-12 11:33:35.000000000 +1100
+++ ./include/linux/raid/md_k.h	2005-12-12 11:34:21.000000000 +1100
@@ -95,6 +95,10 @@ struct mdk_rdev_s
 	atomic_t	read_errors;	/* number of consecutive read errors that
 					 * we have tried to ignore.
 					 */
+	atomic_t	corrected_errors; /* number of corrected read errors,
+					   * for reporting to userspace and storing
+					   * in superblock.
+					   */
 };
 
 struct mddev_s
