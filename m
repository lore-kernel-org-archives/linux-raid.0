From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH v4 4/7] md: add sysfs entries for PPL
Date: Tue, 21 Feb 2017 20:43:58 +0100
Message-ID: <20170221194401.18733-5-artur.paszkiewicz@intel.com>
References: <20170221194401.18733-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170221194401.18733-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

Add 'consistency_policy' attribute for array. It indicates how the array
maintains consistency in case of unexpected shutdown.

Add 'ppl_sector' and 'ppl_size' for rdev, which describe the location
and size of the PPL space on the device. They can't be changed for
active members if the array is started and PPL is enabled, so in the
setter functions only basic checks are performed. More checks are done
in ppl_validate_rdev() when starting the log.

These attributes are writable to allow enabling PPL for external
metadata arrays and (later) to enable/disable PPL for a running array.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 Documentation/admin-guide/md.rst |  32 ++++++++++-
 drivers/md/md.c                  | 115 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 144 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/md.rst b/Documentation/admin-guide/md.rst
index 1e61bf50595c..84de718f24a4 100644
--- a/Documentation/admin-guide/md.rst
+++ b/Documentation/admin-guide/md.rst
@@ -276,14 +276,14 @@ All md devices contain:
      array creation it will default to 0, though starting the array as
      ``clean`` will set it much larger.
 
-   new_dev
+  new_dev
      This file can be written but not read.  The value written should
      be a block device number as major:minor.  e.g. 8:0
      This will cause that device to be attached to the array, if it is
      available.  It will then appear at md/dev-XXX (depending on the
      name of the device) and further configuration is then possible.
 
-   safe_mode_delay
+  safe_mode_delay
      When an md array has seen no write requests for a certain period
      of time, it will be marked as ``clean``.  When another write
      request arrives, the array is marked as ``dirty`` before the write
@@ -292,7 +292,7 @@ All md devices contain:
      period as a number of seconds.  The default is 200msec (0.200).
      Writing a value of 0 disables safemode.
 
-   array_state
+  array_state
      This file contains a single word which describes the current
      state of the array.  In many cases, the state can be set by
      writing the word for the desired state, however some states
@@ -401,7 +401,30 @@ All md devices contain:
      once the array becomes non-degraded, and this fact has been
      recorded in the metadata.
 
+  consistency_policy
+     This indicates how the array maintains consistency in case of unexpected
+     shutdown. It can be:
 
+     none
+       Array has no redundancy information, e.g. raid0, linear.
+
+     resync
+       Full resync is performed and all redundancy is regenerated when the
+       array is started after unclean shutdown.
+
+     bitmap
+       Resync assisted by a write-intent bitmap.
+
+     journal
+       For raid4/5/6, journal device is used to log transactions and replay
+       after unclean shutdown.
+
+     ppl
+       For raid5 only, Partial Parity Log is used to close the write hole and
+       eliminate resync.
+
+     The accepted values when writing to this file are ``ppl`` and ``resync``,
+     used to enable and disable PPL.
 
 
 As component devices are added to an md array, they appear in the ``md``
@@ -563,6 +586,9 @@ Each directory contains:
 	adds bad blocks without acknowledging them. This is largely
 	for testing.
 
+      ppl_sector, ppl_size
+        Location and size (in sectors) of the space used for Partial Parity Log
+        on this device.
 
 
 An active md device will also contain an entry for each active device
diff --git a/drivers/md/md.c b/drivers/md/md.c
index c2028007b209..3ff979d538d4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3157,6 +3157,78 @@ static ssize_t ubb_store(struct md_rdev *rdev, const char *page, size_t len)
 static struct rdev_sysfs_entry rdev_unack_bad_blocks =
 __ATTR(unacknowledged_bad_blocks, S_IRUGO|S_IWUSR, ubb_show, ubb_store);
 
+static ssize_t
+ppl_sector_show(struct md_rdev *rdev, char *page)
+{
+	return sprintf(page, "%llu\n", (unsigned long long)rdev->ppl.sector);
+}
+
+static ssize_t
+ppl_sector_store(struct md_rdev *rdev, const char *buf, size_t len)
+{
+	unsigned long long sector;
+
+	if (kstrtoull(buf, 10, &sector) < 0)
+		return -EINVAL;
+	if (sector != (sector_t)sector)
+		return -EINVAL;
+
+	if (rdev->mddev->pers && test_bit(MD_HAS_PPL, &rdev->mddev->flags) &&
+	    rdev->raid_disk >= 0)
+		return -EBUSY;
+
+	if (rdev->mddev->persistent) {
+		if (rdev->mddev->major_version == 0)
+			return -EINVAL;
+		if ((sector > rdev->sb_start &&
+		     sector - rdev->sb_start > S16_MAX) ||
+		    (sector < rdev->sb_start &&
+		     rdev->sb_start - sector > -S16_MIN))
+			return -EINVAL;
+		rdev->ppl.offset = sector - rdev->sb_start;
+	} else if (!rdev->mddev->external) {
+		return -EBUSY;
+	}
+	rdev->ppl.sector = sector;
+	return len;
+}
+
+static struct rdev_sysfs_entry rdev_ppl_sector =
+__ATTR(ppl_sector, S_IRUGO|S_IWUSR, ppl_sector_show, ppl_sector_store);
+
+static ssize_t
+ppl_size_show(struct md_rdev *rdev, char *page)
+{
+	return sprintf(page, "%u\n", rdev->ppl.size);
+}
+
+static ssize_t
+ppl_size_store(struct md_rdev *rdev, const char *buf, size_t len)
+{
+	unsigned int size;
+
+	if (kstrtouint(buf, 10, &size) < 0)
+		return -EINVAL;
+
+	if (rdev->mddev->pers && test_bit(MD_HAS_PPL, &rdev->mddev->flags) &&
+	    rdev->raid_disk >= 0)
+		return -EBUSY;
+
+	if (rdev->mddev->persistent) {
+		if (rdev->mddev->major_version == 0)
+			return -EINVAL;
+		if (size > U16_MAX)
+			return -EINVAL;
+	} else if (!rdev->mddev->external) {
+		return -EBUSY;
+	}
+	rdev->ppl.size = size;
+	return len;
+}
+
+static struct rdev_sysfs_entry rdev_ppl_size =
+__ATTR(ppl_size, S_IRUGO|S_IWUSR, ppl_size_show, ppl_size_store);
+
 static struct attribute *rdev_default_attrs[] = {
 	&rdev_state.attr,
 	&rdev_errors.attr,
@@ -3167,6 +3239,8 @@ static struct attribute *rdev_default_attrs[] = {
 	&rdev_recovery_start.attr,
 	&rdev_bad_blocks.attr,
 	&rdev_unack_bad_blocks.attr,
+	&rdev_ppl_sector.attr,
+	&rdev_ppl_size.attr,
 	NULL,
 };
 static ssize_t
@@ -4903,6 +4977,46 @@ static struct md_sysfs_entry md_array_size =
 __ATTR(array_size, S_IRUGO|S_IWUSR, array_size_show,
        array_size_store);
 
+static ssize_t
+consistency_policy_show(struct mddev *mddev, char *page)
+{
+	int ret;
+
+	if (test_bit(MD_HAS_JOURNAL, &mddev->flags)) {
+		ret = sprintf(page, "journal\n");
+	} else if (test_bit(MD_HAS_PPL, &mddev->flags)) {
+		ret = sprintf(page, "ppl\n");
+	} else if (mddev->bitmap) {
+		ret = sprintf(page, "bitmap\n");
+	} else if (mddev->pers) {
+		if (mddev->pers->sync_request)
+			ret = sprintf(page, "resync\n");
+		else
+			ret = sprintf(page, "none\n");
+	} else {
+		ret = sprintf(page, "unknown\n");
+	}
+
+	return ret;
+}
+
+static ssize_t
+consistency_policy_store(struct mddev *mddev, const char *buf, size_t len)
+{
+	if (mddev->pers) {
+		return -EBUSY;
+	} else if (mddev->external && strncmp(buf, "ppl", 3) == 0) {
+		set_bit(MD_HAS_PPL, &mddev->flags);
+		return len;
+	} else {
+		return -EINVAL;
+	}
+}
+
+static struct md_sysfs_entry md_consistency_policy =
+__ATTR(consistency_policy, S_IRUGO | S_IWUSR, consistency_policy_show,
+       consistency_policy_store);
+
 static struct attribute *md_default_attrs[] = {
 	&md_level.attr,
 	&md_layout.attr,
@@ -4918,6 +5032,7 @@ static struct attribute *md_default_attrs[] = {
 	&md_reshape_direction.attr,
 	&md_array_size.attr,
 	&max_corr_read_errors.attr,
+	&md_consistency_policy.attr,
 	NULL,
 };
 
-- 
2.11.0

