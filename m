Received: from sg-1-39.ptr.blmpb.com (sg-1-39.ptr.blmpb.com [118.26.132.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062532C235E
	for <linux-raid@vger.kernel.org>; Thu,  5 Mar 2026 17:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772733467; cv=none; b=XXvTMFlNKMSuJ50R70jnzSPX6HkwM+iYZ1kC0s9Repj+yrhdC8hkoULTt52RkEcvGjCEj5adf7ZNEeOJMXEAvxY6LNMw3oIEItPOE6ZQLoXOWtB+SXDNiqrUxJctKotobmsmEqcfl6g/IzhFiv+Ba+ylvjRrH0OH0zS3GvIyjlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772733467; c=relaxed/simple;
	bh=7YVpPHqPBcPJInK3/GuV9IkSvD/+o6wf49xrTsTqoGI=;
	h=Date:In-Reply-To:Content-Type:To:Message-Id:Cc:From:Subject:
	 Mime-Version:References; b=faMJ80EWg/qZdPbiteVIOI74kulWEJ3CTysOCxV54bdP6fhbElO5AJGd+YPUh+7PUqwZocc1x+nxxNs5oIGDzRtcaa+QD4D/HiwHdCSBedW9yNBaA6MSRTPsAngHBgRk0qi1tXyNRT1lYnDZhBYh6NFxGLy0Zvq6mrTzfQu/dws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=AcU4ulz2; arc=none smtp.client-ip=118.26.132.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="AcU4ulz2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1772733452;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=7YVpPHqPBcPJInK3/GuV9IkSvD/+o6wf49xrTsTqoGI=;
 b=AcU4ulz2kwua48Nw1v9tD9gKJULrpplVgp9fWvuSPg5eqeisS64W6maveJWM/z/ExkhSGU
 c5oS4mfTrMJK9OJt6fkbLG52ywhxMesluOI9+RADFUASvde13pG5MWVF9df/1zPKpMNV6d
 9SaIjJbOj3WobWKHfJyNimj1tY7eUP+KplZacrPvak3jA3NvdUls9HqTkIxpg2CRamEC5E
 7YoDqC1WjxD+lGv83a0M9V+I0SDjJlKgdHzLXiB3TIduohgrwK7TVeRyqZk/+zz0OBwHuN
 rtXgShtMip5ZdGC6sIZh321bVdJlp92V/p4PbXZJfj/chEIfT463DMCgTlte7w==
Reply-To: yukuai@fnnas.com
Date: Fri, 6 Mar 2026 01:57:29 +0800
X-Original-From: Yu Kuai <yukuai@fnnas.com>
In-Reply-To: <342g70bt.fsf@damenly.org>
Content-Type: text/plain; charset=UTF-8
To: "Su Yue" <l@damenly.org>, <yukuai@fnnas.com>
Message-Id: <04a3d0bf-838c-43b5-bb69-410829464042@fnnas.com>
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+269a9c40b+ef368a+vger.kernel.org+yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.182]) by smtp.feishu.cn with ESMTPS; Fri, 06 Mar 2026 01:57:30 +0800
Content-Language: en-US
Cc: "Su Yue" <glass.su@suse.com>, <linux-raid@vger.kernel.org>, 
	<song@kernel.org>, <xni@redhat.com>, <linan122@huawei.com>, 
	<heming.zhao@suse.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH 1/3] md: restore bitmap/location to fix wrong bitmap offset while growing
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260303033731.83885-1-glass.su@suse.com> <20260303033731.83885-2-glass.su@suse.com> <20fcd6f0-b27d-49aa-8064-79f58f109d5d@fnnas.com> <342g70bt.fsf@damenly.org>

Hi,

=E5=9C=A8 2026/3/4 11:14, Su Yue =E5=86=99=E9=81=93:
> On Wed 04 Mar 2026 at 10:30, "Yu Kuai" <yukuai@fnnas.com> wrote:
>
>> Hi,
>>
>> =E5=9C=A8 2026/3/3 11:37, Su Yue =E5=86=99=E9=81=93:
>>> Before commit fb8cc3b0d9db ("md/md-bitmap: delay registration of=20
>>> bitmap_ops until creating bitmap")
>>> if CONFIG_MD_BITMAP is enabled, both bitmap none, internal and=20
>>> clustered have
>>> the sysfs file bitmap/location.
>>>
>>> After the commit, if bitmap is none, bitmap/location doesn't exist=20
>>> anymore.
>>> It breaks 'grow' behavior of a md array of madam with=20
>>> MD_FEATURE_BITMAP_OFFSET.
>>> Take level=3Dmirror and metadata=3D1.2 as an example:
>>>
>>> $ mdadm=C2=A0 --create=C2=A0 /dev/md0 -f --bitmap=3Dnone --raid-devices=
=3D2=20
>>> --level=3Dmirror \
>>> =C2=A0=C2=A0 --metadata=3D1.2 /dev/vdd /dev/vde
>>> $ mdadm --grow /dev/md0 --bitmap=3Dinternal
>>> $ cat /sys/block/md0/md/bitmap/location
>>> Before:+8
>>> After: +2
>>>
>>> While growing bitmap from none to internal, clustered and llbitmap,
>>> mdadm/Grow.c:Grow_addbitmap() tries to detect bitmap/location first.
>>> 1)If bitmap/location exists, it sets bitmap/location after=20
>>> getinfo_super().
>>> 2)If bitmap/location doesn't exist, mdadm just calls=20
>>> md_set_array_info() then
>>> mddev->bitmap_info.default_offset will be used.
>>> Situation can be worse if growing none to clustered, bitmap offset=20
>>> of the node
>>> calling `madm --grow` will be changed but the other node are reading=20
>>> bitmap sb from
>>> the old location.
>>
>> Now that we have a new sysfs attribute bitmap_type, can we fix this by:
>> - in the kernel, allow writing to this file in this case;
>> - in mdadm and the grow case above, write to this file first, and change
>> bitmap_type from none to bitmap(For llbitmap, there is still more=20
>> work to do).
>>
> Yes. It's indeed feasible. But how about old versions mdadm? We can't=20
> require
> users' madadm + kernel combinations for old feature. Kernel part=20
> should keep
> compatibility with userspace. sysfs changes and broken haviros are not=20
> ideal
> especially userspace depends on it unless there's a strong reason.
> That's why linux/Documentation/ABI exists.

Okay, I can accept keep this old behavior.

However, instead of introducing a new common_group with the same name "bitm=
ap",
I'll prefer to introducing a separate bitmap_ops for none bitmap as well, a=
nd
you can define the attrs that are necessary.

For llbitmap, I think it's fine, we don't need this old sysfs attr anyway. =
I'll
support to convert from none/bitmap to llbitmap by writing the new bitmap_t=
ype
file.
 =20

>
> --=20
> Su
>
>>>
>>> Here restore sysfs file bitmap/location for ID_BITMAP_NONE and=20
>>> ID_BITMAP.
>>> And it d adds the entry for llbitmap too.
>>>
>>> New attribute_group md_bitmap_common_group is introduced and created in
>>> md_alloc() as before commit fb8cc3b0d9db.
>>> Add New operations register_group and unregister_group to struct=20
>>> bitmap_operations.
>>>
>>> Fixes: fb8cc3b0d9db ("md/md-bitmap: delay registration of bitmap_ops=20
>>> until creating bitmap")
>>> Signed-off-by: Su Yue <glass.su@suse.com>
>>> ---
>>> =C2=A0 drivers/md/md-bitmap.c=C2=A0=C2=A0 | 32 ++++++++++++++++++++++++=
+++++++-
>>> =C2=A0 drivers/md/md-bitmap.h=C2=A0=C2=A0 |=C2=A0 5 +++++
>>> =C2=A0 drivers/md/md-llbitmap.c | 13 +++++++++++++
>>> =C2=A0 drivers/md/md.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 | 16 ++++++++++++----
>>> =C2=A0 4 files changed, 61 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>>> index 83378c033c72..8ff1dc94ed78 100644
>>> --- a/drivers/md/md-bitmap.c
>>> +++ b/drivers/md/md-bitmap.c
>>> @@ -2956,7 +2956,6 @@ __ATTR(max_backlog_used, S_IRUGO | S_IWUSR,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 behind_writes_used_sho=
w, behind_writes_used_reset);
>>>
>>> =C2=A0 static struct attribute *md_bitmap_attrs[] =3D {
>>> -=C2=A0=C2=A0=C2=A0 &bitmap_location.attr,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &bitmap_space.attr,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &bitmap_timeout.attr,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &bitmap_backlog.attr,
>>> @@ -2967,11 +2966,40 @@ static struct attribute *md_bitmap_attrs[] =3D =
{
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 NULL
>>> =C2=A0 };
>>>
>>> +static struct attribute *md_bitmap_common_attrs[] =3D {
>>> +=C2=A0=C2=A0=C2=A0 &bitmap_location.attr,
>>> +=C2=A0=C2=A0=C2=A0 NULL
>>> +};
>>> +
>>> =C2=A0 static struct attribute_group md_bitmap_group =3D {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .name =3D "bitmap",
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .attrs =3D md_bitmap_attrs,
>>> =C2=A0 };
>>>
>>> +static struct attribute_group md_bitmap_common_group =3D {
>>> +=C2=A0=C2=A0=C2=A0 .name =3D "bitmap",
>>> +=C2=A0=C2=A0=C2=A0 .attrs =3D md_bitmap_common_attrs,
>>> +};
>>> +
>>> +int md_sysfs_create_common_group(struct mddev *mddev)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 return sysfs_create_group(&mddev->kobj, &md_bitmap_=
common_group);
>>> +}
>>> +
>>> +static int bitmap_register_group(struct mddev *mddev)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 /*
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * md_bitmap_group and md_bitmap_common_group =
are using same name
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * 'bitmap'.
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> +=C2=A0=C2=A0=C2=A0 return sysfs_merge_group(&mddev->kobj, &md_bitmap_g=
roup);
>>> +}
>>> +
>>> +static void bitmap_unregister_group(struct mddev *mddev)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 sysfs_unmerge_group(&mddev->kobj, &md_bitmap_group)=
;
>>> +}
>>> +
>>> =C2=A0 static struct bitmap_operations bitmap_ops =3D {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .head =3D {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .type=C2=A0=C2=
=A0=C2=A0 =3D MD_BITMAP,
>>> @@ -3013,6 +3041,8 @@ static struct bitmap_operations bitmap_ops =3D {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .set_pages=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 =3D bitmap_set_pages,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .free=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D md_bitmap_free,
>>>
>>> +=C2=A0=C2=A0=C2=A0 .register_group=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 =3D bitmap_register_group,
>>> +=C2=A0=C2=A0=C2=A0 .unregister_group=C2=A0=C2=A0=C2=A0 =3D bitmap_unre=
gister_group,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .group=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D &md_bitmap_group,
>>> =C2=A0 };
>>>
>>> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
>>> index b42a28fa83a0..371791e9011d 100644
>>> --- a/drivers/md/md-bitmap.h
>>> +++ b/drivers/md/md-bitmap.h
>>> @@ -125,6 +125,9 @@ struct bitmap_operations {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 void (*set_pages)(void *data, unsigned l=
ong pages);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 void (*free)(void *data);
>>>
>>> +=C2=A0=C2=A0=C2=A0 int (*register_group)(struct mddev *mddev);
>>> +=C2=A0=C2=A0=C2=A0 void (*unregister_group)(struct mddev *mddev);
>>> +
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct attribute_group *group;
>>> =C2=A0 };
>>>
>>> @@ -169,6 +172,8 @@ static inline void md_bitmap_end_sync(struct=20
>>> mddev *mddev, sector_t offset,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->bitmap_ops->end_sync(mddev, offse=
t, blocks);
>>> =C2=A0 }
>>>
>>> +int md_sysfs_create_common_group(struct mddev *mddev);
>>> +
>>> =C2=A0 #ifdef CONFIG_MD_BITMAP
>>> =C2=A0 int md_bitmap_init(void);
>>> =C2=A0 void md_bitmap_exit(void);
>>> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
>>> index bf398d7476b3..24ff5f7f8751 100644
>>> --- a/drivers/md/md-llbitmap.c
>>> +++ b/drivers/md/md-llbitmap.c
>>> @@ -1561,6 +1561,16 @@ static struct attribute_group=20
>>> md_llbitmap_group =3D {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .attrs =3D md_llbitmap_attrs,
>>> =C2=A0 };
>>>
>>> +static int llbitmap_register_group(struct mddev *mddev)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 return sysfs_create_group(&mddev->kobj, &md_llbitma=
p_group);
>>> +}
>>> +
>>> +static void llbitmap_unregister_group(struct mddev *mddev)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 sysfs_remove_group(&mddev->kobj, &md_llbitmap_group=
);
>>> +}
>>> +
>>> =C2=A0 static struct bitmap_operations llbitmap_ops =3D {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .head =3D {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .type=C2=A0=C2=
=A0=C2=A0 =3D MD_BITMAP,
>>> @@ -1597,6 +1607,9 @@ static struct bitmap_operations llbitmap_ops =3D =
{
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .dirty_bits=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 =3D llbitmap_dirty_bits,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .write_all=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 =3D llbitmap_write_all,
>>>
>>> +=C2=A0=C2=A0=C2=A0 .register_group=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 =3D llbitmap_register_group,
>>> +=C2=A0=C2=A0=C2=A0 .unregister_group=C2=A0=C2=A0=C2=A0 =3D llbitmap_un=
register_group,
>>> +
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .group=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D &md_llbitmap_group,
>>> =C2=A0 };
>>>
>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>> index 3ce6f9e9d38e..ab969e950ea8 100644
>>> --- a/drivers/md/md.c
>>> +++ b/drivers/md/md.c
>>> @@ -703,8 +703,8 @@ static bool mddev_set_bitmap_ops(struct mddev=20
>>> *mddev)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->bitmap_ops =3D (void *)head;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xa_unlock(&md_submodule);
>>>
>>> -=C2=A0=C2=A0=C2=A0 if (!mddev_is_dm(mddev) && mddev->bitmap_ops->group=
) {
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (sysfs_create_group(&mdd=
ev->kobj,=20
>>> mddev->bitmap_ops->group))
>>> +=C2=A0=C2=A0=C2=A0 if (!mddev_is_dm(mddev) && mddev->bitmap_ops->regis=
ter_group) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (mddev->bitmap_ops->regi=
ster_group(mddev))
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 pr_warn("md: cannot register extra bitmap attributes=20
>>> for %s\n",
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mdname(mddev));
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
>>> @@ -724,8 +724,8 @@ static bool mddev_set_bitmap_ops(struct mddev=20
>>> *mddev)
>>> =C2=A0 static void mddev_clear_bitmap_ops(struct mddev *mddev)
>>> =C2=A0 {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!mddev_is_dm(mddev) && mddev->bitmap=
_ops &&
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->bitmap_ops->group)
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sysfs_remove_group(&mddev->=
kobj, mddev->bitmap_ops->group);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->bitmap_ops->unregist=
er_group)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->bitmap_ops->unregist=
er_group(mddev);
>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->bitmap_ops =3D NULL;
>>> =C2=A0 }
>>> @@ -6369,6 +6369,14 @@ struct mddev *md_alloc(dev_t dev, char *name)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ERR_PTR(e=
rror);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>
>>> +=C2=A0=C2=A0=C2=A0 /*
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * md_sysfs_remove_common_group is not needed =
because=20
>>> mddev_delayed_delete
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * calls kobject_put(&mddev->kobj) if mddev is=
 to be deleted.
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> +=C2=A0=C2=A0=C2=A0 if (md_sysfs_create_common_group(mddev))
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pr_warn("md: cannot registe=
r common bitmap attributes for=20
>>> %s\n",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mdn=
ame(mddev));
>>> +
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kobject_uevent(&mddev->kobj, KOBJ_ADD);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->sysfs_state =3D sysfs_get_dirent_=
safe(mddev->kobj.sd, =C2=A0=20
>>> "array_state");
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->sysfs_level =3D sysfs_get_dirent_=
safe(mddev->kobj.sd, =C2=A0=20
>>> "level");

--=20
Thansk,
Kuai
