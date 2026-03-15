Received: from va-2-37.ptr.blmpb.com (va-2-37.ptr.blmpb.com [209.127.231.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EFA2853E0
	for <linux-raid@vger.kernel.org>; Sun, 15 Mar 2026 18:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773598370; cv=none; b=tMyI1K6Y5oY6r29yMjDVAwJigUr1KYtJYZW7twQLfYRAH9B7YelQ4YJ86OBKo5BA64iQ2unu7W8RU7VJ94hNWCi1pmiVyeBGb1dTW9TXbcNRAjiZqR7z1JZLBptzUhuvqohUaUh+3rIyTmuif+Ws1hBSIC9y6CzVMs/ExjQtfh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773598370; c=relaxed/simple;
	bh=oiFZwSSM1zrPl3p9sIT3J6m/kolqI25Wz/8g6UQz/jA=;
	h=Content-Type:References:Message-Id:Mime-Version:To:Date:
	 In-Reply-To:Cc:From:Subject; b=kOdoxbsU9Y3j5TeTRdYFpLyRySluZdhUphwq1Tn4JMJUgshzbsIYo6f/4A+XwSnbtalGTdHuncPVQqmBxjkKJ7cKIgVFSnuI+2pbxpm3p1X+xlop6KItnA7ZxotxmvlnhWcsLdY6Bhr0yBjX10NKI5WFSC0UNNgzGkz2pukAKaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=KeLCFttZ; arc=none smtp.client-ip=209.127.231.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="KeLCFttZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1773598361;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=clmlX/Dg2fYOLR7jt7LoWN4LD7L4EPtsZC8rpF/dldU=;
 b=KeLCFttZwUclIXEFt1zHeWiaKmhzM7V3ywkf/xVhiAFKDIfJuDB0R6LC5Xnrng+jRU3tbP
 tcKoTnnwjDe1uCuKemvInaZM1XfAZxjisJXTBAHI942h6zgRH+GJiQEGvAj2A3k0Eii6Hk
 iOdXa7cpgqxihEMqMy+CK0blpN/xIW3s16ylPvXIMoNr41Z6ao2jmm4omdOumf7MzNv6aX
 WcJloKA763x+AFHkECO4XcekQGLyz+mjeV8OShp1DhDCF1xt3YEiGEkVlgUXwvPPNbJ2tG
 ELdgSWo8hPtAAdA2AFDlAxB8YsA9l00QGnGJXV8OcVhYWkquJ7JqxEQgn75UIA==
Content-Type: text/plain; charset=UTF-8
References: <20260303033731.83885-1-glass.su@suse.com> <20260303033731.83885-2-glass.su@suse.com> <20fcd6f0-b27d-49aa-8064-79f58f109d5d@fnnas.com> <342g70bt.fsf@damenly.org> <04a3d0bf-838c-43b5-bb69-410829464042@fnnas.com> <94F22BD7-A521-496B-AAAE-50DD825A4353@suse.com>
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+269b6f698+bda0fb+vger.kernel.org+yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com
Message-Id: <5c6f9660-08eb-43f1-8d58-8026d95fde30@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Language: en-US
To: "Glass Su" <glass.su@suse.com>, <yukuai@fnnas.com>
Date: Mon, 16 Mar 2026 02:12:37 +0800
In-Reply-To: <94F22BD7-A521-496B-AAAE-50DD825A4353@suse.com>
Received: from [192.168.1.104] ([39.182.0.175]) by smtp.feishu.cn with ESMTPS; Mon, 16 Mar 2026 02:12:39 +0800
Content-Transfer-Encoding: quoted-printable
Cc: "Su Yue" <l@damenly.org>, <linux-raid@vger.kernel.org>, 
	<song@kernel.org>, <xni@redhat.com>, <linan122@huawei.com>, 
	"Heming Zhao" <heming.zhao@suse.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH 1/3] md: restore bitmap/location to fix wrong bitmap offset while growing
X-Original-From: Yu Kuai <yukuai@fnnas.com>

Hi,

=E5=9C=A8 2026/3/15 16:56, Glass Su =E5=86=99=E9=81=93:
>
>> On Mar 6, 2026, at 01:57, Yu Kuai <yukuai@fnnas.com> wrote:
>>
>> Hi,
>>
>> =E5=9C=A8 2026/3/4 11:14, Su Yue =E5=86=99=E9=81=93:
>>> On Wed 04 Mar 2026 at 10:30, "Yu Kuai" <yukuai@fnnas.com> wrote:
>>>
>>>> Hi,
>>>>
>>>> =E5=9C=A8 2026/3/3 11:37, Su Yue =E5=86=99=E9=81=93:
>>>>> Before commit fb8cc3b0d9db ("md/md-bitmap: delay registration of
>>>>> bitmap_ops until creating bitmap")
>>>>> if CONFIG_MD_BITMAP is enabled, both bitmap none, internal and
>>>>> clustered have
>>>>> the sysfs file bitmap/location.
>>>>>
>>>>> After the commit, if bitmap is none, bitmap/location doesn't exist
>>>>> anymore.
>>>>> It breaks 'grow' behavior of a md array of madam with
>>>>> MD_FEATURE_BITMAP_OFFSET.
>>>>> Take level=3Dmirror and metadata=3D1.2 as an example:
>>>>>
>>>>> $ mdadm  --create  /dev/md0 -f --bitmap=3Dnone --raid-devices=3D2
>>>>> --level=3Dmirror \
>>>>>     --metadata=3D1.2 /dev/vdd /dev/vde
>>>>> $ mdadm --grow /dev/md0 --bitmap=3Dinternal
>>>>> $ cat /sys/block/md0/md/bitmap/location
>>>>> Before:+8
>>>>> After: +2
>>>>>
>>>>> While growing bitmap from none to internal, clustered and llbitmap,
>>>>> mdadm/Grow.c:Grow_addbitmap() tries to detect bitmap/location first.
>>>>> 1)If bitmap/location exists, it sets bitmap/location after
>>>>> getinfo_super().
>>>>> 2)If bitmap/location doesn't exist, mdadm just calls
>>>>> md_set_array_info() then
>>>>> mddev->bitmap_info.default_offset will be used.
>>>>> Situation can be worse if growing none to clustered, bitmap offset
>>>>> of the node
>>>>> calling `madm --grow` will be changed but the other node are reading
>>>>> bitmap sb from
>>>>> the old location.
>>>> Now that we have a new sysfs attribute bitmap_type, can we fix this by=
:
>>>> - in the kernel, allow writing to this file in this case;
>>>> - in mdadm and the grow case above, write to this file first, and chan=
ge
>>>> bitmap_type from none to bitmap(For llbitmap, there is still more
>>>> work to do).
>>>>
>>> Yes. It's indeed feasible. But how about old versions mdadm? We can't
>>> require
>>> users' madadm + kernel combinations for old feature. Kernel part
>>> should keep
>>> compatibility with userspace. sysfs changes and broken haviros are not
>>> ideal
>>> especially userspace depends on it unless there's a strong reason.
>>> That's why linux/Documentation/ABI exists.
>> Okay, I can accept keep this old behavior.
>>
>> However, instead of introducing a new common_group with the same name "b=
itmap",
>> I'll prefer to introducing a separate bitmap_ops for none bitmap as well=
, and
>> you can define the attrs that are necessary.
>>
> After a try, the thing I realized is that a common group is unavoidable f=
or bitmap and none bitmap.
>
> mdadm writes to /sys/block/md0/md/bitmap/location, if remove_files() call=
ed by sysfs_remove_group()/
> sysfs_update_group() on same kernfs node, recursive locks will be trigger=
ed:
>
> [  139.516750] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [  139.517363] WARNING: possible recursive locking detected
> [  139.517953] 7.0.0-rc1-custom+ #282 Tainted: G           OE
> [  139.518628] --------------------------------------------
> [  139.519233] mdadm/2346 is trying to acquire lock:
> [  139.519836] ffff8e6b24d85000 (kn->active#116){++++}-{0:0}, at: __kernf=
s_remove+0xd1/0x3e0
> [  139.520848]
>                 but task is already holding lock:
> [  139.521561] ffff8e6b24d85000 (kn->active#116){++++}-{0:0}, at: kernfs_=
fop_write_iter+0x12d/0x250
> [  139.522603]
>                 other info that might help us debug this:
> [  139.523383]  Possible unsafe locking scenario:
>
> [  139.524169]        CPU0
> [  139.524430]        ----
> [  139.524682]   lock(kn->active#116);
> [  139.525047]   lock(kn->active#116);
> [  139.525398]
>                  *** DEADLOCK ***
>
> [  139.525990]  May be due to missing lock nesting notation
>
> [  139.526658] 4 locks held by mdadm/2346:
> [  139.527049]  #0: ffff8e6acd5ec420 (sb_writers#5){.+.+}-{0:0}, at: ksys=
_write+0x6c/0xe0
> [  139.527838]  #1: ffff8e6acd54fa88 (&of->mutex){+.+.}-{4:4}, at: kernfs=
_fop_write_iter+0x118/0x250
> [  139.528713]  #2: ffff8e6b24d85000 (kn->active#116){++++}-{0:0}, at: ke=
rnfs_fop_write_iter+0x12d/0x250
> [  139.529594]  #3: ffff8e6b26b51370 (&mddev->reconfig_mutex){+.+.}-{4:4}=
, at: location_store+0x6c/0x360 [md_mod]
>
> [  139.530535]  dump_stack_lvl+0x68/0x90
> [  139.530540]  print_deadlock_bug.cold+0xc0/0xcd
> [  139.530549]  __lock_acquire+0x1324/0x2250
> [  139.530556]  lock_acquire+0xc6/0x2f0
> [  139.530564]  kernfs_drain+0x1eb/0x200
> [  139.530568]  __kernfs_remove+0xd1/0x3e0
> [  139.530570]  kernfs_remove_by_name_ns+0x5e/0xb0
> [  139.530572]  internal_create_group+0x221/0x4d0
> [  139.530578]  md_bitmap_create+0x122/0x130 [md_mod]
> [  139.530586]  location_store+0x1e9/0x360 [md_mod]
> [  139.530594]  md_attr_store+0xb8/0x1a0 [md_mod]
> [  139.530602]  kernfs_fop_write_iter+0x176/0x250
> [  139.530605]  vfs_write+0x21b/0x560
> [  139.530609]  ksys_write+0x6c/0xe0
> [  139.530611]  do_syscall_64+0x10f/0x5f0
> [  139.530623]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>
> The  patch implemented by separated bitmap_ops is attached. This version =
looks pretty similar to the first
> version because of the reason listed above and IMO ungraceful. Dummy ops =
and functions are a little unnecessary.
>
> I would like to ask your opinion since you are the maintainer even though=
 I prefer v1 version + (remove the location entry for llbitmap).

Hi, I don't think you'll need to remove and recreate sysfs entry here, look=
s like
this problem is introduced by patch 2?

1) split bitmap group into a common group that contain location attr; and a=
 internal
bitmap group(the name is NULL), for example:

struct attribute_group *none_bitmap_group[] =3D {
	&common_bitmap_group,
	NULL
};

struct attribute_group *internal_bitmap_group[] =3D {
	&common_bitmap_group,
	&internal_bitmap_group,
	NULL,
};

2) create none bitmap with common group only, and create internal bitmap wi=
th common group and
internal bitmap group; Notice we should convert to user sysfs_create_groups=
().

3) while growing from none to bitmap, create internal bitmap group attrs

4) while growing from bitmap to none, remove internal bitmap group attrs

> Thanks.
>
>
>
> =E2=80=94
> Su
>
>
>
>> For llbitmap, I think it's fine, we don't need this old sysfs attr anywa=
y. I'll
>> support to convert from none/bitmap to llbitmap by writing the new bitma=
p_type
>> file.
>>
>>
>>> --=20
>>> Su
>>>
>>>>> Here restore sysfs file bitmap/location for ID_BITMAP_NONE and
>>>>> ID_BITMAP.
>>>>> And it d adds the entry for llbitmap too.
>>>>>
>>>>> New attribute_group md_bitmap_common_group is introduced and created =
in
>>>>> md_alloc() as before commit fb8cc3b0d9db.
>>>>> Add New operations register_group and unregister_group to struct
>>>>> bitmap_operations.
>>>>>
>>>>> Fixes: fb8cc3b0d9db ("md/md-bitmap: delay registration of bitmap_ops
>>>>> until creating bitmap")
>>>>> Signed-off-by: Su Yue <glass.su@suse.com>
>>>>> ---
>>>>>    drivers/md/md-bitmap.c   | 32 +++++++++++++++++++++++++++++++-
>>>>>    drivers/md/md-bitmap.h   |  5 +++++
>>>>>    drivers/md/md-llbitmap.c | 13 +++++++++++++
>>>>>    drivers/md/md.c          | 16 ++++++++++++----
>>>>>    4 files changed, 61 insertions(+), 5 deletions(-)
>>>>>
>>>>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>>>>> index 83378c033c72..8ff1dc94ed78 100644
>>>>> --- a/drivers/md/md-bitmap.c
>>>>> +++ b/drivers/md/md-bitmap.c
>>>>> @@ -2956,7 +2956,6 @@ __ATTR(max_backlog_used, S_IRUGO | S_IWUSR,
>>>>>           behind_writes_used_show, behind_writes_used_reset);
>>>>>
>>>>>    static struct attribute *md_bitmap_attrs[] =3D {
>>>>> -    &bitmap_location.attr,
>>>>>        &bitmap_space.attr,
>>>>>        &bitmap_timeout.attr,
>>>>>        &bitmap_backlog.attr,
>>>>> @@ -2967,11 +2966,40 @@ static struct attribute *md_bitmap_attrs[] =
=3D {
>>>>>        NULL
>>>>>    };
>>>>>
>>>>> +static struct attribute *md_bitmap_common_attrs[] =3D {
>>>>> +    &bitmap_location.attr,
>>>>> +    NULL
>>>>> +};
>>>>> +
>>>>>    static struct attribute_group md_bitmap_group =3D {
>>>>>        .name =3D "bitmap",
>>>>>        .attrs =3D md_bitmap_attrs,
>>>>>    };
>>>>>
>>>>> +static struct attribute_group md_bitmap_common_group =3D {
>>>>> +    .name =3D "bitmap",
>>>>> +    .attrs =3D md_bitmap_common_attrs,
>>>>> +};
>>>>> +
>>>>> +int md_sysfs_create_common_group(struct mddev *mddev)
>>>>> +{
>>>>> +    return sysfs_create_group(&mddev->kobj, &md_bitmap_common_group)=
;
>>>>> +}
>>>>> +
>>>>> +static int bitmap_register_group(struct mddev *mddev)
>>>>> +{
>>>>> +    /*
>>>>> +     * md_bitmap_group and md_bitmap_common_group are using same nam=
e
>>>>> +     * 'bitmap'.
>>>>> +     */
>>>>> +    return sysfs_merge_group(&mddev->kobj, &md_bitmap_group);
>>>>> +}
>>>>> +
>>>>> +static void bitmap_unregister_group(struct mddev *mddev)
>>>>> +{
>>>>> +    sysfs_unmerge_group(&mddev->kobj, &md_bitmap_group);
>>>>> +}
>>>>> +
>>>>>    static struct bitmap_operations bitmap_ops =3D {
>>>>>        .head =3D {
>>>>>            .type    =3D MD_BITMAP,
>>>>> @@ -3013,6 +3041,8 @@ static struct bitmap_operations bitmap_ops =3D =
{
>>>>>        .set_pages        =3D bitmap_set_pages,
>>>>>        .free            =3D md_bitmap_free,
>>>>>
>>>>> +    .register_group        =3D bitmap_register_group,
>>>>> +    .unregister_group    =3D bitmap_unregister_group,
>>>>>        .group            =3D &md_bitmap_group,
>>>>>    };
>>>>>
>>>>> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
>>>>> index b42a28fa83a0..371791e9011d 100644
>>>>> --- a/drivers/md/md-bitmap.h
>>>>> +++ b/drivers/md/md-bitmap.h
>>>>> @@ -125,6 +125,9 @@ struct bitmap_operations {
>>>>>        void (*set_pages)(void *data, unsigned long pages);
>>>>>        void (*free)(void *data);
>>>>>
>>>>> +    int (*register_group)(struct mddev *mddev);
>>>>> +    void (*unregister_group)(struct mddev *mddev);
>>>>> +
>>>>>        struct attribute_group *group;
>>>>>    };
>>>>>
>>>>> @@ -169,6 +172,8 @@ static inline void md_bitmap_end_sync(struct
>>>>> mddev *mddev, sector_t offset,
>>>>>        mddev->bitmap_ops->end_sync(mddev, offset, blocks);
>>>>>    }
>>>>>
>>>>> +int md_sysfs_create_common_group(struct mddev *mddev);
>>>>> +
>>>>>    #ifdef CONFIG_MD_BITMAP
>>>>>    int md_bitmap_init(void);
>>>>>    void md_bitmap_exit(void);
>>>>> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
>>>>> index bf398d7476b3..24ff5f7f8751 100644
>>>>> --- a/drivers/md/md-llbitmap.c
>>>>> +++ b/drivers/md/md-llbitmap.c
>>>>> @@ -1561,6 +1561,16 @@ static struct attribute_group
>>>>> md_llbitmap_group =3D {
>>>>>        .attrs =3D md_llbitmap_attrs,
>>>>>    };
>>>>>
>>>>> +static int llbitmap_register_group(struct mddev *mddev)
>>>>> +{
>>>>> +    return sysfs_create_group(&mddev->kobj, &md_llbitmap_group);
>>>>> +}
>>>>> +
>>>>> +static void llbitmap_unregister_group(struct mddev *mddev)
>>>>> +{
>>>>> +    sysfs_remove_group(&mddev->kobj, &md_llbitmap_group);
>>>>> +}
>>>>> +
>>>>>    static struct bitmap_operations llbitmap_ops =3D {
>>>>>        .head =3D {
>>>>>            .type    =3D MD_BITMAP,
>>>>> @@ -1597,6 +1607,9 @@ static struct bitmap_operations llbitmap_ops =
=3D {
>>>>>        .dirty_bits        =3D llbitmap_dirty_bits,
>>>>>        .write_all        =3D llbitmap_write_all,
>>>>>
>>>>> +    .register_group        =3D llbitmap_register_group,
>>>>> +    .unregister_group    =3D llbitmap_unregister_group,
>>>>> +
>>>>>        .group            =3D &md_llbitmap_group,
>>>>>    };
>>>>>
>>>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>>>> index 3ce6f9e9d38e..ab969e950ea8 100644
>>>>> --- a/drivers/md/md.c
>>>>> +++ b/drivers/md/md.c
>>>>> @@ -703,8 +703,8 @@ static bool mddev_set_bitmap_ops(struct mddev
>>>>> *mddev)
>>>>>        mddev->bitmap_ops =3D (void *)head;
>>>>>        xa_unlock(&md_submodule);
>>>>>
>>>>> -    if (!mddev_is_dm(mddev) && mddev->bitmap_ops->group) {
>>>>> -        if (sysfs_create_group(&mddev->kobj,
>>>>> mddev->bitmap_ops->group))
>>>>> +    if (!mddev_is_dm(mddev) && mddev->bitmap_ops->register_group) {
>>>>> +        if (mddev->bitmap_ops->register_group(mddev))
>>>>>                pr_warn("md: cannot register extra bitmap attributes
>>>>> for %s\n",
>>>>>                    mdname(mddev));
>>>>>            else
>>>>> @@ -724,8 +724,8 @@ static bool mddev_set_bitmap_ops(struct mddev
>>>>> *mddev)
>>>>>    static void mddev_clear_bitmap_ops(struct mddev *mddev)
>>>>>    {
>>>>>        if (!mddev_is_dm(mddev) && mddev->bitmap_ops &&
>>>>> -        mddev->bitmap_ops->group)
>>>>> -        sysfs_remove_group(&mddev->kobj, mddev->bitmap_ops->group);
>>>>> +        mddev->bitmap_ops->unregister_group)
>>>>> +        mddev->bitmap_ops->unregister_group(mddev);
>>>>>
>>>>>        mddev->bitmap_ops =3D NULL;
>>>>>    }
>>>>> @@ -6369,6 +6369,14 @@ struct mddev *md_alloc(dev_t dev, char *name)
>>>>>            return ERR_PTR(error);
>>>>>        }
>>>>>
>>>>> +    /*
>>>>> +     * md_sysfs_remove_common_group is not needed because
>>>>> mddev_delayed_delete
>>>>> +     * calls kobject_put(&mddev->kobj) if mddev is to be deleted.
>>>>> +     */
>>>>> +    if (md_sysfs_create_common_group(mddev))
>>>>> +        pr_warn("md: cannot register common bitmap attributes for
>>>>> %s\n",
>>>>> +            mdname(mddev));
>>>>> +
>>>>>        kobject_uevent(&mddev->kobj, KOBJ_ADD);
>>>>>        mddev->sysfs_state =3D sysfs_get_dirent_safe(mddev->kobj.sd,
>>>>> "array_state");
>>>>>        mddev->sysfs_level =3D sysfs_get_dirent_safe(mddev->kobj.sd,
>>>>> "level");
>> --=20
>> Thansk,
>> Kuai
>
--=20
Thansk,
Kuai
