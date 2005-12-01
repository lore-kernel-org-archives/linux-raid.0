From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 007 of 14] Clean up 'page' related names in md
Date: Thu, 1 Dec 2005 14:23:22 +1100
Message-ID: <1051201032322.29629@suse.de>
References: <20051201141508.29384.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Substitute:

  page_cache_get -> get_page
  page_cache_release -> put_page
  PAGE_CACHE_SHIFT -> PAGE_SHIFT
  PAGE_CACHE_SIZE -> PAGE_SIZE
  PAGE_CACHE_MASK -> PAGE_MASK
  __free_page -> put_page

because we aren't using the page cache, we are just using pages.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c    |   44 ++++++++++++++++++++++----------------------
 ./drivers/md/md.c        |    2 +-
 ./drivers/md/raid0.c     |    2 +-
 ./drivers/md/raid1.c     |   10 +++++-----
 ./drivers/md/raid10.c    |    8 ++++----
 ./drivers/md/raid5.c     |    4 ++--
 ./drivers/md/raid6main.c |    6 +++---
 7 files changed, 38 insertions(+), 38 deletions(-)

diff ./drivers/md/bitmap.c~current~ ./drivers/md/bitmap.c
--- ./drivers/md/bitmap.c~current~	2005-12-01 13:56:49.000000000 +1100
+++ ./drivers/md/bitmap.c	2005-12-01 13:57:54.000000000 +1100
@@ -341,7 +341,7 @@ static int write_page(struct bitmap *bit
 		/* add to list to be waited for by daemon */
 		struct page_list *item = mempool_alloc(bitmap->write_pool, GFP_NOIO);
 		item->page = page;
-		page_cache_get(page);
+		get_page(page);
 		spin_lock(&bitmap->write_lock);
 		list_add(&item->list, &bitmap->complete_pages);
 		spin_unlock(&bitmap->write_lock);
@@ -357,10 +357,10 @@ static struct page *read_page(struct fil
 	struct inode *inode = file->f_mapping->host;
 	struct page *page = NULL;
 	loff_t isize = i_size_read(inode);
-	unsigned long end_index = isize >> PAGE_CACHE_SHIFT;
+	unsigned long end_index = isize >> PAGE_SHIFT;
 
-	PRINTK("read bitmap file (%dB @ %Lu)\n", (int)PAGE_CACHE_SIZE,
-			(unsigned long long)index << PAGE_CACHE_SHIFT);
+	PRINTK("read bitmap file (%dB @ %Lu)\n", (int)PAGE_SIZE,
+			(unsigned long long)index << PAGE_SHIFT);
 
 	page = read_cache_page(inode->i_mapping, index,
 			(filler_t *)inode->i_mapping->a_ops->readpage, file);
@@ -368,7 +368,7 @@ static struct page *read_page(struct fil
 		goto out;
 	wait_on_page_locked(page);
 	if (!PageUptodate(page) || PageError(page)) {
-		page_cache_release(page);
+		put_page(page);
 		page = ERR_PTR(-EIO);
 		goto out;
 	}
@@ -376,14 +376,14 @@ static struct page *read_page(struct fil
 	if (index > end_index) /* we have read beyond EOF */
 		*bytes_read = 0;
 	else if (index == end_index) /* possible short read */
-		*bytes_read = isize & ~PAGE_CACHE_MASK;
+		*bytes_read = isize & ~PAGE_MASK;
 	else
-		*bytes_read = PAGE_CACHE_SIZE; /* got a full page */
+		*bytes_read = PAGE_SIZE; /* got a full page */
 out:
 	if (IS_ERR(page))
 		printk(KERN_ALERT "md: bitmap read error: (%dB @ %Lu): %ld\n",
-			(int)PAGE_CACHE_SIZE,
-			(unsigned long long)index << PAGE_CACHE_SHIFT,
+			(int)PAGE_SIZE,
+			(unsigned long long)index << PAGE_SHIFT,
 			PTR_ERR(page));
 	return page;
 }
@@ -558,7 +558,7 @@ static void bitmap_mask_state(struct bit
 		spin_unlock_irqrestore(&bitmap->lock, flags);
 		return;
 	}
-	page_cache_get(bitmap->sb_page);
+	get_page(bitmap->sb_page);
 	spin_unlock_irqrestore(&bitmap->lock, flags);
 	sb = (bitmap_super_t *)kmap(bitmap->sb_page);
 	switch (op) {
@@ -569,7 +569,7 @@ static void bitmap_mask_state(struct bit
 		default: BUG();
 	}
 	kunmap(bitmap->sb_page);
-	page_cache_release(bitmap->sb_page);
+	put_page(bitmap->sb_page);
 }
 
 /*
@@ -622,12 +622,12 @@ static void bitmap_file_unmap(struct bit
 
 	while (pages--)
 		if (map[pages]->index != 0) /* 0 is sb_page, release it below */
-			page_cache_release(map[pages]);
+			put_page(map[pages]);
 	kfree(map);
 	kfree(attr);
 
 	if (sb_page)
-		page_cache_release(sb_page);
+		put_page(sb_page);
 }
 
 static void bitmap_stop_daemon(struct bitmap *bitmap);
@@ -654,7 +654,7 @@ static void drain_write_queues(struct bi
 
 	while ((item = dequeue_page(bitmap))) {
 		/* don't bother to wait */
-		page_cache_release(item->page);
+		put_page(item->page);
 		mempool_free(item, bitmap->write_pool);
 	}
 
@@ -763,7 +763,7 @@ static void bitmap_file_set_bit(struct b
 
 	/* make sure the page stays cached until it gets written out */
 	if (! (get_page_attr(bitmap, page) & BITMAP_PAGE_DIRTY))
-		page_cache_get(page);
+		get_page(page);
 
  	/* set the bit */
 	kaddr = kmap_atomic(page, KM_USER0);
@@ -938,7 +938,7 @@ static int bitmap_init_from_disk(struct 
 				if (ret) {
 					kunmap(page);
 					/* release, page not in filemap yet */
-					page_cache_release(page);
+					put_page(page);
 					goto out;
 				}
 			}
@@ -1043,7 +1043,7 @@ int bitmap_daemon_work(struct bitmap *bi
 			/* skip this page unless it's marked as needing cleaning */
 			if (!((attr=get_page_attr(bitmap, page)) & BITMAP_PAGE_CLEAN)) {
 				if (attr & BITMAP_PAGE_NEEDWRITE) {
-					page_cache_get(page);
+					get_page(page);
 					clear_page_attr(bitmap, page, BITMAP_PAGE_NEEDWRITE);
 				}
 				spin_unlock_irqrestore(&bitmap->lock, flags);
@@ -1057,13 +1057,13 @@ int bitmap_daemon_work(struct bitmap *bi
 					default:
 						bitmap_file_kick(bitmap);
 					}
-					page_cache_release(page);
+					put_page(page);
 				}
 				continue;
 			}
 
 			/* grab the new page, sync and release the old */
-			page_cache_get(page);
+			get_page(page);
 			if (lastpage != NULL) {
 				if (get_page_attr(bitmap, lastpage) & BITMAP_PAGE_NEEDWRITE) {
 					clear_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE);
@@ -1078,7 +1078,7 @@ int bitmap_daemon_work(struct bitmap *bi
 					spin_unlock_irqrestore(&bitmap->lock, flags);
 				}
 				kunmap(lastpage);
-				page_cache_release(lastpage);
+				put_page(lastpage);
 				if (err)
 					bitmap_file_kick(bitmap);
 			} else
@@ -1133,7 +1133,7 @@ int bitmap_daemon_work(struct bitmap *bi
 			spin_unlock_irqrestore(&bitmap->lock, flags);
 		}
 
-		page_cache_release(lastpage);
+		put_page(lastpage);
 	}
 
 	return err;
@@ -1184,7 +1184,7 @@ static void bitmap_writeback_daemon(mdde
 		PRINTK("finished page writeback: %p\n", page);
 
 		err = PageError(page);
-		page_cache_release(page);
+		put_page(page);
 		if (err) {
 			printk(KERN_WARNING "%s: bitmap file writeback "
 			       "failed (page %lu): %d\n",

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-12-01 13:57:01.000000000 +1100
+++ ./drivers/md/md.c	2005-12-01 13:57:54.000000000 +1100
@@ -339,7 +339,7 @@ static int alloc_disk_sb(mdk_rdev_t * rd
 static void free_disk_sb(mdk_rdev_t * rdev)
 {
 	if (rdev->sb_page) {
-		page_cache_release(rdev->sb_page);
+		put_page(rdev->sb_page);
 		rdev->sb_loaded = 0;
 		rdev->sb_page = NULL;
 		rdev->sb_offset = 0;

diff ./drivers/md/raid0.c~current~ ./drivers/md/raid0.c
--- ./drivers/md/raid0.c~current~	2005-12-01 13:56:49.000000000 +1100
+++ ./drivers/md/raid0.c	2005-12-01 13:57:54.000000000 +1100
@@ -361,7 +361,7 @@ static int raid0_run (mddev_t *mddev)
 	 * chunksize should be used in that case.
 	 */
 	{
-		int stripe = mddev->raid_disks * mddev->chunk_size / PAGE_CACHE_SIZE;
+		int stripe = mddev->raid_disks * mddev->chunk_size / PAGE_SIZE;
 		if (mddev->queue->backing_dev_info.ra_pages < 2* stripe)
 			mddev->queue->backing_dev_info.ra_pages = 2* stripe;
 	}

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-12-01 13:56:50.000000000 +1100
+++ ./drivers/md/raid1.c	2005-12-01 13:57:54.000000000 +1100
@@ -139,7 +139,7 @@ static void * r1buf_pool_alloc(gfp_t gfp
 out_free_pages:
 	for (i=0; i < RESYNC_PAGES ; i++)
 		for (j=0 ; j < pi->raid_disks; j++)
-			__free_page(r1_bio->bios[j]->bi_io_vec[i].bv_page);
+			put_page(r1_bio->bios[j]->bi_io_vec[i].bv_page);
 	j = -1;
 out_free_bio:
 	while ( ++j < pi->raid_disks )
@@ -159,7 +159,7 @@ static void r1buf_pool_free(void *__r1_b
 			if (j == 0 ||
 			    r1bio->bios[j]->bi_io_vec[i].bv_page !=
 			    r1bio->bios[0]->bi_io_vec[i].bv_page)
-				__free_page(r1bio->bios[j]->bi_io_vec[i].bv_page);
+				put_page(r1bio->bios[j]->bi_io_vec[i].bv_page);
 		}
 	for (i=0 ; i < pi->raid_disks; i++)
 		bio_put(r1bio->bios[i]);
@@ -386,7 +386,7 @@ static int raid1_end_write_request(struc
 /* FIXME bio has been freed!!! */
 			int i = bio->bi_vcnt;
 			while (i--)
-				__free_page(bio->bi_io_vec[i].bv_page);
+				put_page(bio->bi_io_vec[i].bv_page);
 		}
 		/* clear the bitmap if all writes complete successfully */
 		bitmap_endwrite(r1_bio->mddev->bitmap, r1_bio->sector,
@@ -732,7 +732,7 @@ static struct page **alloc_behind_pages(
 do_sync_io:
 	if (pages)
 		for (i = 0; i < bio->bi_vcnt && pages[i]; i++)
-			__free_page(pages[i]);
+			put_page(pages[i]);
 	kfree(pages);
 	PRINTK("%dB behind alloc failed, doing sync I/O\n", bio->bi_size);
 	return NULL;
@@ -1892,7 +1892,7 @@ out_free_conf:
 		if (conf->r1bio_pool)
 			mempool_destroy(conf->r1bio_pool);
 		kfree(conf->mirrors);
-		__free_page(conf->tmppage);
+		put_page(conf->tmppage);
 		kfree(conf->poolinfo);
 		kfree(conf);
 		mddev->private = NULL;

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2005-12-01 13:56:50.000000000 +1100
+++ ./drivers/md/raid10.c	2005-12-01 13:57:55.000000000 +1100
@@ -134,10 +134,10 @@ static void * r10buf_pool_alloc(gfp_t gf
 
 out_free_pages:
 	for ( ; i > 0 ; i--)
-		__free_page(bio->bi_io_vec[i-1].bv_page);
+		put_page(bio->bi_io_vec[i-1].bv_page);
 	while (j--)
 		for (i = 0; i < RESYNC_PAGES ; i++)
-			__free_page(r10_bio->devs[j].bio->bi_io_vec[i].bv_page);
+			put_page(r10_bio->devs[j].bio->bi_io_vec[i].bv_page);
 	j = -1;
 out_free_bio:
 	while ( ++j < nalloc )
@@ -157,7 +157,7 @@ static void r10buf_pool_free(void *__r10
 		struct bio *bio = r10bio->devs[j].bio;
 		if (bio) {
 			for (i = 0; i < RESYNC_PAGES; i++) {
-				__free_page(bio->bi_io_vec[i].bv_page);
+				put_page(bio->bi_io_vec[i].bv_page);
 				bio->bi_io_vec[i].bv_page = NULL;
 			}
 			bio_put(bio);
@@ -2015,7 +2015,7 @@ static int run(mddev_t *mddev)
 	 * maybe...
 	 */
 	{
-		int stripe = conf->raid_disks * mddev->chunk_size / PAGE_CACHE_SIZE;
+		int stripe = conf->raid_disks * mddev->chunk_size / PAGE_SIZE;
 		stripe /= conf->near_copies;
 		if (mddev->queue->backing_dev_info.ra_pages < 2* stripe)
 			mddev->queue->backing_dev_info.ra_pages = 2* stripe;

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-12-01 13:56:50.000000000 +1100
+++ ./drivers/md/raid5.c	2005-12-01 13:57:55.000000000 +1100
@@ -167,7 +167,7 @@ static void shrink_buffers(struct stripe
 		if (!p)
 			continue;
 		sh->dev[i].page = NULL;
-		page_cache_release(p);
+		put_page(p);
 	}
 }
 
@@ -1955,7 +1955,7 @@ memory = conf->max_nr_stripes * (sizeof(
 	 */
 	{
 		int stripe = (mddev->raid_disks-1) * mddev->chunk_size
-			/ PAGE_CACHE_SIZE;
+			/ PAGE_SIZE;
 		if (mddev->queue->backing_dev_info.ra_pages < 2 * stripe)
 			mddev->queue->backing_dev_info.ra_pages = 2 * stripe;
 	}

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2005-12-01 13:56:50.000000000 +1100
+++ ./drivers/md/raid6main.c	2005-12-01 13:57:55.000000000 +1100
@@ -186,7 +186,7 @@ static void shrink_buffers(struct stripe
 		if (!p)
 			continue;
 		sh->dev[i].page = NULL;
-		page_cache_release(p);
+		put_page(p);
 	}
 }
 
@@ -2069,7 +2069,7 @@ static int run(mddev_t *mddev)
 	 */
 	{
 		int stripe = (mddev->raid_disks-2) * mddev->chunk_size
-			/ PAGE_CACHE_SIZE;
+			/ PAGE_SIZE;
 		if (mddev->queue->backing_dev_info.ra_pages < 2 * stripe)
 			mddev->queue->backing_dev_info.ra_pages = 2 * stripe;
 	}
@@ -2084,7 +2084,7 @@ abort:
 	if (conf) {
 		print_raid6_conf(conf);
 		if (conf->spare_page)
-			page_cache_release(conf->spare_page);
+			put_page(conf->spare_page);
 		if (conf->stripe_hashtbl)
 			free_pages((unsigned long) conf->stripe_hashtbl,
 							HASH_PAGES_ORDER);
