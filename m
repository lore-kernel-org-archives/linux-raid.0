Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B43B277029
	for <linux-raid@vger.kernel.org>; Mon, 20 Apr 2026 05:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776662698; cv=pass; b=haRjwbJ0FaJlo3T5CpzhlhpZcxJdXgIlu8313NFRHn3Ehj2br4jGjKV4TBKhUTOknzJOqkSS9/J4T0KHKCH6lFAGsLvqOWMmCIwbz9lX+WaSzXHK2ESTzc1xL5acc8tDkUav8AC9x/4DtNbctkG80DKpgALbwXwqxz2bDkx1ly4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776662698; c=relaxed/simple;
	bh=CrRYWrUSyLRraAH250s0SmXrDb0Dmql3rcfXwrLDmkk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eW9WYrnwCIUZpzlLHv3mAtcVGBMOzbyJNwO1Hv/fzWxhz+2YTy32ZZUxNiNFk46dtTRWzEDUfTekRj6AIIEAond5E+M15d3KewMDNsgmgu56jX1ERS4zJAGkhVMal17NgJlp/thYCv65Fo/sR+Kiau9rJN+/9wiWGfmHHvXAXj0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fNDh7c20; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=dAHwllVZ; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fNDh7c20";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="dAHwllVZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776662696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5kBvEWQHgQk5b/PPn9NtKRt3ckhWNcUA3RcQcg8sFGo=;
	b=fNDh7c20bNRzcTvFsKMXGem2W+hXz+NRTSuiPY9fATpWzZCRRh9Gdt/F32XcELZNZdFuvh
	rCk8O1Ta3UlLq/UrHUyxeyZ00PxEgHTWxgsCooOxBNHGime2H+3HOoqWyhq3xqDaiC2zPQ
	pyNgHfZKWM7f5IVmrzN+s79Di6SvF5E=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-284-r9aEDYXQMQiAuC0s9PBP0Q-1; Mon, 20 Apr 2026 01:24:54 -0400
X-MC-Unique: r9aEDYXQMQiAuC0s9PBP0Q-1
X-Mimecast-MFC-AGG-ID: r9aEDYXQMQiAuC0s9PBP0Q_1776662693
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5a3ffc66760so1494956e87.3
        for <linux-raid@vger.kernel.org>; Sun, 19 Apr 2026 22:24:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776662693; cv=none;
        d=google.com; s=arc-20240605;
        b=FypL2ljMgO5DhudLu0m0jqrzRoND2sb4oIDcdIgpth34GO4533c5gSf+85SkkVpzVw
         Yr31WfEpXvsdhScXViWmt5yjpC5CYSJC/l4xapxVhibLIMd10Pl/qQ5UkcHrea+iZTIq
         h3rkEoldk3zr57kwEmKjaRsFG8Wd9OqC0/DwnAnHuoVld0IHu5+16Vrecx5HoMQdoYPN
         wnEuioOXfjwJJ2Zsex8mdW78G7akp4ao4HsP0enLSJdCm7fD0RprTw5Q8yMhpJ/IqcYA
         q0Xn+hhVrshq5D2K9YSInsQyWt68es+iHyK+qlUNsMzh8Cd4FI/7aVJOPgCCC+KVZdp2
         jTKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5kBvEWQHgQk5b/PPn9NtKRt3ckhWNcUA3RcQcg8sFGo=;
        fh=TWACGSidAuI7eL+hD1976w75hZ91sk4LU3yEBGmW8+c=;
        b=gXYkixXMCZ+m6XoV4wLsgaXOY/zWmdUf/bLdysT/Pt9/h2aXdwrluxSSIqyqIupj8Y
         LjBO6BjBKvfWiHkqQ5XDCvjKbxEhkK45+Zp1R5dj84e6c6eGxYXtiVv1IMbIxAjRDBg2
         LhQkmUX0eazJQV5COkjONOBsob83rB8H7/YMC5gioUTVicntVCOJYEk+pdrOaQcSZnia
         Xkq/LV5AmVk34qIjs9mjuLnCC5Kz6ovJFF/lExRNuAH0TjV8PoKpSbwmY/17SvY9Yi2q
         AU6FUkIOlX1007ctHHOBhoax2KQoBQnku5mXvJ7Qo97PXfZBy6pQWR1d628+d3FFqw59
         dhNw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776662693; x=1777267493; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5kBvEWQHgQk5b/PPn9NtKRt3ckhWNcUA3RcQcg8sFGo=;
        b=dAHwllVZdt1/u8+/TgbMSzyr2hXooCG7i50LENtok9sEFS5ceaIn7BtaTVSDqLU9yR
         yw0TO6RrFXAqkb/H/2fd+uLopKM2XFyUaMDxKdiOqL7vCMVArrJln1NzL/QJGdH/oEaN
         /uFGOojqq2cNPKhH28H/l0OVtDPMVdFCSstYy3fVMM2fkbjja+/61O3/btv9DFrI8Yjc
         dag0WJkT8/ikrz/sI33M3ztlmzOWlSMZWiYxSKKQ1XNvidrVX0TIoJTEZjNqrnNs6jmU
         QnztpTOV7PczLBls7tq0Vgm0s5Uk1bqCdP5XLfSpWSb3SgSJiIplu4OMP5DNnWy0kv4v
         KZRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776662693; x=1777267493;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5kBvEWQHgQk5b/PPn9NtKRt3ckhWNcUA3RcQcg8sFGo=;
        b=RocONrQ4BxtKSFdyNRTazLNJPjdPoqbP8Xk4WaqLejIH6GA622LiUQ3KRSDrcIbUZq
         dkVRUXbXgI8AW1YCuQ7HGbK8P75vuLs6Z18CQXANQ0/8Hsg4nRFNt59jz7BE9ZLJLvk3
         5T8oIJpY+nxZB0X5MKxEKqWPuHYGq0zwfA/TRxeAQgULJqBAY/GEWAJiqVVfW3m4GKqc
         F7WRKkR4ytsd4TyNjdVvPceXlM2fg5QO96kmV/8RVvEMdhm3neb+1TfS7vzaKaJWlz4T
         56X4Tx1IgWuI2/bc1hGChF4rfRAp8w/wvOmVRv8+KIY5jA2T8f6pJV6cuJ4B3D+9ma3r
         erqA==
X-Gm-Message-State: AOJu0YwimRtQqMlXn86weqzVrORnNoPGqDQXmbgtUhBFQgpcxn7vqvSX
	c1vQgACQWoy61BdD+RmicrshkF6IOu8RCQO8nrOe4FTSYtcLUT4WpuNWOgNi5RSt91ji5QZxB//
	MgkPhdePRmBLqtOmZ/wkuBKV1mcbU/ki3ogh6bimbv4yuKNMs2ZQ+zD8J5PZh9X2vKnmSLqlXcP
	VVgtYAzMfqMC7nzYglIRuyGmTWgEkI+7oD0z5NwQ==
X-Gm-Gg: AeBDietXweEwa4SjpyTYHkx8R+l1Bm5zleDu7HIXwJ73wJj5g4ahw/IjQagfd89Z6wb
	UBd+dOJUkOkPUy6ldRU/OMkK5lkMF9/V+l0B6MLDVCwziDp3EMH9XpSIn69xISly0+UqeOWYIJG
	wm7w9RjvEvu2/3C6IP+n4zKOXmpivJpY/bUUYr0HjvIJfy2XWTSY8A3cKxYKgTCFKork7O0eirJ
	mfEVXRH1XY1pOUtDTYeSr5MJrWewgiwBoqVWq+uDJqc0y7A6O18yN5RnlNfjL5LRkY5KUnN/WKg
	mmcvbR03A7BUM8Mt
X-Received: by 2002:a05:6512:8004:10b0:5a4:18f2:a25a with SMTP id 2adb3069b0e04-5a418f2a29bmr2400818e87.34.1776662692971;
        Sun, 19 Apr 2026 22:24:52 -0700 (PDT)
X-Received: by 2002:a05:6512:8004:10b0:5a4:18f2:a25a with SMTP id
 2adb3069b0e04-5a418f2a29bmr2400811e87.34.1776662692403; Sun, 19 Apr 2026
 22:24:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260407102625.5686-1-glass.su@suse.com> <20260407102625.5686-3-glass.su@suse.com>
In-Reply-To: <20260407102625.5686-3-glass.su@suse.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 20 Apr 2026 13:24:40 +0800
X-Gm-Features: AQROBzBKugvqW7WMiKXjPCo7_9_vxSaykK_UdZ6dzzbYyifZiuZLEkQ-0g9W4oY
Message-ID: <CALTww2-fv32n_PqEi502=O8AKAdr6dh9+docPaMniXB6nCrKjQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] md/md-bitmap: add an extra sysfs argument to
 md_bitmap_create and destroy
To: Su Yue <glass.su@suse.com>
Cc: linux-raid@vger.kernel.org, song@kernel.org, linan122@huawei.com, 
	yukuai@fnnas.com, heming.zhao@suse.com, l@damenly.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 7, 2026 at 6:26=E2=80=AFPM Su Yue <glass.su@suse.com> wrote:
>
> For further use, no functional change.
>
> Signed-off-by: Su Yue <glass.su@suse.com>
> ---
>  drivers/md/md-bitmap.c |  6 +++---
>  drivers/md/md.c        | 36 ++++++++++++++++++------------------
>  drivers/md/md.h        |  4 ++--
>  3 files changed, 23 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 2f24aae05552..ac06c9647bf0 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -2618,7 +2618,7 @@ location_store(struct mddev *mddev, const char *buf=
, size_t len)
>                         goto out;
>                 }
>
> -               md_bitmap_destroy(mddev);
> +               md_bitmap_destroy(mddev, true);
>                 mddev->bitmap_info.offset =3D 0;
>                 if (mddev->bitmap_info.file) {
>                         struct file *f =3D mddev->bitmap_info.file;
> @@ -2659,14 +2659,14 @@ location_store(struct mddev *mddev, const char *b=
uf, size_t len)
>                          */
>                         mddev->bitmap_id =3D ID_BITMAP;
>                         mddev->bitmap_info.offset =3D offset;
> -                       rv =3D md_bitmap_create(mddev);
> +                       rv =3D md_bitmap_create(mddev, true);
>                         if (rv)
>                                 goto out;
>
>                         rv =3D bitmap_load(mddev);
>                         if (rv) {
>                                 mddev->bitmap_info.offset =3D 0;
> -                               md_bitmap_destroy(mddev);
> +                               md_bitmap_destroy(mddev, true);
>                                 goto out;
>                         }
>                 }
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 8b1ecc370ad6..d3c8f77b4fe3 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -678,7 +678,7 @@ static void active_io_release(struct percpu_ref *ref)
>
>  static void no_op(struct percpu_ref *r) {}
>
> -static bool mddev_set_bitmap_ops(struct mddev *mddev)
> +static bool mddev_set_bitmap_ops(struct mddev *mddev, bool create_sysfs)
>  {
>         struct bitmap_operations *old =3D mddev->bitmap_ops;
>         struct md_submodule_head *head;
> @@ -703,7 +703,7 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev)
>         mddev->bitmap_ops =3D (void *)head;
>         xa_unlock(&md_submodule);
>
> -       if (!mddev_is_dm(mddev) && mddev->bitmap_ops->group) {
> +       if (create_sysfs && !mddev_is_dm(mddev) && mddev->bitmap_ops->gro=
up) {
>                 if (sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->g=
roup))
>                         pr_warn("md: cannot register extra bitmap attribu=
tes for %s\n",
>                                 mdname(mddev));
> @@ -721,9 +721,9 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev)
>         return false;
>  }
>
> -static void mddev_clear_bitmap_ops(struct mddev *mddev)
> +static void mddev_clear_bitmap_ops(struct mddev *mddev, bool remove_sysf=
s)
>  {
> -       if (!mddev_is_dm(mddev) && mddev->bitmap_ops &&
> +       if (remove_sysfs && !mddev_is_dm(mddev) && mddev->bitmap_ops &&
>             mddev->bitmap_ops->group)
>                 sysfs_remove_group(&mddev->kobj, mddev->bitmap_ops->group=
);
>
> @@ -6447,24 +6447,24 @@ static void md_safemode_timeout(struct timer_list=
 *t)
>
>  static int start_dirty_degraded;
>
> -int md_bitmap_create(struct mddev *mddev)
> +int md_bitmap_create(struct mddev *mddev, bool create_sysfs)
>  {
>         if (mddev->bitmap_id =3D=3D ID_BITMAP_NONE)
>                 return -EINVAL;
>
> -       if (!mddev_set_bitmap_ops(mddev))
> +       if (!mddev_set_bitmap_ops(mddev, create_sysfs))
>                 return -ENOENT;
>
>         return mddev->bitmap_ops->create(mddev);
>  }
>
> -void md_bitmap_destroy(struct mddev *mddev)
> +void md_bitmap_destroy(struct mddev *mddev, bool remove_sysfs)
>  {
>         if (!md_bitmap_registered(mddev))
>                 return;
>
>         mddev->bitmap_ops->destroy(mddev);
> -       mddev_clear_bitmap_ops(mddev);
> +       mddev_clear_bitmap_ops(mddev, remove_sysfs);
>  }
>
>  int md_run(struct mddev *mddev)
> @@ -6612,7 +6612,7 @@ int md_run(struct mddev *mddev)
>         }
>         if (err =3D=3D 0 && pers->sync_request &&
>             (mddev->bitmap_info.file || mddev->bitmap_info.offset)) {
> -               err =3D md_bitmap_create(mddev);
> +               err =3D md_bitmap_create(mddev, true);
>                 if (err)
>                         pr_warn("%s: failed to create bitmap (%d)\n",
>                                 mdname(mddev), err);
> @@ -6685,7 +6685,7 @@ int md_run(struct mddev *mddev)
>                 pers->free(mddev, mddev->private);
>         mddev->private =3D NULL;
>         put_pers(pers);
> -       md_bitmap_destroy(mddev);
> +       md_bitmap_destroy(mddev, true);
>         return err;
>  }
>  EXPORT_SYMBOL_GPL(md_run);
> @@ -6702,7 +6702,7 @@ int do_md_run(struct mddev *mddev)
>         if (md_bitmap_registered(mddev)) {
>                 err =3D mddev->bitmap_ops->load(mddev);
>                 if (err) {
> -                       md_bitmap_destroy(mddev);
> +                       md_bitmap_destroy(mddev, true);
>                         goto out;
>                 }
>         }
> @@ -6903,7 +6903,7 @@ static void __md_stop(struct mddev *mddev)
>  {
>         struct md_personality *pers =3D mddev->pers;
>
> -       md_bitmap_destroy(mddev);
> +       md_bitmap_destroy(mddev, true);
>         mddev_detach(mddev);
>         spin_lock(&mddev->lock);
>         mddev->pers =3D NULL;
> @@ -7680,16 +7680,16 @@ static int set_bitmap_file(struct mddev *mddev, i=
nt fd)
>         err =3D 0;
>         if (mddev->pers) {
>                 if (fd >=3D 0) {
> -                       err =3D md_bitmap_create(mddev);
> +                       err =3D md_bitmap_create(mddev, true);
>                         if (!err)
>                                 err =3D mddev->bitmap_ops->load(mddev);
>
>                         if (err) {
> -                               md_bitmap_destroy(mddev);
> +                               md_bitmap_destroy(mddev, true);
>                                 fd =3D -1;
>                         }
>                 } else if (fd < 0) {
> -                       md_bitmap_destroy(mddev);
> +                       md_bitmap_destroy(mddev, true);
>                 }
>         }
>
> @@ -7996,12 +7996,12 @@ static int update_array_info(struct mddev *mddev,=
 mdu_array_info_t *info)
>                                 mddev->bitmap_info.default_offset;
>                         mddev->bitmap_info.space =3D
>                                 mddev->bitmap_info.default_space;
> -                       rv =3D md_bitmap_create(mddev);
> +                       rv =3D md_bitmap_create(mddev, true);
>                         if (!rv)
>                                 rv =3D mddev->bitmap_ops->load(mddev);
>
>                         if (rv)
> -                               md_bitmap_destroy(mddev);
> +                               md_bitmap_destroy(mddev, true);
>                 } else {
>                         struct md_bitmap_stats stats;
>
> @@ -8027,7 +8027,7 @@ static int update_array_info(struct mddev *mddev, m=
du_array_info_t *info)
>                                 put_cluster_ops(mddev);
>                                 mddev->safemode_delay =3D DEFAULT_SAFEMOD=
E_DELAY;
>                         }
> -                       md_bitmap_destroy(mddev);
> +                       md_bitmap_destroy(mddev, true);
>                         mddev->bitmap_info.offset =3D 0;
>                 }
>         }
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index ed69244af00d..4aaba3d7015c 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -895,8 +895,8 @@ static inline void safe_put_page(struct page *p)
>
>  int register_md_submodule(struct md_submodule_head *msh);
>  void unregister_md_submodule(struct md_submodule_head *msh);
> -int md_bitmap_create(struct mddev *mddev);
> -void md_bitmap_destroy(struct mddev *mddev);
> +int md_bitmap_create(struct mddev *mddev, bool create_sysfs);
> +void md_bitmap_destroy(struct mddev *mddev, bool remove_sysfs);
>
>  extern struct md_thread *md_register_thread(
>         void (*run)(struct md_thread *thread),
> --
> 2.53.0
>

Looks good to me.
Reviewed-by: Xiao Ni <xni@redhat.com>

