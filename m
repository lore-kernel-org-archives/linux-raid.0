From: NeilBrown <neilb@suse.de>
Subject: [PATCH 003 of 12] md: Delay starting md threads until array is completely setup.
Date: Tue, 27 Jun 2006 17:05:20 +1000
Message-ID: <1060627070520.25986@suse.de>
References: <20060627170010.25835.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


When an array is started we start one or two threads (two if
there is a reshape or recovery that needs to be completed).

We currently start these *before* the array is completely set up and
in particular before queue->queuedata is set.  If the thread
actually starts very quickly on another CPU, we can end up
dereferencing queue->queuedata and oops.

This patch also makes sure we don't try to start a recovery if
a reshape is being restarted.

### Diffstat output
 ./drivers/md/md.c    |   10 +++++-----
 ./drivers/md/raid5.c |    3 ---
 2 files changed, 5 insertions(+), 8 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2006-06-27 12:17:32.000000000 +1000
+++ ./drivers/md/md.c	2006-06-27 12:17:32.000000000 +1000
@@ -3100,8 +3100,7 @@ static int do_md_run(mddev_t * mddev)
 		}
 	
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-	md_wakeup_thread(mddev->thread);
	
+
 	if (mddev->sb_dirty)
 		md_update_sb(mddev);
 
@@ -3121,7 +3120,7 @@ static int do_md_run(mddev_t * mddev)
 	 * start recovery here.  If we leave it to md_check_recovery,
 	 * it will remove the drives and not do the right thing
 	 */
-	if (mddev->degraded) {
+	if (mddev->degraded && !mddev->sync_thread) {
 		struct list_head *rtmp;
 		int spares = 0;
 		ITERATE_RDEV(mddev,rdev,rtmp)
@@ -3142,10 +3141,11 @@ static int do_md_run(mddev_t * mddev)
 				       mdname(mddev));
 				/* leave the spares where they are, it shouldn't hurt */
 				mddev->recovery = 0;
-			} else
-				md_wakeup_thread(mddev->sync_thread);
+			}
 		}
 	}
+	md_wakeup_thread(mddev->thread);
+	md_wakeup_thread(mddev->sync_thread); /* possibly kick off a reshape */
 
 	mddev->changed = 1;
 	md_new_event(mddev);

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2006-06-27 12:16:41.000000000 +1000
+++ ./drivers/md/raid5.c	2006-06-27 12:17:32.000000000 +1000
@@ -3248,9 +3248,6 @@ static int run(mddev_t *mddev)
 		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
 		mddev->sync_thread = md_register_thread(md_do_sync, mddev,
 							"%s_reshape");
-		/* FIXME if md_register_thread fails?? */
-		md_wakeup_thread(mddev->sync_thread);
-
 	}
 
 	/* read-ahead size must cover two whole stripes, which is
