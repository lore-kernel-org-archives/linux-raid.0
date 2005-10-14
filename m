From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 005 of 8] Improvements to raid5 handling of read errors
Date: Fri, 14 Oct 2005 12:26:16 +1000
Message-ID: <1051014022616.11817@suse.de>
References: <20051014122335.11602.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Two refinements to the 'attempt-overwrite-on-read-error' mechanism.
1/ If the array is read-only, don't attempt an over-write.
2/ If there are more than max_nr_stripes read errors on a device with
   no success, fail the drive.  This will make sure a dead
   drive will be eventually kicked even when we aren't trying
   to rewrite (which would normally kick a dead drive more quickly.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c           |    1 +
 ./drivers/md/raid5.c        |   25 +++++++++++++++++--------
 ./include/linux/raid/md_k.h |    3 +++
 3 files changed, 21 insertions(+), 8 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-10-14 12:16:38.000000000 +1000
+++ ./drivers/md/md.c	2005-10-14 12:16:55.000000000 +1000
@@ -1582,6 +1582,7 @@ static mdk_rdev_t *md_import_device(dev_
 	rdev->in_sync = 0;
 	rdev->data_offset = 0;
 	atomic_set(&rdev->nr_pending, 0);
+	atomic_set(&rdev->read_errors, 0);
 
 	size = rdev->bdev->bd_inode->i_size >> BLOCK_SIZE_BITS;
 	if (!size) {

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-10-14 12:16:39.000000000 +1000
+++ ./drivers/md/raid5.c	2005-10-14 12:16:55.000000000 +1000
@@ -420,21 +420,29 @@ static int raid5_end_read_request(struct
 			clear_bit(R5_ReadError, &sh->dev[i].flags);
 			clear_bit(R5_ReWrite, &sh->dev[i].flags);
 		}
+		if (atomic_read(&conf->disks[i].rdev->read_errors))
+			atomic_set(&conf->disks[i].rdev->read_errors, 0);
 	} else {
+		int retry = 0;
 		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
-		if (conf->mddev->degraded) {
+		atomic_inc(&conf->disks[i].rdev->read_errors);
+		if (conf->mddev->degraded)
 			printk("R5: read error not correctable.\n");
-			clear_bit(R5_ReadError, &sh->dev[i].flags);
-			clear_bit(R5_ReWrite, &sh->dev[i].flags);
-			md_error(conf->mddev, conf->disks[i].rdev);
-		} else if (test_bit(R5_ReWrite, &sh->dev[i].flags)) {
+		else if (test_bit(R5_ReWrite, &sh->dev[i].flags))
 			/* Oh, no!!! */
 			printk("R5: read error NOT corrected!!\n");
+		else if (atomic_read(&conf->disks[i].rdev->read_errors)
+			 > conf->max_nr_stripes)
+			printk("raid5: Too many read errors, failing device.\n");
+		else
+			retry = 1;
+		if (retry)
+			set_bit(R5_ReadError, &sh->dev[i].flags);
+		else {
 			clear_bit(R5_ReadError, &sh->dev[i].flags);
 			clear_bit(R5_ReWrite, &sh->dev[i].flags);
 			md_error(conf->mddev, conf->disks[i].rdev);
-		} else
-			set_bit(R5_ReadError, &sh->dev[i].flags);
+		}
 	}
 	rdev_dec_pending(conf->disks[i].rdev, conf->mddev);
 #if 0
@@ -1328,7 +1336,8 @@ static void handle_stripe(struct stripe_
 	/* If the failed drive is just a ReadError, then we might need to progress
 	 * the repair/check process
 	 */
-	if (failed == 1 && test_bit(R5_ReadError, &sh->dev[failed_num].flags)
+	if (failed == 1 && ! conf->mddev->ro &&
+	    test_bit(R5_ReadError, &sh->dev[failed_num].flags)
 	    && !test_bit(R5_LOCKED, &sh->dev[failed_num].flags)
 	    && test_bit(R5_UPTODATE, &sh->dev[failed_num].flags)
 		) {

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2005-10-14 12:16:39.000000000 +1000
+++ ./include/linux/raid/md_k.h	2005-10-14 12:16:55.000000000 +1000
@@ -134,6 +134,9 @@ struct mdk_rdev_s
 					 * only maintained for arrays that
 					 * support hot removal
 					 */
+	atomic_t	read_errors;	/* number of consecutive read errors that
+					 * we have tried to ignore.
+					 */
 };
 
 typedef struct mdk_personality_s mdk_personality_t;
