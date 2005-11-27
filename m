From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 010 of 18] Move bitmap_create to after md array has been initialised.
Date: Mon, 28 Nov 2005 10:40:27 +1100
Message-ID: <1051127234027.14853@suse.de>
References: <20051128102824.14498.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This is important because bitmap_create uses
  mddev->resync_max_sectors
and that doesn't have a valid value until after the array
has been initialised (with pers->run()).
[It doesn't make a difference for current personalities that 
 support bitmaps, but will make a difference for raid10]

This has the added advantage of meaning with can move the
thread->timeout manipulation inside the bitmap.c code instead
of sprinkling identical code throughout all personalities.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c    |    4 ++++
 ./drivers/md/md.c        |   16 +++++++++-------
 ./drivers/md/raid1.c     |    8 --------
 ./drivers/md/raid5.c     |   11 +----------
 ./drivers/md/raid6main.c |   11 +----------
 5 files changed, 15 insertions(+), 35 deletions(-)

diff ./drivers/md/bitmap.c~current~ ./drivers/md/bitmap.c
--- ./drivers/md/bitmap.c~current~	2005-11-28 10:08:19.000000000 +1100
+++ ./drivers/md/bitmap.c	2005-11-28 10:12:40.000000000 +1100
@@ -1530,6 +1530,8 @@ void bitmap_destroy(mddev_t *mddev)
 		return;
 
 	mddev->bitmap = NULL; /* disconnect from the md device */
+	if (mddev->thread)
+		mddev->thread->timeout = MAX_SCHEDULE_TIMEOUT;
 
 	bitmap_free(bitmap);
 }
@@ -1636,6 +1638,8 @@ int bitmap_create(mddev_t *mddev)
 
 	if (IS_ERR(bitmap->writeback_daemon))
 		return PTR_ERR(bitmap->writeback_daemon);
+	mddev->thread->timeout = bitmap->daemon_sleep * HZ;
+
 	return bitmap_update_sb(bitmap);
 
  error:

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-11-28 10:12:33.000000000 +1100
+++ ./drivers/md/md.c	2005-11-28 10:12:40.000000000 +1100
@@ -2054,13 +2054,15 @@ static int do_md_run(mddev_t * mddev)
 	if (start_readonly)
 		mddev->ro = 2; /* read-only, but switch on first write */
 
-	/* before we start the array running, initialise the bitmap */
-	err = bitmap_create(mddev);
-	if (err)
-		printk(KERN_ERR "%s: failed to create bitmap (%d)\n",
-			mdname(mddev), err);
-	else
-		err = mddev->pers->run(mddev);
+	err = mddev->pers->run(mddev);
+	if (!err && mddev->pers->sync_request) {
+		err = bitmap_create(mddev);
+		if (err) {
+			printk(KERN_ERR "%s: failed to create bitmap (%d)\n",
+			       mdname(mddev), err);
+			mddev->pers->stop(mddev);
+		}
+	}
 	if (err) {
 		printk(KERN_ERR "md: pers->run() failed ...\n");
 		module_put(mddev->pers->owner);

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-11-28 10:12:17.000000000 +1100
+++ ./drivers/md/raid1.c	2005-11-28 10:12:40.000000000 +1100
@@ -1610,7 +1610,6 @@ static int run(mddev_t *mddev)
 		       mdname(mddev));
 		goto out_free_conf;
 	}
-	if (mddev->bitmap) mddev->thread->timeout = mddev->bitmap->daemon_sleep * HZ;
 
 	printk(KERN_INFO 
 		"raid1: raid set %s active with %d out of %d mirrors\n",
@@ -1782,13 +1781,6 @@ static void raid1_quiesce(mddev_t *mddev
 		lower_barrier(conf);
 		break;
 	}
-	if (mddev->thread) {
-		if (mddev->bitmap)
-			mddev->thread->timeout = mddev->bitmap->daemon_sleep * HZ;
-		else
-			mddev->thread->timeout = MAX_SCHEDULE_TIMEOUT;
-		md_wakeup_thread(mddev->thread);
-	}
 }
 
 

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-11-28 10:12:33.000000000 +1100
+++ ./drivers/md/raid5.c	2005-11-28 10:12:40.000000000 +1100
@@ -1963,9 +1963,6 @@ memory = conf->max_nr_stripes * (sizeof(
 	/* Ok, everything is just fine now */
 	sysfs_create_group(&mddev->kobj, &raid5_attrs_group);
 
-	if (mddev->bitmap)
-		mddev->thread->timeout = mddev->bitmap->daemon_sleep * HZ;
-
 	mddev->queue->unplug_fn = raid5_unplug_device;
 	mddev->queue->issue_flush_fn = raid5_issue_flush;
 
@@ -2199,14 +2196,8 @@ static void raid5_quiesce(mddev_t *mddev
 		spin_unlock_irq(&conf->device_lock);
 		break;
 	}
-	if (mddev->thread) {
-		if (mddev->bitmap)
-			mddev->thread->timeout = mddev->bitmap->daemon_sleep * HZ;
-		else
-			mddev->thread->timeout = MAX_SCHEDULE_TIMEOUT;
-		md_wakeup_thread(mddev->thread);
-	}
 }
+
 static mdk_personality_t raid5_personality=
 {
 	.name		= "raid5",

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2005-11-28 10:12:33.000000000 +1100
+++ ./drivers/md/raid6main.c	2005-11-28 10:12:40.000000000 +1100
@@ -1990,9 +1990,6 @@ static int run(mddev_t *mddev)
 	/* Ok, everything is just fine now */
 	mddev->array_size =  mddev->size * (mddev->raid_disks - 2);
 
-	if (mddev->bitmap)
-		mddev->thread->timeout = mddev->bitmap->daemon_sleep * HZ;
-
 	mddev->queue->unplug_fn = raid6_unplug_device;
 	mddev->queue->issue_flush_fn = raid6_issue_flush;
 	return 0;
@@ -2228,14 +2225,8 @@ static void raid6_quiesce(mddev_t *mddev
 		spin_unlock_irq(&conf->device_lock);
 		break;
 	}
-	if (mddev->thread) {
-		if (mddev->bitmap)
-			mddev->thread->timeout = mddev->bitmap->daemon_sleep * HZ;
-		else
-			mddev->thread->timeout = MAX_SCHEDULE_TIMEOUT;
-		md_wakeup_thread(mddev->thread);
-	}
 }
+
 static mdk_personality_t raid6_personality=
 {
 	.name		= "raid6",
