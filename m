From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - md 5 of 22 - Fix various list.h list related problems in md.c
Date: Wed, 19 Jun 2002 10:50:34 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15631.54618.665407.371307@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids




Several awkard constructs could be replaced by
list_del_init, list_for_each or list_empty.

Also two bugs fixes:
 free_device_names was freeing the wrong thing
 same_set wasn't initialised.



 ----------- Diffstat output ------------
 ./drivers/md/md.c |   39 ++++++++++++++++-----------------------
 1 files changed, 16 insertions(+), 23 deletions(-)

--- ./drivers/md/md.c	2002/06/18 03:31:03	1.4
+++ ./drivers/md/md.c	2002/06/18 03:33:36	1.5
@@ -253,13 +253,12 @@
 	struct gendisk *hd;
 	static char nomem [] = "<nomem>";
 	dev_name_t *dname;
-	struct list_head *tmp = device_names.next;
+	struct list_head *tmp;
 
-	while (tmp != &device_names) {
+	list_for_each(tmp, &device_names) {
 		dname = list_entry(tmp, dev_name_t, list);
 		if (kdev_same(dname->dev, dev))
 			return dname->name;
-		tmp = tmp->next;
 	}
 
 	dname = (dev_name_t *) kmalloc(sizeof(*dname), GFP_KERNEL);
@@ -279,7 +278,6 @@
 	}
 
 	dname->dev = dev;
-	INIT_LIST_HEAD(&dname->list);
 	list_add(&dname->list, &device_names);
 
 	return dname->name;
@@ -632,8 +630,7 @@
 		MD_BUG();
 		return;
 	}
-	list_del(&rdev->same_set);
-	INIT_LIST_HEAD(&rdev->same_set);
+	list_del_init(&rdev->same_set);
 	rdev->mddev->nb_dev--;
 	printk(KERN_INFO "md: unbind<%s,%d>\n", partition_name(rdev->dev),
 						 rdev->mddev->nb_dev);
@@ -686,13 +683,11 @@
 		MD_BUG();
 	unlock_rdev(rdev);
 	free_disk_sb(rdev);
-	list_del(&rdev->all);
-	INIT_LIST_HEAD(&rdev->all);
-	if (rdev->pending.next != &rdev->pending) {
+	list_del_init(&rdev->all);
+	if (!list_empty(&rdev->pending)) {
 		printk(KERN_INFO "md: (%s was pending)\n",
 			partition_name(rdev->dev));
-		list_del(&rdev->pending);
-		INIT_LIST_HEAD(&rdev->pending);
+		list_del_init(&rdev->pending);
 	}
 #ifndef MODULE
 	md_autodetect_dev(rdev->dev);
@@ -752,7 +747,6 @@
 
 	del_mddev_mapping(mddev, mk_kdev(MD_MAJOR, mdidx(mddev)));
 	list_del(&mddev->all_mddevs);
-	INIT_LIST_HEAD(&mddev->all_mddevs);
 	kfree(mddev);
 	MOD_DEC_USE_COUNT;
 }
@@ -896,12 +890,10 @@
 	struct list_head *tmp;
 	mdk_rdev_t *rdev;
 
-	tmp = all_raid_disks.next;
-	while (tmp != &all_raid_disks) {
+	list_for_each(tmp, &all_raid_disks) {
 		rdev = list_entry(tmp, mdk_rdev_t, all);
 		if (kdev_same(rdev->dev, dev))
 			return rdev;
-		tmp = tmp->next;
 	}
 	return NULL;
 }
@@ -1126,6 +1118,7 @@
 	}
 	list_add(&rdev->all, &all_raid_disks);
 	INIT_LIST_HEAD(&rdev->pending);
+	INIT_LIST_HEAD(&rdev->same_set);
 
 	if (rdev->faulty && rdev->sb)
 		free_disk_sb(rdev);
@@ -1883,7 +1876,7 @@
 	struct list_head *tmp;
 	int err;
 
-	if (mddev->disks.prev == &mddev->disks) {
+	if (list_empty(&mddev->disks)) {
 		MD_BUG();
 		return;
 	}
@@ -1928,7 +1921,7 @@
 
 
 	printk(KERN_INFO "md: autorun ...\n");
-	while (pending_raid_disks.next != &pending_raid_disks) {
+	while (!list_empty(&pending_raid_disks)) {
 		rdev0 = list_entry(pending_raid_disks.next,
 					 mdk_rdev_t, pending);
 
@@ -1971,8 +1964,7 @@
 		printk(KERN_INFO "md: created md%d\n", mdidx(mddev));
 		ITERATE_RDEV_GENERIC(candidates,pending,rdev,tmp) {
 			bind_rdev_to_array(rdev, mddev);
-			list_del(&rdev->pending);
-			INIT_LIST_HEAD(&rdev->pending);
+			list_del_init(&rdev->pending);
 		}
 		autorun_array(mddev);
 	}
@@ -3086,7 +3078,7 @@
 	sz += sprintf(page + sz, "unused devices: ");
 
 	ITERATE_RDEV_ALL(rdev,tmp) {
-		if (!rdev->same_set.next && !rdev->same_set.prev) {
+		if (list_empty(&rdev->same_set)) {
 			/*
 			 * The device is not yet used by any array.
 			 */
@@ -3988,9 +3980,10 @@
 
 static void free_device_names(void)
 {
-	while (device_names.next != &device_names) {
-		struct list_head *tmp = device_names.next;
-		list_del(tmp);
+	while (!list_empty(&device_names)) {
+		struct dname *tmp = list_entry(device_names.next,
+					       dev_name_t, list);
+		list_del(&tmp->list);
 		kfree(tmp);
 	}
 }
