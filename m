From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 1/2] md: document lifetime of internal rdev pointer.
Date: Sat, 03 Feb 2018 09:19:30 +1100
Message-ID: <151760997024.5944.16609247615787679116.stgit@noble>
References: <151760990726.5944.15903931975424856346.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <151760990726.5944.15903931975424856346.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, yuyufen <yuyufen@huawei.com>, colyli@suse.de
List-Id: linux-raid.ids

The rdev pointer kept in the local 'config' for each for
raid1, raid10, raid4/5/6 has non-obvious lifetime rules.
Sometimes RCU is needed, sometimes a lock, something nothing.

Add documentation to explain this.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid1.h  |   12 ++++++++++++
 drivers/md/raid10.h |   13 +++++++++++++
 drivers/md/raid5.h  |   12 ++++++++++++
 3 files changed, 37 insertions(+)

diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index c7294e7557e0..eb84bc68e2fd 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -26,6 +26,18 @@
 #define BARRIER_BUCKETS_NR_BITS		(PAGE_SHIFT - ilog2(sizeof(atomic_t)))
 #define BARRIER_BUCKETS_NR		(1<<BARRIER_BUCKETS_NR_BITS)
 
+/* Note: raid1_info.rdev can be set to NULL asynchronously by raid1_remove_disk.
+ * There are three safe ways to access raid1_info.rdev.
+ * 1/ when holding mddev->reconfig_mutex
+ * 2/ when resync/recovery is known to be happening - i.e. in code that is
+ *    called as part of performing resync/recovery.
+ * 3/ while holding rcu_read_lock(), use rcu_dereference to get the pointer
+ *    and if it is non-NULL, increment rdev->nr_pending before dropping the
+ *    RCU lock.
+ * When .rdev is set to NULL, the nr_pending count checked again and if it has
+ * been incremented, the pointer is put back in .rdev.
+ */
+
 struct raid1_info {
 	struct md_rdev	*rdev;
 	sector_t	head_position;
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index db2ac22ac1b4..e2e8840de9bf 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -2,6 +2,19 @@
 #ifndef _RAID10_H
 #define _RAID10_H
 
+/* Note: raid10_info.rdev can be set to NULL asynchronously by
+ * raid10_remove_disk.
+ * There are three safe ways to access raid10_info.rdev.
+ * 1/ when holding mddev->reconfig_mutex
+ * 2/ when resync/recovery/reshape is known to be happening - i.e. in code
+ *    that is called as part of performing resync/recovery/reshape.
+ * 3/ while holding rcu_read_lock(), use rcu_dereference to get the pointer
+ *    and if it is non-NULL, increment rdev->nr_pending before dropping the
+ *    RCU lock.
+ * When .rdev is set to NULL, the nr_pending count checked again and if it has
+ * been incremented, the pointer is put back in .rdev.
+ */
+
 struct raid10_info {
 	struct md_rdev	*rdev, *replacement;
 	sector_t	head_position;
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 2e6123825095..3f8da26032ac 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -450,6 +450,18 @@ enum {
  * HANDLE gets cleared if stripe_handle leaves nothing locked.
  */
 
+/* Note: disk_info.rdev can be set to NULL asynchronously by raid5_remove_disk.
+ * There are three safe ways to access disk_info.rdev.
+ * 1/ when holding mddev->reconfig_mutex
+ * 2/ when resync/recovery/reshape is known to be happening - i.e. in code that
+ *    is called as part of performing resync/recovery/reshape.
+ * 3/ while holding rcu_read_lock(), use rcu_dereference to get the pointer
+ *    and if it is non-NULL, increment rdev->nr_pending before dropping the RCU
+ *    lock.
+ * When .rdev is set to NULL, the nr_pending count checked again and if
+ * it has been incremented, the pointer is put back in .rdev.
+ */
+
 struct disk_info {
 	struct md_rdev	*rdev, *replacement;
 	struct page	*extra_page; /* extra page to use in prexor */


