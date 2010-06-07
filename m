From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 04/16] md: load/store badblock list from v1.x metadata
Date: Mon, 07 Jun 2010 10:07:54 +1000
Message-ID: <20100607000754.13302.56069.stgit@notabene.brown>
References: <20100606235833.13302.60932.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100606235833.13302.60932.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Space must have been allocated when array was created.
A feature flag is set when the badblock list is non-empty, to
ensure old kernels don't load and trust the whole device.

We only update the on-disk badblocklist when it has changed.
If the badblocklist (or other metadata) is stored on a bad block, we
don't cope very well.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c           |  103 ++++++++++++++++++++++++++++++++++++++++++---
 drivers/md/md.h           |    5 ++
 include/linux/raid/md_p.h |   13 ++++--
 3 files changed, 110 insertions(+), 11 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6ba2253..63b185e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -671,6 +671,10 @@ static void free_disk_sb(mdk_rdev_t * rdev)
 		rdev->sb_start = 0;
 		rdev->sectors = 0;
 	}
+	if (rdev->bb_page) {
+		put_page(rdev->bb_page);
+		rdev->bb_page = NULL;
+	}
 }
 
 
@@ -1433,6 +1437,46 @@ static int super_1_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version)
 	else
 		rdev->desc_nr = le32_to_cpu(sb->dev_number);
 
+	if (!rdev->bb_page) {
+		rdev->bb_page = alloc_page(GFP_KERNEL);
+		if (!rdev->bb_page)
+			return -ENOMEM;
+	}
+	if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_BAD_BLOCKS) &&
+	    rdev->badblocks.count == 0) {
+		/* need to load the bad block list.
+		 * Currently we limit it to one page.
+		 */
+		s32 offset;
+		sector_t bb_sector;
+		u64 *bbp;
+		int i;
+		int sectors = le16_to_cpu(sb->bblog_size);
+		if (sectors > (PAGE_SIZE / 512))
+			return -EINVAL;
+		offset = le32_to_cpu(sb->bblog_offset);
+		if (offset == 0)
+			return -EINVAL;
+		bb_sector = rdev->sb_start + (long long)offset;
+		if (!sync_page_io(rdev->bdev, bb_sector, sectors << 9,
+				  rdev->bb_page, READ))
+			return -EIO;
+		bbp = (u64 *)page_address(rdev->bb_page);
+		rdev->badblocks.shift = sb->bblog_shift;
+		for (i = 0 ; i < (sectors << (9-3)) ; i++, bbp++) {
+			u64 bb = le64_to_cpu(*bbp);
+			int count = bb & (0x3ff);
+			u64 sector = bb >> 10;
+			sector <<= sb->bblog_shift;
+			count <<= sb->bblog_shift;
+			if (bb + 1 == 0)
+				break;
+			if (md_set_badblocks(&rdev->badblocks,
+					     sector, count, 1) == 0)
+				return -EINVAL;
+		}
+	}
+
 	if (!refdev) {
 		ret = 1;
 	} else {
@@ -1586,7 +1630,6 @@ static void super_1_sync(mddev_t *mddev, mdk_rdev_t *rdev)
 	sb->pad0 = 0;
 	sb->recovery_offset = cpu_to_le64(0);
 	memset(sb->pad1, 0, sizeof(sb->pad1));
-	memset(sb->pad2, 0, sizeof(sb->pad2));
 	memset(sb->pad3, 0, sizeof(sb->pad3));
 
 	sb->utime = cpu_to_le64((__u64)mddev->utime);
@@ -1626,6 +1669,38 @@ static void super_1_sync(mddev_t *mddev, mdk_rdev_t *rdev)
 		sb->new_chunk = cpu_to_le32(mddev->new_chunk_sectors);
 	}
 
+	if (rdev->badblocks.count > 0) {
+		int havelock = 0;
+		struct badblocks *bb = &rdev->badblocks;
+		u64 *bbp = (u64 *)page_address(rdev->bb_page);
+		u64 *p;
+		sb->feature_map |= cpu_to_le32(MD_FEATURE_BAD_BLOCKS);
+		if (bb->changed) {
+			memset(bbp, 0xff, PAGE_SIZE);
+
+			rcu_read_lock();
+			p = rcu_dereference(bb->active_page);
+			if (!p) {
+				spin_lock(&bb->lock);
+				p = bb->page;
+				havelock = 1;
+			}
+			for (i = 0 ; i < bb->count ; i++) {
+				u64 internal_bb = *p++;
+				u64 store_bb = ((BB_OFFSET(internal_bb) << 10)
+						| BB_LEN(internal_bb));
+				*bbp++ = cpu_to_le64(store_bb);
+			}
+			bb->sector = (rdev->sb_start +
+				      (int)le32_to_cpu(sb->bblog_offset));
+			bb->size = le16_to_cpu(sb->bblog_size);
+			bb->changed = 0;
+			if (havelock)
+				spin_unlock(&bb->lock);
+			rcu_read_unlock();
+		}
+	}
+
 	max_dev = 0;
 	list_for_each_entry(rdev2, &mddev->disks, same_set)
 		if (rdev2->desc_nr+1 > max_dev)
@@ -2164,6 +2239,7 @@ static void md_update_sb(mddev_t * mddev, int force_change)
 	mdk_rdev_t *rdev;
 	int sync_req;
 	int nospares = 0;
+	int any_badblocks_changed = 0;
 
 	mddev->utime = get_seconds();
 	if (mddev->external)
@@ -2232,6 +2308,11 @@ repeat:
 		wake_up(&mddev->sb_wait);
 		return;
 	}
+
+	list_for_each_entry(rdev, &mddev->disks, same_set)
+		if (rdev->badblocks.changed)
+			any_badblocks_changed++;
+
 	sync_sbs(mddev, nospares);
 	spin_unlock_irq(&mddev->write_lock);
 
@@ -2257,6 +2338,13 @@ repeat:
 				bdevname(rdev->bdev,b),
 				(unsigned long long)rdev->sb_start);
 			rdev->sb_events = mddev->events;
+			if (rdev->badblocks.size) {
+				md_super_write(mddev, rdev,
+					       rdev->badblocks.sector,
+					       rdev->badblocks.size << 9,
+					       rdev->bb_page);
+				rdev->badblocks.size = 0;
+			}
 
 		} else
 			dprintk(")\n");
@@ -2280,6 +2368,9 @@ repeat:
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		sysfs_notify(&mddev->kobj, NULL, "sync_completed");
 
+	if (any_badblocks_changed)
+		list_for_each_entry(rdev, &mddev->disks, same_set)
+			md_ack_all_badblocks(&rdev->badblocks);
 }
 
 /* words written to sysfs files may, or may not, be \n terminated.
@@ -2784,6 +2875,8 @@ int md_rdev_init(mdk_rdev_t *rdev)
 	rdev->sb_events = 0;
 	rdev->last_read_error.tv_sec  = 0;
 	rdev->last_read_error.tv_nsec = 0;
+	rdev->sb_loaded = 0;
+	rdev->bb_page = NULL;
 	atomic_set(&rdev->nr_pending, 0);
 	atomic_set(&rdev->read_errors, 0);
 	atomic_set(&rdev->corrected_errors, 0);
@@ -2871,11 +2964,9 @@ static mdk_rdev_t *md_import_device(dev_t newdev, int super_format, int super_mi
 	return rdev;
 
 abort_free:
-	if (rdev->sb_page) {
-		if (rdev->bdev)
-			unlock_rdev(rdev);
-		free_disk_sb(rdev);
-	}
+	if (rdev->bdev)
+		unlock_rdev(rdev);
+	free_disk_sb(rdev);
 	kfree(rdev);
 	return ERR_PTR(err);
 }
diff --git a/drivers/md/md.h b/drivers/md/md.h
index a24e131..087764b 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -68,7 +68,7 @@ struct mdk_rdev_s
 
 	struct block_device *bdev;	/* block device handle */
 
-	struct page	*sb_page;
+	struct page	*sb_page, *bb_page;
 	int		sb_loaded;
 	__u64		sb_events;
 	sector_t	data_offset;	/* start of data in array */
@@ -139,6 +139,9 @@ struct mdk_rdev_s
 		u64	*active_page;	/* either 'page' or 'NULL' */
 		int	changed;
 		spinlock_t lock;
+
+		sector_t sector;
+		sector_t size;		/* in sectors */
 	} badblocks;
 };
 
diff --git a/include/linux/raid/md_p.h b/include/linux/raid/md_p.h
index ffa2efb..a2c23fd 100644
--- a/include/linux/raid/md_p.h
+++ b/include/linux/raid/md_p.h
@@ -245,10 +245,15 @@ struct mdp_superblock_1 {
 	__u8	device_uuid[16]; /* user-space setable, ignored by kernel */
 	__u8	devflags;	/* per-device flags.  Only one defined...*/
 #define	WriteMostly1	1	/* mask for writemostly flag in above */
-	__u8	pad2[64-57];	/* set to 0 when writing */
+	/* bad block log.  If there are any bad blocks the feature flag is set.
+	 * if offset and size are non-zero, that space is reserved and available.
+	 */
+	__u8	bblog_shift;	/* shift from sectors to block size for badblocklist */
+	__le16	bblog_size;	/* number of sectors reserved for badblocklist */
+	__le32	bblog_offset;	/* sector offset from superblock to bblog, signed */
 
 	/* array state information - 64 bytes */
-	__le64	utime;		/* 40 bits second, 24 btes microseconds */
+	__le64	utime;		/* 40 bits second, 24 bits microseconds */
 	__le64	events;		/* incremented when superblock updated */
 	__le64	resync_offset;	/* data before this offset (from data_offset) known to be in sync */
 	__le32	sb_csum;	/* checksum upto devs[max_dev] */
@@ -270,8 +275,8 @@ struct mdp_superblock_1 {
 					   * must be honoured
 					   */
 #define	MD_FEATURE_RESHAPE_ACTIVE	4
+#define	MD_FEATURE_BAD_BLOCKS		8 /* badblock list is not empty */
 
-#define	MD_FEATURE_ALL			(1|2|4)
+#define	MD_FEATURE_ALL			(1|2|4|8)
 
 #endif 
-


