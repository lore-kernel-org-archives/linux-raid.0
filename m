From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 007 of 7] Tidy up daemon stop/start code in md/bitmap.c
Date: Mon, 29 Aug 2005 17:33:39 +1000
Message-ID: <E1E9e9D-0003X4-Ky@notabene.cse.unsw.edu.au>
References: <20050829172936.12848.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


The bitmap code used to have two daemons, so there is some 'common'
start/stop code.  But now there is only one, so the common code is
just noise.

This patch tidies this up somewhat.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/bitmap.c |   73 ++++++++++++++++++--------------------------------
 1 file changed, 27 insertions(+), 46 deletions(-)

diff ./drivers/md/bitmap.c~current~ ./drivers/md/bitmap.c
--- ./drivers/md/bitmap.c~current~	2005-08-29 16:46:50.000000000 +1000
+++ ./drivers/md/bitmap.c	2005-08-29 17:04:24.000000000 +1000
@@ -626,7 +626,7 @@ static void bitmap_file_unmap(struct bit
 		page_cache_release(sb_page);
 }
 
-static void bitmap_stop_daemons(struct bitmap *bitmap);
+static void bitmap_stop_daemon(struct bitmap *bitmap);
 
 /* dequeue the next item in a page list -- don't call from irq context */
 static struct page_list *dequeue_page(struct bitmap *bitmap)
@@ -668,7 +668,7 @@ static void bitmap_file_put(struct bitma
 	bitmap->file = NULL;
 	spin_unlock_irqrestore(&bitmap->lock, flags);
 
-	bitmap_stop_daemons(bitmap);
+	bitmap_stop_daemon(bitmap);
 
 	drain_write_queues(bitmap);
 
@@ -1188,21 +1188,12 @@ static void bitmap_writeback_daemon(mdde
 	}
 }
 
-static int bitmap_start_daemon(struct bitmap *bitmap, mdk_thread_t **ptr,
+static mdk_thread_t *bitmap_start_daemon(struct bitmap *bitmap,
 				void (*func)(mddev_t *), char *name)
 {
 	mdk_thread_t *daemon;
-	unsigned long flags;
 	char namebuf[32];
 
-	spin_lock_irqsave(&bitmap->lock, flags);
-	*ptr = NULL;
-
-	if (!bitmap->file) /* no need for daemon if there's no backing file */
-		goto out_unlock;
-
-	spin_unlock_irqrestore(&bitmap->lock, flags);
-
 #ifdef INJECT_FATAL_FAULT_2
 	daemon = NULL;
 #else
@@ -1212,47 +1203,32 @@ static int bitmap_start_daemon(struct bi
 	if (!daemon) {
 		printk(KERN_ERR "%s: failed to start bitmap daemon\n",
 			bmname(bitmap));
-		return -ECHILD;
+		return ERR_PTR(-ECHILD);
 	}
 
-	spin_lock_irqsave(&bitmap->lock, flags);
-	*ptr = daemon;
-
 	md_wakeup_thread(daemon); /* start it running */
 
 	PRINTK("%s: %s daemon (pid %d) started...\n",
 		bmname(bitmap), name, daemon->tsk->pid);
-out_unlock:
-	spin_unlock_irqrestore(&bitmap->lock, flags);
-	return 0;
-}
 
-static int bitmap_start_daemons(struct bitmap *bitmap)
-{
-	int err = bitmap_start_daemon(bitmap, &bitmap->writeback_daemon,
-					bitmap_writeback_daemon, "bitmap_wb");
-	return err;
+	return daemon;
 }
 
-static void bitmap_stop_daemon(struct bitmap *bitmap, mdk_thread_t **ptr)
+static void bitmap_stop_daemon(struct bitmap *bitmap)
 {
-	mdk_thread_t *daemon;
-	unsigned long flags;
-
-	spin_lock_irqsave(&bitmap->lock, flags);
-	daemon = *ptr;
-	*ptr = NULL;
-	spin_unlock_irqrestore(&bitmap->lock, flags);
-	if (daemon)
-		md_unregister_thread(daemon); /* destroy the thread */
-}
+	/* the daemon can't stop itself... it'll just exit instead... */
+	if (bitmap->writeback_daemon && ! IS_ERR(bitmap->writeback_daemon) &&
+	    current->pid != bitmap->writeback_daemon->tsk->pid) {
+		mdk_thread_t *daemon;
+		unsigned long flags;
 
-static void bitmap_stop_daemons(struct bitmap *bitmap)
-{
-	/* the daemons can't stop themselves... they'll just exit instead... */
-	if (bitmap->writeback_daemon &&
-	    current->pid != bitmap->writeback_daemon->tsk->pid)
-		bitmap_stop_daemon(bitmap, &bitmap->writeback_daemon);
+		spin_lock_irqsave(&bitmap->lock, flags);
+		daemon = bitmap->writeback_daemon;
+		bitmap->writeback_daemon = NULL;
+		spin_unlock_irqrestore(&bitmap->lock, flags);
+		if (daemon && ! IS_ERR(daemon))
+			md_unregister_thread(daemon); /* destroy the thread */
+	}
 }
 
 static bitmap_counter_t *bitmap_get_counter(struct bitmap *bitmap,
@@ -1637,10 +1613,15 @@ int bitmap_create(mddev_t *mddev)
 
 	mddev->bitmap = bitmap;
 
-	/* kick off the bitmap daemons */
-	err = bitmap_start_daemons(bitmap);
-	if (err)
-		return err;
+	if (file)
+		/* kick off the bitmap writeback daemon */
+		bitmap->writeback_daemon =
+			bitmap_start_daemon(bitmap,
+					    bitmap_writeback_daemon,
+					    "bitmap_wb");
+
+	if (IS_ERR(bitmap->writeback_daemon))
+		return PTR_ERR(bitmap->writeback_daemon);
 	return bitmap_update_sb(bitmap);
 
  error:
