From: Shaohua Li <shli@fb.com>
Subject: [PATCH] md: use lockdep_assert_held
Date: Wed, 18 Oct 2017 22:08:13 -0700
Message-ID: <bd2a7444017882f62ccd503a5f0585ab8570660f.1508389646.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

lockdep_assert_held is a better way to assert lock held, and it works
for UP.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c          |  4 ++--
 drivers/md/md.h          |  5 -----
 drivers/md/raid5-cache.c | 12 ++++++------
 3 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8b2eb0f..f92de43 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2313,7 +2313,7 @@ static void export_array(struct mddev *mddev)
 
 static bool set_in_sync(struct mddev *mddev)
 {
-	WARN_ON_ONCE(NR_CPUS != 1 && !spin_is_locked(&mddev->lock));
+	lockdep_assert_held(&mddev->lock);
 	if (!mddev->in_sync) {
 		mddev->sync_checkers++;
 		spin_unlock(&mddev->lock);
@@ -6735,7 +6735,7 @@ static int set_array_info(struct mddev *mddev, mdu_array_info_t *info)
 
 void md_set_array_sectors(struct mddev *mddev, sector_t array_sectors)
 {
-	WARN(!mddev_is_locked(mddev), "%s: unlocked mddev!\n", __func__);
+	lockdep_assert_held(&mddev->reconfig_mutex);
 
 	if (mddev->external_size)
 		return;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index d8287d3..7f3e77e 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -494,11 +494,6 @@ static inline void mddev_lock_nointr(struct mddev *mddev)
 	mutex_lock(&mddev->reconfig_mutex);
 }
 
-static inline int mddev_is_locked(struct mddev *mddev)
-{
-	return mutex_is_locked(&mddev->reconfig_mutex);
-}
-
 static inline int mddev_trylock(struct mddev *mddev)
 {
 	return mutex_trylock(&mddev->reconfig_mutex);
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 0b7406a..1a60fc5 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -539,7 +539,7 @@ static void r5l_log_run_stripes(struct r5l_log *log)
 {
 	struct r5l_io_unit *io, *next;
 
-	assert_spin_locked(&log->io_list_lock);
+	lockdep_assert_held(&log->io_list_lock);
 
 	list_for_each_entry_safe(io, next, &log->running_ios, log_sibling) {
 		/* don't change list order */
@@ -555,7 +555,7 @@ static void r5l_move_to_end_ios(struct r5l_log *log)
 {
 	struct r5l_io_unit *io, *next;
 
-	assert_spin_locked(&log->io_list_lock);
+	lockdep_assert_held(&log->io_list_lock);
 
 	list_for_each_entry_safe(io, next, &log->running_ios, log_sibling) {
 		/* don't change list order */
@@ -1194,7 +1194,7 @@ static void r5l_run_no_mem_stripe(struct r5l_log *log)
 {
 	struct stripe_head *sh;
 
-	assert_spin_locked(&log->io_list_lock);
+	lockdep_assert_held(&log->io_list_lock);
 
 	if (!list_empty(&log->no_mem_stripes)) {
 		sh = list_first_entry(&log->no_mem_stripes,
@@ -1210,7 +1210,7 @@ static bool r5l_complete_finished_ios(struct r5l_log *log)
 	struct r5l_io_unit *io, *next;
 	bool found = false;
 
-	assert_spin_locked(&log->io_list_lock);
+	lockdep_assert_held(&log->io_list_lock);
 
 	list_for_each_entry_safe(io, next, &log->finished_ios, log_sibling) {
 		/* don't change list order */
@@ -1382,7 +1382,7 @@ static void r5c_flush_stripe(struct r5conf *conf, struct stripe_head *sh)
 	 * raid5_release_stripe() while holding conf->device_lock
 	 */
 	BUG_ON(test_bit(STRIPE_ON_RELEASE_LIST, &sh->state));
-	assert_spin_locked(&conf->device_lock);
+	lockdep_assert_held(&conf->device_lock);
 
 	list_del_init(&sh->lru);
 	atomic_inc(&sh->count);
@@ -1409,7 +1409,7 @@ void r5c_flush_cache(struct r5conf *conf, int num)
 	int count;
 	struct stripe_head *sh, *next;
 
-	assert_spin_locked(&conf->device_lock);
+	lockdep_assert_held(&conf->device_lock);
 	if (!conf->log)
 		return;
 
-- 
2.9.5

