From: NeilBrown <neilb@suse.de>
Subject: [PATCH md ] Better handling of readerrors with raid5.
Date: Fri, 16 Sep 2005 13:01:57 +1000
Message-ID: <1050916030157.11071@suse.de>
References: <20050916125754.11044.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

TESTERS WANTED!!  SEE BELOW...

This patch changes the behaviour of raid5 when it gets a read error.
Instead of just failing the device, it tried to find out what should
have been there, and writes it over the bad block.  For some
media-errors, this has a reasonable chance of fixing the error.
If the write succeeds, and a subsequent read succeeds as well, raid5
decided the address is OK and conitnues.

I have tested this using the 'faulty' md personality, but it would be
really good to test it with real disks that have real errors.  If
anyone has such drives in a cupboard (or even in a computer) and would
be willing to give this a try, I would really appreciate it.

Meanwhile, I think it is OK to go into -mm, but certainly not to go to
Linus yet.

Thanks,
NeilBrown


### Comments for Changeset


Instead of failing a drive on read-error, we attempt to
re-write the block, and then re-read.  If that all works,
we allow the device to remain in the array.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c         |   61 +++++++++++++++++++++++++++++++++++++++----
 ./include/linux/raid/raid5.h |    2 +
 2 files changed, 58 insertions(+), 5 deletions(-)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-09-16 12:21:24.000000000 +1000
+++ ./drivers/md/raid5.c	2005-09-16 12:57:12.000000000 +1000
@@ -349,7 +349,7 @@ static void shrink_stripes(raid5_conf_t 
 	conf->slab_cache = NULL;
 }
 
-static int raid5_end_read_request (struct bio * bi, unsigned int bytes_done,
+static int raid5_end_read_request(struct bio * bi, unsigned int bytes_done,
 				   int error)
 {
  	struct stripe_head *sh = bi->bi_private;
@@ -401,10 +401,27 @@ static int raid5_end_read_request (struc
 		}
 #else
 		set_bit(R5_UPTODATE, &sh->dev[i].flags);
-#endif		
+#endif
+		if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
+			printk("R5: read error corrected!!\n");
+			clear_bit(R5_ReadError, &sh->dev[i].flags);
+			clear_bit(R5_ReWrite, &sh->dev[i].flags);
+		}
 	} else {
-		md_error(conf->mddev, conf->disks[i].rdev);
 		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
+		if (conf->mddev->degraded) {
+			printk("R5: read error not correctable.\n");
+			clear_bit(R5_ReadError, &sh->dev[i].flags);
+			clear_bit(R5_ReWrite, &sh->dev[i].flags);
+			md_error(conf->mddev, conf->disks[i].rdev);
+		} else if (test_bit(R5_ReWrite, &sh->dev[i].flags)) {
+			/* Oh, no!!! */
+			printk("R5: read error NOT corrected!!\n");
+			clear_bit(R5_ReadError, &sh->dev[i].flags);
+			clear_bit(R5_ReWrite, &sh->dev[i].flags);
+			md_error(conf->mddev, conf->disks[i].rdev);
+		} else
+			set_bit(R5_ReadError, &sh->dev[i].flags);
 	}
 	rdev_dec_pending(conf->disks[i].rdev, conf->mddev);
 #if 0
@@ -966,6 +983,12 @@ static void handle_stripe(struct stripe_
 		if (dev->written) written++;
 		rdev = conf->disks[i].rdev; /* FIXME, should I be looking rdev */
 		if (!rdev || !rdev->in_sync) {
+			/* The ReadError flag wil just be confusing now */
+			clear_bit(R5_ReadError, &dev->flags);
+			clear_bit(R5_ReWrite, &dev->flags);
+		}
+		if (!rdev || !rdev->in_sync
+		    || test_bit(R5_ReadError, &dev->flags)) {
 			failed++;
 			failed_num = i;
 		} else
@@ -980,6 +1003,14 @@ static void handle_stripe(struct stripe_
 	if (failed > 1 && to_read+to_write+written) {
 		for (i=disks; i--; ) {
 			int bitmap_end = 0;
+
+			if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
+				mdk_rdev_t *rdev = conf->disks[i].rdev;
+				if (rdev && rdev->in_sync)
+					/* multiple read failures in one stripe */
+					md_error(conf->mddev, rdev);
+			}
+
 			spin_lock_irq(&conf->device_lock);
 			/* fail all writes first */
 			bi = sh->dev[i].towrite;
@@ -1015,7 +1046,8 @@ static void handle_stripe(struct stripe_
 			}
 
 			/* fail any reads if this device is non-operational */
-			if (!test_bit(R5_Insync, &sh->dev[i].flags)) {
+			if (!test_bit(R5_Insync, &sh->dev[i].flags) ||
+			    test_bit(R5_ReadError, &sh->dev[i].flags)) {
 				bi = sh->dev[i].toread;
 				sh->dev[i].toread = NULL;
 				if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
@@ -1274,7 +1306,26 @@ static void handle_stripe(struct stripe_
 		md_done_sync(conf->mddev, STRIPE_SECTORS,1);
 		clear_bit(STRIPE_SYNCING, &sh->state);
 	}
-	
+
+	/* If the failed drive is just a ReadError, then we might need to progress
+	 * the repair/check process
+	 */
+	if (failed == 1 && test_bit(R5_ReadError, &sh->dev[failed_num].flags)
+	    && !test_bit(R5_LOCKED, &sh->dev[failed_num].flags)
+	    && test_bit(R5_UPTODATE, &sh->dev[failed_num].flags)
+		) {
+		dev = &sh->dev[failed_num];
+		if (!test_bit(R5_ReWrite, &dev->flags)) {
+			set_bit(R5_Wantwrite, &dev->flags);
+			set_bit(R5_ReWrite, &dev->flags);
+			set_bit(R5_LOCKED, &dev->flags);
+		} else {
+			/* let's read it back */
+			set_bit(R5_Wantread, &dev->flags);
+			set_bit(R5_LOCKED, &dev->flags);
+		}
+	}
+
 	spin_unlock(&sh->lock);
 
 	while ((bi=return_bi)) {

diff ./include/linux/raid/raid5.h~current~ ./include/linux/raid/raid5.h
--- ./include/linux/raid/raid5.h~current~	2005-09-16 12:21:24.000000000 +1000
+++ ./include/linux/raid/raid5.h	2005-09-16 12:55:51.000000000 +1000
@@ -154,6 +154,8 @@ struct stripe_head {
 #define	R5_Wantwrite	5
 #define	R5_Syncio	6	/* this io need to be accounted as resync io */
 #define	R5_Overlap	7	/* There is a pending overlapping request on this block */
+#define	R5_ReadError	8	/* seen a read error here recently */
+#define	R5_ReWrite	9	/* have tried to over-write the readerror */
 
 /*
  * Write method
