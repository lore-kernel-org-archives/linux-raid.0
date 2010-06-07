From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 13/16] md: make it easier to wait for bad blocks to be
	acknowledged.
Date: Mon, 07 Jun 2010 10:07:56 +1000
Message-ID: <20100607000755.13302.37749.stgit@notabene.brown>
References: <20100606235833.13302.60932.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100606235833.13302.60932.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It is only safe to choose not to write to a bad block if that bad
block is safely recorded in metadata - i.e. if it has been
'acknowledged'.

If it hasn't we need to wait for the acknowledgement.

We support that using rdev->blocked wait and
md_wait_for_blocked_rdev by introducing a new device flag
'BlockedBadBlock'.

This flag is only advisory.
It is cleared whenever we acknowledge a bad block, so that a waiter
can re-check the particular bad blocks that it is interested it.

It should be set by a caller when they find they need to wait.
This (set after test) is inherently racy, but as
md_wait_for_blocked_rdev already has a timeout, losing the race will
have minimal impact.

When we clear "Blocked" was also clear "BlockedBadBlocks" incase it
was set incorrectly (see above race).

We also modify the way we manage 'Blocked' to fit better with the new
handling of 'BlockedBadBlocks' and to make it consistent between
externally managed and internally managed metadata.

Before writing metadata, we set FaultRecorded for all devices that
are Faulty, then after writing the metadata we clear Blocked for any
device for which the Fault was certainly Recorded.

The 'faulty' device flag now appears in sysfs if the device is faulty
*or* it has unacknowledged bad blocks.  So user-space which does not
understand bad blocks can continue to function correctly.
User space which does, should not assume a device is faulty until it
sees the 'faulty' flag, and then sees the list of unacknowledged bad
blocks is empty.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c     |   63 ++++++++++++++++++++++++++++++++-------------------
 drivers/md/md.h     |   22 ++++++++++++++++--
 drivers/md/raid1.c  |    1 +
 drivers/md/raid10.c |    1 +
 drivers/md/raid5.c  |    1 +
 5 files changed, 63 insertions(+), 25 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 20c6792..16cae2f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2313,9 +2313,12 @@ repeat:
 		return;
 	}
 
-	list_for_each_entry(rdev, &mddev->disks, same_set)
+	list_for_each_entry(rdev, &mddev->disks, same_set) {
 		if (rdev->badblocks.changed)
 			any_badblocks_changed++;
+		if (test_bit(Faulty, &rdev->flags))
+			set_bit(FaultRecorded, &rdev->flags);
+	}
 
 	sync_sbs(mddev, nospares);
 	spin_unlock_irq(&mddev->write_lock);
@@ -2372,9 +2375,14 @@ repeat:
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		sysfs_notify(&mddev->kobj, NULL, "sync_completed");
 
-	if (any_badblocks_changed)
-		list_for_each_entry(rdev, &mddev->disks, same_set)
+	list_for_each_entry(rdev, &mddev->disks, same_set) {
+		if (test_and_clear_bit(FaultRecorded, &rdev->flags))
+			clear_bit(Blocked, &rdev->flags);
+
+		if (any_badblocks_changed)
 			md_ack_all_badblocks(&rdev->badblocks);
+	}
+	wake_up(&rdev->blocked_wait);
 }
 
 /* words written to sysfs files may, or may not, be \n terminated.
@@ -2409,7 +2417,8 @@ state_show(mdk_rdev_t *rdev, char *page)
 	char *sep = "";
 	size_t len = 0;
 
-	if (test_bit(Faulty, &rdev->flags)) {
+	if (test_bit(Faulty, &rdev->flags) ||
+	    rdev->badblocks.unacked_exist) {
 		len+= sprintf(page+len, "%sfaulty",sep);
 		sep = ",";
 	}
@@ -2421,7 +2430,8 @@ state_show(mdk_rdev_t *rdev, char *page)
 		len += sprintf(page+len, "%swrite_mostly",sep);
 		sep = ",";
 	}
-	if (test_bit(Blocked, &rdev->flags)) {
+	if (test_bit(Blocked, &rdev->flags) ||
+	    rdev->badblocks.unacked_exist) {
 		len += sprintf(page+len, "%sblocked", sep);
 		sep = ",";
 	}
@@ -2441,12 +2451,12 @@ static ssize_t
 state_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 {
 	/* can write
-	 *  faulty  - simulates and error
+	 *  faulty  - simulates an error
 	 *  remove  - disconnects the device
 	 *  writemostly - sets write_mostly
 	 *  -writemostly - clears write_mostly
-	 *  blocked - sets the Blocked flag
-	 *  -blocked - clears the Blocked flag
+	 *  blocked - sets the Blocked flags
+	 *  -blocked - clears the Blocked and possibly simulates an error
 	 *  insync - sets Insync providing device isn't active
 	 *  write_error - sets WriteErrorSeen
 	 *  -write_error - clears WriteErrorSeen
@@ -2476,7 +2486,15 @@ state_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 		set_bit(Blocked, &rdev->flags);
 		err = 0;
 	} else if (cmd_match(buf, "-blocked")) {
+		if (!test_bit(Faulty, &rdev->flags) &&
+		    test_bit(BlockedBadBlocks, &rdev->flags)) {
+			/* metadata handler doesn't understand badblocks,
+			 * so we need to fail the device
+			 */
+			md_error(rdev->mddev, rdev);
+		}
 		clear_bit(Blocked, &rdev->flags);
+		clear_bit(BlockedBadBlocks, &rdev->flags);
 		wake_up(&rdev->blocked_wait);
 		set_bit(MD_RECOVERY_NEEDED, &rdev->mddev->recovery);
 		md_wakeup_thread(rdev->mddev->thread);
@@ -2792,7 +2810,11 @@ static ssize_t bb_show(mdk_rdev_t *rdev, char *page)
 }
 static ssize_t bb_store(mdk_rdev_t *rdev, const char *page, size_t len)
 {
-	return badblocks_store(&rdev->badblocks, page, len, 0);
+	int rv = badblocks_store(&rdev->badblocks, page, len, 0);
+	/* Maybe that ack was all we needed */
+	if (test_and_clear_bit(BlockedBadBlocks, &rdev->flags))
+		wake_up(&rdev->blocked_wait);
+	return rv;
 }
 static struct rdev_sysfs_entry rdev_bad_blocks =
 __ATTR(bad_blocks, S_IRUGO|S_IWUSR, bb_show, bb_store);
@@ -6234,18 +6256,7 @@ void md_error(mddev_t *mddev, mdk_rdev_t *rdev)
 	if (!rdev || test_bit(Faulty, &rdev->flags))
 		return;
 
-	if (mddev->external)
-		set_bit(Blocked, &rdev->flags);
-/*
-	dprintk("md_error dev:%s, rdev:(%d:%d), (caller: %p,%p,%p,%p).\n",
-		mdname(mddev),
-		MAJOR(rdev->bdev->bd_dev), MINOR(rdev->bdev->bd_dev),
-		__builtin_return_address(0),__builtin_return_address(1),
-		__builtin_return_address(2),__builtin_return_address(3));
-*/
-	if (!mddev->pers)
-		return;
-	if (!mddev->pers->error_handler)
+	if (!mddev->pers || !mddev->pers->error_handler)
 		return;
 	mddev->pers->error_handler(mddev,rdev);
 	if (mddev->degraded)
@@ -7140,7 +7151,7 @@ static int remove_and_add_spares(mddev_t *mddev)
 		list_for_each_entry(rdev, &mddev->disks, same_set) {
 			if (rdev->raid_disk >= 0 &&
 			    !test_bit(In_sync, &rdev->flags) &&
-			    !test_bit(Blocked, &rdev->flags))
+			    !test_bit(Faulty, &rdev->flags))
 				spares++;
 			if (rdev->raid_disk < 0
 			    && !test_bit(Faulty, &rdev->flags)) {
@@ -7364,7 +7375,8 @@ void md_wait_for_blocked_rdev(mdk_rdev_t *rdev, mddev_t *mddev)
 {
 	sysfs_notify_dirent_safe(rdev->sysfs_state);
 	wait_event_timeout(rdev->blocked_wait,
-			   !test_bit(Blocked, &rdev->flags),
+			   !test_bit(Blocked, &rdev->flags) &&
+			   !test_bit(BlockedBadBlocks, &rdev->flags),
 			   msecs_to_jiffies(5000));
 	rdev_dec_pending(rdev, mddev);
 }
@@ -7623,6 +7635,8 @@ add_more:
 	}
 
 	bb->changed = 1;
+	if (!acknowledged)
+		bb->unacked_exist = 1;
 	rcu_assign_pointer(bb->active_page, bb->page);
 	spin_unlock(&bb->lock);
 
@@ -7768,6 +7782,7 @@ again:
 				p[i] = BB_MAKE(start, len, 1);
 			}
 		}
+		bb->unacked_exist = 0;
 	}
 	rcu_assign_pointer(bb->active_page, bb->page);
 	spin_unlock(&bb->lock);
@@ -7817,6 +7832,8 @@ badblocks_show(struct badblocks *bb, char *page, int unack)
 		len += snprintf(page+len, PAGE_SIZE-len, "%llu %u\n",
 				(unsigned long long)s, length);
 	}
+	if (unack && len == 0)
+		bb->unacked_exist = 0;
 
 	if (havelock)
 		spin_unlock(&bb->lock);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index a085df5..3eace8e 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -97,12 +97,26 @@ struct mdk_rdev_s
 #define	AllReserved	6		/* If whole device is reserved for
 					 * one array */
 #define	AutoDetected	7		/* added by auto-detect */
-#define Blocked		8		/* An error occured on an externally
-					 * managed array, don't allow writes
+#define Blocked		8		/* An error occurred but has not yet
+					 * been acknowledged by the metadata
+					 * handler, so don't allow writes
 					 * until it is cleared */
 #define WriteErrorSeen	9		/* A write error has been seen on this
 					 * device
 					 */
+#define FaultRecorded	10		/* Intermediate state for clearing Blocked.
+					 * The Fault is/will-be recorded in the
+					 * metadata, but that metadata hasn't
+					 * been stored safely on disk yet.
+					 */
+#define BlockedBadBlocks 11		/* A writer is blocked because they found
+					 * an unacknowledged bad-block.  This can
+					 * safely be cleared at any time, and the
+					 * writer will re-check.  It may be set
+					 * at any time, and at worst the writer
+					 * will timeout and re-check.  So setting
+					 * it as accurately as possible is good,
+					 * bit not absolutely critical. */
 	wait_queue_head_t blocked_wait;
 
 	int desc_nr;			/* descriptor index in the superblock */
@@ -137,6 +151,10 @@ struct mdk_rdev_s
 
 	struct badblocks {
 		int	count;		/* count of bad blocks */
+		int	unacked_exist;	/* there probably are unacknowledged
+					 * bad blocks.  This is only cleared
+					 * when a read discovers none
+					 */
 		int	shift;		/* shift from sectors to block size */
 		u64	*page;		/* badblock list */
 		u64	*active_page;	/* either 'page' or 'NULL' */
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 8429c63..bb81681 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1160,6 +1160,7 @@ static void error(mddev_t *mddev, mdk_rdev_t *rdev)
 		mddev->recovery_disabled = 1;
 		return;
 	}
+	set_bit(Blocked, &rdev->flags);
 	if (test_and_clear_bit(In_sync, &rdev->flags)) {
 		unsigned long flags;
 		spin_lock_irqsave(&conf->device_lock, flags);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 01a75d2..1e586d9 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1013,6 +1013,7 @@ static void error(mddev_t *mddev, mdk_rdev_t *rdev)
 		 */
 		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	}
+	set_bit(Blocked, &rdev->flags);
 	set_bit(Faulty, &rdev->flags);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 	printk(KERN_ALERT "md/raid10:%s: Disk failure on %s, disabling device.\n"
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 6fb36d8..8abc28c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1636,6 +1636,7 @@ static void error(mddev_t *mddev, mdk_rdev_t *rdev)
 		 */
 		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	}
+	set_bit(Blocked, &rdev->flags);
 	set_bit(Faulty, &rdev->flags);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 	printk(KERN_ALERT


