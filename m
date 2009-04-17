From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 1/4] md: tiny md.h cleanups
Date: Fri, 17 Apr 2009 12:14:53 +1000
Message-ID: <20090417021453.13390.9543.stgit@notabene.brown>
References: <20090417020953.13390.5371.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090417020953.13390.5371.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

From: Christoph Hellwig <hch@lst.de>

- update inclusion guard and make sure it covers the whole file
 - remove superflous #ifdef CONFIG_BLOCK
 - make sure all required headers are included so that new users aren't
   required to include others before

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.h |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index e9b7f54..8227ab9 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -12,10 +12,17 @@
    Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.  
 */
 
-#ifndef _MD_K_H
-#define _MD_K_H
-
-#ifdef CONFIG_BLOCK
+#ifndef _MD_MD_H
+#define _MD_MD_H
+
+#include <linux/blkdev.h>
+#include <linux/kobject.h>
+#include <linux/list.h>
+#include <linux/mm.h>
+#include <linux/mutex.h>
+#include <linux/timer.h>
+#include <linux/wait.h>
+#include <linux/workqueue.h>
 
 #define MaxSector (~(sector_t)0)
 
@@ -408,10 +415,6 @@ static inline void safe_put_page(struct page *p)
 	if (p) put_page(p);
 }
 
-#endif /* CONFIG_BLOCK */
-#endif
-
-
 extern int register_md_personality(struct mdk_personality *p);
 extern int unregister_md_personality(struct mdk_personality *p);
 extern mdk_thread_t * md_register_thread(void (*run) (mddev_t *mddev),
@@ -434,3 +437,5 @@ extern void md_new_event(mddev_t *mddev);
 extern int md_allow_write(mddev_t *mddev);
 extern void md_wait_for_blocked_rdev(mdk_rdev_t *rdev, mddev_t *mddev);
 extern void md_set_array_sectors(mddev_t *mddev, sector_t array_sectors);
+
+#endif /* _MD_MD_H */


