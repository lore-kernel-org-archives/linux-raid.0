From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 1 of 3 - Remove BUG in md.c that change in 2.5.33 triggers.
Date: Wed, 11 Sep 2002 11:02:04 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1020911010204.4458@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

Since 2.5.33, the blk_dev[].queue is called without
the device open, so md_queue_proc can no-longer assume
that the device is open.



 ----------- Diffstat output ------------
 ./drivers/md/md.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

--- ./drivers/md/md.c	2002/09/11 00:27:10	1.1
+++ ./drivers/md/md.c	2002/09/11 00:37:33	1.2
@@ -3149,11 +3149,11 @@ request_queue_t * md_queue_proc(kdev_t d
 {
 	mddev_t *mddev = mddev_find(minor(dev));
 	request_queue_t *q = BLK_DEFAULT_QUEUE(MAJOR_NR);
-	if (!mddev || atomic_read(&mddev->active)<2)
-		BUG();
-	if (mddev->pers)
-		q = &mddev->queue;
-	mddev_put(mddev); /* the caller must hold a reference... */
+	if (mddev) {
+		if (mddev->pers)
+			q = &mddev->queue;
+		mddev_put(mddev);
+	}
 	return q;
 }
 
