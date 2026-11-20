Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795171327;
	b=JjwpdZxEZYV64juwfhnOL7PqtIzOz/5LZglmYdh9D/CZtu8IZiqPNnjda4aaXPUjoIhm
	 iJAaxIhNaoYdbLxQX6tZoXvQgufeRMX9MPn1IQETnuM0fTWZ7VzBYwmFOq8uOO0W97qoi
	 keLh+mAvzgD5KtqphoCdoLz/sFAszbjiL90C5cw7RH4aFrszYIGPbaec1McDDMycJIHtS
	 wjnA+gvD97MEUtppF00Z9F74BtDFc0KQwD3RUIjIE/w5KgLArPYm9JIUIVo5tMjkDpJ6Q
	 f4vSxOUzLm4cQ9WDPTwkah0D3kS3Sj0P3Iah/qba2a5LYRKiIlwuJYAeAZNt9X8wLDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795171327;
	h=DMARC-Filter:DKIM-Signature:Cc:Mime-Version:Reply-To:Message-Id:
	 X-Lms-Return-Path:From:Date:Received:User-Agent:References:
	 In-Reply-To:To:Subject:Content-Type:Content-Transfer-Encoding:
	 X-Original-From;
	bh=um2hLh/hHD8l3GcR5JLblt1Cnw1tyAk72z1sNQOCRRM=;
	b=oZua9+2img5lNOpDNsZ2xqkxLrX46rZFM753BhP26auFPRNm+aQpVaw9SJ7TOcuOsTb1
	 UWxPYVW6i2ZlWIdzsNTdbcRSgb5BwMJK9C5n1Y4F/IBcvyHXSkTV18P73frwd2pv1ztc0
	 Uc7uovc+lmv6YeoejLnvbtJjNPnzLc0ontUL45vJvOmaN9cZ6pLkJOK88ajHePRAes641
	 CbY3it61Blvpc9TNk5tkmWeiKOmPzhCrpK3yixwz0h/y0efH7OZePsLgGLrWZHXx8+UqW
	 xFFOUe26x3UMzroNu79Hn3Rxe/M+Ey+EO/LDh7dFU1ANj0CJtqKVPhsjve5a/OUmxQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=YH6q1vZW;
	arc=none smtp.remote-ip=209.127.231.43
Received: from va-2-43.ptr.blmpb.com (va-2-43.ptr.blmpb.com [209.127.231.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17E4606A320
	for <linux-raid@vger.kernel.org>; Fri, 20 Nov 2026 10:42:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C17E4606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=YH6q1vZW
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1795171319;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=um2hLh/hHD8l3GcR5JLblt1Cnw1tyAk72z1sNQOCRRM=;
 b=YH6q1vZW69WnKvnCjSNa6fEig2t9WlTdgVvEflmXW8WUAzS9txCKsEWWlNTYemezVP6pIv
 ZByIpLEEzHxTxiP1m/6BuQBnLsQVPSt04tCuQCfKcyRidFZWIPI7+EUuT/panSv061+yc3
 slo0tfOcFhpvzwbr1t/jWLsWka69mVeuw07TKB9TX26h+6VdFdMPvf2EpPLM21A1AVpfDJ
 i6jsAyCAfAXq/rb0aEfuYK9YP0HK+N6s2xHZwoKKm9j/LaSBdzYyFgIar6GnQ1XYkTmzqo
 Y1dLhY7wXE5p2zN1yvFJPOjy7w+o4VdmOnZPIDBP/DWdkplG5qbDeCzN3gRy1w==
Cc: <linux-raid@vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Reply-To: yukuai@fygo.io
Message-Id: <e0d5c880-ea38-4f25-8c1a-3bca0a4a5dcc@fygo.io>
X-Lms-Return-Path: <lba+26b0023f6+a2ef9d+vger.kernel.org+yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Date: Fri, 20 Nov 2026 18:41:53 +0800
Received: from [192.168.1.104] ([39.182.0.159]) by smtp.larksuite.com with ESMTPS; Fri, 20 Nov 2026 10:41:57 +0000
User-Agent: Mozilla Thunderbird
References: <20261112114958.2244-1-abd.masalkhi@gmail.com> <sashiko-outbox-211074@kernel.org> <m2tslm1988.fsf@gmail.com>
In-Reply-To: <m2tslm1988.fsf@gmail.com>
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, 
	<sashiko-reviews@lists.linux.dev>, "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH] md: make mddev_get() fail until md_alloc() has finished
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Original-From: yu kuai <yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/11/12 21:15, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
> Hi Kuai,
>
> On Thu, Nov 12, 2026 at 12:13 +0000, sashiko-bot@kernel.org wrote:
>> Thank you for your contribution! Sashiko AI review found 2 potential
>> issues to consider:
>> - [Medium] md: premature KOBJ_ADD uevent in add_disk() while mddev_get()
>>    fails
>> - [Low] md: stale reconfig_mutex lock and comment in md_alloc()
>> It also noticed 1 related pre-existing issue this patch does not
>> introduce:
>> - [Medium] md: kernfs_node memory leak in mddev_unlock() [1]
>> --
>>
>> commit 2ddaaecbff58458e8c38353164498300daf7d131
>> Author: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>>
>> md: make mddev_get() fail until md_alloc() has finished
>>
>> This commit adds an mddev->sysfs_live flag set under all_mddevs_lock aft=
er
>> kobject_add() succeeds in md_alloc(), and updates mddev_get() to fail un=
til
>> that flag is set.
>>
>> Link: https://sashiko.dev/#/patchset/20261029202209.1422567-1-abd.masalk=
hi@gmail.com?part=3D4
>>
>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>> index 03e35386a8028..47118e9d1a656 100644
>>> --- a/drivers/md/md.c
>>> +++ b/drivers/md/md.c
>>> @@ -641,7 +641,7 @@ static inline struct mddev *mddev_get(struct mddev =
*mddev)
>>>   {
>>>   	lockdep_assert_held(&all_mddevs_lock);
>>>  =20
>>> -	if (test_bit(MD_DELETED, &mddev->flags))
>>> +	if (test_bit(MD_DELETED, &mddev->flags) || !mddev->sysfs_live)
>>>   		return NULL;
>>>   	atomic_inc(&mddev->active);
>>>   	return mddev;
>>> @@ -6432,10 +6432,16 @@ struct mddev *md_alloc(dev_t dev, char *name)
>>>   		return ERR_PTR(error);
>>>   	}
>>>  =20
>>> -	kobject_uevent(&mddev->kobj, KOBJ_ADD);
>>>   	mddev->sysfs_state =3D sysfs_get_dirent_safe(mddev->kobj.sd, "array_=
state");
>>>   	mddev->sysfs_level =3D sysfs_get_dirent_safe(mddev->kobj.sd, "level"=
);
>> [Severity: Medium]
>> This problem wasn't introduced by this patch, but when
>> legacy_async_del_gendisk is disabled, does mddev_unlock() leak
>> mddev->sysfs_state and mddev->sysfs_level [1]?
>>
>> md_kobj_release() only calls sysfs_put() on mddev->sysfs_state and
>> mddev->sysfs_level when legacy_async_del_gendisk is true, and the
>> !legacy_async_del_gendisk teardown path in mddev_unlock() deletes
>> mddev->kobj and mddev->gendisk without releasing those kernfs_node
>> references:
>>
>> drivers/md/md.c:md_kobj_release() {
>> 	if (legacy_async_del_gendisk) {
>> 		if (mddev->sysfs_state)
>> 			sysfs_put(mddev->sysfs_state);
>> 		if (mddev->sysfs_level)
>> 			sysfs_put(mddev->sysfs_level);
>> 		del_gendisk(mddev->gendisk);
>> 	}
>> 	put_disk(mddev->gendisk);
>> }
>>
>>> +
>>> +	spin_lock(&all_mddevs_lock);
>>> +	mddev->sysfs_live =3D true;
>>> +	spin_unlock(&all_mddevs_lock);
>>> +
>>> +	kobject_uevent(&mddev->kobj, KOBJ_ADD);
>>>   	mutex_unlock(&disks_mutex);
>>> +
>>>   	return mddev;
>>>  =20
>>>   out_put_disk:
>> [Severity: Medium]
>> Does making mddev_get() fail until mddev->sysfs_live is set cause a
>> regression where udevd or concurrent openers fail with -ENODEV in md_ope=
n()
>> and -EBUSY on md/ sysfs attributes right after add_disk() announces the
>> disk?
>>
>> kobject_uevent(&mddev->kobj, KOBJ_ADD) is dropped by dev_uevent_filter()
>> because mddev->kobj has ktype &md_ktype rather than &device_ktype.  The
>> KOBJ_ADD uevent that actually reaches user space is sent earlier inside
>> add_disk() -> add_disk_final() -> disk_uevent(disk, KOBJ_ADD), right aft=
er
>> bdev_add() publishes the block device inode while mddev->sysfs_live is
>> still false:
>>
>> CPU0                              CPU1 (udevd / opener)
>> md_alloc()
>>    add_disk(disk)
>>      add_disk_final(disk)
>>        bdev_add(...)
>>        disk_uevent(disk, KOBJ_ADD)
>>                                    blkdev_get_no_open()
>>                                    md_open()
>>                                      mddev_find()
>>                                        mddev_get() -> NULL  <-- -ENODEV
>>    kobject_add(&mddev->kobj, ...)
>>    mddev->sysfs_live =3D true
>>
> I missed this case. Do you have a suggestion for a better fix, or should
> I just drop this patch?

Please drop this patch, let open disk fail is not a good idea.

I think you can just set a new flag to mddev if kobject_add failed, and che=
ck
the flag during opening, right after reconfig_mutex is grabbed.

>
>> [Severity: Low]
>> Since mddev_get() now returns NULL until mddev->sysfs_live is set after
>> mddev_unlock(mddev), md_open() can no longer succeed while reconfig_mute=
x
>> is held across add_disk() and kobject_add() from commit d1472ca2ca5d ("m=
d:
>> don't hand out the array before md_alloc() has added mddev->kobj").
>>
>> drivers/md/md.c:md_alloc() {
>> 	/*
>> 	 * add_disk() makes the array openable before mddev->kobj exists.
>> 	 * Hold reconfig_mutex until kobject_add() is done so that ioctls
>> 	 * issued in between wait instead of using an uninitialised kobj.
>> 	 */
>> 	mddev_lock_nointr(mddev);
>> 	error =3D add_disk(disk);
>>      ...
>> 	error =3D kobject_add(&mddev->kobj, &disk_to_dev(disk)->kobj, "%s", "md=
");
>> 	mddev_unlock(mddev);
>> }
>>
>> Does this make the comment and reconfig_mutex critical section in
>> md_alloc() obsolete, as well as the commit message's first paragraph
>> claiming that ioctls such as ADD_NEW_DISK can run before kobject_add()
>> completes?
>>
>> [1] https://sashiko.dev/#/bug/linux-460ea5ed-96ea-49a0-8383-cfa84f28520b
>>
>> --=20
>> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112114958.2=
244-1-abd.masalkhi@gmail.com?part=3D1

--=20
Thanks,
Kuai
