From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 015 of 20] Keep better track of dev/array size when assembling md arrays.
Date: Mon, 12 Dec 2005 14:15:29 +1100
Message-ID: <1051212031529.5152@suse.de>
References: <20051212135705.4561.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Move the checks - that dev size is never less than array size - into
bind_rdev_to_array to make sure it always happens properly (there is
one place where currently it doesn't).

Also reject any superblock which claims an array size smaller than the
device in question can hold.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-12-12 11:35:53.000000000 +1100
+++ ./drivers/md/md.c	2005-12-12 11:36:25.000000000 +1100
@@ -695,6 +695,10 @@ static int super_90_load(mdk_rdev_t *rde
 	}
 	rdev->size = calc_dev_size(rdev, sb->chunk_size);
 
+	if (rdev->size < sb->size && sb->level > 1)
+		/* "this cannot possibly happen" ... */
+		ret = -EINVAL;
+
  abort:
 	return ret;
 }
@@ -1039,6 +1043,9 @@ static int super_1_load(mdk_rdev_t *rdev
 	rdev->size = le64_to_cpu(sb->data_size)/2;
 	if (le32_to_cpu(sb->chunksize))
 		rdev->size &= ~((sector_t)le32_to_cpu(sb->chunksize)/2 - 1);
+
+	if (le32_to_cpu(sb->size) > rdev->size*2)
+		return -EINVAL;
 	return 0;
 }
 
@@ -1224,6 +1231,14 @@ static int bind_rdev_to_array(mdk_rdev_t
 		MD_BUG();
 		return -EINVAL;
 	}
+	/* make sure rdev->size exceeds mddev->size */
+	if (rdev->size && (mddev->size == 0 || rdev->size < mddev->size)) {
+		if (mddev->pers)
+			/* Cannot change size, so fail */
+			return -ENOSPC;
+		else
+			mddev->size = rdev->size;
+	}
 	same_pdev = match_dev_unit(mddev, rdev);
 	if (same_pdev)
 		printk(KERN_WARNING
@@ -2898,12 +2913,6 @@ static int add_new_disk(mddev_t * mddev,
 		if (info->state & (1<<MD_DISK_WRITEMOSTLY))
 			set_bit(WriteMostly, &rdev->flags);
 
-		err = bind_rdev_to_array(rdev, mddev);
-		if (err) {
-			export_rdev(rdev);
-			return err;
-		}
-
 		if (!mddev->persistent) {
 			printk(KERN_INFO "md: nonpersistent superblock ...\n");
 			rdev->sb_offset = rdev->bdev->bd_inode->i_size >> BLOCK_SIZE_BITS;
@@ -2911,8 +2920,11 @@ static int add_new_disk(mddev_t * mddev,
 			rdev->sb_offset = calc_dev_sboffset(rdev->bdev);
 		rdev->size = calc_dev_size(rdev, mddev->chunk_size);
 
-		if (!mddev->size || (mddev->size > rdev->size))
-			mddev->size = rdev->size;
+		err = bind_rdev_to_array(rdev, mddev);
+		if (err) {
+			export_rdev(rdev);
+			return err;
+		}
 	}
 
 	return 0;
@@ -2984,15 +2996,6 @@ static int hot_add_disk(mddev_t * mddev,
 	size = calc_dev_size(rdev, mddev->chunk_size);
 	rdev->size = size;
 
-	if (size < mddev->size) {
-		printk(KERN_WARNING 
-			"%s: disk size %llu blocks < array size %llu\n",
-			mdname(mddev), (unsigned long long)size,
-			(unsigned long long)mddev->size);
-		err = -ENOSPC;
-		goto abort_export;
-	}
-
 	if (test_bit(Faulty, &rdev->flags)) {
 		printk(KERN_WARNING 
 			"md: can not hot-add faulty %s disk to %s!\n",
@@ -3002,7 +3005,9 @@ static int hot_add_disk(mddev_t * mddev,
 	}
 	clear_bit(In_sync, &rdev->flags);
 	rdev->desc_nr = -1;
-	bind_rdev_to_array(rdev, mddev);
+	err = bind_rdev_to_array(rdev, mddev);
+	if (err)
+		goto abort_export;
 
 	/*
 	 * The rest should better be atomic, we can have disk failures
