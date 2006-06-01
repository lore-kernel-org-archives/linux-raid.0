From: NeilBrown <neilb@suse.de>
Subject: [PATCH 008 of 10] md: Allow raid 'layout' to be read and set via sysfs.
Date: Thu, 1 Jun 2006 15:14:08 +1000
Message-ID: <1060601051408.27637@suse.de>
References: <20060601150955.27444.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids




Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./Documentation/md.txt |    5 +++++
 ./drivers/md/md.c      |   27 +++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff ./Documentation/md.txt~current~ ./Documentation/md.txt
--- ./Documentation/md.txt~current~	2006-06-01 15:05:29.000000000 +1000
+++ ./Documentation/md.txt	2006-06-01 15:05:30.000000000 +1000
@@ -200,6 +200,11 @@ All md devices contain:
      This can be written only while the array is being assembled, not
      after it is started.
 
+  layout
+     The "layout" for the array for the particular level.  This is
+     simply a number that is interpretted differently by different
+     levels.  It can be written while assembling an array.
+
    new_dev
      This file can be written but not read.  The value written should
      be a block device number as major:minor.  e.g. 8:0

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2006-06-01 15:05:30.000000000 +1000
+++ ./drivers/md/md.c	2006-06-01 15:05:30.000000000 +1000
@@ -2155,6 +2155,32 @@ level_store(mddev_t *mddev, const char *
 static struct md_sysfs_entry md_level =
 __ATTR(level, 0644, level_show, level_store);
 
+
+static ssize_t
+layout_show(mddev_t *mddev, char *page)
+{
+	/* just a number, not meaningful for all levels */
+	return sprintf(page, "%d\n", mddev->layout);
+}
+
+static ssize_t
+layout_store(mddev_t *mddev, const char *buf, size_t len)
+{
+	char *e;
+	unsigned long n = simple_strtoul(buf, &e, 10);
+	if (mddev->pers)
+		return -EBUSY;
+
+	if (!*buf || (*e && *e != '\n'))
+		return -EINVAL;
+
+	mddev->layout = n;
+	return len;
+}
+static struct md_sysfs_entry md_layout =
+__ATTR(layout, 0655, layout_show, layout_store);
+
+
 static ssize_t
 raid_disks_show(mddev_t *mddev, char *page)
 {
@@ -2741,6 +2767,7 @@ __ATTR(suspend_hi, S_IRUGO|S_IWUSR, susp
 
 static struct attribute *md_default_attrs[] = {
 	&md_level.attr,
+	&md_layout.attr,
 	&md_raid_disks.attr,
 	&md_chunk_size.attr,
 	&md_size.attr,
