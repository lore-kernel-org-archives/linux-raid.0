From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] MD - 9 of 27 - Rdev list cleanups.
Date: Thu, 18 Jul 2002 23:33:04 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1020718133304.4835@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet
Rdev list cleanups.

An "rdev" can be on three different lists.
 - the list of all rdevs
 - the list of pending rdevs
 - the list of rdevs for a given mddev

The first list is now only used to list "unused" devices in
/proc/mdstat, and only pending rdevs can be unused, so this list 
isn't necessary.
An rdev cannot be both pending and in an mddev, so we know rdev will
only be on one list at at time.

This patch discards  the all_raid_disks list, and changes the
pending list to use "same_set" in the rdev.  It also changes
/proc/mdstat to iterate through pending devices, rather than through
all devices.

So now an rdev is only on one list, either the pending list
or the list of rdevs for a given mddev.  This means that
ITERATE_RDEV_GENERIC doesn't need to be told which field,
to walk down: there is ony one.







 ----------- Diffstat output ------------
 ./drivers/md/md.c           |   44 +++++++++++++++-----------------------------
 ./include/linux/raid/md_k.h |   17 ++++-------------
 2 files changed, 19 insertions(+), 42 deletions(-)

--- ./drivers/md/md.c	2002/07/18 12:00:45	1.4
+++ ./drivers/md/md.c	2002/07/18 12:00:52	1.5
@@ -550,7 +550,6 @@ static int match_mddev_units(mddev_t *md
 	return 0;
 }
 
-static LIST_HEAD(all_raid_disks);
 static LIST_HEAD(pending_raid_disks);
 
 static void bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
@@ -629,14 +628,9 @@ static void export_rdev(mdk_rdev_t * rde
 	printk(KERN_INFO "md: export_rdev(%s)\n",partition_name(rdev->dev));
 	if (rdev->mddev)
 		MD_BUG();
-	unlock_rdev(rdev);
 	free_disk_sb(rdev);
-	list_del_init(&rdev->all);
-	if (!list_empty(&rdev->pending)) {
-		printk(KERN_INFO "md: (%s was pending)\n",
-			partition_name(rdev->dev));
-		list_del_init(&rdev->pending);
-	}
+	list_del_init(&rdev->same_set);
+	unlock_rdev(rdev);
 #ifndef MODULE
 	md_autodetect_dev(rdev->dev);
 #endif
@@ -1044,8 +1038,6 @@ static mdk_rdev_t *md_import_device(kdev
 			rdev->desc_nr = -1;
 		}
 	}
-	list_add(&rdev->all, &all_raid_disks);
-	INIT_LIST_HEAD(&rdev->pending);
 	INIT_LIST_HEAD(&rdev->same_set);
 
 	if (rdev->faulty && rdev->sb)
@@ -1821,7 +1813,7 @@ static void autorun_array(mddev_t *mddev
 
 /*
  * lets try to run arrays based on all disks that have arrived
- * until now. (those are in the ->pending list)
+ * until now. (those are in pending_raid_disks)
  *
  * the method: pick the first pending disk, collect all disks with
  * the same UUID, remove all from the pending list and put them into
@@ -1841,7 +1833,7 @@ static void autorun_devices(void)
 	printk(KERN_INFO "md: autorun ...\n");
 	while (!list_empty(&pending_raid_disks)) {
 		rdev0 = list_entry(pending_raid_disks.next,
-					 mdk_rdev_t, pending);
+					 mdk_rdev_t, same_set);
 
 		printk(KERN_INFO "md: considering %s ...\n", partition_name(rdev0->dev));
 		INIT_LIST_HEAD(&candidates);
@@ -1854,8 +1846,7 @@ static void autorun_devices(void)
 					continue;
 				}
 				printk(KERN_INFO "md:  adding %s ...\n", partition_name(rdev->dev));
-				list_del(&rdev->pending);
-				list_add(&rdev->pending, &candidates);
+				list_move(&rdev->same_set, &candidates);
 			}
 		}
 		/*
@@ -1878,9 +1869,9 @@ static void autorun_devices(void)
 			mddev_unlock(mddev);
 		} else {
 			printk(KERN_INFO "md: created md%d\n", mdidx(mddev));
-			ITERATE_RDEV_GENERIC(candidates,pending,rdev,tmp) {
+			ITERATE_RDEV_GENERIC(candidates,rdev,tmp) {
+				list_del_init(&rdev->same_set);
 				bind_rdev_to_array(rdev, mddev);
-				list_del_init(&rdev->pending);
 			}
 			autorun_array(mddev);
 			mddev_unlock(mddev);
@@ -1888,7 +1879,7 @@ static void autorun_devices(void)
 		/* on success, candidates will be empty, on error
 		 * it wont...
 		 */
-		ITERATE_RDEV_GENERIC(candidates,pending,rdev,tmp)
+		ITERATE_RDEV_GENERIC(candidates,rdev,tmp)
 			export_rdev(rdev);
 		mddev_put(mddev);
 	}
@@ -1944,7 +1935,7 @@ static int autostart_array(kdev_t startd
 						partition_name(startdev));
 		goto abort;
 	}
-	list_add(&start_rdev->pending, &pending_raid_disks);
+	list_add(&start_rdev->same_set, &pending_raid_disks);
 
 	sb = start_rdev->sb;
 
@@ -1973,7 +1964,7 @@ static int autostart_array(kdev_t startd
 			       partition_name(dev));
 			continue;
 		}
-		list_add(&rdev->pending, &pending_raid_disks);
+		list_add(&rdev->same_set, &pending_raid_disks);
 	}
 
 	/*
@@ -2897,15 +2888,10 @@ static int status_unused(char * page)
 
 	sz += sprintf(page + sz, "unused devices: ");
 
-	ITERATE_RDEV_ALL(rdev,tmp) {
-		if (list_empty(&rdev->same_set)) {
-			/*
-			 * The device is not yet used by any array.
-			 */
-			i++;
-			sz += sprintf(page + sz, "%s ",
-				partition_name(rdev->dev));
-		}
+	ITERATE_RDEV_PENDING(rdev,tmp) {
+		i++;
+		sz += sprintf(page + sz, "%s ",
+			      partition_name(rdev->dev));
 	}
 	if (!i)
 		sz += sprintf(page + sz, "<none>");
@@ -3556,7 +3542,7 @@ static void autostart_arrays(void)
 			MD_BUG();
 			continue;
 		}
-		list_add(&rdev->pending, &pending_raid_disks);
+		list_add(&rdev->same_set, &pending_raid_disks);
 	}
 	dev_cnt = 0;
 
--- ./include/linux/raid/md_k.h	2002/07/18 12:00:37	1.2
+++ ./include/linux/raid/md_k.h	2002/07/18 12:00:52	1.3
@@ -143,8 +143,6 @@ static inline void mark_disk_nonsync(mdp
 struct mdk_rdev_s
 {
 	struct list_head same_set;	/* RAID devices within the same set */
-	struct list_head all;		/* all RAID devices */
-	struct list_head pending;	/* undetected RAID devices */
 
 	kdev_t dev;			/* Device number */
 	kdev_t old_dev;			/*  "" when it was last imported */
@@ -239,30 +237,23 @@ extern mdp_disk_t *get_spare(mddev_t *md
  * iterates through some rdev ringlist. It's safe to remove the
  * current 'rdev'. Dont touch 'tmp' though.
  */
-#define ITERATE_RDEV_GENERIC(head,field,rdev,tmp)			\
+#define ITERATE_RDEV_GENERIC(head,rdev,tmp)				\
 									\
 	for ((tmp) = (head).next;					\
-		(rdev) = (list_entry((tmp), mdk_rdev_t, field)),	\
+		(rdev) = (list_entry((tmp), mdk_rdev_t, same_set)),	\
 			(tmp) = (tmp)->next, (tmp)->prev != &(head)	\
 		; )
 /*
  * iterates through the 'same array disks' ringlist
  */
 #define ITERATE_RDEV(mddev,rdev,tmp)					\
-	ITERATE_RDEV_GENERIC((mddev)->disks,same_set,rdev,tmp)
-
-
-/*
- * Iterates through all 'RAID managed disks'
- */
-#define ITERATE_RDEV_ALL(rdev,tmp)					\
-	ITERATE_RDEV_GENERIC(all_raid_disks,all,rdev,tmp)
+	ITERATE_RDEV_GENERIC((mddev)->disks,rdev,tmp)
 
 /*
  * Iterates through 'pending RAID disks'
  */
 #define ITERATE_RDEV_PENDING(rdev,tmp)					\
-	ITERATE_RDEV_GENERIC(pending_raid_disks,pending,rdev,tmp)
+	ITERATE_RDEV_GENERIC(pending_raid_disks,rdev,tmp)
 
 #define xchg_values(x,y) do { __typeof__(x) __tmp = x; \
 				x = y; y = __tmp; } while (0)
