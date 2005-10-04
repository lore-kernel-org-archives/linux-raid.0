From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 002 of 5] Extend md sysfs support to component devices.
Date: Tue, 4 Oct 2005 15:23:27 +1000
Message-ID: <1051004052327.28800@suse.de>
References: <20051004151922.28715.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Each device in an md array how has a corresponding
  /sys/block/mdX/md/devNN/
directory which can contain attributes.  Currently
there is only 'state' which summarises the state, nd
'super' which has a copy of the superblock, and
'block' which is a symlink to the block device.

Also, /sys/block/mdX/md/rdNN represents slot 'NN' in 
the array, and is a symlink to the relevant 'devNN'.  
Obviously spare devices do not have a slot in the array,
and so don't have such a symlink.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c           |  168 +++++++++++++++++++++++++++++++++++++++++---
 ./include/linux/raid/md_k.h |    2 
 2 files changed, 162 insertions(+), 8 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-10-04 12:16:53.000000000 +1000
+++ ./drivers/md/md.c	2005-10-04 12:25:36.000000000 +1000
@@ -711,6 +711,7 @@ static void super_90_sync(mddev_t *mddev
 	 */
 	int i;
 	int active=0, working=0,failed=0,spare=0,nr_disks=0;
+	unsigned int fixdesc=0;
 
 	rdev->sb_size = MD_SB_BYTES;
 
@@ -758,16 +759,28 @@ static void super_90_sync(mddev_t *mddev
 	sb->disks[0].state = (1<<MD_DISK_REMOVED);
 	ITERATE_RDEV(mddev,rdev2,tmp) {
 		mdp_disk_t *d;
+		int desc_nr;
 		if (rdev2->raid_disk >= 0 && rdev2->in_sync && !rdev2->faulty)
-			rdev2->desc_nr = rdev2->raid_disk;
+			desc_nr = rdev2->raid_disk;
 		else
-			rdev2->desc_nr = next_spare++;
+			desc_nr = next_spare++;
+		if (desc_nr != rdev2->desc_nr) {
+			fixdesc |= (1 << desc_nr);
+			rdev2->desc_nr = desc_nr;
+			if (rdev2->raid_disk >= 0) {
+				char nm[20];
+				sprintf(nm, "rd%d", rdev2->raid_disk);
+				sysfs_remove_link(&mddev->kobj, nm);
+			}
+			sysfs_remove_link(&rdev2->kobj, "block");
+			kobject_del(&rdev2->kobj);
+		}
 		d = &sb->disks[rdev2->desc_nr];
 		nr_disks++;
 		d->number = rdev2->desc_nr;
 		d->major = MAJOR(rdev2->bdev->bd_dev);
 		d->minor = MINOR(rdev2->bdev->bd_dev);
-		if (rdev2->raid_disk >= 0 && rdev->in_sync && !rdev2->faulty)
+		if (rdev2->raid_disk >= 0 && rdev2->in_sync && !rdev2->faulty)
 			d->raid_disk = rdev2->raid_disk;
 		else
 			d->raid_disk = rdev2->desc_nr; /* compatibility */
@@ -787,7 +800,22 @@ static void super_90_sync(mddev_t *mddev
 		if (test_bit(WriteMostly, &rdev2->flags))
 			d->state |= (1<<MD_DISK_WRITEMOSTLY);
 	}
-	
+	if (fixdesc)
+		ITERATE_RDEV(mddev,rdev2,tmp)
+			if (fixdesc & (1<<rdev2->desc_nr)) {
+				snprintf(rdev2->kobj.name, KOBJ_NAME_LEN, "dev%d",
+					 rdev2->desc_nr);
+				kobject_add(&rdev2->kobj);
+				sysfs_create_link(&rdev2->kobj,
+						  &rdev2->bdev->bd_disk->kobj,
+						  "block");
+				if (rdev2->raid_disk >= 0) {
+					char nm[20];
+					sprintf(nm, "rd%d", rdev2->raid_disk);
+					sysfs_create_link(&mddev->kobj,
+							  &rdev2->kobj, nm);
+				}
+			}
 	/* now set the "removed" and "faulty" bits on any missing devices */
 	for (i=0 ; i < mddev->raid_disks ; i++) {
 		mdp_disk_t *d = &sb->disks[i];
@@ -1147,6 +1175,13 @@ static int bind_rdev_to_array(mdk_rdev_t
 	list_add(&rdev->same_set, &mddev->disks);
 	rdev->mddev = mddev;
 	printk(KERN_INFO "md: bind<%s>\n", bdevname(rdev->bdev,b));
+
+	rdev->kobj.k_name = NULL;
+	snprintf(rdev->kobj.name, KOBJ_NAME_LEN, "dev%d", rdev->desc_nr);
+	rdev->kobj.parent = kobject_get(&mddev->kobj);
+	kobject_add(&rdev->kobj);
+
+	sysfs_create_link(&rdev->kobj, &rdev->bdev->bd_disk->kobj, "block");
 	return 0;
 }
 
@@ -1160,6 +1195,8 @@ static void unbind_rdev_from_array(mdk_r
 	list_del_init(&rdev->same_set);
 	printk(KERN_INFO "md: unbind<%s>\n", bdevname(rdev->bdev,b));
 	rdev->mddev = NULL;
+	sysfs_remove_link(&rdev->kobj, "block");
+	kobject_del(&rdev->kobj);
 }
 
 /*
@@ -1215,7 +1252,7 @@ static void export_rdev(mdk_rdev_t * rde
 	md_autodetect_dev(rdev->bdev->bd_dev);
 #endif
 	unlock_rdev(rdev);
-	kfree(rdev);
+	kobject_put(&rdev->kobj);
 }
 
 static void kick_rdev_from_array(mdk_rdev_t * rdev)
@@ -1414,6 +1451,94 @@ repeat:
 
 }
 
+struct rdev_sysfs_entry {
+	struct attribute attr;
+	ssize_t (*show)(mdk_rdev_t *, char *);
+	ssize_t (*store)(mdk_rdev_t *, const char *, size_t);
+};
+
+static ssize_t
+rdev_show_state(mdk_rdev_t *rdev, char *page)
+{
+	char *sep = "";
+	int len=0;
+
+	if (rdev->faulty) {
+		len+= sprintf(page+len, "%sfaulty",sep);
+		sep = ",";
+	}
+	if (rdev->in_sync) {
+		len += sprintf(page+len, "%sin_sync",sep);
+		sep = ",";
+	}
+	if (!rdev->faulty && !rdev->in_sync) {
+		len += sprintf(page+len, "%sspare", sep);
+		sep = ",";
+	}
+	return len+sprintf(page+len, "\n");
+}
+
+static struct rdev_sysfs_entry rdev_state = {
+	.attr = {.name = "state", .mode = S_IRUGO },
+	.show = rdev_show_state,
+};
+
+static ssize_t
+rdev_show_super(mdk_rdev_t *rdev, char *page)
+{
+	if (rdev->sb_loaded && rdev->sb_size) {
+		memcpy(page, page_address(rdev->sb_page), rdev->sb_size);
+		return rdev->sb_size;
+	} else
+		return 0;
+}
+static struct rdev_sysfs_entry rdev_super = {
+	.attr = {.name = "super", .mode = S_IRUGO },
+	.show = rdev_show_super,
+};
+static struct attribute *rdev_default_attrs[] = {
+	&rdev_state.attr,
+	&rdev_super.attr,
+	NULL,
+};
+static ssize_t
+rdev_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
+{
+	struct rdev_sysfs_entry *entry = container_of(attr, struct rdev_sysfs_entry, attr);
+	mdk_rdev_t *rdev = container_of(kobj, mdk_rdev_t, kobj);
+
+	if (!entry->show)
+		return -EIO;
+	return entry->show(rdev, page);
+}
+
+static ssize_t
+rdev_attr_store(struct kobject *kobj, struct attribute *attr,
+	      const char *page, size_t length)
+{
+	struct rdev_sysfs_entry *entry = container_of(attr, struct rdev_sysfs_entry, attr);
+	mdk_rdev_t *rdev = container_of(kobj, mdk_rdev_t, kobj);
+
+	if (!entry->store)
+		return -EIO;
+	return entry->store(rdev, page, length);
+}
+
+static void rdev_free(struct kobject *ko)
+{
+	mdk_rdev_t *rdev = container_of(ko, mdk_rdev_t, kobj);
+	kfree(rdev);
+}
+static struct sysfs_ops rdev_sysfs_ops = {
+	.show		= rdev_attr_show,
+	.store		= rdev_attr_store,
+};
+static struct kobj_type rdev_ktype = {
+	.release	= rdev_free,
+	.sysfs_ops	= &rdev_sysfs_ops,
+	.default_attrs	= rdev_default_attrs,
+};
+
 /*
  * Import a device. If 'super_format' >= 0, then sanity check the superblock
  *
@@ -1445,6 +1570,10 @@ static mdk_rdev_t *md_import_device(dev_
 	if (err)
 		goto abort_free;
 
+	rdev->kobj.parent = NULL;
+	rdev->kobj.ktype = &rdev_ktype;
+	kobject_init(&rdev->kobj);
+
 	rdev->desc_nr = -1;
 	rdev->faulty = 0;
 	rdev->in_sync = 0;
@@ -1820,6 +1949,13 @@ static int do_md_run(mddev_t * mddev)
 	mddev->safemode_timer.data = (unsigned long) mddev;
 	mddev->safemode_delay = (20 * HZ)/1000 +1; /* 20 msec delay */
 	mddev->in_sync = 1;
+
+	ITERATE_RDEV(mddev,rdev,tmp)
+		if (rdev->raid_disk >= 0) {
+			char nm[20];
+			sprintf(nm, "rd%d", rdev->raid_disk);
+			sysfs_create_link(&mddev->kobj, &rdev->kobj, nm);
+		}
 	
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
@@ -1941,9 +2077,18 @@ static int do_md_stop(mddev_t * mddev, i
 	 * Free resources if final stop
 	 */
 	if (!ro) {
+		mdk_rdev_t *rdev;
+		struct list_head *tmp;
 		struct gendisk *disk;
 		printk(KERN_INFO "md: %s stopped.\n", mdname(mddev));
 
+		ITERATE_RDEV(mddev,rdev,tmp)
+			if (rdev->raid_disk >= 0) {
+				char nm[20];
+				sprintf(nm, "rd%d", rdev->raid_disk);
+				sysfs_remove_link(&mddev->kobj, nm);
+			}
+
 		export_array(mddev);
 
 		mddev->array_size = 0;
@@ -3958,17 +4103,24 @@ void md_check_recovery(mddev_t *mddev)
 			if (rdev->raid_disk >= 0 &&
 			    (rdev->faulty || ! rdev->in_sync) &&
 			    atomic_read(&rdev->nr_pending)==0) {
-				if (mddev->pers->hot_remove_disk(mddev, rdev->raid_disk)==0)
+				if (mddev->pers->hot_remove_disk(mddev, rdev->raid_disk)==0) {
+					char nm[20];
+					sprintf(nm,"rd%d", rdev->raid_disk);
+					sysfs_remove_link(&mddev->kobj, nm);
 					rdev->raid_disk = -1;
+				}
 			}
 
 		if (mddev->degraded) {
 			ITERATE_RDEV(mddev,rdev,rtmp)
 				if (rdev->raid_disk < 0
 				    && !rdev->faulty) {
-					if (mddev->pers->hot_add_disk(mddev,rdev))
+					if (mddev->pers->hot_add_disk(mddev,rdev)) {
+						char nm[20];
+						sprintf(nm, "rd%d", rdev->raid_disk);
+						sysfs_create_link(&mddev->kobj, &rdev->kobj, nm);
 						spares++;
-					else
+					} else
 						break;
 				}
 		}

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2005-10-04 11:54:43.000000000 +1000
+++ ./include/linux/raid/md_k.h	2005-10-04 12:19:17.000000000 +1000
@@ -105,6 +105,8 @@ struct mdk_rdev_s
 	int		sb_size;	/* bytes in the superblock */
 	int		preferred_minor;	/* autorun support */
 
+	struct kobject	kobj;
+
 	/* A device can be in one of three states based on two flags:
 	 * Not working:   faulty==1 in_sync==0
 	 * Fully working: faulty==0 in_sync==1
