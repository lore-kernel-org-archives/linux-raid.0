From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 2/9] md: change all printk() to pr_err() or pr_warn() etc.
Date: Wed, 02 Nov 2016 14:16:49 +1100
Message-ID: <147805660915.23566.15029095566998132914.stgit@noble>
References: <147805657658.23566.1748253447749986766.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <147805657658.23566.1748253447749986766.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

1/ using pr_debug() for a number of messages reduces the noise of
   md, but still allows them to be enabled when needed.
2/ try to be consistent in the usage of pr_err() and pr_warn(), and
   document the intention
3/ When strings have been split onto multiple lines, rejoin into
   a single string.
   The cost of having lines > 80 chars is less than the cost of not
   being able to easily search for a particular message.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/md.c |  389 ++++++++++++++++++++++++-------------------------------
 1 file changed, 170 insertions(+), 219 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e3d20fb1d839..0354a92636aa 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -30,6 +30,18 @@
    You should have received a copy of the GNU General Public License
    (for example /usr/src/linux/COPYING); if not, write to the Free
    Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+
+   Errors, Warnings, etc.
+   Please use:
+     pr_crit() for error conditions that risk data loss
+     pr_err() for error conditions that are unexpected, like an IO error
+         or internal inconsistency
+     pr_warn() for error conditions that could have been predicated, like
+         adding a device to an array when it has incompatible metadata
+     pr_info() for every interesting, very rare events, like an array starting
+         or stopping, or resync starting or stopping
+     pr_debug() for everything else.
+
 */
 
 #include <linux/kthread.h>
@@ -712,7 +724,7 @@ static void super_written(struct bio *bio)
 	struct mddev *mddev = rdev->mddev;
 
 	if (bio->bi_error) {
-		printk("md: super_written gets error=%d\n", bio->bi_error);
+		pr_err("md: super_written gets error=%d\n", bio->bi_error);
 		md_error(mddev, rdev);
 	}
 
@@ -792,8 +804,8 @@ static int read_disk_sb(struct md_rdev *rdev, int size)
 	return 0;
 
 fail:
-	printk(KERN_WARNING "md: disabled device %s, could not read superblock.\n",
-		bdevname(rdev->bdev,b));
+	pr_err("md: disabled device %s, could not read superblock.\n",
+	       bdevname(rdev->bdev,b));
 	return -EINVAL;
 }
 
@@ -815,7 +827,6 @@ static int sb_equal(mdp_super_t *sb1, mdp_super_t *sb2)
 
 	if (!tmp1 || !tmp2) {
 		ret = 0;
-		printk(KERN_INFO "md.c sb_equal(): failed to allocate memory!\n");
 		goto abort;
 	}
 
@@ -929,7 +940,7 @@ int md_check_no_bitmap(struct mddev *mddev)
 {
 	if (!mddev->bitmap_info.file && !mddev->bitmap_info.offset)
 		return 0;
-	printk(KERN_ERR "%s: bitmaps are not supported for %s\n",
+	pr_warn("%s: bitmaps are not supported for %s\n",
 		mdname(mddev), mddev->pers->name);
 	return 1;
 }
@@ -953,7 +964,8 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 	rdev->sb_start = calc_dev_sboffset(rdev);
 
 	ret = read_disk_sb(rdev, MD_SB_BYTES);
-	if (ret) return ret;
+	if (ret)
+		return ret;
 
 	ret = -EINVAL;
 
@@ -961,17 +973,15 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 	sb = page_address(rdev->sb_page);
 
 	if (sb->md_magic != MD_SB_MAGIC) {
-		printk(KERN_ERR "md: invalid raid superblock magic on %s\n",
-		       b);
+		pr_warn("md: invalid raid superblock magic on %s\n", b);
 		goto abort;
 	}
 
 	if (sb->major_version != 0 ||
 	    sb->minor_version < 90 ||
 	    sb->minor_version > 91) {
-		printk(KERN_WARNING "Bad version number %d.%d on %s\n",
-			sb->major_version, sb->minor_version,
-			b);
+		pr_warn("Bad version number %d.%d on %s\n",
+			sb->major_version, sb->minor_version, b);
 		goto abort;
 	}
 
@@ -979,8 +989,7 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 		goto abort;
 
 	if (md_csum_fold(calc_sb_csum(sb)) != md_csum_fold(sb->sb_csum)) {
-		printk(KERN_WARNING "md: invalid superblock checksum on %s\n",
-			b);
+		pr_warn("md: invalid superblock checksum on %s\n", b);
 		goto abort;
 	}
 
@@ -1001,14 +1010,13 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 		__u64 ev1, ev2;
 		mdp_super_t *refsb = page_address(refdev->sb_page);
 		if (!uuid_equal(refsb, sb)) {
-			printk(KERN_WARNING "md: %s has different UUID to %s\n",
+			pr_warn("md: %s has different UUID to %s\n",
 				b, bdevname(refdev->bdev,b2));
 			goto abort;
 		}
 		if (!sb_equal(refsb, sb)) {
-			printk(KERN_WARNING "md: %s has same UUID"
-			       " but different superblock to %s\n",
-			       b, bdevname(refdev->bdev, b2));
+			pr_warn("md: %s has same UUID but different superblock to %s\n",
+				b, bdevname(refdev->bdev, b2));
 			goto abort;
 		}
 		ev1 = md_event(sb);
@@ -1410,13 +1418,13 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 		return -EINVAL;
 
 	if (calc_sb_1_csum(sb) != sb->sb_csum) {
-		printk("md: invalid superblock checksum on %s\n",
+		pr_warn("md: invalid superblock checksum on %s\n",
 			bdevname(rdev->bdev,b));
 		return -EINVAL;
 	}
 	if (le64_to_cpu(sb->data_size) < 10) {
-		printk("md: data_size too small on %s\n",
-		       bdevname(rdev->bdev,b));
+		pr_warn("md: data_size too small on %s\n",
+			bdevname(rdev->bdev,b));
 		return -EINVAL;
 	}
 	if (sb->pad0 ||
@@ -1500,8 +1508,7 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 		    sb->level != refsb->level ||
 		    sb->layout != refsb->layout ||
 		    sb->chunksize != refsb->chunksize) {
-			printk(KERN_WARNING "md: %s has strangely different"
-				" superblock to %s\n",
+			pr_warn("md: %s has strangely different superblock to %s\n",
 				bdevname(rdev->bdev,b),
 				bdevname(refdev->bdev,b2));
 			return -EINVAL;
@@ -1643,8 +1650,7 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 		case MD_DISK_ROLE_JOURNAL: /* journal device */
 			if (!(le32_to_cpu(sb->feature_map) & MD_FEATURE_JOURNAL)) {
 				/* journal device without journal feature */
-				printk(KERN_WARNING
-				  "md: journal device provided without journal feature, ignoring the device\n");
+				pr_warn("md: journal device provided without journal feature, ignoring the device\n");
 				return -EINVAL;
 			}
 			set_bit(Journal, &rdev->flags);
@@ -2001,9 +2007,9 @@ int md_integrity_register(struct mddev *mddev)
 	blk_integrity_register(mddev->gendisk,
 			       bdev_get_integrity(reference->bdev));
 
-	printk(KERN_NOTICE "md: data integrity enabled on %s\n", mdname(mddev));
+	pr_debug("md: data integrity enabled on %s\n", mdname(mddev));
 	if (bioset_integrity_create(mddev->bio_set, BIO_POOL_SIZE)) {
-		printk(KERN_ERR "md: failed to create integrity pool for %s\n",
+		pr_err("md: failed to create integrity pool for %s\n",
 		       mdname(mddev));
 		return -EINVAL;
 	}
@@ -2031,8 +2037,8 @@ int md_integrity_add_rdev(struct md_rdev *rdev, struct mddev *mddev)
 		return 0;
 
 	if (blk_integrity_compare(mddev->gendisk, rdev->bdev->bd_disk) != 0) {
-		printk(KERN_NOTICE "%s: incompatible integrity profile for %s\n",
-				mdname(mddev), bdevname(rdev->bdev, name));
+		pr_err("%s: incompatible integrity profile for %s\n",
+		       mdname(mddev), bdevname(rdev->bdev, name));
 		return -ENXIO;
 	}
 
@@ -2086,15 +2092,15 @@ static int bind_rdev_to_array(struct md_rdev *rdev, struct mddev *mddev)
 	rcu_read_unlock();
 	if (!test_bit(Journal, &rdev->flags) &&
 	    mddev->max_disks && rdev->desc_nr >= mddev->max_disks) {
-		printk(KERN_WARNING "md: %s: array is limited to %d devices\n",
-		       mdname(mddev), mddev->max_disks);
+		pr_warn("md: %s: array is limited to %d devices\n",
+			mdname(mddev), mddev->max_disks);
 		return -EBUSY;
 	}
 	bdevname(rdev->bdev,b);
 	strreplace(b, '/', '!');
 
 	rdev->mddev = mddev;
-	printk(KERN_INFO "md: bind<%s>\n", b);
+	pr_debug("md: bind<%s>\n", b);
 
 	if ((err = kobject_add(&rdev->kobj, &mddev->kobj, "dev-%s", b)))
 		goto fail;
@@ -2113,8 +2119,8 @@ static int bind_rdev_to_array(struct md_rdev *rdev, struct mddev *mddev)
 	return 0;
 
  fail:
-	printk(KERN_WARNING "md: failed to register dev-%s for %s\n",
-	       b, mdname(mddev));
+	pr_warn("md: failed to register dev-%s for %s\n",
+		b, mdname(mddev));
 	return err;
 }
 
@@ -2131,7 +2137,7 @@ static void unbind_rdev_from_array(struct md_rdev *rdev)
 
 	bd_unlink_disk_holder(rdev->bdev, rdev->mddev->gendisk);
 	list_del_rcu(&rdev->same_set);
-	printk(KERN_INFO "md: unbind<%s>\n", bdevname(rdev->bdev,b));
+	pr_debug("md: unbind<%s>\n", bdevname(rdev->bdev,b));
 	rdev->mddev = NULL;
 	sysfs_remove_link(&rdev->kobj, "block");
 	sysfs_put(rdev->sysfs_state);
@@ -2161,8 +2167,7 @@ static int lock_rdev(struct md_rdev *rdev, dev_t dev, int shared)
 	bdev = blkdev_get_by_dev(dev, FMODE_READ|FMODE_WRITE|FMODE_EXCL,
 				 shared ? (struct md_rdev *)lock_rdev : rdev);
 	if (IS_ERR(bdev)) {
-		printk(KERN_ERR "md: could not open %s.\n",
-			__bdevname(dev, b));
+		pr_warn("md: could not open %s.\n", __bdevname(dev, b));
 		return PTR_ERR(bdev);
 	}
 	rdev->bdev = bdev;
@@ -2182,8 +2187,7 @@ static void export_rdev(struct md_rdev *rdev)
 {
 	char b[BDEVNAME_SIZE];
 
-	printk(KERN_INFO "md: export_rdev(%s)\n",
-		bdevname(rdev->bdev,b));
+	pr_debug("md: export_rdev(%s)\n", bdevname(rdev->bdev,b));
 	md_rdev_clear(rdev);
 #ifndef MODULE
 	if (test_bit(AutoDetected, &rdev->flags))
@@ -3208,10 +3212,8 @@ static struct md_rdev *md_import_device(dev_t newdev, int super_format, int supe
 	sector_t size;
 
 	rdev = kzalloc(sizeof(*rdev), GFP_KERNEL);
-	if (!rdev) {
-		printk(KERN_ERR "md: could not alloc mem for new device!\n");
+	if (!rdev)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	err = md_rdev_init(rdev);
 	if (err)
@@ -3228,8 +3230,7 @@ static struct md_rdev *md_import_device(dev_t newdev, int super_format, int supe
 
 	size = i_size_read(rdev->bdev->bd_inode) >> BLOCK_SIZE_BITS;
 	if (!size) {
-		printk(KERN_WARNING
-			"md: %s has zero or unknown size, marking faulty!\n",
+		pr_warn("md: %s has zero or unknown size, marking faulty!\n",
 			bdevname(rdev->bdev,b));
 		err = -EINVAL;
 		goto abort_free;
@@ -3239,16 +3240,13 @@ static struct md_rdev *md_import_device(dev_t newdev, int super_format, int supe
 		err = super_types[super_format].
 			load_super(rdev, NULL, super_minor);
 		if (err == -EINVAL) {
-			printk(KERN_WARNING
-				"md: %s does not have a valid v%d.%d "
-			       "superblock, not importing!\n",
+			pr_warn("md: %s does not have a valid v%d.%d superblock, not importing!\n",
 				bdevname(rdev->bdev,b),
-			       super_format, super_minor);
+				super_format, super_minor);
 			goto abort_free;
 		}
 		if (err < 0) {
-			printk(KERN_WARNING
-				"md: could not read %s's sb, not importing!\n",
+			pr_warn("md: could not read %s's sb, not importing!\n",
 				bdevname(rdev->bdev,b));
 			goto abort_free;
 		}
@@ -3284,9 +3282,7 @@ static void analyze_sbs(struct mddev *mddev)
 		case 0:
 			break;
 		default:
-			printk( KERN_ERR \
-				"md: fatal superblock inconsistency in %s"
-				" -- removing from array\n",
+			pr_warn("md: fatal superblock inconsistency in %s -- removing from array\n",
 				bdevname(rdev->bdev,b));
 			md_kick_rdev_from_array(rdev);
 		}
@@ -3299,18 +3295,16 @@ static void analyze_sbs(struct mddev *mddev)
 		if (mddev->max_disks &&
 		    (rdev->desc_nr >= mddev->max_disks ||
 		     i > mddev->max_disks)) {
-			printk(KERN_WARNING
-			       "md: %s: %s: only %d devices permitted\n",
-			       mdname(mddev), bdevname(rdev->bdev, b),
-			       mddev->max_disks);
+			pr_warn("md: %s: %s: only %d devices permitted\n",
+				mdname(mddev), bdevname(rdev->bdev, b),
+				mddev->max_disks);
 			md_kick_rdev_from_array(rdev);
 			continue;
 		}
 		if (rdev != freshest) {
 			if (super_types[mddev->major_version].
 			    validate_super(mddev, rdev)) {
-				printk(KERN_WARNING "md: kicking non-fresh %s"
-					" from array!\n",
+				pr_warn("md: kicking non-fresh %s from array!\n",
 					bdevname(rdev->bdev,b));
 				md_kick_rdev_from_array(rdev);
 				continue;
@@ -3381,7 +3375,7 @@ safe_delay_store(struct mddev *mddev, const char *cbuf, size_t len)
 	unsigned long msec;
 
 	if (mddev_is_clustered(mddev)) {
-		pr_info("md: Safemode is disabled for clustered mode\n");
+		pr_warn("md: Safemode is disabled for clustered mode\n");
 		return -EINVAL;
 	}
 
@@ -3469,8 +3463,8 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 
 	rv = -EINVAL;
 	if (!mddev->pers->quiesce) {
-		printk(KERN_WARNING "md: %s: %s does not support online personality change\n",
-		       mdname(mddev), mddev->pers->name);
+		pr_warn("md: %s: %s does not support online personality change\n",
+			mdname(mddev), mddev->pers->name);
 		goto out_unlock;
 	}
 
@@ -3488,7 +3482,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 	pers = find_pers(level, clevel);
 	if (!pers || !try_module_get(pers->owner)) {
 		spin_unlock(&pers_lock);
-		printk(KERN_WARNING "md: personality %s not loaded\n", clevel);
+		pr_warn("md: personality %s not loaded\n", clevel);
 		rv = -EINVAL;
 		goto out_unlock;
 	}
@@ -3502,8 +3496,8 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 	}
 	if (!pers->takeover) {
 		module_put(pers->owner);
-		printk(KERN_WARNING "md: %s: %s does not support personality takeover\n",
-		       mdname(mddev), clevel);
+		pr_warn("md: %s: %s does not support personality takeover\n",
+			mdname(mddev), clevel);
 		rv = -EINVAL;
 		goto out_unlock;
 	}
@@ -3523,8 +3517,8 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 		mddev->delta_disks = 0;
 		mddev->reshape_backwards = 0;
 		module_put(pers->owner);
-		printk(KERN_WARNING "md: %s: %s would not accept array\n",
-		       mdname(mddev), clevel);
+		pr_warn("md: %s: %s would not accept array\n",
+			mdname(mddev), clevel);
 		rv = PTR_ERR(priv);
 		goto out_unlock;
 	}
@@ -3567,9 +3561,8 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 	    pers->sync_request != NULL) {
 		/* need to add the md_redundancy_group */
 		if (sysfs_create_group(&mddev->kobj, &md_redundancy_group))
-			printk(KERN_WARNING
-			       "md: cannot register extra attributes for %s\n",
-			       mdname(mddev));
+			pr_warn("md: cannot register extra attributes for %s\n",
+				mdname(mddev));
 		mddev->sysfs_action = sysfs_get_dirent(mddev->kobj.sd, "sync_action");
 	}
 	if (oldpers->sync_request != NULL &&
@@ -3600,9 +3593,8 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 			clear_bit(In_sync, &rdev->flags);
 		else {
 			if (sysfs_link_rdev(mddev, rdev))
-				printk(KERN_WARNING "md: cannot register rd%d"
-				       " for %s after level change\n",
-				       rdev->raid_disk, mdname(mddev));
+				pr_warn("md: cannot register rd%d for %s after level change\n",
+					rdev->raid_disk, mdname(mddev));
 		}
 	}
 
@@ -5068,13 +5060,13 @@ static int md_alloc(dev_t dev, char *name)
 		/* This isn't possible, but as kobject_init_and_add is marked
 		 * __must_check, we must do something with the result
 		 */
-		printk(KERN_WARNING "md: cannot register %s/md - name in use\n",
-		       disk->disk_name);
+		pr_debug("md: cannot register %s/md - name in use\n",
+			 disk->disk_name);
 		error = 0;
 	}
 	if (mddev->kobj.sd &&
 	    sysfs_create_group(&mddev->kobj, &md_bitmap_group))
-		printk(KERN_DEBUG "pointless warning\n");
+		pr_debug("pointless warning\n");
 	mutex_unlock(&mddev->open_mutex);
  abort:
 	mutex_unlock(&disks_mutex);
@@ -5176,15 +5168,15 @@ int md_run(struct mddev *mddev)
 			if (mddev->dev_sectors &&
 			    rdev->data_offset + mddev->dev_sectors
 			    > rdev->sb_start) {
-				printk("md: %s: data overlaps metadata\n",
-				       mdname(mddev));
+				pr_warn("md: %s: data overlaps metadata\n",
+					mdname(mddev));
 				return -EINVAL;
 			}
 		} else {
 			if (rdev->sb_start + rdev->sb_size/512
 			    > rdev->data_offset) {
-				printk("md: %s: metadata overlaps data\n",
-				       mdname(mddev));
+				pr_warn("md: %s: metadata overlaps data\n",
+					mdname(mddev));
 				return -EINVAL;
 			}
 		}
@@ -5199,11 +5191,11 @@ int md_run(struct mddev *mddev)
 	if (!pers || !try_module_get(pers->owner)) {
 		spin_unlock(&pers_lock);
 		if (mddev->level != LEVEL_NONE)
-			printk(KERN_WARNING "md: personality for level %d is not loaded!\n",
-			       mddev->level);
+			pr_warn("md: personality for level %d is not loaded!\n",
+				mddev->level);
 		else
-			printk(KERN_WARNING "md: personality for level %s is not loaded!\n",
-			       mddev->clevel);
+			pr_warn("md: personality for level %s is not loaded!\n",
+				mddev->clevel);
 		return -EINVAL;
 	}
 	spin_unlock(&pers_lock);
@@ -5233,21 +5225,16 @@ int md_run(struct mddev *mddev)
 				if (rdev < rdev2 &&
 				    rdev->bdev->bd_contains ==
 				    rdev2->bdev->bd_contains) {
-					printk(KERN_WARNING
-					       "%s: WARNING: %s appears to be"
-					       " on the same physical disk as"
-					       " %s.\n",
-					       mdname(mddev),
-					       bdevname(rdev->bdev,b),
-					       bdevname(rdev2->bdev,b2));
+					pr_warn("%s: WARNING: %s appears to be on the same physical disk as %s.\n",
+						mdname(mddev),
+						bdevname(rdev->bdev,b),
+						bdevname(rdev2->bdev,b2));
 					warned = 1;
 				}
 			}
 
 		if (warned)
-			printk(KERN_WARNING
-			       "True protection against single-disk"
-			       " failure might be compromised.\n");
+			pr_warn("True protection against single-disk failure might be compromised.\n");
 	}
 
 	mddev->recovery = 0;
@@ -5261,14 +5248,14 @@ int md_run(struct mddev *mddev)
 
 	err = pers->run(mddev);
 	if (err)
-		printk(KERN_ERR "md: pers->run() failed ...\n");
+		pr_warn("md: pers->run() failed ...\n");
 	else if (pers->size(mddev, 0, 0) < mddev->array_sectors) {
-		WARN_ONCE(!mddev->external_size, "%s: default size too small,"
-			  " but 'external_size' not in effect?\n", __func__);
-		printk(KERN_ERR
-		       "md: invalid array_size %llu > default size %llu\n",
-		       (unsigned long long)mddev->array_sectors / 2,
-		       (unsigned long long)pers->size(mddev, 0, 0) / 2);
+		WARN_ONCE(!mddev->external_size,
+			  "%s: default size too small, but 'external_size' not in effect?\n",
+			  __func__);
+		pr_warn("md: invalid array_size %llu > default size %llu\n",
+			(unsigned long long)mddev->array_sectors / 2,
+			(unsigned long long)pers->size(mddev, 0, 0) / 2);
 		err = -EINVAL;
 	}
 	if (err == 0 && pers->sync_request &&
@@ -5278,8 +5265,8 @@ int md_run(struct mddev *mddev)
 		bitmap = bitmap_create(mddev, -1);
 		if (IS_ERR(bitmap)) {
 			err = PTR_ERR(bitmap);
-			printk(KERN_ERR "%s: failed to create bitmap (%d)\n",
-			       mdname(mddev), err);
+			pr_warn("%s: failed to create bitmap (%d)\n",
+				mdname(mddev), err);
 		} else
 			mddev->bitmap = bitmap;
 
@@ -5315,9 +5302,8 @@ int md_run(struct mddev *mddev)
 	if (pers->sync_request) {
 		if (mddev->kobj.sd &&
 		    sysfs_create_group(&mddev->kobj, &md_redundancy_group))
-			printk(KERN_WARNING
-			       "md: cannot register extra attributes for %s\n",
-			       mdname(mddev));
+			pr_warn("md: cannot register extra attributes for %s\n",
+				mdname(mddev));
 		mddev->sysfs_action = sysfs_get_dirent_safe(mddev->kobj.sd, "sync_action");
 	} else if (mddev->ro == 2) /* auto-readonly not meaningful */
 		mddev->ro = 0;
@@ -5418,8 +5404,7 @@ static int restart_array(struct mddev *mddev)
 	mddev->safemode = 0;
 	mddev->ro = 0;
 	set_disk_ro(disk, 0);
-	printk(KERN_INFO "md: %s switched to read-write mode.\n",
-		mdname(mddev));
+	pr_debug("md: %s switched to read-write mode.\n", mdname(mddev));
 	/* Kick recovery or resync if necessary */
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
@@ -5513,8 +5498,8 @@ static void mddev_detach(struct mddev *mddev)
 	struct bitmap *bitmap = mddev->bitmap;
 	/* wait for behind writes to complete */
 	if (bitmap && atomic_read(&bitmap->behind_writes) > 0) {
-		printk(KERN_INFO "md:%s: behind writes in progress - waiting to stop.\n",
-		       mdname(mddev));
+		pr_debug("md:%s: behind writes in progress - waiting to stop.\n",
+			 mdname(mddev));
 		/* need to kick something here to make sure I/O goes? */
 		wait_event(bitmap->behind_wait,
 			   atomic_read(&bitmap->behind_writes) == 0);
@@ -5588,7 +5573,7 @@ static int md_set_readonly(struct mddev *mddev, struct block_device *bdev)
 	if ((mddev->pers && atomic_read(&mddev->openers) > !!bdev) ||
 	    mddev->sync_thread ||
 	    test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
-		printk("md: %s still in use.\n",mdname(mddev));
+		pr_warn("md: %s still in use.\n",mdname(mddev));
 		if (did_freeze) {
 			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
@@ -5650,7 +5635,7 @@ static int do_md_stop(struct mddev *mddev, int mode,
 	    mddev->sysfs_active ||
 	    mddev->sync_thread ||
 	    test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
-		printk("md: %s still in use.\n",mdname(mddev));
+		pr_warn("md: %s still in use.\n",mdname(mddev));
 		mutex_unlock(&mddev->open_mutex);
 		if (did_freeze) {
 			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
@@ -5687,7 +5672,7 @@ static int do_md_stop(struct mddev *mddev, int mode,
 	 * Free resources if final stop
 	 */
 	if (mode == 0) {
-		printk(KERN_INFO "md: %s stopped.\n", mdname(mddev));
+		pr_info("md: %s stopped.\n", mdname(mddev));
 
 		bitmap_destroy(mddev);
 		if (mddev->bitmap_info.file) {
@@ -5719,17 +5704,17 @@ static void autorun_array(struct mddev *mddev)
 	if (list_empty(&mddev->disks))
 		return;
 
-	printk(KERN_INFO "md: running: ");
+	pr_info("md: running: ");
 
 	rdev_for_each(rdev, mddev) {
 		char b[BDEVNAME_SIZE];
-		printk("<%s>", bdevname(rdev->bdev,b));
+		pr_cont("<%s>", bdevname(rdev->bdev,b));
 	}
-	printk("\n");
+	pr_cont("\n");
 
 	err = do_md_run(mddev);
 	if (err) {
-		printk(KERN_WARNING "md: do_md_run() returned %d\n", err);
+		pr_warn("md: do_md_run() returned %d\n", err);
 		do_md_stop(mddev, 0, NULL);
 	}
 }
@@ -5752,7 +5737,7 @@ static void autorun_devices(int part)
 	struct mddev *mddev;
 	char b[BDEVNAME_SIZE];
 
-	printk(KERN_INFO "md: autorun ...\n");
+	pr_info("md: autorun ...\n");
 	while (!list_empty(&pending_raid_disks)) {
 		int unit;
 		dev_t dev;
@@ -5760,13 +5745,12 @@ static void autorun_devices(int part)
 		rdev0 = list_entry(pending_raid_disks.next,
 					 struct md_rdev, same_set);
 
-		printk(KERN_INFO "md: considering %s ...\n",
-			bdevname(rdev0->bdev,b));
+		pr_debug("md: considering %s ...\n", bdevname(rdev0->bdev,b));
 		INIT_LIST_HEAD(&candidates);
 		rdev_for_each_list(rdev, tmp, &pending_raid_disks)
 			if (super_90_load(rdev, rdev0, 0) >= 0) {
-				printk(KERN_INFO "md:  adding %s ...\n",
-					bdevname(rdev->bdev,b));
+				pr_debug("md:  adding %s ...\n",
+					 bdevname(rdev->bdev,b));
 				list_move(&rdev->same_set, &candidates);
 			}
 		/*
@@ -5783,8 +5767,8 @@ static void autorun_devices(int part)
 			unit = MINOR(dev);
 		}
 		if (rdev0->preferred_minor != unit) {
-			printk(KERN_INFO "md: unit number in %s is bad: %d\n",
-			       bdevname(rdev0->bdev, b), rdev0->preferred_minor);
+			pr_warn("md: unit number in %s is bad: %d\n",
+				bdevname(rdev0->bdev, b), rdev0->preferred_minor);
 			break;
 		}
 
@@ -5793,21 +5777,17 @@ static void autorun_devices(int part)
 		if (!mddev || !mddev->gendisk) {
 			if (mddev)
 				mddev_put(mddev);
-			printk(KERN_ERR
-				"md: cannot allocate memory for md drive.\n");
 			break;
 		}
 		if (mddev_lock(mddev))
-			printk(KERN_WARNING "md: %s locked, cannot run\n",
-			       mdname(mddev));
+			pr_warn("md: %s locked, cannot run\n", mdname(mddev));
 		else if (mddev->raid_disks || mddev->major_version
 			 || !list_empty(&mddev->disks)) {
-			printk(KERN_WARNING
-				"md: %s already running, cannot run %s\n",
+			pr_warn("md: %s already running, cannot run %s\n",
 				mdname(mddev), bdevname(rdev0->bdev,b));
 			mddev_unlock(mddev);
 		} else {
-			printk(KERN_INFO "md: created %s\n", mdname(mddev));
+			pr_debug("md: created %s\n", mdname(mddev));
 			mddev->persistent = 1;
 			rdev_for_each_list(rdev, tmp, &candidates) {
 				list_del_init(&rdev->same_set);
@@ -5826,7 +5806,7 @@ static void autorun_devices(int part)
 		}
 		mddev_put(mddev);
 	}
-	printk(KERN_INFO "md: ... autorun DONE.\n");
+	pr_info("md: ... autorun DONE.\n");
 }
 #endif /* !MODULE */
 
@@ -5982,8 +5962,8 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 
 	if (mddev_is_clustered(mddev) &&
 		!(info->state & ((1 << MD_DISK_CLUSTER_ADD) | (1 << MD_DISK_CANDIDATE)))) {
-		pr_err("%s: Cannot add to clustered mddev.\n",
-			       mdname(mddev));
+		pr_warn("%s: Cannot add to clustered mddev.\n",
+			mdname(mddev));
 		return -EINVAL;
 	}
 
@@ -5995,8 +5975,7 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 		/* expecting a device which has a superblock */
 		rdev = md_import_device(dev, mddev->major_version, mddev->minor_version);
 		if (IS_ERR(rdev)) {
-			printk(KERN_WARNING
-				"md: md_import_device returned %ld\n",
+			pr_warn("md: md_import_device returned %ld\n",
 				PTR_ERR(rdev));
 			return PTR_ERR(rdev);
 		}
@@ -6007,8 +5986,7 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 			err = super_types[mddev->major_version]
 				.load_super(rdev, rdev0, mddev->minor_version);
 			if (err < 0) {
-				printk(KERN_WARNING
-					"md: %s has different UUID to %s\n",
+				pr_warn("md: %s has different UUID to %s\n",
 					bdevname(rdev->bdev,b),
 					bdevname(rdev0->bdev,b2));
 				export_rdev(rdev);
@@ -6029,9 +6007,8 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 	if (mddev->pers) {
 		int err;
 		if (!mddev->pers->hot_add_disk) {
-			printk(KERN_WARNING
-				"%s: personality does not support diskops!\n",
-			       mdname(mddev));
+			pr_warn("%s: personality does not support diskops!\n",
+				mdname(mddev));
 			return -EINVAL;
 		}
 		if (mddev->persistent)
@@ -6040,8 +6017,7 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 		else
 			rdev = md_import_device(dev, -1, -1);
 		if (IS_ERR(rdev)) {
-			printk(KERN_WARNING
-				"md: md_import_device returned %ld\n",
+			pr_warn("md: md_import_device returned %ld\n",
 				PTR_ERR(rdev));
 			return PTR_ERR(rdev);
 		}
@@ -6137,8 +6113,7 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 	 * for major_version==0 superblocks
 	 */
 	if (mddev->major_version != 0) {
-		printk(KERN_WARNING "%s: ADD_NEW_DISK not supported\n",
-		       mdname(mddev));
+		pr_warn("%s: ADD_NEW_DISK not supported\n", mdname(mddev));
 		return -EINVAL;
 	}
 
@@ -6146,8 +6121,7 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 		int err;
 		rdev = md_import_device(dev, -1, 0);
 		if (IS_ERR(rdev)) {
-			printk(KERN_WARNING
-				"md: error, md_import_device() returned %ld\n",
+			pr_warn("md: error, md_import_device() returned %ld\n",
 				PTR_ERR(rdev));
 			return PTR_ERR(rdev);
 		}
@@ -6165,7 +6139,7 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 			set_bit(WriteMostly, &rdev->flags);
 
 		if (!mddev->persistent) {
-			printk(KERN_INFO "md: nonpersistent superblock ...\n");
+			pr_debug("md: nonpersistent superblock ...\n");
 			rdev->sb_start = i_size_read(rdev->bdev->bd_inode) / 512;
 		} else
 			rdev->sb_start = calc_dev_sboffset(rdev);
@@ -6209,8 +6183,8 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 
 	return 0;
 busy:
-	printk(KERN_WARNING "md: cannot remove active disk %s from %s ...\n",
-		bdevname(rdev->bdev,b), mdname(mddev));
+	pr_debug("md: cannot remove active disk %s from %s ...\n",
+		 bdevname(rdev->bdev,b), mdname(mddev));
 	return -EBUSY;
 }
 
@@ -6224,22 +6198,19 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
 		return -ENODEV;
 
 	if (mddev->major_version != 0) {
-		printk(KERN_WARNING "%s: HOT_ADD may only be used with"
-			" version-0 superblocks.\n",
+		pr_warn("%s: HOT_ADD may only be used with version-0 superblocks.\n",
 			mdname(mddev));
 		return -EINVAL;
 	}
 	if (!mddev->pers->hot_add_disk) {
-		printk(KERN_WARNING
-			"%s: personality does not support diskops!\n",
+		pr_warn("%s: personality does not support diskops!\n",
 			mdname(mddev));
 		return -EINVAL;
 	}
 
 	rdev = md_import_device(dev, -1, 0);
 	if (IS_ERR(rdev)) {
-		printk(KERN_WARNING
-			"md: error, md_import_device() returned %ld\n",
+		pr_warn("md: error, md_import_device() returned %ld\n",
 			PTR_ERR(rdev));
 		return -EINVAL;
 	}
@@ -6252,8 +6223,7 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
 	rdev->sectors = rdev->sb_start;
 
 	if (test_bit(Faulty, &rdev->flags)) {
-		printk(KERN_WARNING
-			"md: can not hot-add faulty %s disk to %s!\n",
+		pr_warn("md: can not hot-add faulty %s disk to %s!\n",
 			bdevname(rdev->bdev,b), mdname(mddev));
 		err = -EINVAL;
 		goto abort_export;
@@ -6309,23 +6279,23 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 		f = fget(fd);
 
 		if (f == NULL) {
-			printk(KERN_ERR "%s: error: failed to get bitmap file\n",
-			       mdname(mddev));
+			pr_warn("%s: error: failed to get bitmap file\n",
+				mdname(mddev));
 			return -EBADF;
 		}
 
 		inode = f->f_mapping->host;
 		if (!S_ISREG(inode->i_mode)) {
-			printk(KERN_ERR "%s: error: bitmap file must be a regular file\n",
-			       mdname(mddev));
+			pr_warn("%s: error: bitmap file must be a regular file\n",
+				mdname(mddev));
 			err = -EBADF;
 		} else if (!(f->f_mode & FMODE_WRITE)) {
-			printk(KERN_ERR "%s: error: bitmap file must open for write\n",
-			       mdname(mddev));
+			pr_warn("%s: error: bitmap file must open for write\n",
+				mdname(mddev));
 			err = -EBADF;
 		} else if (atomic_read(&inode->i_writecount) != 1) {
-			printk(KERN_ERR "%s: error: bitmap file is already in use\n",
-			       mdname(mddev));
+			pr_warn("%s: error: bitmap file is already in use\n",
+				mdname(mddev));
 			err = -EBUSY;
 		}
 		if (err) {
@@ -6390,8 +6360,7 @@ static int set_array_info(struct mddev *mddev, mdu_array_info_t *info)
 		    info->major_version >= ARRAY_SIZE(super_types) ||
 		    super_types[info->major_version].name == NULL) {
 			/* maybe try to auto-load a module? */
-			printk(KERN_INFO
-				"md: superblock version %d not known\n",
+			pr_warn("md: superblock version %d not known\n",
 				info->major_version);
 			return -EINVAL;
 		}
@@ -6657,8 +6626,7 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 			if (mddev->bitmap_info.nodes) {
 				/* hold PW on all the bitmap lock */
 				if (md_cluster_ops->lock_all_bitmaps(mddev) <= 0) {
-					printk("md: can't change bitmap to none since the"
-					       " array is in use by more than one node\n");
+					pr_warn("md: can't change bitmap to none since the array is in use by more than one node\n");
 					rv = -EPERM;
 					md_cluster_ops->unlock_all_bitmaps(mddev);
 					goto err;
@@ -6844,9 +6812,8 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 	}
 	err = mddev_lock(mddev);
 	if (err) {
-		printk(KERN_INFO
-			"md: ioctl lock interrupted, reason %d, cmd %d\n",
-			err, cmd);
+		pr_debug("md: ioctl lock interrupted, reason %d, cmd %d\n",
+			 err, cmd);
 		goto out;
 	}
 
@@ -6861,30 +6828,24 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 		if (mddev->pers) {
 			err = update_array_info(mddev, &info);
 			if (err) {
-				printk(KERN_WARNING "md: couldn't update"
-				       " array info. %d\n", err);
+				pr_warn("md: couldn't update array info. %d\n", err);
 				goto unlock;
 			}
 			goto unlock;
 		}
 		if (!list_empty(&mddev->disks)) {
-			printk(KERN_WARNING
-			       "md: array %s already has disks!\n",
-			       mdname(mddev));
+			pr_warn("md: array %s already has disks!\n", mdname(mddev));
 			err = -EBUSY;
 			goto unlock;
 		}
 		if (mddev->raid_disks) {
-			printk(KERN_WARNING
-			       "md: array %s already initialised!\n",
-			       mdname(mddev));
+			pr_warn("md: array %s already initialised!\n", mdname(mddev));
 			err = -EBUSY;
 			goto unlock;
 		}
 		err = set_array_info(mddev, &info);
 		if (err) {
-			printk(KERN_WARNING "md: couldn't set"
-			       " array info. %d\n", err);
+			pr_warn("md: couldn't set array info. %d\n", err);
 			goto unlock;
 		}
 		goto unlock;
@@ -7585,8 +7546,8 @@ static const struct file_operations md_seq_fops = {
 
 int register_md_personality(struct md_personality *p)
 {
-	printk(KERN_INFO "md: %s personality registered for level %d\n",
-						p->name, p->level);
+	pr_debug("md: %s personality registered for level %d\n",
+		 p->name, p->level);
 	spin_lock(&pers_lock);
 	list_add_tail(&p->list, &pers_list);
 	spin_unlock(&pers_lock);
@@ -7596,7 +7557,7 @@ EXPORT_SYMBOL(register_md_personality);
 
 int unregister_md_personality(struct md_personality *p)
 {
-	printk(KERN_INFO "md: %s personality unregistered\n", p->name);
+	pr_debug("md: %s personality unregistered\n", p->name);
 	spin_lock(&pers_lock);
 	list_del_init(&p->list);
 	spin_unlock(&pers_lock);
@@ -7636,7 +7597,7 @@ int md_setup_cluster(struct mddev *mddev, int nodes)
 	spin_lock(&pers_lock);
 	/* ensure module won't be unloaded */
 	if (!md_cluster_ops || !try_module_get(md_cluster_mod)) {
-		pr_err("can't find md-cluster module or get it's reference.\n");
+		pr_warn("can't find md-cluster module or get it's reference.\n");
 		spin_unlock(&pers_lock);
 		return -ENOENT;
 	}
@@ -7911,11 +7872,9 @@ void md_do_sync(struct md_thread *thread)
 				    mddev2->curr_resync >= mddev->curr_resync) {
 					if (mddev2_minor != mddev2->md_minor) {
 						mddev2_minor = mddev2->md_minor;
-						printk(KERN_INFO "md: delaying %s of %s"
-						       " until %s has finished (they"
-						       " share one or more physical units)\n",
-						       desc, mdname(mddev),
-						       mdname(mddev2));
+						pr_info("md: delaying %s of %s until %s has finished (they share one or more physical units)\n",
+							desc, mdname(mddev),
+							mdname(mddev2));
 					}
 					mddev_put(mddev2);
 					if (signal_pending(current))
@@ -7972,12 +7931,10 @@ void md_do_sync(struct md_thread *thread)
 		}
 	}
 
-	printk(KERN_INFO "md: %s of RAID array %s\n", desc, mdname(mddev));
-	printk(KERN_INFO "md: minimum _guaranteed_  speed:"
-		" %d KB/sec/disk.\n", speed_min(mddev));
-	printk(KERN_INFO "md: using maximum available idle IO bandwidth "
-	       "(but not more than %d KB/sec) for %s.\n",
-	       speed_max(mddev), desc);
+	pr_info("md: %s of RAID array %s\n", desc, mdname(mddev));
+	pr_debug("md: minimum _guaranteed_  speed: %d KB/sec/disk.\n", speed_min(mddev));
+	pr_debug("md: using maximum available idle IO bandwidth (but not more than %d KB/sec) for %s.\n",
+		 speed_max(mddev), desc);
 
 	is_mddev_idle(mddev, 1); /* this initializes IO event counters */
 
@@ -7994,16 +7951,15 @@ void md_do_sync(struct md_thread *thread)
 	 * Tune reconstruction:
 	 */
 	window = 32*(PAGE_SIZE/512);
-	printk(KERN_INFO "md: using %dk window, over a total of %lluk.\n",
-		window/2, (unsigned long long)max_sectors/2);
+	pr_debug("md: using %dk window, over a total of %lluk.\n",
+		 window/2, (unsigned long long)max_sectors/2);
 
 	atomic_set(&mddev->recovery_active, 0);
 	last_check = 0;
 
 	if (j>2) {
-		printk(KERN_INFO
-		       "md: resuming %s of %s from checkpoint.\n",
-		       desc, mdname(mddev));
+		pr_debug("md: resuming %s of %s from checkpoint.\n",
+			 desc, mdname(mddev));
 		mddev->curr_resync = j;
 	} else
 		mddev->curr_resync = 3; /* no longer delayed */
@@ -8130,9 +8086,9 @@ void md_do_sync(struct md_thread *thread)
 			}
 		}
 	}
-	printk(KERN_INFO "md: %s: %s %s.\n",mdname(mddev), desc,
-	       test_bit(MD_RECOVERY_INTR, &mddev->recovery)
-	       ? "interrupted" : "done");
+	pr_info("md: %s: %s %s.\n",mdname(mddev), desc,
+		test_bit(MD_RECOVERY_INTR, &mddev->recovery)
+		? "interrupted" : "done");
 	/*
 	 * this also signals 'finished resyncing' to md_stop
 	 */
@@ -8152,9 +8108,8 @@ void md_do_sync(struct md_thread *thread)
 		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
 			if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
 				if (mddev->curr_resync >= mddev->recovery_cp) {
-					printk(KERN_INFO
-					       "md: checkpointing %s of %s.\n",
-					       desc, mdname(mddev));
+					pr_debug("md: checkpointing %s of %s.\n",
+						 desc, mdname(mddev));
 					if (test_bit(MD_RECOVERY_ERROR,
 						&mddev->recovery))
 						mddev->recovery_cp =
@@ -8302,8 +8257,8 @@ static void md_start_sync(struct work_struct *ws)
 						mddev,
 						"resync");
 	if (!mddev->sync_thread) {
-		printk(KERN_ERR "%s: could not start resync thread...\n",
-		       mdname(mddev));
+		pr_warn("%s: could not start resync thread...\n",
+			mdname(mddev));
 		/* leave the spares where they are, it shouldn't hurt */
 		clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 		clear_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
@@ -8353,8 +8308,8 @@ void md_check_recovery(struct mddev *mddev)
 
 	if (signal_pending(current)) {
 		if (mddev->pers->sync_request && !mddev->external) {
-			printk(KERN_INFO "md: %s in immediate safe mode\n",
-			       mdname(mddev));
+			pr_debug("md: %s in immediate safe mode\n",
+				 mdname(mddev));
 			mddev->safemode = 2;
 		}
 		flush_signals(current);
@@ -8746,7 +8701,7 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 				rdev2->saved_raid_disk = role;
 				ret = remove_and_add_spares(mddev, rdev2);
 				pr_info("Activated spare: %s\n",
-						bdevname(rdev2->bdev,b));
+					bdevname(rdev2->bdev,b));
 				/* wakeup mddev->thread here, so array could
 				 * perform resync with the new activated disk */
 				set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
@@ -8871,9 +8826,6 @@ void md_autodetect_dev(dev_t dev)
 		mutex_lock(&detected_devices_mutex);
 		list_add_tail(&node_detected_dev->list, &all_detected_devices);
 		mutex_unlock(&detected_devices_mutex);
-	} else {
-		printk(KERN_CRIT "md: md_autodetect_dev: kzalloc failed"
-			", skipping dev(%d,%d)\n", MAJOR(dev), MINOR(dev));
 	}
 }
 
@@ -8887,7 +8839,7 @@ static void autostart_arrays(int part)
 	i_scanned = 0;
 	i_passed = 0;
 
-	printk(KERN_INFO "md: Autodetecting RAID arrays.\n");
+	pr_info("md: Autodetecting RAID arrays.\n");
 
 	mutex_lock(&detected_devices_mutex);
 	while (!list_empty(&all_detected_devices) && i_scanned < INT_MAX) {
@@ -8912,8 +8864,7 @@ static void autostart_arrays(int part)
 	}
 	mutex_unlock(&detected_devices_mutex);
 
-	printk(KERN_INFO "md: Scanned %d and added %d devices.\n",
-						i_scanned, i_passed);
+	pr_debug("md: Scanned %d and added %d devices.\n", i_scanned, i_passed);
 
 	autorun_devices(part);
 }


