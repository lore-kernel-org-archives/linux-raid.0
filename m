From: Shaohua Li <shli@kernel.org>
Subject: [patch 01/10 v3] raid5: use wake_up_all for overlap waking
Date: Mon, 25 Jun 2012 15:24:48 +0800
Message-ID: <20120625072553.970838108@kernel.org>
References: <20120625072447.268095276@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=raid5-wakeupall.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

It's possible several tasks are waiting for stripe overlap. We clear R5_Overlap
bit and wake_up, but wake_up just wakes one task. So if there are several tasks
in the wait queue, some tasks will not be woken up even its strip R5_Overlap
clear. The end result is tasks hang in make_request.

wake_up_all should not introduce performance issue here, since overlap case is
rare.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2012-06-19 08:11:10.021688417 +0800
+++ linux/drivers/md/raid5.c	2012-06-19 08:11:29.833439339 +0800
@@ -1399,7 +1399,7 @@ static void __raid_run_ops(struct stripe
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
 			if (test_and_clear_bit(R5_Overlap, &dev->flags))
-				wake_up(&sh->raid_conf->wait_for_overlap);
+				wake_up_all(&sh->raid_conf->wait_for_overlap);
 		}
 	put_cpu();
 }
@@ -2436,7 +2436,7 @@ handle_failed_stripe(struct r5conf *conf
 		}
 
 		if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
-			wake_up(&conf->wait_for_overlap);
+			wake_up_all(&conf->wait_for_overlap);
 
 		while (bi && bi->bi_sector <
 			sh->dev[i].sector + STRIPE_SECTORS) {
@@ -2474,7 +2474,7 @@ handle_failed_stripe(struct r5conf *conf
 			bi = sh->dev[i].toread;
 			sh->dev[i].toread = NULL;
 			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
-				wake_up(&conf->wait_for_overlap);
+				wake_up_all(&conf->wait_for_overlap);
 			if (bi) s->to_read--;
 			while (bi && bi->bi_sector <
 			       sh->dev[i].sector + STRIPE_SECTORS) {
@@ -3572,7 +3572,7 @@ static void handle_stripe(struct stripe_
 	} else if (s.expanded && !sh->reconstruct_state && s.locked == 0) {
 		clear_bit(STRIPE_EXPAND_READY, &sh->state);
 		atomic_dec(&conf->reshape_stripes);
-		wake_up(&conf->wait_for_overlap);
+		wake_up_all(&conf->wait_for_overlap);
 		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
 	}
 
@@ -4249,7 +4249,7 @@ static sector_t reshape_request(struct m
 		spin_lock_irq(&conf->device_lock);
 		conf->reshape_safe = mddev->reshape_position;
 		spin_unlock_irq(&conf->device_lock);
-		wake_up(&conf->wait_for_overlap);
+		wake_up_all(&conf->wait_for_overlap);
 		sysfs_notify(&mddev->kobj, NULL, "sync_completed");
 	}
 
@@ -4340,7 +4340,7 @@ static sector_t reshape_request(struct m
 		spin_lock_irq(&conf->device_lock);
 		conf->reshape_safe = mddev->reshape_position;
 		spin_unlock_irq(&conf->device_lock);
-		wake_up(&conf->wait_for_overlap);
+		wake_up_all(&conf->wait_for_overlap);
 		sysfs_notify(&mddev->kobj, NULL, "sync_completed");
 	}
 	return reshape_sectors;
@@ -5718,7 +5718,7 @@ static void end_reshape(struct r5conf *c
 		smp_wmb();
 		conf->reshape_progress = MaxSector;
 		spin_unlock_irq(&conf->device_lock);
-		wake_up(&conf->wait_for_overlap);
+		wake_up_all(&conf->wait_for_overlap);
 
 		/* read-ahead size must cover two whole stripes, which is
 		 * 2 * (datadisks) * chunksize where 'n' is the number of raid devices
@@ -5776,7 +5776,7 @@ static void raid5_quiesce(struct mddev *
 
 	switch(state) {
 	case 2: /* resume for a suspend */
-		wake_up(&conf->wait_for_overlap);
+		wake_up_all(&conf->wait_for_overlap);
 		break;
 
 	case 1: /* stop all writes */
@@ -5792,14 +5792,14 @@ static void raid5_quiesce(struct mddev *
 		conf->quiesce = 1;
 		spin_unlock_irq(&conf->device_lock);
 		/* allow reshape to continue */
-		wake_up(&conf->wait_for_overlap);
+		wake_up_all(&conf->wait_for_overlap);
 		break;
 
 	case 0: /* re-enable writes */
 		spin_lock_irq(&conf->device_lock);
 		conf->quiesce = 0;
 		wake_up(&conf->wait_for_stripe);
-		wake_up(&conf->wait_for_overlap);
+		wake_up_all(&conf->wait_for_overlap);
 		spin_unlock_irq(&conf->device_lock);
 		break;
 	}

