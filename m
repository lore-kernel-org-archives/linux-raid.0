Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794489355;
	b=NfpZSDXsujf0Lhm498iHgewe9Ew4Bi8LvGq5lCKxn89sTjJXmbiRq3pURma+gkjZeyhr
	 PATSFXujEfkciPXYlPyHLTf08WNWAwfCegH9HEMHdqVSXr3WF70kisZ8FRRJpHzf4Gxud
	 gysQDicPYoQPqft3RGUammUVFGVNkAx/uKR81dVLi1ihj0WQByGPdlaw1TM2TJudUMVu7
	 fKnbrx33lKYyJlb1yJIDe0W5XkBHIT3fhUn4kuyAp6Vr9+OGmxAWPt4FqmqqLk25o+acI
	 y3PLNdUIQYhEWxllmwfTifXbUgQYesHs6MKxIklYagikrSwgF2ol2Desvuq1hM/0h8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794489355;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 In-Reply-To:References:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=jAZcQQUpnQ9GKTr7ms5g7gJOwcuBaJvlyqVQ5mDpxJQ=;
	b=RpeNIriWSvSWDQ6GJWbpYZAlU8m35eawEHOyeWPEUwKEOXlzEQG6NfkWssS9tUKpRjNm
	 LJa9dTCL5+lXNEeAhmAuNdXyviV7C4aCA9khEJqoDk+JCvOl30yF2mnte9TfAuhgTgXKd
	 CDsBvR1iyl5ieNv1vnD0IUesHUbpyea2XAQEog5tsosz6s54XSXk39rKA/inHki+FBVCX
	 uoy1K40PA5F5FuoW7EyJRnj4nvLj8Q9rws7cRs+mdY9R3pCTeRWhUr3W4SBT8EA3u0OPB
	 SIuvZnEk9hegzhiHAIgrhZDyoaRAG4MoGWBJUjYdnH5fTwuFs/0hYYrwCFzQs9yePKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aFnZ4HMU;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6639606A327
	for <linux-raid@vger.kernel.org>; Thu, 12 Nov 2026 13:15:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B6639606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aFnZ4HMU
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4b7252a32c8so46154705e9.0
        for <linux-raid@vger.kernel.org>; Thu, 12 Nov 2026 05:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794489353; x=1795094153; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jAZcQQUpnQ9GKTr7ms5g7gJOwcuBaJvlyqVQ5mDpxJQ=;
        b=aFnZ4HMUQa5Qp5+K5GxXrXLSFGHudh82tdGjekij0djzrTYxNivi/fFH/mc8bvClH/
         ApjlltSkBqhzOo3XgVDUTPevdv8JJ+YYG2tzRIUDgjrb6U9RzkFJJFJg5I22SJt8qR7e
         RBdkGrGTlI++SKyROXLk2D0+kljnSnqMFSz7f9QEdRyYbg7FMQypm0P/8NFqxUawf9YN
         bcXDMi9QOMiHI890y7LYZkje1yb0j0LEzhUE52lC95F54C05LqkY160Lh3pjnIm9PYzl
         4MI+4dVt2DP2tswxh8ZDks9l2d+dm/31Jp2nIOsBaqXftSF7rYJ+p1ak3zgb4rIjpu8s
         nt0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794489353; x=1795094153;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jAZcQQUpnQ9GKTr7ms5g7gJOwcuBaJvlyqVQ5mDpxJQ=;
        b=Ul6nwFANl9m0iraNNZvkD6S9cwxfVHUk7QjSt12iVC7Bspt0RTfErkDzIQeMaGe5st
         VPSxvVdna8RDUyeD+AO6uulWyAeVJT+RAbKcx7hOuiL+PRAbkWNUY9gzOO2rNFCsm2tO
         e+tIzYZzBvWv5Gy8SBi7K6UWoUE4u+v+w5nnkf3ALu032yLfWjSg0iPkZrfVYby0nNby
         v4oEuJOh9ic8IixHGQJ1/ye07XsWCDUNXdLy5XZ41AMJK8wxda6JAPTPhMLDKvole2hK
         kK/xPFaAVXkuzRUnvY1/7I5Ig3u3moqz1bf8X/7V+nq7jQ5elBZ19XI84EZpSpHNLw6T
         Csvg==
X-Gm-Message-State: APuU4Z+dPfNU6IE3bV7m3Ws5puwOcG3EY/+MfSO7T5RHYjXG5qEIP6xj
	8psAkMzqjm38sP/562NIJouJyJN2yPJjTVYrsVOpo4ATXWisrU/2DzK3
X-Gm-Gg: AYBFou005RtJOAyozeoPvXDvYgQlSSIPZSOPyyYvisKSrxhwsqecroTGdn/TUbZtSM1
	eLGiuZQ36LbRv6ZRaLHh0y15BzlLIJkPTlx+0w0v6Y/ETM+rmIU7SrzdpX8cOQ1twl5G3CHSsVP
	cO55BJ7uI5Vbco+TfUPJrVX37ESo1CVrixGbT7A/ZfJCR8/5QqH5qAiJT61zds1BfP8ivaWc3uN
	BKoWOEALwYsS9qY6c95b0QwS5h25H8EF12jAHJlk1X+jx3JciNTis8lCV0j0Gfkx6twawqigBdq
	lYVb9FfSvi8FEI7X16ai/yDgfMwweKCsMTnbF5jEBoYowaN4JRy8Rom3f4vSdirxcmOKrd8xr5j
	gxhRUAP9r7TNVwRRV3u2R3pbthGByCHI+rPIpEhGMWQmFsjXnqFDQOVkEKq+F1tkH5q5KVyiITO
	yikSabq/gpBWAsWFRFQSY9FE+dPdYtoXgko+9OpJLyHacYvCQBi8LiqRPzake+/OZykkE96m66h
	EvrvB7jCs6PhrZW/1Md9xiVuCniiWeHXSGCm/vE4a7qhvRMiBIaTWhC8dI0KcuhpXz7qGlIiv9/
	uD6MzL2jSlYoaQ8EdvuTDd2qQT9j9i0jULzeakghFZny1ep6tVZ8wUilZCrvABMe/6WZck4peaI
	0IPbGrNTX
X-Received: by 2002:a05:600c:810c:b0:4a3:59c9:a756 with SMTP id 5b1f17b1804b1-4ba09364b9emr102437525e9.6.1794489352840;
        Thu, 12 Nov 2026 05:15:52 -0800 (PST)
Received: from Abds-MacBook-Air.local ([195.72.110.73])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e29daa5sm74401895e9.12.2026.11.12.05.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 05:15:52 -0800 (PST)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
Subject: Re: [PATCH] md: make mddev_get() fail until md_alloc() has finished
In-Reply-To: <sashiko-outbox-211074@kernel.org>
References: <20261112114958.2244-1-abd.masalkhi@gmail.com>
 <sashiko-outbox-211074@kernel.org>
Date: Thu, 12 Nov 2026 14:15:51 +0100
Message-ID: <m2tslm1988.fsf@gmail.com>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Kuai,

On Thu, Nov 12, 2026 at 12:13 +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issues to consider:
> - [Medium] md: premature KOBJ_ADD uevent in add_disk() while mddev_get()
>   fails
> - [Low] md: stale reconfig_mutex lock and comment in md_alloc()
> It also noticed 1 related pre-existing issue this patch does not
> introduce:
> - [Medium] md: kernfs_node memory leak in mddev_unlock() [1]
> --
>
> commit 2ddaaecbff58458e8c38353164498300daf7d131
> Author: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>
> md: make mddev_get() fail until md_alloc() has finished
>
> This commit adds an mddev->sysfs_live flag set under all_mddevs_lock after
> kobject_add() succeeds in md_alloc(), and updates mddev_get() to fail unt=
il
> that flag is set.
>
> Link: https://sashiko.dev/#/patchset/20261029202209.1422567-1-abd.masalkh=
i@gmail.com?part=3D4
>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 03e35386a8028..47118e9d1a656 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -641,7 +641,7 @@ static inline struct mddev *mddev_get(struct mddev *=
mddev)
>>  {
>>  	lockdep_assert_held(&all_mddevs_lock);
>>=20=20
>> -	if (test_bit(MD_DELETED, &mddev->flags))
>> +	if (test_bit(MD_DELETED, &mddev->flags) || !mddev->sysfs_live)
>>  		return NULL;
>>  	atomic_inc(&mddev->active);
>>  	return mddev;
>> @@ -6432,10 +6432,16 @@ struct mddev *md_alloc(dev_t dev, char *name)
>>  		return ERR_PTR(error);
>>  	}
>>=20=20
>> -	kobject_uevent(&mddev->kobj, KOBJ_ADD);
>>  	mddev->sysfs_state =3D sysfs_get_dirent_safe(mddev->kobj.sd, "array_st=
ate");
>>  	mddev->sysfs_level =3D sysfs_get_dirent_safe(mddev->kobj.sd, "level");
>
> [Severity: Medium]
> This problem wasn't introduced by this patch, but when
> legacy_async_del_gendisk is disabled, does mddev_unlock() leak
> mddev->sysfs_state and mddev->sysfs_level [1]?
>
> md_kobj_release() only calls sysfs_put() on mddev->sysfs_state and
> mddev->sysfs_level when legacy_async_del_gendisk is true, and the
> !legacy_async_del_gendisk teardown path in mddev_unlock() deletes
> mddev->kobj and mddev->gendisk without releasing those kernfs_node
> references:
>
> drivers/md/md.c:md_kobj_release() {
> 	if (legacy_async_del_gendisk) {
> 		if (mddev->sysfs_state)
> 			sysfs_put(mddev->sysfs_state);
> 		if (mddev->sysfs_level)
> 			sysfs_put(mddev->sysfs_level);
> 		del_gendisk(mddev->gendisk);
> 	}
> 	put_disk(mddev->gendisk);
> }
>
>> +
>> +	spin_lock(&all_mddevs_lock);
>> +	mddev->sysfs_live =3D true;
>> +	spin_unlock(&all_mddevs_lock);
>> +
>> +	kobject_uevent(&mddev->kobj, KOBJ_ADD);
>>  	mutex_unlock(&disks_mutex);
>> +
>>  	return mddev;
>>=20=20
>>  out_put_disk:
>
> [Severity: Medium]
> Does making mddev_get() fail until mddev->sysfs_live is set cause a
> regression where udevd or concurrent openers fail with -ENODEV in md_open=
()
> and -EBUSY on md/ sysfs attributes right after add_disk() announces the
> disk?
>
> kobject_uevent(&mddev->kobj, KOBJ_ADD) is dropped by dev_uevent_filter()
> because mddev->kobj has ktype &md_ktype rather than &device_ktype.  The
> KOBJ_ADD uevent that actually reaches user space is sent earlier inside
> add_disk() -> add_disk_final() -> disk_uevent(disk, KOBJ_ADD), right after
> bdev_add() publishes the block device inode while mddev->sysfs_live is
> still false:
>
> CPU0                              CPU1 (udevd / opener)
> md_alloc()
>   add_disk(disk)
>     add_disk_final(disk)
>       bdev_add(...)
>       disk_uevent(disk, KOBJ_ADD)
>                                   blkdev_get_no_open()
>                                   md_open()
>                                     mddev_find()
>                                       mddev_get() -> NULL  <-- -ENODEV
>   kobject_add(&mddev->kobj, ...)
>   mddev->sysfs_live =3D true
>

I missed this case. Do you have a suggestion for a better fix, or should
I just drop this patch?

> [Severity: Low]
> Since mddev_get() now returns NULL until mddev->sysfs_live is set after
> mddev_unlock(mddev), md_open() can no longer succeed while reconfig_mutex
> is held across add_disk() and kobject_add() from commit d1472ca2ca5d ("md:
> don't hand out the array before md_alloc() has added mddev->kobj").
>
> drivers/md/md.c:md_alloc() {
> 	/*
> 	 * add_disk() makes the array openable before mddev->kobj exists.
> 	 * Hold reconfig_mutex until kobject_add() is done so that ioctls
> 	 * issued in between wait instead of using an uninitialised kobj.
> 	 */
> 	mddev_lock_nointr(mddev);
> 	error =3D add_disk(disk);
>     ...
> 	error =3D kobject_add(&mddev->kobj, &disk_to_dev(disk)->kobj, "%s", "md"=
);
> 	mddev_unlock(mddev);
> }
>
> Does this make the comment and reconfig_mutex critical section in
> md_alloc() obsolete, as well as the commit message's first paragraph
> claiming that ioctls such as ADD_NEW_DISK can run before kobject_add()
> completes?
>
> [1] https://sashiko.dev/#/bug/linux-460ea5ed-96ea-49a0-8383-cfa84f28520b
>
> --=20
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112114958.22=
44-1-abd.masalkhi@gmail.com?part=3D1

--=20
Best Regards,
Abd-Alrhman
