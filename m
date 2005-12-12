From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 019 of 20] Support adding new devices to md arrays via sysfs
Date: Mon, 12 Dec 2005 14:15:53 +1100
Message-ID: <1051212031553.5225@suse.de>
References: <20051212135705.4561.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Writing major:minor to md/new_dev will bind that device to the
array. 

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./Documentation/md.txt |    8 ++++++
 ./drivers/md/md.c      |   60 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff ./Documentation/md.txt~current~ ./Documentation/md.txt
--- ./Documentation/md.txt~current~	2005-12-12 11:57:28.000000000 +1100
+++ ./Documentation/md.txt	2005-12-12 11:57:31.000000000 +1100
@@ -200,6 +200,14 @@ All md devices contain:
      This can be written only while the array is being assembled, not
      after it is started.
 
+   new_dev
+     This file can be written but not read.  The value written should
+     be a block device number as major:minor.  e.g. 8:0
+     This will cause that device to be attached to the array, if it is
+     available.  It will then appear at md/dev-XXX (depending on the
+     name of the device) and further configuration is then possible.
+
+
 As component devices are added to an md array, they appear in the 'md'
 directory as new directories named
       dev-XXX

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-12-12 11:57:28.000000000 +1100
+++ ./drivers/md/md.c	2005-12-12 11:57:49.000000000 +1100
@@ -1987,6 +1987,65 @@ chunk_size_store(mddev_t *mddev, const c
 static struct md_sysfs_entry md_chunk_size =
 __ATTR(chunk_size, 0644, chunk_size_show, chunk_size_store);
 
+static ssize_t
+null_show(mddev_t *mddev, char *page)
+{
+	return -EINVAL;
+}
+
+static ssize_t
+new_dev_store(mddev_t *mddev, const char *buf, size_t len)
+{
+	/* buf must be %d:%d\n? giving major and minor numbers */
+	/* The new device is added to the array.
+	 * If the array has a persistent superblock, we read the
+	 * superblock to initialise info and check validity.
+	 * Otherwise, only checking done is that in bind_rdev_to_array,
+	 * which mainly checks size.
+	 */
+	char *e;
+	int major = simple_strtoul(buf, &e, 10);
+	int minor;
+	dev_t dev;
+	mdk_rdev_t *rdev;
+	int err;
+
+	if (!*buf || *e != ':' || !e[1] || e[1] == '\n')
+		return -EINVAL;
+	minor = simple_strtoul(e+1, &e, 10);
+	if (*e && *e != '\n')
+		return -EINVAL;
+	dev = MKDEV(major, minor);
+	if (major != MAJOR(dev) ||
+	    minor != MINOR(dev))
+		return -EOVERFLOW;
+
+
+	if (mddev->persistent) {
+		rdev = md_import_device(dev, mddev->major_version,
+					mddev->minor_version);
+		if (!IS_ERR(rdev) && !list_empty(&mddev->disks)) {
+			mdk_rdev_t *rdev0 = list_entry(mddev->disks.next,
+						       mdk_rdev_t, same_set);
+			err = super_types[mddev->major_version]
+				.load_super(rdev, rdev0, mddev->minor_version);
+			if (err < 0)
+				goto out;
+		}
+	} else
+		rdev = md_import_device(dev, -1, -1);
+
+	if (IS_ERR(rdev))
+		return PTR_ERR(rdev);
+	err = bind_rdev_to_array(rdev, mddev);
+ out:
+	if (err)
+		export_rdev(rdev);
+	return err ? err : len;
+}
+
+static struct md_sysfs_entry md_new_device =
+__ATTR(new_dev, 0200, null_show, new_dev_store);
 
 static ssize_t
 size_show(mddev_t *mddev, char *page)
@@ -2144,6 +2203,7 @@ static struct attribute *md_default_attr
 	&md_chunk_size.attr,
 	&md_size.attr,
 	&md_metadata.attr,
+	&md_new_device.attr,
 	NULL,
 };
 
