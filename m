From: NeilBrown <neilb@suse.de>
Subject: [PATCH 13/18] md/raid5: refactor raid5 "run"
Date: Thu, 12 Feb 2009 14:10:11 +1100
Message-ID: <20090212031011.23983.99838.stgit@notabene.brown>
References: <20090212031009.23983.14496.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090212031009.23983.14496.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

.. so that the code to create the private data structures is separate.
This will help with future code to change the level of an active
array.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |  207 ++++++++++++++++++++++++++++++----------------------
 1 files changed, 119 insertions(+), 88 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f1dbfc4..ee42d1a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4149,89 +4149,36 @@ static struct attribute_group raid5_attrs_group = {
 	.attrs = raid5_attrs,
 };
 
-static int run(mddev_t *mddev)
+static raid5_conf_t *setup_conf(mddev_t *mddev)
 {
 	raid5_conf_t *conf;
 	int raid_disk, memory;
 	mdk_rdev_t *rdev;
 	struct disk_info *disk;
-	int working_disks = 0;
 
 	if (mddev->level != 5 && mddev->level != 4 && mddev->level != 6) {
 		printk(KERN_ERR "raid5: %s: raid level not set to 4/5/6 (%d)\n",
 		       mdname(mddev), mddev->level);
-		return -EIO;
+		return ERR_PTR(-EIO);
 	}
 	if ((mddev->level == 5 && !algorithm_valid_raid5(mddev->layout)) ||
 	    (mddev->level == 6 && !algorithm_valid_raid6(mddev->layout))) {
 		printk(KERN_ERR "raid5: %s: layout %d not supported\n",
 		       mdname(mddev), mddev->layout);
-		return -EIO;
+		return ERR_PTR(-EIO);
 	}
 
 	if (mddev->chunk_size < PAGE_SIZE) {
 		printk(KERN_ERR "md/raid5: chunk_size must be at least "
 		       "PAGE_SIZE but %d < %ld\n",
 		       mddev->chunk_size, PAGE_SIZE);
-		return -EINVAL;
-	}
-
-	if (mddev->reshape_position != MaxSector) {
-		/* Check that we can continue the reshape.
-		 * Currently only disks can change, it must
-		 * increase, and we must be past the point where
-		 * a stripe over-writes itself
-		 */
-		sector_t here_new, here_old;
-		int old_disks;
-		int max_degraded = (mddev->level == 5 ? 1 : 2);
-
-		if (mddev->new_level != mddev->level ||
-		    mddev->new_layout != mddev->layout ||
-		    mddev->new_chunk != mddev->chunk_size) {
-			printk(KERN_ERR "raid5: %s: unsupported reshape "
-			       "required - aborting.\n",
-			       mdname(mddev));
-			return -EINVAL;
-		}
-		if (mddev->delta_disks <= 0) {
-			printk(KERN_ERR "raid5: %s: unsupported reshape "
-			       "(reduce disks) required - aborting.\n",
-			       mdname(mddev));
-			return -EINVAL;
-		}
-		old_disks = mddev->raid_disks - mddev->delta_disks;
-		/* reshape_position must be on a new-stripe boundary, and one
-		 * further up in new geometry must map after here in old
-		 * geometry.
-		 */
-		here_new = mddev->reshape_position;
-		if (sector_div(here_new, (mddev->chunk_size>>9)*
-			       (mddev->raid_disks - max_degraded))) {
-			printk(KERN_ERR "raid5: reshape_position not "
-			       "on a stripe boundary\n");
-			return -EINVAL;
-		}
-		/* here_new is the stripe we will write to */
-		here_old = mddev->reshape_position;
-		sector_div(here_old, (mddev->chunk_size>>9)*
-			   (old_disks-max_degraded));
-		/* here_old is the first stripe that we might need to read
-		 * from */
-		if (here_new >= here_old) {
-			/* Reading from the same stripe as writing to - bad */
-			printk(KERN_ERR "raid5: reshape_position too early for "
-			       "auto-recovery - aborting.\n");
-			return -EINVAL;
-		}
-		printk(KERN_INFO "raid5: reshape will continue\n");
-		/* OK, we should be able to continue; */
+		return ERR_PTR(-EINVAL);
 	}
 
-
-	mddev->private = kzalloc(sizeof (raid5_conf_t), GFP_KERNEL);
-	if ((conf = mddev->private) == NULL)
+	conf = kzalloc(sizeof (raid5_conf_t), GFP_KERNEL);
+	if (conf == NULL)
 		goto abort;
+
 	if (mddev->reshape_position == MaxSector) {
 		conf->previous_raid_disks = conf->raid_disks = mddev->raid_disks;
 	} else {
@@ -4255,7 +4202,6 @@ static int run(mddev_t *mddev)
 			goto abort;
 	}
 	spin_lock_init(&conf->device_lock);
-	mddev->queue->queue_lock = &conf->device_lock;
 	init_waitqueue_head(&conf->wait_for_stripe);
 	init_waitqueue_head(&conf->wait_for_overlap);
 	INIT_LIST_HEAD(&conf->handle_list);
@@ -4284,17 +4230,11 @@ static int run(mddev_t *mddev)
 			printk(KERN_INFO "raid5: device %s operational as raid"
 				" disk %d\n", bdevname(rdev->bdev,b),
 				raid_disk);
-			working_disks++;
 		} else
 			/* Cannot rely on bitmap to complete recovery */
 			conf->fullsync = 1;
 	}
 
-	/*
-	 * 0 for a fully functional array, 1 or 2 for a degraded array.
-	 */
-	mddev->degraded = conf->raid_disks - working_disks;
-	conf->mddev = mddev;
 	conf->chunk_size = mddev->chunk_size;
 	conf->level = mddev->level;
 	if (conf->level == 6)
@@ -4305,9 +4245,94 @@ static int run(mddev_t *mddev)
 	conf->max_nr_stripes = NR_STRIPES;
 	conf->expand_progress = mddev->reshape_position;
 
-	/* device size must be a multiple of chunk size */
-	mddev->dev_sectors &= ~(mddev->chunk_size / 512 - 1);
-	mddev->resync_max_sectors = mddev->dev_sectors;
+	memory = conf->max_nr_stripes * (sizeof(struct stripe_head) +
+		 conf->raid_disks * ((sizeof(struct bio) + PAGE_SIZE))) / 1024;
+	if (grow_stripes(conf, conf->max_nr_stripes)) {
+		printk(KERN_ERR 
+			"raid5: couldn't allocate %dkB for buffers\n", memory);
+		shrink_stripes(conf);
+		goto abort;
+	} else
+		printk(KERN_INFO "raid5: allocated %dkB for %s\n",
+			memory, mdname(mddev));
+
+	return conf;
+
+ abort:
+	if (conf) {
+		safe_put_page(conf->spare_page);
+		kfree(conf->disks);
+		kfree(conf->stripe_hashtbl);
+		kfree(conf);
+		return ERR_PTR(-EIO);
+	} else
+		return ERR_PTR(-ENOMEM);
+}
+
+static int run(mddev_t *mddev)
+{
+	raid5_conf_t *conf;
+	int working_disks = 0;
+	mdk_rdev_t *rdev;
+
+	if (mddev->reshape_position != MaxSector) {
+		/* Check that we can continue the reshape.
+		 * Currently only disks can change, it must
+		 * increase, and we must be past the point where
+		 * a stripe over-writes itself
+		 */
+		sector_t here_new, here_old;
+		int old_disks;
+		int max_degraded = (mddev->level == 5 ? 1 : 2);
+
+		if (mddev->new_level != mddev->level ||
+		    mddev->new_layout != mddev->layout ||
+		    mddev->new_chunk != mddev->chunk_size) {
+			printk(KERN_ERR "raid5: %s: unsupported reshape "
+			       "required - aborting.\n",
+			       mdname(mddev));
+			return -EINVAL;
+		}
+		if (mddev->delta_disks <= 0) {
+			printk(KERN_ERR "raid5: %s: unsupported reshape "
+			       "(reduce disks) required - aborting.\n",
+			       mdname(mddev));
+			return -EINVAL;
+		}
+		old_disks = mddev->raid_disks - mddev->delta_disks;
+		/* reshape_position must be on a new-stripe boundary, and one
+		 * further up in new geometry must map after here in old
+		 * geometry.
+		 */
+		here_new = mddev->reshape_position;
+		if (sector_div(here_new, (mddev->chunk_size>>9)*
+			       (mddev->raid_disks - max_degraded))) {
+			printk(KERN_ERR "raid5: reshape_position not "
+			       "on a stripe boundary\n");
+			return -EINVAL;
+		}
+		/* here_new is the stripe we will write to */
+		here_old = mddev->reshape_position;
+		sector_div(here_old, (mddev->chunk_size>>9)*
+			   (old_disks-max_degraded));
+		/* here_old is the first stripe that we might need to read
+		 * from */
+		if (here_new >= here_old) {
+			/* Reading from the same stripe as writing to - bad */
+			printk(KERN_ERR "raid5: reshape_position too early for "
+			       "auto-recovery - aborting.\n");
+			return -EINVAL;
+		}
+		printk(KERN_INFO "raid5: reshape will continue\n");
+		/* OK, we should be able to continue; */
+	}
+
+	conf = setup_conf(mddev);
+
+	if (conf == NULL)
+		return -EIO;
+	if (IS_ERR(conf))
+		return PTR_ERR(conf);
 
 	if (conf->level == 6 && conf->raid_disks < 4) {
 		printk(KERN_ERR "raid6: not enough configured devices for %s (%d, minimum 4)\n",
@@ -4326,6 +4351,23 @@ static int run(mddev_t *mddev)
 		goto abort;
 	}
 
+	mddev->private = conf;
+	mddev->queue->queue_lock = &conf->device_lock;
+
+	/*
+	 * 0 for a fully functional array, 1 or 2 for a degraded array.
+	 */
+	list_for_each_entry(rdev, &mddev->disks, same_set)
+		if (rdev->raid_disk >= 0 &&
+		    test_bit(In_sync, &rdev->flags))
+			working_disks++;
+
+	mddev->degraded = conf->raid_disks - working_disks;
+
+	/* device size must be a multiple of chunk size */
+	mddev->dev_sectors &= ~(mddev->chunk_size / 512 - 1);
+	mddev->resync_max_sectors = mddev->dev_sectors;
+
 	if (mddev->degraded > 0 &&
 	    mddev->recovery_cp != MaxSector) {
 		if (mddev->ok_start_degraded)
@@ -4341,26 +4383,13 @@ static int run(mddev_t *mddev)
 		}
 	}
 
-	{
-		mddev->thread = md_register_thread(raid5d, mddev, "%s_raid5");
-		if (!mddev->thread) {
-			printk(KERN_ERR 
-				"raid5: couldn't allocate thread for %s\n",
-				mdname(mddev));
-			goto abort;
-		}
-	}
-	memory = conf->max_nr_stripes * (sizeof(struct stripe_head) +
-		 conf->raid_disks * ((sizeof(struct bio) + PAGE_SIZE))) / 1024;
-	if (grow_stripes(conf, conf->max_nr_stripes)) {
+	mddev->thread = md_register_thread(raid5d, mddev, "%s_raid5");
+	if (!mddev->thread) {
 		printk(KERN_ERR 
-			"raid5: couldn't allocate %dkB for buffers\n", memory);
-		shrink_stripes(conf);
-		md_unregister_thread(mddev->thread);
+		       "raid5: couldn't allocate thread for %s\n",
+		       mdname(mddev));
 		goto abort;
-	} else
-		printk(KERN_INFO "raid5: allocated %dkB for %s\n",
-			memory, mdname(mddev));
+	}
 
 	if (mddev->degraded == 0)
 		printk("raid5: raid level %d set %s active with %d out of %d"
@@ -4422,6 +4451,8 @@ abort:
 		kfree(conf->stripe_hashtbl);
 		kfree(conf);
 	}
+	if (mddev->thread)
+		md_unregister_thread(mddev->thread);
 	mddev->private = NULL;
 	printk(KERN_ALERT "raid5: failed to run raid set %s\n", mdname(mddev));
 	return -EIO;


