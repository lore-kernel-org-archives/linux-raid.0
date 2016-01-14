From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] md/raid: only permit hot-add of compatible integrity
 profiles
Date: Wed, 13 Jan 2016 16:00:07 -0800
Message-ID: <20160114000007.14556.8837.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <874mei8bu8.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <874mei8bu8.fsf@notabene.neil.brown.name>
Sender: stable-owner@vger.kernel.org
To: neilb@suse.de
Cc: axboe@fb.com, Mike Snitzer <snitzer@redhat.com>, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, keith.busch@intel.com, hch@lst.de
List-Id: linux-raid.ids

It is not safe for an integrity profile to be changed while i/o is
in-flight in the queue.  Prevent adding new disks or otherwise online
spares to an array if the device has an incompatible integrity profile.

The original change to the blk_integrity_unregister implementation in
md, commmit c7bfced9a671 "md: suspend i/o during runtime
blk_integrity_unregister" introduced an immediate hang regression.

This policy of disallowing changes the integrity profile once one has
been established is shared with DM.

Here is an abbreviated log from a test run that:
1/ Creates a degraded raid1 with an integrity-enabled device (pmem0s) [   59.076127]
2/ Tries to add an integrity-disabled device (pmem1m) [   90.489209]
3/ Retries with an integrity-enabled device (pmem1s) [  205.671277]

[   59.076127] md/raid1:md0: active with 1 out of 2 mirrors
[   59.078302] md: data integrity enabled on md0
[..]
[   90.489209] md0: incompatible integrity profile for pmem1m
[..]
[  205.671277] md: super_written gets error=-5
[  205.677386] md/raid1:md0: Disk failure on pmem1m, disabling device.
[  205.677386] md/raid1:md0: Operation continuing on 1 devices.
[  205.683037] RAID1 conf printout:
[  205.684699]  --- wd:1 rd:2
[  205.685972]  disk 0, wo:0, o:1, dev:pmem0s
[  205.687562]  disk 1, wo:1, o:1, dev:pmem1s
[  205.691717] md: recovery of RAID array md0

Fixes: c7bfced9a671 ("md: suspend i/o during runtime blk_integrity_unregister")
Cc: <stable@vger.kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>
Reported-by: NeilBrown <neilb@suse.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/md.c        |   28 ++++++++++++++++------------
 drivers/md/md.h        |    2 +-
 drivers/md/multipath.c |    6 +++---
 drivers/md/raid1.c     |    6 +++---
 drivers/md/raid10.c    |    6 +++---
 5 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 61aacab424cf..b1e1f6b95782 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2017,28 +2017,32 @@ int md_integrity_register(struct mddev *mddev)
 }
 EXPORT_SYMBOL(md_integrity_register);
 
-/* Disable data integrity if non-capable/non-matching disk is being added */
-void md_integrity_add_rdev(struct md_rdev *rdev, struct mddev *mddev)
+/*
+ * Attempt to add an rdev, but only if it is consistent with the current
+ * integrity profile
+ */
+int md_integrity_add_rdev(struct md_rdev *rdev, struct mddev *mddev)
 {
 	struct blk_integrity *bi_rdev;
 	struct blk_integrity *bi_mddev;
+	char name[BDEVNAME_SIZE];
 
 	if (!mddev->gendisk)
-		return;
+		return 0;
 
 	bi_rdev = bdev_get_integrity(rdev->bdev);
 	bi_mddev = blk_get_integrity(mddev->gendisk);
 
 	if (!bi_mddev) /* nothing to do */
-		return;
-	if (rdev->raid_disk < 0) /* skip spares */
-		return;
-	if (bi_rdev && blk_integrity_compare(mddev->gendisk,
-					     rdev->bdev->bd_disk) >= 0)
-		return;
-	WARN_ON_ONCE(!mddev->suspended);
-	printk(KERN_NOTICE "disabling data integrity on %s\n", mdname(mddev));
-	blk_integrity_unregister(mddev->gendisk);
+		return 0;
+
+	if (blk_integrity_compare(mddev->gendisk, rdev->bdev->bd_disk) != 0) {
+		printk(KERN_NOTICE "%s: incompatible integrity profile for %s\n",
+				mdname(mddev), bdevname(rdev->bdev, name));
+		return -ENXIO;
+	}
+
+	return 0;
 }
 EXPORT_SYMBOL(md_integrity_add_rdev);
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ca0b643fe3c1..dfa57b41541b 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -657,7 +657,7 @@ extern void md_wait_for_blocked_rdev(struct md_rdev *rdev, struct mddev *mddev);
 extern void md_set_array_sectors(struct mddev *mddev, sector_t array_sectors);
 extern int md_check_no_bitmap(struct mddev *mddev);
 extern int md_integrity_register(struct mddev *mddev);
-extern void md_integrity_add_rdev(struct md_rdev *rdev, struct mddev *mddev);
+extern int md_integrity_add_rdev(struct md_rdev *rdev, struct mddev *mddev);
 extern int strict_strtoul_scaled(const char *cp, unsigned long *res, int scale);
 
 extern void mddev_init(struct mddev *mddev);
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 7331a80d89f1..0a72ab6e6c20 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -257,6 +257,9 @@ static int multipath_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 			disk_stack_limits(mddev->gendisk, rdev->bdev,
 					  rdev->data_offset << 9);
 
+			err = md_integrity_add_rdev(rdev, mddev);
+			if (err)
+				break;
 			spin_lock_irq(&conf->device_lock);
 			mddev->degraded--;
 			rdev->raid_disk = path;
@@ -264,9 +267,6 @@ static int multipath_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 			spin_unlock_irq(&conf->device_lock);
 			rcu_assign_pointer(p->rdev, rdev);
 			err = 0;
-			mddev_suspend(mddev);
-			md_integrity_add_rdev(rdev, mddev);
-			mddev_resume(mddev);
 			break;
 		}
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index e2169ff6e0f0..c4b913409226 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1589,6 +1589,9 @@ static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	if (mddev->recovery_disabled == conf->recovery_disabled)
 		return -EBUSY;
 
+	if (md_integrity_add_rdev(rdev, mddev))
+		return -ENXIO;
+
 	if (rdev->raid_disk >= 0)
 		first = last = rdev->raid_disk;
 
@@ -1632,9 +1635,6 @@ static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 			break;
 		}
 	}
-	mddev_suspend(mddev);
-	md_integrity_add_rdev(rdev, mddev);
-	mddev_resume(mddev);
 	if (mddev->queue && blk_queue_discard(bdev_get_queue(rdev->bdev)))
 		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
 	print_conf(conf);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 84e597e1c489..ce959b4ae4df 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1698,6 +1698,9 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	if (rdev->saved_raid_disk < 0 && !_enough(conf, 1, -1))
 		return -EINVAL;
 
+	if (md_integrity_add_rdev(rdev, mddev))
+		return -ENXIO;
+
 	if (rdev->raid_disk >= 0)
 		first = last = rdev->raid_disk;
 
@@ -1739,9 +1742,6 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 		rcu_assign_pointer(p->rdev, rdev);
 		break;
 	}
-	mddev_suspend(mddev);
-	md_integrity_add_rdev(rdev, mddev);
-	mddev_resume(mddev);
 	if (mddev->queue && blk_queue_discard(bdev_get_queue(rdev->bdev)))
 		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
 
