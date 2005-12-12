From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 016 of 20] Expose device slot information via sysfs
Date: Mon, 12 Dec 2005 14:15:34 +1100
Message-ID: <1051212031534.5173@suse.de>
References: <20051212135705.4561.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This the role that a device has in an array can be viewed
and set.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./Documentation/md.txt |    8 ++++++++
 ./drivers/md/md.c      |   35 +++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff ./Documentation/md.txt~current~ ./Documentation/md.txt
--- ./Documentation/md.txt~current~	2005-12-12 11:35:01.000000000 +1100
+++ ./Documentation/md.txt	2005-12-12 11:36:55.000000000 +1100
@@ -236,6 +236,14 @@ Each directory contains:
 	providing an ongoing count for arrays with metadata managed by
 	userspace.
 
+      slot
+        This gives the role that the device has in the array.  It will
+	either be 'none' if the device is not active in the array
+        (i.e. is a spare or has failed) or an integer less than the
+	'raid_disks' number for the array indicating which possition
+	it currently fills.  This can only be set while assembling an
+	array.  A device for which this is set is assumed to be working.
+
 
 An active md device will also contain and entry for each active device
 in the array.  These are named

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-12-12 11:36:25.000000000 +1100
+++ ./drivers/md/md.c	2005-12-12 11:37:12.000000000 +1100
@@ -1630,10 +1630,45 @@ errors_store(mdk_rdev_t *rdev, const cha
 static struct rdev_sysfs_entry rdev_errors =
 __ATTR(errors, 0644, errors_show, errors_store);
 
+static ssize_t
+slot_show(mdk_rdev_t *rdev, char *page)
+{
+	if (rdev->raid_disk < 0)
+		return sprintf(page, "none\n");
+	else
+		return sprintf(page, "%d\n", rdev->raid_disk);
+}
+
+static ssize_t
+slot_store(mdk_rdev_t *rdev, const char *buf, size_t len)
+{
+	char *e;
+	int slot = simple_strtoul(buf, &e, 10);
+	if (strncmp(buf, "none", 4)==0)
+		slot = -1;
+	else if (e==buf || (*e && *e!= '\n'))
+		return -EINVAL;
+	if (rdev->mddev->pers)
+		/* Cannot set slot in active array (yet) */
+		return -EBUSY;
+	if (slot >= rdev->mddev->raid_disks)
+		return -ENOSPC;
+	rdev->raid_disk = slot;
+	/* assume it is working */
+	rdev->flags = 0;
+	set_bit(In_sync, &rdev->flags);
+	return len;
+}
+
+
+static struct rdev_sysfs_entry rdev_slot =
+__ATTR(slot, 0644, slot_show, slot_store);
+
 static struct attribute *rdev_default_attrs[] = {
 	&rdev_state.attr,
 	&rdev_super.attr,
 	&rdev_errors.attr,
+	&rdev_slot.attr,
 	NULL,
 };
 static ssize_t
