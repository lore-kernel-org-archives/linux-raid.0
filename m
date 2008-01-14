From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 6] md: Fix use-after-free bug when dropping an rdev from an md array.
Date: Mon, 14 Jan 2008 12:45:31 +1100
Message-ID: <1080114014531.20354@suse.de>
References: <20080114123726.19968.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>
List-Id: linux-raid.ids


Due to possible deadlock issues we need to use a schedule work to
kobject_del an 'rdev' object from a different thread.

A recent change means that kobject_add no longer gets a refernce, and
kobject_del doesn't put a reference.  Consequently, we need to
explicitly hold a reference to ensure that the last reference isn't
dropped before the scheduled work get a chance to call kobject_del.

Also, rename delayed_delete to md_delayed_delete to that it is more
obvious in a stack trace which code is to blame.

Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-01-14 12:23:53.000000000 +1100
+++ ./drivers/md/md.c	2008-01-14 12:24:17.000000000 +1100
@@ -1421,10 +1421,11 @@ static int bind_rdev_to_array(mdk_rdev_t
 	return err;
 }
 
-static void delayed_delete(struct work_struct *ws)
+static void md_delayed_delete(struct work_struct *ws)
 {
 	mdk_rdev_t *rdev = container_of(ws, mdk_rdev_t, del_work);
 	kobject_del(&rdev->kobj);
+	kobject_put(&rdev->kobj);
 }
 
 static void unbind_rdev_from_array(mdk_rdev_t * rdev)
@@ -1443,7 +1444,8 @@ static void unbind_rdev_from_array(mdk_r
 	/* We need to delay this, otherwise we can deadlock when
 	 * writing to 'remove' to "dev/state"
 	 */
-	INIT_WORK(&rdev->del_work, delayed_delete);
+	INIT_WORK(&rdev->del_work, md_delayed_delete);
+	kobject_get(&rdev->kobj);
 	schedule_work(&rdev->del_work);
 }
 
@@ -3688,7 +3690,7 @@ static int do_md_stop(mddev_t * mddev, i
 				sysfs_remove_link(&mddev->kobj, nm);
 			}
 
-		/* make sure all delayed_delete calls have finished */
+		/* make sure all md_delayed_delete calls have finished */
 		flush_scheduled_work();
 
 		export_array(mddev);
