From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 003 of 5] Add kobject/sysfs support to raid5
Date: Tue, 4 Oct 2005 15:23:39 +1000
Message-ID: <1051004052339.28815@suse.de>
References: <20051004151922.28715.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


/sys/block/mdX/md/raid5/
contains raid5-related attributes.
Currently
  stripe_cache_size
is number of entries in stripe cache, and is settable.
  stripe_cache_active
is number of active entries, and in only readable.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c         |  183 +++++++++++++++++++++++++++++++++++--------
 ./include/linux/raid/raid5.h |    1 
 2 files changed, 152 insertions(+), 32 deletions(-)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-10-04 13:08:41.000000000 +1000
+++ ./drivers/md/raid5.c	2005-10-04 13:08:44.000000000 +1000
@@ -293,9 +293,31 @@ static struct stripe_head *get_active_st
 	return sh;
 }
 
-static int grow_stripes(raid5_conf_t *conf, int num)
+static int grow_one_stripe(raid5_conf_t *conf)
 {
 	struct stripe_head *sh;
+	sh = kmem_cache_alloc(conf->slab_cache, GFP_KERNEL);
+	if (!sh)
+		return 0;
+	memset(sh, 0, sizeof(*sh) + (conf->raid_disks-1)*sizeof(struct r5dev));
+	sh->raid_conf = conf;
+	spin_lock_init(&sh->lock);
+
+	if (grow_buffers(sh, conf->raid_disks)) {
+		shrink_buffers(sh, conf->raid_disks);
+		kmem_cache_free(conf->slab_cache, sh);
+		return 0;
+	}
+	/* we just created an active stripe so... */
+	atomic_set(&sh->count, 1);
+	atomic_inc(&conf->active_stripes);
+	INIT_LIST_HEAD(&sh->lru);
+	release_stripe(sh);
+	return 1;
+}
+
+static int grow_stripes(raid5_conf_t *conf, int num)
+{
 	kmem_cache_t *sc;
 	int devs = conf->raid_disks;
 
@@ -308,43 +330,34 @@ static int grow_stripes(raid5_conf_t *co
 		return 1;
 	conf->slab_cache = sc;
 	while (num--) {
-		sh = kmem_cache_alloc(sc, GFP_KERNEL);
-		if (!sh)
+		if (!grow_one_stripe(conf))
 			return 1;
-		memset(sh, 0, sizeof(*sh) + (devs-1)*sizeof(struct r5dev));
-		sh->raid_conf = conf;
-		spin_lock_init(&sh->lock);
-
-		if (grow_buffers(sh, conf->raid_disks)) {
-			shrink_buffers(sh, conf->raid_disks);
-			kmem_cache_free(sc, sh);
-			return 1;
-		}
-		/* we just created an active stripe so... */
-		atomic_set(&sh->count, 1);
-		atomic_inc(&conf->active_stripes);
-		INIT_LIST_HEAD(&sh->lru);
-		release_stripe(sh);
 	}
 	return 0;
 }
 
-static void shrink_stripes(raid5_conf_t *conf)
+static int drop_one_stripe(raid5_conf_t *conf)
 {
 	struct stripe_head *sh;
 
-	while (1) {
-		spin_lock_irq(&conf->device_lock);
-		sh = get_free_stripe(conf);
-		spin_unlock_irq(&conf->device_lock);
-		if (!sh)
-			break;
-		if (atomic_read(&sh->count))
-			BUG();
-		shrink_buffers(sh, conf->raid_disks);
-		kmem_cache_free(conf->slab_cache, sh);
-		atomic_dec(&conf->active_stripes);
-	}
+	spin_lock_irq(&conf->device_lock);
+	sh = get_free_stripe(conf);
+	spin_unlock_irq(&conf->device_lock);
+	if (!sh)
+		return 0;
+	if (atomic_read(&sh->count))
+		BUG();
+	shrink_buffers(sh, conf->raid_disks);
+	kmem_cache_free(conf->slab_cache, sh);
+	atomic_dec(&conf->active_stripes);
+	return 1;
+}
+
+static void shrink_stripes(raid5_conf_t *conf)
+{
+	while (drop_one_stripe(conf))
+		;
+
 	kmem_cache_destroy(conf->slab_cache);
 	conf->slab_cache = NULL;
 }
@@ -1718,6 +1731,108 @@ static void raid5d (mddev_t *mddev)
 	PRINTK("--- raid5d inactive\n");
 }
 
+struct raid5_sysfs_entry {
+	struct attribute attr;
+	ssize_t (*show)(raid5_conf_t *, char *);
+	ssize_t (*store)(raid5_conf_t *, const char *, ssize_t);
+};
+
+static ssize_t
+raid5_show_stripe_cache_size(raid5_conf_t *conf, char *page)
+{
+	return sprintf(page, "%d\n", conf->max_nr_stripes);
+}
+
+static ssize_t
+raid5_store_stripe_cache_size(raid5_conf_t *conf, const char *page, ssize_t len)
+{
+	char *end;
+	int new;
+	if (len >= PAGE_SIZE)
+		return -EINVAL;
+
+	new = simple_strtoul(page, &end, 10);
+	if (!*page || (*end && *end != '\n') )
+		return -EINVAL;
+	if (new <= 16 || new > 32768)
+		return -EINVAL;
+	while (new < conf->max_nr_stripes) {
+		if (drop_one_stripe(conf))
+			conf->max_nr_stripes--;
+		else
+			break;
+	}
+	while (new > conf->max_nr_stripes) {
+		if (grow_one_stripe(conf))
+			conf->max_nr_stripes++;
+		else break;
+	}
+	return len;
+}
+static struct raid5_sysfs_entry raid5_stripecache_size = {
+	.attr = {.name = "stripe_cache_size", .mode = S_IRUGO | S_IWUSR },
+	.show = raid5_show_stripe_cache_size,
+	.store = raid5_store_stripe_cache_size,
+};
+
+static ssize_t
+raid5_show_stripe_cache_active(raid5_conf_t *conf, char *page)
+{
+	return sprintf(page, "%d\n", atomic_read(&conf->active_stripes));
+}
+
+static struct raid5_sysfs_entry raid5_stripecache_active = {
+	.attr = {.name = "stripe_cache_active", .mode = S_IRUGO},
+	.show = raid5_show_stripe_cache_active,
+};
+
+static struct attribute *raid5_default_attrs[] = {
+	&raid5_stripecache_size.attr,
+	&raid5_stripecache_active.attr,
+	NULL,
+};
+
+static ssize_t
+raid5_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
+{
+	struct raid5_sysfs_entry *entry = container_of(attr, struct raid5_sysfs_entry, attr);
+	raid5_conf_t *conf = container_of(kobj, raid5_conf_t, kobj);
+
+	if (!entry->show)
+		return -EIO;
+	return entry->show(conf, page);
+}
+
+static ssize_t
+raid5_attr_store(struct kobject *kobj, struct attribute *attr,
+	      const char *page, size_t length)
+{
+	struct raid5_sysfs_entry *entry = container_of(attr, struct raid5_sysfs_entry, attr);
+	raid5_conf_t *conf = container_of(kobj, raid5_conf_t, kobj);
+
+	if (!entry->store)
+		return -EIO;
+	return entry->store(conf, page, length);
+}
+
+static void raid5_free(struct kobject *ko)
+{
+	raid5_conf_t *conf = container_of(ko, raid5_conf_t, kobj);
+	kfree(conf);
+}
+
+
+static struct sysfs_ops raid5_sysfs_ops = {
+	.show		= raid5_attr_show,
+	.store		= raid5_attr_store,
+};
+
+static struct kobj_type raid5_ktype = {
+	.release	= raid5_free,
+	.sysfs_ops	= &raid5_sysfs_ops,
+	.default_attrs	= raid5_default_attrs,
+};
+
 static int run(mddev_t *mddev)
 {
 	raid5_conf_t *conf;
@@ -1859,6 +1974,10 @@ memory = conf->max_nr_stripes * (sizeof(
 	}
 
 	/* Ok, everything is just fine now */
+	conf->kobj.parent = kobject_get(&mddev->kobj);
+	strcpy(conf->kobj.name, "raid5");
+	conf->kobj.ktype = &raid5_ktype;
+	kobject_register(&conf->kobj);
 
 	if (mddev->bitmap)
 		mddev->thread->timeout = mddev->bitmap->daemon_sleep * HZ;
@@ -1883,7 +2002,7 @@ abort:
 
 
 
-static int stop (mddev_t *mddev)
+static int stop(mddev_t *mddev)
 {
 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
 
@@ -1892,7 +2011,7 @@ static int stop (mddev_t *mddev)
 	shrink_stripes(conf);
 	free_pages((unsigned long) conf->stripe_hashtbl, HASH_PAGES_ORDER);
 	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
-	kfree(conf);
+	kobject_unregister(&conf->kobj);
 	mddev->private = NULL;
 	return 0;
 }

diff ./include/linux/raid/raid5.h~current~ ./include/linux/raid/raid5.h
--- ./include/linux/raid/raid5.h~current~	2005-10-04 13:08:41.000000000 +1000
+++ ./include/linux/raid/raid5.h	2005-10-04 12:57:00.000000000 +1000
@@ -228,6 +228,7 @@ struct raid5_private_data {
 					    * Cleared when a sync completes.
 					    */
 
+	struct kobject		kobj;
 	/*
 	 * Free stripes pool
 	 */
