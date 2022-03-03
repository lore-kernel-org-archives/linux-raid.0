Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 779E5C433EF
	for <linux-raid@archiver.kernel.org>; Thu,  3 Mar 2022 11:04:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbiCCLFh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Mar 2022 06:05:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbiCCLFg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Mar 2022 06:05:36 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C8415DDDC
        for <linux-raid@vger.kernel.org>; Thu,  3 Mar 2022 03:04:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=tkb/uHCeQ8PlKQTt6zz3kJNTCS93uMSBkCmdaif1f0c=; b=Lut5kFsr69P41gy4OGkMdEgW5S
        LLMtLZsHLeCkE//62V6pk5imvDS7id3L0MIv+US/GyZPUVM2LpcmnZ4neMDyr+oH4YToJJ2KYBAK/
        qmqcCkqXTgM6KUjeTUobS5D3BlsfqGTOXI5Kw4HG+3S6jA3eoCbAJ6delmHUG/QhRv4CFmZgqYlXI
        OvXfAa8T7o9AengI7gA65DzLdR4cDAeoV7k/PdLeVMpKnBtZfcV3mUp0xT9ROPin+dTK9OSNrrPUM
        rqb3oQ2FogP5MN/GuCdVYAyFLFhAhCDDXjzeVop704v0EBVaK0uPXO6PAK5aijNln58lzN7djD1zD
        +Qp1t2BQ==;
Received: from [91.93.38.115] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nPjGK-0069ou-Gg; Thu, 03 Mar 2022 11:04:49 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH] md: remove most calls to bdevname
Date:   Thu,  3 Mar 2022 14:04:44 +0300
Message-Id: <20220303110444.320428-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Use the %pg format specifier to save on stack consuption and code size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md-linear.c    |   5 +-
 drivers/md/md-multipath.c |  15 ++--
 drivers/md/md.c           | 152 ++++++++++++++++----------------------
 drivers/md/raid0.c        |  28 +++----
 drivers/md/raid1.c        |  24 +++---
 drivers/md/raid10.c       |  54 ++++++--------
 drivers/md/raid5-cache.c  |   5 +-
 drivers/md/raid5-ppl.c    |  27 +++----
 drivers/md/raid5.c        |  37 ++++------
 9 files changed, 147 insertions(+), 200 deletions(-)

diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index 1ff51647a6822..40bdc6aecd0b2 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -215,7 +215,6 @@ static void linear_free(struct mddev *mddev, void *priv)
 
 static bool linear_make_request(struct mddev *mddev, struct bio *bio)
 {
-	char b[BDEVNAME_SIZE];
 	struct dev_info *tmp_dev;
 	sector_t start_sector, end_sector, data_offset;
 	sector_t bio_sector = bio->bi_iter.bi_sector;
@@ -266,10 +265,10 @@ static bool linear_make_request(struct mddev *mddev, struct bio *bio)
 	return true;
 
 out_of_bounds:
-	pr_err("md/linear:%s: make_request: Sector %llu out of bounds on dev %s: %llu sectors, offset %llu\n",
+	pr_err("md/linear:%s: make_request: Sector %llu out of bounds on dev %pg: %llu sectors, offset %llu\n",
 	       mdname(mddev),
 	       (unsigned long long)bio->bi_iter.bi_sector,
-	       bdevname(tmp_dev->rdev->bdev, b),
+	       tmp_dev->rdev->bdev,
 	       (unsigned long long)tmp_dev->rdev->sectors,
 	       (unsigned long long)start_sector);
 	bio_io_error(bio);
diff --git a/drivers/md/md-multipath.c b/drivers/md/md-multipath.c
index 97fb948e3e741..c056a7d707b09 100644
--- a/drivers/md/md-multipath.c
+++ b/drivers/md/md-multipath.c
@@ -87,10 +87,9 @@ static void multipath_end_request(struct bio *bio)
 		/*
 		 * oops, IO error:
 		 */
-		char b[BDEVNAME_SIZE];
 		md_error (mp_bh->mddev, rdev);
-		pr_info("multipath: %s: rescheduling sector %llu\n",
-			bdevname(rdev->bdev,b),
+		pr_info("multipath: %pg: rescheduling sector %llu\n",
+			rdev->bdev,
 			(unsigned long long)bio->bi_iter.bi_sector);
 		multipath_reschedule_retry(mp_bh);
 	} else
@@ -155,7 +154,6 @@ static void multipath_status(struct seq_file *seq, struct mddev *mddev)
 static void multipath_error (struct mddev *mddev, struct md_rdev *rdev)
 {
 	struct mpconf *conf = mddev->private;
-	char b[BDEVNAME_SIZE];
 
 	if (conf->raid_disks - mddev->degraded <= 1) {
 		/*
@@ -178,9 +176,9 @@ static void multipath_error (struct mddev *mddev, struct md_rdev *rdev)
 	}
 	set_bit(Faulty, &rdev->flags);
 	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
-	pr_err("multipath: IO failure on %s, disabling IO path.\n"
+	pr_err("multipath: IO failure on %pg, disabling IO path.\n"
 	       "multipath: Operation continuing on %d IO paths.\n",
-	       bdevname(rdev->bdev, b),
+	       rdev->bdev,
 	       conf->raid_disks - mddev->degraded);
 }
 
@@ -198,12 +196,11 @@ static void print_multipath_conf (struct mpconf *conf)
 		 conf->raid_disks);
 
 	for (i = 0; i < conf->raid_disks; i++) {
-		char b[BDEVNAME_SIZE];
 		tmp = conf->multipaths + i;
 		if (tmp->rdev)
-			pr_debug(" disk%d, o:%d, dev:%s\n",
+			pr_debug(" disk%d, o:%d, dev:%pg\n",
 				 i,!test_bit(Faulty, &tmp->rdev->flags),
-				 bdevname(tmp->rdev->bdev,b));
+				 tmp->rdev->bdev);
 	}
 }
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index f88a9e948f3eb..29746426b2a1f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1021,8 +1021,6 @@ EXPORT_SYMBOL_GPL(sync_page_io);
 
 static int read_disk_sb(struct md_rdev *rdev, int size)
 {
-	char b[BDEVNAME_SIZE];
-
 	if (rdev->sb_loaded)
 		return 0;
 
@@ -1032,8 +1030,8 @@ static int read_disk_sb(struct md_rdev *rdev, int size)
 	return 0;
 
 fail:
-	pr_err("md: disabled device %s, could not read superblock.\n",
-	       bdevname(rdev->bdev,b));
+	pr_err("md: disabled device %pg, could not read superblock.\n",
+	       rdev->bdev);
 	return -EINVAL;
 }
 
@@ -1179,7 +1177,6 @@ EXPORT_SYMBOL(md_check_no_bitmap);
  */
 static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_version)
 {
-	char b[BDEVNAME_SIZE], b2[BDEVNAME_SIZE];
 	mdp_super_t *sb;
 	int ret;
 	bool spare_disk = true;
@@ -1198,19 +1195,19 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 
 	ret = -EINVAL;
 
-	bdevname(rdev->bdev, b);
 	sb = page_address(rdev->sb_page);
 
 	if (sb->md_magic != MD_SB_MAGIC) {
-		pr_warn("md: invalid raid superblock magic on %s\n", b);
+		pr_warn("md: invalid raid superblock magic on %pg\n",
+			rdev->bdev);
 		goto abort;
 	}
 
 	if (sb->major_version != 0 ||
 	    sb->minor_version < 90 ||
 	    sb->minor_version > 91) {
-		pr_warn("Bad version number %d.%d on %s\n",
-			sb->major_version, sb->minor_version, b);
+		pr_warn("Bad version number %d.%d on %pg\n",
+			sb->major_version, sb->minor_version, rdev->bdev);
 		goto abort;
 	}
 
@@ -1218,7 +1215,7 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 		goto abort;
 
 	if (md_csum_fold(calc_sb_csum(sb)) != md_csum_fold(sb->sb_csum)) {
-		pr_warn("md: invalid superblock checksum on %s\n", b);
+		pr_warn("md: invalid superblock checksum on %pg\n", rdev->bdev);
 		goto abort;
 	}
 
@@ -1250,13 +1247,13 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 		__u64 ev1, ev2;
 		mdp_super_t *refsb = page_address(refdev->sb_page);
 		if (!md_uuid_equal(refsb, sb)) {
-			pr_warn("md: %s has different UUID to %s\n",
-				b, bdevname(refdev->bdev,b2));
+			pr_warn("md: %pg has different UUID to %pg\n",
+				rdev->bdev, refdev->bdev);
 			goto abort;
 		}
 		if (!md_sb_equal(refsb, sb)) {
-			pr_warn("md: %s has same UUID but different superblock to %s\n",
-				b, bdevname(refdev->bdev, b2));
+			pr_warn("md: %pg has same UUID but different superblock to %pg\n",
+				rdev->bdev, refdev->bdev);
 			goto abort;
 		}
 		ev1 = md_event(sb);
@@ -1620,7 +1617,6 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 	int ret;
 	sector_t sb_start;
 	sector_t sectors;
-	char b[BDEVNAME_SIZE], b2[BDEVNAME_SIZE];
 	int bmask;
 	bool spare_disk = true;
 
@@ -1664,13 +1660,13 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 		return -EINVAL;
 
 	if (calc_sb_1_csum(sb) != sb->sb_csum) {
-		pr_warn("md: invalid superblock checksum on %s\n",
-			bdevname(rdev->bdev,b));
+		pr_warn("md: invalid superblock checksum on %pg\n",
+			rdev->bdev);
 		return -EINVAL;
 	}
 	if (le64_to_cpu(sb->data_size) < 10) {
-		pr_warn("md: data_size too small on %s\n",
-			bdevname(rdev->bdev,b));
+		pr_warn("md: data_size too small on %pg\n",
+			rdev->bdev);
 		return -EINVAL;
 	}
 	if (sb->pad0 ||
@@ -1776,9 +1772,9 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 		    sb->level != refsb->level ||
 		    sb->layout != refsb->layout ||
 		    sb->chunksize != refsb->chunksize) {
-			pr_warn("md: %s has strangely different superblock to %s\n",
-				bdevname(rdev->bdev,b),
-				bdevname(refdev->bdev,b2));
+			pr_warn("md: %pg has strangely different superblock to %pg\n",
+				rdev->bdev,
+				refdev->bdev);
 			return -EINVAL;
 		}
 		ev1 = le64_to_cpu(sb->events);
@@ -2365,7 +2361,6 @@ EXPORT_SYMBOL(md_integrity_register);
 int md_integrity_add_rdev(struct md_rdev *rdev, struct mddev *mddev)
 {
 	struct blk_integrity *bi_mddev;
-	char name[BDEVNAME_SIZE];
 
 	if (!mddev->gendisk)
 		return 0;
@@ -2376,8 +2371,8 @@ int md_integrity_add_rdev(struct md_rdev *rdev, struct mddev *mddev)
 		return 0;
 
 	if (blk_integrity_compare(mddev->gendisk, rdev->bdev->bd_disk) != 0) {
-		pr_err("%s: incompatible integrity profile for %s\n",
-		       mdname(mddev), bdevname(rdev->bdev, name));
+		pr_err("%s: incompatible integrity profile for %pg\n",
+		       mdname(mddev), rdev->bdev);
 		return -ENXIO;
 	}
 
@@ -2486,11 +2481,9 @@ static void rdev_delayed_delete(struct work_struct *ws)
 
 static void unbind_rdev_from_array(struct md_rdev *rdev)
 {
-	char b[BDEVNAME_SIZE];
-
 	bd_unlink_disk_holder(rdev->bdev, rdev->mddev->gendisk);
 	list_del_rcu(&rdev->same_set);
-	pr_debug("md: unbind<%s>\n", bdevname(rdev->bdev,b));
+	pr_debug("md: unbind<%pg>\n", rdev->bdev);
 	mddev_destroy_serial_pool(rdev->mddev, rdev, false);
 	rdev->mddev = NULL;
 	sysfs_remove_link(&rdev->kobj, "block");
@@ -2543,9 +2536,7 @@ void md_autodetect_dev(dev_t dev);
 
 static void export_rdev(struct md_rdev *rdev)
 {
-	char b[BDEVNAME_SIZE];
-
-	pr_debug("md: export_rdev(%s)\n", bdevname(rdev->bdev,b));
+	pr_debug("md: export_rdev(%pg)\n", rdev->bdev);
 	md_rdev_clear(rdev);
 #ifndef MODULE
 	if (test_bit(AutoDetected, &rdev->flags))
@@ -2801,8 +2792,6 @@ void md_update_sb(struct mddev *mddev, int force_change)
 rewrite:
 	md_bitmap_update_sb(mddev->bitmap);
 	rdev_for_each(rdev, mddev) {
-		char b[BDEVNAME_SIZE];
-
 		if (rdev->sb_loaded != 1)
 			continue; /* no noise on spare devices */
 
@@ -2810,8 +2799,8 @@ void md_update_sb(struct mddev *mddev, int force_change)
 			md_super_write(mddev,rdev,
 				       rdev->sb_start, rdev->sb_size,
 				       rdev->sb_page);
-			pr_debug("md: (write) %s's sb offset: %llu\n",
-				 bdevname(rdev->bdev, b),
+			pr_debug("md: (write) %pg's sb offset: %llu\n",
+				 rdev->bdev,
 				 (unsigned long long)rdev->sb_start);
 			rdev->sb_events = mddev->events;
 			if (rdev->badblocks.size) {
@@ -2823,8 +2812,8 @@ void md_update_sb(struct mddev *mddev, int force_change)
 			}
 
 		} else
-			pr_debug("md: %s (skipping faulty)\n",
-				 bdevname(rdev->bdev, b));
+			pr_debug("md: %pg (skipping faulty)\n",
+				 rdev->bdev);
 
 		if (mddev->level == LEVEL_MULTIPATH)
 			/* only need to write one superblock... */
@@ -3698,7 +3687,6 @@ EXPORT_SYMBOL_GPL(md_rdev_init);
  */
 static struct md_rdev *md_import_device(dev_t newdev, int super_format, int super_minor)
 {
-	char b[BDEVNAME_SIZE];
 	int err;
 	struct md_rdev *rdev;
 	sector_t size;
@@ -3722,8 +3710,8 @@ static struct md_rdev *md_import_device(dev_t newdev, int super_format, int supe
 
 	size = bdev_nr_bytes(rdev->bdev) >> BLOCK_SIZE_BITS;
 	if (!size) {
-		pr_warn("md: %s has zero or unknown size, marking faulty!\n",
-			bdevname(rdev->bdev,b));
+		pr_warn("md: %pg has zero or unknown size, marking faulty!\n",
+			rdev->bdev);
 		err = -EINVAL;
 		goto abort_free;
 	}
@@ -3732,14 +3720,14 @@ static struct md_rdev *md_import_device(dev_t newdev, int super_format, int supe
 		err = super_types[super_format].
 			load_super(rdev, NULL, super_minor);
 		if (err == -EINVAL) {
-			pr_warn("md: %s does not have a valid v%d.%d superblock, not importing!\n",
-				bdevname(rdev->bdev,b),
+			pr_warn("md: %pg does not have a valid v%d.%d superblock, not importing!\n",
+				rdev->bdev,
 				super_format, super_minor);
 			goto abort_free;
 		}
 		if (err < 0) {
-			pr_warn("md: could not read %s's sb, not importing!\n",
-				bdevname(rdev->bdev,b));
+			pr_warn("md: could not read %pg's sb, not importing!\n",
+				rdev->bdev);
 			goto abort_free;
 		}
 	}
@@ -3762,7 +3750,6 @@ static int analyze_sbs(struct mddev *mddev)
 {
 	int i;
 	struct md_rdev *rdev, *freshest, *tmp;
-	char b[BDEVNAME_SIZE];
 
 	freshest = NULL;
 	rdev_for_each_safe(rdev, tmp, mddev)
@@ -3774,8 +3761,8 @@ static int analyze_sbs(struct mddev *mddev)
 		case 0:
 			break;
 		default:
-			pr_warn("md: fatal superblock inconsistency in %s -- removing from array\n",
-				bdevname(rdev->bdev,b));
+			pr_warn("md: fatal superblock inconsistency in %pg -- removing from array\n",
+				rdev->bdev);
 			md_kick_rdev_from_array(rdev);
 		}
 
@@ -3793,8 +3780,8 @@ static int analyze_sbs(struct mddev *mddev)
 		if (mddev->max_disks &&
 		    (rdev->desc_nr >= mddev->max_disks ||
 		     i > mddev->max_disks)) {
-			pr_warn("md: %s: %s: only %d devices permitted\n",
-				mdname(mddev), bdevname(rdev->bdev, b),
+			pr_warn("md: %s: %pg: only %d devices permitted\n",
+				mdname(mddev), rdev->bdev,
 				mddev->max_disks);
 			md_kick_rdev_from_array(rdev);
 			continue;
@@ -3802,8 +3789,8 @@ static int analyze_sbs(struct mddev *mddev)
 		if (rdev != freshest) {
 			if (super_types[mddev->major_version].
 			    validate_super(mddev, rdev)) {
-				pr_warn("md: kicking non-fresh %s from array!\n",
-					bdevname(rdev->bdev,b));
+				pr_warn("md: kicking non-fresh %pg from array!\n",
+					rdev->bdev);
 				md_kick_rdev_from_array(rdev);
 				continue;
 			}
@@ -5914,7 +5901,6 @@ int md_run(struct mddev *mddev)
 		/* Warn if this is a potentially silly
 		 * configuration.
 		 */
-		char b[BDEVNAME_SIZE], b2[BDEVNAME_SIZE];
 		struct md_rdev *rdev2;
 		int warned = 0;
 
@@ -5923,10 +5909,10 @@ int md_run(struct mddev *mddev)
 				if (rdev < rdev2 &&
 				    rdev->bdev->bd_disk ==
 				    rdev2->bdev->bd_disk) {
-					pr_warn("%s: WARNING: %s appears to be on the same physical disk as %s.\n",
+					pr_warn("%s: WARNING: %pg appears to be on the same physical disk as %pg.\n",
 						mdname(mddev),
-						bdevname(rdev->bdev,b),
-						bdevname(rdev2->bdev,b2));
+						rdev->bdev,
+						rdev2->bdev);
 					warned = 1;
 				}
 			}
@@ -6451,8 +6437,7 @@ static void autorun_array(struct mddev *mddev)
 	pr_info("md: running: ");
 
 	rdev_for_each(rdev, mddev) {
-		char b[BDEVNAME_SIZE];
-		pr_cont("<%s>", bdevname(rdev->bdev,b));
+		pr_cont("<%pg>", rdev->bdev);
 	}
 	pr_cont("\n");
 
@@ -6479,7 +6464,6 @@ static void autorun_devices(int part)
 {
 	struct md_rdev *rdev0, *rdev, *tmp;
 	struct mddev *mddev;
-	char b[BDEVNAME_SIZE];
 
 	pr_info("md: autorun ...\n");
 	while (!list_empty(&pending_raid_disks)) {
@@ -6489,12 +6473,12 @@ static void autorun_devices(int part)
 		rdev0 = list_entry(pending_raid_disks.next,
 					 struct md_rdev, same_set);
 
-		pr_debug("md: considering %s ...\n", bdevname(rdev0->bdev,b));
+		pr_debug("md: considering %pg ...\n", rdev0->bdev);
 		INIT_LIST_HEAD(&candidates);
 		rdev_for_each_list(rdev, tmp, &pending_raid_disks)
 			if (super_90_load(rdev, rdev0, 0) >= 0) {
-				pr_debug("md:  adding %s ...\n",
-					 bdevname(rdev->bdev,b));
+				pr_debug("md:  adding %pg ...\n",
+					 rdev->bdev);
 				list_move(&rdev->same_set, &candidates);
 			}
 		/*
@@ -6511,8 +6495,8 @@ static void autorun_devices(int part)
 			unit = MINOR(dev);
 		}
 		if (rdev0->preferred_minor != unit) {
-			pr_warn("md: unit number in %s is bad: %d\n",
-				bdevname(rdev0->bdev, b), rdev0->preferred_minor);
+			pr_warn("md: unit number in %pg is bad: %d\n",
+				rdev0->bdev, rdev0->preferred_minor);
 			break;
 		}
 
@@ -6525,8 +6509,8 @@ static void autorun_devices(int part)
 			pr_warn("md: %s locked, cannot run\n", mdname(mddev));
 		else if (mddev->raid_disks || mddev->major_version
 			 || !list_empty(&mddev->disks)) {
-			pr_warn("md: %s already running, cannot run %s\n",
-				mdname(mddev), bdevname(rdev0->bdev,b));
+			pr_warn("md: %s already running, cannot run %pg\n",
+				mdname(mddev), rdev0->bdev);
 			mddev_unlock(mddev);
 		} else {
 			pr_debug("md: created %s\n", mdname(mddev));
@@ -6700,7 +6684,6 @@ static int get_disk_info(struct mddev *mddev, void __user * arg)
 
 int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
 {
-	char b[BDEVNAME_SIZE], b2[BDEVNAME_SIZE];
 	struct md_rdev *rdev;
 	dev_t dev = MKDEV(info->major,info->minor);
 
@@ -6730,9 +6713,9 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
 			err = super_types[mddev->major_version]
 				.load_super(rdev, rdev0, mddev->minor_version);
 			if (err < 0) {
-				pr_warn("md: %s has different UUID to %s\n",
-					bdevname(rdev->bdev,b),
-					bdevname(rdev0->bdev,b2));
+				pr_warn("md: %pg has different UUID to %pg\n",
+					rdev->bdev,
+					rdev0->bdev);
 				export_rdev(rdev);
 				return -EINVAL;
 			}
@@ -6907,7 +6890,6 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
 
 static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 {
-	char b[BDEVNAME_SIZE];
 	struct md_rdev *rdev;
 
 	if (!mddev->pers)
@@ -6942,14 +6924,13 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 
 	return 0;
 busy:
-	pr_debug("md: cannot remove active disk %s from %s ...\n",
-		 bdevname(rdev->bdev,b), mdname(mddev));
+	pr_debug("md: cannot remove active disk %pg from %s ...\n",
+		 rdev->bdev, mdname(mddev));
 	return -EBUSY;
 }
 
 static int hot_add_disk(struct mddev *mddev, dev_t dev)
 {
-	char b[BDEVNAME_SIZE];
 	int err;
 	struct md_rdev *rdev;
 
@@ -6982,8 +6963,8 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
 	rdev->sectors = rdev->sb_start;
 
 	if (test_bit(Faulty, &rdev->flags)) {
-		pr_warn("md: can not hot-add faulty %s disk to %s!\n",
-			bdevname(rdev->bdev,b), mdname(mddev));
+		pr_warn("md: can not hot-add faulty %pg disk to %s!\n",
+			rdev->bdev, mdname(mddev));
 		err = -EINVAL;
 		goto abort_export;
 	}
@@ -7010,8 +6991,8 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
 	 * disable on the whole MD.
 	 */
 	if (!blk_queue_nowait(bdev_get_queue(rdev->bdev))) {
-		pr_info("%s: Disabling nowait because %s does not support nowait\n",
-			mdname(mddev), bdevname(rdev->bdev, b));
+		pr_info("%s: Disabling nowait because %pg does not support nowait\n",
+			mdname(mddev), rdev->bdev);
 		blk_queue_flag_clear(QUEUE_FLAG_NOWAIT, mddev->queue);
 	}
 	/*
@@ -8008,10 +7989,8 @@ static void status_unused(struct seq_file *seq)
 	seq_printf(seq, "unused devices: ");
 
 	list_for_each_entry(rdev, &pending_raid_disks, same_set) {
-		char b[BDEVNAME_SIZE];
 		i++;
-		seq_printf(seq, "%s ",
-			      bdevname(rdev->bdev,b));
+		seq_printf(seq, "%pg ", rdev->bdev);
 	}
 	if (!i)
 		seq_printf(seq, "<none>");
@@ -8251,9 +8230,8 @@ static int md_seq_show(struct seq_file *seq, void *v)
 		sectors = 0;
 		rcu_read_lock();
 		rdev_for_each_rcu(rdev, mddev) {
-			char b[BDEVNAME_SIZE];
-			seq_printf(seq, " %s[%d]",
-				bdevname(rdev->bdev,b), rdev->desc_nr);
+			seq_printf(seq, " %pg[%d]", rdev->bdev, rdev->desc_nr);
+
 			if (test_bit(WriteMostly, &rdev->flags))
 				seq_printf(seq, "(W)");
 			if (test_bit(Journal, &rdev->flags))
@@ -9648,7 +9626,6 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 	struct mdp_superblock_1 *sb = page_address(rdev->sb_page);
 	struct md_rdev *rdev2, *tmp;
 	int role, ret;
-	char b[BDEVNAME_SIZE];
 
 	/*
 	 * If size is changed in another node then we need to
@@ -9672,7 +9649,8 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 
 		if (test_bit(Candidate, &rdev2->flags)) {
 			if (role == 0xfffe) {
-				pr_info("md: Removing Candidate device %s because add failed\n", bdevname(rdev2->bdev,b));
+				pr_info("md: Removing Candidate device %pg because add failed\n",
+					rdev2->bdev);
 				md_kick_rdev_from_array(rdev2);
 				continue;
 			}
@@ -9689,8 +9667,8 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 			      MD_FEATURE_RESHAPE_ACTIVE)) {
 				rdev2->saved_raid_disk = role;
 				ret = remove_and_add_spares(mddev, rdev2);
-				pr_info("Activated spare: %s\n",
-					bdevname(rdev2->bdev,b));
+				pr_info("Activated spare: %pg\n",
+					rdev2->bdev);
 				/* wakeup mddev->thread here, so array could
 				 * perform resync with the new activated disk */
 				set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index b59a77b31b90d..d864a022dc7ff 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -37,7 +37,6 @@ static void dump_zones(struct mddev *mddev)
 	int j, k;
 	sector_t zone_size = 0;
 	sector_t zone_start = 0;
-	char b[BDEVNAME_SIZE];
 	struct r0conf *conf = mddev->private;
 	int raid_disks = conf->strip_zone[0].nb_dev;
 	pr_debug("md: RAID0 configuration for %s - %d zone%s\n",
@@ -48,9 +47,8 @@ static void dump_zones(struct mddev *mddev)
 		int len = 0;
 
 		for (k = 0; k < conf->strip_zone[j].nb_dev; k++)
-			len += snprintf(line+len, 200-len, "%s%s", k?"/":"",
-					bdevname(conf->devlist[j*raid_disks
-							       + k]->bdev, b));
+			len += snprintf(line+len, 200-len, "%s%pg", k?"/":"",
+				conf->devlist[j * raid_disks + k]->bdev);
 		pr_debug("md: zone%d=[%s]\n", j, line);
 
 		zone_size  = conf->strip_zone[j].zone_end - zone_start;
@@ -69,8 +67,6 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	struct md_rdev *smallest, *rdev1, *rdev2, *rdev, **dev;
 	struct strip_zone *zone;
 	int cnt;
-	char b[BDEVNAME_SIZE];
-	char b2[BDEVNAME_SIZE];
 	struct r0conf *conf = kzalloc(sizeof(*conf), GFP_KERNEL);
 	unsigned blksize = 512;
 
@@ -78,9 +74,9 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	if (!conf)
 		return -ENOMEM;
 	rdev_for_each(rdev1, mddev) {
-		pr_debug("md/raid0:%s: looking at %s\n",
+		pr_debug("md/raid0:%s: looking at %pg\n",
 			 mdname(mddev),
-			 bdevname(rdev1->bdev, b));
+			 rdev1->bdev);
 		c = 0;
 
 		/* round size to chunk_size */
@@ -92,12 +88,12 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 				      rdev1->bdev->bd_disk->queue));
 
 		rdev_for_each(rdev2, mddev) {
-			pr_debug("md/raid0:%s:   comparing %s(%llu)"
-				 " with %s(%llu)\n",
+			pr_debug("md/raid0:%s:   comparing %pg(%llu)"
+				 " with %pg(%llu)\n",
 				 mdname(mddev),
-				 bdevname(rdev1->bdev,b),
+				 rdev1->bdev,
 				 (unsigned long long)rdev1->sectors,
-				 bdevname(rdev2->bdev,b2),
+				 rdev2->bdev,
 				 (unsigned long long)rdev2->sectors);
 			if (rdev2 == rdev1) {
 				pr_debug("md/raid0:%s:   END\n",
@@ -240,15 +236,15 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 		for (j=0; j<cnt; j++) {
 			rdev = conf->devlist[j];
 			if (rdev->sectors <= zone->dev_start) {
-				pr_debug("md/raid0:%s: checking %s ... nope\n",
+				pr_debug("md/raid0:%s: checking %pg ... nope\n",
 					 mdname(mddev),
-					 bdevname(rdev->bdev, b));
+					 rdev->bdev);
 				continue;
 			}
-			pr_debug("md/raid0:%s: checking %s ..."
+			pr_debug("md/raid0:%s: checking %pg ..."
 				 " contained as device %d\n",
 				 mdname(mddev),
-				 bdevname(rdev->bdev, b), c);
+				 rdev->bdev, c);
 			dev[c] = rdev;
 			c++;
 			if (!smallest || rdev->sectors < smallest->sectors) {
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index c3288d46948de..c180c188da574 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -398,10 +398,9 @@ static void raid1_end_read_request(struct bio *bio)
 		/*
 		 * oops, read error:
 		 */
-		char b[BDEVNAME_SIZE];
-		pr_err_ratelimited("md/raid1:%s: %s: rescheduling sector %llu\n",
+		pr_err_ratelimited("md/raid1:%s: %pg: rescheduling sector %llu\n",
 				   mdname(conf->mddev),
-				   bdevname(rdev->bdev, b),
+				   rdev->bdev,
 				   (unsigned long long)r1_bio->sector);
 		set_bit(R1BIO_ReadError, &r1_bio->state);
 		reschedule_retry(r1_bio);
@@ -1289,10 +1288,10 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	mirror = conf->mirrors + rdisk;
 
 	if (r1bio_existed)
-		pr_info_ratelimited("md/raid1:%s: redirecting sector %llu to other mirror: %s\n",
+		pr_info_ratelimited("md/raid1:%s: redirecting sector %llu to other mirror: %pg\n",
 				    mdname(mddev),
 				    (unsigned long long)r1_bio->sector,
-				    bdevname(mirror->rdev->bdev, b));
+				    mirror->rdev->bdev);
 
 	if (test_bit(WriteMostly, &mirror->rdev->flags) &&
 	    bitmap) {
@@ -1651,7 +1650,6 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
 
 static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 {
-	char b[BDEVNAME_SIZE];
 	struct r1conf *conf = mddev->private;
 	unsigned long flags;
 
@@ -1685,9 +1683,9 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	set_mask_bits(&mddev->sb_flags, 0,
 		      BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
-	pr_crit("md/raid1:%s: Disk failure on %s, disabling device.\n"
+	pr_crit("md/raid1:%s: Disk failure on %pg, disabling device.\n"
 		"md/raid1:%s: Operation continuing on %d devices.\n",
-		mdname(mddev), bdevname(rdev->bdev, b),
+		mdname(mddev), rdev->bdev,
 		mdname(mddev), conf->raid_disks - mddev->degraded);
 }
 
@@ -1705,13 +1703,12 @@ static void print_conf(struct r1conf *conf)
 
 	rcu_read_lock();
 	for (i = 0; i < conf->raid_disks; i++) {
-		char b[BDEVNAME_SIZE];
 		struct md_rdev *rdev = rcu_dereference(conf->mirrors[i].rdev);
 		if (rdev)
-			pr_debug(" disk %d, wo:%d, o:%d, dev:%s\n",
+			pr_debug(" disk %d, wo:%d, o:%d, dev:%pg\n",
 				 i, !test_bit(In_sync, &rdev->flags),
 				 !test_bit(Faulty, &rdev->flags),
-				 bdevname(rdev->bdev,b));
+				 rdev->bdev);
 	}
 	rcu_read_unlock();
 }
@@ -2349,7 +2346,6 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 		}
 		d = start;
 		while (d != read_disk) {
-			char b[BDEVNAME_SIZE];
 			if (d==0)
 				d = conf->raid_disks * 2;
 			d--;
@@ -2362,11 +2358,11 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 				if (r1_sync_page_io(rdev, sect, s,
 						    conf->tmppage, READ)) {
 					atomic_add(s, &rdev->corrected_errors);
-					pr_info("md/raid1:%s: read error corrected (%d sectors at %llu on %s)\n",
+					pr_info("md/raid1:%s: read error corrected (%d sectors at %llu on %pg)\n",
 						mdname(mddev), s,
 						(unsigned long long)(sect +
 								     rdev->data_offset),
-						bdevname(rdev->bdev, b));
+						rdev->bdev);
 				}
 				rdev_dec_pending(rdev, mddev);
 			} else
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5dd2e17e1d0ea..853d3d8c77c74 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -390,10 +390,9 @@ static void raid10_end_read_request(struct bio *bio)
 		/*
 		 * oops, read error - keep the refcount on the rdev
 		 */
-		char b[BDEVNAME_SIZE];
-		pr_err_ratelimited("md/raid10:%s: %s: rescheduling sector %llu\n",
+		pr_err_ratelimited("md/raid10:%s: %pg: rescheduling sector %llu\n",
 				   mdname(conf->mddev),
-				   bdevname(rdev->bdev, b),
+				   rdev->bdev,
 				   (unsigned long long)r10_bio->sector);
 		set_bit(R10BIO_ReadError, &r10_bio->state);
 		reschedule_retry(r10_bio);
@@ -1189,9 +1188,9 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 		return;
 	}
 	if (err_rdev)
-		pr_err_ratelimited("md/raid10:%s: %s: redirecting sector %llu to another mirror\n",
+		pr_err_ratelimited("md/raid10:%s: %pg: redirecting sector %llu to another mirror\n",
 				   mdname(mddev),
-				   bdevname(rdev->bdev, b),
+				   rdev->bdev,
 				   (unsigned long long)r10_bio->sector);
 	if (max_sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, max_sectors,
@@ -1976,7 +1975,6 @@ static int enough(struct r10conf *conf, int ignore)
 
 static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
 {
-	char b[BDEVNAME_SIZE];
 	struct r10conf *conf = mddev->private;
 	unsigned long flags;
 
@@ -2006,9 +2004,9 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
 	set_mask_bits(&mddev->sb_flags, 0,
 		      BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
 	spin_unlock_irqrestore(&conf->device_lock, flags);
-	pr_crit("md/raid10:%s: Disk failure on %s, disabling device.\n"
+	pr_crit("md/raid10:%s: Disk failure on %pg, disabling device.\n"
 		"md/raid10:%s: Operation continuing on %d devices.\n",
-		mdname(mddev), bdevname(rdev->bdev, b),
+		mdname(mddev), rdev->bdev,
 		mdname(mddev), conf->geo.raid_disks - mddev->degraded);
 }
 
@@ -2028,13 +2026,12 @@ static void print_conf(struct r10conf *conf)
 	/* This is only called with ->reconfix_mutex held, so
 	 * rcu protection of rdev is not needed */
 	for (i = 0; i < conf->geo.raid_disks; i++) {
-		char b[BDEVNAME_SIZE];
 		rdev = conf->mirrors[i].rdev;
 		if (rdev)
-			pr_debug(" disk %d, wo:%d, o:%d, dev:%s\n",
+			pr_debug(" disk %d, wo:%d, o:%d, dev:%pg\n",
 				 i, !test_bit(In_sync, &rdev->flags),
 				 !test_bit(Faulty, &rdev->flags),
-				 bdevname(rdev->bdev,b));
+				 rdev->bdev);
 	}
 }
 
@@ -2689,14 +2686,11 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 	check_decay_read_errors(mddev, rdev);
 	atomic_inc(&rdev->read_errors);
 	if (atomic_read(&rdev->read_errors) > max_read_errors) {
-		char b[BDEVNAME_SIZE];
-		bdevname(rdev->bdev, b);
-
-		pr_notice("md/raid10:%s: %s: Raid device exceeded read_error threshold [cur %d:max %d]\n",
-			  mdname(mddev), b,
+		pr_notice("md/raid10:%s: %pg: Raid device exceeded read_error threshold [cur %d:max %d]\n",
+			  mdname(mddev), rdev->bdev,
 			  atomic_read(&rdev->read_errors), max_read_errors);
-		pr_notice("md/raid10:%s: %s: Failing raid device\n",
-			  mdname(mddev), b);
+		pr_notice("md/raid10:%s: %pg: Failing raid device\n",
+			  mdname(mddev), rdev->bdev);
 		md_error(mddev, rdev);
 		r10_bio->devs[r10_bio->read_slot].bio = IO_BLOCKED;
 		return;
@@ -2766,8 +2760,6 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 		/* write it back and re-read */
 		rcu_read_lock();
 		while (sl != r10_bio->read_slot) {
-			char b[BDEVNAME_SIZE];
-
 			if (sl==0)
 				sl = conf->copies;
 			sl--;
@@ -2786,24 +2778,22 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 					     s, conf->tmppage, WRITE)
 			    == 0) {
 				/* Well, this device is dead */
-				pr_notice("md/raid10:%s: read correction write failed (%d sectors at %llu on %s)\n",
+				pr_notice("md/raid10:%s: read correction write failed (%d sectors at %llu on %pg)\n",
 					  mdname(mddev), s,
 					  (unsigned long long)(
 						  sect +
 						  choose_data_offset(r10_bio,
 								     rdev)),
-					  bdevname(rdev->bdev, b));
-				pr_notice("md/raid10:%s: %s: failing drive\n",
+					  rdev->bdev);
+				pr_notice("md/raid10:%s: %pg: failing drive\n",
 					  mdname(mddev),
-					  bdevname(rdev->bdev, b));
+					  rdev->bdev);
 			}
 			rdev_dec_pending(rdev, mddev);
 			rcu_read_lock();
 		}
 		sl = start;
 		while (sl != r10_bio->read_slot) {
-			char b[BDEVNAME_SIZE];
-
 			if (sl==0)
 				sl = conf->copies;
 			sl--;
@@ -2823,23 +2813,23 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 						 READ)) {
 			case 0:
 				/* Well, this device is dead */
-				pr_notice("md/raid10:%s: unable to read back corrected sectors (%d sectors at %llu on %s)\n",
+				pr_notice("md/raid10:%s: unable to read back corrected sectors (%d sectors at %llu on %pg)\n",
 				       mdname(mddev), s,
 				       (unsigned long long)(
 					       sect +
 					       choose_data_offset(r10_bio, rdev)),
-				       bdevname(rdev->bdev, b));
-				pr_notice("md/raid10:%s: %s: failing drive\n",
+				       rdev->bdev);
+				pr_notice("md/raid10:%s: %pg: failing drive\n",
 				       mdname(mddev),
-				       bdevname(rdev->bdev, b));
+				       rdev->bdev);
 				break;
 			case 1:
-				pr_info("md/raid10:%s: read error corrected (%d sectors at %llu on %s)\n",
+				pr_info("md/raid10:%s: read error corrected (%d sectors at %llu on %pg)\n",
 				       mdname(mddev), s,
 				       (unsigned long long)(
 					       sect +
 					       choose_data_offset(r10_bio, rdev)),
-				       bdevname(rdev->bdev, b));
+				       rdev->bdev);
 				atomic_add(s, &rdev->corrected_errors);
 			}
 
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 86e2bb89d9c7b..2dcb93f3efbaa 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -3064,11 +3064,10 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 {
 	struct request_queue *q = bdev_get_queue(rdev->bdev);
 	struct r5l_log *log;
-	char b[BDEVNAME_SIZE];
 	int ret;
 
-	pr_debug("md/raid:%s: using device %s as journal\n",
-		 mdname(conf->mddev), bdevname(rdev->bdev, b));
+	pr_debug("md/raid:%s: using device %pg as journal\n",
+		 mdname(conf->mddev), rdev->bdev);
 
 	if (PAGE_SIZE != 4096)
 		return -EINVAL;
diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index 3446797fa0aca..93d9364a930e3 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -806,7 +806,6 @@ static int ppl_recover_entry(struct ppl_log *log, struct ppl_header_entry *e,
 	int data_disks;
 	int i;
 	int ret = 0;
-	char b[BDEVNAME_SIZE];
 	unsigned int pp_size = le32_to_cpu(e->pp_size);
 	unsigned int data_size = le32_to_cpu(e->data_size);
 
@@ -900,8 +899,8 @@ static int ppl_recover_entry(struct ppl_log *log, struct ppl_header_entry *e,
 				break;
 			}
 
-			pr_debug("%s:%*s reading data member disk %s sector %llu\n",
-				 __func__, indent, "", bdevname(rdev->bdev, b),
+			pr_debug("%s:%*s reading data member disk %pg sector %llu\n",
+				 __func__, indent, "", rdev->bdev,
 				 (unsigned long long)sector);
 			if (!sync_page_io(rdev, sector, block_size, page2,
 					REQ_OP_READ, 0, false)) {
@@ -945,10 +944,10 @@ static int ppl_recover_entry(struct ppl_log *log, struct ppl_header_entry *e,
 		parity_rdev = conf->disks[sh.pd_idx].rdev;
 
 		BUG_ON(parity_rdev->bdev->bd_dev != log->rdev->bdev->bd_dev);
-		pr_debug("%s:%*s write parity at sector %llu, disk %s\n",
+		pr_debug("%s:%*s write parity at sector %llu, disk %pg\n",
 			 __func__, indent, "",
 			 (unsigned long long)parity_sector,
-			 bdevname(parity_rdev->bdev, b));
+			 parity_rdev->bdev);
 		if (!sync_page_io(parity_rdev, parity_sector, block_size,
 				page1, REQ_OP_WRITE, 0, false)) {
 			pr_debug("%s:%*s parity write error!\n", __func__,
@@ -1258,7 +1257,6 @@ void ppl_exit_log(struct r5conf *conf)
 
 static int ppl_validate_rdev(struct md_rdev *rdev)
 {
-	char b[BDEVNAME_SIZE];
 	int ppl_data_sectors;
 	int ppl_size_new;
 
@@ -1275,8 +1273,8 @@ static int ppl_validate_rdev(struct md_rdev *rdev)
 				RAID5_STRIPE_SECTORS((struct r5conf *)rdev->mddev->private));
 
 	if (ppl_data_sectors <= 0) {
-		pr_warn("md/raid:%s: PPL space too small on %s\n",
-			mdname(rdev->mddev), bdevname(rdev->bdev, b));
+		pr_warn("md/raid:%s: PPL space too small on %pg\n",
+			mdname(rdev->mddev), rdev->bdev);
 		return -ENOSPC;
 	}
 
@@ -1286,16 +1284,16 @@ static int ppl_validate_rdev(struct md_rdev *rdev)
 	     rdev->ppl.sector + ppl_size_new > rdev->data_offset) ||
 	    (rdev->ppl.sector >= rdev->data_offset &&
 	     rdev->data_offset + rdev->sectors > rdev->ppl.sector)) {
-		pr_warn("md/raid:%s: PPL space overlaps with data on %s\n",
-			mdname(rdev->mddev), bdevname(rdev->bdev, b));
+		pr_warn("md/raid:%s: PPL space overlaps with data on %pg\n",
+			mdname(rdev->mddev), rdev->bdev);
 		return -EINVAL;
 	}
 
 	if (!rdev->mddev->external &&
 	    ((rdev->ppl.offset > 0 && rdev->ppl.offset < (rdev->sb_size >> 9)) ||
 	     (rdev->ppl.offset <= 0 && rdev->ppl.offset + ppl_size_new > 0))) {
-		pr_warn("md/raid:%s: PPL space overlaps with superblock on %s\n",
-			mdname(rdev->mddev), bdevname(rdev->bdev, b));
+		pr_warn("md/raid:%s: PPL space overlaps with superblock on %pg\n",
+			mdname(rdev->mddev), rdev->bdev);
 		return -EINVAL;
 	}
 
@@ -1465,14 +1463,13 @@ int ppl_modify_log(struct r5conf *conf, struct md_rdev *rdev, bool add)
 	struct ppl_conf *ppl_conf = conf->log_private;
 	struct ppl_log *log;
 	int ret = 0;
-	char b[BDEVNAME_SIZE];
 
 	if (!rdev)
 		return -EINVAL;
 
-	pr_debug("%s: disk: %d operation: %s dev: %s\n",
+	pr_debug("%s: disk: %d operation: %s dev: %pg\n",
 		 __func__, rdev->raid_disk, add ? "add" : "remove",
-		 bdevname(rdev->bdev, b));
+		 rdev->bdev);
 
 	if (rdev->raid_disk < 0)
 		return 0;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8891aaba65964..7597959021dad 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2665,7 +2665,6 @@ static void raid5_end_read_request(struct bio * bi)
 	struct stripe_head *sh = bi->bi_private;
 	struct r5conf *conf = sh->raid_conf;
 	int disks = sh->disks, i;
-	char b[BDEVNAME_SIZE];
 	struct md_rdev *rdev = NULL;
 	sector_t s;
 
@@ -2703,10 +2702,10 @@ static void raid5_end_read_request(struct bio * bi)
 			 * any error
 			 */
 			pr_info_ratelimited(
-				"md/raid:%s: read error corrected (%lu sectors at %llu on %s)\n",
+				"md/raid:%s: read error corrected (%lu sectors at %llu on %pg)\n",
 				mdname(conf->mddev), RAID5_STRIPE_SECTORS(conf),
 				(unsigned long long)s,
-				bdevname(rdev->bdev, b));
+				rdev->bdev);
 			atomic_add(RAID5_STRIPE_SECTORS(conf), &rdev->corrected_errors);
 			clear_bit(R5_ReadError, &sh->dev[i].flags);
 			clear_bit(R5_ReWrite, &sh->dev[i].flags);
@@ -2723,7 +2722,6 @@ static void raid5_end_read_request(struct bio * bi)
 		if (atomic_read(&rdev->read_errors))
 			atomic_set(&rdev->read_errors, 0);
 	} else {
-		const char *bdn = bdevname(rdev->bdev, b);
 		int retry = 0;
 		int set_bad = 0;
 
@@ -2732,25 +2730,25 @@ static void raid5_end_read_request(struct bio * bi)
 			atomic_inc(&rdev->read_errors);
 		if (test_bit(R5_ReadRepl, &sh->dev[i].flags))
 			pr_warn_ratelimited(
-				"md/raid:%s: read error on replacement device (sector %llu on %s).\n",
+				"md/raid:%s: read error on replacement device (sector %llu on %pg).\n",
 				mdname(conf->mddev),
 				(unsigned long long)s,
-				bdn);
+				rdev->bdev);
 		else if (conf->mddev->degraded >= conf->max_degraded) {
 			set_bad = 1;
 			pr_warn_ratelimited(
-				"md/raid:%s: read error not correctable (sector %llu on %s).\n",
+				"md/raid:%s: read error not correctable (sector %llu on %pg).\n",
 				mdname(conf->mddev),
 				(unsigned long long)s,
-				bdn);
+				rdev->bdev);
 		} else if (test_bit(R5_ReWrite, &sh->dev[i].flags)) {
 			/* Oh, no!!! */
 			set_bad = 1;
 			pr_warn_ratelimited(
-				"md/raid:%s: read error NOT corrected!! (sector %llu on %s).\n",
+				"md/raid:%s: read error NOT corrected!! (sector %llu on %pg).\n",
 				mdname(conf->mddev),
 				(unsigned long long)s,
-				bdn);
+				rdev->bdev);
 		} else if (atomic_read(&rdev->read_errors)
 			 > conf->max_nr_stripes) {
 			if (!test_bit(Faulty, &rdev->flags)) {
@@ -2758,8 +2756,8 @@ static void raid5_end_read_request(struct bio * bi)
 				    mdname(conf->mddev),
 				    atomic_read(&rdev->read_errors),
 				    conf->max_nr_stripes);
-				pr_warn("md/raid:%s: Too many read errors, failing device %s.\n",
-				    mdname(conf->mddev), bdn);
+				pr_warn("md/raid:%s: Too many read errors, failing device %pg.\n",
+				    mdname(conf->mddev), rdev->bdev);
 			}
 		} else
 			retry = 1;
@@ -2872,7 +2870,6 @@ static void raid5_end_write_request(struct bio *bi)
 
 static void raid5_error(struct mddev *mddev, struct md_rdev *rdev)
 {
-	char b[BDEVNAME_SIZE];
 	struct r5conf *conf = mddev->private;
 	unsigned long flags;
 	pr_debug("raid456: error called\n");
@@ -2899,10 +2896,10 @@ static void raid5_error(struct mddev *mddev, struct md_rdev *rdev)
 	set_bit(Blocked, &rdev->flags);
 	set_mask_bits(&mddev->sb_flags, 0,
 		      BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
-	pr_crit("md/raid:%s: Disk failure on %s, disabling device.\n"
+	pr_crit("md/raid:%s: Disk failure on %pg, disabling device.\n"
 		"md/raid:%s: Operation continuing on %d devices.\n",
 		mdname(mddev),
-		bdevname(rdev->bdev, b),
+		rdev->bdev,
 		mdname(mddev),
 		conf->raid_disks - mddev->degraded);
 	r5c_update_on_rdev_error(mddev, rdev);
@@ -7340,9 +7337,8 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 		}
 
 		if (test_bit(In_sync, &rdev->flags)) {
-			char b[BDEVNAME_SIZE];
-			pr_info("md/raid:%s: device %s operational as raid disk %d\n",
-				mdname(mddev), bdevname(rdev->bdev, b), raid_disk);
+			pr_info("md/raid:%s: device %pg operational as raid disk %d\n",
+				mdname(mddev), rdev->bdev, raid_disk);
 		} else if (rdev->saved_raid_disk != raid_disk)
 			/* Cannot rely on bitmap to complete recovery */
 			conf->fullsync = 1;
@@ -7861,12 +7857,11 @@ static void print_raid5_conf (struct r5conf *conf)
 	       conf->raid_disks - conf->mddev->degraded);
 
 	for (i = 0; i < conf->raid_disks; i++) {
-		char b[BDEVNAME_SIZE];
 		tmp = conf->disks + i;
 		if (tmp->rdev)
-			pr_debug(" disk %d, o:%d, dev:%s\n",
+			pr_debug(" disk %d, o:%d, dev:%pg\n",
 			       i, !test_bit(Faulty, &tmp->rdev->flags),
-			       bdevname(tmp->rdev->bdev, b));
+			       tmp->rdev->bdev);
 	}
 }
 
-- 
2.30.2

