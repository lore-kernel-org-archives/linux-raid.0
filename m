From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: WARNING in 2.6.25-07422-gb66e1f1
Date: Mon, 05 May 2008 11:03:31 -0700
Message-ID: <1210010611.18440.18.camel@dwillia2-linux.ch.intel.com>
References: <200805031151.44287.prakash@punnoor.de>
	 <481DB3F3.5080102@gmail.com><20080504183839.GN12774@kernel.dk>
	 <18462.46639.578272.994939@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18462.46639.578272.994939@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, Jacek Luczak <difrost.kernel@gmail.com>, Prakash Punnoor <prakash@punnoor.de>, Linux Kernel list <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Mon, 2008-05-05 at 00:24 -0700, Neil Brown wrote:
> On Sunday May 4, jens.axboe@oracle.com wrote:
> > On Sun, May 04 2008, Jacek Luczak wrote:
> > > Hi,
> > >
> > > I've CC:-ed few guys which may help.
> > >
> > > Prakash Punnoor pisze:
> > > > Hi, I got this on boot:
> > > >
> > > > usb 2-1.3: new full speed USB device using ehci_hcd and address 3
> > > > usb 2-1.3: configuration #1 chosen from 1 choice
> > > > Clocksource tsc unstable (delta = -117343945 ns)
> > > > ------------[ cut here ]------------
> > > > WARNING: at include/linux/blkdev.h:443 blk_remove_plug+0x7d/0x90()
> ...
> >
> > Looks like it caught a real bug there - unfortunately we have to check
> > for ->queue_lock here as well, if this is another stacked devices and
> > not the bottom device. Does this make the warning go away for you?
> >
[..]
> I suspect that will just cause more problems, as the 'q' for an md
> device never gets ->queue_lock initialised.
> I suspect the correct thing to do is set
>         q->queue_lock = &conf->device_lock;
> 
> at some stage, probably immediately after device_lock is initialised
> in 'run'.
> 
> I was discussing this with Dan Williams starting
>   http://marc.info/?l=linux-raid&m=120951839903995&w=4
> though we don't have an agreed patch yet.

The patch below appears to work for the raid5 case, but I am
encountering a new issue when testing linear arrays?  raid0/1/10 are not
triggering this issue.

$ mdadm --create /dev/md0 /dev/loop[0-3] -n 4 -l linear
mdadm: RUN_ARRAY failed: Invalid argument # huh?
mdadm: stopped /dev/md0
$ cat /proc/mdstat
Personalities : [raid0] [linear]
unused devices: <none>
$ mdadm --create /dev/md0 /dev/loop[0-3] -n 4 -l linear
Segmentation fault

[293399.915068] BUG: unable to handle kernel NULL pointer dereference at 00000000
[293399.931249] IP: [<c0441cfa>] find_usage_backwards+0x9c/0xb6
[293399.945735] *pde = 00000000
[293399.957323] Oops: 0000 [#1] SMP
[293399.968978] Modules linked in: raid456 async_xor async_memcpy async_tx xor linear loop ipt_MASQUERADE iptable_nat nf_nat bridge rfcomm l2cap bluetooth ]
[293400.093457]
[293400.105809] Pid: 30652, comm: mdadm Not tainted (2.6.25-imsm #63)
[293400.123339] EIP: 0060:[<c0441cfa>] EFLAGS: 00210046 CPU: 2
[293400.140261] EIP is at find_usage_backwards+0x9c/0xb6
[293400.156651] EAX: 00000002 EBX: 00000000 ECX: 00000001 EDX: 0000a9a8
[293400.174211] ESI: 00000000 EDI: d54f2400 EBP: d1db9ba8 ESP: d1db9b9c
[293400.191645]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[293400.207967] Process mdadm (pid: 30652, ti=d1db9000 task=e0f28000 task.ti=d1db9000)
[293400.216021] Stack: e0f284f0 e0f28000 00000004 d1db9bb8 c0441d2d e0f284f0 e0f28000 d1db9bd4
[293400.236094]        c0442032 c06d1fed 00000010 00200246 e0f284f0 d54f2400 d1db9c24 c0442b63
[293400.256296]        0000025d 00000002 00000000 00000000 f72cd3ec 00000001 e0f28000 00000000
[293400.276699] Call Trace:
[293400.302628]  [<c0441d2d>] ? check_usage_backwards+0x19/0x3b
[293400.320626]  [<c0442032>] ? mark_lock+0x228/0x399
[293400.337629]  [<c0442b63>] ? __lock_acquire+0x440/0xad5
[293400.355036]  [<c04421e4>] ? mark_held_locks+0x41/0x5c
[293400.372027]  [<c0408124>] ? native_sched_clock+0x8d/0x9f
[293400.389053]  [<c04435a2>] ? lock_acquire+0x57/0x73
[293400.405617]  [<f8cea220>] ? linear_conf+0xac/0x399 [linear]
[293400.422874]  [<c0628507>] ? _spin_lock+0x1c/0x49
[293400.439193]  [<f8cea220>] ? linear_conf+0xac/0x399 [linear]
[293400.456628]  [<f8cea220>] ? linear_conf+0xac/0x399 [linear]
[293400.474060]  [<c04421e4>] ? mark_held_locks+0x41/0x5c
[293400.491130]  [<c0627061>] ? __mutex_unlock_slowpath+0xe1/0xe9
[293400.509098]  [<c044093b>] ? lock_release_holdtime+0x3f/0x44
[293400.526942]  [<c059524c>] ? do_md_run+0x514/0x9ea
[293400.543989]  [<f8cea5e2>] ? linear_run+0x11/0x71 [linear]
[293400.561848]  [<c0595407>] ? do_md_run+0x6cf/0x9ea
[293400.579013]  [<c0628863>] ? _spin_unlock_irq+0x22/0x26
[293400.596696]  [<c04421e4>] ? mark_held_locks+0x41/0x5c
[293400.614585]  [<c0626f6c>] ? mutex_lock_interruptible_nested+0x25f/0x273
[293400.634244]  [<c044235f>] ? trace_hardirqs_on+0xe1/0x102
[293400.652580]  [<c0626f76>] ? mutex_lock_interruptible_nested+0x269/0x273
[293400.672573]  [<c0599249>] ? md_ioctl+0xb8/0xdc6
[293400.690261]  [<c0599d3d>] ? md_ioctl+0xbac/0xdc6
[293400.708073]  [<c0408124>] ? native_sched_clock+0x8d/0x9f
[293400.726798]  [<c044093b>] ? lock_release_holdtime+0x3f/0x44
[293400.745947]  [<c06289c2>] ? _spin_unlock_irqrestore+0x36/0x3c
[293400.765174]  [<c044235f>] ? trace_hardirqs_on+0xe1/0x102
[293400.783838]  [<c043acec>] ? down+0x2b/0x2f
[293400.801143]  [<c04e8035>] ? blkdev_driver_ioctl+0x49/0x5b
[293400.819931]  [<c04e8762>] ? blkdev_ioctl+0x71b/0x769
[293400.837909]  [<c0462006>] ? free_hot_cold_page+0x15c/0x185
[293400.856024]  [<c0408124>] ? native_sched_clock+0x8d/0x9f
[293400.873546]  [<c044093b>] ? lock_release_holdtime+0x3f/0x44
[293400.891111]  [<c06289c2>] ? _spin_unlock_irqrestore+0x36/0x3c
[293400.908540]  [<c044235f>] ? trace_hardirqs_on+0xe1/0x102
[293400.925100]  [<c049f217>] ? block_ioctl+0x16/0x1b
[293400.940642]  [<c049f201>] ? block_ioctl+0x0/0x1b
[293400.956000]  [<c04887d2>] ? vfs_ioctl+0x22/0x67
[293400.971108]  [<c0488a7b>] ? do_vfs_ioctl+0x264/0x27b
[293400.986610]  [<c0488ad2>] ? sys_ioctl+0x40/0x5a
[293401.001599]  [<c0403915>] ? sysenter_past_esp+0x6a/0xb1
[293401.017331]  =======================
[293401.031194] Code: 89 3d 30 86 a2 c0 b8 02 00 00 00 eb 33 8b 9f b4 00 00 00 eb 16 8b 43 08 8d 56 01 e8 6f ff ff ff 83 f8 02 74 1b 85 c0 74 17 8b 1b <8b>
[293401.073207] EIP: [<c0441cfa>] find_usage_backwards+0x9c/0xb6 SS:ESP 0068:d1db9b9c
[293401.121680] ---[ end trace 6a498ad836843586 ]---

---
md: tell blk-core about device_lock for protecting the queue flags

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
 include/linux/raid/linear.h |    1 +
 include/linux/raid/raid0.h  |    1 +
 8 files changed, 34 insertions(+), 2 deletions(-)


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
index ba15469..1bb90cf 100644
--- a/include/linux/raid/linear.h
+++ b/include/linux/raid/linear.h
@@ -19,6 +19,7 @@ struct linear_private_data
 	sector_t		array_size;
 	int			preshift; /* shift before dividing by hash_spacing */
 	dev_info_t		disks[0];
+	spinlock_t		device_lock;
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


