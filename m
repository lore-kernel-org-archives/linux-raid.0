From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 2 of 7] Make retry_list non-global in raid1 and multipath
Date: Wed, 08 Sep 2004 12:48:09 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1C4sVF-0005dd-Ki@notabene.cse.unsw.edu.au>
References: <20040908124236.20651.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Both raid1 and multipath have a "retry_list" which is global,
so all raid1 arrays (for example) us the same list.
This is rather ugly, and it is simple enough to make it per-array,
so this patch does that.

It also changes to multipath code to use list.h lists instead of
roll-your-own.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/multipath.c         |   28 ++++++++++++----------------
 ./drivers/md/raid1.c             |   18 +++++++++---------
 ./include/linux/raid/multipath.h |    3 ++-
 ./include/linux/raid/raid1.h     |    1 +
 4 files changed, 24 insertions(+), 26 deletions(-)

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2004-09-08 11:03:13.000000000 +1000
+++ ./drivers/md/multipath.c	2004-09-08 11:03:22.000000000 +1000
@@ -36,8 +36,6 @@
 
 
 static mdk_personality_t multipath_personality;
-static spinlock_t retry_list_lock = SPIN_LOCK_UNLOCKED;
-struct multipath_bh *multipath_retry_list = NULL, **multipath_retry_tail;
 
 
 static void *mp_pool_alloc(int gfp_flags, void *data)
@@ -101,14 +99,11 @@ static void multipath_reschedule_retry (
 {
 	unsigned long flags;
 	mddev_t *mddev = mp_bh->mddev;
+	multipath_conf_t *conf = mddev_to_conf(mddev);
 
-	spin_lock_irqsave(&retry_list_lock, flags);
-	if (multipath_retry_list == NULL)
-		multipath_retry_tail = &multipath_retry_list;
-	*multipath_retry_tail = mp_bh;
-	multipath_retry_tail = &mp_bh->next_mp;
-	mp_bh->next_mp = NULL;
-	spin_unlock_irqrestore(&retry_list_lock, flags);
+	spin_lock_irqsave(&conf->device_lock, flags);
+	list_add(&mp_bh->retry_list, &conf->retry_list);
+	spin_unlock_irqrestore(&conf->device_lock, flags);
 	md_wakeup_thread(mddev->thread);
 }
 
@@ -399,18 +394,18 @@ static void multipathd (mddev_t *mddev)
 	struct bio *bio;
 	unsigned long flags;
 	multipath_conf_t *conf = mddev_to_conf(mddev);
+	struct list_head *head = &conf->retry_list;
 
 	md_check_recovery(mddev);
 	for (;;) {
 		char b[BDEVNAME_SIZE];
-		spin_lock_irqsave(&retry_list_lock, flags);
-		mp_bh = multipath_retry_list;
-		if (!mp_bh)
+		spin_lock_irqsave(&conf->device_lock, flags);
+		if (list_empty(head))
 			break;
-		multipath_retry_list = mp_bh->next_mp;
-		spin_unlock_irqrestore(&retry_list_lock, flags);
+		mp_bh = list_entry(head->prev, struct multipath_bh, retry_list);
+		list_del(head->prev);
+		spin_unlock_irqrestore(&conf->device_lock, flags);
 
-		mddev = mp_bh->mddev;
 		bio = &mp_bh->bio;
 		bio->bi_sector = mp_bh->master_bio->bi_sector;
 		
@@ -433,7 +428,7 @@ static void multipathd (mddev_t *mddev)
 			generic_make_request(bio);
 		}
 	}
-	spin_unlock_irqrestore(&retry_list_lock, flags);
+	spin_unlock_irqrestore(&conf->device_lock, flags);
 }
 
 static int multipath_run (mddev_t *mddev)
@@ -506,6 +501,7 @@ static int multipath_run (mddev_t *mddev
 	mddev->sb_dirty = 1;
 	conf->mddev = mddev;
 	conf->device_lock = SPIN_LOCK_UNLOCKED;
+	INIT_LIST_HEAD(&conf->retry_list);
 
 	if (!conf->working_disks) {
 		printk(KERN_ERR "multipath: no operational IO paths for %s\n",

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2004-09-08 11:03:13.000000000 +1000
+++ ./drivers/md/raid1.c	2004-09-08 11:03:22.000000000 +1000
@@ -30,8 +30,6 @@
 #define	NR_RAID1_BIOS 256
 
 static mdk_personality_t raid1_personality;
-static spinlock_t retry_list_lock = SPIN_LOCK_UNLOCKED;
-static LIST_HEAD(retry_list_head);
 
 static void unplug_slaves(mddev_t *mddev);
 
@@ -188,10 +186,11 @@ static void reschedule_retry(r1bio_t *r1
 {
 	unsigned long flags;
 	mddev_t *mddev = r1_bio->mddev;
+	conf_t *conf = mddev_to_conf(mddev);
 
-	spin_lock_irqsave(&retry_list_lock, flags);
-	list_add(&r1_bio->retry_list, &retry_list_head);
-	spin_unlock_irqrestore(&retry_list_lock, flags);
+	spin_lock_irqsave(&conf->device_lock, flags);
+	list_add(&r1_bio->retry_list, &conf->retry_list);
+	spin_unlock_irqrestore(&conf->device_lock, flags);
 
 	md_wakeup_thread(mddev->thread);
 }
@@ -904,11 +903,11 @@ static void sync_request_write(mddev_t *
 
 static void raid1d(mddev_t *mddev)
 {
-	struct list_head *head = &retry_list_head;
 	r1bio_t *r1_bio;
 	struct bio *bio;
 	unsigned long flags;
 	conf_t *conf = mddev_to_conf(mddev);
+	struct list_head *head = &conf->retry_list;
 	int unplug=0;
 	mdk_rdev_t *rdev;
 
@@ -917,12 +916,12 @@ static void raid1d(mddev_t *mddev)
 	
 	for (;;) {
 		char b[BDEVNAME_SIZE];
-		spin_lock_irqsave(&retry_list_lock, flags);
+		spin_lock_irqsave(&conf->device_lock, flags);
 		if (list_empty(head))
 			break;
 		r1_bio = list_entry(head->prev, r1bio_t, retry_list);
 		list_del(head->prev);
-		spin_unlock_irqrestore(&retry_list_lock, flags);
+		spin_unlock_irqrestore(&conf->device_lock, flags);
 
 		mddev = r1_bio->mddev;
 		conf = mddev_to_conf(mddev);
@@ -956,7 +955,7 @@ static void raid1d(mddev_t *mddev)
 			}
 		}
 	}
-	spin_unlock_irqrestore(&retry_list_lock, flags);
+	spin_unlock_irqrestore(&conf->device_lock, flags);
 	if (unplug)
 		unplug_slaves(mddev);
 }
@@ -1205,6 +1204,7 @@ static int run(mddev_t *mddev)
 	conf->raid_disks = mddev->raid_disks;
 	conf->mddev = mddev;
 	conf->device_lock = SPIN_LOCK_UNLOCKED;
+	INIT_LIST_HEAD(&conf->retry_list);
 	if (conf->working_disks == 1)
 		mddev->recovery_cp = MaxSector;
 

diff ./include/linux/raid/multipath.h~current~ ./include/linux/raid/multipath.h
--- ./include/linux/raid/multipath.h~current~	2004-09-08 11:03:13.000000000 +1000
+++ ./include/linux/raid/multipath.h	2004-09-08 11:03:22.000000000 +1000
@@ -14,6 +14,7 @@ struct multipath_private_data {
 	int			working_disks;
 	spinlock_t		device_lock;
 	unsigned long		last_fail_event;
+	struct list_head	retry_list;
 
 	mempool_t		*pool;
 };
@@ -37,6 +38,6 @@ struct multipath_bh {
 	struct bio		*master_bio;
 	struct bio		bio;
 	int			path;
-	struct multipath_bh	*next_mp; /* next for retry */
+	struct list_head	retry_list;
 };
 #endif

diff ./include/linux/raid/raid1.h~current~ ./include/linux/raid/raid1.h
--- ./include/linux/raid/raid1.h~current~	2004-09-08 11:03:13.000000000 +1000
+++ ./include/linux/raid/raid1.h	2004-09-08 11:03:22.000000000 +1000
@@ -35,6 +35,7 @@ struct r1_private_data_s {
 	sector_t		next_seq_sect;
 	spinlock_t		device_lock;
 
+	struct list_head	retry_list;
 	/* for use when syncing mirrors: */
 
 	spinlock_t		resync_lock;
