From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 1 of 3 - Don't setup make_request_fn for md array until *after* it has been start.
Date: Tue, 23 Sep 2003 09:26:58 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1A1a54-0004C6-00@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Three patches for drivers/md in 2.6.0-testX..
Thanks,
NeilBrown

### Comments for ChangeSet

Also revert to md_fail_request before stopping an array.

The ->stop method can never fail, so there is not point checking it.

 ----------- Diffstat output ------------
 ./drivers/md/md.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-09-23 09:08:10.000000000 +1000
+++ ./drivers/md/md.c	2003-09-23 09:10:42.000000000 +1000
@@ -1607,9 +1607,6 @@ static int do_md_run(mddev_t * mddev)
 	mddev->pers = pers[pnum];
 	spin_unlock(&pers_lock);
 
-	blk_queue_make_request(mddev->queue, mddev->pers->make_request);
-	mddev->queue->queuedata = mddev;
-
 	err = mddev->pers->run(mddev);
 	if (err) {
 		printk(KERN_ERR "md: pers->run() failed ...\n");
@@ -1627,6 +1624,10 @@ static int do_md_run(mddev_t * mddev)
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
 	set_capacity(disk, mddev->array_size<<1);
+
+	blk_queue_make_request(mddev->queue, mddev->pers->make_request);
+	mddev->queue->queuedata = mddev;
+
 	return 0;
 }
 
@@ -1698,12 +1699,8 @@ static int do_md_stop(mddev_t * mddev, i
 		} else {
 			if (mddev->ro)
 				set_disk_ro(disk, 0);
-			if (mddev->pers->stop(mddev)) {
-				err = -EBUSY;
-				if (mddev->ro)
-					set_disk_ro(disk, 1);
-				goto out;
-			}
+			blk_queue_make_request(mddev->queue, md_fail_request);
+			mddev->pers->stop(mddev);
 			module_put(mddev->pers->owner);
 			mddev->pers = NULL;
 			if (mddev->ro)
