From: NeilBrown <neilb@suse.com>
Subject: Re: Linux Plumbers MD BOF discussion notes
Date: Thu, 05 Oct 2017 08:41:52 +1100
Message-ID: <87d162380v.fsf@notabene.neil.brown.name>
References: <20170915142737.qafwl3vgl6vhfi5q@kernel.org> <871sn78pzt.fsf@notabene.neil.brown.name> <alpine.DEB.2.20.1709180852450.29378@uplift.swm.pp.se> <874ls0s7un.fsf@notabene.neil.brown.name> <alpine.DEB.2.20.1710010730210.31961@uplift.swm.pp.se> <87lgkr3fgj.fsf@notabene.neil.brown.name> <619758c0-9ca4-c25d-c61b-f411b095041d@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <619758c0-9ca4-c25d-c61b-f411b095041d@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 04 2017, Artur Paszkiewicz wrote:

>
> Also, our customers are asking specifically for an option to "hide" the
> member drives. Making it impossible to write to the devices is ok, but
> they would like to see only the md device, "like hardware raid". One of
> the reasons is that some monitoring or inventory scan applications treat
> md arrays and their components as separate storage devices. They should
> probably modify their software but maybe that's not possible.

What exactly is meant by "hide".  How, exactly, does this software scan
all devices?  /proc/partitions? /sys/block? /sys/class/block?
/dev/disks?  All of the above.

Modifying their application *must* be on the table, else modify the
kernel is *not* on the table.  I'm certainly open to enhancing the
kernel so that it is easy to skip a particular class of devices, but if
their application chooses to ignore the information the kernel provides,
then the fact that the application doesn't work is their problem, not
ours.


>
> I've been experimenting with different solutions and here is a patch
> that allows to "hide" disk devices and their partitions by writing to a
> sysfs attribute. It removes the device nodes (on devtmpfs), links in
> /sys/block/ and removes the devices from the block class list, so they
> won't be included in places like /proc/partitions, /sys/class/block/,
> lsblk and so on. The device's "real" sysfs directory under /sys/devices/
> is still available, also the links in /sys/dev/block/ are preserved.
> Applications like mdadm can use this to hide/unhide their component
> devices.

Can you confirm that this addresses the customer problem?  Do you know
which of these lists their code looks at?

Thanks,
NeilBrown


>
> Thanks,
> Artur
>
> diff --git a/block/genhd.c b/block/genhd.c
> index 7f520fa25d16..58b8e3eb14af 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -685,6 +685,55 @@ void del_gendisk(struct gendisk *disk)
>  }
>  EXPORT_SYMBOL(del_gendisk);
>=20=20
> +static int hide_disk(struct gendisk *disk)
> +{
> +	struct device *ddev =3D disk_to_dev(disk);
> +	struct disk_part_iter piter;
> +	struct hd_struct *part;
> +	int ret;
> +
> +	ret =3D device_hide(ddev);
> +	if (ret)
> +		return ret;
> +
> +	disk_part_iter_init(&piter, disk,
> +			     DISK_PITER_INCL_EMPTY | DISK_PITER_REVERSE);
> +	while ((part =3D disk_part_iter_next(&piter)))
> +		device_hide(part_to_dev(part));
> +	disk_part_iter_exit(&piter);
> +
> +	if (!sysfs_deprecated)
> +		sysfs_remove_link(block_depr, dev_name(ddev));
> +
> +	return ret;
> +}
> +
> +static int unhide_disk(struct gendisk *disk)
> +{
> +	struct device *ddev =3D disk_to_dev(disk);
> +	struct disk_part_iter piter;
> +	struct hd_struct *part;
> +	int ret;
> +
> +	ret =3D device_unhide(ddev);
> +	if (ret)
> +		return ret;
> +
> +	disk_part_iter_init(&piter, disk, DISK_PITER_INCL_EMPTY);
> +	while ((part =3D disk_part_iter_next(&piter)))
> +		device_unhide(part_to_dev(part));
> +	disk_part_iter_exit(&piter);
> +
> +	if (!sysfs_deprecated) {
> +		if (sysfs_create_link(block_depr, &ddev->kobj,
> +				      kobject_name(&ddev->kobj)))
> +			pr_warn("%s: failed to restore /sys/block link\n",
> +				disk->disk_name);
> +	}
> +
> +	return ret;
> +}
> +
>  /* sysfs access to bad-blocks list. */
>  static ssize_t disk_badblocks_show(struct device *dev,
>  					struct device_attribute *attr,
> @@ -1017,6 +1066,31 @@ static ssize_t disk_discard_alignment_show(struct =
device *dev,
>  	return sprintf(buf, "%d\n", queue_discard_alignment(disk->queue));
>  }
>=20=20
> +static ssize_t disk_hidden_show(struct device *dev,
> +				struct device_attribute *attr,
> +				char *buf)
> +{
> +	return sprintf(buf, "%d\n", device_is_hidden(dev));
> +}
> +
> +static ssize_t disk_hidden_store(struct device *dev,
> +				 struct device_attribute *attr,
> +				 const char *buf, size_t len)
> +{
> +	struct gendisk *disk =3D dev_to_disk(dev);
> +	bool hide;
> +	int ret;
> +
> +	ret =3D kstrtobool(buf, &hide);
> +	if (ret)
> +		return ret;
> +
> +	if (hide !=3D device_is_hidden(dev))
> +		ret =3D hide ? hide_disk(disk) : unhide_disk(disk);
> +
> +	return ret ?: len;
> +}
> +
>  static DEVICE_ATTR(range, S_IRUGO, disk_range_show, NULL);
>  static DEVICE_ATTR(ext_range, S_IRUGO, disk_ext_range_show, NULL);
>  static DEVICE_ATTR(removable, S_IRUGO, disk_removable_show, NULL);
> @@ -1030,6 +1104,8 @@ static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, N=
ULL);
>  static DEVICE_ATTR(inflight, S_IRUGO, part_inflight_show, NULL);
>  static DEVICE_ATTR(badblocks, S_IRUGO | S_IWUSR, disk_badblocks_show,
>  		disk_badblocks_store);
> +static DEVICE_ATTR(hidden, S_IRUGO | S_IWUSR, disk_hidden_show,
> +		   disk_hidden_store);
>  #ifdef CONFIG_FAIL_MAKE_REQUEST
>  static struct device_attribute dev_attr_fail =3D
>  	__ATTR(make-it-fail, S_IRUGO|S_IWUSR, part_fail_show, part_fail_store);
> @@ -1058,6 +1134,7 @@ static struct attribute *disk_attrs[] =3D {
>  #ifdef CONFIG_FAIL_IO_TIMEOUT
>  	&dev_attr_fail_timeout.attr,
>  #endif
> +	&dev_attr_hidden.attr,
>  	NULL
>  };
>=20=20
> diff --git a/block/partition-generic.c b/block/partition-generic.c
> index c5ec8246e25e..0223a37c7a8c 100644
> --- a/block/partition-generic.c
> +++ b/block/partition-generic.c
> @@ -350,6 +350,9 @@ struct hd_struct *add_partition(struct gendisk *disk,=
 int partno,
>  	if (err)
>  		goto out_put;
>=20=20
> +	if (device_is_hidden(ddev))
> +		device_hide(pdev);
> +
>  	err =3D -ENOMEM;
>  	p->holder_dir =3D kobject_create_and_add("holders", &pdev->kobj);
>  	if (!p->holder_dir)
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 755451f684bc..0804a45b8fbf 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1871,6 +1871,71 @@ void device_del(struct device *dev)
>  }
>  EXPORT_SYMBOL_GPL(device_del);
>=20=20
> +DEFINE_KLIST(klist_hidden_devices, NULL, NULL);
> +
> +bool device_is_hidden(struct device *dev)
> +{
> +	bool ret =3D false;
> +
> +	if (dev->class) {
> +		mutex_lock(&dev->class->p->mutex);
> +		ret =3D (dev->knode_class.n_klist =3D=3D &klist_hidden_devices);
> +		mutex_unlock(&dev->class->p->mutex);
> +	}
> +	return ret;
> +}
> +
> +int device_hide(struct device *dev)
> +{
> +	char *envp[] =3D { "EVENT=3Dhide", NULL };
> +
> +	if (!dev->class)
> +		return -EINVAL;
> +
> +	if (MAJOR(dev->devt))
> +		devtmpfs_delete_node(dev);
> +
> +	device_remove_class_symlinks(dev);
> +
> +	mutex_lock(&dev->class->p->mutex);
> +	/* remove the device from the class list */
> +	klist_remove(&dev->knode_class);
> +	/* add to the hidden devices list */
> +	klist_add_tail(&dev->knode_class, &klist_hidden_devices);
> +	mutex_unlock(&dev->class->p->mutex);
> +
> +	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
> +
> +	return 0;
> +}
> +
> +int device_unhide(struct device *dev)
> +{
> +	char *envp[] =3D { "EVENT=3Dunhide", NULL };
> +	int err;
> +
> +	if (!dev->class)
> +		return -EINVAL;
> +
> +	err =3D device_add_class_symlinks(dev);
> +	if (err)
> +		return err;
> +
> +	if (MAJOR(dev->devt))
> +		devtmpfs_create_node(dev);
> +
> +	mutex_lock(&dev->class->p->mutex);
> +	/* remove the device from the hidden devices list */
> +	klist_remove(&dev->knode_class);
> +	/* tie the class to the device */
> +	klist_add_tail(&dev->knode_class, &dev->class->p->klist_devices);
> +	mutex_unlock(&dev->class->p->mutex);
> +
> +	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
> +
> +	return err;
> +}
> +
>  /**
>   * device_unregister - unregister device from system.
>   * @dev: device going away.
> diff --git a/include/linux/device.h b/include/linux/device.h
> index beabdbc08420..90ab1e6b63c6 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -1118,6 +1118,9 @@ extern void device_unregister(struct device *dev);
>  extern void device_initialize(struct device *dev);
>  extern int __must_check device_add(struct device *dev);
>  extern void device_del(struct device *dev);
> +extern bool device_is_hidden(struct device *dev);
> +extern int device_hide(struct device *dev);
> +extern int device_unhide(struct device *dev);
>  extern int device_for_each_child(struct device *dev, void *data,
>  		     int (*fn)(struct device *dev, void *data));
>  extern int device_for_each_child_reverse(struct device *dev, void *data,

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnVVaEACgkQOeye3VZi
gbn/ug/9Gnvk5dwx6XM+6K3hiGdc9AEs9LubOWzeJugCu+euQ44FPnOQzgeLa1dm
VgGeaU9Q7zvpC6U6srwIm+Ci7yNYIyLh9N8NV5FkBJiHEFxAxHDC5E5EkTOtlf4K
7VzAbgC6WVAEEXd3gYgzjejH2Few4V61eWY6H9pc2WQUg44f/6kKuQjoCw7B4SxY
4gwoxgEhiJ46nMi2M8Ub6UaG8J8bU1CDuTLoSsZNgMcn8mwNHMqyC0Eh3VTDZM61
8qMm+5FSQ+jHExp0f6GPLsQ3OlMtZwzFSG7W6NO08F/bYu9cClCA/ef7Xk8mAsK1
9CsiUoMbg2ilx0NM9rJauhyI6wl2vr3WT0gFTV7mJp3xGcEE3G3SsNjBVkwY8W9/
7Ght2vsz/RInWYIbjJp72tETQ1UD+rPKAi3Ce8VupBWOLXe58J4wuGWX6CJZkxQY
sqe5CWCQcSNLTK8UbQF0FM+6OYQvh5viVNTBLlJbxmmViBGBHXW8a6EkRpOLfECr
3cJLobEvFK2sdzGU+LMhZ8fjbttm+dA/ssPN7kXlOoV2UG+sgUk/O7wOSWeTOLfC
X7jSv6v9KdjeoC/Xmid/0nx3BQxKeV8Pvxw8fMVX5SDs77xbX3pVoN4X+B0Rzyrl
aYqYphiGcOInZFnoQlbpV4UduSN7SmhYejEvxzZ1ZPD1hYGoSgk=
=ATFl
-----END PGP SIGNATURE-----
--=-=-=--
