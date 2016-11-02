From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 3/9] md/bitmap: change all printk() to pr_*()
Date: Wed, 02 Nov 2016 14:16:49 +1100
Message-ID: <147805660938.23566.6912498415559861048.stgit@noble>
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

Follow err/warn distinction introduced in md.c
Join multi-part strings into single string.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/bitmap.c |  107 ++++++++++++++++++++++++---------------------------
 1 file changed, 50 insertions(+), 57 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 2d826927a3bf..3ceb0c51891e 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -405,10 +405,10 @@ static int read_page(struct file *file, unsigned long index,
 		ret = -EIO;
 out:
 	if (ret)
-		printk(KERN_ALERT "md: bitmap read error: (%dB @ %llu): %d\n",
-			(int)PAGE_SIZE,
-			(unsigned long long)index << PAGE_SHIFT,
-			ret);
+		pr_err("md: bitmap read error: (%dB @ %llu): %d\n",
+		       (int)PAGE_SIZE,
+		       (unsigned long long)index << PAGE_SHIFT,
+		       ret);
 	return ret;
 }
 
@@ -455,24 +455,24 @@ void bitmap_print_sb(struct bitmap *bitmap)
 	if (!bitmap || !bitmap->storage.sb_page)
 		return;
 	sb = kmap_atomic(bitmap->storage.sb_page);
-	printk(KERN_DEBUG "%s: bitmap file superblock:\n", bmname(bitmap));
-	printk(KERN_DEBUG "         magic: %08x\n", le32_to_cpu(sb->magic));
-	printk(KERN_DEBUG "       version: %d\n", le32_to_cpu(sb->version));
-	printk(KERN_DEBUG "          uuid: %08x.%08x.%08x.%08x\n",
-					*(__u32 *)(sb->uuid+0),
-					*(__u32 *)(sb->uuid+4),
-					*(__u32 *)(sb->uuid+8),
-					*(__u32 *)(sb->uuid+12));
-	printk(KERN_DEBUG "        events: %llu\n",
-			(unsigned long long) le64_to_cpu(sb->events));
-	printk(KERN_DEBUG "events cleared: %llu\n",
-			(unsigned long long) le64_to_cpu(sb->events_cleared));
-	printk(KERN_DEBUG "         state: %08x\n", le32_to_cpu(sb->state));
-	printk(KERN_DEBUG "     chunksize: %d B\n", le32_to_cpu(sb->chunksize));
-	printk(KERN_DEBUG "  daemon sleep: %ds\n", le32_to_cpu(sb->daemon_sleep));
-	printk(KERN_DEBUG "     sync size: %llu KB\n",
-			(unsigned long long)le64_to_cpu(sb->sync_size)/2);
-	printk(KERN_DEBUG "max write behind: %d\n", le32_to_cpu(sb->write_behind));
+	pr_debug("%s: bitmap file superblock:\n", bmname(bitmap));
+	pr_debug("         magic: %08x\n", le32_to_cpu(sb->magic));
+	pr_debug("       version: %d\n", le32_to_cpu(sb->version));
+	pr_debug("          uuid: %08x.%08x.%08x.%08x\n",
+		 *(__u32 *)(sb->uuid+0),
+		 *(__u32 *)(sb->uuid+4),
+		 *(__u32 *)(sb->uuid+8),
+		 *(__u32 *)(sb->uuid+12));
+	pr_debug("        events: %llu\n",
+		 (unsigned long long) le64_to_cpu(sb->events));
+	pr_debug("events cleared: %llu\n",
+		 (unsigned long long) le64_to_cpu(sb->events_cleared));
+	pr_debug("         state: %08x\n", le32_to_cpu(sb->state));
+	pr_debug("     chunksize: %d B\n", le32_to_cpu(sb->chunksize));
+	pr_debug("  daemon sleep: %ds\n", le32_to_cpu(sb->daemon_sleep));
+	pr_debug("     sync size: %llu KB\n",
+		 (unsigned long long)le64_to_cpu(sb->sync_size)/2);
+	pr_debug("max write behind: %d\n", le32_to_cpu(sb->write_behind));
 	kunmap_atomic(sb);
 }
 
@@ -506,14 +506,14 @@ static int bitmap_new_disk_sb(struct bitmap *bitmap)
 	BUG_ON(!chunksize);
 	if (!is_power_of_2(chunksize)) {
 		kunmap_atomic(sb);
-		printk(KERN_ERR "bitmap chunksize not a power of 2\n");
+		pr_warn("bitmap chunksize not a power of 2\n");
 		return -EINVAL;
 	}
 	sb->chunksize = cpu_to_le32(chunksize);
 
 	daemon_sleep = bitmap->mddev->bitmap_info.daemon_sleep;
 	if (!daemon_sleep || (daemon_sleep > MAX_SCHEDULE_TIMEOUT)) {
-		printk(KERN_INFO "Choosing daemon_sleep default (5 sec)\n");
+		pr_debug("Choosing daemon_sleep default (5 sec)\n");
 		daemon_sleep = 5 * HZ;
 	}
 	sb->daemon_sleep = cpu_to_le32(daemon_sleep);
@@ -584,7 +584,7 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 		/* to 4k blocks */
 		bm_blocks = DIV_ROUND_UP_SECTOR_T(bm_blocks, 4096);
 		offset = bitmap->mddev->bitmap_info.offset + (bitmap->cluster_slot * (bm_blocks << 3));
-		pr_info("%s:%d bm slot: %d offset: %llu\n", __func__, __LINE__,
+		pr_debug("%s:%d bm slot: %d offset: %llu\n", __func__, __LINE__,
 			bitmap->cluster_slot, offset);
 	}
 
@@ -634,7 +634,7 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 	else if (write_behind > COUNTER_MAX)
 		reason = "write-behind limit out of range (0 - 16383)";
 	if (reason) {
-		printk(KERN_INFO "%s: invalid bitmap file superblock: %s\n",
+		pr_warn("%s: invalid bitmap file superblock: %s\n",
 			bmname(bitmap), reason);
 		goto out;
 	}
@@ -648,18 +648,15 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 		 * bitmap's UUID and event counter to the mddev's
 		 */
 		if (memcmp(sb->uuid, bitmap->mddev->uuid, 16)) {
-			printk(KERN_INFO
-			       "%s: bitmap superblock UUID mismatch\n",
-			       bmname(bitmap));
+			pr_warn("%s: bitmap superblock UUID mismatch\n",
+				bmname(bitmap));
 			goto out;
 		}
 		events = le64_to_cpu(sb->events);
 		if (!nodes && (events < bitmap->mddev->events)) {
-			printk(KERN_INFO
-			       "%s: bitmap file is out of date (%llu < %llu) "
-			       "-- forcing full recovery\n",
-			       bmname(bitmap), events,
-			       (unsigned long long) bitmap->mddev->events);
+			pr_warn("%s: bitmap file is out of date (%llu < %llu) -- forcing full recovery\n",
+				bmname(bitmap), events,
+				(unsigned long long) bitmap->mddev->events);
 			set_bit(BITMAP_STALE, &bitmap->flags);
 		}
 	}
@@ -679,8 +676,8 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 	if (err == 0 && nodes && (bitmap->cluster_slot < 0)) {
 		err = md_setup_cluster(bitmap->mddev, nodes);
 		if (err) {
-			pr_err("%s: Could not setup cluster service (%d)\n",
-					bmname(bitmap), err);
+			pr_warn("%s: Could not setup cluster service (%d)\n",
+				bmname(bitmap), err);
 			goto out_no_sb;
 		}
 		bitmap->cluster_slot = md_cluster_ops->slot_number(bitmap->mddev);
@@ -847,15 +844,13 @@ static void bitmap_file_kick(struct bitmap *bitmap)
 				ptr = file_path(bitmap->storage.file,
 					     path, PAGE_SIZE);
 
-			printk(KERN_ALERT
-			      "%s: kicking failed bitmap file %s from array!\n",
-			      bmname(bitmap), IS_ERR(ptr) ? "" : ptr);
+			pr_warn("%s: kicking failed bitmap file %s from array!\n",
+				bmname(bitmap), IS_ERR(ptr) ? "" : ptr);
 
 			kfree(path);
 		} else
-			printk(KERN_ALERT
-			       "%s: disabling internal bitmap due to errors\n",
-			       bmname(bitmap));
+			pr_warn("%s: disabling internal bitmap due to errors\n",
+				bmname(bitmap));
 	}
 }
 
@@ -1056,14 +1051,13 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 
 	outofdate = test_bit(BITMAP_STALE, &bitmap->flags);
 	if (outofdate)
-		printk(KERN_INFO "%s: bitmap file is out of date, doing full "
-			"recovery\n", bmname(bitmap));
+		pr_warn("%s: bitmap file is out of date, doing full recovery\n", bmname(bitmap));
 
 	if (file && i_size_read(file->f_mapping->host) < store->bytes) {
-		printk(KERN_INFO "%s: bitmap file too short %lu < %lu\n",
-		       bmname(bitmap),
-		       (unsigned long) i_size_read(file->f_mapping->host),
-		       store->bytes);
+		pr_warn("%s: bitmap file too short %lu < %lu\n",
+			bmname(bitmap),
+			(unsigned long) i_size_read(file->f_mapping->host),
+			store->bytes);
 		goto err;
 	}
 
@@ -1137,16 +1131,15 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 		offset = 0;
 	}
 
-	printk(KERN_INFO "%s: bitmap initialized from disk: "
-	       "read %lu pages, set %lu of %lu bits\n",
-	       bmname(bitmap), store->file_pages,
-	       bit_cnt, chunks);
+	pr_debug("%s: bitmap initialized from disk: read %lu pages, set %lu of %lu bits\n",
+		 bmname(bitmap), store->file_pages,
+		 bit_cnt, chunks);
 
 	return 0;
 
  err:
-	printk(KERN_INFO "%s: bitmap initialisation failed: %d\n",
-	       bmname(bitmap), ret);
+	pr_warn("%s: bitmap initialisation failed: %d\n",
+		bmname(bitmap), ret);
 	return ret;
 }
 
@@ -1825,8 +1818,8 @@ struct bitmap *bitmap_create(struct mddev *mddev, int slot)
 	if (err)
 		goto error;
 
-	printk(KERN_INFO "created bitmap (%lu pages) for device %s\n",
-	       bitmap->counts.pages, bmname(bitmap));
+	pr_debug("created bitmap (%lu pages) for device %s\n",
+		 bitmap->counts.pages, bmname(bitmap));
 
 	err = test_bit(BITMAP_WRITE_ERROR, &bitmap->flags) ? -EIO : 0;
 	if (err)
@@ -2089,7 +2082,7 @@ int bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 				bitmap->mddev->bitmap_info.chunksize = 1 << (old_counts.chunkshift +
 									     BITMAP_BLOCK_SHIFT);
 				blocks = old_counts.chunks << old_counts.chunkshift;
-				pr_err("Could not pre-allocate in-memory bitmap for cluster raid\n");
+				pr_warn("Could not pre-allocate in-memory bitmap for cluster raid\n");
 				break;
 			} else
 				bitmap->counts.bp[page].count += 1;


