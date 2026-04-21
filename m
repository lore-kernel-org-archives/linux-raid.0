Received: from mail-108-mta47.mxroute.com (mail-108-mta47.mxroute.com [136.175.108.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A4E19D092
	for <linux-raid@vger.kernel.org>; Tue, 21 Apr 2026 02:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776738874; cv=none; b=a24kVOYzDMODq9F/C0Jz2F1ovjJ84QdC8S9hoQj2sw1Xi29R44dNR7raFvPjCVfld5Gk+BydHYMH4u63Y25wcdkfY186PmNSv6CLYz4jZZIePhye+nWaJw5AxDQNluoW7gtD/fP81oD6/utRPKHQGtbg6fszTPh81Wx0JJNzkvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776738874; c=relaxed/simple;
	bh=ymOVCTs3uIUgESgNZ3puhTCmaVLYVoAoX639MOz3ed8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=twgUd0IdU57ILz7JCT25Z4hijSafDx2Ray9qgek0bnBZuLUClYuOqW+4FC9kp+S48/sjorAUPU8323ZakSfmg0FnHStmb6NteFJVTphWf2rkzzQNRQHaGyYcxQWcaeTQTJjjaKaiyYf67QzNimt36alatip8UmwKSOHvtVyvaAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=FVDKL6tq; arc=none smtp.client-ip=136.175.108.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="FVDKL6tq"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta47.mxroute.com (ZoneMTA) with ESMTPSA id 19daddee90300032bf.007
 for <linux-raid@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Tue, 21 Apr 2026 02:29:20 +0000
X-Zone-Loop: d7c96cbff95f897815b70c7e49d14c8c66499af94479
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:
	References:In-Reply-To:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/l5tuu6ntma5vdbEnlN2esAWK4pcKSQMmiln5h+FeNg=; b=FVDKL6tq6bKwdbrWDmkhiRi+2Z
	Rmyc0MbPEKQu9SCJe0zMmuIxWjFdQO/GFPq1TwV4d+NvRUBaSfVCmgLcQmaxHVseTz5Bt8Tb4zTlw
	lwULJPnek7l7W0XYNzm9Ur0oYPxAa5zX1WPZzj33oJMH3leE8G4mDRIBhh0YYiHANyAEYJ/odriCh
	hGRCEkSXVUAct20riZJGl0IrfCuiRLSD2Mf3Zbn/gmXjfJllFbTRXotfAWfnshxcPkRSXtoFioi7r
	hw8YE3WNWTZSSqeA63CRT8KEUX8pgvcfVPZosrHG3ZjAYFB2Y9usCBUu4ug76lbpKxXSh7m7Ei6AG
	T1sRo0sQ==;
From: Su Yue <l@damenly.org>
To: Xiao Ni <xni@redhat.com>
Cc: Su Yue <glass.su@suse.com>,  linux-raid@vger.kernel.org,
  song@kernel.org,  linan122@huawei.com,  yukuai@fnnas.com,
  heming.zhao@suse.com
Subject: Re: [PATCH v2 3/5] md/md-bitmap: add dummy bitmap ops for none to
 fix wrong bitmap offset
In-Reply-To: <CALTww28XwfDKbcnrka_YMtgTtArjAXEGhbUafVVGEWuAjV2o3w@mail.gmail.com>
 (Xiao
	Ni's message of "Mon, 20 Apr 2026 15:05:46 +0800")
References: <20260407102625.5686-1-glass.su@suse.com>
	<20260407102625.5686-4-glass.su@suse.com>
	<CALTww28XwfDKbcnrka_YMtgTtArjAXEGhbUafVVGEWuAjV2o3w@mail.gmail.com>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Tue, 21 Apr 2026 10:29:06 +0800
Message-ID: <1pg982rx.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Authenticated-Id: l@damenly.org

On Mon 20 Apr 2026 at 15:05, Xiao Ni <xni@redhat.com> wrote:

> On Tue, Apr 7, 2026 at 6:27=E2=80=AFPM Su Yue <glass.su@suse.com> wrote:
>>
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
>>   --metadata=3D1.2 /dev/vdd /dev/vde
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
>>
>> Here introducing a dummy bitmap_operations for ID_BITMAP_NONE=20
>> to restore sysfs
>> file bitmap/location for ID_BITMAP_NONE and ID_BITMAP.
>> location_store() now calls md_bitmap_(create|destroy) with=20
>> false sysfs parameter then
>> (add,remove)_internal_bitmap() will be called to manage sysfs=20
>> entries.
>>
>> Fixes: fb8cc3b0d9db ("md/md-bitmap: delay registration of=20
>> bitmap_ops until creating bitmap")
>> Suggested-by: Yu Kuai <yukuai@fnnas.com>
>> Signed-off-by: Su Yue <glass.su@suse.com>
>> ---
>>  drivers/md/md-bitmap.c   | 116=20
>>  ++++++++++++++++++++++++++++++++++++---
>>  drivers/md/md-bitmap.h   |   3 +
>>  drivers/md/md-llbitmap.c |  12 ++++
>>  drivers/md/md.c          |  16 +++---
>>  4 files changed, 130 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>> index ac06c9647bf0..a8a176428c61 100644
>> --- a/drivers/md/md-bitmap.c
>> +++ b/drivers/md/md-bitmap.c
>> @@ -240,6 +240,11 @@ static bool bitmap_enabled(void *data,=20
>> bool flush)
>>                bitmap->storage.filemap !=3D NULL;
>>  }
>>
>> +static bool dummy_bitmap_enabled(void *data, bool flush)
>> +{
>> +       return false;
>> +}
>> +
>>  /*
>>   * check a page and, if necessary, allocate it (or hijack it=20
>>   if the alloc fails)
>>   *
>> @@ -2201,6 +2206,11 @@ static int bitmap_create(struct mddev=20
>> *mddev)
>>         return 0;
>>  }
>>
>> +static int dummy_bitmap_create(struct mddev *mddev)
>> +{
>> +       return 0;
>> +}
>> +
>>  static int bitmap_load(struct mddev *mddev)
>>  {
>>         int err =3D 0;
>> @@ -2594,6 +2604,9 @@ location_show(struct mddev *mddev, char=20
>> *page)
>>         return len;
>>  }
>>
>> +static int create_internal_group(struct mddev *mddev);
>> +static void remove_internal_group(struct mddev *mddev);
>> +
>>  static ssize_t
>>  location_store(struct mddev *mddev, const char *buf, size_t=20
>>  len)
>>  {
>> @@ -2618,7 +2631,8 @@ location_store(struct mddev *mddev, const=20
>> char *buf, size_t len)
>>                         goto out;
>>                 }
>>
>> -               md_bitmap_destroy(mddev, true);
>> +               md_bitmap_destroy(mddev, false);
>> +               remove_internal_group(mddev);
>>                 mddev->bitmap_info.offset =3D 0;
>>                 if (mddev->bitmap_info.file) {
>>                         struct file *f =3D=20
>>                         mddev->bitmap_info.file;
>> @@ -2659,14 +2673,22 @@ location_store(struct mddev *mddev,=20
>> const char *buf, size_t len)
>>                          */
>>                         mddev->bitmap_id =3D ID_BITMAP;
>>                         mddev->bitmap_info.offset =3D offset;
>> -                       rv =3D md_bitmap_create(mddev, true);
>> +                       rv =3D md_bitmap_create(mddev, false);
>>                         if (rv)
>>                                 goto out;
>>
>> +                       rv =3D create_internal_group(mddev);
>> +                       if (rv) {
>> +                               mddev->bitmap_info.offset =3D 0;
>> +                               bitmap_destroy(mddev);
>> +                               goto out;
>> +                       }
>> +
>>                         rv =3D bitmap_load(mddev);
>>                         if (rv) {
>> +                               remove_internal_group(mddev);
>>                                 mddev->bitmap_info.offset =3D 0;
>> -                               md_bitmap_destroy(mddev, true);
>> +                               md_bitmap_destroy(mddev,=20
>> false);
>>                                 goto out;
>>                         }
>>                 }
>> @@ -2960,8 +2982,7 @@ static struct md_sysfs_entry=20
>> max_backlog_used =3D
>>  __ATTR(max_backlog_used, S_IRUGO | S_IWUSR,
>>         behind_writes_used_show, behind_writes_used_reset);
>>
>> -static struct attribute *md_bitmap_attrs[] =3D {
>> -       &bitmap_location.attr,
>> +static struct attribute *internal_bitmap_attrs[] =3D {
>>         &bitmap_space.attr,
>>         &bitmap_timeout.attr,
>>         &bitmap_backlog.attr,
>> @@ -2972,11 +2993,57 @@ static struct attribute=20
>> *md_bitmap_attrs[] =3D {
>>         NULL
>>  };
>>
>> -static struct attribute_group md_bitmap_group =3D {
>> +static struct attribute_group internal_bitmap_group =3D {
>>         .name =3D "bitmap",
>> -       .attrs =3D md_bitmap_attrs,
>> +       .attrs =3D internal_bitmap_attrs,
>>  };
>>
>> +/* Only necessary attrs for compatibility */
>> +static struct attribute *common_bitmap_attrs[] =3D {
>> +       &bitmap_location.attr,
>> +       NULL
>> +};
>> +
>> +static const struct attribute_group common_bitmap_group =3D {
>> +       .name =3D "bitmap",
>> +       .attrs =3D common_bitmap_attrs,
>> +};
>> +
>> +static int create_internal_group(struct mddev *mddev)
>> +{
>> +       /*
>> +        * md_bitmap_group and md_bitmap_common_group are using=20
>> same name
>> +        * 'bitmap'.
>> +        */
>> +       return sysfs_merge_group(&mddev->kobj,=20
>> &internal_bitmap_group);
>> +}
>> +
>> +static void remove_internal_group(struct mddev *mddev)
>> +{
>> +       sysfs_unmerge_group(&mddev->kobj,=20
>> &internal_bitmap_group);
>> +}
>> +
>> +static int bitmap_register_groups(struct mddev *mddev)
>> +{
>> +       int ret;
>> +
>> +       ret =3D sysfs_create_group(&mddev->kobj,=20
>> &common_bitmap_group);
>> +
>> +       if (ret)
>> +               return ret;
>> +
>> +       ret =3D sysfs_merge_group(&mddev->kobj,=20
>> &internal_bitmap_group);
>> +       if (ret)
>> +               sysfs_remove_group(&mddev->kobj,=20
>> &common_bitmap_group);
>> +
>> +       return ret;
>> +}
>> +
>> +static void bitmap_unregister_groups(struct mddev *mddev)
>> +{
>> +       sysfs_unmerge_group(&mddev->kobj,=20
>> &internal_bitmap_group);
>> +}
>
> Hi Su
>
> bitmap_unregister_groups should also remove common_bitmap_group,=20
> right?
>

As you pasted before, mdadm:Grow.c:

int Grow_addbitmap(char *devname, int fd, struct context *c,=20
struct shape *s)
{
...
	if (array.state & (1 << MD_SB_BITMAP_PRESENT)) {
		if (s->btype =3D=3D BitmapNone) {
			array.state &=3D ~(1 << MD_SB_BITMAP_PRESENT);
			if (md_set_array_info(fd, &array) !=3D 0) {
				if (array.state & (1 << MD_SB_CLUSTERED))
					pr_err("failed to remove clustered=20
					bitmap.\n");
				else
					pr_err("failed to remove internal bitmap.\n");
				return 1;
			}
			return 0;
		}
		pr_err("bitmap already present on %s\n", devname);
		return 1;
	}
...
}

In case of growing from internal to none,=20
bitmap_unregister_groups() will
be called, if common_bitmap_group is removed, bitmap/location=20
won't exist.
update_array_info() is a common function used by many call paths.=20
Also
llbitmap is involved here. I don't want to make situation and code=20
more
complicated like adding more codes in update_array_info().


>> +
>>  static struct bitmap_operations bitmap_ops =3D {
>
> You already changed md_bitmap_group to internal_bitmap_group.=20
> It's
> better to change bitmap_ops to internal_bitmap_ops?
>
>>         .head =3D {
>>                 .type   =3D MD_BITMAP,
>> @@ -3018,21 +3085,52 @@ static struct bitmap_operations=20
>> bitmap_ops =3D {
>>         .set_pages              =3D bitmap_set_pages,
>>         .free                   =3D md_bitmap_free,
>>
>> -       .group                  =3D &md_bitmap_group,
>> +       .register_groups        =3D bitmap_register_groups,
>> +       .unregister_groups      =3D bitmap_unregister_groups,
>> +};
>> +
>> +static int none_bitmap_register_groups(struct mddev *mddev)
>> +{
>> +       return sysfs_create_group(&mddev->kobj,=20
>> &common_bitmap_group);
>> +}
>> +
>> +static struct bitmap_operations none_bitmap_ops =3D {
>> +       .head =3D {
>> +               .type   =3D MD_BITMAP,
>> +               .id     =3D ID_BITMAP_NONE,
>> +               .name   =3D "none",
>> +       },
>> +
>> +       .enabled                =3D dummy_bitmap_enabled,
>> +       .create                 =3D dummy_bitmap_create,
>> +       .destroy                =3D bitmap_destroy,
>> +       .load                   =3D bitmap_load,
>> +       .get_stats              =3D bitmap_get_stats,
>> +       .free                   =3D md_bitmap_free,
>> +
>> +       .register_groups        =3D none_bitmap_register_groups,
>> +       .unregister_groups      =3D NULL,
>
> How does bitmap/location can be deleted if array is created with=20
> no
> bitmap? Can the `mdadm --stop` command get stuck?
>
No. It wont get stuck.

I guess here your concern is the timing of removing=20
common_bitmap_group.
The life cycle is same as before fb8cc3b0d9db. At the time=20
llbitmap is
not introduced, because there is no need to switch bitmap ops, so=20
all
attrs of bitmap are removed in kobject_put() in=20
mddev_delayed_delete()
queued by mddev_put(). This is now where common_bitmap_group is=20
being removed.

--
Su
> Best Regards
> Xiao
>
>>  };
>>
>>  int md_bitmap_init(void)
>>  {
>> +       int ret;
>> +
>>         md_bitmap_wq =3D alloc_workqueue("md_bitmap",=20
>>         WQ_MEM_RECLAIM | WQ_UNBOUND,
>>                                        0);
>>         if (!md_bitmap_wq)
>>                 return -ENOMEM;
>>
>> -       return register_md_submodule(&bitmap_ops.head);
>> +       ret =3D register_md_submodule(&bitmap_ops.head);
>> +       if (ret)
>> +               return ret;
>> +
>> +       return register_md_submodule(&none_bitmap_ops.head);
>>  }
>>
>>  void md_bitmap_exit(void)
>>  {
>>         destroy_workqueue(md_bitmap_wq);
>>         unregister_md_submodule(&bitmap_ops.head);
>> +       unregister_md_submodule(&none_bitmap_ops.head);
>>  }
>> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
>> index b42a28fa83a0..10bc6854798c 100644
>> --- a/drivers/md/md-bitmap.h
>> +++ b/drivers/md/md-bitmap.h
>> @@ -125,6 +125,9 @@ struct bitmap_operations {
>>         void (*set_pages)(void *data, unsigned long pages);
>>         void (*free)(void *data);
>>
>> +       int (*register_groups)(struct mddev *mddev);
>> +       void (*unregister_groups)(struct mddev *mddev);
>> +
>>         struct attribute_group *group;
>>  };
>>
>> diff --git a/drivers/md/md-llbitmap.c=20
>> b/drivers/md/md-llbitmap.c
>> index bf398d7476b3..9b3ea4f1d268 100644
>> --- a/drivers/md/md-llbitmap.c
>> +++ b/drivers/md/md-llbitmap.c
>> @@ -1561,6 +1561,16 @@ static struct attribute_group=20
>> md_llbitmap_group =3D {
>>         .attrs =3D md_llbitmap_attrs,
>>  };
>>
>> +static int llbitmap_register_groups(struct mddev *mddev)
>> +{
>> +       return sysfs_create_group(&mddev->kobj,=20
>> &md_llbitmap_group);
>> +}
>> +
>> +static void llbitmap_unregister_groups(struct mddev *mddev)
>> +{
>> +       sysfs_remove_group(&mddev->kobj, &md_llbitmap_group);
>> +}
>> +
>>  static struct bitmap_operations llbitmap_ops =3D {
>>         .head =3D {
>>                 .type   =3D MD_BITMAP,
>> @@ -1597,6 +1607,8 @@ static struct bitmap_operations=20
>> llbitmap_ops =3D {
>>         .dirty_bits             =3D llbitmap_dirty_bits,
>>         .write_all              =3D llbitmap_write_all,
>>
>> +       .register_groups        =3D llbitmap_register_groups,
>> +       .unregister_groups      =3D llbitmap_unregister_groups,
>>         .group                  =3D &md_llbitmap_group,
>>  };
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index d3c8f77b4fe3..55a95b227b83 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -683,8 +683,7 @@ static bool mddev_set_bitmap_ops(struct=20
>> mddev *mddev, bool create_sysfs)
>>         struct bitmap_operations *old =3D mddev->bitmap_ops;
>>         struct md_submodule_head *head;
>>
>> -       if (mddev->bitmap_id =3D=3D ID_BITMAP_NONE ||
>> -           (old && old->head.id =3D=3D mddev->bitmap_id))
>> +       if (old && old->head.id =3D=3D mddev->bitmap_id)
>>                 return true;
>>
>>         xa_lock(&md_submodule);
>> @@ -703,8 +702,8 @@ static bool mddev_set_bitmap_ops(struct=20
>> mddev *mddev, bool create_sysfs)
>>         mddev->bitmap_ops =3D (void *)head;
>>         xa_unlock(&md_submodule);
>>
>> -       if (create_sysfs && !mddev_is_dm(mddev) &&=20
>> mddev->bitmap_ops->group) {
>> -               if (sysfs_create_group(&mddev->kobj,=20
>> mddev->bitmap_ops->group))
>> +       if (create_sysfs && !mddev_is_dm(mddev) &&=20
>> mddev->bitmap_ops->register_groups) {
>> +               if (mddev->bitmap_ops->register_groups(mddev))
>>                         pr_warn("md: cannot register extra=20
>>                         bitmap attributes for %s\n",
>>                                 mdname(mddev));
>>                 else
>> @@ -724,8 +723,8 @@ static bool mddev_set_bitmap_ops(struct=20
>> mddev *mddev, bool create_sysfs)
>>  static void mddev_clear_bitmap_ops(struct mddev *mddev, bool=20
>>  remove_sysfs)
>>  {
>>         if (remove_sysfs && !mddev_is_dm(mddev) &&=20
>>         mddev->bitmap_ops &&
>> -           mddev->bitmap_ops->group)
>> -               sysfs_remove_group(&mddev->kobj,=20
>> mddev->bitmap_ops->group);
>> +           mddev->bitmap_ops->unregister_groups)
>> +               mddev->bitmap_ops->unregister_groups(mddev);
>>
>>         mddev->bitmap_ops =3D NULL;
>>  }
>> @@ -6610,8 +6609,9 @@ int md_run(struct mddev *mddev)
>>                         (unsigned long long)pers->size(mddev,=20
>>                         0, 0) / 2);
>>                 err =3D -EINVAL;
>>         }
>> -       if (err =3D=3D 0 && pers->sync_request &&
>> -           (mddev->bitmap_info.file ||=20
>> mddev->bitmap_info.offset)) {
>> +       if (err =3D=3D 0 && pers->sync_request) {
>> +               if (mddev->bitmap_info.offset =3D=3D 0)
>> +                       mddev->bitmap_id =3D ID_BITMAP_NONE;
>>                 err =3D md_bitmap_create(mddev, true);
>>                 if (err)
>>                         pr_warn("%s: failed to create bitmap=20
>>                         (%d)\n",
>> --
>> 2.53.0
>>
