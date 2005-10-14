From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 001 of 8] Provide proper rcu_dereference / rcu_assign_pointer annotations in md
Date: Fri, 14 Oct 2005 12:25:55 +1000
Message-ID: <1051014022555.11758@suse.de>
References: <20051014122335.11602.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Acked-by: <paulmck@us.ibm.com>
Signed-off-by: <suzannew@cs.pdx.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/multipath.c |    8 ++++----
 ./drivers/md/raid1.c     |   20 ++++++++++----------
 ./drivers/md/raid10.c    |   30 ++++++++++++++++--------------
 ./drivers/md/raid5.c     |    8 ++++----
 ./drivers/md/raid6main.c |    8 ++++----
 5 files changed, 38 insertions(+), 36 deletions(-)

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2005-10-14 12:01:38.000000000 +1000
+++ ./drivers/md/multipath.c	2005-10-14 12:15:25.000000000 +1000
@@ -63,7 +63,7 @@ static int multipath_map (multipath_conf
 
 	rcu_read_lock();
 	for (i = 0; i < disks; i++) {
-		mdk_rdev_t *rdev = conf->multipaths[i].rdev;
+		mdk_rdev_t *rdev = rcu_dereference(conf->multipaths[i].rdev);
 		if (rdev && rdev->in_sync) {
 			atomic_inc(&rdev->nr_pending);
 			rcu_read_unlock();
@@ -139,7 +139,7 @@ static void unplug_slaves(mddev_t *mddev
 
 	rcu_read_lock();
 	for (i=0; i<mddev->raid_disks; i++) {
-		mdk_rdev_t *rdev = conf->multipaths[i].rdev;
+		mdk_rdev_t *rdev = rcu_dereference(conf->multipaths[i].rdev);
 		if (rdev && !rdev->faulty && atomic_read(&rdev->nr_pending)) {
 			request_queue_t *r_queue = bdev_get_queue(rdev->bdev);
 
@@ -228,7 +228,7 @@ static int multipath_issue_flush(request
 
 	rcu_read_lock();
 	for (i=0; i<mddev->raid_disks && ret == 0; i++) {
-		mdk_rdev_t *rdev = conf->multipaths[i].rdev;
+		mdk_rdev_t *rdev = rcu_dereference(conf->multipaths[i].rdev);
 		if (rdev && !rdev->faulty) {
 			struct block_device *bdev = rdev->bdev;
 			request_queue_t *r_queue = bdev_get_queue(bdev);
@@ -335,7 +335,7 @@ static int multipath_add_disk(mddev_t *m
 			conf->working_disks++;
 			rdev->raid_disk = path;
 			rdev->in_sync = 1;
-			p->rdev = rdev;
+			rcu_assign_pointer(p->rdev, rdev);
 			found = 1;
 		}
 

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-10-14 12:01:38.000000000 +1000
+++ ./drivers/md/raid1.c	2005-10-14 12:15:25.000000000 +1000
@@ -416,10 +416,10 @@ static int read_balance(conf_t *conf, r1
 		/* Choose the first operation device, for consistancy */
 		new_disk = 0;
 
-		for (rdev = conf->mirrors[new_disk].rdev;
+		for (rdev = rcu_dereference(conf->mirrors[new_disk].rdev);
 		     !rdev || !rdev->in_sync
 			     || test_bit(WriteMostly, &rdev->flags);
-		     rdev = conf->mirrors[++new_disk].rdev) {
+		     rdev = rcu_dereference(conf->mirrors[++new_disk].rdev)) {
 
 			if (rdev && rdev->in_sync)
 				wonly_disk = new_disk;
@@ -434,10 +434,10 @@ static int read_balance(conf_t *conf, r1
 
 
 	/* make sure the disk is operational */
-	for (rdev = conf->mirrors[new_disk].rdev;
+	for (rdev = rcu_dereference(conf->mirrors[new_disk].rdev);
 	     !rdev || !rdev->in_sync ||
 		     test_bit(WriteMostly, &rdev->flags);
-	     rdev = conf->mirrors[new_disk].rdev) {
+	     rdev = rcu_dereference(conf->mirrors[new_disk].rdev)) {
 
 		if (rdev && rdev->in_sync)
 			wonly_disk = new_disk;
@@ -474,7 +474,7 @@ static int read_balance(conf_t *conf, r1
 			disk = conf->raid_disks;
 		disk--;
 
-		rdev = conf->mirrors[disk].rdev;
+		rdev = rcu_dereference(conf->mirrors[disk].rdev);
 
 		if (!rdev ||
 		    !rdev->in_sync ||
@@ -496,7 +496,7 @@ static int read_balance(conf_t *conf, r1
 
 
 	if (new_disk >= 0) {
-		rdev = conf->mirrors[new_disk].rdev;
+		rdev = rcu_dereference(conf->mirrors[new_disk].rdev);
 		if (!rdev)
 			goto retry;
 		atomic_inc(&rdev->nr_pending);
@@ -522,7 +522,7 @@ static void unplug_slaves(mddev_t *mddev
 
 	rcu_read_lock();
 	for (i=0; i<mddev->raid_disks; i++) {
-		mdk_rdev_t *rdev = conf->mirrors[i].rdev;
+		mdk_rdev_t *rdev = rcu_dereference(conf->mirrors[i].rdev);
 		if (rdev && !rdev->faulty && atomic_read(&rdev->nr_pending)) {
 			request_queue_t *r_queue = bdev_get_queue(rdev->bdev);
 
@@ -556,7 +556,7 @@ static int raid1_issue_flush(request_que
 
 	rcu_read_lock();
 	for (i=0; i<mddev->raid_disks && ret == 0; i++) {
-		mdk_rdev_t *rdev = conf->mirrors[i].rdev;
+		mdk_rdev_t *rdev = rcu_dereference(conf->mirrors[i].rdev);
 		if (rdev && !rdev->faulty) {
 			struct block_device *bdev = rdev->bdev;
 			request_queue_t *r_queue = bdev_get_queue(bdev);
@@ -732,7 +732,7 @@ static int make_request(request_queue_t 
 #endif
 	rcu_read_lock();
 	for (i = 0;  i < disks; i++) {
-		if ((rdev=conf->mirrors[i].rdev) != NULL &&
+		if ((rdev=rcu_dereference(conf->mirrors[i].rdev)) != NULL &&
 		    !rdev->faulty) {
 			atomic_inc(&rdev->nr_pending);
 			if (rdev->faulty) {
@@ -958,7 +958,7 @@ static int raid1_add_disk(mddev_t *mddev
 			found = 1;
 			if (rdev->saved_raid_disk != mirror)
 				conf->fullsync = 1;
-			p->rdev = rdev;
+			rcu_assign_pointer(p->rdev, rdev);
 			break;
 		}
 

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2005-10-14 12:01:38.000000000 +1000
+++ ./drivers/md/raid10.c	2005-10-14 12:15:25.000000000 +1000
@@ -496,6 +496,7 @@ static int read_balance(conf_t *conf, r1
 	int disk, slot, nslot;
 	const int sectors = r10_bio->sectors;
 	sector_t new_distance, current_distance;
+	mdk_rdev_t *rdev;
 
 	raid10_find_phys(conf, r10_bio);
 	rcu_read_lock();
@@ -510,8 +511,8 @@ static int read_balance(conf_t *conf, r1
 		slot = 0;
 		disk = r10_bio->devs[slot].devnum;
 
-		while (!conf->mirrors[disk].rdev ||
-		       !conf->mirrors[disk].rdev->in_sync) {
+		while ((rdev = rcu_dereference(conf->mirrors[disk].rdev)) == NULL ||
+		       !rdev->in_sync) {
 			slot++;
 			if (slot == conf->copies) {
 				slot = 0;
@@ -527,8 +528,8 @@ static int read_balance(conf_t *conf, r1
 	/* make sure the disk is operational */
 	slot = 0;
 	disk = r10_bio->devs[slot].devnum;
-	while (!conf->mirrors[disk].rdev ||
-	       !conf->mirrors[disk].rdev->in_sync) {
+	while ((rdev=rcu_dereference(conf->mirrors[disk].rdev)) == NULL ||
+	       !rdev->in_sync) {
 		slot ++;
 		if (slot == conf->copies) {
 			disk = -1;
@@ -547,11 +548,11 @@ static int read_balance(conf_t *conf, r1
 		int ndisk = r10_bio->devs[nslot].devnum;
 
 
-		if (!conf->mirrors[ndisk].rdev ||
-		    !conf->mirrors[ndisk].rdev->in_sync)
+		if ((rdev=rcu_dereference(conf->mirrors[ndisk].rdev)) == NULL ||
+		    !rdev->in_sync)
 			continue;
 
-		if (!atomic_read(&conf->mirrors[ndisk].rdev->nr_pending)) {
+		if (!atomic_read(&rdev->nr_pending)) {
 			disk = ndisk;
 			slot = nslot;
 			break;
@@ -569,7 +570,7 @@ rb_out:
 	r10_bio->read_slot = slot;
 /*	conf->next_seq_sect = this_sector + sectors;*/
 
-	if (disk >= 0 && conf->mirrors[disk].rdev)
+	if (disk >= 0 && (rdev=rcu_dereference(conf->mirrors[disk].rdev))!= NULL)
 		atomic_inc(&conf->mirrors[disk].rdev->nr_pending);
 	rcu_read_unlock();
 
@@ -583,7 +584,7 @@ static void unplug_slaves(mddev_t *mddev
 
 	rcu_read_lock();
 	for (i=0; i<mddev->raid_disks; i++) {
-		mdk_rdev_t *rdev = conf->mirrors[i].rdev;
+		mdk_rdev_t *rdev = rcu_dereference(conf->mirrors[i].rdev);
 		if (rdev && !rdev->faulty && atomic_read(&rdev->nr_pending)) {
 			request_queue_t *r_queue = bdev_get_queue(rdev->bdev);
 
@@ -614,7 +615,7 @@ static int raid10_issue_flush(request_qu
 
 	rcu_read_lock();
 	for (i=0; i<mddev->raid_disks && ret == 0; i++) {
-		mdk_rdev_t *rdev = conf->mirrors[i].rdev;
+		mdk_rdev_t *rdev = rcu_dereference(conf->mirrors[i].rdev);
 		if (rdev && !rdev->faulty) {
 			struct block_device *bdev = rdev->bdev;
 			request_queue_t *r_queue = bdev_get_queue(bdev);
@@ -772,9 +773,10 @@ static int make_request(request_queue_t 
 	rcu_read_lock();
 	for (i = 0;  i < conf->copies; i++) {
 		int d = r10_bio->devs[i].devnum;
-		if (conf->mirrors[d].rdev &&
-		    !conf->mirrors[d].rdev->faulty) {
-			atomic_inc(&conf->mirrors[d].rdev->nr_pending);
+		mdk_rdev_t *rdev = rcu_dereference(conf->mirrors[d].rdev);
+		if (rdev &&
+		    !rdev->faulty) {
+			atomic_inc(&rdev->nr_pending);
 			r10_bio->devs[i].bio = bio;
 		} else
 			r10_bio->devs[i].bio = NULL;
@@ -984,7 +986,7 @@ static int raid10_add_disk(mddev_t *mdde
 			p->head_position = 0;
 			rdev->raid_disk = mirror;
 			found = 1;
-			p->rdev = rdev;
+			rcu_assign_pointer(p->rdev, rdev);
 			break;
 		}
 

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-10-14 12:15:05.000000000 +1000
+++ ./drivers/md/raid5.c	2005-10-14 12:15:25.000000000 +1000
@@ -1374,7 +1374,7 @@ static void handle_stripe(struct stripe_
 			bi->bi_end_io = raid5_end_read_request;
  
 		rcu_read_lock();
-		rdev = conf->disks[i].rdev;
+		rdev = rcu_dereference(conf->disks[i].rdev);
 		if (rdev && rdev->faulty)
 			rdev = NULL;
 		if (rdev)
@@ -1448,7 +1448,7 @@ static void unplug_slaves(mddev_t *mddev
 
 	rcu_read_lock();
 	for (i=0; i<mddev->raid_disks; i++) {
-		mdk_rdev_t *rdev = conf->disks[i].rdev;
+		mdk_rdev_t *rdev = rcu_dereference(conf->disks[i].rdev);
 		if (rdev && !rdev->faulty && atomic_read(&rdev->nr_pending)) {
 			request_queue_t *r_queue = bdev_get_queue(rdev->bdev);
 
@@ -1493,7 +1493,7 @@ static int raid5_issue_flush(request_que
 
 	rcu_read_lock();
 	for (i=0; i<mddev->raid_disks && ret == 0; i++) {
-		mdk_rdev_t *rdev = conf->disks[i].rdev;
+		mdk_rdev_t *rdev = rcu_dereference(conf->disks[i].rdev);
 		if (rdev && !rdev->faulty) {
 			struct block_device *bdev = rdev->bdev;
 			request_queue_t *r_queue = bdev_get_queue(bdev);
@@ -2169,7 +2169,7 @@ static int raid5_add_disk(mddev_t *mddev
 			found = 1;
 			if (rdev->saved_raid_disk != disk)
 				conf->fullsync = 1;
-			p->rdev = rdev;
+			rcu_assign_pointer(p->rdev, rdev);
 			break;
 		}
 	print_raid5_conf(conf);

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2005-10-14 12:01:38.000000000 +1000
+++ ./drivers/md/raid6main.c	2005-10-14 12:15:25.000000000 +1000
@@ -1464,7 +1464,7 @@ static void handle_stripe(struct stripe_
 			bi->bi_end_io = raid6_end_read_request;
 
 		rcu_read_lock();
-		rdev = conf->disks[i].rdev;
+		rdev = rcu_dereference(conf->disks[i].rdev);
 		if (rdev && rdev->faulty)
 			rdev = NULL;
 		if (rdev)
@@ -1538,7 +1538,7 @@ static void unplug_slaves(mddev_t *mddev
 
 	rcu_read_lock();
 	for (i=0; i<mddev->raid_disks; i++) {
-		mdk_rdev_t *rdev = conf->disks[i].rdev;
+		mdk_rdev_t *rdev = rcu_dereference(conf->disks[i].rdev);
 		if (rdev && !rdev->faulty && atomic_read(&rdev->nr_pending)) {
 			request_queue_t *r_queue = bdev_get_queue(rdev->bdev);
 
@@ -1583,7 +1583,7 @@ static int raid6_issue_flush(request_que
 
 	rcu_read_lock();
 	for (i=0; i<mddev->raid_disks && ret == 0; i++) {
-		mdk_rdev_t *rdev = conf->disks[i].rdev;
+		mdk_rdev_t *rdev = rcu_dereference(conf->disks[i].rdev);
 		if (rdev && !rdev->faulty) {
 			struct block_device *bdev = rdev->bdev;
 			request_queue_t *r_queue = bdev_get_queue(bdev);
@@ -2158,7 +2158,7 @@ static int raid6_add_disk(mddev_t *mddev
 			found = 1;
 			if (rdev->saved_raid_disk != disk)
 				conf->fullsync = 1;
-			p->rdev = rdev;
+			rcu_assign_pointer(p->rdev, rdev);
 			break;
 		}
 	print_raid6_conf(conf);
