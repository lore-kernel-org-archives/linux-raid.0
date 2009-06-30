From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: md: Use new topology calls to indicate alignment and I/O sizes
Date: Tue, 30 Jun 2009 16:24:32 -0400
Message-ID: <20090630202432.GG7888@redhat.com>
References: <yq1ws73turf.fsf@sermon.lab.mkp.net> <170fa0d20906231444t5432998eo8cc2335c6d4a3a0d@mail.gmail.com> <19009.42494.925771.283731@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <19009.42494.925771.283731@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: jens.axboe@oracle.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-raid.ids

On Wed, Jun 24 2009 at 12:05am -0400,
Neil Brown <neilb@suse.de> wrote:

> On Tuesday June 23, snitzer@gmail.com wrote:
> >
> > On Tue, Jun 23, 2009 at 12:54 AM, Martin K.
> > Petersen<martin.petersen@oracle.com> wrote:
> > >
> > > Neil,
> > >
> > > Looks like this one missed the boat on the first MD pull request.
> > > Here's an updated patch that applies to Linus' current tree in case you
> > > are planning a second round...
> > >
> > >
> > > Switch MD over to the new disk_stack_limits() function which checks for
> > > aligment and adjusts preferred I/O sizes when stacking.
> > >
> > > Also indicate preferred I/O sizes where applicable.
> > 
> > Given that Linus has not yet pulled in the DM changes for 2.6.31
> > (which includes DM's topology support) I'd imagine it shouldn't be a
> > problem to get this patch in.  In fact it would be a real shame if
> > this somehow missed 2.6.31 seeing as MD is the only consumer of the
> > topology infrastructure's disk_stack_limits().
> > 
> > Neil, please push to Linus for 2.6.31, thanks!
> > 
> 
> It looks mostly OK and can now be pulled from
>    git://neil.brown.name/md/ for-linus
> though I'll send a more formal pull request later (if necessary)

Neil,

Any chance you could make a formal pull request for this MD topology
support patch for 2.6.31-rc2?

NOTE: all the disk_stack_limits() calls must pass the 3rd 'offset' arg
in terms of bytes and _not_ sectors.  So all of MD's calls to
disk_stack_limits() should pass: rdev->data_offset << 9

Here is an updated patch, please advise, thanks!


From: Martin K. Petersen <martin.petersen@oracle.com>

Switch MD over to the new disk_stack_limits() function which checks for
alignment and adjusts preferred I/O sizes when stacking.

Also indicate preferred I/O sizes where applicable.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>

--
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 15c8b7b..5810fa9 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -166,8 +166,8 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
 			rdev->sectors = sectors * mddev->chunk_sectors;
 		}
 
-		blk_queue_stack_limits(mddev->queue,
-				       rdev->bdev->bd_disk->queue);
+		disk_stack_limits(mddev->gendisk, rdev->bdev,
+				  rdev->data_offset << 9);
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, so limit ->max_sector to one PAGE, as
 		 * a one page request is never in violation.
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index cbe368f..3e320ac 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -294,7 +294,8 @@ static int multipath_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 	for (path = first; path <= last; path++)
 		if ((p=conf->multipaths+path)->rdev == NULL) {
 			q = rdev->bdev->bd_disk->queue;
-			blk_queue_stack_limits(mddev->queue, q);
+			disk_stack_limits(mddev->gendisk, rdev->bdev,
+				rdev->data_offset << 9);
 
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, so limit ->max_sector to one PAGE, as
@@ -463,9 +464,9 @@ static int multipath_run (mddev_t *mddev)
 
 		disk = conf->multipaths + disk_idx;
 		disk->rdev = rdev;
+		disk_stack_limits(mddev->gendisk, rdev->bdev,
+				  rdev->data_offset << 9);
 
-		blk_queue_stack_limits(mddev->queue,
-				       rdev->bdev->bd_disk->queue);
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, not that we ever expect a device with
 		 * a merge_bvec_fn to be involved in multipath */
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index ab4a489..335f490 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -170,8 +170,8 @@ static int create_strip_zones(mddev_t *mddev)
 		}
 		dev[j] = rdev1;
 
-		blk_queue_stack_limits(mddev->queue,
-				       rdev1->bdev->bd_disk->queue);
+		disk_stack_limits(mddev->gendisk, rdev1->bdev,
+				  rdev1->data_offset << 9);
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, so limit ->max_sector to one PAGE, as
 		 * a one page request is never in violation.
@@ -250,6 +250,11 @@ static int create_strip_zones(mddev_t *mddev)
 		       mddev->chunk_sectors << 9);
 		goto abort;
 	}
+
+	blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
+	blk_queue_io_opt(mddev->queue,
+			 (mddev->chunk_sectors << 9) * mddev->raid_disks);
+
 	printk(KERN_INFO "raid0: done.\n");
 	mddev->private = conf;
 	return 0;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 89939a7..0569efb 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1123,8 +1123,8 @@ static int raid1_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 	for (mirror = first; mirror <= last; mirror++)
 		if ( !(p=conf->mirrors+mirror)->rdev) {
 
-			blk_queue_stack_limits(mddev->queue,
-					       rdev->bdev->bd_disk->queue);
+			disk_stack_limits(mddev->gendisk, rdev->bdev,
+					  rdev->data_offset << 9);
 			/* as we don't honour merge_bvec_fn, we must never risk
 			 * violating it, so limit ->max_sector to one PAGE, as
 			 * a one page request is never in violation.
@@ -1988,9 +1988,8 @@ static int run(mddev_t *mddev)
 		disk = conf->mirrors + disk_idx;
 
 		disk->rdev = rdev;
-
-		blk_queue_stack_limits(mddev->queue,
-				       rdev->bdev->bd_disk->queue);
+		disk_stack_limits(mddev->gendisk, rdev->bdev,
+				  rdev->data_offset << 9);
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, so limit ->max_sector to one PAGE, as
 		 * a one page request is never in violation.
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index ae12cea..7298a5e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1151,8 +1151,8 @@ static int raid10_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 	for ( ; mirror <= last ; mirror++)
 		if ( !(p=conf->mirrors+mirror)->rdev) {
 
-			blk_queue_stack_limits(mddev->queue,
-					       rdev->bdev->bd_disk->queue);
+			disk_stack_limits(mddev->gendisk, rdev->bdev,
+					  rdev->data_offset << 9);
 			/* as we don't honour merge_bvec_fn, we must never risk
 			 * violating it, so limit ->max_sector to one PAGE, as
 			 * a one page request is never in violation.
@@ -2044,7 +2044,7 @@ raid10_size(mddev_t *mddev, sector_t sectors, int raid_disks)
 static int run(mddev_t *mddev)
 {
 	conf_t *conf;
-	int i, disk_idx;
+	int i, disk_idx, chunk_size;
 	mirror_info_t *disk;
 	mdk_rdev_t *rdev;
 	int nc, fc, fo;
@@ -2130,6 +2130,14 @@ static int run(mddev_t *mddev)
 	spin_lock_init(&conf->device_lock);
 	mddev->queue->queue_lock = &conf->device_lock;
 
+	chunk_size = mddev->chunk_sectors << 9;
+	blk_queue_io_min(mddev->queue, chunk_size);
+	if (conf->raid_disks % conf->near_copies)
+		blk_queue_io_opt(mddev->queue, chunk_size * conf->raid_disks);
+	else
+		blk_queue_io_opt(mddev->queue, chunk_size *
+				 (conf->raid_disks / conf->near_copies));
+
 	list_for_each_entry(rdev, &mddev->disks, same_set) {
 		disk_idx = rdev->raid_disk;
 		if (disk_idx >= mddev->raid_disks
@@ -2138,9 +2146,8 @@ static int run(mddev_t *mddev)
 		disk = conf->mirrors + disk_idx;
 
 		disk->rdev = rdev;
-
-		blk_queue_stack_limits(mddev->queue,
-				       rdev->bdev->bd_disk->queue);
+		disk_stack_limits(mddev->gendisk, rdev->bdev,
+				  rdev->data_offset << 9);
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, so limit ->max_sector to one PAGE, as
 		 * a one page request is never in violation.
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f9f991e..92ef9b6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4452,7 +4452,7 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
 static int run(mddev_t *mddev)
 {
 	raid5_conf_t *conf;
-	int working_disks = 0;
+	int working_disks = 0, chunk_size;
 	mdk_rdev_t *rdev;
 
 	if (mddev->recovery_cp != MaxSector)
@@ -4607,6 +4607,14 @@ static int run(mddev_t *mddev)
 	md_set_array_sectors(mddev, raid5_size(mddev, 0, 0));
 
 	blk_queue_merge_bvec(mddev->queue, raid5_mergeable_bvec);
+	chunk_size = mddev->chunk_sectors << 9;
+	blk_queue_io_min(mddev->queue, chunk_size);
+	blk_queue_io_opt(mddev->queue, chunk_size *
+			 (conf->raid_disks - conf->max_degraded));
+
+	list_for_each_entry(rdev, &mddev->disks, same_set)
+		disk_stack_limits(mddev->gendisk, rdev->bdev,
+				  rdev->data_offset << 9);
 
 	return 0;
 abort:
