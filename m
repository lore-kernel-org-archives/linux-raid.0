From: NeilBrown <neilb@suse.de>
Subject: [PATCH 013 of 13] md: Support suspending of IO to regions of an md array.
Date: Fri, 17 Mar 2006 15:48:30 +1100
Message-ID: <1060317044830.16246@suse.de>
References: <20060317154017.15880.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


This allows user-space to access data safely.
This is needed for raid5 reshape as user-space needs to take
a backup of the first few stripes before allowing reshape
to commense.
It will also be useful in cluster-aware raid1 configurations
so that all cluster members can leave a section of the array untouched
while a resync/recovery happens.

A 'start' and 'end' of the suspended range are written to 2 sysfs
attributes.  Note that only one range can be suspended at a time.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c           |   59 ++++++++++++++++++++++++++++++++++++++++++++
 ./drivers/md/raid5.c        |   14 ++++++++++
 ./include/linux/raid/md_k.h |    4 ++
 3 files changed, 77 insertions(+)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2006-03-17 11:48:59.000000000 +1100
+++ ./drivers/md/md.c	2006-03-17 11:48:59.000000000 +1100
@@ -2360,6 +2360,63 @@ sync_completed_show(mddev_t *mddev, char
 static struct md_sysfs_entry
 md_sync_completed = __ATTR_RO(sync_completed);
 
+static ssize_t
+suspend_lo_show(mddev_t *mddev, char *page)
+{
+	return sprintf(page, "%llu\n", (unsigned long long)mddev->suspend_lo);
+}
+
+static ssize_t
+suspend_lo_store(mddev_t *mddev, const char *buf, size_t len)
+{
+	char *e;
+	unsigned long long new = simple_strtoull(buf, &e, 10);
+
+	if (mddev->pers->quiesce == NULL)
+		return -EINVAL;
+	if (buf == e || (*e && *e != '\n'))
+		return -EINVAL;
+	if (new >= mddev->suspend_hi ||
+	    (new > mddev->suspend_lo && new < mddev->suspend_hi)) {
+		mddev->suspend_lo = new;
+		mddev->pers->quiesce(mddev, 2);
+		return len;
+	} else
+		return -EINVAL;
+}
+static struct md_sysfs_entry md_suspend_lo =
+__ATTR(suspend_lo, S_IRUGO|S_IWUSR, suspend_lo_show, suspend_lo_store);
+
+
+static ssize_t
+suspend_hi_show(mddev_t *mddev, char *page)
+{
+	return sprintf(page, "%llu\n", (unsigned long long)mddev->suspend_hi);
+}
+
+static ssize_t
+suspend_hi_store(mddev_t *mddev, const char *buf, size_t len)
+{
+	char *e;
+	unsigned long long new = simple_strtoull(buf, &e, 10);
+
+	if (mddev->pers->quiesce == NULL)
+		return -EINVAL;
+	if (buf == e || (*e && *e != '\n'))
+		return -EINVAL;
+	if ((new <= mddev->suspend_lo && mddev->suspend_lo >= mddev->suspend_hi) ||
+	    (new > mddev->suspend_lo && new > mddev->suspend_hi)) {
+		mddev->suspend_hi = new;
+		mddev->pers->quiesce(mddev, 1);
+		mddev->pers->quiesce(mddev, 0);
+		return len;
+	} else
+		return -EINVAL;
+}
+static struct md_sysfs_entry md_suspend_hi =
+__ATTR(suspend_hi, S_IRUGO|S_IWUSR, suspend_hi_show, suspend_hi_store);
+
+
 static struct attribute *md_default_attrs[] = {
 	&md_level.attr,
 	&md_raid_disks.attr,
@@ -2377,6 +2434,8 @@ static struct attribute *md_redundancy_a
 	&md_sync_max.attr,
 	&md_sync_speed.attr,
 	&md_sync_completed.attr,
+	&md_suspend_lo.attr,
+	&md_suspend_hi.attr,
 	NULL,
 };
 static struct attribute_group md_redundancy_group = {

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2006-03-17 11:48:59.000000000 +1100
+++ ./drivers/md/raid5.c	2006-03-17 11:48:59.000000000 +1100
@@ -1790,6 +1790,15 @@ static int make_request(request_queue_t 
 					goto retry;
 				}
 			}
+			/* FIXME what if we get a false positive because these
+			 * are being updated.
+			 */
+			if (logical_sector >= mddev->suspend_lo &&
+			    logical_sector < mddev->suspend_hi) {
+				release_stripe(sh);
+				schedule();
+				goto retry;
+			}
 
 			if (test_bit(STRIPE_EXPANDING, &sh->state) ||
 			    !add_stripe_bio(sh, bi, dd_idx, (bi->bi_rw&RW_MASK))) {
@@ -2708,6 +2717,10 @@ static void raid5_quiesce(mddev_t *mddev
 	raid5_conf_t *conf = mddev_to_conf(mddev);
 
 	switch(state) {
+	case 2: /* resume for a suspend */
+		wake_up(&conf->wait_for_overlap);
+		break;
+
 	case 1: /* stop all writes */
 		spin_lock_irq(&conf->device_lock);
 		conf->quiesce = 1;
@@ -2721,6 +2734,7 @@ static void raid5_quiesce(mddev_t *mddev
 		spin_lock_irq(&conf->device_lock);
 		conf->quiesce = 0;
 		wake_up(&conf->wait_for_stripe);
+		wake_up(&conf->wait_for_overlap);
 		spin_unlock_irq(&conf->device_lock);
 		break;
 	}

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2006-03-17 11:48:59.000000000 +1100
+++ ./include/linux/raid/md_k.h	2006-03-17 11:48:59.000000000 +1100
@@ -151,6 +151,10 @@ struct mddev_s
 	sector_t			resync_mismatches; /* count of sectors where
 							    * parity/replica mismatch found
 							    */
+
+	/* allow user-space to request suspension of IO to regions of the array */
+	sector_t			suspend_lo;
+	sector_t			suspend_hi;
 	/* if zero, use the system-wide default */
 	int				sync_speed_min;
 	int				sync_speed_max;
