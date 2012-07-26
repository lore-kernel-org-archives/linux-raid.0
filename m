From: Shaohua Li <shli@kernel.org>
Subject: [RFC 1/2]raid1: only write mismatch sectors in sync
Date: Thu, 26 Jul 2012 16:01:50 +0800
Message-ID: <20120726080150.GA21457@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

Write has some impacts to SSD:
1. wear out flash. Frequent write can speed out the progress.
2. increase the burden of garbage collection of SSD firmware. If no space
left for write, SSD firmware garbage collection will try to free some space.
3. slow down subsequent write. After write SSD to some extents (for example,
write the whole disk), subsequent write will slow down significantly (because
almost every write invokes garbage collection in such case).

We want to avoid unnecessary write as more as possible. raid sync generally
involves a lot of unnecessary write. For example, even two disks don't have
any data, we write the second disk for the whole disk size.

To reduce write, we always compare raid disk data and only write mismatch part.
This means sync will have extra IO read and memory compare. So this scheme is
very bad for hard disk raid and sometimes SSD raid too if mismatch part is
majority. But sometimes this can be very helpful to reduce write, in that case,
since sync is rare operation, the extra IO/CPU usage is worthy paying. People
who want to use the feature should understand the risk first. So this ability
is off by default, a sysfs entry can be used to enable it.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/md.c    |   41 +++++++++++++++++++++++++++++++
 drivers/md/md.h    |    3 ++
 drivers/md/raid1.c |   70 +++++++++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 110 insertions(+), 4 deletions(-)

Index: linux/drivers/md/md.h
===================================================================
--- linux.orig/drivers/md/md.h	2012-07-25 13:51:00.353775521 +0800
+++ linux/drivers/md/md.h	2012-07-26 10:36:38.500740552 +0800
@@ -325,6 +325,9 @@ struct mddev {
 #define	MD_RECOVERY_FROZEN	9
 
 	unsigned long			recovery;
+#define MD_RECOVERY_MODE_REPAIR		0
+#define MD_RECOVERY_MODE_DISCARD	1
+	unsigned long			recovery_mode;
 	/* If a RAID personality determines that recovery (of a particular
 	 * device) will fail due to a read error on the source device, it
 	 * takes a copy of this number and does not attempt recovery again
Index: linux/drivers/md/raid1.c
===================================================================
--- linux.orig/drivers/md/raid1.c	2012-07-25 13:51:00.365775374 +0800
+++ linux/drivers/md/raid1.c	2012-07-26 10:34:10.658595244 +0800
@@ -102,7 +102,8 @@ static void * r1buf_pool_alloc(gfp_t gfp
 	 * If this is a user-requested check/repair, allocate
 	 * RESYNC_PAGES for each bio.
 	 */
-	if (test_bit(MD_RECOVERY_REQUESTED, &pi->mddev->recovery))
+	if (test_bit(MD_RECOVERY_REQUESTED, &pi->mddev->recovery) ||
+	    test_bit(MD_RECOVERY_MODE_REPAIR, &pi->mddev->recovery_mode))
 		j = pi->raid_disks;
 	else
 		j = 1;
@@ -118,7 +119,8 @@ static void * r1buf_pool_alloc(gfp_t gfp
 		}
 	}
 	/* If not user-requests, copy the page pointers to all bios */
-	if (!test_bit(MD_RECOVERY_REQUESTED, &pi->mddev->recovery)) {
+	if (!test_bit(MD_RECOVERY_REQUESTED, &pi->mddev->recovery) &&
+	    !test_bit(MD_RECOVERY_MODE_REPAIR, &pi->mddev->recovery_mode)) {
 		for (i=0; i<RESYNC_PAGES ; i++)
 			for (j=1; j<pi->raid_disks; j++)
 				r1_bio->bios[j]->bi_io_vec[i].bv_page =
@@ -1556,6 +1558,38 @@ static void end_sync_write(struct bio *b
 	}
 }
 
+static void end_repair_read(struct bio *bio, int error, int write)
+{
+	struct r1bio *r1_bio = bio->bi_private;
+	struct r1conf *conf;
+	int i;
+
+	/* process_checks() will re-setup the bio */
+	if (write)
+		bio->bi_end_io = end_sync_write;
+	else
+		bio->bi_end_io = end_sync_read;
+
+	conf = r1_bio->mddev->private;
+	for (i = 0; i < conf->raid_disks * 2; i++)
+		if (r1_bio->bios[i] == bio)
+			break;
+	update_head_pos(i, r1_bio);
+
+	if (atomic_dec_and_test(&r1_bio->remaining))
+		reschedule_retry(r1_bio);
+}
+
+static void end_repair_read_for_write(struct bio *bio, int error)
+{
+	end_repair_read(bio, error, 1);
+}
+
+static void end_repair_read_for_read(struct bio *bio, int error)
+{
+	end_repair_read(bio, error, 0);
+}
+
 static int r1_sync_page_io(struct md_rdev *rdev, sector_t sector,
 			    int sectors, struct page *page, int rw)
 {
@@ -1718,6 +1752,8 @@ static int process_checks(struct r1bio *
 			rdev_dec_pending(conf->mirrors[primary].rdev, mddev);
 			break;
 		}
+	if (!test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
+		primary = r1_bio->read_disk;
 	r1_bio->read_disk = primary;
 	vcnt = (r1_bio->sectors + PAGE_SIZE / 512 - 1) >> (PAGE_SHIFT - 9);
 	for (i = 0; i < conf->raid_disks * 2; i++) {
@@ -1726,7 +1762,9 @@ static int process_checks(struct r1bio *
 		struct bio *sbio = r1_bio->bios[i];
 		int size;
 
-		if (r1_bio->bios[i]->bi_end_io != end_sync_read)
+		if (sbio->bi_end_io != end_sync_read &&
+		    !(sbio->bi_end_io == end_sync_write &&
+		      test_bit(MD_RECOVERY_MODE_REPAIR, &mddev->recovery_mode)))
 			continue;
 
 		if (test_bit(BIO_UPTODATE, &sbio->bi_flags)) {
@@ -1761,6 +1799,7 @@ static int process_checks(struct r1bio *
 		sbio->bi_sector = r1_bio->sector +
 			conf->mirrors[i].rdev->data_offset;
 		sbio->bi_bdev = conf->mirrors[i].rdev->bdev;
+
 		size = sbio->bi_size;
 		for (j = 0; j < vcnt ; j++) {
 			struct bio_vec *bi;
@@ -1793,7 +1832,8 @@ static void sync_request_write(struct md
 		if (!fix_sync_read_error(r1_bio))
 			return;
 
-	if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
+	if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) ||
+	    test_bit(MD_RECOVERY_MODE_REPAIR, &mddev->recovery_mode))
 		if (process_checks(r1_bio) < 0)
 			return;
 	/*
@@ -2491,6 +2531,28 @@ static sector_t sync_request(struct mdde
 				md_sync_acct(bio->bi_bdev, nr_sectors);
 				generic_make_request(bio);
 			}
+		}
+	} else if (test_bit(MD_RECOVERY_MODE_REPAIR, &mddev->recovery_mode)) {
+		atomic_set(&r1_bio->remaining, write_targets + 1);
+		for (i = 0; i < conf->raid_disks * 2; i++) {
+			int do_io = 0;
+
+			bio = r1_bio->bios[i];
+			if (bio->bi_end_io == end_sync_write) {
+				bio->bi_rw = READ;
+				bio->bi_end_io = end_repair_read_for_write;
+				do_io = 1;
+			}
+			if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) &&
+			    bio->bi_end_io == end_sync_read &&
+			    i != r1_bio->read_disk) {
+				bio->bi_end_io = end_repair_read_for_read;
+				do_io = 1;
+			}
+			if (i == r1_bio->read_disk || do_io) {
+				md_sync_acct(bio->bi_bdev, nr_sectors);
+				generic_make_request(bio);
+			}
 		}
 	} else {
 		atomic_set(&r1_bio->remaining, 1);
Index: linux/drivers/md/md.c
===================================================================
--- linux.orig/drivers/md/md.c	2012-07-25 13:51:00.345775613 +0800
+++ linux/drivers/md/md.c	2012-07-26 10:12:13.123162321 +0800
@@ -4330,9 +4330,49 @@ mismatch_cnt_show(struct mddev *mddev, c
 		       (unsigned long long) mddev->resync_mismatches);
 }
 
+static ssize_t
+recovery_mode_show(struct mddev *mddev, char *page)
+{
+	char *type = "default";
+	if (test_bit(MD_RECOVERY_MODE_REPAIR, &mddev->recovery_mode)) {
+		type = "repair";
+		if (test_bit(MD_RECOVERY_MODE_DISCARD, &mddev->recovery_mode))
+			type = "discard";
+	}
+	return sprintf(page, "%s\n", type);
+}
+
+static ssize_t
+recovery_mode_store(struct mddev *mddev, const char *page, size_t len)
+{
+	if (!mddev->pers || !mddev->pers->sync_request)
+		return -EINVAL;
+
+	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
+		    !test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))
+		return -EBUSY;
+
+	if (cmd_match(page, "discard")) {
+		set_bit(MD_RECOVERY_MODE_REPAIR, &mddev->recovery_mode);
+		set_bit(MD_RECOVERY_MODE_DISCARD, &mddev->recovery_mode);
+	} else {
+		clear_bit(MD_RECOVERY_MODE_DISCARD, &mddev->recovery_mode);
+		if (cmd_match(page, "repair"))
+			set_bit(MD_RECOVERY_MODE_REPAIR, &mddev->recovery_mode);
+		else {
+			clear_bit(MD_RECOVERY_MODE_REPAIR, &mddev->recovery_mode);
+			if (!cmd_match(page, "default"))
+				return -EINVAL;
+		}
+	}
+	return len;
+}
+
 static struct md_sysfs_entry md_scan_mode =
 __ATTR(sync_action, S_IRUGO|S_IWUSR, action_show, action_store);
 
+static struct md_sysfs_entry md_recovery_mode =
+__ATTR(recovery_mode, S_IRUGO|S_IWUSR, recovery_mode_show, recovery_mode_store);
 
 static struct md_sysfs_entry md_mismatches = __ATTR_RO(mismatch_cnt);
 
@@ -4732,6 +4772,7 @@ static struct attribute *md_default_attr
 
 static struct attribute *md_redundancy_attrs[] = {
 	&md_scan_mode.attr,
+	&md_recovery_mode.attr,
 	&md_mismatches.attr,
 	&md_sync_min.attr,
 	&md_sync_max.attr,
