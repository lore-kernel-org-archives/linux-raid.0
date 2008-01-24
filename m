From: Neil Brown <neilb@suse.de>
Subject: Re: idle array consuming cpu ??!!
Date: Thu, 24 Jan 2008 15:55:50 +1100
Message-ID: <18328.6742.625490.166920@notabene.brown>
References: <18323.53904.556620.19761@fisica.ufpr.br>
	<18323.61999.693738.678224@notabene.brown>
	<18325.21501.507878.267465@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Carlos Carvalho on Tuesday January 22
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday January 22, carlos@fisica.ufpr.br wrote:
> Neil Brown (neilb@suse.de) wrote on 21 January 2008 12:15:
>  >On Sunday January 20, carlos@fisica.ufpr.br wrote:
>  >> A raid6 array with a spare and bitmap is idle: not mounted and with no
>  >> IO to it or any of its disks (obviously), as shown by iostat. However
>  >> it's consuming cpu: since reboot it used about 11min in 24h, which is quite
>  >> a lot even for a busy array (the cpus are fast). The array was cleanly
>  >> shutdown so there's been no reconstruction/check or anything else.
>  >> 
>  >> How can this be? Kernel is 2.6.22.16 with the two patches for the
>  >> deadlock ("[PATCH 004 of 4] md: Fix an occasional deadlock in raid5 -
>  >> FIX") and the previous one.
>  >
>  >Maybe the bitmap code is waking up regularly to do nothing.
>  >
>  >Would you be happy to experiment?  Remove the bitmap with
>  >   mdadm --grow /dev/mdX --bitmap=none
>  >
>  >and see how that affects cpu usage?
> 
> Confirmed, removing the bitmap stopped cpu consumption.

Thanks.

This patch should substantiallly reduce cpu consumption on an idle
bitmap.

NeilBrown

----------------------
Reduce CPU wastage on idle md array with a write-intent bitmap.

On an md array with a write-intent bitmap, a thread wakes up every few
seconds to and scans the bitmap looking for work to do.  If there
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
--- .prev/drivers/md/bitmap.c	2008-01-24 15:53:45.000000000 +1100
+++ ./drivers/md/bitmap.c	2008-01-24 15:54:29.000000000 +1100
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
--- .prev/include/linux/raid/bitmap.h	2008-01-24 15:53:45.000000000 +1100
+++ ./include/linux/raid/bitmap.h	2008-01-24 15:54:29.000000000 +1100
@@ -235,6 +235,8 @@ struct bitmap {
 
 	unsigned long flags;
 
+	int allclean;
+
 	unsigned long max_write_behind; /* write-behind mode */
 	atomic_t behind_writes;
 
