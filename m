From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 013 of 18] Improve handing of read errors with raid6
Date: Mon, 28 Nov 2005 10:40:43 +1100
Message-ID: <1051127234043.14889@suse.de>
References: <20051128102824.14498.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This is a simple port of match functionality across from raid5.
If we get a read error, we don't kick the drive straight away, but
try to over-write with good data first.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid6main.c |   70 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 66 insertions(+), 4 deletions(-)

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2005-11-28 10:12:56.000000000 +1100
+++ ./drivers/md/raid6main.c	2005-11-28 10:12:59.000000000 +1100
@@ -367,8 +367,8 @@ static void shrink_stripes(raid6_conf_t 
 	conf->slab_cache = NULL;
 }
 
-static int raid6_end_read_request (struct bio * bi, unsigned int bytes_done,
-				   int error)
+static int raid6_end_read_request(struct bio * bi, unsigned int bytes_done,
+				  int error)
 {
  	struct stripe_head *sh = bi->bi_private;
 	raid6_conf_t *conf = sh->raid_conf;
@@ -420,9 +420,35 @@ static int raid6_end_read_request (struc
 #else
 		set_bit(R5_UPTODATE, &sh->dev[i].flags);
 #endif
+		if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
+			printk(KERN_INFO "raid6: read error corrected!!\n");
+			clear_bit(R5_ReadError, &sh->dev[i].flags);
+			clear_bit(R5_ReWrite, &sh->dev[i].flags);
+		}
+		if (atomic_read(&conf->disks[i].rdev->read_errors))
+			atomic_set(&conf->disks[i].rdev->read_errors, 0);
 	} else {
-		md_error(conf->mddev, conf->disks[i].rdev);
+		int retry = 0;
 		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
+		atomic_inc(&conf->disks[i].rdev->read_errors);
+		if (conf->mddev->degraded)
+			printk(KERN_WARNING "raid6: read error not correctable.\n");
+		else if (test_bit(R5_ReWrite, &sh->dev[i].flags))
+			/* Oh, no!!! */
+			printk(KERN_WARNING "raid6: read error NOT corrected!!\n");
+		else if (atomic_read(&conf->disks[i].rdev->read_errors)
+			 > conf->max_nr_stripes)
+			printk(KERN_WARNING
+			       "raid6: Too many read errors, failing device.\n");
+		else
+			retry = 1;
+		if (retry)
+			set_bit(R5_ReadError, &sh->dev[i].flags);
+		else {
+			clear_bit(R5_ReadError, &sh->dev[i].flags);
+			clear_bit(R5_ReWrite, &sh->dev[i].flags);
+			md_error(conf->mddev, conf->disks[i].rdev);
+		}
 	}
 	rdev_dec_pending(conf->disks[i].rdev, conf->mddev);
 #if 0
@@ -1079,6 +1105,12 @@ static void handle_stripe(struct stripe_
 		if (dev->written) written++;
 		rdev = conf->disks[i].rdev; /* FIXME, should I be looking rdev */
 		if (!rdev || !test_bit(In_sync, &rdev->flags)) {
+			/* The ReadError flag will just be confusing now */
+			clear_bit(R5_ReadError, &dev->flags);
+			clear_bit(R5_ReWrite, &dev->flags);
+		}
+		if (!rdev || !test_bit(In_sync, &rdev->flags)
+		    || test_bit(R5_ReadError, &dev->flags)) {
 			if ( failed < 2 )
 				failed_num[failed] = i;
 			failed++;
@@ -1095,6 +1127,14 @@ static void handle_stripe(struct stripe_
 	if (failed > 2 && to_read+to_write+written) {
 		for (i=disks; i--; ) {
 			int bitmap_end = 0;
+
+			if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
+				mdk_rdev_t *rdev = conf->disks[i].rdev;
+				if (rdev && test_bit(In_sync, &rdev->flags))
+					/* multiple read failures in one stripe */
+					md_error(conf->mddev, rdev);
+			}
+
 			spin_lock_irq(&conf->device_lock);
 			/* fail all writes first */
 			bi = sh->dev[i].towrite;
@@ -1130,7 +1170,8 @@ static void handle_stripe(struct stripe_
 			}
 
 			/* fail any reads if this device is non-operational */
-			if (!test_bit(R5_Insync, &sh->dev[i].flags)) {
+			if (!test_bit(R5_Insync, &sh->dev[i].flags) ||
+			    test_bit(R5_ReadError, &sh->dev[i].flags)) {
 				bi = sh->dev[i].toread;
 				sh->dev[i].toread = NULL;
 				if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
@@ -1457,6 +1498,27 @@ static void handle_stripe(struct stripe_
 		clear_bit(STRIPE_SYNCING, &sh->state);
 	}
 
+	/* If the failed drives are just a ReadError, then we might need
+	 * to progress the repair/check process
+	 */
+	if (failed <= 2 && ! conf->mddev->ro)
+		for (i=0; i<failed;i++) {
+			dev = &sh->dev[failed_num[i]];
+			if (test_bit(R5_ReadError, &dev->flags)
+			    && !test_bit(R5_LOCKED, &dev->flags)
+			    && test_bit(R5_UPTODATE, &dev->flags)
+				) {
+				if (!test_bit(R5_ReWrite, &dev->flags)) {
+					set_bit(R5_Wantwrite, &dev->flags);
+					set_bit(R5_ReWrite, &dev->flags);
+					set_bit(R5_LOCKED, &dev->flags);
+				} else {
+					/* let's read it back */
+					set_bit(R5_Wantread, &dev->flags);
+					set_bit(R5_LOCKED, &dev->flags);
+				}
+			}
+		}
 	spin_unlock(&sh->lock);
 
 	while ((bi=return_bi)) {
