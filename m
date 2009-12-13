From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2/2] md: add 'recovery_start' sysfs attribute
Date: Sat, 12 Dec 2009 21:17:12 -0700
Message-ID: <20091213041711.12532.26335.stgit@dwillia2-linux.ch.intel.com>
References: <20091213041123.12532.15225.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091213041123.12532.15225.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: ed.ciechanowski@intel.com, marcin.labun@intel.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Enable external metadata arrays to manage rebuild checkpointing via a
md/recovery_start attribute that overrides rdev->recovery_offset.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 Documentation/md.txt |   15 +++++++++--
 drivers/md/md.c      |   69 +++++++++++++++++++++++++++++++++++++++++++-------
 drivers/md/md.h      |    1 +
 3 files changed, 72 insertions(+), 13 deletions(-)

diff --git a/Documentation/md.txt b/Documentation/md.txt
index 4edd39e..2b03814 100644
--- a/Documentation/md.txt
+++ b/Documentation/md.txt
@@ -233,9 +233,18 @@ All md devices contain:
 
   resync_start
      The point at which resync should start.  If no resync is needed,
-     this will be a very large number.  At array creation it will
-     default to 0, though starting the array as 'clean' will
-     set it much larger.
+     this will be a very large number (or 'none' since 2.6.30-rc1).  At
+     array creation it will default to 0, though starting the array as
+     'clean' will set it much larger.
+
+  recovery_start
+     The point at which recovery should start when rebuilding a degraded
+     array member.  This value overrides the 'recovery_offset' read from
+     the metadata.  Setting this value to zero tells md to use/report
+     the default recovery_offset read from the metadata.  This value
+     auto-resets itself to zero (default recovery_offset) after it has
+     been consumed by the recovery process.  This value cannot be
+     changed while a recovery is in-flight.
 
    new_dev
      This file can be written but not read.  The value written should
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3e8fb67..5f09d40 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2983,6 +2983,56 @@ resync_start_store(mddev_t *mddev, const char *buf, size_t len)
 static struct md_sysfs_entry md_resync_start =
 __ATTR(resync_start, S_IRUGO|S_IWUSR, resync_start_show, resync_start_store);
 
+static sector_t md_recovery_offset(mddev_t *mddev)
+{
+	/* this is sometimes called outside mddev_lock() hence the
+	 * rcu_read_lock()
+	 */
+	sector_t recovery_offset = MaxSector;
+	mdk_rdev_t *rdev;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(rdev, &mddev->disks, same_set)
+		if (rdev->raid_disk >= 0 &&
+		    !test_bit(Faulty, &rdev->flags) &&
+		    !test_bit(In_sync, &rdev->flags) &&
+		    rdev->recovery_offset < recovery_offset)
+			recovery_offset = rdev->recovery_offset;
+	rcu_read_unlock();
+
+	return recovery_offset;
+}
+
+static ssize_t recovery_start_show(mddev_t *mddev, char *page)
+{
+	unsigned long long recovery_start = mddev->recovery_start;
+
+	if (recovery_start == 0)
+		recovery_start = md_recovery_offset(mddev);
+
+	if (recovery_start == MaxSector)
+		return sprintf(page, "none\n");
+
+	return sprintf(page, "%llu\n", recovery_start);
+}
+
+static ssize_t recovery_start_store(mddev_t *mddev, const char *buf, size_t len)
+{
+	unsigned long long recovery_start;
+
+	if (strict_strtoull(buf, 10, &recovery_start))
+		return -EINVAL;
+
+	if (!mddev->ro || !mddev->degraded || md_recovery_offset(mddev) > 0)
+		return -EBUSY;
+
+	mddev->recovery_start = recovery_start;
+	return len;
+}
+
+static struct md_sysfs_entry md_recovery_start =
+__ATTR(recovery_start, S_IRUGO|S_IWUSR, recovery_start_show, recovery_start_store);
+
 /*
  * The array state can be:
  *
@@ -3788,6 +3838,7 @@ static struct attribute *md_default_attrs[] = {
 	&md_chunk_size.attr,
 	&md_size.attr,
 	&md_resync_start.attr,
+	&md_recovery_start.attr,
 	&md_metadata.attr,
 	&md_new_device.attr,
 	&md_safe_delay.attr,
@@ -4426,6 +4477,7 @@ out:
 		mddev->dev_sectors = 0;
 		mddev->raid_disks = 0;
 		mddev->recovery_cp = 0;
+		mddev->recovery_start = 0;
 		mddev->resync_min = 0;
 		mddev->resync_max = MaxSector;
 		mddev->reshape_position = MaxSector;
@@ -6338,18 +6390,15 @@ void md_do_sync(mddev_t *mddev)
 
 	} else if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
 		max_sectors = mddev->dev_sectors;
-	else {
+	else if (mddev->recovery_start) {
+		/* userspace requested override of rdev->recovery_offset */
+		max_sectors = mddev->dev_sectors;
+		j = mddev->recovery_start;
+		mddev->recovery_start = 0;
+	} else {
 		/* recovery follows the physical size of devices */
 		max_sectors = mddev->dev_sectors;
-		j = MaxSector;
-		rcu_read_lock();
-		list_for_each_entry_rcu(rdev, &mddev->disks, same_set)
-			if (rdev->raid_disk >= 0 &&
-			    !test_bit(Faulty, &rdev->flags) &&
-			    !test_bit(In_sync, &rdev->flags) &&
-			    rdev->recovery_offset < j)
-				j = rdev->recovery_offset;
-		rcu_read_unlock();
+		j = md_recovery_offset(mddev);
 	}
 
 	printk(KERN_INFO "md: %s of RAID array %s\n", desc, mdname(mddev));
diff --git a/drivers/md/md.h b/drivers/md/md.h
index f184b69..03a18b4 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -252,6 +252,7 @@ struct mddev_s
 	atomic_t			recovery_active; /* blocks scheduled, but not written */
 	wait_queue_head_t		recovery_wait;
 	sector_t			recovery_cp;
+	sector_t			recovery_start;	/* override rdev->recovery_offset */
 	sector_t			resync_min;	/* user requested sync
 							 * starts here */
 	sector_t			resync_max;	/* resync should pause

