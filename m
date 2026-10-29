Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793306884;
	b=0PMZ6Fz6rkRwKDLmJKbfIKjGKhdFCxzIYg9ld18uURur+gqa5GyEaIDmdI/gExzG6Ry2
	 m7uzPhMjDDQovjH92EbQKYBcqsfXo1wBskZkwCa+H6P6GzVK2k0ppKr7LbHVQ2zWozhMB
	 P+k9mCocDgBFc0dD4FYnxkanFdvu1eTutxs/V9b7wPxvM3PbKdfm8bLGTdtsF4YK2ZfRu
	 gH8EGA987/gTAvAjrjMJaCwpe4RfVRIxLHpvQz/qiZIFGbATy58t3cp8/BLI3LD4CPsTE
	 1jaqxLTihr9ZNzP3yCN+IWypXdm2W9YBzhYLuSLdpZt907p93Dvponn83cGxGpn0Vig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793306884;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=TsbArIddT7HAhpqUOGS7kygpC/50OM7Is0mXmYaeuow=;
	b=lmXEML8hChuJzlZlg3zLxVqMtm7Pr0XWwZ0YySdv1tHNfK030jhW9+fjXL517I5FX3pM
	 L0bWuMOYVVTFz8gTNJUTHtFBEDEI8bwQy5o2Dna+KIsxEIESExWAgssZhwnXbxhKLgUvo
	 /B0CqgRJnMnCkNNEkmCuktZs8PxEniN9gN7f+ov1Ax3Aw6FNcTf6XYFwrBcGvWOYNLoND
	 0Yojlz0RyQJWrMgbqPh14dSBaWJe8ECeTj7sgooBwhhIUMF48gTRIOyc1eJKskITZSP4g
	 9qPrHEG+z0JC3E6klxyHT5WAfUiuwbWOe0MYqqQ9nCMdw8Z6LVuqEEZ3mf99EIkvcjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ht9fOytJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99A4606A31A
	for <linux-raid@vger.kernel.org>; Thu, 29 Oct 2026 20:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ht9fOytJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6D91F01824;
	Thu, 29 Oct 2026 20:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306883;
	bh=TsbArIddT7HAhpqUOGS7kygpC/50OM7Is0mXmYaeuow=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ht9fOytJ4L/n35ajG+YZ9Kf1LlukZiaHQaHyWNfwj/Mpcrh0Jb75O43Bwlz4N2HSt
	 r2vpouKHUc8JW2+nIiA9q+JTpzlxiEZVJuhkTZ228Lv6Ge2n6SJiY9nCS3cP5QvANz
	 q24Zzc26JFwFCq9Ife/pLRQoJCceriR1IF5rMbfFhQBwyyJENaIjkcw8FhuHXjS6E/
	 gaNGlQxoDkDE8R7zEXKGcA8l2SijD+AW8m7KqDkaBusQqWdMNloDkMgCXLlh4lVnGe
	 D3AHDi/Ois+jAQVwc2aZE5lmLlO8MJT8Rs9i7F45SycbZVAI9NWZa0peqe33fxlryx
	 aUdFSfuEW8pOA==
Message-ID: <sashiko-outbox-189939@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v5 4/4] md: add a control device for array
 management
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20261029202209.1422567-5-abd.masalkhi@gmail.com>
References: <20261029202209.1422567-1-abd.masalkhi@gmail.com>
 <20261029202209.1422567-5-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 20:48:02 +0000
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 7 potential issue(=
s) to consider:
- [Critical] md: unlocked set_disk_faulty() call in mdctl_ioctl() races wit=
h __md_stop()
- [High] md: missing MD_CLOSING check in mdctl_find_mddev() and mdctl_ioctl=
()
- [High] md: missing state revalidation after lock drop in mdctl_ioctl()
- [Medium] md: MD_CTL_STOP_ARRAY with MD_CTL_RO_FLAG returns -EINVAL on ina=
ctive array
- [Medium] md: mdctl_get_mddev_uuid() and mdctl_lookup_array() use non-nati=
ve or stale uuid
- [Medium] md: tautological MINOR() check and u64 md_dev truncation in mdct=
l_find_mddev()
- [Medium] md: race between md_alloc() kobject_add() failure and mdctl_find=
_mddev()
--

commit a0c97489b840f0bb7566f8fcc5073f039699c2e5
Author: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

md: add a control device for array management

This commit introduces a /dev/md-control misc device to allow configuring,
querying, and stopping MD arrays by name, UUID, or device number without
opening the MD block device directly. It also moves disks_mutex to file
scope to synchronize control device lookups with md_alloc().

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 3b4497b615cf0..a1425b5e6b3ec 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c

[ ... ]

> @@ -8601,6 +8607,618 @@ static int md_compat_ioctl(struct block_device *b=
dev, blk_mode_t mode,
>  }
>  #endif /* CONFIG_COMPAT */
> =20
> +static struct mddev *mdctl_get_mddev_dev(dev_t dev)
> +{
> +	struct mddev *mddev, *ret =3D ERR_PTR(-EINVAL);
> +
> +	if (MINOR(dev) >=3D (1 << MINORBITS))
> +		return ret;

[ ... ]

> +static struct mddev *mdctl_get_mddev_uuid(const char *uuid)
> +{
> +	struct mddev *mddev, *ret =3D ERR_PTR(-ENODEV);
> +
> +	spin_lock(&all_mddevs_lock);
> +	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
> +		if (memcmp(mddev->uuid, uuid, sizeof(mddev->uuid)) =3D=3D 0) {
> +			ret =3D mddev_get(mddev);
> +			if (!ret)
> +				ret =3D ERR_PTR(-ENODEV);
> +			break;
> +		}
> +	}
> +	spin_unlock(&all_mddevs_lock);
> +
> +	return ret;
> +}

[Severity: Medium]
Can mdctl_get_mddev_uuid() and mdctl_lookup_array() match or report a
non-native or stale mddev->uuid?

The commit description notes that UUID lookup is only available for arrays
with native metadata, but there are two places where mddev->uuid is
populated on arrays that do not have active persistent native metadata:

1. In md_set_array_info(), get_random_bytes(mddev->uuid, 16) populates
   mddev->uuid even when info->not_persistent is set (!mddev->persistent).
   As a result, mdctl_get_mddev_uuid() matches non-persistent arrays and
   mdctl_lookup_array() copies a non-zero UUID to userspace for them.

2. When an array is stopped via do_md_stop() -> md_clean(), md_clean()
   resets mddev->raid_disks and mddev->persistent to 0, but never clears
   mddev->uuid:

drivers/md/md.c:md_clean() {
	mddev->array_sectors =3D 0;
	...
	mddev->raid_disks =3D 0;
	...
	mddev->persistent =3D 0;
}

If the stopped mddev remains in all_mddevs (for example, while
hold_active =3D=3D UNTIL_STOP or before delayed deletion completes),
mdctl_get_mddev_uuid() will still match its stale mddev->uuid. Furthermore,
if an older mddev with MD_DELETED set is still on all_mddevs when the array
is re-assembled on a new mddev later in the list, mddev_get() will return
NULL on the first match and mdctl_get_mddev_uuid() will break out of the
loop and return -ENODEV instead of continuing to find the live mddev.

Should mdctl_get_mddev_uuid() and mdctl_lookup_array() check
mddev->persistent (and skip entries where mddev_get() fails), or should
md_clean() also clear mddev->uuid?

> +
> +static struct mddev *mdctl_find_mddev(struct mdu_ioctl *md_ctl)
> +{
> +	struct mddev *ret =3D ERR_PTR(-EINVAL);
> +
> +	/*
> +	 * md_alloc() adds a new mddev to all_mddevs before it creates the
> +	 * gendisk. If creation fails. it frees the mddev directly, without
> +	 * looking at ->active. All of this happens under disks_mutex.
> +	 * Holding disks_mutex for the lookup means we only see mddevs that
> +	 * md_alloc() has finished, so taking a reference is safe and every
> +	 * mddev we find has a gendisk.
> +	 */
> +	mutex_lock(&disks_mutex);

[Severity: Medium]
Does holding disks_mutex in mdctl_find_mddev() prevent taking a reference to
an mddev when kobject_add() fails in md_alloc()?

In md_alloc(), if kobject_add() fails, disks_mutex is unlocked before
mddev_put() is called:

drivers/md/md.c:md_alloc() {
	...
	error =3D kobject_add(&mddev->kobj, &disk_to_dev(disk)->kobj, "%s", "md");
	if (error) {
		mddev->hold_active =3D 0;
		mutex_unlock(&disks_mutex);
		mddev_put(mddev);
		return ERR_PTR(error);
	}
}

Because MD_DELETED is only set inside mddev_put() -> __mddev_put() when
mddev->active drops to 0, a concurrent mdctl_ioctl() -> mdctl_find_mddev()
can acquire disks_mutex right after md_alloc() unlocks it and call
mddev_get(mddev), incrementing mddev->active from 1 to 2 before md_alloc()
calls mddev_put(mddev).

When md_alloc() then calls mddev_put(mddev), atomic_dec_and_lock() sees
mddev->active drop from 2 to 1 and returns early without setting MD_DELETED.
If the racing mdctl_ioctl() runs MD_CTL_SET_ARRAY_INFO, md_set_array_info()
sets mddev->ctime (and mddev->raid_disks), causing the subsequent
mddev_put() in mdctl_ioctl() to also skip __mddev_put() deletion and leaving
an mddev without a sysfs kobject in all_mddevs.

> +
> +	if (memchr_inv(md_ctl->md_uuid, 0, MD_UUID_LEN)) {
> +		if (*md_ctl->md_name || md_ctl->md_dev) {
> +			pr_err_ratelimited("md: only supply one of name, uuid or dev number\n=
");
> +			goto out;
> +		}
> +		ret =3D mdctl_get_mddev_uuid(md_ctl->md_uuid);
> +	} else if (*md_ctl->md_name) {
> +		if (md_ctl->md_dev) {
> +			pr_err_ratelimited("md: only supply one of name, uuid or dev number\n=
");
> +			goto out;
> +		}
> +		ret =3D mdctl_get_mddev_name(md_ctl->md_name);
> +	} else if (md_ctl->md_dev) {
> +		ret =3D mdctl_get_mddev_dev(new_decode_dev(md_ctl->md_dev));
> +	}

[Severity: Medium]
Can passing md_ctl->md_dev directly to new_decode_dev() silently truncate
64-bit device numbers, and is the MINOR(dev) check in mdctl_get_mddev_dev()
reachable?

In struct mdu_ioctl, md_dev is __u64, whereas new_decode_dev() takes a u32.
In 64-bit userspace, dev_t encodings (such as glibc makedev()) store
minor[31:20] and major[31:12] in the upper 32 bits. Passing md_ctl->md_dev
to new_decode_dev() without checking that it fits in u32 (or using
huge_decode_dev()) discards the upper 32 bits, so a device number with
minor =3D (1 << 20) decodes as minor 0 and aliases to md0 instead of failing
with -EINVAL.

In addition, in mdctl_get_mddev_dev():

	if (MINOR(dev) >=3D (1 << MINORBITS))
		return ret;

MINOR(dev) is defined as ((unsigned int)((dev) & MINORMASK)) where MINORMASK
is ((1U << MINORBITS) - 1), so MINOR(dev) >=3D (1 << MINORBITS) is always
false.

> +
> +out:
> +	mutex_unlock(&disks_mutex);
> +	return ret;
> +}

[ ... ]

> +static long mdctl_ioctl(struct file *filp, uint cmd, ulong u)
> +{

[ ... ]

> +	/* These commands do not need reconfig_mutex. */
> +	err =3D -ENODEV;
> +	switch (cmd) {
> +	case MD_CTL_GET_ARRAY_INFO:
> +		if (mddev_configured(mddev))
> +			err =3D mdctl_get_array_info(mddev, arg);
> +		goto out;
> +
> +	case MD_CTL_GET_DISK_INFO:
> +		if (mddev_configured(mddev))
> +			err =3D mdctl_get_disk_info(mddev, arg);
> +		goto out;
> +
> +	case MD_CTL_GET_BITMAP_FILE:
> +		err =3D get_bitmap_file(mddev, arg);
> +		goto out;
> +
> +	case MD_CTL_SET_DISK_FAULTY:
> +		err =3D set_disk_faulty(mddev, new_decode_dev(md_ctl.arg));
> +		goto out;
> +	}

[Severity: Critical]
Can calling set_disk_faulty() here without reconfig_mutex or an opener
reference race with __md_stop() and trigger a use-after-free or NULL pointer
dereference?

In the legacy block device md_ioctl() path, the caller holds /dev/mdX open,
so mddev->openers >=3D 1 prevents another task from stopping the array via
STOP_ARRAY. Through /dev/md-control, mdctl_ioctl() does not open the block
device, so mddev->openers is 0 and MD_CTL_SET_DISK_FAULTY runs without
reconfig_mutex.

If another task concurrently stops the array via MD_CTL_STOP_ARRAY (or writ=
es
"inactive" or "clear" to sysfs array_state), do_md_stop() calls
__md_stop(mddev) before export_array(mddev) unbinds the rdevs:

drivers/md/md.c:__md_stop() {
	...
	spin_lock(&mddev->lock);
	mddev->pers =3D NULL;
	spin_unlock(&mddev->lock);
	if (mddev->private)
		pers->free(mddev, mddev->private);
	mddev->private =3D NULL;
	put_pers(pers);
}

Concurrently, set_disk_faulty() only takes rcu_read_lock(), finds the still
bound rdev via md_find_rdev_rcu(), and calls md_error(mddev, rdev):

drivers/md/md.c:md_error() {
	...
	if (!mddev->pers || !mddev->pers->error_handler)
		return;
	mddev->pers->error_handler(mddev, rdev);

	if (mddev->pers->head.id =3D=3D ID_RAID0 ||
	    mddev->pers->head.id =3D=3D ID_LINEAR)
		return;
	...
}

Because __md_stop() clears mddev->pers and immediately frees mddev->private
(such as struct r1conf, r10conf, or r5conf) without waiting for an RCU grace
period or holding reconfig_mutex against set_disk_faulty(), md_error() and
mddev->pers->error_handler() can dereference a NULL mddev->pers or a freed
mddev->private.

> +
> +	if (cmd =3D=3D MD_CTL_STOP_ARRAY) {
> +		/* Need to flush page cache, and ensure no openers */
> +		err =3D mddev_set_closing_and_sync_blockdev(mddev, 0);
> +		if (err)
> +			goto out;
> +
> +		closing =3D true;
> +	}
> +
> +	if (!md_is_rdwr(mddev))
> +		flush_work(&mddev->sync_work);
> +
> +	suspend =3D mdctl_ioctl_need_suspend(cmd);
> +	err =3D suspend ? mddev_suspend_and_lock(mddev) : mddev_lock(mddev);
> +	if (err) {
> +		pr_debug("md: ioctl lock interrupted, reason %d, cmd %d\n",
> +			 err, cmd);
> +		goto out;
> +	}

[Severity: High]
Does mdctl_ioctl() or mdctl_find_mddev() need to check whether MD_CLOSING is
set on mddev->flags?

When legacy_async_del_gendisk is true (the default), stopping an array where
mddev->hold_active =3D=3D 0 via do_md_stop(mddev, 0) -> md_clean() leaves
MD_CLOSING set on mddev->flags without setting MD_DELETED:

drivers/md/md.c:md_clean() {
	...
	if (legacy_async_del_gendisk && mddev->hold_active) {
		clear_bit(MD_CLOSING, &mddev->flags);
	} else {
		/* if UNTIL_STOP is set, it's cleared here */
		mddev->hold_active =3D 0;
		/* Don't clear MD_CLOSING, or mddev can be opened again. */
		mddev->flags &=3D BIT_ULL_MASK(MD_CLOSING);
	}
}

For legacy block device ioctls, md_open() checks test_bit(MD_CLOSING,
&mddev->flags) and returns -ENODEV, preventing any new ioctls from
reconfiguring the array before mddev_put() -> __mddev_put() sets MD_DELETED
and queues del_work.

However, mdctl_find_mddev() -> mddev_get() and mddev_lock() only check
MD_DELETED, not MD_CLOSING. If a concurrent task issues MD_CTL_SET_ARRAY_IN=
FO
or MD_CTL_ADD_NEW_DISK via /dev/md-control and grabs a reference in
mdctl_find_mddev() before the stopping task's mddev_put() drops
mddev->active to 0, __mddev_put() will not run when the stop finishes. The
second task then locks the mddev and populates mddev->ctime,
mddev->raid_disks, or mddev->disks while MD_CLOSING is still set. When
mddev_put() later drops mddev->active to 0, __mddev_put() sees that the
mddev is no longer empty and returns early without deleting it:

drivers/md/md.c:__mddev_put() {
	if (mddev->raid_disks || !list_empty(&mddev->disks) ||
	    mddev->ctime || mddev->hold_active)
		return;
	...
}

This leaves MD_CLOSING permanently set on the mddev, leaking the mddev and
its bound rdevs and causing subsequent md_open() calls to fail with -ENODEV
and MD_CTL_STOP_ARRAY calls to fail with -EBUSY.

> +	if (suspend)
> +		noio_flags =3D memalloc_noio_save();
> +
> +	/*
> +	 * Commands querying/configuring an existing array.
> +	 *
> +	 * If the array is not initialised yet, check of the command requires
> +	 * the array to be initialised.
> +	 */
> +	if (!mddev_configured(mddev) && mdctl_ioctl_need_config(cmd, flags)) {
> +		err =3D -ENODEV;
> +		goto unlock;
> +	}
> +
> +	/*
> +	 * Commands even a read-only array can execute:
> +	 */
> +	switch (cmd) {
> +	case MD_CTL_SET_ARRAY_INFO:
> +		err =3D mdctl_set_array_info(mddev, arg);
> +		goto unlock;
> +
> +	case MD_CTL_RESTART_ARRAY_RW:
> +		err =3D restart_array(mddev);
> +		goto unlock;
> +
> +	case MD_CTL_STOP_ARRAY:
> +		err =3D -EINVAL;
> +		if (!flags)
> +			err =3D do_md_stop(mddev, 0);
> +		else if (flags =3D=3D MD_CTL_RO_FLAG && mddev->pers)
> +			err =3D md_set_readonly(mddev);
> +		goto unlock;

[Severity: Medium]
What happens when MD_CTL_STOP_ARRAY is called with flags =3D=3D MD_CTL_RO_F=
LAG
on a configured array that is not currently running (mddev->pers =3D=3D NUL=
L)?

In the legacy md_ioctl() handler, err is initialized to 0 before the switch:

drivers/md/md.c:md_ioctl() {
	...
	case STOP_ARRAY_RO:
		if (mddev->pers)
			err =3D md_set_readonly(mddev);
		goto unlock;
}

so STOP_ARRAY_RO on a configured but inactive array succeeds with 0 (and
clears mddev->hold_active =3D=3D UNTIL_IOCTL at unlock).

In mdctl_ioctl(), err is set to -EINVAL before the if/else chain, so when
flags =3D=3D MD_CTL_RO_FLAG and mddev->pers is NULL, neither branch is take=
n and
mdctl_ioctl() returns -EINVAL.

> +
> +	case MD_CTL_HOT_REMOVE_DISK:
> +		err =3D hot_remove_disk(mddev, new_decode_dev(md_ctl.arg));
> +		goto unlock;
> +
> +	case MD_CTL_ADD_NEW_DISK:
> +		/* We can support ADD_NEW_DISK on read-only arrays
> +		 * only if we are re-adding a preexisting device.
> +		 * So require mddev->pers and MD_DISK_SYNC.
> +		 */
> +		if (mddev->pers) {
> +			struct mdu_disk_info64 info;
> +
> +			if (copy_from_user(&info, arg, sizeof(info)))
> +				err =3D -EFAULT;
> +			else if (!(info.state & (1 << MD_DISK_SYNC)))
> +				/* Need to clear read-only for this */
> +				break;
> +			else
> +				err =3D md_add_new_disk(mddev, &info);
> +			goto unlock;
> +		}
> +		break;
> +	}
> +
> +	/*
> +	 * The remaining ioctls are changing the state of the
> +	 * superblock, so we do not allow them on read-only arrays.
> +	 */
> +	if (!md_is_rdwr(mddev) && mddev->pers) {
> +		if (mddev->ro !=3D MD_AUTO_READ) {
> +			err =3D -EROFS;
> +			goto unlock;
> +		}
> +		mddev->ro =3D MD_RDWR;
> +		sysfs_notify_dirent_safe(mddev->sysfs_state);
> +		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> +		/* mddev_unlock will wake thread */
> +		/* If a device failed while we were read-only, we
> +		 * need to make sure the metadata is updated now.
> +		 */
> +		if (test_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags)) {
> +			mddev_unlock(mddev);
> +			wait_event(mddev->sb_wait,
> +				   !test_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags) &&
> +				   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
> +			mddev_lock_nointr(mddev);
> +		}
> +	}

[Severity: High]
Can the array be stopped and deleted while mdctl_ioctl() drops
reconfig_mutex to wait on mddev->sb_wait here?

In md_ioctl(), the caller holds the block device open (mddev->openers >=3D =
1),
which prevents a concurrent STOP_ARRAY from passing
mddev_set_closing_and_sync_blockdev() while reconfig_mutex is dropped.
In mdctl_ioctl(), the block device is not open (mddev->openers =3D=3D 0).

When mdctl_ioctl() drops reconfig_mutex via mddev_unlock(mddev) and sleeps
in wait_event(mddev->sb_wait, ...), a concurrent MD_CTL_STOP_ARRAY (which
does not call mddev_suspend()) or a sysfs array_state write can acquire
reconfig_mutex and run do_md_stop(mddev, 0). That stops the personality,
exports all disks, clears mddev->sb_flags and mddev->raid_disks in
md_clean(), sets MD_DELETED (when !legacy_async_del_gendisk), and in
mddev_unlock() wakes mddev->sb_wait and deletes the gendisk.

mdctl_ioctl() then wakes up, reacquires reconfig_mutex via
mddev_lock_nointr(mddev) (which does not check MD_DELETED or MD_CLOSING),
and proceeds into the switch below without revalidating that the array is
still active or configured. For example, if cmd is MD_CTL_ADD_NEW_DISK,
md_add_new_disk() will see mddev->raid_disks =3D=3D 0 and bind a new rdev o=
nto
the stopped/deleted mddev, preventing __mddev_put() from freeing the mddev
and leaving the rdev's block device claimed.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029202209.1422=
567-1-abd.masalkhi@gmail.com?part=3D4
