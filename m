From: NeilBrown <neilb@suse.de>
Subject: [PATCH 004 of 9] md: Tidy up device-change notification when an md array is stopped
Date: Wed, 8 Nov 2006 09:09:41 +1100
Message-ID: <1061107220941.12521@suse.de>
References: <20061108085917.12064.patches@notabene>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753687AbWKGWLc@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


An md array can be stopped leaving all the setting still in place,
or it can torn down and destroyed.
set_capacity and other change notifications only happen in the latter
case, but should happen in both.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2006-11-06 11:29:00.000000000 +1100
+++ ./drivers/md/md.c	2006-11-06 11:29:12.000000000 +1100
@@ -3314,6 +3314,10 @@ static int do_md_stop(mddev_t * mddev, i
 
 			module_put(mddev->pers->owner);
 			mddev->pers = NULL;
+
+			set_capacity(disk, 0);
+			mddev->changed = 1;
+
 			if (mddev->ro)
 				mddev->ro = 0;
 		}
@@ -3333,7 +3337,7 @@ static int do_md_stop(mddev_t * mddev, i
 	if (mode == 0) {
 		mdk_rdev_t *rdev;
 		struct list_head *tmp;
-		struct gendisk *disk;
+
 		printk(KERN_INFO "md: %s stopped.\n", mdname(mddev));
 
 		bitmap_destroy(mddev);
@@ -3358,10 +3362,6 @@ static int do_md_stop(mddev_t * mddev, i
 		mddev->raid_disks = 0;
 		mddev->recovery_cp = 0;
 
-		disk = mddev->gendisk;
-		if (disk)
-			set_capacity(disk, 0);
-		mddev->changed = 1;
 	} else if (mddev->pers)
 		printk(KERN_INFO "md: %s switched to read-only mode.\n",
 			mdname(mddev));
