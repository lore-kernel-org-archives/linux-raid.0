From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: WARNING in 2.6.25-07422-gb66e1f1
Date: Thu, 08 May 2008 16:18:10 -0700
Message-ID: <1210288690.9697.14.camel@dwillia2-linux.ch.intel.com>
References: <200805031151.44287.prakash@punnoor.de>
	 <18462.46639.578272.994939@notabene.brown> <20080505190159.GA329@kernel.dk>
	 <200805082039.01316.rjw@sisk.pl>
	 <1210272379.9697.3.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1210272379.9697.3.camel@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Jacek Luczak <difrost.kernel@gmail.com>, Prakash Punnoor <prakash@punnoor.de>, Linux Kernel list <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2008-05-08 at 11:46 -0700, Dan Williams wrote:
> On Thu, 2008-05-08 at 11:39 -0700, Rafael J. Wysocki wrote:
> > I get a similar warning with RAID1 on one of my test boxes:
> > 
> > WARNING: at /home/rafael/src/linux-2.6/include/linux/blkdev.h:443 blk_remove_plug+0x85/0xa0()
> > Modules linked in: raid456 async_xor async_memcpy async_tx xor raid0 ehci_hcd ohci_hcd sd_mod edd raid1 ext3 jbd fan sata_uli pata_ali thermal processor
> > Pid: 2159, comm: md1_raid1 Not tainted 2.6.26-rc1 #158
> > 
> > Call Trace:
> >  [<ffffffff80238bbf>] warn_on_slowpath+0x5f/0x80
> >  [<ffffffff8025e8d8>] ? __lock_acquire+0x748/0x10d0
> >  [<ffffffff80348f55>] blk_remove_plug+0x85/0xa0
> >  [<ffffffffa004df64>] :raid1:flush_pending_writes+0x44/0xb0
> >  [<ffffffffa004e649>] :raid1:raid1d+0x59/0xfe0
> >  [<ffffffff8025e8d8>] ? __lock_acquire+0x748/0x10d0
> >  [<ffffffff8025dc4f>] ? trace_hardirqs_on+0xbf/0x150
> >  [<ffffffff8043ea8c>] md_thread+0x3c/0x110
> >  [<ffffffff8024f6a0>] ? autoremove_wake_function+0x0/0x40
> >  [<ffffffff8043ea50>] ? md_thread+0x0/0x110
> >  [<ffffffff8024f23d>] kthread+0x4d/0x80
> >  [<ffffffff8020c548>] child_rip+0xa/0x12
> >  [<ffffffff8020bc5f>] ? restore_args+0x0/0x30
> >  [<ffffffff8024f1f0>] ? kthread+0x0/0x80
> >  [<ffffffff8020c53e>] ? child_rip+0x0/0x12
> > 
> > ---[ end trace 05d4e0844c61f45d ]---
> > 
> > This is the WARN_ON_ONCE(!queue_is_locked(q)) in queue_flag_clear(),
> > apparently.
> 
> Yes, it triggers on all RAID levels.  The patch in this message:
> 
> http://marc.info/?l=linux-raid&m=121001065404056&w=2
> > 
> ...fixes the raid 0/1/10/5/6 cases, but I am still trying to isolate an
> issue (potentially unrelated) with linear arrays.
> 

Gah, 'device_lock' can not come after 'disks[0]' in 'struct
linear_private_data'.  Updated patch below.  Simple testing passes:
'mdadm --create /dev/md0; mkfs.ext3 /dev/md0' for each raid level
linear, 0, 1, 10, 5, and 6.

---snip--->
Subject: md: tell blk-core about device_lock for protecting the queue flags
From: Dan Williams <dan.j.williams@intel.com>

Now that queue flags are no longer atomic (commit:
75ad23bc0fcb4f992a5d06982bf0857ab1738e9e) blk-core checks the queue is locked
via ->queue_lock.  As noticed by Neil conf->device_lock already satisfies this
requirement.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/linear.c         |    6 ++++++
 drivers/md/multipath.c      |    6 ++++++
 drivers/md/raid0.c          |    6 ++++++
 drivers/md/raid1.c          |    7 ++++++-
 drivers/md/raid10.c         |    7 ++++++-
 drivers/md/raid5.c          |    2 ++
 include/linux/raid/linear.h |    3 ++-
 include/linux/raid/raid0.h  |    1 +
 8 files changed, 35 insertions(+), 3 deletions(-)


diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 0b85117..d026f08 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -122,6 +122,10 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
 	cnt = 0;
 	conf->array_size = 0;
 
+	spin_lock_init(&conf->device_lock);
+	/* blk-core uses queue_lock to verify protection of the queue flags */
+	mddev->queue->queue_lock = &conf->device_lock;
+
 	rdev_for_each(rdev, tmp, mddev) {
 		int j = rdev->raid_disk;
 		dev_info_t *disk = conf->disks + j;
@@ -133,8 +137,10 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
 
 		disk->rdev = rdev;
 
+		spin_lock(&conf->device_lock);
 		blk_queue_stack_limits(mddev->queue,
 				       rdev->bdev->bd_disk->queue);
+		spin_unlock(&conf->device_lock);
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, so limit ->max_sector to one PAGE, as
 		 * a one page request is never in violation.
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 42ee1a2..ee7df38 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -436,6 +436,10 @@ static int multipath_run (mddev_t *mddev)
 		goto out_free_conf;
 	}
 
+	spin_lock_init(&conf->device_lock);
+	/* blk-core uses queue_lock to verify protection of the queue flags */
+	mddev->queue->queue_lock = &conf->device_lock;
+
 	conf->working_disks = 0;
 	rdev_for_each(rdev, tmp, mddev) {
 		disk_idx = rdev->raid_disk;
@@ -446,8 +450,10 @@ static int multipath_run (mddev_t *mddev)
 		disk = conf->multipaths + disk_idx;
 		disk->rdev = rdev;
 
+		spin_lock(&conf->device_lock);
 		blk_queue_stack_limits(mddev->queue,
 				       rdev->bdev->bd_disk->queue);
+		spin_unlock(&conf->device_lock);
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, not that we ever expect a device with
 		 * a merge_bvec_fn to be involved in multipath */
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 818b482..deb5609 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -117,6 +117,10 @@ static int create_strip_zones (mddev_t *mddev)
 	if (!conf->devlist)
 		return 1;
 
+	spin_lock_init(&conf->device_lock);
+	/* blk-core uses queue_lock to verify protection of the queue flags */
+	mddev->queue->queue_lock = &conf->device_lock;
+
 	/* The first zone must contain all devices, so here we check that
 	 * there is a proper alignment of slots to devices and find them all
 	 */
@@ -138,8 +142,10 @@ static int create_strip_zones (mddev_t *mddev)
 		}
 		zone->dev[j] = rdev1;
 
+		spin_lock(&conf->device_lock);
 		blk_queue_stack_limits(mddev->queue,
 				       rdev1->bdev->bd_disk->queue);
+		spin_unlock(&conf->device_lock);
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, so limit ->max_sector to one PAGE, as
 		 * a one page request is never in violation.
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 6778b7c..a01fc7e 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1935,6 +1935,10 @@ static int run(mddev_t *mddev)
 	if (!conf->r1bio_pool)
 		goto out_no_mem;
 
+	spin_lock_init(&conf->device_lock);
+	/* blk-core uses queue_lock to verify protection of the queue flags */
+	mddev->queue->queue_lock = &conf->device_lock;
+
 	rdev_for_each(rdev, tmp, mddev) {
 		disk_idx = rdev->raid_disk;
 		if (disk_idx >= mddev->raid_disks
@@ -1944,8 +1948,10 @@ static int run(mddev_t *mddev)
 
 		disk->rdev = rdev;
 
+		spin_lock(&conf->device_lock);
 		blk_queue_stack_limits(mddev->queue,
 				       rdev->bdev->bd_disk->queue);
+		spin_unlock(&conf->device_lock);
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, so limit ->max_sector to one PAGE, as
 		 * a one page request is never in violation.
@@ -1958,7 +1964,6 @@ static int run(mddev_t *mddev)
 	}
 	conf->raid_disks = mddev->raid_disks;
 	conf->mddev = mddev;
-	spin_lock_init(&conf->device_lock);
 	INIT_LIST_HEAD(&conf->retry_list);
 
 	spin_lock_init(&conf->resync_lock);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5938fa9..c28af78 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2082,6 +2082,10 @@ static int run(mddev_t *mddev)
 		goto out_free_conf;
 	}
 
+	spin_lock_init(&conf->device_lock);
+	/* blk-core uses queue_lock to verify protection of the queue flags */
+	mddev->queue->queue_lock = &conf->device_lock;
+
 	rdev_for_each(rdev, tmp, mddev) {
 		disk_idx = rdev->raid_disk;
 		if (disk_idx >= mddev->raid_disks
@@ -2091,8 +2095,10 @@ static int run(mddev_t *mddev)
 
 		disk->rdev = rdev;
 
+		spin_lock(&conf->device_lock);
 		blk_queue_stack_limits(mddev->queue,
 				       rdev->bdev->bd_disk->queue);
+		spin_unlock(&conf->device_lock);
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, so limit ->max_sector to one PAGE, as
 		 * a one page request is never in violation.
@@ -2103,7 +2109,6 @@ static int run(mddev_t *mddev)
 
 		disk->head_position = 0;
 	}
-	spin_lock_init(&conf->device_lock);
 	INIT_LIST_HEAD(&conf->retry_list);
 
 	spin_lock_init(&conf->resync_lock);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ee0ea91..59964a7 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4257,6 +4257,8 @@ static int run(mddev_t *mddev)
 			goto abort;
 	}
 	spin_lock_init(&conf->device_lock);
+	/* blk-core uses queue_lock to verify protection of the queue flags */
+	mddev->queue->queue_lock = &conf->device_lock;
 	init_waitqueue_head(&conf->wait_for_stripe);
 	init_waitqueue_head(&conf->wait_for_overlap);
 	INIT_LIST_HEAD(&conf->handle_list);
diff --git a/include/linux/raid/linear.h b/include/linux/raid/linear.h
index ba15469..3c35e1e 100644
--- a/include/linux/raid/linear.h
+++ b/include/linux/raid/linear.h
@@ -18,7 +18,8 @@ struct linear_private_data
 	sector_t		hash_spacing;
 	sector_t		array_size;
 	int			preshift; /* shift before dividing by hash_spacing */
-	dev_info_t		disks[0];
+	spinlock_t		device_lock;
+	dev_info_t		disks[0]; /* grows depending on 'raid_disks' */
 };
 
 
diff --git a/include/linux/raid/raid0.h b/include/linux/raid/raid0.h
index 1b2dda0..3d20d14 100644
--- a/include/linux/raid/raid0.h
+++ b/include/linux/raid/raid0.h
@@ -21,6 +21,7 @@ struct raid0_private_data
 
 	sector_t hash_spacing;
 	int preshift;			/* shift this before divide by hash_spacing */
+	spinlock_t device_lock;
 };
 
 typedef struct raid0_private_data raid0_conf_t;



