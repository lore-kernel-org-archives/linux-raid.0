From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 009 of 14] Tidy up raid5/6 hash table code.
Date: Thu, 1 Dec 2005 14:23:33 +1100
Message-ID: <1051201032333.29653@suse.de>
References: <20051201141508.29384.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


- replace open-coded hash chain with hlist macros
- Fix hash-table size at one page - it is already quite
  generous, so there will never be a need to use multiple
  pages, so no need for __get_free_pages

No functional change.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c         |   40 +++++++++++++------------------------
 ./drivers/md/raid6main.c     |   46 +++++++++++++++----------------------------
 ./include/linux/raid/raid5.h |    4 +--
 3 files changed, 33 insertions(+), 57 deletions(-)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-12-01 14:01:46.000000000 +1100
+++ ./drivers/md/raid5.c	2005-12-01 14:01:59.000000000 +1100
@@ -35,12 +35,10 @@
 #define STRIPE_SHIFT		(PAGE_SHIFT - 9)
 #define STRIPE_SECTORS		(STRIPE_SIZE>>9)
 #define	IO_THRESHOLD		1
-#define HASH_PAGES		1
-#define HASH_PAGES_ORDER	0
-#define NR_HASH			(HASH_PAGES * PAGE_SIZE / sizeof(struct stripe_head *))
+#define NR_HASH			(PAGE_SIZE / sizeof(struct hlist_head))
 #define HASH_MASK		(NR_HASH - 1)
 
-#define stripe_hash(conf, sect)	((conf)->stripe_hashtbl[((sect) >> STRIPE_SHIFT) & HASH_MASK])
+#define stripe_hash(conf, sect)	(&((conf)->stripe_hashtbl[((sect) >> STRIPE_SHIFT) & HASH_MASK]))
 
 /* bio's attached to a stripe+device for I/O are linked together in bi_sector
  * order without overlap.  There may be several bio's per stripe+device, and
@@ -113,29 +111,21 @@ static void release_stripe(struct stripe
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 }
 
-static void remove_hash(struct stripe_head *sh)
+static inline void remove_hash(struct stripe_head *sh)
 {
 	PRINTK("remove_hash(), stripe %llu\n", (unsigned long long)sh->sector);
 
-	if (sh->hash_pprev) {
-		if (sh->hash_next)
-			sh->hash_next->hash_pprev = sh->hash_pprev;
-		*sh->hash_pprev = sh->hash_next;
-		sh->hash_pprev = NULL;
-	}
+	hlist_del_init(&sh->hash);
 }
 
-static __inline__ void insert_hash(raid5_conf_t *conf, struct stripe_head *sh)
+static inline void insert_hash(raid5_conf_t *conf, struct stripe_head *sh)
 {
-	struct stripe_head **shp = &stripe_hash(conf, sh->sector);
+	struct hlist_head *hp = stripe_hash(conf, sh->sector);
 
 	PRINTK("insert_hash(), stripe %llu\n", (unsigned long long)sh->sector);
 
 	CHECK_DEVLOCK();
-	if ((sh->hash_next = *shp) != NULL)
-		(*shp)->hash_pprev = &sh->hash_next;
-	*shp = sh;
-	sh->hash_pprev = shp;
+	hlist_add_head(&sh->hash, hp);
 }
 
 
@@ -228,10 +218,11 @@ static inline void init_stripe(struct st
 static struct stripe_head *__find_stripe(raid5_conf_t *conf, sector_t sector)
 {
 	struct stripe_head *sh;
+	struct hlist_node *hn;
 
 	CHECK_DEVLOCK();
 	PRINTK("__find_stripe, sector %llu\n", (unsigned long long)sector);
-	for (sh = stripe_hash(conf, sector); sh; sh = sh->hash_next)
+	hlist_for_each_entry(sh, hn, stripe_hash(conf, sector), hash)
 		if (sh->sector == sector)
 			return sh;
 	PRINTK("__stripe %llu not in cache\n", (unsigned long long)sector);
@@ -1834,9 +1825,8 @@ static int run(mddev_t *mddev)
 
 	conf->mddev = mddev;
 
-	if ((conf->stripe_hashtbl = (struct stripe_head **) __get_free_pages(GFP_ATOMIC, HASH_PAGES_ORDER)) == NULL)
+	if ((conf->stripe_hashtbl = kzalloc(PAGE_SIZE, GFP_KERNEL)) == NULL)
 		goto abort;
-	memset(conf->stripe_hashtbl, 0, HASH_PAGES * PAGE_SIZE);
 
 	spin_lock_init(&conf->device_lock);
 	init_waitqueue_head(&conf->wait_for_stripe);
@@ -1971,9 +1961,7 @@ memory = conf->max_nr_stripes * (sizeof(
 abort:
 	if (conf) {
 		print_raid5_conf(conf);
-		if (conf->stripe_hashtbl)
-			free_pages((unsigned long) conf->stripe_hashtbl,
-							HASH_PAGES_ORDER);
+		kfree(conf->stripe_hashtbl);
 		kfree(conf);
 	}
 	mddev->private = NULL;
@@ -1990,7 +1978,7 @@ static int stop(mddev_t *mddev)
 	md_unregister_thread(mddev->thread);
 	mddev->thread = NULL;
 	shrink_stripes(conf);
-	free_pages((unsigned long) conf->stripe_hashtbl, HASH_PAGES_ORDER);
+	kfree(conf->stripe_hashtbl);
 	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
 	sysfs_remove_group(&mddev->kobj, &raid5_attrs_group);
 	kfree(conf);
@@ -2018,12 +2006,12 @@ static void print_sh (struct stripe_head
 static void printall (raid5_conf_t *conf)
 {
 	struct stripe_head *sh;
+	struct hlist_node *hn;
 	int i;
 
 	spin_lock_irq(&conf->device_lock);
 	for (i = 0; i < NR_HASH; i++) {
-		sh = conf->stripe_hashtbl[i];
-		for (; sh; sh = sh->hash_next) {
+		hlist_for_each_entry(sh, hn, &conf->stripe_hashtbl[i], hash) {
 			if (sh->raid_conf != conf)
 				continue;
 			print_sh(sh);

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2005-12-01 13:59:45.000000000 +1100
+++ ./drivers/md/raid6main.c	2005-12-01 14:01:58.000000000 +1100
@@ -40,12 +40,10 @@
 #define STRIPE_SHIFT		(PAGE_SHIFT - 9)
 #define STRIPE_SECTORS		(STRIPE_SIZE>>9)
 #define	IO_THRESHOLD		1
-#define HASH_PAGES		1
-#define HASH_PAGES_ORDER	0
-#define NR_HASH			(HASH_PAGES * PAGE_SIZE / sizeof(struct stripe_head *))
+#define NR_HASH			(PAGE_SIZE / sizeof(struct hlist_head))
 #define HASH_MASK		(NR_HASH - 1)
 
-#define stripe_hash(conf, sect)	((conf)->stripe_hashtbl[((sect) >> STRIPE_SHIFT) & HASH_MASK])
+#define stripe_hash(conf, sect)	(&((conf)->stripe_hashtbl[((sect) >> STRIPE_SHIFT) & HASH_MASK]))
 
 /* bio's attached to a stripe+device for I/O are linked together in bi_sector
  * order without overlap.  There may be several bio's per stripe+device, and
@@ -132,29 +130,21 @@ static void release_stripe(struct stripe
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 }
 
-static void remove_hash(struct stripe_head *sh)
+static inline void remove_hash(struct stripe_head *sh)
 {
 	PRINTK("remove_hash(), stripe %llu\n", (unsigned long long)sh->sector);
 
-	if (sh->hash_pprev) {
-		if (sh->hash_next)
-			sh->hash_next->hash_pprev = sh->hash_pprev;
-		*sh->hash_pprev = sh->hash_next;
-		sh->hash_pprev = NULL;
-	}
+	hlist_del_init(&sh->hash);
 }
 
-static __inline__ void insert_hash(raid6_conf_t *conf, struct stripe_head *sh)
+static inline void insert_hash(raid6_conf_t *conf, struct stripe_head *sh)
 {
-	struct stripe_head **shp = &stripe_hash(conf, sh->sector);
+	struct hlist_head *hp = stripe_hash(conf, sh->sector);
 
 	PRINTK("insert_hash(), stripe %llu\n", (unsigned long long)sh->sector);
 
 	CHECK_DEVLOCK();
-	if ((sh->hash_next = *shp) != NULL)
-		(*shp)->hash_pprev = &sh->hash_next;
-	*shp = sh;
-	sh->hash_pprev = shp;
+	hlist_add_head(&sh->hash, hp);
 }
 
 
@@ -247,10 +237,11 @@ static inline void init_stripe(struct st
 static struct stripe_head *__find_stripe(raid6_conf_t *conf, sector_t sector)
 {
 	struct stripe_head *sh;
+	struct hlist_node *hn;
 
 	CHECK_DEVLOCK();
 	PRINTK("__find_stripe, sector %llu\n", (unsigned long long)sector);
-	for (sh = stripe_hash(conf, sector); sh; sh = sh->hash_next)
+	hlist_for_each_entry (sh, hn,  stripe_hash(conf, sector), hash)
 		if (sh->sector == sector)
 			return sh;
 	PRINTK("__stripe %llu not in cache\n", (unsigned long long)sector);
@@ -1931,17 +1922,15 @@ static int run(mddev_t *mddev)
 		return -EIO;
 	}
 
-	mddev->private = kmalloc (sizeof (raid6_conf_t)
-				  + mddev->raid_disks * sizeof(struct disk_info),
-				  GFP_KERNEL);
+	mddev->private = kzalloc(sizeof (raid6_conf_t)
+				 + mddev->raid_disks * sizeof(struct disk_info),
+				 GFP_KERNEL);
 	if ((conf = mddev->private) == NULL)
 		goto abort;
-	memset (conf, 0, sizeof (*conf) + mddev->raid_disks * sizeof(struct disk_info) );
 	conf->mddev = mddev;
 
-	if ((conf->stripe_hashtbl = (struct stripe_head **) __get_free_pages(GFP_ATOMIC, HASH_PAGES_ORDER)) == NULL)
+	if ((conf->stripe_hashtbl = kzalloc(PAGE_SIZE, GFP_KERNEL)) == NULL)
 		goto abort;
-	memset(conf->stripe_hashtbl, 0, HASH_PAGES * PAGE_SIZE);
 
 	conf->spare_page = alloc_page(GFP_KERNEL);
 	if (!conf->spare_page)
@@ -2085,9 +2074,7 @@ abort:
 		print_raid6_conf(conf);
 		if (conf->spare_page)
 			put_page(conf->spare_page);
-		if (conf->stripe_hashtbl)
-			free_pages((unsigned long) conf->stripe_hashtbl,
-							HASH_PAGES_ORDER);
+		kfree(conf->stripe_hashtbl);
 		kfree(conf);
 	}
 	mddev->private = NULL;
@@ -2104,7 +2091,7 @@ static int stop (mddev_t *mddev)
 	md_unregister_thread(mddev->thread);
 	mddev->thread = NULL;
 	shrink_stripes(conf);
-	free_pages((unsigned long) conf->stripe_hashtbl, HASH_PAGES_ORDER);
+	kfree(conf->stripe_hashtbl);
 	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
 	kfree(conf);
 	mddev->private = NULL;
@@ -2131,12 +2118,13 @@ static void print_sh (struct seq_file *s
 static void printall (struct seq_file *seq, raid6_conf_t *conf)
 {
 	struct stripe_head *sh;
+	struct hlist_node *hn;
 	int i;
 
 	spin_lock_irq(&conf->device_lock);
 	for (i = 0; i < NR_HASH; i++) {
 		sh = conf->stripe_hashtbl[i];
-		for (; sh; sh = sh->hash_next) {
+		hlist_for_each_entry(sh, hn, &conf->stripe_hashtbl[i], hash) {
 			if (sh->raid_conf != conf)
 				continue;
 			print_sh(seq, sh);

diff ./include/linux/raid/raid5.h~current~ ./include/linux/raid/raid5.h
--- ./include/linux/raid/raid5.h~current~	2005-12-01 13:59:45.000000000 +1100
+++ ./include/linux/raid/raid5.h	2005-12-01 14:01:58.000000000 +1100
@@ -126,7 +126,7 @@
  */
 
 struct stripe_head {
-	struct stripe_head	*hash_next, **hash_pprev; /* hash pointers */
+	struct hlist_node	hash;
 	struct list_head	lru;			/* inactive_list or handle_list */
 	struct raid5_private_data	*raid_conf;
 	sector_t		sector;			/* sector of this row */
@@ -204,7 +204,7 @@ struct disk_info {
 };
 
 struct raid5_private_data {
-	struct stripe_head	**stripe_hashtbl;
+	struct hlist_head	*stripe_hashtbl;
 	mddev_t			*mddev;
 	struct disk_info	*spare;
 	int			chunk_size, level, algorithm;
