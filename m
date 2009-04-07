From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] md: tiny md.h cleanups
Date: Tue, 7 Apr 2009 18:15:48 +0200
Message-ID: <20090407161548.GA11724@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 - update inclusion guard and make sure it covers the whole file
 - remove superflous #ifdef CONFIG_BLOCK
 - make sure all required headers are included so that new users aren't
   required to include others before


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/md/md.h
===================================================================
--- linux-2.6.orig/drivers/md/md.h	2009-04-06 14:17:05.642571528 +0200
+++ linux-2.6/drivers/md/md.h	2009-04-07 17:56:33.472570155 +0200
@@ -12,10 +12,17 @@
    Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.  
 */
 
-#ifndef _MD_K_H
-#define _MD_K_H
+#ifndef _MD_MD_H
+#define _MD_MD_H
 
-#ifdef CONFIG_BLOCK
+#include <linux/blkdev.h>
+#include <linux/kobject.h>
+#include <linux/list.h>
+#include <linux/mm.h>
+#include <linux/mutex.h>
+#include <linux/timer.h>
+#include <linux/wait.h>
+#include <linux/workqueue.h>
 
 #define MaxSector (~(sector_t)0)
 
@@ -408,10 +415,6 @@ static inline void safe_put_page(struct 
 	if (p) put_page(p);
 }
 
-#endif /* CONFIG_BLOCK */
-#endif
-
-
 extern int register_md_personality(struct mdk_personality *p);
 extern int unregister_md_personality(struct mdk_personality *p);
 extern mdk_thread_t * md_register_thread(void (*run) (mddev_t *mddev),
@@ -434,3 +437,5 @@ extern void md_new_event(mddev_t *mddev)
 extern int md_allow_write(mddev_t *mddev);
 extern void md_wait_for_blocked_rdev(mdk_rdev_t *rdev, mddev_t *mddev);
 extern void md_set_array_sectors(mddev_t *mddev, sector_t array_sectors);
+
+#endif /* _MD_MD_H */
