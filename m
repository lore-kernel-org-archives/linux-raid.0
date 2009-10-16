From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 09/11] md: Fix handling of raid5 array which is being
	reshaped to fewer devices.
Date: Fri, 16 Oct 2009 16:49:19 +1100
Message-ID: <20091016054919.24208.1181.stgit@notabene.brown>
References: <20091016054316.24208.33818.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091016054316.24208.33818.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

When a raid5 (or raid6) array is being reshaped to have fewer devices,
conf->raid_disks is the latter and hence smaller number of devices.
However sometimes we want to use a number which is the total number of
currently required devices - the larger of the 'old' and 'new' sizes.
Before we implemented reducing the number of devices, this was always
'new' i.e. ->raid_disks.
Now we need max(raid_disks, previous_raid_disks) in those places.

This particularly affects assembling an array that was shutdown while
in the middle of a reshape to fewer devices.

md.c needs a similar fix when interpreting the md metadata.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c    |    2 +-
 drivers/md/raid5.c |   37 ++++++++++++++++++-------------------
 2 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 26ba42a..10eb1fc 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2631,7 +2631,7 @@ static void analyze_sbs(mddev_t * mddev)
 			rdev->desc_nr = i++;
 			rdev->raid_disk = rdev->desc_nr;
 			set_bit(In_sync, &rdev->flags);
-		} else if (rdev->raid_disk >= mddev->raid_disks) {
+		} else if (rdev->raid_disk >= (mddev->raid_disks - min(0, mddev->delta_disks))) {
 			rdev->raid_disk = -1;
 			clear_bit(In_sync, &rdev->flags);
 		}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d4ce51b..c4366c9 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1238,22 +1238,22 @@ static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 static int grow_one_stripe(raid5_conf_t *conf)
 {
 	struct stripe_head *sh;
+	int disks = max(conf->raid_disks, conf->previous_raid_disks);
 	sh = kmem_cache_alloc(conf->slab_cache, GFP_KERNEL);
 	if (!sh)
 		return 0;
-	memset(sh, 0, sizeof(*sh) + (conf->raid_disks-1)*sizeof(struct r5dev));
+	memset(sh, 0, sizeof(*sh) + (disks-1)*sizeof(struct r5dev));
 	sh->raid_conf = conf;
 	spin_lock_init(&sh->lock);
 	#ifdef CONFIG_MULTICORE_RAID456
 	init_waitqueue_head(&sh->ops.wait_for_ops);
 	#endif
 
-	if (grow_buffers(sh, conf->raid_disks)) {
-		shrink_buffers(sh, conf->raid_disks);
+	if (grow_buffers(sh, disks)) {
+		shrink_buffers(sh, disks);
 		kmem_cache_free(conf->slab_cache, sh);
 		return 0;
 	}
-	sh->disks = conf->raid_disks;
 	/* we just created an active stripe so... */
 	atomic_set(&sh->count, 1);
 	atomic_inc(&conf->active_stripes);
@@ -1265,7 +1265,7 @@ static int grow_one_stripe(raid5_conf_t *conf)
 static int grow_stripes(raid5_conf_t *conf, int num)
 {
 	struct kmem_cache *sc;
-	int devs = conf->raid_disks;
+	int devs = max(conf->raid_disks, conf->previous_raid_disks);
 
 	sprintf(conf->cache_name[0],
 		"raid%d-%s", conf->level, mdname(conf->mddev));
@@ -3540,9 +3540,10 @@ static void unplug_slaves(mddev_t *mddev)
 {
 	raid5_conf_t *conf = mddev->private;
 	int i;
+	int devs = max(conf->raid_disks, conf->previous_raid_disks);
 
 	rcu_read_lock();
-	for (i = 0; i < conf->raid_disks; i++) {
+	for (i = 0; i < devs; i++) {
 		mdk_rdev_t *rdev = rcu_dereference(conf->disks[i].rdev);
 		if (rdev && !test_bit(Faulty, &rdev->flags) && atomic_read(&rdev->nr_pending)) {
 			struct request_queue *r_queue = bdev_get_queue(rdev->bdev);
@@ -4562,13 +4563,9 @@ raid5_size(mddev_t *mddev, sector_t sectors, int raid_disks)
 
 	if (!sectors)
 		sectors = mddev->dev_sectors;
-	if (!raid_disks) {
+	if (!raid_disks)
 		/* size is defined by the smallest of previous and new size */
-		if (conf->raid_disks < conf->previous_raid_disks)
-			raid_disks = conf->raid_disks;
-		else
-			raid_disks = conf->previous_raid_disks;
-	}
+		raid_disks = min(conf->raid_disks, conf->previous_raid_disks);
 
 	sectors &= ~((sector_t)mddev->chunk_sectors - 1);
 	sectors &= ~((sector_t)mddev->new_chunk_sectors - 1);
@@ -4669,7 +4666,7 @@ static int raid5_alloc_percpu(raid5_conf_t *conf)
 			}
 			per_cpu_ptr(conf->percpu, cpu)->spare_page = spare_page;
 		}
-		scribble = kmalloc(scribble_len(conf->raid_disks), GFP_KERNEL);
+		scribble = kmalloc(conf->scribble_len, GFP_KERNEL);
 		if (!scribble) {
 			err = -ENOMEM;
 			break;
@@ -4690,7 +4687,7 @@ static int raid5_alloc_percpu(raid5_conf_t *conf)
 static raid5_conf_t *setup_conf(mddev_t *mddev)
 {
 	raid5_conf_t *conf;
-	int raid_disk, memory;
+	int raid_disk, memory, max_disks;
 	mdk_rdev_t *rdev;
 	struct disk_info *disk;
 
@@ -4740,13 +4737,14 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
 	conf->bypass_threshold = BYPASS_THRESHOLD;
 
 	conf->raid_disks = mddev->raid_disks;
-	conf->scribble_len = scribble_len(conf->raid_disks);
 	if (mddev->reshape_position == MaxSector)
 		conf->previous_raid_disks = mddev->raid_disks;
 	else
 		conf->previous_raid_disks = mddev->raid_disks - mddev->delta_disks;
+	max_disks = max(conf->raid_disks, conf->previous_raid_disks);
+	conf->scribble_len = scribble_len(max_disks);
 
-	conf->disks = kzalloc(conf->raid_disks * sizeof(struct disk_info),
+	conf->disks = kzalloc(max_disks * sizeof(struct disk_info),
 			      GFP_KERNEL);
 	if (!conf->disks)
 		goto abort;
@@ -4764,7 +4762,7 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
 
 	list_for_each_entry(rdev, &mddev->disks, same_set) {
 		raid_disk = rdev->raid_disk;
-		if (raid_disk >= conf->raid_disks
+		if (raid_disk >= max_disks
 		    || raid_disk < 0)
 			continue;
 		disk = conf->disks + raid_disk;
@@ -4796,7 +4794,7 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
 	}
 
 	memory = conf->max_nr_stripes * (sizeof(struct stripe_head) +
-		 conf->raid_disks * ((sizeof(struct bio) + PAGE_SIZE))) / 1024;
+		 max_disks * ((sizeof(struct bio) + PAGE_SIZE))) / 1024;
 	if (grow_stripes(conf, conf->max_nr_stripes)) {
 		printk(KERN_ERR
 			"raid5: couldn't allocate %dkB for buffers\n", memory);
@@ -4921,7 +4919,8 @@ static int run(mddev_t *mddev)
 		    test_bit(In_sync, &rdev->flags))
 			working_disks++;
 
-	mddev->degraded = conf->raid_disks - working_disks;
+	mddev->degraded = (max(conf->raid_disks, conf->previous_raid_disks)
+			   - working_disks);
 
 	if (mddev->degraded > conf->max_degraded) {
 		printk(KERN_ERR "raid5: not enough operational devices for %s"


