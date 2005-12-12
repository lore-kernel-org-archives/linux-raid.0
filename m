From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 018 of 20] Allow available size of component devices to be set via sysfs.
Date: Mon, 12 Dec 2005 14:15:48 +1100
Message-ID: <1051212031548.5212@suse.de>
References: <20051212135705.4561.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./Documentation/md.txt |    7 +++++++
 ./drivers/md/md.c      |   25 +++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff ./Documentation/md.txt~current~ ./Documentation/md.txt
--- ./Documentation/md.txt~current~	2005-12-12 11:37:32.000000000 +1100
+++ ./Documentation/md.txt	2005-12-12 11:38:02.000000000 +1100
@@ -250,6 +250,13 @@ Each directory contains:
         the device before this offset us not touched, unless it is
         used for storing metadata (Formats 1.1 and 1.2).
 
+      size
+        The amount of the device, after the offset, that can be used
+        for storage of data.  This will normally be the same as the
+	component_size.  This can be written while assembling an
+        array.  If a value less than the current component_size is
+        written, component_size will be reduced to this value.
+
 
 An active md device will also contain and entry for each active device
 in the array.  These are named

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-12-12 11:37:48.000000000 +1100
+++ ./drivers/md/md.c	2005-12-12 11:38:30.000000000 +1100
@@ -1686,12 +1686,37 @@ offset_store(mdk_rdev_t *rdev, const cha
 static struct rdev_sysfs_entry rdev_offset =
 __ATTR(offset, 0644, offset_show, offset_store);
 
+static ssize_t
+rdev_size_show(mdk_rdev_t *rdev, char *page)
+{
+	return sprintf(page, "%llu\n", rdev->size);
+}
+
+static ssize_t
+rdev_size_store(mdk_rdev_t *rdev, const char *buf, size_t len)
+{
+	char *e;
+	unsigned long long size = simple_strtoull(buf, &e, 10);
+	if (e==buf || (*e && *e != '\n'))
+		return -EINVAL;
+	if (rdev->mddev->pers)
+		return -EBUSY;
+	rdev->size = size;
+	if (size < rdev->mddev->size || rdev->mddev->size == 0)
+		rdev->mddev->size = size;
+	return len;
+}
+
+static struct rdev_sysfs_entry rdev_size =
+__ATTR(size, 0644, rdev_size_show, rdev_size_store);
+
 static struct attribute *rdev_default_attrs[] = {
 	&rdev_state.attr,
 	&rdev_super.attr,
 	&rdev_errors.attr,
 	&rdev_slot.attr,
 	&rdev_offset.attr,
+	&rdev_size.attr,
 	NULL,
 };
 static ssize_t
