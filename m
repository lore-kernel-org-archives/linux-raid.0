Received: from mail-108-mta174.mxroute.com (mail-108-mta174.mxroute.com [136.175.108.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF183537CB
	for <linux-raid@vger.kernel.org>; Wed,  4 Mar 2026 03:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772594399; cv=none; b=t2/PP+bQhtKBNBjsAd0ckmDi51Yf+LRMyC4t6a73N3iuACQsO1rO9QsrFi50VGcbW0CuLzNhcMRDptQs2qZd/frjd0V24GhgZcl1fm+hRCWsAc5PWKp5vTuzi0kscdJzoHUxanzXz3HJWh1hnasNyDX5+7i8d/P05Y23gMHnhjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772594399; c=relaxed/simple;
	bh=GCOfugRtGF4LnTPY2f0gJqqsNRfpt4lnJZTPB+wfv7A=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=VQpGo2IT1n0TjdpEc+Isatov+ab6aObFgFdwumBv8V+6aZ2PvSD2i8Kb6HzbaDOwneKrsLWA9welNmsQAUU/EF/PwJURqZa56BNmpgKfRPSPDJNNvkiZJOXLZVdxKDezqpE3sEH3K9a0JVPtKpG8xlDjKa84sHTgKyK4Q4KMUUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=B8moo526; arc=none smtp.client-ip=136.175.108.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="B8moo526"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta174.mxroute.com (ZoneMTA) with ESMTPSA id 19cb6d746f20007228.007
 for <linux-raid@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Wed, 04 Mar 2026 03:14:47 +0000
X-Zone-Loop: b648a51a098c6e9a7c7cbb1b5b6a081dc89f58e0e180
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:
	References:In-Reply-To:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mYcwvQ6bGM8zSU7P7Gqui2/185jPOxNmHS9/l/1UoX8=; b=B8moo526Z3C9vJyqB4Ag9SpAmh
	1ivVC+lwaSUiuRrVk4vraCtkESVD2EZiNmwWO44pfG+ne38J/hTcIAXMKoBMcqx6vaXZM46qUE3oZ
	ls1RQ1NhmT4OtBLmHJANmopbhlWFjju7suwmCceh5tlrFPmHTwiFEHCFhN7OzZFJ2F3Q9gAzjpanK
	g/qgtI4Gm6cNhnL1b4CsYG4k5imn/yKkrQ36FVJuofGPzYa1xbjwJrIuvWaxkxgq1DvS00nTqwM2m
	WSc8UvmuRwF1i1m03RU/i+04kXxUjJ6A3mN2teR3ckIQiRfIAe6rSYaOjq/GhfkZCu4/y9MOezMvG
	gCnr2xAg==;
From: Su Yue <l@damenly.org>
To: "Yu Kuai" <yukuai@fnnas.com>
Cc: "Su Yue" <glass.su@suse.com>,  <linux-raid@vger.kernel.org>,
  <song@kernel.org>,  <xni@redhat.com>,  <linan122@huawei.com>,
  <heming.zhao@suse.com>
Subject: Re: [PATCH 1/3] md: restore bitmap/location to fix wrong bitmap
 offset while growing
In-Reply-To: <20fcd6f0-b27d-49aa-8064-79f58f109d5d@fnnas.com> (Yu Kuai's
	message of "Wed, 4 Mar 2026 10:30:20 +0800")
References: <20260303033731.83885-1-glass.su@suse.com>
	<20260303033731.83885-2-glass.su@suse.com>
	<20fcd6f0-b27d-49aa-8064-79f58f109d5d@fnnas.com>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Wed, 04 Mar 2026 11:14:30 +0800
Message-ID: <342g70bt.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Authenticated-Id: l@damenly.org

On Wed 04 Mar 2026 at 10:30, "Yu Kuai" <yukuai@fnnas.com> wrote:

> Hi,
>
> =E5=9C=A8 2026/3/3 11:37, Su Yue =E5=86=99=E9=81=93:
>> Before commit fb8cc3b0d9db ("md/md-bitmap: delay registration=20
>> of bitmap_ops until creating bitmap")
>> if CONFIG_MD_BITMAP is enabled, both bitmap none, internal and=20
>> clustered have
>> the sysfs file bitmap/location.
>>
>> After the commit, if bitmap is none, bitmap/location doesn't=20
>> exist anymore.
>> It breaks 'grow' behavior of a md array of madam with=20
>> MD_FEATURE_BITMAP_OFFSET.
>> Take level=3Dmirror and metadata=3D1.2 as an example:
>>
>> $ mdadm  --create  /dev/md0 -f --bitmap=3Dnone --raid-devices=3D2=20
>> --level=3Dmirror \
>>    --metadata=3D1.2 /dev/vdd /dev/vde
>> $ mdadm --grow /dev/md0 --bitmap=3Dinternal
>> $ cat /sys/block/md0/md/bitmap/location
>> Before:+8
>> After: +2
>>
>> While growing bitmap from none to internal, clustered and=20
>> llbitmap,
>> mdadm/Grow.c:Grow_addbitmap() tries to detect bitmap/location=20
>> first.
>> 1)If bitmap/location exists, it sets bitmap/location after=20
>> getinfo_super().
>> 2)If bitmap/location doesn't exist, mdadm just calls=20
>> md_set_array_info() then
>> mddev->bitmap_info.default_offset will be used.
>> Situation can be worse if growing none to clustered, bitmap=20
>> offset of the node
>> calling `madm --grow` will be changed but the other node are=20
>> reading bitmap sb from
>> the old location.
>
> Now that we have a new sysfs attribute bitmap_type, can we fix=20
> this by:
> - in the kernel, allow writing to this file in this case;
> - in mdadm and the grow case above, write to this file first,=20
> and change
> bitmap_type from none to bitmap(For llbitmap, there is still=20
> more work to do).
>
Yes. It's indeed feasible. But how about old versions mdadm? We=20
can't require
users' madadm + kernel combinations for old feature. Kernel part=20
should keep
compatibility with userspace. sysfs changes and broken haviros are=20
not ideal
especially userspace depends on it unless there's a strong reason.
That's why linux/Documentation/ABI exists.

--
Su

>>
>> Here restore sysfs file bitmap/location for ID_BITMAP_NONE and=20
>> ID_BITMAP.
>> And it d adds the entry for llbitmap too.
>>
>> New attribute_group md_bitmap_common_group is introduced and=20
>> created in
>> md_alloc() as before commit fb8cc3b0d9db.
>> Add New operations register_group and unregister_group to=20
>> struct bitmap_operations.
>>
>> Fixes: fb8cc3b0d9db ("md/md-bitmap: delay registration of=20
>> bitmap_ops until creating bitmap")
>> Signed-off-by: Su Yue <glass.su@suse.com>
>> ---
>>   drivers/md/md-bitmap.c   | 32=20
>>   +++++++++++++++++++++++++++++++-
>>   drivers/md/md-bitmap.h   |  5 +++++
>>   drivers/md/md-llbitmap.c | 13 +++++++++++++
>>   drivers/md/md.c          | 16 ++++++++++++----
>>   4 files changed, 61 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>> index 83378c033c72..8ff1dc94ed78 100644
>> --- a/drivers/md/md-bitmap.c
>> +++ b/drivers/md/md-bitmap.c
>> @@ -2956,7 +2956,6 @@ __ATTR(max_backlog_used, S_IRUGO |=20
>> S_IWUSR,
>>          behind_writes_used_show, behind_writes_used_reset);
>>
>>   static struct attribute *md_bitmap_attrs[] =3D {
>> -	&bitmap_location.attr,
>>   	&bitmap_space.attr,
>>   	&bitmap_timeout.attr,
>>   	&bitmap_backlog.attr,
>> @@ -2967,11 +2966,40 @@ static struct attribute=20
>> *md_bitmap_attrs[] =3D {
>>   	NULL
>>   };
>>
>> +static struct attribute *md_bitmap_common_attrs[] =3D {
>> +	&bitmap_location.attr,
>> +	NULL
>> +};
>> +
>>   static struct attribute_group md_bitmap_group =3D {
>>   	.name =3D "bitmap",
>>   	.attrs =3D md_bitmap_attrs,
>>   };
>>
>> +static struct attribute_group md_bitmap_common_group =3D {
>> +	.name =3D "bitmap",
>> +	.attrs =3D md_bitmap_common_attrs,
>> +};
>> +
>> +int md_sysfs_create_common_group(struct mddev *mddev)
>> +{
>> +	return sysfs_create_group(&mddev->kobj,=20
>> &md_bitmap_common_group);
>> +}
>> +
>> +static int bitmap_register_group(struct mddev *mddev)
>> +{
>> +	/*
>> +	 * md_bitmap_group and md_bitmap_common_group are using=20
>> same name
>> +	 * 'bitmap'.
>> +	 */
>> +	return sysfs_merge_group(&mddev->kobj, &md_bitmap_group);
>> +}
>> +
>> +static void bitmap_unregister_group(struct mddev *mddev)
>> +{
>> +	sysfs_unmerge_group(&mddev->kobj, &md_bitmap_group);
>> +}
>> +
>>   static struct bitmap_operations bitmap_ops =3D {
>>   	.head =3D {
>>   		.type	=3D MD_BITMAP,
>> @@ -3013,6 +3041,8 @@ static struct bitmap_operations=20
>> bitmap_ops =3D {
>>   	.set_pages		=3D bitmap_set_pages,
>>   	.free			=3D md_bitmap_free,
>>
>> +	.register_group		=3D bitmap_register_group,
>> +	.unregister_group	=3D bitmap_unregister_group,
>>   	.group			=3D &md_bitmap_group,
>>   };
>>
>> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
>> index b42a28fa83a0..371791e9011d 100644
>> --- a/drivers/md/md-bitmap.h
>> +++ b/drivers/md/md-bitmap.h
>> @@ -125,6 +125,9 @@ struct bitmap_operations {
>>   	void (*set_pages)(void *data, unsigned long pages);
>>   	void (*free)(void *data);
>>
>> +	int (*register_group)(struct mddev *mddev);
>> +	void (*unregister_group)(struct mddev *mddev);
>> +
>>   	struct attribute_group *group;
>>   };
>>
>> @@ -169,6 +172,8 @@ static inline void=20
>> md_bitmap_end_sync(struct mddev *mddev, sector_t offset,
>>   	mddev->bitmap_ops->end_sync(mddev, offset, blocks);
>>   }
>>
>> +int md_sysfs_create_common_group(struct mddev *mddev);
>> +
>>   #ifdef CONFIG_MD_BITMAP
>>   int md_bitmap_init(void);
>>   void md_bitmap_exit(void);
>> diff --git a/drivers/md/md-llbitmap.c=20
>> b/drivers/md/md-llbitmap.c
>> index bf398d7476b3..24ff5f7f8751 100644
>> --- a/drivers/md/md-llbitmap.c
>> +++ b/drivers/md/md-llbitmap.c
>> @@ -1561,6 +1561,16 @@ static struct attribute_group=20
>> md_llbitmap_group =3D {
>>   	.attrs =3D md_llbitmap_attrs,
>>   };
>>
>> +static int llbitmap_register_group(struct mddev *mddev)
>> +{
>> +	return sysfs_create_group(&mddev->kobj,=20
>> &md_llbitmap_group);
>> +}
>> +
>> +static void llbitmap_unregister_group(struct mddev *mddev)
>> +{
>> +	sysfs_remove_group(&mddev->kobj, &md_llbitmap_group);
>> +}
>> +
>>   static struct bitmap_operations llbitmap_ops =3D {
>>   	.head =3D {
>>   		.type	=3D MD_BITMAP,
>> @@ -1597,6 +1607,9 @@ static struct bitmap_operations=20
>> llbitmap_ops =3D {
>>   	.dirty_bits		=3D llbitmap_dirty_bits,
>>   	.write_all		=3D llbitmap_write_all,
>>
>> +	.register_group		=3D llbitmap_register_group,
>> +	.unregister_group	=3D llbitmap_unregister_group,
>> +
>>   	.group			=3D &md_llbitmap_group,
>>   };
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 3ce6f9e9d38e..ab969e950ea8 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -703,8 +703,8 @@ static bool mddev_set_bitmap_ops(struct=20
>> mddev *mddev)
>>   	mddev->bitmap_ops =3D (void *)head;
>>   	xa_unlock(&md_submodule);
>>
>> -	if (!mddev_is_dm(mddev) && mddev->bitmap_ops->group) {
>> -		if (sysfs_create_group(&mddev->kobj,=20
>> mddev->bitmap_ops->group))
>> +	if (!mddev_is_dm(mddev) &&=20
>> mddev->bitmap_ops->register_group) {
>> +		if (mddev->bitmap_ops->register_group(mddev))
>>   			pr_warn("md: cannot register extra bitmap=20
>>   attributes for %s\n",
>>   				mdname(mddev));
>>   		else
>> @@ -724,8 +724,8 @@ static bool mddev_set_bitmap_ops(struct=20
>> mddev *mddev)
>>   static void mddev_clear_bitmap_ops(struct mddev *mddev)
>>   {
>>   	if (!mddev_is_dm(mddev) && mddev->bitmap_ops &&
>> -	    mddev->bitmap_ops->group)
>> -		sysfs_remove_group(&mddev->kobj,=20
>> mddev->bitmap_ops->group);
>> +	    mddev->bitmap_ops->unregister_group)
>> +		mddev->bitmap_ops->unregister_group(mddev);
>>
>>   	mddev->bitmap_ops =3D NULL;
>>   }
>> @@ -6369,6 +6369,14 @@ struct mddev *md_alloc(dev_t dev, char=20
>> *name)
>>   		return ERR_PTR(error);
>>   	}
>>
>> +	/*
>> +	 * md_sysfs_remove_common_group is not needed because=20
>> mddev_delayed_delete
>> +	 * calls kobject_put(&mddev->kobj) if mddev is to be=20
>> deleted.
>> +	 */
>> +	if (md_sysfs_create_common_group(mddev))
>> +		pr_warn("md: cannot register common bitmap attributes=20
>> for %s\n",
>> +			mdname(mddev));
>> +
>>   	kobject_uevent(&mddev->kobj, KOBJ_ADD);
>>   	mddev->sysfs_state =3D sysfs_get_dirent_safe(mddev->kobj.sd,=20
>>   "array_state");
>>   	mddev->sysfs_level =3D sysfs_get_dirent_safe(mddev->kobj.sd,=20
>>   "level");
