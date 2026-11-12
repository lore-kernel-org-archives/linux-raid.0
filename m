Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794485616;
	b=tjihljIlutNHyAw36Wxru7GNQRvqnEwR/LNq+poj2TrsnXcnBhw8Qu48RhaC2vYg6mXP
	 L0rrWiDHX/Kr1mWr1mCGCTZ7RXNFGu36Sd+YIF4iZ6Hl43ge6U26J/Qed5lCWe6rIM6+B
	 Le3/LZv7u1SLoWJe30o/NiFmbUwB/yyFtI9SJ0HGsC8Qjcg6wmGodWj6BDMpV75HEo9pY
	 CcMnchQizyrrnJwRhhWEB+F/ofHYc21E7yR0i0oV6xhsBRNkoIt+dC7+dCF1+dWqwqfJL
	 CRSlY2iNdCcnveVWL7mtUY/uLbZr9o/AY+JChGuIyueGiTU3hQZGKsJFnj3A5QflSOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794485616;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jyvKN9kAPrKoEg/N2y7gzAMN3km9rMLro0iNDuMlVo8=;
	b=I1YN+46/xH94XqACDN88RRRGwopph1ad5hieaHl6l15ohbStA7viEb+IhFwUGoR8wH5O
	 3hHYpk2C1zIh5ABM+DA1a9U6tKG+r+hOb382zZfFzdCIByi39o21a+aCCAuX/MTqxBMUP
	 vjloO2MAo4m3oJ4HBh2PW5YULJl0BMM98LKR1/UT/424ItCiJgyUA3tbpLfJXIht1SY5h
	 Pxe2FS6DiW9kxuWQyzQzBVJpzFwFH+uGn4twaoTNQTEqPxaJdlKvRSYU0TPzEqTMJNjeO
	 uuzldtUNkapFxs5x5afM8uC3VxkFw1vSgn5telGFi0o+cxhp1vjNVM+6N3C7iBXQRlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WAd2CbFm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7406606A31C
	for <linux-raid@vger.kernel.org>; Thu, 12 Nov 2026 12:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WAd2CbFm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B5B1F00A05;
	Thu, 12 Nov 2026 12:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794485616;
	bh=jyvKN9kAPrKoEg/N2y7gzAMN3km9rMLro0iNDuMlVo8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WAd2CbFmlPidQZ8AK29mgNbj9YLxVy+L6s5hCSceM/q/OOnKYXap/bBDD6X1/bnr7
	 xLHtHo8awkIlKFxD43HfZiW4TMU4tZYU97rs+IaeKljk3JIXgK2mH967LYPARXHwZj
	 LOajiSDbVFhdE8gEqvZ0oj+x0ZdVyboG5u5wgeOHi8nxjiIUNxzkdpH9/oaQl91mVp
	 T49oM5p0GQec/pABR+GmGJb9i7ib91ledoN3MjvO37wLaPbdGjq0NCELmNqIOxK1bG
	 p73mZv7QSmzL927xKUU5rt9GbMre9N4JiW+e73u+ocEe6+GBBFZ6iyOPWysLJWt2VC
	 t3zgZf4hvZgPA==
Message-ID: <sashiko-outbox-211074@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md: make mddev_get() fail until md_alloc() has finished
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20261112114958.2244-1-abd.masalkhi@gmail.com>
References: <20261112114958.2244-1-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 12:13:35 +0000
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] md: premature KOBJ_ADD uevent in add_disk() while mddev_get()
  fails
- [Low] md: stale reconfig_mutex lock and comment in md_alloc()
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [Medium] md: kernfs_node memory leak in mddev_unlock() [1]
--

commit 2ddaaecbff58458e8c38353164498300daf7d131
Author: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

md: make mddev_get() fail until md_alloc() has finished

This commit adds an mddev->sysfs_live flag set under all_mddevs_lock after
kobject_add() succeeds in md_alloc(), and updates mddev_get() to fail until
that flag is set.

Link: https://sashiko.dev/#/patchset/20261029202209.1422567-1-abd.masalkhi@=
gmail.com?part=3D4

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 03e35386a8028..47118e9d1a656 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -641,7 +641,7 @@ static inline struct mddev *mddev_get(struct mddev *m=
ddev)
>  {
>  	lockdep_assert_held(&all_mddevs_lock);
> =20
> -	if (test_bit(MD_DELETED, &mddev->flags))
> +	if (test_bit(MD_DELETED, &mddev->flags) || !mddev->sysfs_live)
>  		return NULL;
>  	atomic_inc(&mddev->active);
>  	return mddev;
> @@ -6432,10 +6432,16 @@ struct mddev *md_alloc(dev_t dev, char *name)
>  		return ERR_PTR(error);
>  	}
> =20
> -	kobject_uevent(&mddev->kobj, KOBJ_ADD);
>  	mddev->sysfs_state =3D sysfs_get_dirent_safe(mddev->kobj.sd, "array_sta=
te");
>  	mddev->sysfs_level =3D sysfs_get_dirent_safe(mddev->kobj.sd, "level");

[Severity: Medium]
This problem wasn't introduced by this patch, but when
legacy_async_del_gendisk is disabled, does mddev_unlock() leak
mddev->sysfs_state and mddev->sysfs_level [1]?

md_kobj_release() only calls sysfs_put() on mddev->sysfs_state and
mddev->sysfs_level when legacy_async_del_gendisk is true, and the
!legacy_async_del_gendisk teardown path in mddev_unlock() deletes
mddev->kobj and mddev->gendisk without releasing those kernfs_node
references:

drivers/md/md.c:md_kobj_release() {
	if (legacy_async_del_gendisk) {
		if (mddev->sysfs_state)
			sysfs_put(mddev->sysfs_state);
		if (mddev->sysfs_level)
			sysfs_put(mddev->sysfs_level);
		del_gendisk(mddev->gendisk);
	}
	put_disk(mddev->gendisk);
}

> +
> +	spin_lock(&all_mddevs_lock);
> +	mddev->sysfs_live =3D true;
> +	spin_unlock(&all_mddevs_lock);
> +
> +	kobject_uevent(&mddev->kobj, KOBJ_ADD);
>  	mutex_unlock(&disks_mutex);
> +
>  	return mddev;
> =20
>  out_put_disk:

[Severity: Medium]
Does making mddev_get() fail until mddev->sysfs_live is set cause a
regression where udevd or concurrent openers fail with -ENODEV in md_open()
and -EBUSY on md/ sysfs attributes right after add_disk() announces the
disk?

kobject_uevent(&mddev->kobj, KOBJ_ADD) is dropped by dev_uevent_filter()
because mddev->kobj has ktype &md_ktype rather than &device_ktype.  The
KOBJ_ADD uevent that actually reaches user space is sent earlier inside
add_disk() -> add_disk_final() -> disk_uevent(disk, KOBJ_ADD), right after
bdev_add() publishes the block device inode while mddev->sysfs_live is
still false:

CPU0                              CPU1 (udevd / opener)
md_alloc()
  add_disk(disk)
    add_disk_final(disk)
      bdev_add(...)
      disk_uevent(disk, KOBJ_ADD)
                                  blkdev_get_no_open()
                                  md_open()
                                    mddev_find()
                                      mddev_get() -> NULL  <-- -ENODEV
  kobject_add(&mddev->kobj, ...)
  mddev->sysfs_live =3D true

[Severity: Low]
Since mddev_get() now returns NULL until mddev->sysfs_live is set after
mddev_unlock(mddev), md_open() can no longer succeed while reconfig_mutex
is held across add_disk() and kobject_add() from commit d1472ca2ca5d ("md:
don't hand out the array before md_alloc() has added mddev->kobj").

drivers/md/md.c:md_alloc() {
	/*
	 * add_disk() makes the array openable before mddev->kobj exists.
	 * Hold reconfig_mutex until kobject_add() is done so that ioctls
	 * issued in between wait instead of using an uninitialised kobj.
	 */
	mddev_lock_nointr(mddev);
	error =3D add_disk(disk);
    ...
	error =3D kobject_add(&mddev->kobj, &disk_to_dev(disk)->kobj, "%s", "md");
	mddev_unlock(mddev);
}

Does this make the comment and reconfig_mutex critical section in
md_alloc() obsolete, as well as the commit message's first paragraph
claiming that ioctls such as ADD_NEW_DISK can run before kobject_add()
completes?

[1] https://sashiko.dev/#/bug/linux-460ea5ed-96ea-49a0-8383-cfa84f28520b

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112114958.2244=
-1-abd.masalkhi@gmail.com?part=3D1
