From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 004 of 10] Fix some locking and module refcounting issues with md's use of sysfs.
Date: Wed, 2 Nov 2005 21:15:10 +1100
Message-ID: <1051102101510.23887@suse.de>
References: <20051102205640.22689.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Greg KH <greg@kroah.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


1/ I really should be using the __ATTR macros for defining attributes, so
 that the .owner field get set properly, otherwise modules can be removed
 while sysfs files are open.
 This also involves some name changes of _show routines.

2/ Always lock the mddev (against reconfiguration) for all sysfs
 attribute access.  This easily avoid certain races and is completely
 consistant with other interfaces (ioctl and /proc/mdstat both 
 always lock against reconfiguration).

3/ raid5 attributes must check that the 'conf' structure actually 
  exists (the array could have been stopped while an attribute file
  was open).

4/ A missing 'kfree' from when the raid5_conf_t was converted to have
  a kobject embedded, and then converted back again.



Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c    |   62 +++++++++++++++++++++++----------------------------
 ./drivers/md/raid5.c |   30 ++++++++++++++----------
 2 files changed, 46 insertions(+), 46 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-11-02 17:32:41.000000000 +1100
+++ ./drivers/md/md.c	2005-11-02 17:33:16.000000000 +1100
@@ -1504,7 +1504,7 @@ struct rdev_sysfs_entry {
 };
 
 static ssize_t
-rdev_show_state(mdk_rdev_t *rdev, char *page)
+state_show(mdk_rdev_t *rdev, char *page)
 {
 	char *sep = "";
 	int len=0;
@@ -1525,13 +1525,11 @@ rdev_show_state(mdk_rdev_t *rdev, char *
 	return len+sprintf(page+len, "\n");
 }
 
-static struct rdev_sysfs_entry rdev_state = {
-	.attr = {.name = "state", .mode = S_IRUGO },
-	.show = rdev_show_state,
-};
+static struct rdev_sysfs_entry
+rdev_state = __ATTR_RO(state);
 
 static ssize_t
-rdev_show_super(mdk_rdev_t *rdev, char *page)
+super_show(mdk_rdev_t *rdev, char *page)
 {
 	if (rdev->sb_loaded && rdev->sb_size) {
 		memcpy(page, page_address(rdev->sb_page), rdev->sb_size);
@@ -1539,10 +1537,8 @@ rdev_show_super(mdk_rdev_t *rdev, char *
 	} else
 		return 0;
 }
-static struct rdev_sysfs_entry rdev_super = {
-	.attr = {.name = "super", .mode = S_IRUGO },
-	.show = rdev_show_super,
-};
+static struct rdev_sysfs_entry rdev_super = __ATTR_RO(super);
+
 static struct attribute *rdev_default_attrs[] = {
 	&rdev_state.attr,
 	&rdev_super.attr,
@@ -1728,7 +1724,7 @@ static void analyze_sbs(mddev_t * mddev)
 }
 
 static ssize_t
-md_show_level(mddev_t *mddev, char *page)
+level_show(mddev_t *mddev, char *page)
 {
 	mdk_personality_t *p = mddev->pers;
 	if (p == NULL)
@@ -1739,21 +1735,15 @@ md_show_level(mddev_t *mddev, char *page
 		return sprintf(page, "%s\n", p->name);
 }
 
-static struct md_sysfs_entry md_level = {
-	.attr = {.name = "level", .mode = S_IRUGO },
-	.show = md_show_level,
-};
+static struct md_sysfs_entry md_level = __ATTR_RO(level);
 
 static ssize_t
-md_show_rdisks(mddev_t *mddev, char *page)
+raid_disks_show(mddev_t *mddev, char *page)
 {
 	return sprintf(page, "%d\n", mddev->raid_disks);
 }
 
-static struct md_sysfs_entry md_raid_disks = {
-	.attr = {.name = "raid_disks", .mode = S_IRUGO },
-	.show = md_show_rdisks,
-};
+static struct md_sysfs_entry md_raid_disks = __ATTR_RO(raid_disks);
 
 static ssize_t
 md_show_scan(mddev_t *mddev, char *page)
@@ -1782,10 +1772,10 @@ md_store_scan(mddev_t *mddev, const char
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
 	    test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))
 		return -EBUSY;
-	down(&mddev->reconfig_sem);
+
 	if (mddev->pers && mddev->pers->sync_request)
 		canscan=1;
-	up(&mddev->reconfig_sem);
+
 	if (!canscan)
 		return -EINVAL;
 
@@ -1801,22 +1791,18 @@ md_store_scan(mddev_t *mddev, const char
 }
 
 static ssize_t
-md_show_mismatch(mddev_t *mddev, char *page)
+mismatch_cnt_show(mddev_t *mddev, char *page)
 {
 	return sprintf(page, "%llu\n",
 		       (unsigned long long) mddev->resync_mismatches);
 }
 
-static struct md_sysfs_entry md_scan_mode = {
-	.attr = {.name = "scan_mode", .mode = S_IRUGO|S_IWUSR },
-	.show = md_show_scan,
-	.store = md_store_scan,
-};
+static struct md_sysfs_entry
+md_scan_mode = __ATTR(scan_mode, S_IRUGO|S_IWUSR, md_show_scan, md_store_scan);
 
-static struct md_sysfs_entry md_mismatches = {
-	.attr = {.name = "mismatch_cnt", .mode = S_IRUGO },
-	.show = md_show_mismatch,
-};
+
+static struct md_sysfs_entry
+md_mismatches = __ATTR_RO(mismatch_cnt);
 
 static struct attribute *md_default_attrs[] = {
 	&md_level.attr,
@@ -1831,10 +1817,14 @@ md_attr_show(struct kobject *kobj, struc
 {
 	struct md_sysfs_entry *entry = container_of(attr, struct md_sysfs_entry, attr);
 	mddev_t *mddev = container_of(kobj, struct mddev_s, kobj);
+	ssize_t rv;
 
 	if (!entry->show)
 		return -EIO;
-	return entry->show(mddev, page);
+	mddev_lock(mddev);
+	rv = entry->show(mddev, page);
+	mddev_unlock(mddev);
+	return rv;
 }
 
 static ssize_t
@@ -1843,10 +1833,14 @@ md_attr_store(struct kobject *kobj, stru
 {
 	struct md_sysfs_entry *entry = container_of(attr, struct md_sysfs_entry, attr);
 	mddev_t *mddev = container_of(kobj, struct mddev_s, kobj);
+	ssize_t rv;
 
 	if (!entry->store)
 		return -EIO;
-	return entry->store(mddev, page, length);
+	mddev_lock(mddev);
+	rv = entry->store(mddev, page, length);
+	mddev_unlock(mddev);
+	return rv;
 }
 
 static void md_free(struct kobject *ko)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-11-02 17:32:57.000000000 +1100
+++ ./drivers/md/raid5.c	2005-11-02 17:33:17.000000000 +1100
@@ -1750,7 +1750,10 @@ static ssize_t
 raid5_show_stripe_cache_size(mddev_t *mddev, char *page)
 {
 	raid5_conf_t *conf = mddev_to_conf(mddev);
-	return sprintf(page, "%d\n", conf->max_nr_stripes);
+	if (conf)
+		return sprintf(page, "%d\n", conf->max_nr_stripes);
+	else
+		return 0;
 }
 
 static ssize_t
@@ -1761,6 +1764,8 @@ raid5_store_stripe_cache_size(mddev_t *m
 	int new;
 	if (len >= PAGE_SIZE)
 		return -EINVAL;
+	if (!conf)
+		return -ENODEV;
 
 	new = simple_strtoul(page, &end, 10);
 	if (!*page || (*end && *end != '\n') )
@@ -1781,23 +1786,23 @@ raid5_store_stripe_cache_size(mddev_t *m
 	return len;
 }
 
-static struct md_sysfs_entry raid5_stripecache_size = {
-	.attr = {.name = "stripe_cache_size", .mode = S_IRUGO | S_IWUSR },
-	.show = raid5_show_stripe_cache_size,
-	.store = raid5_store_stripe_cache_size,
-};
+static struct md_sysfs_entry
+raid5_stripecache_size = __ATTR(stripe_cache_size, S_IRUGO | S_IWUSR,
+				raid5_show_stripe_cache_size,
+				raid5_store_stripe_cache_size);
 
 static ssize_t
-raid5_show_stripe_cache_active(mddev_t *mddev, char *page)
+stripe_cache_active_show(mddev_t *mddev, char *page)
 {
 	raid5_conf_t *conf = mddev_to_conf(mddev);
-	return sprintf(page, "%d\n", atomic_read(&conf->active_stripes));
+	if (conf)
+		return sprintf(page, "%d\n", atomic_read(&conf->active_stripes));
+	else
+		return 0;
 }
 
-static struct md_sysfs_entry raid5_stripecache_active = {
-	.attr = {.name = "stripe_cache_active", .mode = S_IRUGO},
-	.show = raid5_show_stripe_cache_active,
-};
+static struct md_sysfs_entry
+raid5_stripecache_active = __ATTR_RO(stripe_cache_active);
 
 static struct attribute *raid5_attrs[] =  {
 	&raid5_stripecache_size.attr,
@@ -1985,6 +1990,7 @@ static int stop(mddev_t *mddev)
 	free_pages((unsigned long) conf->stripe_hashtbl, HASH_PAGES_ORDER);
 	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
 	sysfs_remove_group(&mddev->kobj, &raid5_attrs_group);
+	kfree(conf);
 	mddev->private = NULL;
 	return 0;
 }
