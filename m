From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 009 of 20] Allow chunk_size to be settable through sysfs
Date: Mon, 12 Dec 2005 14:14:58 +1100
Message-ID: <1051212031458.5063@suse.de>
References: <20051212135705.4561.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


... only before array is started of course.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./Documentation/md.txt |    8 ++++++++
 ./drivers/md/md.c      |   26 ++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff ./Documentation/md.txt~current~ ./Documentation/md.txt
--- ./Documentation/md.txt~current~	2005-12-12 11:30:58.000000000 +1100
+++ ./Documentation/md.txt	2005-12-12 11:31:25.000000000 +1100
@@ -166,6 +166,14 @@ All md devices contain:
      will be empty.  If an array is being resized (not currently
      possible) this will contain the larger of the old and new sizes.
 
+  chunk_size
+     This is the size if bytes for 'chunks' and is only relevant to
+     raid levels that involve striping (1,4,5,6,10). The address space
+     of the array is conceptually divided into chunks and consecutive
+     chunks are striped onto neighbouring devices.
+     The size should be atleast PAGE_SIZE (4k) and should be a power
+     of 2.  This can only be set while assembling an array
+
 As component devices are added to an md array, they appear in the 'md'
 directory as new directories named
       dev-XXX

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-12-12 11:30:58.000000000 +1100
+++ ./drivers/md/md.c	2005-12-12 11:31:25.000000000 +1100
@@ -1795,6 +1795,31 @@ raid_disks_show(mddev_t *mddev, char *pa
 static struct md_sysfs_entry md_raid_disks = __ATTR_RO(raid_disks);
 
 static ssize_t
+chunk_size_show(mddev_t *mddev, char *page)
+{
+	return sprintf(page, "%d\n", mddev->chunk_size);
+}
+
+static ssize_t
+chunk_size_store(mddev_t *mddev, const char *buf, size_t len)
+{
+	/* can only set chunk_size if array is not yet active */
+	char *e;
+	unsigned long n = simple_strtoul(buf, &e, 10);
+
+	if (mddev->pers)
+		return -EBUSY;
+	if (!*buf || (*e && *e != '\n'))
+		return -EINVAL;
+
+	mddev->chunk_size = n;
+	return len;
+}
+static struct md_sysfs_entry md_chunk_size =
+__ATTR(chunk_size, 0644, chunk_size_show, chunk_size_store);
+
+
+static ssize_t
 action_show(mddev_t *mddev, char *page)
 {
 	char *type = "idle";
@@ -1861,6 +1886,7 @@ md_mismatches = __ATTR_RO(mismatch_cnt);
 static struct attribute *md_default_attrs[] = {
 	&md_level.attr,
 	&md_raid_disks.attr,
+	&md_chunk_size.attr,
 	NULL,
 };
 
