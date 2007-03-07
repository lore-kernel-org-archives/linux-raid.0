From: Greg KH <gregkh@suse.de>
Subject: [patch 021/101] md: Avoid possible BUG_ON in md bitmap handling.
Date: Wed, 07 Mar 2007 09:10:56 -0800
Message-ID: <20070307171226.114733654@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=md-avoid-possible-bug_on-in-md-bitmap-handling.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>, Zwane Mwaikambo <zwane@arm.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>, Chris Wedgwood <reviews@ml.cw.f00f.org>, Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>, torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk, linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

From: Neil Brown <neilb@suse.de>

md/bitmap tracks how many active write requests are pending on blocks
associated with each bit in the bitmap, so that it knows when it can
clear the bit (when count hits zero).

The counter has 14 bits of space, so if there are ever more than 16383,
we cannot cope.

Currently the code just calles BUG_ON as "all" drivers have request queue
limits much smaller than this.

However is seems that some don't.  Apparently some multipath configurations
can allow more than 16383 concurrent write requests.

So, in this unlikely situation, instead of calling BUG_ON we now wait
for the count to drop down a bit.  This requires a new wait_queue_head,
some waiting code, and a wakeup call.

Tested by limiting the counter to 20 instead of 16383 (writes go a lot slower
in that case...).

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff .prev/drivers/md/bitmap.c ./drivers/md/bitmap.c
---
 drivers/md/bitmap.c         |   22 +++++++++++++++++++++-
 include/linux/raid/bitmap.h |    1 +
 2 files changed, 22 insertions(+), 1 deletion(-)

--- linux-2.6.20.1.orig/drivers/md/bitmap.c
+++ linux-2.6.20.1/drivers/md/bitmap.c
@@ -1160,6 +1160,22 @@ int bitmap_startwrite(struct bitmap *bit
 			return 0;
 		}
 
+		if (unlikely((*bmc & COUNTER_MAX) == COUNTER_MAX)) {
+			DEFINE_WAIT(__wait);
+			/* note that it is safe to do the prepare_to_wait
+			 * after the test as long as we do it before dropping
+			 * the spinlock.
+			 */
+			prepare_to_wait(&bitmap->overflow_wait, &__wait,
+					TASK_UNINTERRUPTIBLE);
+			spin_unlock_irq(&bitmap->lock);
+			bitmap->mddev->queue
+				->unplug_fn(bitmap->mddev->queue);
+			schedule();
+			finish_wait(&bitmap->overflow_wait, &__wait);
+			continue;
+		}
+
 		switch(*bmc) {
 		case 0:
 			bitmap_file_set_bit(bitmap, offset);
@@ -1169,7 +1185,7 @@ int bitmap_startwrite(struct bitmap *bit
 		case 1:
 			*bmc = 2;
 		}
-		BUG_ON((*bmc & COUNTER_MAX) == COUNTER_MAX);
+
 		(*bmc)++;
 
 		spin_unlock_irq(&bitmap->lock);
@@ -1207,6 +1223,9 @@ void bitmap_endwrite(struct bitmap *bitm
 		if (!success && ! (*bmc & NEEDED_MASK))
 			*bmc |= NEEDED_MASK;
 
+		if ((*bmc & COUNTER_MAX) == COUNTER_MAX)
+			wake_up(&bitmap->overflow_wait);
+
 		(*bmc)--;
 		if (*bmc <= 2) {
 			set_page_attr(bitmap,
@@ -1431,6 +1450,7 @@ int bitmap_create(mddev_t *mddev)
 	spin_lock_init(&bitmap->lock);
 	atomic_set(&bitmap->pending_writes, 0);
 	init_waitqueue_head(&bitmap->write_wait);
+	init_waitqueue_head(&bitmap->overflow_wait);
 
 	bitmap->mddev = mddev;
 
--- linux-2.6.20.1.orig/include/linux/raid/bitmap.h
+++ linux-2.6.20.1/include/linux/raid/bitmap.h
@@ -247,6 +247,7 @@ struct bitmap {
 
 	atomic_t pending_writes; /* pending writes to the bitmap file */
 	wait_queue_head_t write_wait;
+	wait_queue_head_t overflow_wait;
 
 };
 

--
