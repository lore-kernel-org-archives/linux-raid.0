From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] MD - 2 of 27 - Remove dead consistancy checking code from multipath.
Date: Thu, 18 Jul 2002 23:32:22 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1020718133222.4749@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet
Remove dead consistancy checking code from multipath.

This "consistancy_check" is carried over from raid1 on which multipath
was based, and was not used in raid1 and has since been removed.  Now
it gets removed from multipath too.




 ----------- Diffstat output ------------
 ./drivers/md/multipath.c |   88 -----------------------------------------------
 1 files changed, 88 deletions(-)

--- ./drivers/md/multipath.c	2002/07/18 11:57:49	1.2
+++ ./drivers/md/multipath.c	2002/07/18 11:58:06	1.3
@@ -700,83 +700,6 @@ static void multipathd (void *data)
 #undef IO_ERROR
 #undef REDIRECT_SECTOR
 
-/*
- * This will catch the scenario in which one of the multipaths was
- * mounted as a normal device rather than as a part of a raid set.
- *
- * check_consistency is very personality-dependent, eg. RAID5 cannot
- * do this check, it uses another method.
- */
-static int __check_consistency (mddev_t *mddev, int row)
-{
-	multipath_conf_t *conf = mddev_to_conf(mddev);
-	int disks = MD_SB_DISKS;
-	struct block_device *bdev;
-	int i, rc = 0;
-	char *buffer;
-	struct page *page = NULL;
-	int first = 1;
-	int order = PAGE_CACHE_SHIFT-PAGE_SHIFT;
-
-	buffer = (char *) __get_free_pages(GFP_KERNEL, order);
-	if (!buffer)
-		return rc;
-
-	for (i = 0; i < disks; i++) {
-		struct address_space *mapping;
-		char *p;
-		if (!conf->multipaths[i].operational)
-			continue;
-		printk("(checking disk %d)\n",i);
-		bdev = conf->multipaths[i].bdev;
-		mapping = bdev->bd_inode->i_mapping;
-		page = read_cache_page(mapping, row/(PAGE_CACHE_SIZE/1024),
-				(filler_t *)mapping->a_ops->readpage, NULL);
-		if (IS_ERR(page)) {
-			page = NULL;
-			break;
-		}
-		wait_on_page_locked(page);
-		if (!PageUptodate(page))
-			break;
-		if (PageError(page))
-			break;
-		p = page_address(page);
-		if (first) {
-			memcpy(buffer, p, PAGE_CACHE_SIZE);
-			first = 0;
-		} else if (memcmp(buffer, p, PAGE_CACHE_SIZE)) {
-			rc = 1;
-			break;
-		}
-		page_cache_release(page);
-		fsync_bdev(bdev);
-		invalidate_bdev(bdev, 0);
-		page = NULL;
-	}
-	if (page) {
-		bdev = page->mapping->host->i_bdev;
-		page_cache_release(page);
-		fsync_bdev(bdev);
-		invalidate_bdev(bdev, 0);
-	}
-	free_pages((unsigned long) buffer, order);
-	return rc;
-}
-
-static int check_consistency (mddev_t *mddev)
-{
-	if (__check_consistency(mddev, 0))
-/*
- * we do not do this currently, as it's perfectly possible to
- * have an inconsistent array when it's freshly created. Only
- * newly written data has to be consistent.
- */
-		return 0;
-
-	return 0;
-}
-
 #define INVALID_LEVEL KERN_WARNING \
 "multipath: md%d: raid level not set to multipath IO (%d)\n"
 
@@ -961,17 +884,6 @@ static int multipath_run (mddev_t *mddev
 	if (multipath_grow_mpbh(conf, NR_RESERVED_BUFS) < NR_RESERVED_BUFS) {
 		printk(MEM_ERROR, mdidx(mddev));
 		goto out_free_conf;
-	}
-
-	if ((sb->state & (1 << MD_SB_CLEAN))) {
-		/*
-		 * we do sanity checks even if the device says
-		 * it's clean ...
-		 */
-		if (check_consistency(mddev)) {
-			printk(SB_DIFFERENCES);
-			sb->state &= ~(1 << MD_SB_CLEAN);
-		}
 	}
 
 	{
