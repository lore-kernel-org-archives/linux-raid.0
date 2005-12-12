From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 011 of 20] Expose md metadata format in sysfs.
Date: Mon, 12 Dec 2005 14:15:08 +1100
Message-ID: <1051212031508.5095@suse.de>
References: <20051212135705.4561.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Allow it to be set to a particular version, or 'none'.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./Documentation/md.txt |    6 ++++++
 ./drivers/md/md.c      |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff ./Documentation/md.txt~current~ ./Documentation/md.txt
--- ./Documentation/md.txt~current~	2005-12-12 11:31:46.000000000 +1100
+++ ./Documentation/md.txt	2005-12-12 11:33:02.000000000 +1100
@@ -183,6 +183,12 @@ All md devices contain:
      the array if the personality supports it (raid1, raid5, raid6),
      and if the component drives are large enough.
 
+  metadata_version
+     This indicates the format that is being used to record metadata
+     about the array.  It can be 0.90 (traditional format), 1.0, 1.1,
+     1.2 (newer format in varying locations) or "none" indicating that
+     the kernel isn't managing metadata at all.
+
 As component devices are added to an md array, they appear in the 'md'
 directory as new directories named
       dev-XXX

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-12-12 11:32:28.000000000 +1100
+++ ./drivers/md/md.c	2005-12-12 11:33:24.000000000 +1100
@@ -1857,6 +1857,54 @@ size_store(mddev_t *mddev, const char *b
 static struct md_sysfs_entry md_size =
 __ATTR(component_size, 0644, size_show, size_store);
 
+
+/* Metdata version.
+ * This is either 'none' for arrays with externally managed metadata,
+ * or N.M for internally known formats
+ */
+static ssize_t
+metadata_show(mddev_t *mddev, char *page)
+{
+	if (mddev->persistent)
+		return sprintf(page, "%d.%d\n",
+			       mddev->major_version, mddev->minor_version);
+	else
+		return sprintf(page, "none\n");
+}
+
+static ssize_t
+metadata_store(mddev_t *mddev, const char *buf, size_t len)
+{
+	int major, minor;
+	char *e;
+	if (!list_empty(&mddev->disks))
+		return -EBUSY;
+
+	if (cmd_match(buf, "none")) {
+		mddev->persistent = 0;
+		mddev->major_version = 0;
+		mddev->minor_version = 90;
+		return len;
+	}
+	major = simple_strtoul(buf, &e, 10);
+	if (e==buf || *e != '.')
+		return -EINVAL;
+	buf = e+1;
+	minor = simple_strtoul(buf, &e, 10);
+	if (e==buf || *e != '\n')
+		return -EINVAL;
+	if (major >= sizeof(super_types)/sizeof(super_types[0]) ||
+	    super_types[major].name == NULL)
+		return -ENOENT;
+	mddev->major_version = major;
+	mddev->minor_version = minor;
+	mddev->persistent = 1;
+	return len;
+}
+
+static struct md_sysfs_entry md_metadata =
+__ATTR(metadata_version, 0644, metadata_show, metadata_store);
+
 static ssize_t
 action_show(mddev_t *mddev, char *page)
 {
@@ -1926,6 +1974,7 @@ static struct attribute *md_default_attr
 	&md_raid_disks.attr,
 	&md_chunk_size.attr,
 	&md_size.attr,
+	&md_metadata.attr,
 	NULL,
 };
 
