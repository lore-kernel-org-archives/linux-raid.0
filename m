From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 3 of 3 - Convert md personalities to new module interface
Date: Wed, 26 Mar 2003 11:11:01 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E18xyVR-0004U5-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

Thanks to  Angus Sawyer <angus.sawyer@dsl.pipex.com> and 
   Daniel McNeil <daniel@osdl.org>

 ----------- Diffstat output ------------
 ./drivers/md/linear.c       |    6 +-----
 ./drivers/md/md.c           |   30 ++++++++++++++++++++++--------
 ./drivers/md/multipath.c    |    5 +----
 ./drivers/md/raid0.c        |    5 +----
 ./drivers/md/raid1.c        |    5 +----
 ./drivers/md/raid5.c        |    6 +-----
 ./include/linux/raid/md_k.h |    1 +
 7 files changed, 28 insertions(+), 30 deletions(-)

diff ./drivers/md/linear.c~current~ ./drivers/md/linear.c
--- ./drivers/md/linear.c~current~	2003-03-26 10:55:20.000000000 +1100
+++ ./drivers/md/linear.c	2003-03-26 10:37:28.000000000 +1100
@@ -79,8 +79,6 @@ static int linear_run (mddev_t *mddev)
 	unsigned int curr_offset;
 	struct list_head *tmp;
 
-	MOD_INC_USE_COUNT;
-
 	conf = kmalloc (sizeof (*conf), GFP_KERNEL);
 	if (!conf)
 		goto out;
@@ -167,7 +165,6 @@ static int linear_run (mddev_t *mddev)
 out:
 	if (conf)
 		kfree(conf);
-	MOD_DEC_USE_COUNT;
 	return 1;
 }
 
@@ -178,8 +175,6 @@ static int linear_stop (mddev_t *mddev)
 	kfree(conf->hash_table);
 	kfree(conf);
 
-	MOD_DEC_USE_COUNT;
-
 	return 0;
 }
 
@@ -246,6 +241,7 @@ static void linear_status (struct seq_fi
 static mdk_personality_t linear_personality=
 {
 	.name		= "linear",
+	.owner		= THIS_MODULE,
 	.make_request	= linear_make_request,
 	.run		= linear_run,
 	.stop		= linear_stop,

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-03-26 10:55:20.000000000 +1100
+++ ./drivers/md/md.c	2003-03-26 10:56:07.000000000 +1100
@@ -64,6 +64,7 @@ static void autostart_arrays (void);
 #endif
 
 static mdk_personality_t *pers[MAX_PERSONALITY];
+static spinlock_t pers_lock = SPIN_LOCK_UNLOCKED;
 
 /*
  * Current RAID-1,4,5 parallel reconstruction 'guaranteed speed limit'
@@ -1648,20 +1649,14 @@ static int do_md_run(mddev_t * mddev)
 		return -EINVAL;
 	}
 
+#ifdef CONFIG_KMOD
 	if (!pers[pnum])
 	{
-#ifdef CONFIG_KMOD
 		char module_name[80];
 		sprintf (module_name, "md-personality-%d", pnum);
 		request_module (module_name);
-		if (!pers[pnum])
-#endif
-		{
-			printk(KERN_ERR "md: personality %d is not loaded!\n",
-				pnum);
-			return -EINVAL;
-		}
 	}
+#endif
 
 	if (device_size_calculation(mddev))
 		return -EINVAL;
@@ -1695,7 +1690,17 @@ static int do_md_run(mddev_t * mddev)
 	disk = disks[mdidx(mddev)];
 	if (!disk)
 		return -ENOMEM;
+
+	spin_lock(&pers_lock);
+	if (!pers[pnum] || !try_module_get(pers[pnum]->owner)) {
+		spin_unlock(&pers_lock);
+		printk(KERN_ERR "md: personality %d is not loaded!\n",
+		       pnum);
+		return -EINVAL;
+	}
+
 	mddev->pers = pers[pnum];
+	spin_unlock(&pers_lock);
 
 	blk_queue_make_request(&mddev->queue, mddev->pers->make_request);
 	printk("%s: setting max_sectors to %d, segment boundary to %d\n",
@@ -1710,6 +1715,7 @@ static int do_md_run(mddev_t * mddev)
 	if (err) {
 		printk(KERN_ERR "md: pers->run() failed ...\n");
 		mddev->pers = NULL;
+		module_put(mddev->pers->owner);
 		return -EINVAL;
 	}
  	atomic_set(&mddev->writes_pending,0);
@@ -1800,6 +1806,7 @@ static int do_md_stop(mddev_t * mddev, i
 					set_disk_ro(disk, 1);
 				goto out;
 			}
+			module_put(mddev->pers->owner);
 			mddev->pers = NULL;
 			if (mddev->ro)
 				mddev->ro = 0;
@@ -3006,10 +3013,12 @@ static int md_seq_show(struct seq_file *
 
 	if (v == (void*)1) {
 		seq_printf(seq, "Personalities : ");
+		spin_lock(&pers_lock);
 		for (i = 0; i < MAX_PERSONALITY; i++)
 			if (pers[i])
 				seq_printf(seq, "[%s] ", pers[i]->name);
 
+		spin_unlock(&pers_lock);
 		seq_printf(seq, "\n");
 		return 0;
 	}
@@ -3093,13 +3102,16 @@ int register_md_personality(int pnum, md
 		return -EINVAL;
 	}
 
+	spin_lock(&pers_lock);
 	if (pers[pnum]) {
+		spin_unlock(&pers_lock);
 		MD_BUG();
 		return -EBUSY;
 	}
 
 	pers[pnum] = p;
 	printk(KERN_INFO "md: %s personality registered as nr %d\n", p->name, pnum);
+	spin_unlock(&pers_lock);
 	return 0;
 }
 
@@ -3111,7 +3123,9 @@ int unregister_md_personality(int pnum)
 	}
 
 	printk(KERN_INFO "md: %s personality unregistered\n", pers[pnum]->name);
+	spin_lock(&pers_lock);
 	pers[pnum] = NULL;
+	spin_unlock(&pers_lock);
 	return 0;
 }
 

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2003-03-26 10:55:20.000000000 +1100
+++ ./drivers/md/multipath.c	2003-03-26 10:37:52.000000000 +1100
@@ -365,8 +365,6 @@ static int multipath_run (mddev_t *mddev
 	mdk_rdev_t *rdev;
 	struct list_head *tmp;
 
-	MOD_INC_USE_COUNT;
-
 	if (mddev->level != LEVEL_MULTIPATH) {
 		printk("multipath: md%d: raid level not set to multipath IO (%d)\n",
 		       mdidx(mddev), mddev->level);
@@ -448,7 +446,6 @@ out_free_conf:
 	kfree(conf);
 	mddev->private = NULL;
 out:
-	MOD_DEC_USE_COUNT;
 	return -EIO;
 }
 
@@ -461,13 +458,13 @@ static int multipath_stop (mddev_t *mdde
 	mempool_destroy(conf->pool);
 	kfree(conf);
 	mddev->private = NULL;
-	MOD_DEC_USE_COUNT;
 	return 0;
 }
 
 static mdk_personality_t multipath_personality=
 {
 	.name		= "multipath",
+	.owner		= THIS_MODULE,
 	.make_request	= multipath_make_request,
 	.run		= multipath_run,
 	.stop		= multipath_stop,

diff ./drivers/md/raid0.c~current~ ./drivers/md/raid0.c
--- ./drivers/md/raid0.c~current~	2003-03-26 10:55:20.000000000 +1100
+++ ./drivers/md/raid0.c	2003-03-26 10:37:28.000000000 +1100
@@ -197,8 +197,6 @@ static int raid0_run (mddev_t *mddev)
 	s64 size;
 	raid0_conf_t *conf;
 
-	MOD_INC_USE_COUNT;
-
 	conf = vmalloc(sizeof (raid0_conf_t));
 	if (!conf)
 		goto out;
@@ -275,7 +273,6 @@ out_free_conf:
 	vfree(conf);
 	mddev->private = NULL;
 out:
-	MOD_DEC_USE_COUNT;
 	return 1;
 }
 
@@ -290,7 +287,6 @@ static int raid0_stop (mddev_t *mddev)
 	vfree (conf);
 	mddev->private = NULL;
 
-	MOD_DEC_USE_COUNT;
 	return 0;
 }
 
@@ -424,6 +420,7 @@ static void raid0_status (struct seq_fil
 static mdk_personality_t raid0_personality=
 {
 	.name		= "raid0",
+	.owner		= THIS_MODULE,
 	.make_request	= raid0_make_request,
 	.run		= raid0_run,
 	.stop		= raid0_stop,

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2003-03-26 10:55:20.000000000 +1100
+++ ./drivers/md/raid1.c	2003-03-26 10:37:59.000000000 +1100
@@ -1061,8 +1061,6 @@ static int run(mddev_t *mddev)
 	mdk_rdev_t *rdev;
 	struct list_head *tmp;
 
-	MOD_INC_USE_COUNT;
-
 	if (mddev->level != 1) {
 		printk("raid1: md%d: raid level not set to mirroring (%d)\n",
 		       mdidx(mddev), mddev->level);
@@ -1166,7 +1164,6 @@ out_free_conf:
 	kfree(conf);
 	mddev->private = NULL;
 out:
-	MOD_DEC_USE_COUNT;
 	return -EIO;
 }
 
@@ -1180,13 +1177,13 @@ static int stop(mddev_t *mddev)
 		mempool_destroy(conf->r1bio_pool);
 	kfree(conf);
 	mddev->private = NULL;
-	MOD_DEC_USE_COUNT;
 	return 0;
 }
 
 static mdk_personality_t raid1_personality =
 {
 	.name		= "raid1",
+	.owner		= THIS_MODULE,
 	.make_request	= make_request,
 	.run		= run,
 	.stop		= stop,

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2003-03-26 10:55:20.000000000 +1100
+++ ./drivers/md/raid5.c	2003-03-26 10:37:28.000000000 +1100
@@ -1433,11 +1433,8 @@ static int run (mddev_t *mddev)
 	struct disk_info *disk;
 	struct list_head *tmp;
 
-	MOD_INC_USE_COUNT;
-
 	if (mddev->level != 5 && mddev->level != 4) {
 		printk("raid5: md%d: raid level not set to 4/5 (%d)\n", mdidx(mddev), mddev->level);
-		MOD_DEC_USE_COUNT;
 		return -EIO;
 	}
 
@@ -1563,7 +1560,6 @@ abort:
 	}
 	mddev->private = NULL;
 	printk(KERN_ALERT "raid5: failed to run raid set md%d\n", mdidx(mddev));
-	MOD_DEC_USE_COUNT;
 	return -EIO;
 }
 
@@ -1579,7 +1575,6 @@ static int stop (mddev_t *mddev)
 	free_pages((unsigned long) conf->stripe_hashtbl, HASH_PAGES_ORDER);
 	kfree(conf);
 	mddev->private = NULL;
-	MOD_DEC_USE_COUNT;
 	return 0;
 }
 
@@ -1735,6 +1730,7 @@ static int raid5_add_disk(mddev_t *mddev
 static mdk_personality_t raid5_personality=
 {
 	.name		= "raid5",
+	.owner		= THIS_MODULE,
 	.make_request	= make_request,
 	.run		= run,
 	.stop		= stop,

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2003-03-26 10:55:20.000000000 +1100
+++ ./include/linux/raid/md_k.h	2003-03-26 10:37:28.000000000 +1100
@@ -254,6 +254,7 @@ struct mddev_s
 struct mdk_personality_s
 {
 	char *name;
+	struct module *owner;
 	int (*make_request)(request_queue_t *q, struct bio *bio);
 	int (*run)(mddev_t *mddev);
 	int (*stop)(mddev_t *mddev);
