From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH] md: don't return -EAGAIN in md_allow_write for external metadata arrays
Date: Mon,  8 May 2017 11:56:55 +0200
Message-ID: <20170508095655.27350-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

This essentially reverts commit b5470dc5fc18 ("md: resolve external
metadata handling deadlock in md_allow_write") with some adjustments.

Since commit 6791875e2e53 ("md: make reconfig_mutex optional for writes
to md sysfs files.") changing array_state to 'active' does not use
mddev_lock() and will not cause a deadlock with md_allow_write(). This
revert simplifies userspace tools that write to sysfs attributes like
"stripe_cache_size" or "consistency_policy" because it removes the need
for special handling for external metadata arrays, checking for EAGAIN
and retrying the write.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/md/md.c    | 20 ++++++++------------
 drivers/md/md.h    |  2 +-
 drivers/md/raid1.c |  9 +++------
 drivers/md/raid5.c | 12 +++---------
 4 files changed, 15 insertions(+), 28 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 82f798be964f..10367ffe92e3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8022,18 +8022,15 @@ EXPORT_SYMBOL(md_write_end);
  * may proceed without blocking.  It is important to call this before
  * attempting a GFP_KERNEL allocation while holding the mddev lock.
  * Must be called with mddev_lock held.
- *
- * In the ->external case MD_SB_CHANGE_PENDING can not be cleared until mddev->lock
- * is dropped, so return -EAGAIN after notifying userspace.
  */
-int md_allow_write(struct mddev *mddev)
+void md_allow_write(struct mddev *mddev)
 {
 	if (!mddev->pers)
-		return 0;
+		return;
 	if (mddev->ro)
-		return 0;
+		return;
 	if (!mddev->pers->sync_request)
-		return 0;
+		return;
 
 	spin_lock(&mddev->lock);
 	if (mddev->in_sync) {
@@ -8046,13 +8043,12 @@ int md_allow_write(struct mddev *mddev)
 		spin_unlock(&mddev->lock);
 		md_update_sb(mddev, 0);
 		sysfs_notify_dirent_safe(mddev->sysfs_state);
+		/* wait for the dirty state to be recorded in the metadata */
+		wait_event(mddev->sb_wait,
+			   !test_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags) &&
+			   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
 	} else
 		spin_unlock(&mddev->lock);
-
-	if (test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags))
-		return -EAGAIN;
-	else
-		return 0;
 }
 EXPORT_SYMBOL_GPL(md_allow_write);
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 4e75d121bfcc..11f15146ce51 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -665,7 +665,7 @@ extern int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 			bool metadata_op);
 extern void md_do_sync(struct md_thread *thread);
 extern void md_new_event(struct mddev *mddev);
-extern int md_allow_write(struct mddev *mddev);
+extern void md_allow_write(struct mddev *mddev);
 extern void md_wait_for_blocked_rdev(struct md_rdev *rdev, struct mddev *mddev);
 extern void md_set_array_sectors(struct mddev *mddev, sector_t array_sectors);
 extern int md_check_no_bitmap(struct mddev *mddev);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7ed59351fe97..7c1f73398800 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3197,7 +3197,7 @@ static int raid1_reshape(struct mddev *mddev)
 	struct r1conf *conf = mddev->private;
 	int cnt, raid_disks;
 	unsigned long flags;
-	int d, d2, err;
+	int d, d2;
 
 	/* Cannot change chunk_size, layout, or level */
 	if (mddev->chunk_sectors != mddev->new_chunk_sectors ||
@@ -3209,11 +3209,8 @@ static int raid1_reshape(struct mddev *mddev)
 		return -EINVAL;
 	}
 
-	if (!mddev_is_clustered(mddev)) {
-		err = md_allow_write(mddev);
-		if (err)
-			return err;
-	}
+	if (!mddev_is_clustered(mddev))
+		md_allow_write(mddev);
 
 	raid_disks = mddev->raid_disks + mddev->delta_disks;
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3809a2192132..f8055a7abb4b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2309,14 +2309,12 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 	struct stripe_head *osh, *nsh;
 	LIST_HEAD(newstripes);
 	struct disk_info *ndisks;
-	int err;
+	int err = 0;
 	struct kmem_cache *sc;
 	int i;
 	int hash, cnt;
 
-	err = md_allow_write(conf->mddev);
-	if (err)
-		return err;
+	md_allow_write(conf->mddev);
 
 	/* Step 1 */
 	sc = kmem_cache_create(conf->cache_name[1-conf->active_name],
@@ -6310,7 +6308,6 @@ int
 raid5_set_cache_size(struct mddev *mddev, int size)
 {
 	struct r5conf *conf = mddev->private;
-	int err;
 
 	if (size <= 16 || size > 32768)
 		return -EINVAL;
@@ -6322,10 +6319,7 @@ raid5_set_cache_size(struct mddev *mddev, int size)
 		;
 	mutex_unlock(&conf->cache_size_mutex);
 
-
-	err = md_allow_write(mddev);
-	if (err)
-		return err;
+	md_allow_write(mddev);
 
 	mutex_lock(&conf->cache_size_mutex);
 	while (size > conf->max_nr_stripes)
-- 
2.11.0

