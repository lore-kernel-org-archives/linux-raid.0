From: NeilBrown <neilb@suse.de>
Subject: [PATCH 006 of 6] md: Change ITERATE_RDEV_GENERIC to rdev_for_each_list, and remove ITERATE_RDEV_PENDING.
Date: Mon, 14 Jan 2008 12:45:56 +1100
Message-ID: <1080114014556.20415@suse.de>
References: <20080114123726.19968.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Finish ITERATE_ to for_each conversion.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c           |    8 ++++----
 ./include/linux/raid/md_k.h |   14 ++++----------
 2 files changed, 8 insertions(+), 14 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-01-14 12:26:10.000000000 +1100
+++ ./drivers/md/md.c	2008-01-14 12:26:15.000000000 +1100
@@ -3767,7 +3767,7 @@ static void autorun_devices(int part)
 		printk(KERN_INFO "md: considering %s ...\n",
 			bdevname(rdev0->bdev,b));
 		INIT_LIST_HEAD(&candidates);
-		ITERATE_RDEV_PENDING(rdev,tmp)
+		rdev_for_each_list(rdev, tmp, pending_raid_disks)
 			if (super_90_load(rdev, rdev0, 0) >= 0) {
 				printk(KERN_INFO "md:  adding %s ...\n",
 					bdevname(rdev->bdev,b));
@@ -3810,7 +3810,7 @@ static void autorun_devices(int part)
 			mddev_unlock(mddev);
 		} else {
 			printk(KERN_INFO "md: created %s\n", mdname(mddev));
-			ITERATE_RDEV_GENERIC(candidates,rdev,tmp) {
+			rdev_for_each_list(rdev, tmp, candidates) {
 				list_del_init(&rdev->same_set);
 				if (bind_rdev_to_array(rdev, mddev))
 					export_rdev(rdev);
@@ -3821,7 +3821,7 @@ static void autorun_devices(int part)
 		/* on success, candidates will be empty, on error
 		 * it won't...
 		 */
-		ITERATE_RDEV_GENERIC(candidates,rdev,tmp)
+		rdev_for_each_list(rdev, tmp, candidates)
 			export_rdev(rdev);
 		mddev_put(mddev);
 	}
@@ -4936,7 +4936,7 @@ static void status_unused(struct seq_fil
 
 	seq_printf(seq, "unused devices: ");
 
-	ITERATE_RDEV_PENDING(rdev,tmp) {
+	rdev_for_each_list(rdev, tmp, pending_raid_disks) {
 		char b[BDEVNAME_SIZE];
 		i++;
 		seq_printf(seq, "%s ",

diff .prev/include/linux/raid/md_k.h ./include/linux/raid/md_k.h
--- .prev/include/linux/raid/md_k.h	2008-01-14 12:26:10.000000000 +1100
+++ ./include/linux/raid/md_k.h	2008-01-14 12:26:15.000000000 +1100
@@ -313,23 +313,17 @@ static inline char * mdname (mddev_t * m
  * iterates through some rdev ringlist. It's safe to remove the
  * current 'rdev'. Dont touch 'tmp' though.
  */
-#define ITERATE_RDEV_GENERIC(head,rdev,tmp)				\
+#define rdev_for_each_list(rdev, tmp, list)				\
 									\
-	for ((tmp) = (head).next;					\
+	for ((tmp) = (list).next;					\
 		(rdev) = (list_entry((tmp), mdk_rdev_t, same_set)),	\
-			(tmp) = (tmp)->next, (tmp)->prev != &(head)	\
+			(tmp) = (tmp)->next, (tmp)->prev != &(list)	\
 		; )
 /*
  * iterates through the 'same array disks' ringlist
  */
 #define rdev_for_each(rdev, tmp, mddev)				\
-	ITERATE_RDEV_GENERIC((mddev)->disks,rdev,tmp)
-
-/*
- * Iterates through 'pending RAID disks'
- */
-#define ITERATE_RDEV_PENDING(rdev,tmp)					\
-	ITERATE_RDEV_GENERIC(pending_raid_disks,rdev,tmp)
+	rdev_for_each_list(rdev, tmp, (mddev)->disks)
 
 typedef struct mdk_thread_s {
 	void			(*run) (mddev_t *mddev);
