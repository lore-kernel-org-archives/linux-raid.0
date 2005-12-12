From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 017 of 20] Export rdev->data_offset via sysfs
Date: Mon, 12 Dec 2005 14:15:44 +1100
Message-ID: <1051212031544.5200@suse.de>
References: <20051212135705.4561.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids




Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./Documentation/md.txt |    6 ++++++
 ./drivers/md/md.c      |   23 +++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff ./Documentation/md.txt~current~ ./Documentation/md.txt
--- ./Documentation/md.txt~current~	2005-12-12 11:36:55.000000000 +1100
+++ ./Documentation/md.txt	2005-12-12 11:37:32.000000000 +1100
@@ -244,6 +244,12 @@ Each directory contains:
 	it currently fills.  This can only be set while assembling an
 	array.  A device for which this is set is assumed to be working.
 
+      offset
+        This gives the location in the device (in sectors from the
+        start) where data from the array will be stored.  Any part of
+        the device before this offset us not touched, unless it is
+        used for storing metadata (Formats 1.1 and 1.2).
+
 
 An active md device will also contain and entry for each active device
 in the array.  These are named

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-12-12 11:37:12.000000000 +1100
+++ ./drivers/md/md.c	2005-12-12 11:37:48.000000000 +1100
@@ -1664,11 +1664,34 @@ slot_store(mdk_rdev_t *rdev, const char 
 static struct rdev_sysfs_entry rdev_slot =
 __ATTR(slot, 0644, slot_show, slot_store);
 
+static ssize_t
+offset_show(mdk_rdev_t *rdev, char *page)
+{
+	return sprintf(page, "%llu\n", rdev->data_offset);
+}
+
+static ssize_t
+offset_store(mdk_rdev_t *rdev, const char *buf, size_t len)
+{
+	char *e;
+	unsigned long long offset = simple_strtoull(buf, &e, 10);
+	if (e==buf || (*e && *e != '\n'))
+		return -EINVAL;
+	if (rdev->mddev->pers)
+		return -EBUSY;
+	rdev->data_offset = offset;
+	return len;
+}
+
+static struct rdev_sysfs_entry rdev_offset =
+__ATTR(offset, 0644, offset_show, offset_store);
+
 static struct attribute *rdev_default_attrs[] = {
 	&rdev_state.attr,
 	&rdev_super.attr,
 	&rdev_errors.attr,
 	&rdev_slot.attr,
+	&rdev_offset.attr,
 	NULL,
 };
 static ssize_t
