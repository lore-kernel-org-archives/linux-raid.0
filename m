From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 004 of 8] Change raid5 sysfs attribute to not create a new directory.
Date: Fri, 14 Oct 2005 12:26:11 +1000
Message-ID: <1051014022611.11802@suse.de>
References: <20051014122335.11602.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


There isn't really a need for raid5 attributes to be an a subdirectory,
so this patch moves them from 
  /sys/block/mdX/md/raid5/attribute
to 
  /sys/block/mdX/md/attribute

This suggests that all md personalities should co-operate about
namespace usage, but that shouldn't be a problem.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c            |    6 ---
 ./drivers/md/raid5.c         |   72 ++++++++-----------------------------------
 ./include/linux/raid/md_k.h  |    7 ++++
 ./include/linux/raid/raid5.h |    1 
 4 files changed, 22 insertions(+), 64 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-10-14 12:16:10.000000000 +1000
+++ ./drivers/md/md.c	2005-10-14 12:16:38.000000000 +1000
@@ -1683,12 +1683,6 @@ static void analyze_sbs(mddev_t * mddev)
 
 }
 
-struct md_sysfs_entry {
-	struct attribute attr;
-	ssize_t (*show)(mddev_t *, char *);
-	ssize_t (*store)(mddev_t *, const char *, size_t);
-};
-
 static ssize_t
 md_show_level(mddev_t *mddev, char *page)
 {

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-10-14 12:15:42.000000000 +1000
+++ ./drivers/md/raid5.c	2005-10-14 12:16:39.000000000 +1000
@@ -1736,21 +1736,17 @@ static void raid5d (mddev_t *mddev)
 	PRINTK("--- raid5d inactive\n");
 }
 
-struct raid5_sysfs_entry {
-	struct attribute attr;
-	ssize_t (*show)(raid5_conf_t *, char *);
-	ssize_t (*store)(raid5_conf_t *, const char *, ssize_t);
-};
-
 static ssize_t
-raid5_show_stripe_cache_size(raid5_conf_t *conf, char *page)
+raid5_show_stripe_cache_size(mddev_t *mddev, char *page)
 {
+	raid5_conf_t *conf = mddev_to_conf(mddev);
 	return sprintf(page, "%d\n", conf->max_nr_stripes);
 }
 
 static ssize_t
-raid5_store_stripe_cache_size(raid5_conf_t *conf, const char *page, ssize_t len)
+raid5_store_stripe_cache_size(mddev_t *mddev, const char *page, size_t len)
 {
+	raid5_conf_t *conf = mddev_to_conf(mddev);
 	char *end;
 	int new;
 	if (len >= PAGE_SIZE)
@@ -1774,68 +1770,33 @@ raid5_store_stripe_cache_size(raid5_conf
 	}
 	return len;
 }
-static struct raid5_sysfs_entry raid5_stripecache_size = {
+
+static struct md_sysfs_entry raid5_stripecache_size = {
 	.attr = {.name = "stripe_cache_size", .mode = S_IRUGO | S_IWUSR },
 	.show = raid5_show_stripe_cache_size,
 	.store = raid5_store_stripe_cache_size,
 };
 
 static ssize_t
-raid5_show_stripe_cache_active(raid5_conf_t *conf, char *page)
+raid5_show_stripe_cache_active(mddev_t *mddev, char *page)
 {
+	raid5_conf_t *conf = mddev_to_conf(mddev);
 	return sprintf(page, "%d\n", atomic_read(&conf->active_stripes));
 }
 
-static struct raid5_sysfs_entry raid5_stripecache_active = {
+static struct md_sysfs_entry raid5_stripecache_active = {
 	.attr = {.name = "stripe_cache_active", .mode = S_IRUGO},
 	.show = raid5_show_stripe_cache_active,
 };
 
-static struct attribute *raid5_default_attrs[] = {
+static struct attribute *raid5_attrs[] =  {
 	&raid5_stripecache_size.attr,
 	&raid5_stripecache_active.attr,
 	NULL,
 };
-
-static ssize_t
-raid5_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
-{
-	struct raid5_sysfs_entry *entry = container_of(attr, struct raid5_sysfs_entry, attr);
-	raid5_conf_t *conf = container_of(kobj, raid5_conf_t, kobj);
-
-	if (!entry->show)
-		return -EIO;
-	return entry->show(conf, page);
-}
-
-static ssize_t
-raid5_attr_store(struct kobject *kobj, struct attribute *attr,
-	      const char *page, size_t length)
-{
-	struct raid5_sysfs_entry *entry = container_of(attr, struct raid5_sysfs_entry, attr);
-	raid5_conf_t *conf = container_of(kobj, raid5_conf_t, kobj);
-
-	if (!entry->store)
-		return -EIO;
-	return entry->store(conf, page, length);
-}
-
-static void raid5_free(struct kobject *ko)
-{
-	raid5_conf_t *conf = container_of(ko, raid5_conf_t, kobj);
-	kfree(conf);
-}
-
-
-static struct sysfs_ops raid5_sysfs_ops = {
-	.show		= raid5_attr_show,
-	.store		= raid5_attr_store,
-};
-
-static struct kobj_type raid5_ktype = {
-	.release	= raid5_free,
-	.sysfs_ops	= &raid5_sysfs_ops,
-	.default_attrs	= raid5_default_attrs,
+static struct attribute_group raid5_attrs_group = {
+	.name = NULL,
+	.attrs = raid5_attrs,
 };
 
 static int run(mddev_t *mddev)
@@ -1979,10 +1940,7 @@ memory = conf->max_nr_stripes * (sizeof(
 	}
 
 	/* Ok, everything is just fine now */
-	conf->kobj.parent = &mddev->kobj;
-	strcpy(conf->kobj.name, "raid5");
-	conf->kobj.ktype = &raid5_ktype;
-	kobject_register(&conf->kobj);
+	sysfs_create_group(&mddev->kobj, &raid5_attrs_group);
 
 	if (mddev->bitmap)
 		mddev->thread->timeout = mddev->bitmap->daemon_sleep * HZ;
@@ -2016,7 +1974,7 @@ static int stop(mddev_t *mddev)
 	shrink_stripes(conf);
 	free_pages((unsigned long) conf->stripe_hashtbl, HASH_PAGES_ORDER);
 	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
-	kobject_unregister(&conf->kobj);
+	sysfs_remove_group(&mddev->kobj, &raid5_attrs_group);
 	mddev->private = NULL;
 	return 0;
 }

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2005-10-14 12:15:05.000000000 +1000
+++ ./include/linux/raid/md_k.h	2005-10-14 12:16:39.000000000 +1000
@@ -282,6 +282,13 @@ struct mdk_personality_s
 };
 
 
+struct md_sysfs_entry {
+	struct attribute attr;
+	ssize_t (*show)(mddev_t *, char *);
+	ssize_t (*store)(mddev_t *, const char *, size_t);
+};
+
+
 static inline char * mdname (mddev_t * mddev)
 {
 	return mddev->gendisk ? mddev->gendisk->disk_name : "mdX";

diff ./include/linux/raid/raid5.h~current~ ./include/linux/raid/raid5.h
--- ./include/linux/raid/raid5.h~current~	2005-10-14 12:14:52.000000000 +1000
+++ ./include/linux/raid/raid5.h	2005-10-14 12:16:39.000000000 +1000
@@ -228,7 +228,6 @@ struct raid5_private_data {
 					    * Cleared when a sync completes.
 					    */
 
-	struct kobject		kobj;
 	/*
 	 * Free stripes pool
 	 */
