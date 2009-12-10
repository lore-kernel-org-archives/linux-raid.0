From: Neil Brown <neilb@suse.de>
Subject: Re: [md PATCH 14/22] md: support updating bitmap parameters via
 sysfs.
Date: Thu, 10 Dec 2009 17:14:59 +1100
Message-ID: <20091210171459.6aee086f@notabene.brown>
References: <20091204064559.10264.37619.stgit@notabene.brown>
	<20091204064802.10264.47719.stgit@notabene.brown>
	<20091208102943.GZ21495@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091208102943.GZ21495@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 8 Dec 2009 11:29:43 +0100
Andre Noll <maan@systemlinux.org> wrote:

Thanks for the very thorough review.

I think I have address all your issues - see below.

> > +		/* No bitmap, OK to set a location */
> > +		long long offset;
> > +		if (strncmp(buf, "none", 4) == 0)
> > +			/* nothing to be done */;
> > +		else if (strncmp(buf, "file:", 5) == 0) {
> > +			/* Not supported yet */
> > +			return -EINVAL;
> > +		} else {
> > +			int rv;
> > +			if (buf[0] == '+')
> > +				rv = strict_strtoll(buf+1, 10, &offset);
> > +			else
> > +				rv = strict_strtoll(buf, 10, &offset);
> > +			if (rv)
> > +				return rv;
> > +			mddev->bitmap_info.offset = offset;
> 
> Introducing a sanity check here would probably save some sysadmin's
> feet.

What sort of sanity check did you have in mind.  When we come to
write out bitmap data a sanity check is performed and if there is
any overlap the bitmap is disabled.

But sysadmins shouldn't really be touching this directly - that is what mdadm
is (or will be) for.



> > +
> > +int strict_strtoul_scaled(const char *cp, unsigned long *res, int scale)
> > +{
> > +	unsigned long result = 0;
> > +	long decimals = -1;
> > +	while (isdigit(*cp) || (*cp == '.' && decimals < 0)) {
> > +		if (*cp == '.')
> > +			decimals = 0;
> > +		else if (decimals < scale) {
> > +			unsigned int value;
> > +			value = *cp - '0';
> > +			result = result * 10 + value;
> > +			if (decimals >= 0)
> > +				decimals++;
> > +		}
> > +		cp++;
> > +	}
> > +	if (*cp == '\n')
> > +		cp++;
> > +	if (*cp)
> > +		return -EINVAL;
> > +	if (decimals < 0)
> > +		decimals = 0;
> > +	while (decimals < scale) {
> > +		result *= 10;
> > +		decimals ++;
> > +	}
> > +	*res = result;
> > +	return 0;
> > +}
> 
> A comment which describes what exactly this function is supposed to
> to would be nice. It has only one caller and could be made static BTW.
> OTOH, it probably belongs to lib/vsprintf.c.

I've created a separate patch which factors this code out of
safe_delay_store and makes it a global function in md.c
So the bitmap patch just uses that function.
I guess I could move it to lib/vsprintf.c....



> This might overflow. But maybe that's OK as only insane values (written
> by root) will cause an overflow.
> 
> > +
> > +	if (timeout > MAX_SCHEDULE_TIMEOUT)
> > +		timeout = MAX_SCHEDULE_TIMEOUT;
> > +	if (timeout < 1)
> > +		timeout = 1;
> > +	mddev->bitmap_info.daemon_sleep = timeout;
> > +	if (mddev->thread) {
> > +		if (mddev->thread->timeout < MAX_SCHEDULE_TIMEOUT) {
> > +			mddev->thread->timeout = timeout;
> > +			md_wakeup_thread(mddev->thread);
> > +		}
> 
> I don't get this. Why do we want to set mddev->thread->timeout only
> if mddev->thread->timeout < MAX_SCHEDULE_TIMEOUT)?

If mddev->thread->timeout is MAX_SCHEDULE_TIMEOUT then the bitmap is
currently idle (it is all clean) so there is no need to wake up any time soon.

> 
> Also, if the timeout is being set while the array is stopped, the
> command succeeds but has no effect (as mddev->thread is NULL). Maybe
> it's better to return an error in this case.

No - bitmap_info.daemon_sleep is always set.  This is the important part of
the function.  This "if (mddev->thread) {" branch is just to ensure it takes
effect instantly instead of soon.

Thanks for all your very helpful comments.
Here is the new version.

NeilBrown

From 9ebade9bec51bb65559e1fb56fa875dfbadaacf5 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Tue, 1 Dec 2009 17:49:54 +1100
Subject: [PATCH] md: support updating bitmap parameters via sysfs.

A new attribute directory 'bitmap' in 'md' is created which
contains files for configuring the bitmap.
'location' identifies where the bitmap is, either 'none',
or 'file' or 'sector offset from metadata'.
Writing 'location' can create or remove a bitmap.
Adding a 'file' bitmap this way is not yet supported.
'chunksize' and 'time_base' must be set before 'location'
can be set.

'chunksize' can be set before creating a bitmap, but is
currently always over-ridden by the bitmap superblock.

'time_base' and 'backlog' can be updated at any time.


Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Andre Noll <maan@systemlinux.org>
---
 Documentation/md.txt |   29 +++++++
 drivers/md/bitmap.c  |  206 ++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/md.c      |    3 +
 drivers/md/md.h      |    2 +-
 4 files changed, 239 insertions(+), 1 deletions(-)

diff --git a/Documentation/md.txt b/Documentation/md.txt
index 4edd39e..18fad68 100644
--- a/Documentation/md.txt
+++ b/Documentation/md.txt
@@ -296,6 +296,35 @@ All md devices contain:
      active-idle
          like active, but no writes have been seen for a while (safe_mode_delay).
 
+  bitmap/location
+     This indicates where the write-intent bitmap for the array is
+     stored.
+     It can be one of "none", "file" or "[+-]N".
+     "file" may later be extended to "file:/file/name"
+     "[+-]N" means that many sectors from the start of the metadata.
+       This is replicated on all devices.  For arrays with externally
+       managed metadata, the offset is from the beginning of the
+       device.
+  bitmap/chunksize
+     The size, in bytes, of the chunk which will be represented by a
+     single bit.  For RAID456, it is a portion of an individual
+     device. For RAID10, it is a portion of the array.  For RAID1, it
+     is both (they come to the same thing).
+  bitmap/time_base
+     The time, in seconds, between looking for bits in the bitmap to
+     be cleared. In the current implementation, a bit will be cleared
+     between 2 and 3 times "time_base" after all the covered blocks
+     are known to be in-sync.
+  bitmap/backlog
+     When write-mostly devices are active in a RAID1, write requests
+     to those devices proceed in the background - the filesystem (or
+     other user of the device) does not have to wait for them.
+     'backlog' sets a limit on the number of concurrent background
+     writes.  If there are more than this, new writes will by
+     synchronous.
+     
+     
+     
 
 As component devices are added to an md array, they appear in the 'md'
 directory as new directories named
diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 9588654..3ff7c5c 100644
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
@@ -1714,6 +1718,208 @@ int bitmap_create(mddev_t *mddev)
 	return err;
 }
 
+static ssize_t
+location_show(mddev_t *mddev, char *page)
+{
+	ssize_t len;
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
+			if (offset == 0)
+				return -EINVAL;
+			if (mddev->major_version == 0 &&
+			    offset != mddev->bitmap_info.default_offset)
+				return -EINVAL;
+			mddev->bitmap_info.offset = offset;
+			if (mddev->pers) {
+				mddev->pers->quiesce(mddev, 1);
+				rv = bitmap_create(mddev);
+				if (rv) {
+					bitmap_destroy(mddev);
+					mddev->bitmap_info.offset = 0;
+				}
+				mddev->pers->quiesce(mddev, 0);
+				if (rv)
+					return rv;
+			}
+		}
+	}
+	if (!mddev->external) {
+		/* Ensure new bitmap info is stored in
+		 * metadata promptly.
+		 */
+		set_bit(MD_CHANGE_DEVS, &mddev->flags);
+		md_wakeup_thread(mddev->thread);
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
+	ssize_t len;
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
+static ssize_t
+timeout_store(mddev_t *mddev, const char *buf, size_t len)
+{
+	/* timeout can be set at any time */
+	unsigned long timeout;
+	int rv = strict_strtoul_scaled(buf, &timeout, 4);
+	if (rv)
+		return rv;
+
+	/* just to make sure we don't overflow... */
+	if (timeout >= LONG_MAX / HZ)
+		return -EINVAL;
+
+	timeout = timeout * HZ / 10000;
+
+	if (timeout >= MAX_SCHEDULE_TIMEOUT)
+		timeout = MAX_SCHEDULE_TIMEOUT-1;
+	if (timeout < 1)
+		timeout = 1;
+	mddev->bitmap_info.daemon_sleep = timeout;
+	if (mddev->thread) {
+		/* if thread->timeout is MAX_SCHEDULE_TIMEOUT, then
+		 * the bitmap is all clean and we don't need to
+		 * adjust the timeout right now
+		 */
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
+		return -EINVAL;
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
index 29a935b..4ac1984 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4034,6 +4034,7 @@ static void mddev_delayed_delete(struct work_struct *ws)
 		mddev->sysfs_action = NULL;
 		mddev->private = NULL;
 	}
+	sysfs_remove_group(&mddev->kobj, &md_bitmap_group);
 	kobject_del(&mddev->kobj);
 	kobject_put(&mddev->kobj);
 }
@@ -4125,6 +4126,8 @@ static int md_alloc(dev_t dev, char *name)
 		       disk->disk_name);
 		error = 0;
 	}
+	if (sysfs_create_group(&mddev->kobj, &md_bitmap_group))
+		printk(KERN_DEBUG "pointless warning\n");
  abort:
 	mutex_unlock(&disks_mutex);
 	if (!error) {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ed91c39..7c3e86e 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -372,7 +372,7 @@ struct md_sysfs_entry {
 	ssize_t (*show)(mddev_t *, char *);
 	ssize_t (*store)(mddev_t *, const char *, size_t);
 };
-
+extern struct attribute_group md_bitmap_group;
 
 static inline char * mdname (mddev_t * mddev)
 {
-- 
1.6.5.4

