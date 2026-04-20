Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9777A3815EF
	for <linux-raid@vger.kernel.org>; Mon, 20 Apr 2026 07:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776668768; cv=pass; b=ZcTGR6lCvuJ6O8J7MiZw+C0kDQubx+jbkav4MAYlBIAqnWHbp+VxRMpoay6NcmYLRy8TQDgsJEhrAQ/AD4/HC4L8S4zxY4l8QGNgjICTmNiY3/TB6EmGPQW7hoep4tYk4LLD3RR3krOFVMY1F7fIFhVqoOyI7xnIMgDhtNuTi1I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776668768; c=relaxed/simple;
	bh=BkmXSTZ84N3wD+Cqp5+WufqJLgN9NlFw7Z67hDFpQJw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OkEq56SM/LMf03b4gMXfV6hEBvij+3F2MIaF1ZMyK0mIhAHaW1SLf4ieFo13f/ZScwTDII/+oM6oO4E3ZQ/pwmufo2XIaqApmueHjH+sutiLK1y+Zhmsso0J73faWxSc6d1qt6lJk5T97UfsPP7KkCPn/U0eHBWWTaV9s5R1TRc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q1fBl80W; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ovcE6FvG; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q1fBl80W";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ovcE6FvG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776668764;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PjrCEwPjoPzCYNNAUGqFRk7o/CLzHqvxEcXz77aeSU8=;
	b=Q1fBl80WpxOQphK3KkqvWf46CBOSF0LHtG6ZeEf52rZbDkvsJ/nKr9MLLJRs/gLduNd5dy
	C4rMBnvDK9hJ8ymmV/ccZsZYEXUuHJYHZza+3Atz4lITArt2wwDua+VyZSlzPbLe8AC5Tb
	ydb/wfFERaGeHLqbReRe/9yPkkt5Xvk=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-QgVFzjC8PaG9Puqqk8jtZw-1; Mon, 20 Apr 2026 03:06:03 -0400
X-MC-Unique: QgVFzjC8PaG9Puqqk8jtZw-1
X-Mimecast-MFC-AGG-ID: QgVFzjC8PaG9Puqqk8jtZw_1776668761
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5a409cef179so1863094e87.1
        for <linux-raid@vger.kernel.org>; Mon, 20 Apr 2026 00:06:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776668761; cv=none;
        d=google.com; s=arc-20240605;
        b=JgkYypOABodpSQTKlOIcLuHwanTeORZvz4NqETa/7/8F1x1nimv3vfWAiPYOJn2EwQ
         +GNxRM2s2NSwYuVHqEqTvQ7ub4gNhhdJUVDUsfRMzREm9raGut+wSn1KX0M239715XCH
         Xxh82cYhJabiegNCL0Gzj970yStVC8eRoNO6xkDGljXJ/g7QpNk0aNBt454x1aPlKjod
         Uvnke/MEreciG9hdZQlKkTZXfNvAQlOA2Cv7eDdYpkwgLjucORqDqE2vv7j63FiPfvtc
         e9S6L8F2WqLsQakESq8GXXdUW2PMLDAYnKTK8uGomgv5coi6Nx0XThoA1MSB+9NxMR8/
         xwyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PjrCEwPjoPzCYNNAUGqFRk7o/CLzHqvxEcXz77aeSU8=;
        fh=TWACGSidAuI7eL+hD1976w75hZ91sk4LU3yEBGmW8+c=;
        b=Oa4UDFZTAzcYFjtOGmRaO/VSGYvfuvdqSKEnZ9Wntro2I+ViUXZ91ohMKuVrQoVqA4
         mN5Op+/vzsLTb+04lzcqmmy7KtP53n99hZO7AeiHMYkxfqKCY8nDU4vxJSGsEPG28+Ni
         C6+kiIBgUKi3OKyb1ofpj51HEZwLEL+sU4fyVWI59uGcBspwjCQwApTlk3rsawLWDiq7
         uVu2Neiq+gWu0+Q5gF+4f3GMwqaZs89lksyu4s0xqTG/Zd4wrlzrZ9aTanpue0mWoqfw
         R6mmKWv7v1M0H5KMbsOVPrHuHONA25YvQG8I9m//+F3XxpbgTTXyiUmAbygc/f7KtAok
         Im0Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776668761; x=1777273561; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PjrCEwPjoPzCYNNAUGqFRk7o/CLzHqvxEcXz77aeSU8=;
        b=ovcE6FvGMVLASi+6Zv5dQJTEZMagRLbBYNmxciuM48zRfA8jPaVuuFBc0iMuUkP7T5
         sa+HOkYn8yRSmnYRbUg2nfdXf9LijlCMKN2KQGkt+qGW1Vm2sq5OgZ7WkREp8JxYmp7h
         whyN+gAX6osy2ZkVv+CpcSYDI4OoFmi+KZ2AzpomiErel9oNiaCnnLkCTMIeugB0iGQP
         ejCYV3GF3C3PRSZGMN5K3FPOju2HYYPbdkzxftPlpb/wAQGdDf7X3oljPsfHo2FE651+
         Y6E9VIwBt+QCs2xYynk1uNW0PZxSMqGCEIKAn9VbqP7Yag520PYOJWYpfBuHZFD5Wf5l
         /46Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776668761; x=1777273561;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PjrCEwPjoPzCYNNAUGqFRk7o/CLzHqvxEcXz77aeSU8=;
        b=GqKUEiI8U9QGPM0bP4YtK2IKFwnG5kDXtyiMXu8xfNrhvRSOvVBlcuTkge66cpDixv
         hz03wJrArXMzGNfIddg22vB/CStp7M3oRpnHZ38iWv3KGPZWhNB9aM9ZkrKIDv2VQ/p6
         8yiT+nLctiBdtvfUnmvxfn/1pEixegOtLxe8SqWTrHOVhpDkrLMSbkmDRxiYe9VjY/d3
         AQDMMsFmVWIh2znG3QKbgA4cGquJjZMek4X5d474/pcNwHGARF3LcGv67KPAOd16FQsP
         l1oHDutLcX06xGxZ/nmH/dea9EPCpda6HqLQwVCETMqXK/FONHRoJilWKLFSd75xP7bk
         PcbA==
X-Gm-Message-State: AOJu0YwjB34DJm11PpCx8xsq3xdlC2lfBLOpV2UaoAKohs3cevFsqJbd
	VB2+WftJdVcB1/xBYUBlY9N3aGDJsuYEl05tVbi9F87mIFGmW6AqWIfVE2a4OWTpbd99ngu0+LZ
	um6X5pxEBsIf/YsLCnpfxQC9JR7g6tBqu44Uygli/OLvwUR6l0qDdrSh58mWPx0NswKv7AQ5O9k
	KKVU9em9xKSNDh8MxaxzLp2ukwmNB9FDdlsQqXpg==
X-Gm-Gg: AeBDiev/uI9uwq1mxQE3aoWpJG+cNuVIdEDtLgff/4zM5h8K0+SWOyo7iAA94WV4OZg
	QT0dGGsgXJ8YGdNqy2NCX3SxL1w3S5M61q/bGfpnpbbJ9N6PqwkLPymk9bF8zGroBltTy3PFd9c
	I0guomMup/K/7/grGL6gmQt35aWfwR+LCTGi2OZtBzMJvPuWqz6G8oZRr8MoKR43B5CPBjllF8p
	pJCowsNKNoixOkf9s9m/vL97nt2PjkpVT2aGJytFuHzpBjl+psj1H0A3g4hdbxsJ/8TfdH7ruB+
	+WZ+yZBHQjWTuzxQ
X-Received: by 2002:a05:6512:108c:b0:5a2:c962:59f2 with SMTP id 2adb3069b0e04-5a4172e1c03mr3402312e87.22.1776668760994;
        Mon, 20 Apr 2026 00:06:00 -0700 (PDT)
X-Received: by 2002:a05:6512:108c:b0:5a2:c962:59f2 with SMTP id
 2adb3069b0e04-5a4172e1c03mr3402284e87.22.1776668760318; Mon, 20 Apr 2026
 00:06:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260407102625.5686-1-glass.su@suse.com> <20260407102625.5686-4-glass.su@suse.com>
In-Reply-To: <20260407102625.5686-4-glass.su@suse.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 20 Apr 2026 15:05:46 +0800
X-Gm-Features: AQROBzCEYwiEr7EJGFEF2N65tNDHpIuS7si2Z0jsJZoQXQrBXiD-ocHbuV7ANZg
Message-ID: <CALTww28XwfDKbcnrka_YMtgTtArjAXEGhbUafVVGEWuAjV2o3w@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] md/md-bitmap: add dummy bitmap ops for none to fix
 wrong bitmap offset
To: Su Yue <glass.su@suse.com>
Cc: linux-raid@vger.kernel.org, song@kernel.org, linan122@huawei.com, 
	yukuai@fnnas.com, heming.zhao@suse.com, l@damenly.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 7, 2026 at 6:27=E2=80=AFPM Su Yue <glass.su@suse.com> wrote:
>
> Before commit fb8cc3b0d9db ("md/md-bitmap: delay registration of bitmap_o=
ps until creating bitmap")
> if CONFIG_MD_BITMAP is enabled, both bitmap none, internal and clustered =
have
> the sysfs file bitmap/location.
>
> After the commit, if bitmap is none, bitmap/location doesn't exist anymor=
e.
> It breaks 'grow' behavior of a md array of madam with MD_FEATURE_BITMAP_O=
FFSET.
> Take level=3Dmirror and metadata=3D1.2 as an example:
>
> $ mdadm  --create  /dev/md0 -f --bitmap=3Dnone --raid-devices=3D2 --level=
=3Dmirror \
>   --metadata=3D1.2 /dev/vdd /dev/vde
> $ mdadm --grow /dev/md0 --bitmap=3Dinternal
> $ cat /sys/block/md0/md/bitmap/location
> Before:+8
> After: +2
>
> While growing bitmap from none to internal, clustered and llbitmap,
> mdadm/Grow.c:Grow_addbitmap() tries to detect bitmap/location first.
> 1)If bitmap/location exists, it sets bitmap/location after getinfo_super(=
).
> 2)If bitmap/location doesn't exist, mdadm just calls md_set_array_info() =
then
> mddev->bitmap_info.default_offset will be used.
> Situation can be worse if growing none to clustered, bitmap offset of the=
 node
> calling `madm --grow` will be changed but the other node are reading bitm=
ap sb from
> the old location.
>
> Here introducing a dummy bitmap_operations for ID_BITMAP_NONE to restore =
sysfs
> file bitmap/location for ID_BITMAP_NONE and ID_BITMAP.
> location_store() now calls md_bitmap_(create|destroy) with false sysfs pa=
rameter then
> (add,remove)_internal_bitmap() will be called to manage sysfs entries.
>
> Fixes: fb8cc3b0d9db ("md/md-bitmap: delay registration of bitmap_ops unti=
l creating bitmap")
> Suggested-by: Yu Kuai <yukuai@fnnas.com>
> Signed-off-by: Su Yue <glass.su@suse.com>
> ---
>  drivers/md/md-bitmap.c   | 116 ++++++++++++++++++++++++++++++++++++---
>  drivers/md/md-bitmap.h   |   3 +
>  drivers/md/md-llbitmap.c |  12 ++++
>  drivers/md/md.c          |  16 +++---
>  4 files changed, 130 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index ac06c9647bf0..a8a176428c61 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -240,6 +240,11 @@ static bool bitmap_enabled(void *data, bool flush)
>                bitmap->storage.filemap !=3D NULL;
>  }
>
> +static bool dummy_bitmap_enabled(void *data, bool flush)
> +{
> +       return false;
> +}
> +
>  /*
>   * check a page and, if necessary, allocate it (or hijack it if the allo=
c fails)
>   *
> @@ -2201,6 +2206,11 @@ static int bitmap_create(struct mddev *mddev)
>         return 0;
>  }
>
> +static int dummy_bitmap_create(struct mddev *mddev)
> +{
> +       return 0;
> +}
> +
>  static int bitmap_load(struct mddev *mddev)
>  {
>         int err =3D 0;
> @@ -2594,6 +2604,9 @@ location_show(struct mddev *mddev, char *page)
>         return len;
>  }
>
> +static int create_internal_group(struct mddev *mddev);
> +static void remove_internal_group(struct mddev *mddev);
> +
>  static ssize_t
>  location_store(struct mddev *mddev, const char *buf, size_t len)
>  {
> @@ -2618,7 +2631,8 @@ location_store(struct mddev *mddev, const char *buf=
, size_t len)
>                         goto out;
>                 }
>
> -               md_bitmap_destroy(mddev, true);
> +               md_bitmap_destroy(mddev, false);
> +               remove_internal_group(mddev);
>                 mddev->bitmap_info.offset =3D 0;
>                 if (mddev->bitmap_info.file) {
>                         struct file *f =3D mddev->bitmap_info.file;
> @@ -2659,14 +2673,22 @@ location_store(struct mddev *mddev, const char *b=
uf, size_t len)
>                          */
>                         mddev->bitmap_id =3D ID_BITMAP;
>                         mddev->bitmap_info.offset =3D offset;
> -                       rv =3D md_bitmap_create(mddev, true);
> +                       rv =3D md_bitmap_create(mddev, false);
>                         if (rv)
>                                 goto out;
>
> +                       rv =3D create_internal_group(mddev);
> +                       if (rv) {
> +                               mddev->bitmap_info.offset =3D 0;
> +                               bitmap_destroy(mddev);
> +                               goto out;
> +                       }
> +
>                         rv =3D bitmap_load(mddev);
>                         if (rv) {
> +                               remove_internal_group(mddev);
>                                 mddev->bitmap_info.offset =3D 0;
> -                               md_bitmap_destroy(mddev, true);
> +                               md_bitmap_destroy(mddev, false);
>                                 goto out;
>                         }
>                 }
> @@ -2960,8 +2982,7 @@ static struct md_sysfs_entry max_backlog_used =3D
>  __ATTR(max_backlog_used, S_IRUGO | S_IWUSR,
>         behind_writes_used_show, behind_writes_used_reset);
>
> -static struct attribute *md_bitmap_attrs[] =3D {
> -       &bitmap_location.attr,
> +static struct attribute *internal_bitmap_attrs[] =3D {
>         &bitmap_space.attr,
>         &bitmap_timeout.attr,
>         &bitmap_backlog.attr,
> @@ -2972,11 +2993,57 @@ static struct attribute *md_bitmap_attrs[] =3D {
>         NULL
>  };
>
> -static struct attribute_group md_bitmap_group =3D {
> +static struct attribute_group internal_bitmap_group =3D {
>         .name =3D "bitmap",
> -       .attrs =3D md_bitmap_attrs,
> +       .attrs =3D internal_bitmap_attrs,
>  };
>
> +/* Only necessary attrs for compatibility */
> +static struct attribute *common_bitmap_attrs[] =3D {
> +       &bitmap_location.attr,
> +       NULL
> +};
> +
> +static const struct attribute_group common_bitmap_group =3D {
> +       .name =3D "bitmap",
> +       .attrs =3D common_bitmap_attrs,
> +};
> +
> +static int create_internal_group(struct mddev *mddev)
> +{
> +       /*
> +        * md_bitmap_group and md_bitmap_common_group are using same name
> +        * 'bitmap'.
> +        */
> +       return sysfs_merge_group(&mddev->kobj, &internal_bitmap_group);
> +}
> +
> +static void remove_internal_group(struct mddev *mddev)
> +{
> +       sysfs_unmerge_group(&mddev->kobj, &internal_bitmap_group);
> +}
> +
> +static int bitmap_register_groups(struct mddev *mddev)
> +{
> +       int ret;
> +
> +       ret =3D sysfs_create_group(&mddev->kobj, &common_bitmap_group);
> +
> +       if (ret)
> +               return ret;
> +
> +       ret =3D sysfs_merge_group(&mddev->kobj, &internal_bitmap_group);
> +       if (ret)
> +               sysfs_remove_group(&mddev->kobj, &common_bitmap_group);
> +
> +       return ret;
> +}
> +
> +static void bitmap_unregister_groups(struct mddev *mddev)
> +{
> +       sysfs_unmerge_group(&mddev->kobj, &internal_bitmap_group);
> +}

Hi Su

bitmap_unregister_groups should also remove common_bitmap_group, right?

> +
>  static struct bitmap_operations bitmap_ops =3D {

You already changed md_bitmap_group to internal_bitmap_group. It's
better to change bitmap_ops to internal_bitmap_ops?

>         .head =3D {
>                 .type   =3D MD_BITMAP,
> @@ -3018,21 +3085,52 @@ static struct bitmap_operations bitmap_ops =3D {
>         .set_pages              =3D bitmap_set_pages,
>         .free                   =3D md_bitmap_free,
>
> -       .group                  =3D &md_bitmap_group,
> +       .register_groups        =3D bitmap_register_groups,
> +       .unregister_groups      =3D bitmap_unregister_groups,
> +};
> +
> +static int none_bitmap_register_groups(struct mddev *mddev)
> +{
> +       return sysfs_create_group(&mddev->kobj, &common_bitmap_group);
> +}
> +
> +static struct bitmap_operations none_bitmap_ops =3D {
> +       .head =3D {
> +               .type   =3D MD_BITMAP,
> +               .id     =3D ID_BITMAP_NONE,
> +               .name   =3D "none",
> +       },
> +
> +       .enabled                =3D dummy_bitmap_enabled,
> +       .create                 =3D dummy_bitmap_create,
> +       .destroy                =3D bitmap_destroy,
> +       .load                   =3D bitmap_load,
> +       .get_stats              =3D bitmap_get_stats,
> +       .free                   =3D md_bitmap_free,
> +
> +       .register_groups        =3D none_bitmap_register_groups,
> +       .unregister_groups      =3D NULL,

How does bitmap/location can be deleted if array is created with no
bitmap? Can the `mdadm --stop` command get stuck?

Best Regards
Xiao

>  };
>
>  int md_bitmap_init(void)
>  {
> +       int ret;
> +
>         md_bitmap_wq =3D alloc_workqueue("md_bitmap", WQ_MEM_RECLAIM | WQ=
_UNBOUND,
>                                        0);
>         if (!md_bitmap_wq)
>                 return -ENOMEM;
>
> -       return register_md_submodule(&bitmap_ops.head);
> +       ret =3D register_md_submodule(&bitmap_ops.head);
> +       if (ret)
> +               return ret;
> +
> +       return register_md_submodule(&none_bitmap_ops.head);
>  }
>
>  void md_bitmap_exit(void)
>  {
>         destroy_workqueue(md_bitmap_wq);
>         unregister_md_submodule(&bitmap_ops.head);
> +       unregister_md_submodule(&none_bitmap_ops.head);
>  }
> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
> index b42a28fa83a0..10bc6854798c 100644
> --- a/drivers/md/md-bitmap.h
> +++ b/drivers/md/md-bitmap.h
> @@ -125,6 +125,9 @@ struct bitmap_operations {
>         void (*set_pages)(void *data, unsigned long pages);
>         void (*free)(void *data);
>
> +       int (*register_groups)(struct mddev *mddev);
> +       void (*unregister_groups)(struct mddev *mddev);
> +
>         struct attribute_group *group;
>  };
>
> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index bf398d7476b3..9b3ea4f1d268 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
> @@ -1561,6 +1561,16 @@ static struct attribute_group md_llbitmap_group =
=3D {
>         .attrs =3D md_llbitmap_attrs,
>  };
>
> +static int llbitmap_register_groups(struct mddev *mddev)
> +{
> +       return sysfs_create_group(&mddev->kobj, &md_llbitmap_group);
> +}
> +
> +static void llbitmap_unregister_groups(struct mddev *mddev)
> +{
> +       sysfs_remove_group(&mddev->kobj, &md_llbitmap_group);
> +}
> +
>  static struct bitmap_operations llbitmap_ops =3D {
>         .head =3D {
>                 .type   =3D MD_BITMAP,
> @@ -1597,6 +1607,8 @@ static struct bitmap_operations llbitmap_ops =3D {
>         .dirty_bits             =3D llbitmap_dirty_bits,
>         .write_all              =3D llbitmap_write_all,
>
> +       .register_groups        =3D llbitmap_register_groups,
> +       .unregister_groups      =3D llbitmap_unregister_groups,
>         .group                  =3D &md_llbitmap_group,
>  };
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d3c8f77b4fe3..55a95b227b83 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -683,8 +683,7 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev,=
 bool create_sysfs)
>         struct bitmap_operations *old =3D mddev->bitmap_ops;
>         struct md_submodule_head *head;
>
> -       if (mddev->bitmap_id =3D=3D ID_BITMAP_NONE ||
> -           (old && old->head.id =3D=3D mddev->bitmap_id))
> +       if (old && old->head.id =3D=3D mddev->bitmap_id)
>                 return true;
>
>         xa_lock(&md_submodule);
> @@ -703,8 +702,8 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev,=
 bool create_sysfs)
>         mddev->bitmap_ops =3D (void *)head;
>         xa_unlock(&md_submodule);
>
> -       if (create_sysfs && !mddev_is_dm(mddev) && mddev->bitmap_ops->gro=
up) {
> -               if (sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->g=
roup))
> +       if (create_sysfs && !mddev_is_dm(mddev) && mddev->bitmap_ops->reg=
ister_groups) {
> +               if (mddev->bitmap_ops->register_groups(mddev))
>                         pr_warn("md: cannot register extra bitmap attribu=
tes for %s\n",
>                                 mdname(mddev));
>                 else
> @@ -724,8 +723,8 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev,=
 bool create_sysfs)
>  static void mddev_clear_bitmap_ops(struct mddev *mddev, bool remove_sysf=
s)
>  {
>         if (remove_sysfs && !mddev_is_dm(mddev) && mddev->bitmap_ops &&
> -           mddev->bitmap_ops->group)
> -               sysfs_remove_group(&mddev->kobj, mddev->bitmap_ops->group=
);
> +           mddev->bitmap_ops->unregister_groups)
> +               mddev->bitmap_ops->unregister_groups(mddev);
>
>         mddev->bitmap_ops =3D NULL;
>  }
> @@ -6610,8 +6609,9 @@ int md_run(struct mddev *mddev)
>                         (unsigned long long)pers->size(mddev, 0, 0) / 2);
>                 err =3D -EINVAL;
>         }
> -       if (err =3D=3D 0 && pers->sync_request &&
> -           (mddev->bitmap_info.file || mddev->bitmap_info.offset)) {
> +       if (err =3D=3D 0 && pers->sync_request) {
> +               if (mddev->bitmap_info.offset =3D=3D 0)
> +                       mddev->bitmap_id =3D ID_BITMAP_NONE;
>                 err =3D md_bitmap_create(mddev, true);
>                 if (err)
>                         pr_warn("%s: failed to create bitmap (%d)\n",
> --
> 2.53.0
>

