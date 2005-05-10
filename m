From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 002 of 4] Set the unplug_fn and issue_flush_fn for md devices *after* committed to creation.
Date: Tue, 10 May 2005 15:04:02 +1000
Message-ID: <E1DVMuY-0000Pw-LC@notabene.cse.unsw.edu.au>
References: <20050510145931.1553.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


We we set the too early, they may still be in place and possibly get called
even though the array didn't get set up properly.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/multipath.c |    8 ++++----
 ./drivers/md/raid1.c     |    7 +++----
 ./drivers/md/raid10.c    |    6 +++---
 ./drivers/md/raid5.c     |    7 ++++---
 ./drivers/md/raid6main.c |    6 +++---
 5 files changed, 17 insertions(+), 17 deletions(-)

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2005-05-10 14:30:02.000000000 +1000
+++ ./drivers/md/multipath.c	2005-05-10 14:29:15.000000000 +1000
@@ -462,10 +462,6 @@ static int multipath_run (mddev_t *mddev
 	}
 	memset(conf->multipaths, 0, sizeof(struct multipath_info)*mddev->raid_disks);
 
-	mddev->queue->unplug_fn = multipath_unplug;
-
-	mddev->queue->issue_flush_fn = multipath_issue_flush;
-
 	conf->working_disks = 0;
 	ITERATE_RDEV(mddev,rdev,tmp) {
 		disk_idx = rdev->raid_disk;
@@ -528,6 +524,10 @@ static int multipath_run (mddev_t *mddev
 	 * Ok, everything is just fine now
 	 */
 	mddev->array_size = mddev->size;
+
+	mddev->queue->unplug_fn = multipath_unplug;
+	mddev->queue->issue_flush_fn = multipath_issue_flush;
+
 	return 0;
 
 out_free_conf:

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-05-10 14:30:02.000000000 +1000
+++ ./drivers/md/raid1.c	2005-05-10 14:29:15.000000000 +1000
@@ -1331,10 +1331,6 @@ static int run(mddev_t *mddev)
 	if (!conf->r1bio_pool)
 		goto out_no_mem;
 
-	mddev->queue->unplug_fn = raid1_unplug;
-
-	mddev->queue->issue_flush_fn = raid1_issue_flush;
-
 	ITERATE_RDEV(mddev, rdev, tmp) {
 		disk_idx = rdev->raid_disk;
 		if (disk_idx >= mddev->raid_disks
@@ -1418,6 +1414,9 @@ static int run(mddev_t *mddev)
 	 */
 	mddev->array_size = mddev->size;
 
+	mddev->queue->unplug_fn = raid1_unplug;
+	mddev->queue->issue_flush_fn = raid1_issue_flush;
+
 	return 0;
 
 out_no_mem:

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2005-05-10 14:30:02.000000000 +1000
+++ ./drivers/md/raid10.c	2005-05-10 14:29:15.000000000 +1000
@@ -1645,9 +1645,6 @@ static int run(mddev_t *mddev)
 			mdname(mddev));
 		goto out_free_conf;
 	}
-	mddev->queue->unplug_fn = raid10_unplug;
-
-	mddev->queue->issue_flush_fn = raid10_issue_flush;
 
 	ITERATE_RDEV(mddev, rdev, tmp) {
 		disk_idx = rdev->raid_disk;
@@ -1719,6 +1716,9 @@ static int run(mddev_t *mddev)
 	mddev->array_size = size/2;
 	mddev->resync_max_sectors = size;
 
+	mddev->queue->unplug_fn = raid10_unplug;
+	mddev->queue->issue_flush_fn = raid10_issue_flush;
+
 	/* Calculate max read-ahead size.
 	 * We need to readahead at least twice a whole stripe....
 	 * maybe...

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-05-10 14:30:02.000000000 +1000
+++ ./drivers/md/raid5.c	2005-05-10 14:29:15.000000000 +1000
@@ -1620,9 +1620,6 @@ static int run (mddev_t *mddev)
 	atomic_set(&conf->active_stripes, 0);
 	atomic_set(&conf->preread_active_stripes, 0);
 
-	mddev->queue->unplug_fn = raid5_unplug_device;
-	mddev->queue->issue_flush_fn = raid5_issue_flush;
-
 	PRINTK("raid5: run(%s) called.\n", mdname(mddev));
 
 	ITERATE_RDEV(mddev,rdev,tmp) {
@@ -1728,6 +1725,10 @@ memory = conf->max_nr_stripes * (sizeof(
 	}
 
 	/* Ok, everything is just fine now */
+
+	mddev->queue->unplug_fn = raid5_unplug_device;
+	mddev->queue->issue_flush_fn = raid5_issue_flush;
+
 	mddev->array_size =  mddev->size * (mddev->raid_disks - 1);
 	return 0;
 abort:

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2005-05-10 14:30:02.000000000 +1000
+++ ./drivers/md/raid6main.c	2005-05-10 14:29:15.000000000 +1000
@@ -1779,9 +1779,6 @@ static int run (mddev_t *mddev)
 	atomic_set(&conf->active_stripes, 0);
 	atomic_set(&conf->preread_active_stripes, 0);
 
-	mddev->queue->unplug_fn = raid6_unplug_device;
-	mddev->queue->issue_flush_fn = raid6_issue_flush;
-
 	PRINTK("raid6: run(%s) called.\n", mdname(mddev));
 
 	ITERATE_RDEV(mddev,rdev,tmp) {
@@ -1895,6 +1892,9 @@ static int run (mddev_t *mddev)
 
 	/* Ok, everything is just fine now */
 	mddev->array_size =  mddev->size * (mddev->raid_disks - 2);
+
+	mddev->queue->unplug_fn = raid6_unplug_device;
+	mddev->queue->issue_flush_fn = raid6_issue_flush;
 	return 0;
 abort:
 	if (conf) {
