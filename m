From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 23/26] md: use mddev->lock to protect updates to
 resync_{min, max}.
Date: Wed, 04 Feb 2015 08:42:30 +1100
Message-ID: <20150203214230.3448.46213.stgit@notabene.brown>
References: <20150203213948.3448.80258.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150203213948.3448.80258.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

There are interdependencies between these two sysfs attributes
and whether a resync is currently running.

Rather than depending on reconfig_mutex to ensure no races when
testing these interdependencies are met, use the spinlock.
This will allow the mutex to be remove from protecting this
code in a subsequent patch.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |   58 +++++++++++++++++++++++++++++++++++++++++++------------
 drivers/md/md.h |    2 ++
 2 files changed, 47 insertions(+), 13 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e68824d2d21e..c17de6d0fb42 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4269,22 +4269,36 @@ static ssize_t
 min_sync_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	unsigned long long min;
+	int err;
+	int chunk;
+
 	if (kstrtoull(buf, 10, &min))
 		return -EINVAL;
+
+	spin_lock(&mddev->lock);
+	err = -EINVAL;
 	if (min > mddev->resync_max)
-		return -EINVAL;
+		goto out_unlock;
+
+	err = -EBUSY;
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
-		return -EBUSY;
+		goto out_unlock;
 
 	/* Must be a multiple of chunk_size */
-	if (mddev->chunk_sectors) {
+	chunk = mddev->chunk_sectors;
+	if (chunk) {
 		sector_t temp = min;
-		if (sector_div(temp, mddev->chunk_sectors))
-			return -EINVAL;
+
+		err = -EINVAL;
+		if (sector_div(temp, chunk))
+			goto out_unlock;
 	}
 	mddev->resync_min = min;
+	err = 0;
 
-	return len;
+out_unlock:
+	spin_unlock(&mddev->lock);
+	return err ?: len;
 }
 
 static struct md_sysfs_entry md_min_sync =
@@ -4302,29 +4316,42 @@ max_sync_show(struct mddev *mddev, char *page)
 static ssize_t
 max_sync_store(struct mddev *mddev, const char *buf, size_t len)
 {
+	int err;
+	spin_lock(&mddev->lock);
 	if (strncmp(buf, "max", 3) == 0)
 		mddev->resync_max = MaxSector;
 	else {
 		unsigned long long max;
+		int chunk;
+
+		err = -EINVAL;
 		if (kstrtoull(buf, 10, &max))
-			return -EINVAL;
+			goto out_unlock;
 		if (max < mddev->resync_min)
-			return -EINVAL;
+			goto out_unlock;
+
+		err = -EBUSY;
 		if (max < mddev->resync_max &&
 		    mddev->ro == 0 &&
 		    test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
-			return -EBUSY;
+			goto out_unlock;
 
 		/* Must be a multiple of chunk_size */
-		if (mddev->chunk_sectors) {
+		chunk = mddev->chunk_sectors;
+		if (chunk) {
 			sector_t temp = max;
-			if (sector_div(temp, mddev->chunk_sectors))
-				return -EINVAL;
+
+			err = -EINVAL;
+			if (sector_div(temp, chunk))
+				goto out_unlock;
 		}
 		mddev->resync_max = max;
 	}
 	wake_up(&mddev->recovery_wait);
-	return len;
+	err = 0;
+out_unlock:
+	spin_unlock(&mddev->lock);
+	return err ?: len;
 }
 
 static struct md_sysfs_entry md_max_sync =
@@ -7585,6 +7612,7 @@ void md_do_sync(struct md_thread *thread)
  skip:
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 
+	spin_lock(&mddev->lock);
 	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
 		/* We completed so min/max setting can be forgotten if used. */
 		if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
@@ -7593,6 +7621,8 @@ void md_do_sync(struct md_thread *thread)
 	} else if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
 		mddev->resync_min = mddev->curr_resync_completed;
 	mddev->curr_resync = 0;
+	spin_unlock(&mddev->lock);
+
 	wake_up(&resync_wait);
 	set_bit(MD_RECOVERY_DONE, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
@@ -7793,7 +7823,9 @@ void md_check_recovery(struct mddev *mddev)
 		 * any transients in the value of "sync_action".
 		 */
 		mddev->curr_resync_completed = 0;
+		spin_lock(&mddev->lock);
 		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
+		spin_unlock(&mddev->lock);
 		/* Clear some bits that don't mean anything, but
 		 * might be left set
 		 */
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b4fbd6a63fcf..6bf3faa951ec 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -394,6 +394,8 @@ struct mddev {
 	 *   pers (also protected by reconfig_mutex and pending IO).
 	 *   clearing ->bitmap
 	 *   clearing ->bitmap_info.file
+	 *   changing ->resync_{min,max}
+	 *   setting MD_RECOVERY_RUNNING (which interacts with resync_{min,max})
 	 */
 	spinlock_t			lock;
 	wait_queue_head_t		sb_wait;	/* for waiting on superblock updates */


