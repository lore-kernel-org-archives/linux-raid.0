From: NeilBrown <neilb@suse.de>
Subject: [PATCH 16/18] md: add ->takeover method to support changing the
	personality managing an array
Date: Thu, 12 Feb 2009 14:10:11 +1100
Message-ID: <20090212031011.23983.49110.stgit@notabene.brown>
References: <20090212031009.23983.14496.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090212031009.23983.14496.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Implement this for RAID6 to be able to 'takeover' a RAID5 array.  The
new RAID6 will use a layout which places Q on the last device, and
that device will be missing.
If there are any available spares, one will immediately have Q
recovered onto it.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c            |   92 ++++++++++++++++++++++++++++++++++----
 drivers/md/raid5.c         |  106 +++++++++++++++++++++++++++++++++++++-------
 include/linux/raid/md_k.h  |   10 ++++
 include/linux/raid/raid5.h |    5 ++
 4 files changed, 186 insertions(+), 27 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0e0e1ff..bd003d7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2614,18 +2614,92 @@ level_show(mddev_t *mddev, char *page)
 static ssize_t
 level_store(mddev_t *mddev, const char *buf, size_t len)
 {
+	char level[16];
 	ssize_t rv = len;
-	if (mddev->pers)
+	struct mdk_personality *pers;
+	void *priv;
+
+	if (mddev->pers == NULL) {
+		if (len == 0)
+			return 0;
+		if (len >= sizeof(mddev->clevel))
+			return -ENOSPC;
+		strncpy(mddev->clevel, buf, len);
+		if (mddev->clevel[len-1] == '\n')
+			len--;
+		mddev->clevel[len] = 0;
+		mddev->level = LEVEL_NONE;
+		return rv;
+	}
+
+	/* request to change the personality.  Need to ensure:
+	 *  - array is not engaged in resync/recovery/reshape
+	 *  - old personality can be suspended
+	 *  - new personality will access other array.
+	 */
+
+	if (mddev->sync_thread || mddev->reshape_position != MaxSector)
 		return -EBUSY;
-	if (len == 0)
-		return 0;
-	if (len >= sizeof(mddev->clevel))
-		return -ENOSPC;
-	strncpy(mddev->clevel, buf, len);
-	if (mddev->clevel[len-1] == '\n')
+
+	if (!mddev->pers->quiesce) {
+		printk(KERN_WARNING "md: %s: %s does not support online personality change\n",
+		       mdname(mddev), mddev->pers->name);
+		return -EINVAL;
+	}
+
+	/* Now find the new personality */
+	if (len == 0 || len >= sizeof(level))
+		return -EINVAL;
+	strncpy(level, buf, len);
+	if (level[len-1] == '\n')
 		len--;
-	mddev->clevel[len] = 0;
-	mddev->level = LEVEL_NONE;
+	level[len] = 0;
+
+	request_module("md-%s", level);
+	spin_lock(&pers_lock);
+	pers = find_pers(LEVEL_NONE, level);
+	if (!pers || !try_module_get(pers->owner)) {
+		spin_unlock(&pers_lock);
+		printk(KERN_WARNING "md: personality %s not loaded\n", level);
+		return -EINVAL;
+	}
+	spin_unlock(&pers_lock);
+
+	if (pers == mddev->pers) {
+		/* Nothing to do! */
+		module_put(pers->owner);
+		return rv;
+	}
+	if (!pers->takeover) {
+		module_put(pers->owner);
+		printk(KERN_WARNING "md: %s: %s does not support personality takeover\n",
+		       mdname(mddev), level);
+		return -EINVAL;
+	}
+
+	priv = pers->takeover(mddev);
+	if (IS_ERR(priv)) {
+		module_put(pers->owner);
+		printk(KERN_WARNING "md: %s: %s would not accept array\n",
+		       mdname(mddev), level);
+		return PTR_ERR(priv);
+	}
+
+	/* Looks like we have a winner */
+	mddev_suspend(mddev);
+	mddev->pers->stop(mddev);
+	module_put(mddev->pers->owner);
+	mddev->pers = pers;
+	mddev->private = priv;
+	strlcpy(mddev->clevel, pers->name, sizeof(mddev->clevel));
+	mddev->level = pers->level;
+	mddev->new_level = pers->level;
+	mddev->new_layout = mddev->layout;
+	mddev->new_chunk = mddev->chunk_size;
+	pers->run(mddev);
+	mddev_resume(mddev);
+	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	md_wakeup_thread(mddev->thread);
 	return rv;
 }
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 6c33add..89ce65d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -912,8 +912,10 @@ static int grow_stripes(raid5_conf_t *conf, int num)
 	struct kmem_cache *sc;
 	int devs = conf->raid_disks;
 
-	sprintf(conf->cache_name[0], "raid5-%s", mdname(conf->mddev));
-	sprintf(conf->cache_name[1], "raid5-%s-alt", mdname(conf->mddev));
+	sprintf(conf->cache_name[0],
+		"raid%d-%s", conf->level, mdname(conf->mddev));
+	sprintf(conf->cache_name[1],
+		"raid%d-%s-alt", conf->level, mdname(conf->mddev));
 	conf->active_name = 0;
 	sc = kmem_cache_create(conf->cache_name[conf->active_name],
 			       sizeof(struct stripe_head)+(devs-1)*sizeof(struct r5dev),
@@ -4149,22 +4151,22 @@ static struct attribute_group raid5_attrs_group = {
 	.attrs = raid5_attrs,
 };
 
-static raid5_conf_t *setup_conf(mddev_t *mddev)
+static raid5_conf_t *setup_conf(mddev_t *mddev, int raid_disks, int level, int layout)
 {
 	raid5_conf_t *conf;
 	int raid_disk, memory;
 	mdk_rdev_t *rdev;
 	struct disk_info *disk;
 
-	if (mddev->level != 5 && mddev->level != 4 && mddev->level != 6) {
+	if (level != 5 && level != 4 && level != 6) {
 		printk(KERN_ERR "raid5: %s: raid level not set to 4/5/6 (%d)\n",
-		       mdname(mddev), mddev->level);
+		       mdname(mddev), level);
 		return ERR_PTR(-EIO);
 	}
-	if ((mddev->level == 5 && !algorithm_valid_raid5(mddev->layout)) ||
-	    (mddev->level == 6 && !algorithm_valid_raid6(mddev->layout))) {
+	if ((level == 5 && !algorithm_valid_raid5(layout)) ||
+	    (level == 6 && !algorithm_valid_raid6(layout))) {
 		printk(KERN_ERR "raid5: %s: layout %d not supported\n",
-		       mdname(mddev), mddev->layout);
+		       mdname(mddev), layout);
 		return ERR_PTR(-EIO);
 	}
 
@@ -4180,10 +4182,10 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
 		goto abort;
 
 	if (mddev->reshape_position == MaxSector) {
-		conf->previous_raid_disks = conf->raid_disks = mddev->raid_disks;
+		conf->previous_raid_disks = conf->raid_disks = raid_disks;
 	} else {
-		conf->raid_disks = mddev->raid_disks;
-		conf->previous_raid_disks = mddev->raid_disks - mddev->delta_disks;
+		conf->raid_disks = raid_disks;
+		conf->previous_raid_disks = raid_disks - mddev->delta_disks;
 	}
 
 	conf->disks = kzalloc(conf->raid_disks * sizeof(struct disk_info),
@@ -4196,7 +4198,7 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
 	if ((conf->stripe_hashtbl = kzalloc(PAGE_SIZE, GFP_KERNEL)) == NULL)
 		goto abort;
 
-	if (mddev->level == 6) {
+	if (level == 6) {
 		conf->spare_page = alloc_page(GFP_KERNEL);
 		if (!conf->spare_page)
 			goto abort;
@@ -4236,12 +4238,12 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
 	}
 
 	conf->chunk_size = mddev->chunk_size;
-	conf->level = mddev->level;
+	conf->level = level;
 	if (conf->level == 6)
 		conf->max_degraded = 2;
 	else
 		conf->max_degraded = 1;
-	conf->algorithm = mddev->layout;
+	conf->algorithm = layout;
 	conf->max_nr_stripes = NR_STRIPES;
 	conf->expand_progress = mddev->reshape_position;
 
@@ -4327,10 +4329,14 @@ static int run(mddev_t *mddev)
 		/* OK, we should be able to continue; */
 	}
 
-	conf = setup_conf(mddev);
+	if (mddev->private == NULL)
+		conf = setup_conf(mddev, mddev->raid_disks, mddev->level, mddev->layout);
+	else {
+		conf = mddev->private;
+		mddev->raid_disks = conf->raid_disks;
+		mddev->layout = conf->algorithm;
+	}
 
-	if (conf == NULL)
-		return -EIO;
 	if (IS_ERR(conf))
 		return PTR_ERR(conf);
 
@@ -4383,7 +4389,11 @@ static int run(mddev_t *mddev)
 		}
 	}
 
-	mddev->thread = md_register_thread(raid5d, mddev, "%s_raid5");
+	if (conf->thread) {
+		mddev->thread = conf->thread;
+		conf->thread = NULL;
+	} else
+		mddev->thread = md_register_thread(raid5d, mddev, "%s_raid5");
 	if (!mddev->thread) {
 		printk(KERN_ERR 
 		       "raid5: couldn't allocate thread for %s\n",
@@ -4859,6 +4869,65 @@ static void raid5_quiesce(mddev_t *mddev, int state)
 	}
 }
 
+static struct mdk_personality raid5_personality;
+
+static void *raid6_takeover(mddev_t *mddev)
+{
+	/* Currently can only take over a raid5.  We map the
+	 * personality to an equivalent raid6 personality
+	 * with the Q block at the end.
+	 */
+	int new_layout;
+	raid5_conf_t *conf;
+
+	if (mddev->pers != &raid5_personality)
+		return ERR_PTR(-EINVAL);
+	if (mddev->degraded > 1)
+		return ERR_PTR(-EINVAL);
+	if (mddev->raid_disks > 253)
+		return ERR_PTR(-EINVAL);
+	if (mddev->raid_disks < 3)
+		return ERR_PTR(-EINVAL);
+
+	switch(mddev->layout) {
+	case ALGORITHM_LEFT_ASYMMETRIC:
+		new_layout = ALGORITHM_LEFT_ASYMMETRIC_6;
+		break;
+	case ALGORITHM_RIGHT_ASYMMETRIC:
+		new_layout = ALGORITHM_RIGHT_ASYMMETRIC_6;
+		break;
+	case ALGORITHM_LEFT_SYMMETRIC:
+		new_layout = ALGORITHM_LEFT_SYMMETRIC_6;
+		break;
+	case ALGORITHM_RIGHT_SYMMETRIC:
+		new_layout = ALGORITHM_RIGHT_SYMMETRIC_6;
+		break;
+	case ALGORITHM_PARITY_0:
+		new_layout = ALGORITHM_PARITY_0_6;
+		break;
+	case ALGORITHM_PARITY_N:
+		new_layout = ALGORITHM_PARITY_N;
+		break;
+	default:
+		return ERR_PTR(-EINVAL);
+	}
+	conf = setup_conf(mddev, mddev->raid_disks + 1, 6, new_layout);
+	if (IS_ERR(conf))
+		return conf;
+
+	conf->thread = md_register_thread(raid5d, mddev, "%s_raid5");
+	if (conf->thread)
+		return conf;
+
+	safe_put_page(conf->spare_page);
+	kfree(conf->disks);
+	kfree(conf->stripe_hashtbl);
+	kfree(conf);
+
+	return ERR_PTR(-ENOMEM);
+}
+
+
 static struct mdk_personality raid6_personality =
 {
 	.name		= "raid6",
@@ -4879,6 +4948,7 @@ static struct mdk_personality raid6_personality =
 	.start_reshape  = raid5_start_reshape,
 #endif
 	.quiesce	= raid5_quiesce,
+	.takeover	= raid6_takeover,
 };
 static struct mdk_personality raid5_personality =
 {
diff --git a/include/linux/raid/md_k.h b/include/linux/raid/md_k.h
index a815bab..3755045 100644
--- a/include/linux/raid/md_k.h
+++ b/include/linux/raid/md_k.h
@@ -334,6 +334,16 @@ struct mdk_personality
 	 * others - reserved
 	 */
 	void (*quiesce) (mddev_t *mddev, int state);
+	/* takeover is used to transition an array from one
+	 * personality to another.  The new personality must be able
+	 * to handle the data in the current layout.
+	 * e.g. 2drive raid1 -> 2drive raid5
+	 *      ndrive raid5 -> degraded n+1drive raid6 with special layout
+	 * If the takeover succeeds, a new 'private' structure is returned.
+	 * This needs to be installed and then ->quiesce used to activate the
+	 * array.
+	 */
+	void *(*takeover) (mddev_t *mddev);
 };
 
 
diff --git a/include/linux/raid/raid5.h b/include/linux/raid/raid5.h
index 3adda05..4894cd5 100644
--- a/include/linux/raid/raid5.h
+++ b/include/linux/raid/raid5.h
@@ -387,6 +387,11 @@ struct raid5_private_data {
 	int			pool_size; /* number of disks in stripeheads in pool */
 	spinlock_t		device_lock;
 	struct disk_info	*disks;
+
+	/* When taking over an array from a different personality, we store
+	 * the new thread here until we fully activate the array.
+	 */
+	struct mdk_thread_s		*thread;
 };
 
 typedef struct raid5_private_data raid5_conf_t;


