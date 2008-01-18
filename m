From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 4] md: Allow devices to be shared between md arrays.
Date: Fri, 18 Jan 2008 22:02:36 +1100
Message-ID: <1080118110236.30484@suse.de>
References: <20080118215531.30136.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Currently, a given device is "claimed" by a particular array so
that it cannot be used by other arrays.

This is not ideal for DDF and other metadata schemes which have
their own partitioning concept.

So for externally managed metadata, just claim the device for
md in general, require that "offset" and "size" are set
properly for each device, and make sure that if a device is
included in different arrays then the active sections do
not overlap.

This involves adding another flag to the rdev which makes it awkward
to set "->flags = 0" to clear certain flags.  So now clear flags
explicitly by name when we want to clear things.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c           |   88 +++++++++++++++++++++++++++++++++++++++-----
 ./include/linux/raid/md_k.h |    2 +
 2 files changed, 80 insertions(+), 10 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-01-18 11:03:15.000000000 +1100
+++ ./drivers/md/md.c	2008-01-18 11:18:04.000000000 +1100
@@ -774,7 +774,11 @@ static int super_90_validate(mddev_t *md
 	__u64 ev1 = md_event(sb);
 
 	rdev->raid_disk = -1;
-	rdev->flags = 0;
+	clear_bit(Faulty, &rdev->flags);
+	clear_bit(In_sync, &rdev->flags);
+	clear_bit(WriteMostly, &rdev->flags);
+	clear_bit(BarriersNotsupp, &rdev->flags);
+
 	if (mddev->raid_disks == 0) {
 		mddev->major_version = 0;
 		mddev->minor_version = sb->minor_version;
@@ -1154,7 +1158,11 @@ static int super_1_validate(mddev_t *mdd
 	__u64 ev1 = le64_to_cpu(sb->events);
 
 	rdev->raid_disk = -1;
-	rdev->flags = 0;
+	clear_bit(Faulty, &rdev->flags);
+	clear_bit(In_sync, &rdev->flags);
+	clear_bit(WriteMostly, &rdev->flags);
+	clear_bit(BarriersNotsupp, &rdev->flags);
+
 	if (mddev->raid_disks == 0) {
 		mddev->major_version = 1;
 		mddev->patch_version = 0;
@@ -1402,7 +1410,7 @@ static int bind_rdev_to_array(mdk_rdev_t
 		goto fail;
 	}
 	list_add(&rdev->same_set, &mddev->disks);
-	bd_claim_by_disk(rdev->bdev, rdev, mddev->gendisk);
+	bd_claim_by_disk(rdev->bdev, rdev->bdev->bd_holder, mddev->gendisk);
 	return 0;
 
  fail:
@@ -1442,7 +1450,7 @@ static void unbind_rdev_from_array(mdk_r
  * otherwise reused by a RAID array (or any other kernel
  * subsystem), by bd_claiming the device.
  */
-static int lock_rdev(mdk_rdev_t *rdev, dev_t dev)
+static int lock_rdev(mdk_rdev_t *rdev, dev_t dev, int shared)
 {
 	int err = 0;
 	struct block_device *bdev;
@@ -1454,13 +1462,15 @@ static int lock_rdev(mdk_rdev_t *rdev, d
 			__bdevname(dev, b));
 		return PTR_ERR(bdev);
 	}
-	err = bd_claim(bdev, rdev);
+	err = bd_claim(bdev, shared ? (mdk_rdev_t *)lock_rdev : rdev);
 	if (err) {
 		printk(KERN_ERR "md: could not bd_claim %s.\n",
 			bdevname(bdev, b));
 		blkdev_put(bdev);
 		return err;
 	}
+	if (!shared)
+		set_bit(AllReserved, &rdev->flags);
 	rdev->bdev = bdev;
 	return err;
 }
@@ -1925,7 +1935,8 @@ slot_store(mdk_rdev_t *rdev, const char 
 			return -ENOSPC;
 		rdev->raid_disk = slot;
 		/* assume it is working */
-		rdev->flags = 0;
+		clear_bit(Faulty, &rdev->flags);
+		clear_bit(WriteMostly, &rdev->flags);
 		set_bit(In_sync, &rdev->flags);
 	}
 	return len;
@@ -1950,6 +1961,10 @@ offset_store(mdk_rdev_t *rdev, const cha
 		return -EINVAL;
 	if (rdev->mddev->pers)
 		return -EBUSY;
+	if (rdev->size && rdev->mddev->external)
+		/* Must set offset before size, so overlap checks
+		 * can be sane */
+		return -EBUSY;
 	rdev->data_offset = offset;
 	return len;
 }
@@ -1963,16 +1978,69 @@ rdev_size_show(mdk_rdev_t *rdev, char *p
 	return sprintf(page, "%llu\n", (unsigned long long)rdev->size);
 }
 
+static int overlaps(sector_t s1, sector_t l1, sector_t s2, sector_t l2)
+{
+	/* check if two start/length pairs overlap */
+	if (s1+l1 <= s2)
+		return 0;
+	if (s2+l2 <= s1)
+		return 0;
+	return 1;
+}
+
 static ssize_t
 rdev_size_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 {
 	char *e;
 	unsigned long long size = simple_strtoull(buf, &e, 10);
+	unsigned long long oldsize = rdev->size;
 	if (e==buf || (*e && *e != '\n'))
 		return -EINVAL;
 	if (rdev->mddev->pers)
 		return -EBUSY;
 	rdev->size = size;
+	if (size > oldsize && rdev->mddev->external) {
+		/* need to check that all other rdevs with the same ->bdev
+		 * do not overlap.  We need to unlock the mddev to avoid
+		 * a deadlock.  We have already changed rdev->size, and if
+		 * we have to change it back, we will have the lock again.
+		 */
+		mddev_t *mddev;
+		int overlap = 0;
+		struct list_head *tmp, *tmp2;
+
+		mddev_unlock(rdev->mddev);
+		ITERATE_MDDEV(mddev, tmp) {
+			mdk_rdev_t *rdev2;
+
+			mddev_lock(mddev);
+			ITERATE_RDEV(mddev, rdev2, tmp2)
+				if (test_bit(AllReserved, &rdev2->flags) ||
+				    (rdev->bdev == rdev2->bdev &&
+				     rdev != rdev2 &&
+				     overlaps(rdev->data_offset, rdev->size,
+					    rdev2->data_offset, rdev2->size))) {
+					overlap = 1;
+					break;
+				}
+			mddev_unlock(mddev);
+			if (overlap) {
+				mddev_put(mddev);
+				break;
+			}
+		}
+		mddev_lock(rdev->mddev);
+		if (overlap) {
+			/* Someone else could have slipped in a size
+			 * change here, but doing so is just silly.
+			 * We put oldsize back because we *know* it is
+			 * safe, and trust userspace not to race with
+			 * itself
+			 */
+			rdev->size = oldsize;
+			return -EBUSY;
+		}
+	}
 	if (size < rdev->mddev->size || rdev->mddev->size == 0)
 		rdev->mddev->size = size;
 	return len;
@@ -2062,7 +2130,7 @@ static mdk_rdev_t *md_import_device(dev_
 	if ((err = alloc_disk_sb(rdev)))
 		goto abort_free;
 
-	err = lock_rdev(rdev, newdev);
+	err = lock_rdev(rdev, newdev, super_format == -2);
 	if (err)
 		goto abort_free;
 
@@ -2615,7 +2683,9 @@ new_dev_store(mddev_t *mddev, const char
 			if (err < 0)
 				goto out;
 		}
-	} else
+	} else if (mddev->external)
+		rdev = md_import_device(dev, -2, -1);
+	else
 		rdev = md_import_device(dev, -1, -1);
 
 	if (IS_ERR(rdev))
@@ -4025,8 +4095,6 @@ static int add_new_disk(mddev_t * mddev,
 		else
 			rdev->raid_disk = -1;
 
-		rdev->flags = 0;
-
 		if (rdev->raid_disk < mddev->raid_disks)
 			if (info->state & (1<<MD_DISK_SYNC))
 				set_bit(In_sync, &rdev->flags);

diff .prev/include/linux/raid/md_k.h ./include/linux/raid/md_k.h
--- .prev/include/linux/raid/md_k.h	2008-01-18 10:46:49.000000000 +1100
+++ ./include/linux/raid/md_k.h	2008-01-18 11:18:04.000000000 +1100
@@ -81,6 +81,8 @@ struct mdk_rdev_s
 #define	In_sync		2		/* device is in_sync with rest of array */
 #define	WriteMostly	4		/* Avoid reading if at all possible */
 #define	BarriersNotsupp	5		/* BIO_RW_BARRIER is not supported */
+#define	AllReserved	6		/* If whole device is reserved for
+					 * one array */
 
 	int desc_nr;			/* descriptor index in the superblock */
 	int raid_disk;			/* role of device in array */
