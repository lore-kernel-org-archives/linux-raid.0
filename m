From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: Linux Plumbers MD BOF discussion notes
Date: Wed, 4 Oct 2017 13:02:41 +0200
Message-ID: <619758c0-9ca4-c25d-c61b-f411b095041d@intel.com>
References: <20170915142737.qafwl3vgl6vhfi5q@kernel.org>
 <871sn78pzt.fsf@notabene.neil.brown.name>
 <alpine.DEB.2.20.1709180852450.29378@uplift.swm.pp.se>
 <874ls0s7un.fsf@notabene.neil.brown.name>
 <alpine.DEB.2.20.1710010730210.31961@uplift.swm.pp.se>
 <87lgkr3fgj.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87lgkr3fgj.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/04/2017 02:49 AM, NeilBrown wrote:
> On Sun, Oct 01 2017, Mikael Abrahamsson wrote:
> 
>> On Mon, 18 Sep 2017, NeilBrown wrote:
>>
>>> Anyway, thanks for the example of a real problem related to this.  It 
>>> does make it easier to think about.
>>
>> Btw, if someone does --zero-superblock or dd /dev/zero to to a component 
>> device that is active, what happens when mdadm --stop /dev/mdX is run? 
>> Does it write out the complete superblock again?
> 
> --zero-superblock won't work on a device that is currently part of an
> array.  dd /dev/zero will.
> When the array is stopped the metadata will be written if the array is
> not read-only and is not clean.
> So for 'linear' and 'raid0' it is never written.  For others it probably
> is but may not be.
> I'm not sure that forcing a write makes sense.  A dd could corrupt lots
> of stuff, and just saving the metadata is not a big win.
> 
> I've been playing with some code, and this patch makes it impossible to
> write to a device which is in-use by md.
> Well... not exactly.  If a partition is in-use by md, the whole device
> can still be written to.  But the partition itself cannot.
> Also if metadata is managed by user-space, writes are still allowed.
> To fix that, we would need to capture each write request and validate
> the sector range.  Not impossible, but ugly.
> 
> Also, by itself, this patch breaks the use of raid6check on an active
> array.  We could fix that by enabling writes whenever a region is
> suspended.
> 
> Still... maybe it is a starting point for thinking about the problem.

Hi Neil,

I tested your patch and it works. One minor issue: ioctls are still
allowed, so we can do e.g. blkdiscard on a component device or something
like this:

# mdadm -C /dev/md0 -e1.0 -l1 -n2 /dev/sd[ab] --assume-clean -R
# parted /dev/md0 mklabel msdos
# parted /dev/md0 mkpart primary 1M 100%
# partprobe /dev/sda
# dd if=/dev/zero of=/dev/sda1 bs=1M count=1
1+0 records in
1+0 records out
1048576 bytes (1.0 MB) copied, 0.010408 s, 101 MB/s

Earlier I was thinking about something similar to not allow writes to
devices used by md, but the problem with external metadata updates
looked like a showstopper to me. To keep it clean (and not ugly), I
think md would have to expose some special interface for updating
metadata from userspace.

Also, our customers are asking specifically for an option to "hide" the
member drives. Making it impossible to write to the devices is ok, but
they would like to see only the md device, "like hardware raid". One of
the reasons is that some monitoring or inventory scan applications treat
md arrays and their components as separate storage devices. They should
probably modify their software but maybe that's not possible.

I've been experimenting with different solutions and here is a patch
that allows to "hide" disk devices and their partitions by writing to a
sysfs attribute. It removes the device nodes (on devtmpfs), links in
/sys/block/ and removes the devices from the block class list, so they
won't be included in places like /proc/partitions, /sys/class/block/,
lsblk and so on. The device's "real" sysfs directory under /sys/devices/
is still available, also the links in /sys/dev/block/ are preserved.
Applications like mdadm can use this to hide/unhide their component
devices.

Thanks,
Artur

diff --git a/block/genhd.c b/block/genhd.c
index 7f520fa25d16..58b8e3eb14af 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -685,6 +685,55 @@ void del_gendisk(struct gendisk *disk)
 }
 EXPORT_SYMBOL(del_gendisk);
 
+static int hide_disk(struct gendisk *disk)
+{
+	struct device *ddev = disk_to_dev(disk);
+	struct disk_part_iter piter;
+	struct hd_struct *part;
+	int ret;
+
+	ret = device_hide(ddev);
+	if (ret)
+		return ret;
+
+	disk_part_iter_init(&piter, disk,
+			     DISK_PITER_INCL_EMPTY | DISK_PITER_REVERSE);
+	while ((part = disk_part_iter_next(&piter)))
+		device_hide(part_to_dev(part));
+	disk_part_iter_exit(&piter);
+
+	if (!sysfs_deprecated)
+		sysfs_remove_link(block_depr, dev_name(ddev));
+
+	return ret;
+}
+
+static int unhide_disk(struct gendisk *disk)
+{
+	struct device *ddev = disk_to_dev(disk);
+	struct disk_part_iter piter;
+	struct hd_struct *part;
+	int ret;
+
+	ret = device_unhide(ddev);
+	if (ret)
+		return ret;
+
+	disk_part_iter_init(&piter, disk, DISK_PITER_INCL_EMPTY);
+	while ((part = disk_part_iter_next(&piter)))
+		device_unhide(part_to_dev(part));
+	disk_part_iter_exit(&piter);
+
+	if (!sysfs_deprecated) {
+		if (sysfs_create_link(block_depr, &ddev->kobj,
+				      kobject_name(&ddev->kobj)))
+			pr_warn("%s: failed to restore /sys/block link\n",
+				disk->disk_name);
+	}
+
+	return ret;
+}
+
 /* sysfs access to bad-blocks list. */
 static ssize_t disk_badblocks_show(struct device *dev,
 					struct device_attribute *attr,
@@ -1017,6 +1066,31 @@ static ssize_t disk_discard_alignment_show(struct device *dev,
 	return sprintf(buf, "%d\n", queue_discard_alignment(disk->queue));
 }
 
+static ssize_t disk_hidden_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	return sprintf(buf, "%d\n", device_is_hidden(dev));
+}
+
+static ssize_t disk_hidden_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t len)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+	bool hide;
+	int ret;
+
+	ret = kstrtobool(buf, &hide);
+	if (ret)
+		return ret;
+
+	if (hide != device_is_hidden(dev))
+		ret = hide ? hide_disk(disk) : unhide_disk(disk);
+
+	return ret ?: len;
+}
+
 static DEVICE_ATTR(range, S_IRUGO, disk_range_show, NULL);
 static DEVICE_ATTR(ext_range, S_IRUGO, disk_ext_range_show, NULL);
 static DEVICE_ATTR(removable, S_IRUGO, disk_removable_show, NULL);
@@ -1030,6 +1104,8 @@ static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
 static DEVICE_ATTR(inflight, S_IRUGO, part_inflight_show, NULL);
 static DEVICE_ATTR(badblocks, S_IRUGO | S_IWUSR, disk_badblocks_show,
 		disk_badblocks_store);
+static DEVICE_ATTR(hidden, S_IRUGO | S_IWUSR, disk_hidden_show,
+		   disk_hidden_store);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 static struct device_attribute dev_attr_fail =
 	__ATTR(make-it-fail, S_IRUGO|S_IWUSR, part_fail_show, part_fail_store);
@@ -1058,6 +1134,7 @@ static struct attribute *disk_attrs[] = {
 #ifdef CONFIG_FAIL_IO_TIMEOUT
 	&dev_attr_fail_timeout.attr,
 #endif
+	&dev_attr_hidden.attr,
 	NULL
 };
 
diff --git a/block/partition-generic.c b/block/partition-generic.c
index c5ec8246e25e..0223a37c7a8c 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -350,6 +350,9 @@ struct hd_struct *add_partition(struct gendisk *disk, int partno,
 	if (err)
 		goto out_put;
 
+	if (device_is_hidden(ddev))
+		device_hide(pdev);
+
 	err = -ENOMEM;
 	p->holder_dir = kobject_create_and_add("holders", &pdev->kobj);
 	if (!p->holder_dir)
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 755451f684bc..0804a45b8fbf 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1871,6 +1871,71 @@ void device_del(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(device_del);
 
+DEFINE_KLIST(klist_hidden_devices, NULL, NULL);
+
+bool device_is_hidden(struct device *dev)
+{
+	bool ret = false;
+
+	if (dev->class) {
+		mutex_lock(&dev->class->p->mutex);
+		ret = (dev->knode_class.n_klist == &klist_hidden_devices);
+		mutex_unlock(&dev->class->p->mutex);
+	}
+	return ret;
+}
+
+int device_hide(struct device *dev)
+{
+	char *envp[] = { "EVENT=hide", NULL };
+
+	if (!dev->class)
+		return -EINVAL;
+
+	if (MAJOR(dev->devt))
+		devtmpfs_delete_node(dev);
+
+	device_remove_class_symlinks(dev);
+
+	mutex_lock(&dev->class->p->mutex);
+	/* remove the device from the class list */
+	klist_remove(&dev->knode_class);
+	/* add to the hidden devices list */
+	klist_add_tail(&dev->knode_class, &klist_hidden_devices);
+	mutex_unlock(&dev->class->p->mutex);
+
+	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
+
+	return 0;
+}
+
+int device_unhide(struct device *dev)
+{
+	char *envp[] = { "EVENT=unhide", NULL };
+	int err;
+
+	if (!dev->class)
+		return -EINVAL;
+
+	err = device_add_class_symlinks(dev);
+	if (err)
+		return err;
+
+	if (MAJOR(dev->devt))
+		devtmpfs_create_node(dev);
+
+	mutex_lock(&dev->class->p->mutex);
+	/* remove the device from the hidden devices list */
+	klist_remove(&dev->knode_class);
+	/* tie the class to the device */
+	klist_add_tail(&dev->knode_class, &dev->class->p->klist_devices);
+	mutex_unlock(&dev->class->p->mutex);
+
+	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
+
+	return err;
+}
+
 /**
  * device_unregister - unregister device from system.
  * @dev: device going away.
diff --git a/include/linux/device.h b/include/linux/device.h
index beabdbc08420..90ab1e6b63c6 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1118,6 +1118,9 @@ extern void device_unregister(struct device *dev);
 extern void device_initialize(struct device *dev);
 extern int __must_check device_add(struct device *dev);
 extern void device_del(struct device *dev);
+extern bool device_is_hidden(struct device *dev);
+extern int device_hide(struct device *dev);
+extern int device_unhide(struct device *dev);
 extern int device_for_each_child(struct device *dev, void *data,
 		     int (*fn)(struct device *dev, void *data));
 extern int device_for_each_child_reverse(struct device *dev, void *data,

