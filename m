From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - Fix problems with freeing gendisk in md.c
Date: Thu, 12 Sep 2002 12:57:37 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1020912025737.20468@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

md currently tries to set_capacity() *after* freeing
the gendisk structure.
It also frees the gendisk even when switching to read-only.

That patch open-codes free_mddev (which is only called once)
and cleans all this up.


 ----------- Diffstat output ------------
 ./drivers/md/md.c |   37 ++++++++++++++-----------------------
 1 files changed, 14 insertions(+), 23 deletions(-)

--- ./drivers/md/md.c	2002/09/11 00:59:18	1.3
+++ ./drivers/md/md.c	2002/09/12 02:53:48	1.4
@@ -601,18 +601,6 @@ static void export_array(mddev_t *mddev)
 	mddev->raid_disks = 0;
 }
 
-static void free_mddev(mddev_t *mddev)
-{
-	if (!mddev) {
-		MD_BUG();
-		return;
-	}
-
-	export_array(mddev);
-	md_size[mdidx(mddev)] = 0;
-	set_capacity(disks[mdidx(mddev)], 0);
-}
-
 #undef BAD_CSUM
 #undef BAD_MAGIC
 #undef OUT_OF_MEM
@@ -1530,7 +1518,6 @@ static int do_md_stop(mddev_t * mddev, i
 {
 	int err = 0;
 	kdev_t dev = mddev_to_kdev(mddev);
-	struct gendisk *disk;
 
 	if (atomic_read(&mddev->active)>1) {
 		printk(STILL_IN_USE, mdidx(mddev));
@@ -1579,21 +1566,25 @@ static int do_md_stop(mddev_t * mddev, i
 		if (ro)
 			set_device_ro(dev, 1);
 	}
-	disk = disks[mdidx(mddev)];
-	disks[mdidx(mddev)] = NULL;
-
-	if (disk) {
-		del_gendisk(disk);
-		kfree(disk->major_name);
-		kfree(disk);
-	}
-
 	/*
 	 * Free resources if final stop
 	 */
 	if (!ro) {
+		struct gendisk *disk;
 		printk(KERN_INFO "md: md%d stopped.\n", mdidx(mddev));
-		free_mddev(mddev);
+
+		export_array(mddev);
+
+		md_size[mdidx(mddev)] = 0;
+		disk = disks[mdidx(mddev)];
+		disks[mdidx(mddev)] = NULL;
+
+		if (disk) {
+			del_gendisk(disk);
+			kfree(disk->major_name);
+			kfree(disk);
+		}
+
 	} else
 		printk(KERN_INFO "md: md%d switched to read-only mode.\n", mdidx(mddev));
 	err = 0;
