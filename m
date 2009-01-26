From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 2/2] md: Represent raid device size in sectors.
Date: Mon, 26 Jan 2009 16:14:12 +0100
Message-ID: <1232982852-32747-3-git-send-email-maan@systemlinux.org>
References: <1232982852-32747-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1232982852-32747-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: LinuxRaid <linux-raid@vger.kernel.org>, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

This patch renames the "size" field of struct mdk_rdev_s to
"num_sectors" and changes this field to store sectors instead of
blocks.

All users of this field, linear.c, raid0.c and md.c, are fixed up
accordingly which gets rid of many multiplications and divisions.

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/linear.c       |    4 +-
 drivers/md/md.c           |   96 ++++++++++++++++++++++----------------------
 drivers/md/raid0.c        |   41 +++++++++----------
 include/linux/raid/md_k.h |    2 +-
 4 files changed, 71 insertions(+), 72 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 09658b2..83110f8 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -135,8 +135,8 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
 		    mddev->queue->max_sectors > (PAGE_SIZE>>9))
 			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
 
-		disk->num_sectors = rdev->size * 2;
-		conf->array_sectors += rdev->size * 2;
+		disk->num_sectors = rdev->sectors;
+		conf->array_sectors += rdev->sectors;
 
 		cnt++;
 	}
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4e04804..359c842 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -414,7 +414,7 @@ static void free_disk_sb(mdk_rdev_t * rdev)
 		rdev->sb_loaded = 0;
 		rdev->sb_page = NULL;
 		rdev->sb_start = 0;
-		rdev->size = 0;
+		rdev->sectors = 0;
 	}
 }
 
@@ -780,9 +780,9 @@ static int super_90_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version
 		else 
 			ret = 0;
 	}
-	rdev->size = calc_num_sectors(rdev, sb->chunk_size) / 2;
+	rdev->sectors = calc_num_sectors(rdev, sb->chunk_size);
 
-	if (rdev->size < sb->size && sb->level > 1)
+	if (rdev->sectors < sb->size * 2 && sb->level > 1)
 		/* "this cannot possibly happen" ... */
 		ret = -EINVAL;
 
@@ -1185,16 +1185,17 @@ static int super_1_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version)
 			ret = 0;
 	}
 	if (minor_version)
-		rdev->size = ((rdev->bdev->bd_inode->i_size>>9) - le64_to_cpu(sb->data_offset)) / 2;
+		rdev->sectors = (rdev->bdev->bd_inode->i_size >> 9) -
+			le64_to_cpu(sb->data_offset);
 	else
-		rdev->size = rdev->sb_start / 2;
-	if (rdev->size < le64_to_cpu(sb->data_size)/2)
+		rdev->sectors = rdev->sb_start;
+	if (rdev->sectors < le64_to_cpu(sb->data_size))
 		return -EINVAL;
-	rdev->size = le64_to_cpu(sb->data_size)/2;
+	rdev->sectors = le64_to_cpu(sb->data_size);
 	if (le32_to_cpu(sb->chunksize))
-		rdev->size &= ~((sector_t)le32_to_cpu(sb->chunksize)/2 - 1);
+		rdev->sectors &= ~((sector_t)le32_to_cpu(sb->chunksize) - 1);
 
-	if (le64_to_cpu(sb->size) > rdev->size*2)
+	if (le64_to_cpu(sb->size) > rdev->sectors)
 		return -EINVAL;
 	return ret;
 }
@@ -1386,7 +1387,7 @@ super_1_rdev_size_change(mdk_rdev_t *rdev, sector_t num_sectors)
 		sector_t sb_start;
 		sb_start = (rdev->bdev->bd_inode->i_size >> 9) - 8*2;
 		sb_start &= ~(sector_t)(4*2 - 1);
-		max_sectors = rdev->size * 2 + sb_start - rdev->sb_start;
+		max_sectors = rdev->sectors + sb_start - rdev->sb_start;
 		if (!num_sectors || num_sectors > max_sectors)
 			num_sectors = max_sectors;
 		rdev->sb_start = sb_start;
@@ -1454,9 +1455,9 @@ static int bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
 	if (find_rdev(mddev, rdev->bdev->bd_dev))
 		return -EEXIST;
 
-	/* make sure rdev->size exceeds mddev->dev_sectors / 2 */
-	if (rdev->size && (mddev->dev_sectors == 0 ||
-			rdev->size < mddev->dev_sectors / 2)) {
+	/* make sure rdev->sectors exceeds mddev->dev_sectors */
+	if (rdev->sectors && (mddev->dev_sectors == 0 ||
+			rdev->sectors < mddev->dev_sectors)) {
 		if (mddev->pers) {
 			/* Cannot change size, so fail
 			 * If mddev->level <= 0, then we don't care
@@ -1465,7 +1466,7 @@ static int bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
 			if (mddev->level > 0)
 				return -ENOSPC;
 		} else
-			mddev->dev_sectors = rdev->size * 2;
+			mddev->dev_sectors = rdev->sectors;
 	}
 
 	/* Verify rdev->desc_nr is unique.
@@ -1714,8 +1715,8 @@ static void print_sb_1(struct mdp_superblock_1 *sb)
 static void print_rdev(mdk_rdev_t *rdev, int major_version)
 {
 	char b[BDEVNAME_SIZE];
-	printk(KERN_INFO "md: rdev %s, SZ:%08llu F:%d S:%d DN:%u\n",
-		bdevname(rdev->bdev,b), (unsigned long long)rdev->size,
+	printk(KERN_INFO "md: rdev %s, Sect:%08llu F:%d S:%d DN:%u\n",
+		bdevname(rdev->bdev, b), (unsigned long long)rdev->sectors,
 	        test_bit(Faulty, &rdev->flags), test_bit(In_sync, &rdev->flags),
 	        rdev->desc_nr);
 	if (rdev->sb_loaded) {
@@ -2154,7 +2155,7 @@ offset_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 		return -EINVAL;
 	if (rdev->mddev->pers && rdev->raid_disk >= 0)
 		return -EBUSY;
-	if (rdev->size && rdev->mddev->external)
+	if (rdev->sectors && rdev->mddev->external)
 		/* Must set offset before size, so overlap checks
 		 * can be sane */
 		return -EBUSY;
@@ -2168,7 +2169,7 @@ __ATTR(offset, S_IRUGO|S_IWUSR, offset_show, offset_store);
 static ssize_t
 rdev_size_show(mdk_rdev_t *rdev, char *page)
 {
-	return sprintf(page, "%llu\n", (unsigned long long)rdev->size);
+	return sprintf(page, "%llu\n", (unsigned long long)rdev->sectors / 2);
 }
 
 static int overlaps(sector_t s1, sector_t l1, sector_t s2, sector_t l2)
@@ -2184,31 +2185,31 @@ static int overlaps(sector_t s1, sector_t l1, sector_t s2, sector_t l2)
 static ssize_t
 rdev_size_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 {
-	unsigned long long size;
-	unsigned long long oldsize = rdev->size;
 	mddev_t *my_mddev = rdev->mddev;
+	sector_t oldsectors = rdev->sectors;
+	unsigned long long sectors;
 
-	if (strict_strtoull(buf, 10, &size) < 0)
+	if (strict_strtoull(buf, 10, &sectors) < 0)
 		return -EINVAL;
+	sectors *= 2;
 	if (my_mddev->pers && rdev->raid_disk >= 0) {
 		if (my_mddev->persistent) {
-			size = super_types[my_mddev->major_version].
-				rdev_size_change(rdev, size * 2);
-			if (!size)
+			sectors = super_types[my_mddev->major_version].
+				rdev_size_change(rdev, sectors);
+			if (!sectors)
 				return -EBUSY;
-		} else if (!size) {
-			size = (rdev->bdev->bd_inode->i_size >> 10);
-			size -= rdev->data_offset/2;
-		}
+		} else if (!sectors)
+			sectors = (rdev->bdev->bd_inode->i_size >> 9) -
+				rdev->data_offset;
 	}
-	if (size < my_mddev->dev_sectors / 2)
+	if (sectors < my_mddev->dev_sectors)
 		return -EINVAL; /* component must fit device */
 
-	rdev->size = size;
-	if (size > oldsize && my_mddev->external) {
+	rdev->sectors = sectors;
+	if (sectors > oldsectors && my_mddev->external) {
 		/* need to check that all other rdevs with the same ->bdev
 		 * do not overlap.  We need to unlock the mddev to avoid
-		 * a deadlock.  We have already changed rdev->size, and if
+		 * a deadlock.  We have already changed rdev->sectors, and if
 		 * we have to change it back, we will have the lock again.
 		 */
 		mddev_t *mddev;
@@ -2224,9 +2225,9 @@ rdev_size_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 				if (test_bit(AllReserved, &rdev2->flags) ||
 				    (rdev->bdev == rdev2->bdev &&
 				     rdev != rdev2 &&
-				     overlaps(rdev->data_offset, rdev->size * 2,
+				     overlaps(rdev->data_offset, rdev->sectors,
 					      rdev2->data_offset,
-					      rdev2->size * 2))) {
+					      rdev2->sectors))) {
 					overlap = 1;
 					break;
 				}
@@ -2240,11 +2241,11 @@ rdev_size_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 		if (overlap) {
 			/* Someone else could have slipped in a size
 			 * change here, but doing so is just silly.
-			 * We put oldsize back because we *know* it is
+			 * We put oldsectors back because we *know* it is
 			 * safe, and trust userspace not to race with
 			 * itself
 			 */
-			rdev->size = oldsize;
+			rdev->sectors = oldsectors;
 			return -EBUSY;
 		}
 	}
@@ -3708,13 +3709,13 @@ static int do_md_run(mddev_t * mddev)
 		list_for_each_entry(rdev, &mddev->disks, same_set) {
 			if (test_bit(Faulty, &rdev->flags))
 				continue;
-			if (rdev->size < chunk_size / 1024) {
+			if (rdev->sectors < chunk_size / 512) {
 				printk(KERN_WARNING
 					"md: Dev %s smaller than chunk_size:"
-					" %lluk < %dk\n",
+					" %llu < %d\n",
 					bdevname(rdev->bdev,b),
-					(unsigned long long)rdev->size,
-					chunk_size / 1024);
+					(unsigned long long)rdev->sectors,
+					chunk_size / 512);
 				return -EINVAL;
 			}
 		}
@@ -4526,7 +4527,7 @@ static int add_new_disk(mddev_t * mddev, mdu_disk_info_t *info)
 			rdev->sb_start = rdev->bdev->bd_inode->i_size / 512;
 		} else 
 			rdev->sb_start = calc_dev_sboffset(rdev->bdev);
-		rdev->size = calc_num_sectors(rdev, mddev->chunk_size) / 2;
+		rdev->sectors = calc_num_sectors(rdev, mddev->chunk_size);
 
 		err = bind_rdev_to_array(rdev, mddev);
 		if (err) {
@@ -4596,7 +4597,7 @@ static int hot_add_disk(mddev_t * mddev, dev_t dev)
 	else
 		rdev->sb_start = rdev->bdev->bd_inode->i_size / 512;
 
-	rdev->size = calc_num_sectors(rdev, mddev->chunk_size) / 2;
+	rdev->sectors = calc_num_sectors(rdev, mddev->chunk_size);
 
 	if (test_bit(Faulty, &rdev->flags)) {
 		printk(KERN_WARNING 
@@ -4807,8 +4808,7 @@ static int update_size(mddev_t *mddev, sector_t num_sectors)
 		 */
 		return -EBUSY;
 	list_for_each_entry(rdev, &mddev->disks, same_set) {
-		sector_t avail;
-		avail = rdev->size * 2;
+		sector_t avail = rdev->sectors;
 
 		if (fit && (num_sectors == 0 || num_sectors > avail))
 			num_sectors = avail;
@@ -5536,7 +5536,7 @@ struct mdstat_info {
 static int md_seq_show(struct seq_file *seq, void *v)
 {
 	mddev_t *mddev = v;
-	sector_t size;
+	sector_t sectors;
 	mdk_rdev_t *rdev;
 	struct mdstat_info *mi = seq->private;
 	struct bitmap *bitmap;
@@ -5572,7 +5572,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
 			seq_printf(seq, " %s", mddev->pers->name);
 		}
 
-		size = 0;
+		sectors = 0;
 		list_for_each_entry(rdev, &mddev->disks, same_set) {
 			char b[BDEVNAME_SIZE];
 			seq_printf(seq, " %s[%d]",
@@ -5584,7 +5584,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
 				continue;
 			} else if (rdev->raid_disk < 0)
 				seq_printf(seq, "(S)"); /* spare */
-			size += rdev->size;
+			sectors += rdev->sectors;
 		}
 
 		if (!list_empty(&mddev->disks)) {
@@ -5594,7 +5594,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
 					   mddev->array_sectors / 2);
 			else
 				seq_printf(seq, "\n      %llu blocks",
-					   (unsigned long long)size);
+					   (unsigned long long)sectors / 2);
 		}
 		if (mddev->persistent) {
 			if (mddev->major_version != 0 ||
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index c605ba8..a5037de 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -73,16 +73,15 @@ static int create_strip_zones (mddev_t *mddev)
 		list_for_each_entry(rdev2, &mddev->disks, same_set) {
 			printk(KERN_INFO "raid0:   comparing %s(%llu)",
 			       bdevname(rdev1->bdev,b),
-			       (unsigned long long)rdev1->size);
+			       (unsigned long long)rdev1->sectors);
 			printk(KERN_INFO " with %s(%llu)\n",
 			       bdevname(rdev2->bdev,b),
-			       (unsigned long long)rdev2->size);
+			       (unsigned long long)rdev2->sectors);
 			if (rdev2 == rdev1) {
 				printk(KERN_INFO "raid0:   END\n");
 				break;
 			}
-			if (rdev2->size == rdev1->size)
-			{
+			if (rdev2->sectors == rdev1->sectors) {
 				/*
 				 * Not unique, don't count it as a new
 				 * group
@@ -145,7 +144,7 @@ static int create_strip_zones (mddev_t *mddev)
 		    mddev->queue->max_sectors > (PAGE_SIZE>>9))
 			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
 
-		if (!smallest || (rdev1->size <smallest->size))
+		if (!smallest || (rdev1->sectors < smallest->sectors))
 			smallest = rdev1;
 		cnt++;
 	}
@@ -155,10 +154,10 @@ static int create_strip_zones (mddev_t *mddev)
 		goto abort;
 	}
 	zone->nb_dev = cnt;
-	zone->sectors = smallest->size * cnt * 2;
+	zone->sectors = smallest->sectors * cnt;
 	zone->zone_start = 0;
 
-	current_start = smallest->size * 2;
+	current_start = smallest->sectors;
 	curr_zone_start = zone->sectors;
 
 	/* now do the other zones */
@@ -177,29 +176,29 @@ static int create_strip_zones (mddev_t *mddev)
 			rdev = conf->strip_zone[0].dev[j];
 			printk(KERN_INFO "raid0: checking %s ...",
 				bdevname(rdev->bdev, b));
-			if (rdev->size > current_start / 2) {
-				printk(KERN_INFO " contained as device %d\n",
-					c);
-				zone->dev[c] = rdev;
-				c++;
-				if (!smallest || (rdev->size <smallest->size)) {
-					smallest = rdev;
-					printk(KERN_INFO "  (%llu) is smallest!.\n",
-						(unsigned long long)rdev->size);
-				}
-			} else
+			if (rdev->sectors <= current_start) {
 				printk(KERN_INFO " nope.\n");
+				continue;
+			}
+			printk(KERN_INFO " contained as device %d\n", c);
+			zone->dev[c] = rdev;
+			c++;
+			if (!smallest || rdev->sectors < smallest->sectors) {
+				smallest = rdev;
+				printk(KERN_INFO "  (%llu) is smallest!.\n",
+					(unsigned long long)rdev->sectors);
+			}
 		}
 
 		zone->nb_dev = c;
-		zone->sectors = (smallest->size * 2 - current_start) * c;
+		zone->sectors = (smallest->sectors - current_start) * c;
 		printk(KERN_INFO "raid0: zone->nb_dev: %d, sectors: %llu\n",
 			zone->nb_dev, (unsigned long long)zone->sectors);
 
 		zone->zone_start = curr_zone_start;
 		curr_zone_start += zone->sectors;
 
-		current_start = smallest->size * 2;
+		current_start = smallest->sectors;
 		printk(KERN_INFO "raid0: current zone start: %llu\n",
 			(unsigned long long)current_start);
 	}
@@ -293,7 +292,7 @@ static int raid0_run (mddev_t *mddev)
 	/* calculate array device size */
 	mddev->array_sectors = 0;
 	list_for_each_entry(rdev, &mddev->disks, same_set)
-		mddev->array_sectors += rdev->size * 2;
+		mddev->array_sectors += rdev->sectors;
 
 	printk(KERN_INFO "raid0 : md_size is %llu sectors.\n",
 		(unsigned long long)mddev->array_sectors);
diff --git a/include/linux/raid/md_k.h b/include/linux/raid/md_k.h
index ed2f24b..e0defd6 100644
--- a/include/linux/raid/md_k.h
+++ b/include/linux/raid/md_k.h
@@ -49,7 +49,7 @@ struct mdk_rdev_s
 {
 	struct list_head same_set;	/* RAID devices within the same set */
 
-	sector_t size;			/* Device size (in blocks) */
+	sector_t sectors;		/* Device size (in 512bytes sectors) */
 	mddev_t *mddev;			/* RAID array if running */
 	long last_events;		/* IO event timestamp */
 
-- 
1.5.3.8

