From: Neil Brown <neilb@suse.de>
Subject: Re: WARNING in 2.6.25-07422-gb66e1f1
Date: Fri, 9 May 2008 15:38:30 +1000
Message-ID: <18467.58198.777484.773976@notabene.brown>
References: <200805031151.44287.prakash@punnoor.de>
	<18462.46639.578272.994939@notabene.brown>
	<20080505190159.GA329@kernel.dk>
	<200805082039.01316.rjw@sisk.pl>
	<1210272379.9697.3.camel@dwillia2-linux.ch.intel.com>
	<1210288690.9697.14.camel@dwillia2-linux.ch.intel.com>
	<18467.46015.146700.695469@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Neil Brown on Friday May 9
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Jacek Luczak <difrost.kernel@gmail.com>, Prakash Punnoor <prakash@punn>
List-Id: linux-raid.ids

On Friday May 9, neilb@suse.de wrote:
> On Thursday May 8, dan.j.williams@intel.com wrote:
> > @@ -133,8 +137,10 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
> >  
> >  		disk->rdev = rdev;
> >  
> > +		spin_lock(&conf->device_lock);
> >  		blk_queue_stack_limits(mddev->queue,
> >  				       rdev->bdev->bd_disk->queue);
> > +		spin_unlock(&conf->device_lock);
> >  		/* as we don't honour merge_bvec_fn, we must never risk
> >  		 * violating it, so limit ->max_sector to one PAGE, as
> >  		 * a one page request is never in violation.
> 
> This shouldn't be necessary.
> There is no actual race here -- mddev->queue->queue_flags is not going to be
> accessed by anyone else until do_md_run does
> 	mddev->queue->make_request_fn = mddev->pers->make_request;
> which is much later.
> So we only need to be sure that "queue_is_locked" doesn't complain.
> And as q->queue_lock is still NULL at this point, it won't complain.

Sorry, I got that backwards.  It will complain, won't it. :-)

I gotta say that I think it shouldn't.  Introducing a spinlock in
linear.c, raid0.c, multipath.c just to silence a "WARN_ON" seems like
the wrong thing to do.  Of course we could just use q->__queue_lock so
we don't have to add a new lock, but we still have to take the lock
unnecessarily.

Unfortunately I cannot find a nice solution that both avoids clutter
in md code and also protects against carelessly changing flags without
a proper lock.....

Maybe....
We could get blk_queue_stack_limits to lock the queue, and always
spin_lock_init __queue_lock.  Then the only change needed in linear.c
et al would be to set ->queue_lock to &->__queue_lock.

Jens:  What do you think of this??

NeilBrown



diff --git a/block/blk-core.c b/block/blk-core.c
index b754a4a..2d31dc2 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -479,6 +479,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	kobject_init(&q->kobj, &blk_queue_ktype);
 
 	mutex_init(&q->sysfs_lock);
+	spin_lock_init(&q->__queue_lock);
 
 	return q;
 }
@@ -541,10 +542,8 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
 	 * if caller didn't supply a lock, they get per-queue locking with
 	 * our embedded lock
 	 */
-	if (!lock) {
-		spin_lock_init(&q->__queue_lock);
+	if (!lock)
 		lock = &q->__queue_lock;
-	}
 
 	q->request_fn		= rfn;
 	q->prep_rq_fn		= NULL;
diff --git a/block/blk-settings.c b/block/blk-settings.c
index bb93d4c..488199a 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -286,8 +286,14 @@ void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b)
 	t->max_hw_segments = min(t->max_hw_segments, b->max_hw_segments);
 	t->max_segment_size = min(t->max_segment_size, b->max_segment_size);
 	t->hardsect_size = max(t->hardsect_size, b->hardsect_size);
-	if (!test_bit(QUEUE_FLAG_CLUSTER, &b->queue_flags))
+	if (!t->queue_lock)
+		WARN_ON_ONCE(1);
+	else if (!test_bit(QUEUE_FLAG_CLUSTER, &b->queue_flags)) {
+		unsigned long flags;
+		spin_lock_irqsave(&t->queue_lock, flags);
 		queue_flag_clear(QUEUE_FLAG_CLUSTER, t);
+		spin_unlock_irqrestore(&t->queue_lock, flags);
+	}
 }
 EXPORT_SYMBOL(blk_queue_stack_limits);
 
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 0b85117..552f81b 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -250,6 +250,7 @@ static int linear_run (mddev_t *mddev)
 {
 	linear_conf_t *conf;
 
+	mddev->queue_lock = &mddev->__queue_lock;
 	conf = linear_conf(mddev, mddev->raid_disks);
 
 	if (!conf)
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 42ee1a2..90f85e4 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -417,6 +417,7 @@ static int multipath_run (mddev_t *mddev)
 	 * bookkeeping area. [whatever we allocate in multipath_run(),
 	 * should be freed in multipath_stop()]
 	 */
+	mddev->queue_lock = &mddev->__queue_lock;
 
 	conf = kzalloc(sizeof(multipath_conf_t), GFP_KERNEL);
 	mddev->private = conf;
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 818b482..a179c8f 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -280,6 +280,7 @@ static int raid0_run (mddev_t *mddev)
 	       (mddev->chunk_size>>1)-1);
 	blk_queue_max_sectors(mddev->queue, mddev->chunk_size >> 9);
 	blk_queue_segment_boundary(mddev->queue, (mddev->chunk_size>>1) - 1);
+	mddev->queue_lock = &mddev->__queue_lock;
 
 	conf = kmalloc(sizeof (raid0_conf_t), GFP_KERNEL);
 	if (!conf)
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 6778b7c..ac409b7 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1935,6 +1935,9 @@ static int run(mddev_t *mddev)
 	if (!conf->r1bio_pool)
 		goto out_no_mem;
 
+	spin_lock_init(&conf->device_lock);
+	mddev->queue->queue_lock = &conf->device_lock;
+
 	rdev_for_each(rdev, tmp, mddev) {
 		disk_idx = rdev->raid_disk;
 		if (disk_idx >= mddev->raid_disks
@@ -1958,7 +1961,6 @@ static int run(mddev_t *mddev)
 	}
 	conf->raid_disks = mddev->raid_disks;
 	conf->mddev = mddev;
-	spin_lock_init(&conf->device_lock);
 	INIT_LIST_HEAD(&conf->retry_list);
 
 	spin_lock_init(&conf->resync_lock);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5938fa9..740f670 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2082,6 +2082,9 @@ static int run(mddev_t *mddev)
 		goto out_free_conf;
 	}
 
+	spin_lock_init(&conf->device_lock);
+	mddev->queue->queue_lock = &mddev->queue->__queue_lock;
+
 	rdev_for_each(rdev, tmp, mddev) {
 		disk_idx = rdev->raid_disk;
 		if (disk_idx >= mddev->raid_disks
@@ -2103,7 +2106,6 @@ static int run(mddev_t *mddev)
 
 		disk->head_position = 0;
 	}
-	spin_lock_init(&conf->device_lock);
 	INIT_LIST_HEAD(&conf->retry_list);
 
 	spin_lock_init(&conf->resync_lock);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 087eee0..4fafc79 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4256,6 +4256,7 @@ static int run(mddev_t *mddev)
 			goto abort;
 	}
 	spin_lock_init(&conf->device_lock);
+	mddev->queue->queue_lock = &conf->device_lock;
 	init_waitqueue_head(&conf->wait_for_stripe);
 	init_waitqueue_head(&conf->wait_for_overlap);
 	INIT_LIST_HEAD(&conf->handle_list);
