From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 001 of 5] Initial sysfs support for md
Date: Tue, 4 Oct 2005 15:23:21 +1000
Message-ID: <1051004052321.28788@suse.de>
References: <20051004151922.28715.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Start using kobjects in mddevs, and provide a couple
of simple attributes (level and disks).
Attributes live in
  /sys/block/mdX/md/attr-name


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c           |   86 +++++++++++++++++++++++++++++++++++++++++++-
 ./include/linux/raid/md_k.h |    2 +
 2 files changed, 87 insertions(+), 1 deletion(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-10-04 11:54:43.000000000 +1000
+++ ./drivers/md/md.c	2005-10-04 12:16:53.000000000 +1000
@@ -181,7 +181,7 @@ static void mddev_put(mddev_t *mddev)
 	if (!mddev->raid_disks && list_empty(&mddev->disks)) {
 		list_del(&mddev->all_mddevs);
 		blk_put_queue(mddev->queue);
-		kfree(mddev);
+		kobject_unregister(&mddev->kobj);
 	}
 	spin_unlock(&all_mddevs_lock);
 }
@@ -1551,6 +1551,85 @@ static void analyze_sbs(mddev_t * mddev)
 
 }
 
+struct md_sysfs_entry {
+	struct attribute attr;
+	ssize_t (*show)(mddev_t *, char *);
+	ssize_t (*store)(mddev_t *, const char *, size_t);
+};
+
+static ssize_t
+md_show_level(mddev_t *mddev, char *page)
+{
+	mdk_personality_t *p = mddev->pers;
+	if (p == NULL)
+		return 0;
+	if (mddev->level >= 0)
+		return sprintf(page, "RAID-%d\n", mddev->level);
+	else
+		return sprintf(page, "%s\n", p->name);
+}
+
+static struct md_sysfs_entry md_level = {
+	.attr = {.name = "level", .mode = S_IRUGO },
+	.show = md_show_level,
+};
+
+static ssize_t
+md_show_rdisks(mddev_t *mddev, char *page)
+{
+	return sprintf(page, "%d\n", mddev->raid_disks);
+}
+
+static struct md_sysfs_entry md_raid_disks = {
+	.attr = {.name = "raid_disks", .mode = S_IRUGO },
+	.show = md_show_rdisks,
+};
+
+static struct attribute *md_default_attrs[] = {
+	&md_level.attr,
+	&md_raid_disks.attr,
+	NULL,
+};
+
+static ssize_t
+md_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
+{
+	struct md_sysfs_entry *entry = container_of(attr, struct md_sysfs_entry, attr);
+	mddev_t *mddev = container_of(kobj, struct mddev_s, kobj);
+
+	if (!entry->show)
+		return -EIO;
+	return entry->show(mddev, page);
+}
+
+static ssize_t
+md_attr_store(struct kobject *kobj, struct attribute *attr,
+	      const char *page, size_t length)
+{
+	struct md_sysfs_entry *entry = container_of(attr, struct md_sysfs_entry, attr);
+	mddev_t *mddev = container_of(kobj, struct mddev_s, kobj);
+
+	if (!entry->store)
+		return -EIO;
+	return entry->store(mddev, page, length);
+}
+
+static void md_free(struct kobject *ko)
+{
+	mddev_t *mddev = container_of(ko, mddev_t, kobj);
+	kfree(mddev);
+}
+
+static struct sysfs_ops md_sysfs_ops = {
+	.show	= md_attr_show,
+	.store	= md_attr_store,
+};
+static struct kobj_type md_ktype = {
+	.release	= md_free,
+	.sysfs_ops	= &md_sysfs_ops,
+	.default_attrs	= md_default_attrs,
+};
+
 int mdp_major = 0;
 
 static struct kobject *md_probe(dev_t dev, int *part, void *data)
@@ -1592,6 +1671,11 @@ static struct kobject *md_probe(dev_t de
 	add_disk(disk);
 	mddev->gendisk = disk;
 	up(&disks_sem);
+	mddev->kobj.parent = kobject_get(&disk->kobj);
+	mddev->kobj.k_name = NULL;
+	snprintf(mddev->kobj.name, KOBJ_NAME_LEN, "%s", "md");
+	mddev->kobj.ktype = &md_ktype;
+	kobject_register(&mddev->kobj);
 	return NULL;
 }
 

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2005-10-04 11:54:43.000000000 +1000
+++ ./include/linux/raid/md_k.h	2005-10-04 11:54:43.000000000 +1000
@@ -148,6 +148,8 @@ struct mddev_s
 
 	struct gendisk			*gendisk;
 
+	struct kobject			kobj;
+
 	/* Superblock information */
 	int				major_version,
 					minor_version,
