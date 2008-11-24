From: NeilBrown <neilb@suse.de>
Subject: [PATCH 2/2] Allow md devices to be created by name.
Date: Mon, 24 Nov 2008 14:55:31 +1100
Message-ID: <20081124035530.3465.78537.stgit@notabene.brown>
References: <20081124035516.3465.66413.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081124035516.3465.66413.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Doug Ledford <dledford@redhat.com>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Using sequential numbers to identify md devices is somewhat artificial.
Using names can be a lot more user-friendly.

Also, creating md devices by opening the device special file is a bit
awkward.

So this patch provides a new option for creating and naming devices.

Writing a name such as "md_home" to
    /sys/modules/md_mod/parameters/new_array
will cause an array with that name to be created.  It will appear in
/sys/block/ /proc/partitions and /proc/mdstat as 'md_home'.
It will have an arbitrary minor number allocated.

md devices that a created by an open are destroyed on the last
close when the device is inactive.
For names md devices, they will not be destroyed until the array
is explicitly stopped, either with the STOP_ARRAY ioctl or by
writing 'clear' to /sys/block/md_XXXX/md/array_state.

The name of the array must start 'md_' to avoid conflict with
other devices.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c           |  122 ++++++++++++++++++++++++++++++++++++++-------
 include/linux/raid/md_k.h |    1 
 2 files changed, 104 insertions(+), 19 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5ebda55..89700b5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -249,17 +249,51 @@ static mddev_t * mddev_find(dev_t unit)
 
  retry:
 	spin_lock(&all_mddevs_lock);
-	list_for_each_entry(mddev, &all_mddevs, all_mddevs)
-		if (mddev->unit == unit) {
-			mddev_get(mddev);
+
+	if (unit) {
+		list_for_each_entry(mddev, &all_mddevs, all_mddevs)
+			if (mddev->unit == unit) {
+				mddev_get(mddev);
+				spin_unlock(&all_mddevs_lock);
+				kfree(new);
+				return mddev;
+			}
+
+		if (new) {
+			list_add(&new->all_mddevs, &all_mddevs);
 			spin_unlock(&all_mddevs_lock);
-			kfree(new);
-			return mddev;
+			new->hold_active = UNTIL_CLOSE;
+			return new;
 		}
-
-	if (new) {
+	} else if (new) {
+		/* find an unused unit number */
+		static int next_minor = 512;
+		int start = next_minor;
+		int is_free = 0;
+		int dev = 0;
+		while (!is_free) {
+			dev = MKDEV(MD_MAJOR, next_minor);
+			next_minor++;
+			if (next_minor > MINORMASK)
+				next_minor = 0;
+			if (next_minor == start) {
+				/* Oh dear, all in use. */
+				spin_unlock(&all_mddevs_lock);
+				kfree(new);
+				return NULL;
+			}
+				
+			is_free = 1;
+			list_for_each_entry(mddev, &all_mddevs, all_mddevs)
+				if (mddev->unit == dev) {
+					is_free = 0;
+					break;
+				}
+		}
+		new->unit = dev;
+		new->md_minor = MINOR(dev);
+		new->hold_active = UNTIL_STOP;
 		list_add(&new->all_mddevs, &all_mddevs);
-		mddev->hold_active = UNTIL_CLOSE;
 		spin_unlock(&all_mddevs_lock);
 		return new;
 	}
@@ -3489,18 +3523,22 @@ static struct kobj_type md_ktype = {
 
 int mdp_major = 0;
 
-static struct kobject *md_probe(dev_t dev, int *part, void *data)
+static int md_alloc(dev_t dev, char *name)
 {
 	static DEFINE_MUTEX(disks_mutex);
 	mddev_t *mddev = mddev_find(dev);
 	struct gendisk *disk;
-	int partitioned = (MAJOR(dev) != MD_MAJOR);
-	int shift = partitioned ? MdpMinorShift : 0;
-	int unit = MINOR(dev) >> shift;
+	int partitioned;
+	int shift;
+	int unit;
 	int error;
 
 	if (!mddev)
-		return NULL;
+		return -ENODEV;
+
+	partitioned = (MAJOR(mddev->unit) != MD_MAJOR);
+	shift = partitioned ? MdpMinorShift : 0;
+	unit = MINOR(mddev->unit) >> shift;
 
 	/* wait for any previous instance if this device
 	 * to be completed removed (mddev_delayed_delete).
@@ -3511,14 +3549,29 @@ static struct kobject *md_probe(dev_t dev, int *part, void *data)
 	if (mddev->gendisk) {
 		mutex_unlock(&disks_mutex);
 		mddev_put(mddev);
-		return NULL;
+		return -EEXIST;
+	}
+
+	if (name) {
+		/* Need to ensure that 'name' is not a duplicate.
+		 */
+		mddev_t *mddev2;
+		spin_lock(&all_mddevs_lock);
+
+		list_for_each_entry(mddev2, &all_mddevs, all_mddevs)
+			if (mddev2->gendisk &&
+			    strcmp(mddev2->gendisk->disk_name, name) == 0) {
+				spin_unlock(&all_mddevs_lock);
+				return -EEXIST;
+			}
+		spin_unlock(&all_mddevs_lock);
 	}
 
 	mddev->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!mddev->queue) {
 		mutex_unlock(&disks_mutex);
 		mddev_put(mddev);
-		return NULL;
+		return -ENOMEM;
 	}
 	/* Can be unlocked because the queue is new: no concurrency */
 	queue_flag_set_unlocked(QUEUE_FLAG_CLUSTER, mddev->queue);
@@ -3531,11 +3584,13 @@ static struct kobject *md_probe(dev_t dev, int *part, void *data)
 		blk_cleanup_queue(mddev->queue);
 		mddev->queue = NULL;
 		mddev_put(mddev);
-		return NULL;
+		return -ENOMEM;
 	}
-	disk->major = MAJOR(dev);
+	disk->major = MAJOR(mddev->unit);
 	disk->first_minor = unit << shift;
-	if (partitioned)
+	if (name)
+		strcpy(disk->disk_name, name);
+	else if (partitioned)
 		sprintf(disk->disk_name, "md_d%d", unit);
 	else
 		sprintf(disk->disk_name, "md%d", unit);
@@ -3560,9 +3615,34 @@ static struct kobject *md_probe(dev_t dev, int *part, void *data)
 		mddev->sysfs_state = sysfs_get_dirent(mddev->kobj.sd, "array_state");
 	}
 	mddev_put(mddev);
+	return 0;
+}
+
+static struct kobject *md_probe(dev_t dev, int *part, void *data)
+{
+	md_alloc(dev, NULL);
 	return NULL;
 }
 
+static int add_named_array(const char *val, struct kernel_param *kp)
+{
+	/* val must be "md_*" where * is not all digits.
+	 * We allocate an array with a large free minor number, and
+	 * set the name to val.  val must not already be an active name.
+	 */
+	int len = strlen(val);
+	char buf[DISK_NAME_LEN];
+
+	while (len && val[len-1] == '\n')
+		len--;
+	if (len >= DISK_NAME_LEN)
+		return -E2BIG;
+	strlcpy(buf, val, len+1);
+	if (strncmp(buf, "md_", 3) != 0)
+		return -EINVAL;
+	return md_alloc(0, buf);
+}
+
 static void md_safemode_timeout(unsigned long data)
 {
 	mddev_t *mddev = (mddev_t *) data;
@@ -4023,6 +4103,8 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 		mddev->barriers_work = 0;
 		mddev->safemode = 0;
 		kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
+		if (mddev->hold_active == UNTIL_STOP)
+			mddev->hold_active = 0;
 
 	} else if (mddev->pers)
 		printk(KERN_INFO "md: %s switched to read-only mode.\n",
@@ -5127,7 +5209,8 @@ static int md_release(struct gendisk *disk, fmode_t mode)
 
 	BUG_ON(!mddev);
 	atomic_dec(&mddev->openers);
-	mddev->hold_active = 0;
+	if (mddev->hold_active == UNTIL_CLOSE)
+		mddev->hold_active = 0;
 	mddev_put(mddev);
 
 	return 0;
@@ -6498,6 +6581,7 @@ static int set_ro(const char *val, struct kernel_param *kp)
 module_param_call(start_ro, set_ro, get_ro, NULL, S_IRUSR|S_IWUSR);
 module_param(start_dirty_degraded, int, S_IRUGO|S_IWUSR);
 
+module_param_call(new_array, add_named_array, NULL, NULL, S_IWUSR);
 
 EXPORT_SYMBOL(register_md_personality);
 EXPORT_SYMBOL(unregister_md_personality);
diff --git a/include/linux/raid/md_k.h b/include/linux/raid/md_k.h
index 7b6029b..19756d7 100644
--- a/include/linux/raid/md_k.h
+++ b/include/linux/raid/md_k.h
@@ -139,6 +139,7 @@ struct mddev_s
 	struct kobject			kobj;
 	int				hold_active;
 #define	UNTIL_CLOSE	1
+#define	UNTIL_STOP	2
 
 	/* Superblock information */
 	int				major_version,


