From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 010 of 14] Convert various kmap calls to kmap_atomic
Date: Thu, 1 Dec 2005 14:23:39 +1100
Message-ID: <1051201032339.29666@suse.de>
References: <20051201141508.29384.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c |   44 +++++++++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 23 deletions(-)

diff ./drivers/md/bitmap.c~current~ ./drivers/md/bitmap.c
--- ./drivers/md/bitmap.c~current~	2005-12-01 14:02:54.000000000 +1100
+++ ./drivers/md/bitmap.c	2005-12-01 14:02:50.000000000 +1100
@@ -406,11 +406,11 @@ int bitmap_update_sb(struct bitmap *bitm
 		return 0;
 	}
 	spin_unlock_irqrestore(&bitmap->lock, flags);
-	sb = (bitmap_super_t *)kmap(bitmap->sb_page);
+	sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
 	sb->events = cpu_to_le64(bitmap->mddev->events);
 	if (!bitmap->mddev->degraded)
 		sb->events_cleared = cpu_to_le64(bitmap->mddev->events);
-	kunmap(bitmap->sb_page);
+	kunmap_atomic(sb, KM_USER0);
 	return write_page(bitmap, bitmap->sb_page, 1);
 }
 
@@ -421,7 +421,7 @@ void bitmap_print_sb(struct bitmap *bitm
 
 	if (!bitmap || !bitmap->sb_page)
 		return;
-	sb = (bitmap_super_t *)kmap(bitmap->sb_page);
+	sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
 	printk(KERN_DEBUG "%s: bitmap file superblock:\n", bmname(bitmap));
 	printk(KERN_DEBUG "         magic: %08x\n", le32_to_cpu(sb->magic));
 	printk(KERN_DEBUG "       version: %d\n", le32_to_cpu(sb->version));
@@ -440,7 +440,7 @@ void bitmap_print_sb(struct bitmap *bitm
 	printk(KERN_DEBUG "     sync size: %llu KB\n",
 			(unsigned long long)le64_to_cpu(sb->sync_size)/2);
 	printk(KERN_DEBUG "max write behind: %d\n", le32_to_cpu(sb->write_behind));
-	kunmap(bitmap->sb_page);
+	kunmap_atomic(sb, KM_USER0);
 }
 
 /* read the superblock from the bitmap file and initialize some bitmap fields */
@@ -466,7 +466,7 @@ static int bitmap_read_sb(struct bitmap 
 		return err;
 	}
 
-	sb = (bitmap_super_t *)kmap(bitmap->sb_page);
+	sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
 
 	if (bytes_read < sizeof(*sb)) { /* short read */
 		printk(KERN_INFO "%s: bitmap file superblock truncated\n",
@@ -535,7 +535,7 @@ success:
 		bitmap->events_cleared = bitmap->mddev->events;
 	err = 0;
 out:
-	kunmap(bitmap->sb_page);
+	kunmap_atomic(sb, KM_USER0);
 	if (err)
 		bitmap_print_sb(bitmap);
 	return err;
@@ -560,7 +560,7 @@ static void bitmap_mask_state(struct bit
 	}
 	get_page(bitmap->sb_page);
 	spin_unlock_irqrestore(&bitmap->lock, flags);
-	sb = (bitmap_super_t *)kmap(bitmap->sb_page);
+	sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
 	switch (op) {
 		case MASK_SET: sb->state |= bits;
 				break;
@@ -568,7 +568,7 @@ static void bitmap_mask_state(struct bit
 				break;
 		default: BUG();
 	}
-	kunmap(bitmap->sb_page);
+	kunmap_atomic(sb, KM_USER0);
 	put_page(bitmap->sb_page);
 }
 
@@ -854,6 +854,7 @@ static int bitmap_init_from_disk(struct 
 	unsigned long bytes, offset, dummy;
 	int outofdate;
 	int ret = -ENOSPC;
+	void *paddr;
 
 	chunks = bitmap->chunks;
 	file = bitmap->file;
@@ -899,8 +900,6 @@ static int bitmap_init_from_disk(struct 
 		bit = file_page_offset(i);
 		if (index != oldindex) { /* this is a new page, read it in */
 			/* unmap the old page, we're done with it */
-			if (oldpage != NULL)
-				kunmap(oldpage);
 			if (index == 0) {
 				/*
 				 * if we're here then the superblock page
@@ -923,18 +922,18 @@ static int bitmap_init_from_disk(struct 
 
 			oldindex = index;
 			oldpage = page;
-			kmap(page);
 
 			if (outofdate) {
 				/*
 				 * if bitmap is out of date, dirty the
 			 	 * whole page and write it out
 				 */
-				memset(page_address(page) + offset, 0xff,
+				paddr = kmap_atomic(page, KM_USER0);
+				memset(paddr + offset, 0xff,
 				       PAGE_SIZE - offset);
+				kunmap_atomic(paddr, KM_USER0);
 				ret = write_page(bitmap, page, 1);
 				if (ret) {
-					kunmap(page);
 					/* release, page not in filemap yet */
 					put_page(page);
 					goto out;
@@ -943,10 +942,12 @@ static int bitmap_init_from_disk(struct 
 
 			bitmap->filemap[bitmap->file_pages++] = page;
 		}
+		paddr = kmap_atomic(page, KM_USER0);
 		if (bitmap->flags & BITMAP_HOSTENDIAN)
-			b = test_bit(bit, page_address(page));
+			b = test_bit(bit, paddr);
 		else
-			b = ext2_test_bit(bit, page_address(page));
+			b = ext2_test_bit(bit, paddr);
+		kunmap_atomic(paddr, KM_USER0);
 		if (b) {
 			/* if the disk bit is set, set the memory bit */
 			bitmap_set_memory_bits(bitmap, i << CHUNK_BLOCK_SHIFT(bitmap),
@@ -961,9 +962,6 @@ static int bitmap_init_from_disk(struct 
 	ret = 0;
 	bitmap_mask_state(bitmap, BITMAP_STALE, MASK_UNSET);
 
-	if (page) /* unmap the last page */
-		kunmap(page);
-
 	if (bit_cnt) { /* Kick recovery if any bits were set */
 		set_bit(MD_RECOVERY_NEEDED, &bitmap->mddev->recovery);
 		md_wakeup_thread(bitmap->mddev->thread);
@@ -1019,6 +1017,7 @@ int bitmap_daemon_work(struct bitmap *bi
 	int err = 0;
 	int blocks;
 	int attr;
+	void *paddr;
 
 	if (bitmap == NULL)
 		return 0;
@@ -1075,14 +1074,12 @@ int bitmap_daemon_work(struct bitmap *bi
 					set_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE);
 					spin_unlock_irqrestore(&bitmap->lock, flags);
 				}
-				kunmap(lastpage);
 				put_page(lastpage);
 				if (err)
 					bitmap_file_kick(bitmap);
 			} else
 				spin_unlock_irqrestore(&bitmap->lock, flags);
 			lastpage = page;
-			kmap(page);
 /*
 			printk("bitmap clean at page %lu\n", j);
 */
@@ -1105,10 +1102,12 @@ int bitmap_daemon_work(struct bitmap *bi
 						  -1);
 
 				/* clear the bit */
+				paddr = kmap_atomic(page, KM_USER0);
 				if (bitmap->flags & BITMAP_HOSTENDIAN)
-					clear_bit(file_page_offset(j), page_address(page));
+					clear_bit(file_page_offset(j), paddr);
 				else
-					ext2_clear_bit(file_page_offset(j), page_address(page));
+					ext2_clear_bit(file_page_offset(j), paddr);
+				kunmap_atomic(paddr, KM_USER0);
 			}
 		}
 		spin_unlock_irqrestore(&bitmap->lock, flags);
@@ -1116,7 +1115,6 @@ int bitmap_daemon_work(struct bitmap *bi
 
 	/* now sync the final page */
 	if (lastpage != NULL) {
-		kunmap(lastpage);
 		spin_lock_irqsave(&bitmap->lock, flags);
 		if (get_page_attr(bitmap, lastpage) &BITMAP_PAGE_NEEDWRITE) {
 			clear_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE);
