From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 013 of 14] Remove personality numbering from md.
Date: Thu, 1 Dec 2005 14:23:56 +1100
Message-ID: <1051201032356.29720@suse.de>
References: <20051201141508.29384.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


md supports multiple different RAID level, each being
implemented by a 'personality' (which is often in a separate
module).
These personalities have fairly artificial 'numbers'.  The numbers
are use to:
 1- provide an index into an array where the various personalities 
    are recorded
 2- identify the module (via an alias) which implements are particular
    personality.

Neither of these uses really justify the existence of personality numbers.
The array can be replaced by a linked list which is searched (array lookup
only happens very rarely).  Module identification can be done using an
alias based on level rather than 'personality' number.

The current 'raid5' modules support two level (4 and 5) but only one
personality.  This slight awkwardness (which was handled in the mapping
from level to personality) can be better handled by allowing raid5
to register 2 personalities.

With this change in place, the core md module does not need to have an
exhaustive list of all possible personalities, so other personalities
can be added independently.

This patch also moves the check for chunksize being non-zero
into the ->run routines for the personalities that need it, 
rather than having it in core-md.  This has a side effect of allowing
'faulty' and 'linear' not to have a chunk-size set.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/faulty.c       |    8 ++--
 ./drivers/md/linear.c       |   10 +++--
 ./drivers/md/md.c           |   79 ++++++++++++++++----------------------------
 ./drivers/md/multipath.c    |   11 ++----
 ./drivers/md/raid0.c        |   14 +++++--
 ./drivers/md/raid1.c        |    9 ++---
 ./drivers/md/raid10.c       |   16 +++++---
 ./drivers/md/raid5.c        |   34 ++++++++++++++++--
 ./drivers/md/raid6main.c    |   10 +++--
 ./include/linux/raid/md.h   |    4 +-
 ./include/linux/raid/md_k.h |   63 +++++------------------------------
 ./init/do_mounts_md.c       |   22 +++++-------
 12 files changed, 125 insertions(+), 155 deletions(-)

diff ./drivers/md/faulty.c~current~ ./drivers/md/faulty.c
--- ./drivers/md/faulty.c~current~	2005-12-01 13:59:45.000000000 +1100
+++ ./drivers/md/faulty.c	2005-12-01 14:03:25.000000000 +1100
@@ -316,9 +316,10 @@ static int stop(mddev_t *mddev)
 	return 0;
 }
 
-static mdk_personality_t faulty_personality =
+static struct mdk_personality faulty_personality =
 {
 	.name		= "faulty",
+	.level		= LEVEL_FAULTY,
 	.owner		= THIS_MODULE,
 	.make_request	= make_request,
 	.run		= run,
@@ -329,15 +330,16 @@ static mdk_personality_t faulty_personal
 
 static int __init raid_init(void)
 {
-	return register_md_personality(FAULTY, &faulty_personality);
+	return register_md_personality(&faulty_personality);
 }
 
 static void raid_exit(void)
 {
-	unregister_md_personality(FAULTY);
+	unregister_md_personality(&faulty_personality);
 }
 
 module_init(raid_init);
 module_exit(raid_exit);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("md-personality-10"); /* faulty */
+MODULE_ALIAS("md-level--5");

diff ./drivers/md/linear.c~current~ ./drivers/md/linear.c
--- ./drivers/md/linear.c~current~	2005-12-01 13:59:53.000000000 +1100
+++ ./drivers/md/linear.c	2005-12-01 14:03:25.000000000 +1100
@@ -351,9 +351,10 @@ static void linear_status (struct seq_fi
 }
 
 
-static mdk_personality_t linear_personality=
+static struct mdk_personality linear_personality =
 {
 	.name		= "linear",
+	.level		= LEVEL_LINEAR,
 	.owner		= THIS_MODULE,
 	.make_request	= linear_make_request,
 	.run		= linear_run,
@@ -363,16 +364,17 @@ static mdk_personality_t linear_personal
 
 static int __init linear_init (void)
 {
-	return register_md_personality (LINEAR, &linear_personality);
+	return register_md_personality (&linear_personality);
 }
 
 static void linear_exit (void)
 {
-	unregister_md_personality (LINEAR);
+	unregister_md_personality (&linear_personality);
 }
 
 
 module_init(linear_init);
 module_exit(linear_exit);
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("md-personality-1"); /* LINEAR */
+MODULE_ALIAS("md-personality-1"); /* LINEAR - degrecated*/
+MODULE_ALIAS("md-level--1");

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-12-01 14:03:07.000000000 +1100
+++ ./drivers/md/md.c	2005-12-01 14:03:25.000000000 +1100
@@ -68,7 +68,7 @@
 static void autostart_arrays (int part);
 #endif
 
-static mdk_personality_t *pers[MAX_PERSONALITY];
+static LIST_HEAD(pers_list);
 static DEFINE_SPINLOCK(pers_lock);
 
 /*
@@ -303,6 +303,15 @@ static mdk_rdev_t * find_rdev(mddev_t * 
 	return NULL;
 }
 
+static struct mdk_personality *find_pers(int level)
+{
+	struct mdk_personality *pers;
+	list_for_each_entry(pers, &pers_list, list)
+		if (pers->level == level)
+			return pers;
+	return NULL;
+}
+
 static inline sector_t calc_dev_sboffset(struct block_device *bdev)
 {
 	sector_t size = bdev->bd_inode->i_size >> BLOCK_SIZE_BITS;
@@ -1744,7 +1753,7 @@ static void analyze_sbs(mddev_t * mddev)
 static ssize_t
 level_show(mddev_t *mddev, char *page)
 {
-	mdk_personality_t *p = mddev->pers;
+	struct mdk_personality *p = mddev->pers;
 	if (p == NULL && mddev->raid_disks == 0)
 		return 0;
 	if (mddev->level >= 0)
@@ -1960,11 +1969,12 @@ static int start_dirty_degraded;
 
 static int do_md_run(mddev_t * mddev)
 {
-	int pnum, err;
+	int err;
 	int chunk_size;
 	struct list_head *tmp;
 	mdk_rdev_t *rdev;
 	struct gendisk *disk;
+	struct mdk_personality *pers;
 	char b[BDEVNAME_SIZE];
 
 	if (list_empty(&mddev->disks))
@@ -1981,20 +1991,8 @@ static int do_md_run(mddev_t * mddev)
 		analyze_sbs(mddev);
 
 	chunk_size = mddev->chunk_size;
-	pnum = level_to_pers(mddev->level);
 
-	if ((pnum != MULTIPATH) && (pnum != RAID1)) {
-		if (!chunk_size) {
-			/*
-			 * 'default chunksize' in the old md code used to
-			 * be PAGE_SIZE, baaad.
-			 * we abort here to be on the safe side. We don't
-			 * want to continue the bad practice.
-			 */
-			printk(KERN_ERR 
-				"no chunksize specified, see 'man raidtab'\n");
-			return -EINVAL;
-		}
+	if (chunk_size) {
 		if (chunk_size > MAX_CHUNK_SIZE) {
 			printk(KERN_ERR "too big chunk_size: %d > %d\n",
 				chunk_size, MAX_CHUNK_SIZE);
@@ -2030,10 +2028,7 @@ static int do_md_run(mddev_t * mddev)
 	}
 
 #ifdef CONFIG_KMOD
-	if (!pers[pnum])
-	{
-		request_module("md-personality-%d", pnum);
-	}
+	request_module("md-level-%d", mddev->level);
 #endif
 
 	/*
@@ -2055,14 +2050,14 @@ static int do_md_run(mddev_t * mddev)
 		return -ENOMEM;
 
 	spin_lock(&pers_lock);
-	if (!pers[pnum] || !try_module_get(pers[pnum]->owner)) {
+	pers = find_pers(mddev->level);
+	if (!pers || !try_module_get(pers->owner)) {
 		spin_unlock(&pers_lock);
-		printk(KERN_WARNING "md: personality %d is not loaded!\n",
-		       pnum);
+		printk(KERN_WARNING "md: personality for level %d is not loaded!\n",
+		       mddev->level);
 		return -EINVAL;
 	}
-
-	mddev->pers = pers[pnum];
+	mddev->pers = pers;
 	spin_unlock(&pers_lock);
 
 	mddev->recovery = 0;
@@ -3693,15 +3688,14 @@ static int md_seq_show(struct seq_file *
 	struct list_head *tmp2;
 	mdk_rdev_t *rdev;
 	struct mdstat_info *mi = seq->private;
-	int i;
 	struct bitmap *bitmap;
 
 	if (v == (void*)1) {
+		struct mdk_personality *pers;
 		seq_printf(seq, "Personalities : ");
 		spin_lock(&pers_lock);
-		for (i = 0; i < MAX_PERSONALITY; i++)
-			if (pers[i])
-				seq_printf(seq, "[%s] ", pers[i]->name);
+		list_for_each_entry(pers, &pers_list, list)
+			seq_printf(seq, "[%s] ", pers->name);
 
 		spin_unlock(&pers_lock);
 		seq_printf(seq, "\n");
@@ -3862,35 +3856,20 @@ static struct file_operations md_seq_fop
 	.poll		= mdstat_poll,
 };
 
-int register_md_personality(int pnum, mdk_personality_t *p)
+int register_md_personality(struct mdk_personality *p)
 {
-	if (pnum >= MAX_PERSONALITY) {
-		printk(KERN_ERR
-		       "md: tried to install personality %s as nr %d, but max is %lu\n",
-		       p->name, pnum, MAX_PERSONALITY-1);
-		return -EINVAL;
-	}
-
 	spin_lock(&pers_lock);
-	if (pers[pnum]) {
-		spin_unlock(&pers_lock);
-		return -EBUSY;
-	}
-
-	pers[pnum] = p;
-	printk(KERN_INFO "md: %s personality registered as nr %d\n", p->name, pnum);
+	list_add_tail(&p->list, &pers_list);
+	printk(KERN_INFO "md: %s personality registered for level %d\n", p->name, p->level);
 	spin_unlock(&pers_lock);
 	return 0;
 }
 
-int unregister_md_personality(int pnum)
+int unregister_md_personality(struct mdk_personality *p)
 {
-	if (pnum >= MAX_PERSONALITY)
-		return -EINVAL;
-
-	printk(KERN_INFO "md: %s personality unregistered\n", pers[pnum]->name);
+	printk(KERN_INFO "md: %s personality unregistered\n", p->name);
 	spin_lock(&pers_lock);
-	pers[pnum] = NULL;
+	list_del_init(&p->list);
 	spin_unlock(&pers_lock);
 	return 0;
 }

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2005-12-01 13:59:53.000000000 +1100
+++ ./drivers/md/multipath.c	2005-12-01 14:03:25.000000000 +1100
@@ -35,9 +35,6 @@
 #define	NR_RESERVED_BUFS	32
 
 
-static mdk_personality_t multipath_personality;
-
-
 static void *mp_pool_alloc(gfp_t gfp_flags, void *data)
 {
 	struct multipath_bh *mpb;
@@ -553,9 +550,10 @@ static int multipath_stop (mddev_t *mdde
 	return 0;
 }
 
-static mdk_personality_t multipath_personality=
+static struct mdk_personality multipath_personality =
 {
 	.name		= "multipath",
+	.level		= LEVEL_MULTIPATH,
 	.owner		= THIS_MODULE,
 	.make_request	= multipath_make_request,
 	.run		= multipath_run,
@@ -568,15 +566,16 @@ static mdk_personality_t multipath_perso
 
 static int __init multipath_init (void)
 {
-	return register_md_personality (MULTIPATH, &multipath_personality);
+	return register_md_personality (&multipath_personality);
 }
 
 static void __exit multipath_exit (void)
 {
-	unregister_md_personality (MULTIPATH);
+	unregister_md_personality (&multipath_personality);
 }
 
 module_init(multipath_init);
 module_exit(multipath_exit);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("md-personality-7"); /* MULTIPATH */
+MODULE_ALIAS("md-level--4");

diff ./drivers/md/raid0.c~current~ ./drivers/md/raid0.c
--- ./drivers/md/raid0.c~current~	2005-12-01 13:59:53.000000000 +1100
+++ ./drivers/md/raid0.c	2005-12-01 14:03:25.000000000 +1100
@@ -275,7 +275,11 @@ static int raid0_run (mddev_t *mddev)
 	mdk_rdev_t *rdev;
 	struct list_head *tmp;
 
-	printk("%s: setting max_sectors to %d, segment boundary to %d\n",
+	if (mddev->chunk_size == 0) {
+		printk(KERN_ERR "md/raid0: non-zero chunk size required.\n");
+		return -EINVAL;
+	}
+	printk(KERN_INFO "%s: setting max_sectors to %d, segment boundary to %d\n",
 	       mdname(mddev),
 	       mddev->chunk_size >> 9,
 	       (mddev->chunk_size>>1)-1);
@@ -507,9 +511,10 @@ static void raid0_status (struct seq_fil
 	return;
 }
 
-static mdk_personality_t raid0_personality=
+static struct mdk_personality raid0_personality=
 {
 	.name		= "raid0",
+	.level		= 0,
 	.owner		= THIS_MODULE,
 	.make_request	= raid0_make_request,
 	.run		= raid0_run,
@@ -519,15 +524,16 @@ static mdk_personality_t raid0_personali
 
 static int __init raid0_init (void)
 {
-	return register_md_personality (RAID0, &raid0_personality);
+	return register_md_personality (&raid0_personality);
 }
 
 static void raid0_exit (void)
 {
-	unregister_md_personality (RAID0);
+	unregister_md_personality (&raid0_personality);
 }
 
 module_init(raid0_init);
 module_exit(raid0_exit);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("md-personality-2"); /* RAID0 */
+MODULE_ALIAS("md-level-0");

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-12-01 13:59:53.000000000 +1100
+++ ./drivers/md/raid1.c	2005-12-01 14:03:25.000000000 +1100
@@ -47,7 +47,6 @@
  */
 #define	NR_RAID1_BIOS 256
 
-static mdk_personality_t raid1_personality;
 
 static void unplug_slaves(mddev_t *mddev);
 
@@ -2035,9 +2034,10 @@ static void raid1_quiesce(mddev_t *mddev
 }
 
 
-static mdk_personality_t raid1_personality =
+static struct mdk_personality raid1_personality =
 {
 	.name		= "raid1",
+	.level		= 1,
 	.owner		= THIS_MODULE,
 	.make_request	= make_request,
 	.run		= run,
@@ -2055,15 +2055,16 @@ static mdk_personality_t raid1_personali
 
 static int __init raid_init(void)
 {
-	return register_md_personality(RAID1, &raid1_personality);
+	return register_md_personality(&raid1_personality);
 }
 
 static void raid_exit(void)
 {
-	unregister_md_personality(RAID1);
+	unregister_md_personality(&raid1_personality);
 }
 
 module_init(raid_init);
 module_exit(raid_exit);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("md-personality-3"); /* RAID1 */
+MODULE_ALIAS("md-level-1");

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2005-12-01 14:03:16.000000000 +1100
+++ ./drivers/md/raid10.c	2005-12-01 14:03:25.000000000 +1100
@@ -1883,11 +1883,11 @@ static int run(mddev_t *mddev)
 	int nc, fc;
 	sector_t stride, size;
 
-	if (mddev->level != 10) {
-		printk(KERN_ERR "raid10: %s: raid level not set correctly... (%d)\n",
-		       mdname(mddev), mddev->level);
-		goto out;
+	if (mddev->chunk_size == 0) {
+		printk(KERN_ERR "md/raid10: non-zero chunk size required.\n");
+		return -EINVAL;
 	}
+
 	nc = mddev->layout & 255;
 	fc = (mddev->layout >> 8) & 255;
 	if ((nc*fc) <2 || (nc*fc) > mddev->raid_disks ||
@@ -2072,9 +2072,10 @@ static void raid10_quiesce(mddev_t *mdde
 	}
 }
 
-static mdk_personality_t raid10_personality =
+static struct mdk_personality raid10_personality =
 {
 	.name		= "raid10",
+	.level		= 10,
 	.owner		= THIS_MODULE,
 	.make_request	= make_request,
 	.run		= run,
@@ -2090,15 +2091,16 @@ static mdk_personality_t raid10_personal
 
 static int __init raid_init(void)
 {
-	return register_md_personality(RAID10, &raid10_personality);
+	return register_md_personality(&raid10_personality);
 }
 
 static void raid_exit(void)
 {
-	unregister_md_personality(RAID10);
+	unregister_md_personality(&raid10_personality);
 }
 
 module_init(raid_init);
 module_exit(raid_exit);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("md-personality-9"); /* RAID10 */
+MODULE_ALIAS("md-level-10");

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-12-01 14:01:59.000000000 +1100
+++ ./drivers/md/raid5.c	2005-12-01 14:03:25.000000000 +1100
@@ -2186,9 +2186,10 @@ static void raid5_quiesce(mddev_t *mddev
 	}
 }
 
-static mdk_personality_t raid5_personality=
+static struct mdk_personality raid5_personality =
 {
 	.name		= "raid5",
+	.level		= 5,
 	.owner		= THIS_MODULE,
 	.make_request	= make_request,
 	.run		= run,
@@ -2203,17 +2204,40 @@ static mdk_personality_t raid5_personali
 	.quiesce	= raid5_quiesce,
 };
 
-static int __init raid5_init (void)
+static struct mdk_personality raid4_personality =
 {
-	return register_md_personality (RAID5, &raid5_personality);
+	.name		= "raid4",
+	.level		= 4,
+	.owner		= THIS_MODULE,
+	.make_request	= make_request,
+	.run		= run,
+	.stop		= stop,
+	.status		= status,
+	.error_handler	= error,
+	.hot_add_disk	= raid5_add_disk,
+	.hot_remove_disk= raid5_remove_disk,
+	.spare_active	= raid5_spare_active,
+	.sync_request	= sync_request,
+	.resize		= raid5_resize,
+	.quiesce	= raid5_quiesce,
+};
+
+static int __init raid5_init(void)
+{
+	register_md_personality(&raid5_personality);
+	register_md_personality(&raid4_personality);
+	return 0;
 }
 
-static void raid5_exit (void)
+static void raid5_exit(void)
 {
-	unregister_md_personality (RAID5);
+	unregister_md_personality(&raid5_personality);
+	unregister_md_personality(&raid4_personality);
 }
 
 module_init(raid5_init);
 module_exit(raid5_exit);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("md-personality-4"); /* RAID5 */
+MODULE_ALIAS("md-level-5");
+MODULE_ALIAS("md-level-4");

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2005-12-01 14:01:58.000000000 +1100
+++ ./drivers/md/raid6main.c	2005-12-01 14:03:25.000000000 +1100
@@ -2304,9 +2304,10 @@ static void raid6_quiesce(mddev_t *mddev
 	}
 }
 
-static mdk_personality_t raid6_personality=
+static struct mdk_personality raid6_personality =
 {
 	.name		= "raid6",
+	.level		= 6,
 	.owner		= THIS_MODULE,
 	.make_request	= make_request,
 	.run		= run,
@@ -2321,7 +2322,7 @@ static mdk_personality_t raid6_personali
 	.quiesce	= raid6_quiesce,
 };
 
-static int __init raid6_init (void)
+static int __init raid6_init(void)
 {
 	int e;
 
@@ -2329,15 +2330,16 @@ static int __init raid6_init (void)
 	if ( e )
 		return e;
 
-	return register_md_personality (RAID6, &raid6_personality);
+	return register_md_personality(&raid6_personality);
 }
 
 static void raid6_exit (void)
 {
-	unregister_md_personality (RAID6);
+	unregister_md_personality(&raid6_personality);
 }
 
 module_init(raid6_init);
 module_exit(raid6_exit);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("md-personality-8"); /* RAID6 */
+MODULE_ALIAS("md-level-6");

diff ./include/linux/raid/md.h~current~ ./include/linux/raid/md.h
--- ./include/linux/raid/md.h~current~	2005-12-01 13:59:45.000000000 +1100
+++ ./include/linux/raid/md.h	2005-12-01 14:03:25.000000000 +1100
@@ -71,8 +71,8 @@
  */
 #define MD_PATCHLEVEL_VERSION           3
 
-extern int register_md_personality (int p_num, mdk_personality_t *p);
-extern int unregister_md_personality (int p_num);
+extern int register_md_personality (struct mdk_personality *p);
+extern int unregister_md_personality (struct mdk_personality *p);
 extern mdk_thread_t * md_register_thread (void (*run) (mddev_t *mddev),
 				mddev_t *mddev, const char *name);
 extern void md_unregister_thread (mdk_thread_t *thread);

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2005-12-01 13:59:45.000000000 +1100
+++ ./include/linux/raid/md_k.h	2005-12-01 14:03:25.000000000 +1100
@@ -18,62 +18,19 @@
 /* and dm-bio-list.h is not under include/linux because.... ??? */
 #include "../../../drivers/md/dm-bio-list.h"
 
-#define MD_RESERVED       0UL
-#define LINEAR            1UL
-#define RAID0             2UL
-#define RAID1             3UL
-#define RAID5             4UL
-#define TRANSLUCENT       5UL
-#define HSM               6UL
-#define MULTIPATH         7UL
-#define RAID6		  8UL
-#define	RAID10		  9UL
-#define FAULTY		  10UL
-#define MAX_PERSONALITY   11UL
-
 #define	LEVEL_MULTIPATH		(-4)
 #define	LEVEL_LINEAR		(-1)
 #define	LEVEL_FAULTY		(-5)
 
+/* we need a value for 'no level specified' and 0
+ * means 'raid0', so we need something else.  This is
+ * for internal use only
+ */
+#define	LEVEL_NONE		(-1000000)
+
 #define MaxSector (~(sector_t)0)
 #define MD_THREAD_NAME_MAX 14
 
-static inline int pers_to_level (int pers)
-{
-	switch (pers) {
-		case FAULTY:		return LEVEL_FAULTY;
-		case MULTIPATH:		return LEVEL_MULTIPATH;
-		case HSM:		return -3;
-		case TRANSLUCENT:	return -2;
-		case LINEAR:		return LEVEL_LINEAR;
-		case RAID0:		return 0;
-		case RAID1:		return 1;
-		case RAID5:		return 5;
-		case RAID6:		return 6;
-		case RAID10:		return 10;
-	}
-	BUG();
-	return MD_RESERVED;
-}
-
-static inline int level_to_pers (int level)
-{
-	switch (level) {
-		case LEVEL_FAULTY: return FAULTY;
-		case LEVEL_MULTIPATH: return MULTIPATH;
-		case -3: return HSM;
-		case -2: return TRANSLUCENT;
-		case LEVEL_LINEAR: return LINEAR;
-		case 0: return RAID0;
-		case 1: return RAID1;
-		case 4:
-		case 5: return RAID5;
-		case 6: return RAID6;
-		case 10: return RAID10;
-	}
-	return MD_RESERVED;
-}
-
 typedef struct mddev_s mddev_t;
 typedef struct mdk_rdev_s mdk_rdev_t;
 
@@ -140,12 +97,10 @@ struct mdk_rdev_s
 					 */
 };
 
-typedef struct mdk_personality_s mdk_personality_t;
-
 struct mddev_s
 {
 	void				*private;
-	mdk_personality_t		*pers;
+	struct mdk_personality		*pers;
 	dev_t				unit;
 	int				md_minor;
 	struct list_head 		disks;
@@ -266,9 +221,11 @@ static inline void md_sync_acct(struct b
         atomic_add(nr_sectors, &bdev->bd_contains->bd_disk->sync_io);
 }
 
-struct mdk_personality_s
+struct mdk_personality
 {
 	char *name;
+	int level;
+	struct list_head list;
 	struct module *owner;
 	int (*make_request)(request_queue_t *q, struct bio *bio);
 	int (*run)(mddev_t *mddev);

diff ./init/do_mounts_md.c~current~ ./init/do_mounts_md.c
--- ./init/do_mounts_md.c~current~	2005-12-01 13:59:45.000000000 +1100
+++ ./init/do_mounts_md.c	2005-12-01 14:03:25.000000000 +1100
@@ -17,7 +17,7 @@ static int __initdata raid_noautodetect,
 static struct {
 	int minor;
 	int partitioned;
-	int pers;
+	int level;
 	int chunk;
 	char *device_names;
 } md_setup_args[MAX_MD_DEVS] __initdata;
@@ -47,7 +47,7 @@ extern int mdp_major;
  */
 static int __init md_setup(char *str)
 {
-	int minor, level, factor, fault, pers, partitioned = 0;
+	int minor, level, factor, fault, partitioned = 0;
 	char *pername = "";
 	char *str1;
 	int ent;
@@ -78,7 +78,7 @@ static int __init md_setup(char *str)
 	}
 	if (ent >= md_setup_ents)
 		md_setup_ents++;
-	switch (get_option(&str, &level)) {	/* RAID Personality */
+	switch (get_option(&str, &level)) {	/* RAID level */
 	case 2: /* could be 0 or -1.. */
 		if (level == 0 || level == LEVEL_LINEAR) {
 			if (get_option(&str, &factor) != 2 ||	/* Chunk Size */
@@ -86,16 +86,12 @@ static int __init md_setup(char *str)
 				printk(KERN_WARNING "md: Too few arguments supplied to md=.\n");
 				return 0;
 			}
-			md_setup_args[ent].pers = level;
+			md_setup_args[ent].level = level;
 			md_setup_args[ent].chunk = 1 << (factor+12);
-			if (level ==  LEVEL_LINEAR) {
-				pers = LINEAR;
+			if (level ==  LEVEL_LINEAR)
 				pername = "linear";
-			} else {
-				pers = RAID0;
+			else
 				pername = "raid0";
-			}
-			md_setup_args[ent].pers = pers;
 			break;
 		}
 		/* FALL THROUGH */
@@ -103,7 +99,7 @@ static int __init md_setup(char *str)
 		str = str1;
 		/* FALL THROUGH */
 	case 0:
-		md_setup_args[ent].pers = 0;
+		md_setup_args[ent].level = LEVEL_NONE;
 		pername="super-block";
 	}
 
@@ -190,10 +186,10 @@ static void __init md_setup_drive(void)
 			continue;
 		}
 
-		if (md_setup_args[ent].pers) {
+		if (md_setup_args[ent].level != LEVEL_NONE) {
 			/* non-persistent */
 			mdu_array_info_t ainfo;
-			ainfo.level = pers_to_level(md_setup_args[ent].pers);
+			ainfo.level = md_setup_args[ent].level;
 			ainfo.size = 0;
 			ainfo.nr_disks =0;
 			ainfo.raid_disks =0;
