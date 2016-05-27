From: Song Liu <songliubraving@fb.com>
Subject: [RFC 2/5] move stripe cache define and functions to raid5.h
Date: Thu, 26 May 2016 22:29:40 -0700
Message-ID: <1464326983-3798454-3-git-send-email-songliubraving@fb.com>
References: <1464326983-3798454-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1464326983-3798454-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, nfbrown@novell.com, dan.j.williams@intel.com, hch@infradead.org, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

These defines and functions will be used in r5cache, so move them
to raid5.h.

Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5.c | 55 ------------------------------------------------------
 drivers/md/raid5.h | 55 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 55 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8e25e67..dc24b664 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -70,61 +70,6 @@ module_param(devices_handle_discard_safely, bool, 0644);
 MODULE_PARM_DESC(devices_handle_discard_safely,
 		 "Set to Y if all devices in each array reliably return zeroes on reads from discarded regions");
 static struct workqueue_struct *raid5_wq;
-/*
- * Stripe cache
- */
-
-#define NR_STRIPES		256
-#define STRIPE_SIZE		PAGE_SIZE
-#define STRIPE_SHIFT		(PAGE_SHIFT - 9)
-#define STRIPE_SECTORS		(STRIPE_SIZE>>9)
-#define	IO_THRESHOLD		1
-#define BYPASS_THRESHOLD	1
-#define NR_HASH			(PAGE_SIZE / sizeof(struct hlist_head))
-#define HASH_MASK		(NR_HASH - 1)
-#define MAX_STRIPE_BATCH	8
-
-static inline struct hlist_head *stripe_hash(struct r5conf *conf, sector_t sect)
-{
-	int hash = (sect >> STRIPE_SHIFT) & HASH_MASK;
-	return &conf->stripe_hashtbl[hash];
-}
-
-static inline int stripe_hash_locks_hash(sector_t sect)
-{
-	return (sect >> STRIPE_SHIFT) & STRIPE_HASH_LOCKS_MASK;
-}
-
-static inline void lock_device_hash_lock(struct r5conf *conf, int hash)
-{
-	spin_lock_irq(conf->hash_locks + hash);
-	spin_lock(&conf->device_lock);
-}
-
-static inline void unlock_device_hash_lock(struct r5conf *conf, int hash)
-{
-	spin_unlock(&conf->device_lock);
-	spin_unlock_irq(conf->hash_locks + hash);
-}
-
-static inline void lock_all_device_hash_locks_irq(struct r5conf *conf)
-{
-	int i;
-	local_irq_disable();
-	spin_lock(conf->hash_locks);
-	for (i = 1; i < NR_STRIPE_HASH_LOCKS; i++)
-		spin_lock_nest_lock(conf->hash_locks + i, conf->hash_locks);
-	spin_lock(&conf->device_lock);
-}
-
-static inline void unlock_all_device_hash_locks_irq(struct r5conf *conf)
-{
-	int i;
-	spin_unlock(&conf->device_lock);
-	for (i = NR_STRIPE_HASH_LOCKS; i; i--)
-		spin_unlock(conf->hash_locks + i - 1);
-	local_irq_enable();
-}
 
 /* bio's attached to a stripe+device for I/O are linked together in bi_sector
  * order without overlap.  There may be several bio's per stripe+device, and
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 517d4b6..3b68d4f 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -616,6 +616,61 @@ static inline int algorithm_is_DDF(int layout)
 	return layout >= 8 && layout <= 10;
 }
 
+/*
+ * Stripe cache
+ */
+#define NR_STRIPES		256
+#define STRIPE_SIZE		PAGE_SIZE
+#define STRIPE_SHIFT		(PAGE_SHIFT - 9)
+#define STRIPE_SECTORS		(STRIPE_SIZE>>9)
+#define	IO_THRESHOLD		1
+#define BYPASS_THRESHOLD	1
+#define NR_HASH			(PAGE_SIZE / sizeof(struct hlist_head))
+#define HASH_MASK		(NR_HASH - 1)
+#define MAX_STRIPE_BATCH	8
+
+static inline struct hlist_head *stripe_hash(struct r5conf *conf, sector_t sect)
+{
+	int hash = (sect >> STRIPE_SHIFT) & HASH_MASK;
+	return &conf->stripe_hashtbl[hash];
+}
+
+static inline int stripe_hash_locks_hash(sector_t sect)
+{
+	return (sect >> STRIPE_SHIFT) & STRIPE_HASH_LOCKS_MASK;
+}
+
+static inline void lock_device_hash_lock(struct r5conf *conf, int hash)
+{
+	spin_lock_irq(conf->hash_locks + hash);
+	spin_lock(&conf->device_lock);
+}
+
+static inline void unlock_device_hash_lock(struct r5conf *conf, int hash)
+{
+	spin_unlock(&conf->device_lock);
+	spin_unlock_irq(conf->hash_locks + hash);
+}
+
+static inline void lock_all_device_hash_locks_irq(struct r5conf *conf)
+{
+	int i;
+	local_irq_disable();
+	spin_lock(conf->hash_locks);
+	for (i = 1; i < NR_STRIPE_HASH_LOCKS; i++)
+		spin_lock_nest_lock(conf->hash_locks + i, conf->hash_locks);
+	spin_lock(&conf->device_lock);
+}
+
+static inline void unlock_all_device_hash_locks_irq(struct r5conf *conf)
+{
+	int i;
+	spin_unlock(&conf->device_lock);
+	for (i = NR_STRIPE_HASH_LOCKS; i; i--)
+		spin_unlock(conf->hash_locks + i - 1);
+	local_irq_enable();
+}
+
 extern void md_raid5_kick_device(struct r5conf *conf);
 extern int raid5_set_cache_size(struct mddev *mddev, int size);
 extern sector_t raid5_compute_blocknr(struct stripe_head *sh, int i, int previous);
-- 
2.8.0.rc2

