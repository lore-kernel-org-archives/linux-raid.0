From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 3] md: Remove some code that can sleep from under a spinlock.
Date: Thu, 30 Mar 2006 16:52:42 +1100
Message-ID: <1060330055242.25283@suse.de>
References: <20060330164933.25210.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


And remove the comments that were put in inplace of a fix too....

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2006-03-30 16:48:30.000000000 +1100
+++ ./drivers/md/md.c	2006-03-30 16:48:47.000000000 +1100
@@ -214,13 +214,11 @@ static void mddev_put(mddev_t *mddev)
 		return;
 	if (!mddev->raid_disks && list_empty(&mddev->disks)) {
 		list_del(&mddev->all_mddevs);
-		/* that blocks */
+		spin_unlock(&all_mddevs_lock);
 		blk_cleanup_queue(mddev->queue);
-		/* that also blocks */
 		kobject_unregister(&mddev->kobj);
-		/* result blows... */
-	}
-	spin_unlock(&all_mddevs_lock);
+	} else
+		spin_unlock(&all_mddevs_lock);
 }
 
 static mddev_t * mddev_find(dev_t unit)
