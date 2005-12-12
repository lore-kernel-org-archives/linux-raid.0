From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 020 of 20] Allow sync-speed to be controlled per-device
Date: Mon, 12 Dec 2005 14:15:58 +1100
Message-ID: <1051212031558.5244@suse.de>
References: <20051212135705.4561.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Also export current (average) speed and status in sysfs.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./Documentation/md.txt      |   22 ++++++++
 ./drivers/md/md.c           |  110 ++++++++++++++++++++++++++++++++++++++++++--
 ./include/linux/raid/md_k.h |    4 +
 3 files changed, 131 insertions(+), 5 deletions(-)

diff ./Documentation/md.txt~current~ ./Documentation/md.txt
--- ./Documentation/md.txt~current~	2005-12-12 12:12:50.000000000 +1100
+++ ./Documentation/md.txt	2005-12-12 12:12:53.000000000 +1100
@@ -207,6 +207,28 @@ All md devices contain:
      available.  It will then appear at md/dev-XXX (depending on the
      name of the device) and further configuration is then possible.
 
+   sync_speed_min
+   sync_speed_max
+     This are similar to /proc/sys/dev/raid/speed_limit_{min,max}
+     however they only apply to the particular array.
+     If no value has been written to these, of if the word 'system'
+     is written, then the system-wide value is used.  If a value,
+     in kibibytes-per-second is written, then it is used.
+     When the files are read, they show the currently active value
+     followed by "(local)" or "(system)" depending on whether it is
+     a locally set or system-wide value.
+
+   sync_completed
+     This shows the number of sectors that have been completed of
+     whatever the current sync_action is, followed by the number of
+     sectors in total that could need to be processed.  The two
+     numbers are separated by a '/'  thus effectively showing one
+     value, a fraction of the process that is complete.
+
+   sync_speed
+     This shows the current actual speed, in K/sec, of the current
+     sync_action.  It is averaged over the last 30 seconds.
+
 
 As component devices are added to an md array, they appear in the 'md'
 directory as new directories named

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-12-12 12:12:50.000000000 +1100
+++ ./drivers/md/md.c	2005-12-12 12:12:57.000000000 +1100
@@ -81,10 +81,22 @@ static DEFINE_SPINLOCK(pers_lock);
  * idle IO detection.
  *
  * you can change it via /proc/sys/dev/raid/speed_limit_min and _max.
+ * or /sys/block/mdX/md/sync_speed_{min,max}
  */
 
 static int sysctl_speed_limit_min = 1000;
 static int sysctl_speed_limit_max = 200000;
+static inline int speed_min(mddev_t *mddev)
+{
+	return mddev->sync_speed_min ?
+		mddev->sync_speed_min : sysctl_speed_limit_min;
+}
+
+static inline int speed_max(mddev_t *mddev)
+{
+	return mddev->sync_speed_max ?
+		mddev->sync_speed_max : sysctl_speed_limit_max;
+}
 
 static struct ctl_table_header *raid_table_header;
 
@@ -2197,6 +2209,90 @@ md_scan_mode = __ATTR(sync_action, S_IRU
 static struct md_sysfs_entry
 md_mismatches = __ATTR_RO(mismatch_cnt);
 
+static ssize_t
+sync_min_show(mddev_t *mddev, char *page)
+{
+	return sprintf(page, "%d (%s)\n", speed_min(mddev),
+		       mddev->sync_speed_min ? "local": "system");
+}
+
+static ssize_t
+sync_min_store(mddev_t *mddev, const char *buf, size_t len)
+{
+	int min;
+	char *e;
+	if (strncmp(buf, "system", 6)==0) {
+		mddev->sync_speed_min = 0;
+		return len;
+	}
+	min = simple_strtoul(buf, &e, 10);
+	if (buf == e || (*e && *e != '\n') || min <= 0)
+		return -EINVAL;
+	mddev->sync_speed_min = min;
+	return len;
+}
+
+static struct md_sysfs_entry md_sync_min =
+__ATTR(sync_speed_min, S_IRUGO|S_IWUSR, sync_min_show, sync_min_store);
+
+static ssize_t
+sync_max_show(mddev_t *mddev, char *page)
+{
+	return sprintf(page, "%d (%s)\n", speed_max(mddev),
+		       mddev->sync_speed_max ? "local": "system");
+}
+
+static ssize_t
+sync_max_store(mddev_t *mddev, const char *buf, size_t len)
+{
+	int max;
+	char *e;
+	if (strncmp(buf, "system", 6)==0) {
+		mddev->sync_speed_max = 0;
+		return len;
+	}
+	max = simple_strtoul(buf, &e, 10);
+	if (buf == e || (*e && *e != '\n') || max <= 0)
+		return -EINVAL;
+	mddev->sync_speed_max = max;
+	return len;
+}
+
+static struct md_sysfs_entry md_sync_max =
+__ATTR(sync_speed_max, S_IRUGO|S_IWUSR, sync_max_show, sync_max_store);
+
+
+static ssize_t
+sync_speed_show(mddev_t *mddev, char *page)
+{
+	unsigned long resync, dt, db;
+	resync = (mddev->curr_resync - atomic_read(&mddev->recovery_active));
+	dt = ((jiffies - mddev->resync_mark) / HZ);
+	if (!dt) dt++;
+	db = resync - (mddev->resync_mark_cnt);
+	return sprintf(page, "%ld\n", db/dt/2); /* K/sec */
+}
+
+static struct md_sysfs_entry
+md_sync_speed = __ATTR_RO(sync_speed);
+
+static ssize_t
+sync_completed_show(mddev_t *mddev, char *page)
+{
+	unsigned long max_blocks, resync;
+
+	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
+		max_blocks = mddev->resync_max_sectors;
+	else
+		max_blocks = mddev->size << 1;
+
+	resync = (mddev->curr_resync - atomic_read(&mddev->recovery_active));
+	return sprintf(page, "%lu / %lu\n", resync, max_blocks);
+}
+
+static struct md_sysfs_entry
+md_sync_completed = __ATTR_RO(sync_completed);
+
 static struct attribute *md_default_attrs[] = {
 	&md_level.attr,
 	&md_raid_disks.attr,
@@ -2210,6 +2306,10 @@ static struct attribute *md_default_attr
 static struct attribute *md_redundancy_attrs[] = {
 	&md_scan_mode.attr,
 	&md_mismatches.attr,
+	&md_sync_min.attr,
+	&md_sync_max.attr,
+	&md_sync_speed.attr,
+	&md_sync_completed.attr,
 	NULL,
 };
 static struct attribute_group md_redundancy_group = {
@@ -4425,10 +4525,10 @@ static void md_do_sync(mddev_t *mddev)
 
 	printk(KERN_INFO "md: syncing RAID array %s\n", mdname(mddev));
 	printk(KERN_INFO "md: minimum _guaranteed_ reconstruction speed:"
-		" %d KB/sec/disc.\n", sysctl_speed_limit_min);
+		" %d KB/sec/disc.\n", speed_min(mddev));
 	printk(KERN_INFO "md: using maximum available idle IO bandwidth "
 	       "(but not more than %d KB/sec) for reconstruction.\n",
-	       sysctl_speed_limit_max);
+	       speed_max(mddev));
 
 	is_mddev_idle(mddev); /* this also initializes IO event counters */
 	/* we don't use the checkpoint if there's a bitmap */
@@ -4469,7 +4569,7 @@ static void md_do_sync(mddev_t *mddev)
 
 		skipped = 0;
 		sectors = mddev->pers->sync_request(mddev, j, &skipped,
-					    currspeed < sysctl_speed_limit_min);
+					    currspeed < speed_min(mddev));
 		if (sectors == 0) {
 			set_bit(MD_RECOVERY_ERR, &mddev->recovery);
 			goto out;
@@ -4534,8 +4634,8 @@ static void md_do_sync(mddev_t *mddev)
 		currspeed = ((unsigned long)(io_sectors-mddev->resync_mark_cnt))/2
 			/((jiffies-mddev->resync_mark)/HZ +1) +1;
 
-		if (currspeed > sysctl_speed_limit_min) {
-			if ((currspeed > sysctl_speed_limit_max) ||
+		if (currspeed > speed_min(mddev)) {
+			if ((currspeed > speed_max(mddev)) ||
 					!is_mddev_idle(mddev)) {
 				msleep(500);
 				goto repeat;

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2005-12-12 12:12:50.000000000 +1100
+++ ./include/linux/raid/md_k.h	2005-12-12 12:12:53.000000000 +1100
@@ -143,6 +143,10 @@ struct mddev_s
 	sector_t			resync_mismatches; /* count of sectors where
 							    * parity/replica mismatch found
 							    */
+	/* if zero, use the system-wide default */
+	int				sync_speed_min;
+	int				sync_speed_max;
+
 	int				ok_start_degraded;
 	/* recovery/resync flags 
 	 * NEEDED:   we might need to start a resync/recover
