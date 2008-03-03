From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 9] md: Reduce CPU wastage on idle md array with a write-intent bitmap.
Date: Mon, 3 Mar 2008 11:17:11 +1100
Message-ID: <1080303001711.23593@suse.de>
References: <20080303111240.23302.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


On an md array with a write-intent bitmap, a thread wakes up every few
seconds and scans the bitmap looking for work to do.  If the
array is idle, there will be no work to do, but a lot of scanning is
done to discover this.

So cache the fact that the bitmap is completely clean, and avoid
scanning the whole bitmap when the cache is known to be clean.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c         |   19 +++++++++++++++++--
 ./include/linux/raid/bitmap.h |    2 ++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff .prev/drivers/md/bitmap.c ./drivers/md/bitmap.c
--- .prev/drivers/md/bitmap.c	2008-02-22 15:45:56.000000000 +1100
+++ ./drivers/md/bitmap.c	2008-02-22 15:45:56.000000000 +1100
@@ -1047,6 +1047,11 @@ void bitmap_daemon_work(struct bitmap *b
 	if (time_before(jiffies, bitmap->daemon_lastrun + bitmap->daemon_sleep*HZ))
 		return;
 	bitmap->daemon_lastrun = jiffies;
+	if (bitmap->allclean) {
+		bitmap->mddev->thread->timeout = MAX_SCHEDULE_TIMEOUT;
+		return;
+	}
+	bitmap->allclean = 1;
 
 	for (j = 0; j < bitmap->chunks; j++) {
 		bitmap_counter_t *bmc;
@@ -1068,8 +1073,10 @@ void bitmap_daemon_work(struct bitmap *b
 					clear_page_attr(bitmap, page, BITMAP_PAGE_NEEDWRITE);
 
 				spin_unlock_irqrestore(&bitmap->lock, flags);
-				if (need_write)
+				if (need_write) {
 					write_page(bitmap, page, 0);
+					bitmap->allclean = 0;
+				}
 				continue;
 			}
 
@@ -1098,6 +1105,9 @@ void bitmap_daemon_work(struct bitmap *b
 /*
   if (j < 100) printk("bitmap: j=%lu, *bmc = 0x%x\n", j, *bmc);
 */
+			if (*bmc)
+				bitmap->allclean = 0;
+
 			if (*bmc == 2) {
 				*bmc=1; /* maybe clear the bit next time */
 				set_page_attr(bitmap, page, BITMAP_PAGE_CLEAN);
@@ -1132,6 +1142,8 @@ void bitmap_daemon_work(struct bitmap *b
 		}
 	}
 
+	if (bitmap->allclean == 0)
+		bitmap->mddev->thread->timeout = bitmap->daemon_sleep * HZ;
 }
 
 static bitmap_counter_t *bitmap_get_counter(struct bitmap *bitmap,
@@ -1226,6 +1238,7 @@ int bitmap_startwrite(struct bitmap *bit
 			sectors -= blocks;
 		else sectors = 0;
 	}
+	bitmap->allclean = 0;
 	return 0;
 }
 
@@ -1296,6 +1309,7 @@ int bitmap_start_sync(struct bitmap *bit
 		}
 	}
 	spin_unlock_irq(&bitmap->lock);
+	bitmap->allclean = 0;
 	return rv;
 }
 
@@ -1332,6 +1346,7 @@ void bitmap_end_sync(struct bitmap *bitm
 	}
  unlock:
 	spin_unlock_irqrestore(&bitmap->lock, flags);
+	bitmap->allclean = 0;
 }
 
 void bitmap_close_sync(struct bitmap *bitmap)
@@ -1399,7 +1414,7 @@ static void bitmap_set_memory_bits(struc
 		set_page_attr(bitmap, page, BITMAP_PAGE_CLEAN);
 	}
 	spin_unlock_irq(&bitmap->lock);
-
+	bitmap->allclean = 0;
 }
 
 /* dirty the memory and file bits for bitmap chunks "s" to "e" */

diff .prev/include/linux/raid/bitmap.h ./include/linux/raid/bitmap.h
--- .prev/include/linux/raid/bitmap.h	2008-02-22 15:45:56.000000000 +1100
+++ ./include/linux/raid/bitmap.h	2008-02-22 15:45:56.000000000 +1100
@@ -235,6 +235,8 @@ struct bitmap {
 
 	unsigned long flags;
 
+	int allclean;
+
 	unsigned long max_write_behind; /* write-behind mode */
 	atomic_t behind_writes;
 
