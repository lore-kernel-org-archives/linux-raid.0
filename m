From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] MD data integrity support
Date: Sun, 04 Jan 2009 03:02:39 -0500
Message-ID: <yq13afz5wio.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, jens.axboe@oracle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


md: Add support for data integrity to MD

If all subdevices support the same protection format the MD device is
flagged as integrity capable.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/md/md.c b/drivers/md/md.c
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1411,6 +1411,38 @@ static int match_mddev_units(mddev_t *md
 
 static LIST_HEAD(pending_raid_disks);
 
+static void md_integrity_check(mdk_rdev_t *rdev, mddev_t *mddev)
+{
+	struct mdk_personality *pers = mddev->pers;
+	struct gendisk *disk = mddev->gendisk;
+	struct blk_integrity *bi_rdev = bdev_get_integrity(rdev->bdev);
+	struct blk_integrity *bi_mddev = blk_get_integrity(disk);
+
+	/* Data integrity passthrough not supported on RAID 4, 5 and 6 */
+	if (pers && pers->level >= 4 && pers->level <= 6)
+		return;
+
+	/* If rdev is integrity capable, register profile for mddev */
+	if (!bi_mddev && bi_rdev) {
+		if (blk_integrity_register(disk, bi_rdev))
+			printk(KERN_ERR "%s: %s Could not register integrity!\n",
+			       __func__, disk->disk_name);
+		else
+			printk(KERN_NOTICE "Enabling data integrity on %s\n",
+			       disk->disk_name);
+		return;
+	}
+
+	/* Check that mddev and rdev have matching profiles */
+	if (blk_integrity_compare(disk, rdev->bdev->bd_disk) < 0) {
+		printk(KERN_ERR "%s: %s/%s integrity mismatch!\n", __func__,
+		       disk->disk_name, rdev->bdev->bd_disk->disk_name);
+		printk(KERN_NOTICE "Disabling data integrity on %s\n",
+		       disk->disk_name);
+		blk_integrity_unregister(disk);
+	}
+}
+
 static int bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
 {
 	char b[BDEVNAME_SIZE];
@@ -1474,6 +1506,7 @@ static int bind_rdev_to_array(mdk_rdev_t
 	}
 	list_add_rcu(&rdev->same_set, &mddev->disks);
 	bd_claim_by_disk(rdev->bdev, rdev->bdev->bd_holder, mddev->gendisk);
+	md_integrity_check(rdev, mddev);
 	return 0;
 
  fail:
@@ -3950,6 +3983,7 @@ static int do_md_stop(mddev_t * mddev, i
 		printk(KERN_INFO "md: %s switched to read-only mode.\n",
 			mdname(mddev));
 	err = 0;
+	blk_integrity_unregister(disk);
 	md_new_event(mddev);
 	sysfs_notify(&mddev->kobj, NULL, "array_state");
 out:
