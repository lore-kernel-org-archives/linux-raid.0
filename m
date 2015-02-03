From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 24/26] md: move mddev_lock and related to md.h
Date: Wed, 04 Feb 2015 08:42:30 +1100
Message-ID: <20150203214230.3448.40446.stgit@notabene.brown>
References: <20150203213948.3448.80258.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150203213948.3448.80258.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The one which is not inline (mddev_unlock) gets EXPORTed.

This makes the locking available to personality modules so that it
doesn't have to be imposed upon them.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |   26 ++------------------------
 drivers/md/md.h |   24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 24 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c17de6d0fb42..6517f4ece44e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -590,32 +590,9 @@ static struct mddev *mddev_find(dev_t unit)
 	goto retry;
 }
 
-static inline int __must_check mddev_lock(struct mddev *mddev)
-{
-	return mutex_lock_interruptible(&mddev->reconfig_mutex);
-}
-
-/* Sometimes we need to take the lock in a situation where
- * failure due to interrupts is not acceptable.
- */
-static inline void mddev_lock_nointr(struct mddev *mddev)
-{
-	mutex_lock(&mddev->reconfig_mutex);
-}
-
-static inline int mddev_is_locked(struct mddev *mddev)
-{
-	return mutex_is_locked(&mddev->reconfig_mutex);
-}
-
-static inline int mddev_trylock(struct mddev *mddev)
-{
-	return mutex_trylock(&mddev->reconfig_mutex);
-}
-
 static struct attribute_group md_redundancy_group;
 
-static void mddev_unlock(struct mddev *mddev)
+void mddev_unlock(struct mddev *mddev)
 {
 	if (mddev->to_remove) {
 		/* These cannot be removed under reconfig_mutex as
@@ -657,6 +634,7 @@ static void mddev_unlock(struct mddev *mddev)
 	md_wakeup_thread(mddev->thread);
 	spin_unlock(&pers_lock);
 }
+EXPORT_SYMBOL_GPL(mddev_unlock);
 
 static struct md_rdev *find_rdev_nr_rcu(struct mddev *mddev, int nr)
 {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 6bf3faa951ec..14367d919351 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -450,6 +450,30 @@ struct mddev {
 	void (*sync_super)(struct mddev *mddev, struct md_rdev *rdev);
 };
 
+static inline int __must_check mddev_lock(struct mddev *mddev)
+{
+	return mutex_lock_interruptible(&mddev->reconfig_mutex);
+}
+
+/* Sometimes we need to take the lock in a situation where
+ * failure due to interrupts is not acceptable.
+ */
+static inline void mddev_lock_nointr(struct mddev *mddev)
+{
+	mutex_lock(&mddev->reconfig_mutex);
+}
+
+static inline int mddev_is_locked(struct mddev *mddev)
+{
+	return mutex_is_locked(&mddev->reconfig_mutex);
+}
+
+static inline int mddev_trylock(struct mddev *mddev)
+{
+	return mutex_trylock(&mddev->reconfig_mutex);
+}
+extern void mddev_unlock(struct mddev *mddev);
+
 static inline void rdev_dec_pending(struct md_rdev *rdev, struct mddev *mddev)
 {
 	int faulty = test_bit(Faulty, &rdev->flags);


