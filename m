Received: from mail-108-mta89.mxroute.com (mail-108-mta89.mxroute.com [136.175.108.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424092E03E4
	for <linux-raid@vger.kernel.org>; Tue, 21 Apr 2026 09:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776763591; cv=none; b=aYuPrLv5YolI4JzIzZpIYGc2ZFePlZOYQez+knZ20VJm6CX5tk5W4o9+EDf7RJLs/tDW6FW/MKapbov5ZdJb0D27gGLDK96+Ab2aNj9GchLK0J0qdEZKY9Ci5Y05EI2/SMoxug3dfk5sfCQkKVlQ5joVQeSalSW5sr4+3cnzjjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776763591; c=relaxed/simple;
	bh=vuiJnb4MfWTZLSUgFAfbBboxijHwkzBk3npnzxQV2wI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=S8vUmnVjYHSX3vFVzUQbj23lKBqUVDEDpr7oXMyx4d0GUNFZbYZ0OxvZGiZgl/3BTy2Jr8V6ZD4pWKgNQOmGHdfmWAFhiUD7dEjPa609p7rHcjBwbFVrCnPGol5VEzH2JOiNMNrEe2blIHJc+IhvygadMNMTgaoGhhKiyvEvazA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=tcvFjOu2; arc=none smtp.client-ip=136.175.108.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="tcvFjOu2"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta89.mxroute.com (ZoneMTA) with ESMTPSA id 19daf58092d00067f7.007
 for <linux-raid@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Tue, 21 Apr 2026 09:21:15 +0000
X-Zone-Loop: 15537724c4163ecde373ea707fa0b080acdf24c21ebc
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:
	References:In-Reply-To:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7o7IDvTYUVqq/YK/mn4bdHRjnFKpKlPwOqBSj34vyOs=; b=tcvFjOu2G3P18zajmJmXRzuL8N
	MxCHiHM/THs4nQCf9ARUIy878RzlqPFQYBBgKVFHgK6XZWo0H/y/NPqswKxFrrM3PfUVumqyc3rmF
	gRXEL7aKPYk6Dsg7SD1oIXY53EYLrzmuAM8PY60SlAQMCNDsGFp1RoY+62CLMc2+X7t2Fq98L+zHn
	ZXfnUquW3H1LWcA0F9vgC0SsguOq3FR04qikwyX3+3tDQoYW6XeWZzRhEYaB30Js9vm45o+/A2h9e
	nrKosmMO3j1CMDHMTZZ1T/ydz/spi/N8TfkFCB/UjtYULD4jKbNWdyiXLPSWODVpRbbqXtJAUoa75
	AA4oGwmA==;
From: Su Yue <l@damenly.org>
To: Xiao Ni <xni@redhat.com>
Cc: Su Yue <glass.su@suse.com>,  linux-raid@vger.kernel.org,
  song@kernel.org,  linan122@huawei.com,  yukuai@fnnas.com,
  heming.zhao@suse.com
Subject: Re: [PATCH v2 3/5] md/md-bitmap: add dummy bitmap ops for none to
 fix wrong bitmap offset
In-Reply-To: <CALTww29y_EJq3Qkimn67cSTnL6_+Yi6Lf1LoT=JJM6YqmFTjaw@mail.gmail.com>
 (Xiao
	Ni's message of "Tue, 21 Apr 2026 15:36:09 +0800")
References: <20260407102625.5686-1-glass.su@suse.com>
	<20260407102625.5686-4-glass.su@suse.com>
	<CALTww28XwfDKbcnrka_YMtgTtArjAXEGhbUafVVGEWuAjV2o3w@mail.gmail.com>
	<1pg982rx.fsf@damenly.org>
	<CALTww29y_EJq3Qkimn67cSTnL6_+Yi6Lf1LoT=JJM6YqmFTjaw@mail.gmail.com>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Tue, 21 Apr 2026 17:21:03 +0800
Message-ID: <pl3s7jpc.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Authenticated-Id: l@damenly.org

On Tue 21 Apr 2026 at 15:36, Xiao Ni <xni@redhat.com> wrote:

> On Tue, Apr 21, 2026 at 10:29=E2=80=AFAM Su Yue <l@damenly.org> wrote:
>>
>> On Mon 20 Apr 2026 at 15:05, Xiao Ni <xni@redhat.com> wrote:
>>
>> > On Tue, Apr 7, 2026 at 6:27=E2=80=AFPM Su Yue <glass.su@suse.com>=20
>> > wrote:
>> >>
>> >> Before commit fb8cc3b0d9db ("md/md-bitmap: delay=20
>> >> registration
>> >> of bitmap_ops until creating bitmap")
>> >> if CONFIG_MD_BITMAP is enabled, both bitmap none, internal=20
>> >> and
>> >> clustered have
>> >> the sysfs file bitmap/location.
>> >>
>> >> After the commit, if bitmap is none, bitmap/location doesn't
>> >> exist anymore.
>> >> It breaks 'grow' behavior of a md array of madam with
>> >> MD_FEATURE_BITMAP_OFFSET.
>> >> Take level=3Dmirror and metadata=3D1.2 as an example:
>> >>
>> >> $ mdadm  --create  /dev/md0 -f --bitmap=3Dnone=20
>> >> --raid-devices=3D2
>> >> --level=3Dmirror \
>> >>   --metadata=3D1.2 /dev/vdd /dev/vde
>> >> $ mdadm --grow /dev/md0 --bitmap=3Dinternal
>> >> $ cat /sys/block/md0/md/bitmap/location
>> >> Before:+8
>> >> After: +2
>> >>
>> >> While growing bitmap from none to internal, clustered and
>> >> llbitmap,
>> >> mdadm/Grow.c:Grow_addbitmap() tries to detect=20
>> >> bitmap/location
>> >> first.
>> >> 1)If bitmap/location exists, it sets bitmap/location after
>> >> getinfo_super().
>> >> 2)If bitmap/location doesn't exist, mdadm just calls
>> >> md_set_array_info() then
>> >> mddev->bitmap_info.default_offset will be used.
>> >> Situation can be worse if growing none to clustered, bitmap
>> >> offset of the node
>> >> calling `madm --grow` will be changed but the other node are
>> >> reading bitmap sb from
>> >> the old location.
>> >>
>> >> Here introducing a dummy bitmap_operations for=20
>> >> ID_BITMAP_NONE
>> >> to restore sysfs
>> >> file bitmap/location for ID_BITMAP_NONE and ID_BITMAP.
>> >> location_store() now calls md_bitmap_(create|destroy) with
>> >> false sysfs parameter then
>> >> (add,remove)_internal_bitmap() will be called to manage=20
>> >> sysfs
>> >> entries.
>> >>
>> >> Fixes: fb8cc3b0d9db ("md/md-bitmap: delay registration of
>> >> bitmap_ops until creating bitmap")
>> >> Suggested-by: Yu Kuai <yukuai@fnnas.com>
>> >> Signed-off-by: Su Yue <glass.su@suse.com>
>> >> ---
>> >>  drivers/md/md-bitmap.c   | 116
>> >>  ++++++++++++++++++++++++++++++++++++---
>> >>  drivers/md/md-bitmap.h   |   3 +
>> >>  drivers/md/md-llbitmap.c |  12 ++++
>> >>  drivers/md/md.c          |  16 +++---
>> >>  4 files changed, 130 insertions(+), 17 deletions(-)
>> >>
>> >> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>> >> index ac06c9647bf0..a8a176428c61 100644
>> >> --- a/drivers/md/md-bitmap.c
>> >> +++ b/drivers/md/md-bitmap.c
>> >> @@ -240,6 +240,11 @@ static bool bitmap_enabled(void *data,
>> >> bool flush)
>> >>                bitmap->storage.filemap !=3D NULL;
>> >>  }
>> >>
>> >> +static bool dummy_bitmap_enabled(void *data, bool flush)
>> >> +{
>> >> +       return false;
>> >> +}
>> >> +
>> >>  /*
>> >>   * check a page and, if necessary, allocate it (or hijack=20
>> >>   it
>> >>   if the alloc fails)
>> >>   *
>> >> @@ -2201,6 +2206,11 @@ static int bitmap_create(struct mddev
>> >> *mddev)
>> >>         return 0;
>> >>  }
>> >>
>> >> +static int dummy_bitmap_create(struct mddev *mddev)
>> >> +{
>> >> +       return 0;
>> >> +}
>> >> +
>> >>  static int bitmap_load(struct mddev *mddev)
>> >>  {
>> >>         int err =3D 0;
>> >> @@ -2594,6 +2604,9 @@ location_show(struct mddev *mddev,=20
>> >> char
>> >> *page)
>> >>         return len;
>> >>  }
>> >>
>> >> +static int create_internal_group(struct mddev *mddev);
>> >> +static void remove_internal_group(struct mddev *mddev);
>> >> +
>> >>  static ssize_t
>> >>  location_store(struct mddev *mddev, const char *buf, size_t
>> >>  len)
>> >>  {
>> >> @@ -2618,7 +2631,8 @@ location_store(struct mddev *mddev,=20
>> >> const
>> >> char *buf, size_t len)
>> >>                         goto out;
>> >>                 }
>> >>
>> >> -               md_bitmap_destroy(mddev, true);
>> >> +               md_bitmap_destroy(mddev, false);
>> >> +               remove_internal_group(mddev);
>> >>                 mddev->bitmap_info.offset =3D 0;
>> >>                 if (mddev->bitmap_info.file) {
>> >>                         struct file *f =3D
>> >>                         mddev->bitmap_info.file;
>> >> @@ -2659,14 +2673,22 @@ location_store(struct mddev *mddev,
>> >> const char *buf, size_t len)
>> >>                          */
>> >>                         mddev->bitmap_id =3D ID_BITMAP;
>> >>                         mddev->bitmap_info.offset =3D offset;
>> >> -                       rv =3D md_bitmap_create(mddev, true);
>> >> +                       rv =3D md_bitmap_create(mddev, false);
>> >>                         if (rv)
>> >>                                 goto out;
>> >>
>> >> +                       rv =3D create_internal_group(mddev);
>> >> +                       if (rv) {
>> >> +                               mddev->bitmap_info.offset =3D=20
>> >> 0;
>> >> +                               bitmap_destroy(mddev);
>> >> +                               goto out;
>> >> +                       }
>> >> +
>> >>                         rv =3D bitmap_load(mddev);
>> >>                         if (rv) {
>> >> +=20
>> >> remove_internal_group(mddev);
>> >>                                 mddev->bitmap_info.offset =3D=20
>> >>                                 0;
>> >> -                               md_bitmap_destroy(mddev,=20
>> >> true);
>> >> +                               md_bitmap_destroy(mddev,
>> >> false);
>> >>                                 goto out;
>> >>                         }
>> >>                 }
>> >> @@ -2960,8 +2982,7 @@ static struct md_sysfs_entry
>> >> max_backlog_used =3D
>> >>  __ATTR(max_backlog_used, S_IRUGO | S_IWUSR,
>> >>         behind_writes_used_show, behind_writes_used_reset);
>> >>
>> >> -static struct attribute *md_bitmap_attrs[] =3D {
>> >> -       &bitmap_location.attr,
>> >> +static struct attribute *internal_bitmap_attrs[] =3D {
>> >>         &bitmap_space.attr,
>> >>         &bitmap_timeout.attr,
>> >>         &bitmap_backlog.attr,
>> >> @@ -2972,11 +2993,57 @@ static struct attribute
>> >> *md_bitmap_attrs[] =3D {
>> >>         NULL
>> >>  };
>> >>
>> >> -static struct attribute_group md_bitmap_group =3D {
>> >> +static struct attribute_group internal_bitmap_group =3D {
>> >>         .name =3D "bitmap",
>> >> -       .attrs =3D md_bitmap_attrs,
>> >> +       .attrs =3D internal_bitmap_attrs,
>> >>  };
>> >>
>> >> +/* Only necessary attrs for compatibility */
>> >> +static struct attribute *common_bitmap_attrs[] =3D {
>> >> +       &bitmap_location.attr,
>> >> +       NULL
>> >> +};
>> >> +
>> >> +static const struct attribute_group common_bitmap_group =3D {
>> >> +       .name =3D "bitmap",
>> >> +       .attrs =3D common_bitmap_attrs,
>> >> +};
>> >> +
>> >> +static int create_internal_group(struct mddev *mddev)
>> >> +{
>> >> +       /*
>> >> +        * md_bitmap_group and md_bitmap_common_group are=20
>> >> using
>> >> same name
>> >> +        * 'bitmap'.
>> >> +        */
>> >> +       return sysfs_merge_group(&mddev->kobj,
>> >> &internal_bitmap_group);
>> >> +}
>> >> +
>> >> +static void remove_internal_group(struct mddev *mddev)
>> >> +{
>> >> +       sysfs_unmerge_group(&mddev->kobj,
>> >> &internal_bitmap_group);
>> >> +}
>> >> +
>> >> +static int bitmap_register_groups(struct mddev *mddev)
>> >> +{
>> >> +       int ret;
>> >> +
>> >> +       ret =3D sysfs_create_group(&mddev->kobj,
>> >> &common_bitmap_group);
>> >> +
>> >> +       if (ret)
>> >> +               return ret;
>> >> +
>> >> +       ret =3D sysfs_merge_group(&mddev->kobj,
>> >> &internal_bitmap_group);
>> >> +       if (ret)
>> >> +               sysfs_remove_group(&mddev->kobj,
>> >> &common_bitmap_group);
>> >> +
>> >> +       return ret;
>> >> +}
>> >> +
>> >> +static void bitmap_unregister_groups(struct mddev *mddev)
>> >> +{
>> >> +       sysfs_unmerge_group(&mddev->kobj,
>> >> &internal_bitmap_group);
>> >> +}
>> >
>> > Hi Su
>> >
>> > bitmap_unregister_groups should also remove=20
>> > common_bitmap_group,
>> > right?
>> >
>>
>> As you pasted before, mdadm:Grow.c:
>>
>> int Grow_addbitmap(char *devname, int fd, struct context *c,
>> struct shape *s)
>> {
>> ...
>>         if (array.state & (1 << MD_SB_BITMAP_PRESENT)) {
>>                 if (s->btype =3D=3D BitmapNone) {
>>                         array.state &=3D ~(1 <<=20
>>                         MD_SB_BITMAP_PRESENT);
>>                         if (md_set_array_info(fd, &array) !=3D 0)=20
>>                         {
>>                                 if (array.state & (1 <<=20
>>                                 MD_SB_CLUSTERED))
>>                                         pr_err("failed to=20
>>                                         remove clustered
>>                                         bitmap.\n");
>>                                 else
>>                                         pr_err("failed to=20
>>                                         remove internal=20
>>                                         bitmap.\n");
>>                                 return 1;
>>                         }
>>                         return 0;
>>                 }
>>                 pr_err("bitmap already present on %s\n",=20
>>                 devname);
>>                 return 1;
>>         }
>> ...
>> }
>>
>> In case of growing from internal to none,
>> bitmap_unregister_groups() will
>> be called, if common_bitmap_group is removed, bitmap/location
>> won't exist.
>> update_array_info() is a common function used by many call=20
>> paths.
>> Also
>> llbitmap is involved here. I don't want to make situation and=20
>> code
>> more
>> complicated like adding more codes in update_array_info().
>
> The above mdadm codes use bitmap/location. In your patch, you=20
> already
> pass false to md_bitmap_destroy in location_store. So removing
> common_bitmap_group in bitmap_unregister_groups can't affect the=20
> above
> case.
>
Right. Got confusion between md_set_array_info() and=20
update_array_info().

>
> But after reading your below comments. It's good to me that
> bitmap_unregister_groups doesn't remove common_bitmap_group.
>
Thanks.

--
Su
>>
>>
>> >> +
>> >>  static struct bitmap_operations bitmap_ops =3D {
>> >
>> > You already changed md_bitmap_group to internal_bitmap_group.
>> > It's
>> > better to change bitmap_ops to internal_bitmap_ops?
>> >
>> >>         .head =3D {
>> >>                 .type   =3D MD_BITMAP,
>> >> @@ -3018,21 +3085,52 @@ static struct bitmap_operations
>> >> bitmap_ops =3D {
>> >>         .set_pages              =3D bitmap_set_pages,
>> >>         .free                   =3D md_bitmap_free,
>> >>
>> >> -       .group                  =3D &md_bitmap_group,
>> >> +       .register_groups        =3D bitmap_register_groups,
>> >> +       .unregister_groups      =3D bitmap_unregister_groups,
>> >> +};
>> >> +
>> >> +static int none_bitmap_register_groups(struct mddev *mddev)
>> >> +{
>> >> +       return sysfs_create_group(&mddev->kobj,
>> >> &common_bitmap_group);
>> >> +}
>> >> +
>> >> +static struct bitmap_operations none_bitmap_ops =3D {
>> >> +       .head =3D {
>> >> +               .type   =3D MD_BITMAP,
>> >> +               .id     =3D ID_BITMAP_NONE,
>> >> +               .name   =3D "none",
>> >> +       },
>> >> +
>> >> +       .enabled                =3D dummy_bitmap_enabled,
>> >> +       .create                 =3D dummy_bitmap_create,
>> >> +       .destroy                =3D bitmap_destroy,
>> >> +       .load                   =3D bitmap_load,
>> >> +       .get_stats              =3D bitmap_get_stats,
>> >> +       .free                   =3D md_bitmap_free,
>> >> +
>> >> +       .register_groups        =3D=20
>> >> none_bitmap_register_groups,
>> >> +       .unregister_groups      =3D NULL,
>> >
>> > How does bitmap/location can be deleted if array is created=20
>> > with
>> > no
>> > bitmap? Can the `mdadm --stop` command get stuck?
>> >
>> No. It wont get stuck.
>>
>> I guess here your concern is the timing of removing
>> common_bitmap_group.
>> The life cycle is same as before fb8cc3b0d9db. At the time
>> llbitmap is
>> not introduced, because there is no need to switch bitmap ops,=20
>> so
>> all
>> attrs of bitmap are removed in kobject_put() in
>> mddev_delayed_delete()
>> queued by mddev_put(). This is now where common_bitmap_group is
>> being removed.
>
> Thanks for the explanation.
>
> Best Regards
> Xiao
>>
>> --
>> Su
>> > Best Regards
>> > Xiao
>> >
>> >>  };
>> >>
>> >>  int md_bitmap_init(void)
>> >>  {
>> >> +       int ret;
>> >> +
>> >>         md_bitmap_wq =3D alloc_workqueue("md_bitmap",
>> >>         WQ_MEM_RECLAIM | WQ_UNBOUND,
>> >>                                        0);
>> >>         if (!md_bitmap_wq)
>> >>                 return -ENOMEM;
>> >>
>> >> -       return register_md_submodule(&bitmap_ops.head);
>> >> +       ret =3D register_md_submodule(&bitmap_ops.head);
>> >> +       if (ret)
>> >> +               return ret;
>> >> +
>> >> +       return register_md_submodule(&none_bitmap_ops.head);
>> >>  }
>> >>
>> >>  void md_bitmap_exit(void)
>> >>  {
>> >>         destroy_workqueue(md_bitmap_wq);
>> >>         unregister_md_submodule(&bitmap_ops.head);
>> >> +       unregister_md_submodule(&none_bitmap_ops.head);
>> >>  }
>> >> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
>> >> index b42a28fa83a0..10bc6854798c 100644
>> >> --- a/drivers/md/md-bitmap.h
>> >> +++ b/drivers/md/md-bitmap.h
>> >> @@ -125,6 +125,9 @@ struct bitmap_operations {
>> >>         void (*set_pages)(void *data, unsigned long pages);
>> >>         void (*free)(void *data);
>> >>
>> >> +       int (*register_groups)(struct mddev *mddev);
>> >> +       void (*unregister_groups)(struct mddev *mddev);
>> >> +
>> >>         struct attribute_group *group;
>> >>  };
>> >>
>> >> diff --git a/drivers/md/md-llbitmap.c
>> >> b/drivers/md/md-llbitmap.c
>> >> index bf398d7476b3..9b3ea4f1d268 100644
>> >> --- a/drivers/md/md-llbitmap.c
>> >> +++ b/drivers/md/md-llbitmap.c
>> >> @@ -1561,6 +1561,16 @@ static struct attribute_group
>> >> md_llbitmap_group =3D {
>> >>         .attrs =3D md_llbitmap_attrs,
>> >>  };
>> >>
>> >> +static int llbitmap_register_groups(struct mddev *mddev)
>> >> +{
>> >> +       return sysfs_create_group(&mddev->kobj,
>> >> &md_llbitmap_group);
>> >> +}
>> >> +
>> >> +static void llbitmap_unregister_groups(struct mddev *mddev)
>> >> +{
>> >> +       sysfs_remove_group(&mddev->kobj,=20
>> >> &md_llbitmap_group);
>> >> +}
>> >> +
>> >>  static struct bitmap_operations llbitmap_ops =3D {
>> >>         .head =3D {
>> >>                 .type   =3D MD_BITMAP,
>> >> @@ -1597,6 +1607,8 @@ static struct bitmap_operations
>> >> llbitmap_ops =3D {
>> >>         .dirty_bits             =3D llbitmap_dirty_bits,
>> >>         .write_all              =3D llbitmap_write_all,
>> >>
>> >> +       .register_groups        =3D llbitmap_register_groups,
>> >> +       .unregister_groups      =3D=20
>> >> llbitmap_unregister_groups,
>> >>         .group                  =3D &md_llbitmap_group,
>> >>  };
>> >>
>> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> >> index d3c8f77b4fe3..55a95b227b83 100644
>> >> --- a/drivers/md/md.c
>> >> +++ b/drivers/md/md.c
>> >> @@ -683,8 +683,7 @@ static bool mddev_set_bitmap_ops(struct
>> >> mddev *mddev, bool create_sysfs)
>> >>         struct bitmap_operations *old =3D mddev->bitmap_ops;
>> >>         struct md_submodule_head *head;
>> >>
>> >> -       if (mddev->bitmap_id =3D=3D ID_BITMAP_NONE ||
>> >> -           (old && old->head.id =3D=3D mddev->bitmap_id))
>> >> +       if (old && old->head.id =3D=3D mddev->bitmap_id)
>> >>                 return true;
>> >>
>> >>         xa_lock(&md_submodule);
>> >> @@ -703,8 +702,8 @@ static bool mddev_set_bitmap_ops(struct
>> >> mddev *mddev, bool create_sysfs)
>> >>         mddev->bitmap_ops =3D (void *)head;
>> >>         xa_unlock(&md_submodule);
>> >>
>> >> -       if (create_sysfs && !mddev_is_dm(mddev) &&
>> >> mddev->bitmap_ops->group) {
>> >> -               if (sysfs_create_group(&mddev->kobj,
>> >> mddev->bitmap_ops->group))
>> >> +       if (create_sysfs && !mddev_is_dm(mddev) &&
>> >> mddev->bitmap_ops->register_groups) {
>> >> +               if=20
>> >> (mddev->bitmap_ops->register_groups(mddev))
>> >>                         pr_warn("md: cannot register extra
>> >>                         bitmap attributes for %s\n",
>> >>                                 mdname(mddev));
>> >>                 else
>> >> @@ -724,8 +723,8 @@ static bool mddev_set_bitmap_ops(struct
>> >> mddev *mddev, bool create_sysfs)
>> >>  static void mddev_clear_bitmap_ops(struct mddev *mddev,=20
>> >>  bool
>> >>  remove_sysfs)
>> >>  {
>> >>         if (remove_sysfs && !mddev_is_dm(mddev) &&
>> >>         mddev->bitmap_ops &&
>> >> -           mddev->bitmap_ops->group)
>> >> -               sysfs_remove_group(&mddev->kobj,
>> >> mddev->bitmap_ops->group);
>> >> +           mddev->bitmap_ops->unregister_groups)
>> >> +               mddev->bitmap_ops->unregister_groups(mddev);
>> >>
>> >>         mddev->bitmap_ops =3D NULL;
>> >>  }
>> >> @@ -6610,8 +6609,9 @@ int md_run(struct mddev *mddev)
>> >>                         (unsigned long=20
>> >>                         long)pers->size(mddev,
>> >>                         0, 0) / 2);
>> >>                 err =3D -EINVAL;
>> >>         }
>> >> -       if (err =3D=3D 0 && pers->sync_request &&
>> >> -           (mddev->bitmap_info.file ||
>> >> mddev->bitmap_info.offset)) {
>> >> +       if (err =3D=3D 0 && pers->sync_request) {
>> >> +               if (mddev->bitmap_info.offset =3D=3D 0)
>> >> +                       mddev->bitmap_id =3D ID_BITMAP_NONE;
>> >>                 err =3D md_bitmap_create(mddev, true);
>> >>                 if (err)
>> >>                         pr_warn("%s: failed to create bitmap
>> >>                         (%d)\n",
>> >> --
>> >> 2.53.0
>> >>
>>
