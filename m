From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - md 20 of 22 - Provide SMP safe locking for all_mddevs list.
Date: Wed, 19 Jun 2002 10:54:53 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15631.54877.451803.348028@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Provide SMP safe locking for all_mddevs list.

the all_mddevs_lock is added to protect all_mddevs and mddev_map.

ITERATE_MDDEV is moved to md.c (it isn't needed elsewhere) and enhanced
to take the lock appropriately and always have a refcount on the object
that is given to the body of the loop.

mddev_find is changed so that the structure is allocated outside a lock,
but test-and-set is done inside the lock.



 ----------- Diffstat output ------------
 ./drivers/md/md.c           |   73 +++++++++++++++++++++++++++++++++-----------
 ./include/linux/raid/md_k.h |   10 ------
 2 files changed, 55 insertions(+), 28 deletions(-)

--- ./drivers/md/md.c	2002/06/18 05:33:38	1.19
+++ ./drivers/md/md.c	2002/06/18 06:05:22	1.20
@@ -127,8 +127,33 @@
 
 /*
  * Enables to iterate over all existing md arrays
+ * all_mddevs_lock protects this list as well as mddev_map.
  */
 static LIST_HEAD(all_mddevs);
+static spinlock_t all_mddevs_lock = SPIN_LOCK_UNLOCKED;
+
+
+/*
+ * iterates through all used mddevs in the system.
+ * We take care to grab the all_mddevs_lock whenever navigating
+ * the list, and to always hold a refcount when unlocked.
+ * Any code which breaks out of this loop while own
+ * a reference to the current mddev and must mddev_put it.
+ */
+#define ITERATE_MDDEV(mddev,tmp)					\
+									\
+	for (spin_lock(&all_mddevs_lock), 				\
+		     (tmp = all_mddevs.next),				\
+		     (mddev = NULL);					\
+	     (void)(tmp != &all_mddevs &&				\
+			mddev_get(list_entry(tmp, mddev_t, all_mddevs))),\
+		     spin_unlock(&all_mddevs_lock),			\
+		     (mddev ? mddev_put(mddev):(void)NULL),		\
+		     (mddev = list_entry(tmp, mddev_t, all_mddevs)),	\
+		     (tmp != &all_mddevs);				\
+	     spin_lock(&all_mddevs_lock),				\
+		     (tmp = tmp->next)					\
+		)
 
 static mddev_t *mddev_map[MAX_MD_DEVS];
 
@@ -146,7 +171,7 @@
 
 static void mddev_put(mddev_t *mddev)
 {
-	if (!atomic_dec_and_test(&mddev->active))
+	if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
 		return;
 	if (!mddev->sb && list_empty(&mddev->disks)) {
 		list_del(&mddev->all_mddevs);
@@ -154,33 +179,44 @@
 		kfree(mddev);
 		MOD_DEC_USE_COUNT;
 	}
+	spin_unlock(&all_mddevs_lock);
 }
 
 static mddev_t * mddev_find(int unit)
 {
-	mddev_t *mddev;
+	mddev_t *mddev, *new = NULL;
 
-	if ((mddev = mddev_map[unit])) {
-		return mddev_get(mddev);
+ retry:
+	spin_lock(&all_mddevs_lock);
+	if (mddev_map[unit]) {
+		mddev =  mddev_get(mddev_map[unit]);
+		spin_unlock(&all_mddevs_lock);
+		if (new)
+			kfree(new);
+		return mddev;
+	}
+	if (new) {
+		mddev_map[unit] = new;
+		list_add(&new->all_mddevs, &all_mddevs);
+		spin_unlock(&all_mddevs_lock);
+		MOD_INC_USE_COUNT;
+		return new;
 	}
-	mddev = (mddev_t *) kmalloc(sizeof(*mddev), GFP_KERNEL);
-	if (!mddev)
-		return NULL;
-
-	memset(mddev, 0, sizeof(*mddev));
+	spin_unlock(&all_mddevs_lock);
 
-	mddev->__minor = unit;
-	init_MUTEX(&mddev->reconfig_sem);
-	INIT_LIST_HEAD(&mddev->disks);
-	INIT_LIST_HEAD(&mddev->all_mddevs);
-	atomic_set(&mddev->active, 1);
+	new = (mddev_t *) kmalloc(sizeof(*new), GFP_KERNEL);
+	if (!new)
+		return NULL;
 
-	mddev_map[unit] = mddev;
-	list_add(&mddev->all_mddevs, &all_mddevs);
+	memset(new, 0, sizeof(*new));
 
-	MOD_INC_USE_COUNT;
+	new->__minor = unit;
+	init_MUTEX(&new->reconfig_sem);
+	INIT_LIST_HEAD(&new->disks);
+	INIT_LIST_HEAD(&new->all_mddevs);
+	atomic_set(&new->active, 1);
 
-	return mddev;
+	goto retry;
 }
 
 static inline int mddev_lock(mddev_t * mddev)
@@ -3192,6 +3228,7 @@
 							     mddev2->curr_resync < 2)) {
 					flush_curr_signals();
 					err = -EINTR;
+					mddev_put(mddev2);
 					goto out;
 				}
 			}
--- ./include/linux/raid/md_k.h	2002/06/18 05:29:05	1.8
+++ ./include/linux/raid/md_k.h	2002/06/18 06:05:22	1.9
@@ -277,16 +277,6 @@
 #define ITERATE_RDEV_PENDING(rdev,tmp)					\
 	ITERATE_RDEV_GENERIC(pending_raid_disks,pending,rdev,tmp)
 
-/*
- * iterates through all used mddevs in the system.
- */
-#define ITERATE_MDDEV(mddev,tmp)					\
-									\
-	for (tmp = all_mddevs.next;					\
-		mddev = list_entry(tmp, mddev_t, all_mddevs),	\
-			tmp = tmp->next, tmp->prev != &all_mddevs	\
-		; )
-
 #define xchg_values(x,y) do { __typeof__(x) __tmp = x; \
 				x = y; y = __tmp; } while (0)
 
