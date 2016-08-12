From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH V2 04/10] md: changes for MD_STILL_CLOSED flag
Date: Fri, 12 Aug 2016 13:42:37 +0800
Message-ID: <1470980563-26062-5-git-send-email-gqjiang@suse.com>
References: <1470980563-26062-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1470980563-26062-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

When stop clustered raid while it is pending on resync,
MD_STILL_CLOSED flag could be cleared since udev rule
is triggered to open the mddev. So obviously array can't
be stopped soon and returns EBUSY.

	mdadm -Ss          md-raid-arrays.rules
  set MD_STILL_CLOSED          md_open()
	... ... ...          clear MD_STILL_CLOSED
	do_md_stop

We make below changes to resolve this issue:

1. rename MD_STILL_CLOSED to MD_CLOSING since it is set
   when stop array and it means we are stopping array.
2. let md_open returns early if CLOSING is set, so no
   other threads will open array if one thread is trying
   to close it.
3. no need to clear CLOSING bit in md_open because 1 has
   ensure the bit is cleared, then we also don't need to
   test CLOSING bit in do_md_stop.

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md.c | 14 ++++++++------
 drivers/md/md.h |  5 ++---
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d6ae9bc..da5741c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5576,8 +5576,7 @@ static int md_set_readonly(struct mddev *mddev, struct block_device *bdev)
 	mutex_lock(&mddev->open_mutex);
 	if ((mddev->pers && atomic_read(&mddev->openers) > !!bdev) ||
 	    mddev->sync_thread ||
-	    test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
-	    (bdev && !test_bit(MD_STILL_CLOSED, &mddev->flags))) {
+	    test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
 		printk("md: %s still in use.\n",mdname(mddev));
 		if (did_freeze) {
 			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
@@ -5639,8 +5638,7 @@ static int do_md_stop(struct mddev *mddev, int mode,
 	if ((mddev->pers && atomic_read(&mddev->openers) > !!bdev) ||
 	    mddev->sysfs_active ||
 	    mddev->sync_thread ||
-	    test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
-	    (bdev && !test_bit(MD_STILL_CLOSED, &mddev->flags))) {
+	    test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
 		printk("md: %s still in use.\n",mdname(mddev));
 		mutex_unlock(&mddev->open_mutex);
 		if (did_freeze) {
@@ -6825,7 +6823,7 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 			err = -EBUSY;
 			goto out;
 		}
-		set_bit(MD_STILL_CLOSED, &mddev->flags);
+		set_bit(MD_CLOSING, &mddev->flags);
 		mutex_unlock(&mddev->open_mutex);
 		sync_blockdev(bdev);
 	}
@@ -7074,9 +7072,13 @@ static int md_open(struct block_device *bdev, fmode_t mode)
 	if ((err = mutex_lock_interruptible(&mddev->open_mutex)))
 		goto out;
 
+	if (test_bit(MD_CLOSING, &mddev->flags)) {
+		mutex_unlock(&mddev->open_mutex);
+		return -ENODEV;
+	}
+
 	err = 0;
 	atomic_inc(&mddev->openers);
-	clear_bit(MD_STILL_CLOSED, &mddev->flags);
 	mutex_unlock(&mddev->open_mutex);
 
 	check_disk_change(bdev);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 20c6675..2b20417 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -201,9 +201,8 @@ struct mddev {
 #define MD_CHANGE_PENDING 2	/* switch from 'clean' to 'active' in progress */
 #define MD_UPDATE_SB_FLAGS (1 | 2 | 4)	/* If these are set, md_update_sb needed */
 #define MD_ARRAY_FIRST_USE 3    /* First use of array, needs initialization */
-#define MD_STILL_CLOSED	4	/* If set, then array has not been opened since
-				 * md_ioctl checked on it.
-				 */
+#define MD_CLOSING	4	/* If set, we are closing the array, do not open
+				 * it then */
 #define MD_JOURNAL_CLEAN 5	/* A raid with journal is already clean */
 #define MD_HAS_JOURNAL	6	/* The raid array has journal feature set */
 #define MD_RELOAD_SB	7	/* Reload the superblock because another node
-- 
2.6.2

