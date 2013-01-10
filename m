From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] DM-RAID: Fix RAID10's check for sufficient redundancy
Date: Wed, 09 Jan 2013 20:00:59 -0600
Message-ID: <1357783259.9103.5.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, agk@redhat.com, jbrassow@redhat.com
List-Id: linux-raid.ids

DM RAID:  Fix RAID10's check for sufficient redundancy

Before attempting to activate a RAID array, it is checked for sufficient
redundancy.  That is, we make sure that there are not too many failed
devices - or devices specified for rebuild - to undermine our ability to
activate the array.  The current code performs this check twice - once to
ensure there were not too many devices specified for rebuild by the user
('validate_rebuild_devices') and again after possibly experiencing a failure
to read the superblock ('analyse_superblocks').  Neither of these checks are
sufficient.  The first check is done properly but with insufficient
information about the possible failure state of the devices to make a good
determination if the array can be activated.  The second check is simply
done wrong in the case of RAID10 because it doesn't account for the
independence of the stripes (i.e. mirror sets).  The solution is to use the
properly written check ('validate_rebuild_devices'), but perform the check
after the superblocks have been read and we know which devices have failed.
This gives us one check instead of two and performs it in a location where
it can be done right.

Only RAID10 was affected and it was affected in the following ways:
- the code did not properly catch the condition where a user specified
  a device for rebuild that already had a failed device in the same mirror
  set.  (This condition would, however, be caught at a deeper level in MD.)
- the code triggers a false positive and denies activation when devices in
  independent mirror sets have failed - counting the failures as though they
  were all in the same set.

The most likely place this error was introduced (or this patch should have
been included) is in commit 4ec1e369 - first introduced in v3.7-rc1.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -369,25 +369,23 @@ static int validate_region_size(struct r
 }
 
 /*
- * validate_rebuild_devices
+ * validate_raid_redundancy
  * @rs
  *
- * Determine if the devices specified for rebuild can result in a valid
- * usable array that is capable of rebuilding the given devices.
+ * Determine if there are enough devices in the array that haven't
+ * failed (or are being rebuilt) to form a usable array.
  *
  * Returns: 0 on success, -EINVAL on failure.
  */
-static int validate_rebuild_devices(struct raid_set *rs)
+static int validate_raid_redundancy(struct raid_set *rs)
 {
 	unsigned i, rebuild_cnt = 0;
 	unsigned rebuilds_per_group, copies, d;
 	unsigned group_size, last_group_start;
 
-	if (!(rs->print_flags & DMPF_REBUILD))
-		return 0;
-
 	for (i = 0; i < rs->md.raid_disks; i++)
-		if (!test_bit(In_sync, &rs->dev[i].rdev.flags))
+		if (!test_bit(In_sync, &rs->dev[i].rdev.flags) ||
+		    !rs->dev[i].rdev.sb_page)
 			rebuild_cnt++;
 
 	switch (rs->raid_type->level) {
@@ -424,7 +422,8 @@ static int validate_rebuild_devices(stru
 		if (!strcmp("near", raid10_md_layout_to_format(rs->md.layout))) {
 			for (i = 0; i < rs->md.raid_disks * copies; i++) {
 				d = i % rs->md.raid_disks;
-				if (!test_bit(In_sync, &rs->dev[d].rdev.flags) &&
+				if ((!rs->dev[d].rdev.sb_page ||
+				     !test_bit(In_sync, &rs->dev[d].rdev.flags)) &&
 				    (++rebuilds_per_group >= copies))
 					goto too_many;
 				if (!((i + 1) % copies))
@@ -451,22 +450,20 @@ static int validate_rebuild_devices(stru
 		for (i = 0; i < rs->md.raid_disks; i++) {
 			if (!(i % copies) && !(i > last_group_start))
 				rebuilds_per_group = 0;
-			if (!test_bit(In_sync, &rs->dev[i].rdev.flags) &&
+			if ((!rs->dev[i].rdev.sb_page ||
+			     !test_bit(In_sync, &rs->dev[i].rdev.flags)) &&
 			    (++rebuilds_per_group >= copies))
 					goto too_many;
 		}
 		break;
 	default:
-		DMERR("The rebuild parameter is not supported for %s",
-		      rs->raid_type->name);
-		rs->ti->error = "Rebuild not supported for this RAID type";
-		return -EINVAL;
+		if (rebuild_cnt)
+			return -EINVAL;
 	}
 
 	return 0;
 
 too_many:
-	rs->ti->error = "Too many rebuild devices specified";
 	return -EINVAL;
 }
 
@@ -728,9 +725,6 @@ static int parse_raid_params(struct raid
 	}
 	rs->md.dev_sectors = sectors_per_dev;
 
-	if (validate_rebuild_devices(rs))
-		return -EINVAL;
-
 	/* Assume there are no metadata devices until the drives are parsed */
 	rs->md.persistent = 0;
 	rs->md.external = 1;
@@ -1072,28 +1066,10 @@ static int super_validate(struct mddev *
 static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
 {
 	int ret;
-	unsigned redundancy = 0;
 	struct raid_dev *dev;
 	struct md_rdev *rdev, *tmp, *freshest;
 	struct mddev *mddev = &rs->md;
 
-	switch (rs->raid_type->level) {
-	case 1:
-		redundancy = rs->md.raid_disks - 1;
-		break;
-	case 4:
-	case 5:
-	case 6:
-		redundancy = rs->raid_type->parity_devs;
-		break;
-	case 10:
-		redundancy = raid10_md_layout_to_copies(mddev->layout) - 1;
-		break;
-	default:
-		ti->error = "Unknown RAID type";
-		return -EINVAL;
-	}
-
 	freshest = NULL;
 	rdev_for_each_safe(rdev, tmp, mddev) {
 		/*
@@ -1122,44 +1098,43 @@ static int analyse_superblocks(struct dm
 			break;
 		default:
 			dev = container_of(rdev, struct raid_dev, rdev);
-			if (redundancy--) {
-				if (dev->meta_dev)
-					dm_put_device(ti, dev->meta_dev);
-
-				dev->meta_dev = NULL;
-				rdev->meta_bdev = NULL;
+			if (dev->meta_dev)
+				dm_put_device(ti, dev->meta_dev);
 
-				if (rdev->sb_page)
-					put_page(rdev->sb_page);
+			dev->meta_dev = NULL;
+			rdev->meta_bdev = NULL;
 
-				rdev->sb_page = NULL;
+			if (rdev->sb_page)
+				put_page(rdev->sb_page);
 
-				rdev->sb_loaded = 0;
+			rdev->sb_page = NULL;
 
-				/*
-				 * We might be able to salvage the data device
-				 * even though the meta device has failed.  For
-				 * now, we behave as though '- -' had been
-				 * set for this device in the table.
-				 */
-				if (dev->data_dev)
-					dm_put_device(ti, dev->data_dev);
+			rdev->sb_loaded = 0;
 
-				dev->data_dev = NULL;
-				rdev->bdev = NULL;
+			/*
+			 * We might be able to salvage the data device
+			 * even though the meta device has failed.  For
+			 * now, we behave as though '- -' had been
+			 * set for this device in the table.
+			 */
+			if (dev->data_dev)
+				dm_put_device(ti, dev->data_dev);
 
-				list_del(&rdev->same_set);
+			dev->data_dev = NULL;
+			rdev->bdev = NULL;
 
-				continue;
-			}
-			ti->error = "Failed to load superblock";
-			return ret;
+			list_del(&rdev->same_set);
 		}
 	}
 
 	if (!freshest)
 		return 0;
 
+	if (validate_raid_redundancy(rs)) {
+		rs->ti->error = "Insufficient redundancy to activate array";
+		return -EINVAL;
+	}
+
 	/*
 	 * Validation of the freshest device provides the source of
 	 * validation for the remaining devices.
Index: linux-upstream/Documentation/device-mapper/dm-raid.txt
===================================================================
--- linux-upstream.orig/Documentation/device-mapper/dm-raid.txt
+++ linux-upstream/Documentation/device-mapper/dm-raid.txt
@@ -171,3 +171,4 @@ Version History
 1.3.1	Allow device replacement/rebuild for RAID 10
 1.4.0	Non-functional change.  Removes arg from mapping function.
 1.4.1   Add RAID10 "far" and "offset" algorithm support.
+1.4.2   Fix/improve redundancy checking for RAID10


