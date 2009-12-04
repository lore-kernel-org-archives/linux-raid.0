From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 14/22] md: support updating bitmap parameters via sysfs.
Date: Fri, 04 Dec 2009 17:48:02 +1100
Message-ID: <20091204064802.10264.47719.stgit@notabene.brown>
References: <20091204064559.10264.37619.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091204064559.10264.37619.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

A new attribute directory 'bitmap' in 'md' is created which
contains files for configuring the bitmap.
'location' identifies where the bitmap is, either 'none',
or 'file' or 'sector offset from metadata'.
Writing 'location' can create or remove a bitmap.
Adding a 'file' bitmap this way is not yet supported.

'chunksize' can be set before creating a bitmap, but is
currently always over-ridden by the bitmap superblock.

'time_base' and 'backlog' can be updated at any time.


Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/bitmap.c |  214 +++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/md.c     |    3 +
 drivers/md/md.h     |    2 
 3 files changed, 218 insertions(+), 1 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 5b77e5c..0f3d9a8 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -27,6 +27,7 @@
 #include <linux/file.h>
 #include <linux/mount.h>
 #include <linux/buffer_head.h>
+#include <linux/ctype.h>
 #include "md.h"
 #include "bitmap.h"
 
@@ -510,6 +511,9 @@ void bitmap_update_sb(struct bitmap *bitmap)
 		bitmap->events_cleared = bitmap->mddev->events;
 		sb->events_cleared = cpu_to_le64(bitmap->events_cleared);
 	}
+	/* Just in case these have been changed via sysfs: */
+	sb->daemon_sleep = cpu_to_le32(bitmap->mddev->bitmap_info.daemon_sleep/HZ);
+	sb->write_behind = cpu_to_le32(bitmap->mddev->bitmap_info.max_write_behind);
 	kunmap_atomic(sb, KM_USER0);
 	write_page(bitmap, bitmap->sb_page, 1);
 }
@@ -1714,6 +1718,216 @@ int bitmap_create(mddev_t *mddev)
 	return err;
 }
 
+static ssize_t
+location_show(mddev_t *mddev, char *page)
+{
+	ssize_t len = 0;
+	if (mddev->bitmap_info.file) {
+		len = sprintf(page, "file");
+	} else if (mddev->bitmap_info.offset) {
+		len = sprintf(page, "%+lld", (long long)mddev->bitmap_info.offset);
+	} else
+		len = sprintf(page, "none");
+	len += sprintf(page+len, "\n");
+	return len;
+}
+
+static ssize_t
+location_store(mddev_t *mddev, const char *buf, size_t len)
+{
+
+	if (mddev->pers) {
+		if (!mddev->pers->quiesce)
+			return -EBUSY;
+		if (mddev->recovery || mddev->sync_thread)
+			return -EBUSY;
+	}
+
+	if (mddev->bitmap || mddev->bitmap_info.file ||
+	    mddev->bitmap_info.offset) {
+		/* bitmap already configured.  Only option is to clear it */
+		if (strncmp(buf, "none", 4) != 0)
+			return -EBUSY;
+		if (mddev->pers) {
+			mddev->pers->quiesce(mddev, 1);
+			bitmap_destroy(mddev);
+			mddev->pers->quiesce(mddev, 0);
+		}
+		mddev->bitmap_info.offset = 0;
+		if (mddev->bitmap_info.file) {
+			struct file *f = mddev->bitmap_info.file;
+			mddev->bitmap_info.file = NULL;
+			restore_bitmap_write_access(f);
+			fput(f);
+		}
+	} else {
+		/* No bitmap, OK to set a location */
+		long long offset;
+		if (strncmp(buf, "none", 4) == 0)
+			/* nothing to be done */;
+		else if (strncmp(buf, "file:", 5) == 0) {
+			/* Not supported yet */
+			return -EINVAL;
+		} else {
+			int rv;
+			if (buf[0] == '+')
+				rv = strict_strtoll(buf+1, 10, &offset);
+			else
+				rv = strict_strtoll(buf, 10, &offset);
+			if (rv)
+				return rv;
+			mddev->bitmap_info.offset = offset;
+			if (mddev->pers) {
+				mddev->pers->quiesce(mddev, 1);
+				rv = bitmap_create(mddev);
+				if (rv)
+					bitmap_destroy(mddev);
+				mddev->pers->quiesce(mddev, 0);
+				if (rv)
+					return rv;
+			}
+		}
+	}
+	return len;
+}
+
+static struct md_sysfs_entry bitmap_location =
+__ATTR(location, S_IRUGO|S_IWUSR, location_show, location_store);
+
+static ssize_t
+timeout_show(mddev_t *mddev, char *page)
+{
+	ssize_t len = 0;
+	unsigned long secs = mddev->bitmap_info.daemon_sleep / HZ;
+	unsigned long jifs = mddev->bitmap_info.daemon_sleep % HZ;
+	
+	len = sprintf(page, "%lu", secs);
+	if (jifs)
+		len += sprintf(page+len, ".%03u", jiffies_to_msecs(jifs));
+	len += sprintf(page+len, "\n");
+	return len;
+}
+
+int strict_strtoul_scaled(const char *cp, unsigned long *res, int scale)
+{
+	unsigned long result = 0;
+	long decimals = -1;
+	while (isdigit(*cp) || (*cp == '.' && decimals < 0)) {
+		if (*cp == '.')
+			decimals = 0;
+		else if (decimals < scale) {
+			unsigned int value;
+			value = *cp - '0';
+			result = result * 10 + value;
+			if (decimals >= 0)
+				decimals++;
+		}
+		cp++;
+	}
+	if (*cp == '\n')
+		cp++;
+	if (*cp)
+		return -EINVAL;
+	if (decimals < 0)
+		decimals = 0;
+	while (decimals < scale) {
+		result *= 10;
+		decimals ++;
+	}
+	*res = result;
+	return 0;
+}
+
+static ssize_t
+timeout_store(mddev_t *mddev, const char *buf, size_t len)
+{
+	/* timeout can be set at any time */
+	unsigned long timeout;
+	int rv = strict_strtoul_scaled(buf, &timeout, 4);
+	if (rv)
+		return rv;
+
+	timeout = timeout * HZ / 10000;
+
+	if (timeout > MAX_SCHEDULE_TIMEOUT)
+		timeout = MAX_SCHEDULE_TIMEOUT;
+	if (timeout < 1)
+		timeout = 1;
+	mddev->bitmap_info.daemon_sleep = timeout;
+	if (mddev->thread) {
+		if (mddev->thread->timeout < MAX_SCHEDULE_TIMEOUT) {
+			mddev->thread->timeout = timeout;
+			md_wakeup_thread(mddev->thread);
+		}
+	}
+	return len;
+}
+
+static struct md_sysfs_entry bitmap_timeout =
+__ATTR(time_base, S_IRUGO|S_IWUSR, timeout_show, timeout_store);
+
+static ssize_t
+backlog_show(mddev_t *mddev, char *page)
+{
+	return sprintf(page, "%lu\n", mddev->bitmap_info.max_write_behind);
+}
+
+static ssize_t
+backlog_store(mddev_t *mddev, const char *buf, size_t len)
+{
+	unsigned long backlog;
+	int rv = strict_strtoul(buf, 10, &backlog);
+	if (rv)
+		return rv;
+	if (backlog > COUNTER_MAX)
+		backlog = COUNTER_MAX;
+	mddev->bitmap_info.max_write_behind = backlog;
+	return len;
+}
+
+static struct md_sysfs_entry bitmap_backlog =
+__ATTR(backlog, S_IRUGO|S_IWUSR, backlog_show, backlog_store);
+
+static ssize_t
+chunksize_show(mddev_t *mddev, char *page)
+{
+	return sprintf(page, "%lu\n", mddev->bitmap_info.chunksize);
+}
+
+static ssize_t
+chunksize_store(mddev_t *mddev, const char *buf, size_t len)
+{
+	/* Can only be changed when no bitmap is active */
+	int rv;
+	unsigned long csize;
+	if (mddev->bitmap)
+		return -EBUSY;
+	rv = strict_strtoul(buf, 10, &csize);
+	if (rv)
+		return rv;
+	if (csize < 512 ||
+	    !is_power_of_2(csize))
+		return -EINVAL;
+	mddev->bitmap_info.chunksize = csize;
+	return len;
+}
+
+static struct md_sysfs_entry bitmap_chunksize =
+__ATTR(chunksize, S_IRUGO|S_IWUSR, chunksize_show, chunksize_store);
+
+static struct attribute *md_bitmap_attrs[] = {
+	&bitmap_location.attr,
+	&bitmap_timeout.attr,
+	&bitmap_backlog.attr,
+	&bitmap_chunksize.attr,
+	NULL
+};
+struct attribute_group md_bitmap_group = {
+	.name = "bitmap",
+	.attrs = md_bitmap_attrs,
+};
+
+
 /* the bitmap API -- for raid personalities */
 EXPORT_SYMBOL(bitmap_startwrite);
 EXPORT_SYMBOL(bitmap_endwrite);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9f797ac..fbff790 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4013,6 +4013,7 @@ static void mddev_delayed_delete(struct work_struct *ws)
 		mddev->sysfs_action = NULL;
 		mddev->private = NULL;
 	}
+	sysfs_remove_group(&mddev->kobj, &md_bitmap_group);
 	kobject_del(&mddev->kobj);
 	kobject_put(&mddev->kobj);
 }
@@ -4104,6 +4105,8 @@ static int md_alloc(dev_t dev, char *name)
 		       disk->disk_name);
 		error = 0;
 	}
+	if (sysfs_create_group(&mddev->kobj, &md_bitmap_group))
+		printk(KERN_DEBUG "pointless warning\n");
  abort:
 	mutex_unlock(&disks_mutex);
 	if (!error) {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index aa67532..05b91c3 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -370,7 +370,7 @@ struct md_sysfs_entry {
 	ssize_t (*show)(mddev_t *, char *);
 	ssize_t (*store)(mddev_t *, const char *, size_t);
 };
-
+extern struct attribute_group md_bitmap_group;
 
 static inline char * mdname (mddev_t * mddev)
 {


