From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 018 of 18] Fix up some rdev rcu locking in raid5/6
Date: Mon, 28 Nov 2005 10:41:09 +1100
Message-ID: <1051127234109.14949@suse.de>
References: <20051128102824.14498.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


There is this "FIXME" comment with a typo in it!! that been annoying
me for days, so I just had to remove it.

conf->disks[i].rdev should only be accessed if
  - we know we hold a reference or
  - the mddev->reconfig_sem is down or
  - we have a rcu_readlock

handle_stripe was referencing rdev in three places without any of these.
For the first two, get an rcu_readlock.
For the last, the same access (md_sync_acct call) is made a little later
after the rdev has been claimed under and rcu_readlock, if R5_Syncio is set.
So just use that access...  However R5_Syncio isn't really needed as the
'syncing' variable contains the same information. So use that instead.

Issues, comment, and fix are identical in raid5 and raid6.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c         |   16 ++++++++--------
 ./drivers/md/raid6main.c     |   19 ++++++++-----------
 ./include/linux/raid/raid5.h |    1 -
 3 files changed, 16 insertions(+), 20 deletions(-)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-11-28 10:12:40.000000000 +1100
+++ ./drivers/md/raid5.c	2005-11-28 10:13:37.000000000 +1100
@@ -960,11 +960,11 @@ static void handle_stripe(struct stripe_
 	syncing = test_bit(STRIPE_SYNCING, &sh->state);
 	/* Now to look around and see what can be done */
 
+	rcu_read_lock();
 	for (i=disks; i--; ) {
 		mdk_rdev_t *rdev;
 		dev = &sh->dev[i];
 		clear_bit(R5_Insync, &dev->flags);
-		clear_bit(R5_Syncio, &dev->flags);
 
 		PRINTK("check %d: state 0x%lx read %p write %p written %p\n",
 			i, dev->flags, dev->toread, dev->towrite, dev->written);
@@ -1003,7 +1003,7 @@ static void handle_stripe(struct stripe_
 				non_overwrite++;
 		}
 		if (dev->written) written++;
-		rdev = conf->disks[i].rdev; /* FIXME, should I be looking rdev */
+		rdev = rcu_dereference(conf->disks[i].rdev);
 		if (!rdev || !test_bit(In_sync, &rdev->flags)) {
 			/* The ReadError flag will just be confusing now */
 			clear_bit(R5_ReadError, &dev->flags);
@@ -1016,6 +1016,7 @@ static void handle_stripe(struct stripe_
 		} else
 			set_bit(R5_Insync, &dev->flags);
 	}
+	rcu_read_unlock();
 	PRINTK("locked=%d uptodate=%d to_read=%d"
 		" to_write=%d failed=%d failed_num=%d\n",
 		locked, uptodate, to_read, to_write, failed, failed_num);
@@ -1027,10 +1028,13 @@ static void handle_stripe(struct stripe_
 			int bitmap_end = 0;
 
 			if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
-				mdk_rdev_t *rdev = conf->disks[i].rdev;
+				mdk_rdev_t *rdev;
+				rcu_read_lock();
+				rdev = rcu_dereference(conf->disks[i].rdev);
 				if (rdev && test_bit(In_sync, &rdev->flags))
 					/* multiple read failures in one stripe */
 					md_error(conf->mddev, rdev);
+				rcu_read_unlock();
 			}
 
 			spin_lock_irq(&conf->device_lock);
@@ -1179,9 +1183,6 @@ static void handle_stripe(struct stripe_
 					locked++;
 					PRINTK("Reading block %d (sync=%d)\n", 
 						i, syncing);
-					if (syncing)
-						md_sync_acct(conf->disks[i].rdev->bdev,
-							     STRIPE_SECTORS);
 				}
 			}
 		}
@@ -1325,7 +1326,6 @@ static void handle_stripe(struct stripe_
 			clear_bit(STRIPE_DEGRADED, &sh->state);
 			locked++;
 			set_bit(STRIPE_INSYNC, &sh->state);
-			set_bit(R5_Syncio, &dev->flags);
 		}
 	}
 	if (syncing && locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
@@ -1391,7 +1391,7 @@ static void handle_stripe(struct stripe_
 		rcu_read_unlock();
  
 		if (rdev) {
-			if (test_bit(R5_Syncio, &sh->dev[i].flags))
+			if (syncing)
 				md_sync_acct(rdev->bdev, STRIPE_SECTORS);
 
 			bi->bi_bdev = rdev->bdev;

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2005-11-28 10:12:59.000000000 +1100
+++ ./drivers/md/raid6main.c	2005-11-28 10:13:37.000000000 +1100
@@ -1060,11 +1060,11 @@ static void handle_stripe(struct stripe_
 	syncing = test_bit(STRIPE_SYNCING, &sh->state);
 	/* Now to look around and see what can be done */
 
+	rcu_read_lock();
 	for (i=disks; i--; ) {
 		mdk_rdev_t *rdev;
 		dev = &sh->dev[i];
 		clear_bit(R5_Insync, &dev->flags);
-		clear_bit(R5_Syncio, &dev->flags);
 
 		PRINTK("check %d: state 0x%lx read %p write %p written %p\n",
 			i, dev->flags, dev->toread, dev->towrite, dev->written);
@@ -1103,7 +1103,7 @@ static void handle_stripe(struct stripe_
 				non_overwrite++;
 		}
 		if (dev->written) written++;
-		rdev = conf->disks[i].rdev; /* FIXME, should I be looking rdev */
+		rdev = rcu_dereference(conf->disks[i].rdev);
 		if (!rdev || !test_bit(In_sync, &rdev->flags)) {
 			/* The ReadError flag will just be confusing now */
 			clear_bit(R5_ReadError, &dev->flags);
@@ -1117,6 +1117,7 @@ static void handle_stripe(struct stripe_
 		} else
 			set_bit(R5_Insync, &dev->flags);
 	}
+	rcu_read_unlock();
 	PRINTK("locked=%d uptodate=%d to_read=%d"
 	       " to_write=%d failed=%d failed_num=%d,%d\n",
 	       locked, uptodate, to_read, to_write, failed,
@@ -1129,10 +1130,13 @@ static void handle_stripe(struct stripe_
 			int bitmap_end = 0;
 
 			if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
-				mdk_rdev_t *rdev = conf->disks[i].rdev;
+				mdk_rdev_t *rdev;
+				rcu_read_lock();
+				rdev = rcu_dereference(conf->disks[i].rdev);
 				if (rdev && test_bit(In_sync, &rdev->flags))
 					/* multiple read failures in one stripe */
 					md_error(conf->mddev, rdev);
+				rcu_read_unlock();
 			}
 
 			spin_lock_irq(&conf->device_lock);
@@ -1307,9 +1311,6 @@ static void handle_stripe(struct stripe_
 					locked++;
 					PRINTK("Reading block %d (sync=%d)\n",
 						i, syncing);
-					if (syncing)
-						md_sync_acct(conf->disks[i].rdev->bdev,
-							     STRIPE_SECTORS);
 				}
 			}
 		}
@@ -1463,14 +1464,12 @@ static void handle_stripe(struct stripe_
 				locked++;
 				set_bit(R5_LOCKED, &dev->flags);
 				set_bit(R5_Wantwrite, &dev->flags);
-				set_bit(R5_Syncio, &dev->flags);
 			}
 			if (failed >= 1) {
 				dev = &sh->dev[failed_num[0]];
 				locked++;
 				set_bit(R5_LOCKED, &dev->flags);
 				set_bit(R5_Wantwrite, &dev->flags);
-				set_bit(R5_Syncio, &dev->flags);
 			}
 
 			if (update_p) {
@@ -1478,14 +1477,12 @@ static void handle_stripe(struct stripe_
 				locked ++;
 				set_bit(R5_LOCKED, &dev->flags);
 				set_bit(R5_Wantwrite, &dev->flags);
-				set_bit(R5_Syncio, &dev->flags);
 			}
 			if (update_q) {
 				dev = &sh->dev[qd_idx];
 				locked++;
 				set_bit(R5_LOCKED, &dev->flags);
 				set_bit(R5_Wantwrite, &dev->flags);
-				set_bit(R5_Syncio, &dev->flags);
 			}
 			clear_bit(STRIPE_DEGRADED, &sh->state);
 
@@ -1557,7 +1554,7 @@ static void handle_stripe(struct stripe_
 		rcu_read_unlock();
 
 		if (rdev) {
-			if (test_bit(R5_Syncio, &sh->dev[i].flags))
+			if (syncing)
 				md_sync_acct(rdev->bdev, STRIPE_SECTORS);
 
 			bi->bi_bdev = rdev->bdev;

diff ./include/linux/raid/raid5.h~current~ ./include/linux/raid/raid5.h
--- ./include/linux/raid/raid5.h~current~	2005-11-28 10:12:56.000000000 +1100
+++ ./include/linux/raid/raid5.h	2005-11-28 10:13:37.000000000 +1100
@@ -152,7 +152,6 @@ struct stripe_head {
 #define	R5_Insync	3	/* rdev && rdev->in_sync at start */
 #define	R5_Wantread	4	/* want to schedule a read */
 #define	R5_Wantwrite	5
-#define	R5_Syncio	6	/* this io need to be accounted as resync io */
 #define	R5_Overlap	7	/* There is a pending overlapping request on this block */
 #define	R5_ReadError	8	/* seen a read error here recently */
 #define	R5_ReWrite	9	/* have tried to over-write the readerror */
