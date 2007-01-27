From: Iustin Pop <iusty@k1024.org>
Subject: [PATCH 2.6.20-rc6] md: expose uuid and degraded attributes in sysfs
Date: Sat, 27 Jan 2007 02:59:48 +0100
Message-ID: <20070127015948.GA24479@teal.hq.k1024.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Iustin Pop <iusty@k1024.org>

This patch exposes the uuid and the degraded status of an assembled
array through sysfs.

The uuid is useful in the case when multiple arrays exist on a system
and userspace needs to identify them; currently, the only portable way
that I know of is using 'mdadm -D' on each device until the desired uuid
is found. Having the uuid visible in sysfs is much more cleaner, IMHO.
Note on the method to format the uuid: I'm not sure if this is the best
way, I've copied and transformed the one in print_sb.

The 'degraded' attribute is also useful to quickly determine if the
array is degraded, instead of, again, parsing 'mdadm -D' output or
relying on the other techniques (number of working devices against
number of defined devices, etc.). The md code already keeps track of
this attribute, so it's useful to export it.

Signed-off-by: Iustin Pop <iusty@k1024.org>
---

--- linux-2.6.20-rc6/drivers/md/md.c.orig	2007-01-27 02:31:11.496575360 +0100
+++ linux-2.6.20-rc6/drivers/md/md.c	2007-01-27 02:32:51.746741201 +0100
@@ -2856,6 +2856,22 @@
 static struct md_sysfs_entry md_suspend_hi =
 __ATTR(suspend_hi, S_IRUGO|S_IWUSR, suspend_hi_show, suspend_hi_store);
 
+static ssize_t
+uuid_show(mddev_t *mddev, char *page)
+{
+	__u32 *p = (__u32*)mddev->uuid;
+	return sprintf(page, "%08x:%08x:%08x:%08x\n", p[0], p[1], p[2], p[3]);
+}
+static struct md_sysfs_entry md_uuid =
+__ATTR_RO(uuid);
+
+static ssize_t
+degraded_show(mddev_t *mddev, char *page)
+{
+	return sprintf(page, "%i\n", mddev->degraded);
+}
+static struct md_sysfs_entry md_degraded =
+__ATTR_RO(degraded);
 
 static struct attribute *md_default_attrs[] = {
 	&md_level.attr,
@@ -2881,6 +2897,8 @@
 	&md_suspend_lo.attr,
 	&md_suspend_hi.attr,
 	&md_bitmap.attr,
+	&md_uuid.attr,
+	&md_degraded.attr,
 	NULL,
 };
 static struct attribute_group md_redundancy_group = {
