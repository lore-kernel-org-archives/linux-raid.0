Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795266509;
	b=z0CE2HMP4BnAmJAlAf33wSaHuMUxsTnYOHCrrktm5p1+zAxUQMgUXbbyl02l0iQXoaMu
	 W5UG5RcISjiKNLTNVP5Jq/3n1Q1QpLZuL+/JvnyuaoihaGEvHKmaPH+3uEa4mFB57hluA
	 nmjavLwd634TC4P95omKNFPovj8o1YC4qTgkN3lUgbqqKRQ+RrHDLibIezYS+VCsj2Ao+
	 WF7Sp5FcDWpH3I3Z2cQPryev6vshu6eNxikrIPbkvh6P8u/oYEUaJrV8ZAzYryx4EgrXh
	 IdkNODmisCx7dGUrXOpMNfSpIxm2O7s9y9DzKss0oITkocwx1K6RE2fGyqTCNSTbT4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795266509;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 In-Reply-To:References:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=LHjG/iTsDXs6nDYHCXcunTi8MwN8lduDlNDVFE7Jg1Q=;
	b=hm4/78/dR/8l8YiG1Ym06iBjEvzQkIUkowNM6XKBGgXTpW4NHhWtc5uknvi7sO2VFlvs
	 Pd93ZwE6Vp+WK/7NmE2MSuk+qEXbNUn+VvZSHsmLGqYCmnVmeGOiMicvqmaXfgFu0aON6
	 ifQo02HXHsF8hYK/watSyTfq66OkAgFSjgJ9keSyAeAWqocGUcU6kkWvzrzV9zliUHM+g
	 BoPAFjoom0J/uUdRQHIN/ImjeGrbd2NO70WtmXJzN3aHt8kJxj+vR0foOk6LWXzmCNl3q
	 5jV7OTrCkZBB8Njt3eP2Mz0+YwMonFrev+vncfQ8DBM+OTlJ0z9l5d9+pGmG8YwMbtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CKVBC5Q1;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE6A606A32A
	for <linux-raid@vger.kernel.org>; Sat, 21 Nov 2026 13:08:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CFE6A606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CKVBC5Q1
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a210470b49so16194395e9.2
        for <linux-raid@vger.kernel.org>; Sat, 21 Nov 2026 05:08:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795266507; x=1795871307; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LHjG/iTsDXs6nDYHCXcunTi8MwN8lduDlNDVFE7Jg1Q=;
        b=CKVBC5Q1q7BcMuVLhAjA7CFGC8fCrcld5Qgxm2LqcDrf/NOo+0k5BeePKzMkY3zKRm
         wyxAs/5nu00yr01MusdSqj0C0gCEWoLaHt+1SmsHwJAAKKNYwDqfu4Wh8l89Y69iKdgV
         6uK56Xqa9HW1kxTppH0HPV3K/saBDecNV8Bsaa1enjKPuaf59+HEpqZG09VJAU0PiC0K
         BoGDqNzVyCX9tyQ590554aXzVtlTzAUnBLnzZGXNSMfepJG+uM0QF5fPXQRGOYY/+HYE
         nYeC23FFDe0IGDBMSnDBWwfrZGXMZwaedYCZLlLR+NhFEu0Ki2X+l3J/VgVIpVg77e9d
         1KjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795266507; x=1795871307;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LHjG/iTsDXs6nDYHCXcunTi8MwN8lduDlNDVFE7Jg1Q=;
        b=oIdxNhxmbd8WFPxr4bw3vp4t9W8y6vp+rtSRlkumdz9HVRLU6b6Lpr2yrzLIguaEq8
         toOjsf19T0S4nx/j2yZuCI1PGN+rSFcyt07HdLMbjMODIAZkletkr8Txnp/kj7ffgQ2E
         Dd12ETVs98ghyXT2kuESnSSUVjSeY+IhTjzrLyxYN7QWzxGfcakCVUBCkmJI3Gy/GYqF
         7nbt5oWYB9boxpVHZOnk2VP8T4osPtBaQC4w7GO7bbpfCFneSR/SnaKYURFMoJDhgyrz
         JjtYzYEEgv1LKnevg5MIZHUD1cZOdYEH9GLSPESvk23P6XuAd2pNui6d1pb0x2ZyRZ+U
         3mRA==
X-Gm-Message-State: APuU4Z/v+I8bx9iI8gw2j7ZosW0nmezmd1A0CY6F2oI3kqxoog1sBGSa
	tYcjggpsXPLE/SfTzGdjHLTiDHzhh21w8NDih+IEk/k2jQxUy21UbPEPKzfaUw==
X-Gm-Gg: AZFdTZdNNZGYspQfA7cxJwHSs8juJgxIIac8WUhednAxhnqA2mRUZb+gDuyyx7vvy8Z
	pjD6pkw2capYBaFKhmy0lMFpHGlCROrKOnokoxCxRulNRVQmdXf1KliDqnkKqTG5XZ+mrLeGb9/
	dAMMa2Vu3tPYGgXSY2cEkxB7UzT1pWQaAlV2exbIiHD2PZHkgHSb37gNFq6HAdFxKhimQQGKCk9
	0zDigIKYyDP9Smm3aPnc3u3h1hBsB0oHw0YAtLY1pJO3Sg9ilUEStNbmsWDgBXXs6pOQ+rq5S1j
	G6HnlUKMkWzeftDhmBFnzxluoOESFT/vNv2wp9RkgscCwkHHkHhRyaril81wEop3uq+LYDtSRvp
	Ly1w7ULO/vuaikew1yDu2XxvUUJXYsTUF3KnpCSCd7uh7s8b29oTkWcoMGENc2yS70/DNtdnsRt
	m96CV9B2+WvDIbzpSAZ61wpB7eYIJc31Qp0amqCU3kEod7YLD8vXK/Zncfm0Qzitt2tRSqNUvF9
	wKxe34xqj8tcA64aEw6x0hR64bI7Tflce/ExOMakP4Tip2mx2WTKcsQoH3kJSUoiBfGccpXZwac
	ix62PTJAoaueY1U4P4Zv+656Y4YuYbknvaSFLTSUdtaPlGTRuVnrr72EG110g1iqsujdB1Dt
X-Received: by 2002:a05:600c:5249:b0:4bb:665c:a078 with SMTP id 5b1f17b1804b1-4bb8893a89bmr134882075e9.28.1795266506857;
        Sat, 21 Nov 2026 05:08:26 -0800 (PST)
Received: from Abds-MacBook-Air.local ([2a02:3037:31c:5c36:c05b:18d5:9baf:f9f5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884c3063sm179882145e9.15.2026.11.21.05.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 05:08:26 -0800 (PST)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: yu kuai <yukuai@fygo.io>, sashiko-reviews@lists.linux.dev, yu kuai
 <yukuai@fygo.io>
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH] md: make mddev_get() fail until md_alloc() has finished
In-Reply-To: <e0d5c880-ea38-4f25-8c1a-3bca0a4a5dcc@fygo.io>
References: <20261112114958.2244-1-abd.masalkhi@gmail.com>
 <sashiko-outbox-211074@kernel.org> <m2tslm1988.fsf@gmail.com>
 <e0d5c880-ea38-4f25-8c1a-3bca0a4a5dcc@fygo.io>
Date: Sat, 21 Nov 2026 14:08:15 +0100
Message-ID: <m2tslal4cg.fsf@gmail.com>
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

On Fri, Nov 20, 2026 at 18:41 +0800, yu kuai wrote:
> Hi,
>
> =E5=9C=A8 2026/11/12 21:15, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
>> Hi Kuai,
>>
>> On Thu, Nov 12, 2026 at 12:13 +0000, sashiko-bot@kernel.org wrote:
>>> Thank you for your contribution! Sashiko AI review found 2 potential
>>> issues to consider:
>>> - [Medium] md: premature KOBJ_ADD uevent in add_disk() while mddev_get()
>>>    fails
>>> - [Low] md: stale reconfig_mutex lock and comment in md_alloc()
>>> It also noticed 1 related pre-existing issue this patch does not
>>> introduce:
>>> - [Medium] md: kernfs_node memory leak in mddev_unlock() [1]
>>> --
>>>
>>> commit 2ddaaecbff58458e8c38353164498300daf7d131
>>> Author: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>>>
>>> md: make mddev_get() fail until md_alloc() has finished
>>>
>>> This commit adds an mddev->sysfs_live flag set under all_mddevs_lock af=
ter
>>> kobject_add() succeeds in md_alloc(), and updates mddev_get() to fail u=
ntil
>>> that flag is set.
>>>
>>> Link: https://sashiko.dev/#/patchset/20261029202209.1422567-1-abd.masal=
khi@gmail.com?part=3D4
>>>
>>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>>> index 03e35386a8028..47118e9d1a656 100644
>>>> --- a/drivers/md/md.c
>>>> +++ b/drivers/md/md.c
>>>> @@ -641,7 +641,7 @@ static inline struct mddev *mddev_get(struct mddev=
 *mddev)
>>>>   {
>>>>   	lockdep_assert_held(&all_mddevs_lock);
>>>>=20=20=20
>>>> -	if (test_bit(MD_DELETED, &mddev->flags))
>>>> +	if (test_bit(MD_DELETED, &mddev->flags) || !mddev->sysfs_live)
>>>>   		return NULL;
>>>>   	atomic_inc(&mddev->active);
>>>>   	return mddev;
>>>> @@ -6432,10 +6432,16 @@ struct mddev *md_alloc(dev_t dev, char *name)
>>>>   		return ERR_PTR(error);
>>>>   	}
>>>>=20=20=20
>>>> -	kobject_uevent(&mddev->kobj, KOBJ_ADD);
>>>>   	mddev->sysfs_state =3D sysfs_get_dirent_safe(mddev->kobj.sd, "array=
_state");
>>>>   	mddev->sysfs_level =3D sysfs_get_dirent_safe(mddev->kobj.sd, "level=
");
>>> [Severity: Medium]
>>> This problem wasn't introduced by this patch, but when
>>> legacy_async_del_gendisk is disabled, does mddev_unlock() leak
>>> mddev->sysfs_state and mddev->sysfs_level [1]?
>>>
>>> md_kobj_release() only calls sysfs_put() on mddev->sysfs_state and
>>> mddev->sysfs_level when legacy_async_del_gendisk is true, and the
>>> !legacy_async_del_gendisk teardown path in mddev_unlock() deletes
>>> mddev->kobj and mddev->gendisk without releasing those kernfs_node
>>> references:
>>>
>>> drivers/md/md.c:md_kobj_release() {
>>> 	if (legacy_async_del_gendisk) {
>>> 		if (mddev->sysfs_state)
>>> 			sysfs_put(mddev->sysfs_state);
>>> 		if (mddev->sysfs_level)
>>> 			sysfs_put(mddev->sysfs_level);
>>> 		del_gendisk(mddev->gendisk);
>>> 	}
>>> 	put_disk(mddev->gendisk);
>>> }
>>>
>>>> +
>>>> +	spin_lock(&all_mddevs_lock);
>>>> +	mddev->sysfs_live =3D true;
>>>> +	spin_unlock(&all_mddevs_lock);
>>>> +
>>>> +	kobject_uevent(&mddev->kobj, KOBJ_ADD);
>>>>   	mutex_unlock(&disks_mutex);
>>>> +
>>>>   	return mddev;
>>>>=20=20=20
>>>>   out_put_disk:
>>> [Severity: Medium]
>>> Does making mddev_get() fail until mddev->sysfs_live is set cause a
>>> regression where udevd or concurrent openers fail with -ENODEV in md_op=
en()
>>> and -EBUSY on md/ sysfs attributes right after add_disk() announces the
>>> disk?
>>>
>>> kobject_uevent(&mddev->kobj, KOBJ_ADD) is dropped by dev_uevent_filter()
>>> because mddev->kobj has ktype &md_ktype rather than &device_ktype.  The
>>> KOBJ_ADD uevent that actually reaches user space is sent earlier inside
>>> add_disk() -> add_disk_final() -> disk_uevent(disk, KOBJ_ADD), right af=
ter
>>> bdev_add() publishes the block device inode while mddev->sysfs_live is
>>> still false:
>>>
>>> CPU0                              CPU1 (udevd / opener)
>>> md_alloc()
>>>    add_disk(disk)
>>>      add_disk_final(disk)
>>>        bdev_add(...)
>>>        disk_uevent(disk, KOBJ_ADD)
>>>                                    blkdev_get_no_open()
>>>                                    md_open()
>>>                                      mddev_find()
>>>                                        mddev_get() -> NULL  <-- -ENODEV
>>>    kobject_add(&mddev->kobj, ...)
>>>    mddev->sysfs_live =3D true
>>>
>> I missed this case. Do you have a suggestion for a better fix, or should
>> I just drop this patch?
>
> Please drop this patch, let open disk fail is not a good idea.
>
> I think you can just set a new flag to mddev if kobject_add failed, and c=
heck
> the flag during opening, right after reconfig_mutex is grabbed.
>

Thank you for the feedback. I will drop this patch and fix it
accordingly.

>>
>>> [Severity: Low]
>>> Since mddev_get() now returns NULL until mddev->sysfs_live is set after
>>> mddev_unlock(mddev), md_open() can no longer succeed while reconfig_mut=
ex
>>> is held across add_disk() and kobject_add() from commit d1472ca2ca5d ("=
md:
>>> don't hand out the array before md_alloc() has added mddev->kobj").
>>>
>>> drivers/md/md.c:md_alloc() {
>>> 	/*
>>> 	 * add_disk() makes the array openable before mddev->kobj exists.
>>> 	 * Hold reconfig_mutex until kobject_add() is done so that ioctls
>>> 	 * issued in between wait instead of using an uninitialised kobj.
>>> 	 */
>>> 	mddev_lock_nointr(mddev);
>>> 	error =3D add_disk(disk);
>>>      ...
>>> 	error =3D kobject_add(&mddev->kobj, &disk_to_dev(disk)->kobj, "%s", "m=
d");
>>> 	mddev_unlock(mddev);
>>> }
>>>
>>> Does this make the comment and reconfig_mutex critical section in
>>> md_alloc() obsolete, as well as the commit message's first paragraph
>>> claiming that ioctls such as ADD_NEW_DISK can run before kobject_add()
>>> completes?
>>>
>>> [1] https://sashiko.dev/#/bug/linux-460ea5ed-96ea-49a0-8383-cfa84f28520b
>>>
>>> --=20
>>> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112114958.=
2244-1-abd.masalkhi@gmail.com?part=3D1
>
> --=20
> Thanks,
> Kuai

--=20
Best Regards,
Abd-Alrhman
