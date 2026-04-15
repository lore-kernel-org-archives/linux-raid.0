Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1CD273D8F
	for <linux-raid@vger.kernel.org>; Wed, 15 Apr 2026 10:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776249311; cv=pass; b=pvIXDAsOCx9IhVsBQo1RmBIPZaMHACzjwieyz3Qm41+b8K0ZdZ/UiYYCVFWf3fTVwgos2VzLmttgifyUPE6bsj6O/VtJUIG59MTNIkoD9XTy2Y/tgxKntuPbnHRrLaEqfsb2oh/IdGzzlc1Q68bEOz5LtQK/Q0kFTKj0RGSgmHY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776249311; c=relaxed/simple;
	bh=dxHrnzghkvTVoyRk9DIvS4R387kzM/m3L1wORUYvbi0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qYE4y5EIXzPGtFk2W7IQ3xjJA+zWo0+9HBGGuHeLUz8XUoq09SLBfm9HUP7pxcQTPnHj2k/an5IxnsUyaE20GexSRkq5tXNzzSFuIvi0FfWvJRNqyLPMZ7DQs5EQ3SWj0Rkw34NtO8ZhINoebso/gZBMBEC/derTlSXb+tkckJM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AM2C6kJS; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=SbxBAmWt; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AM2C6kJS";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="SbxBAmWt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776249308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cm2pf7De6zHEnM2RR5NpdN+rat5/WXiTVV9iej5lJQ4=;
	b=AM2C6kJSvNqvsBpdo+3sS6vZ6oPAuydt23to6bkE/dAniaH4RDknFyoDo6sIYHrAslbAqX
	qg2KbO1qa4aj+BetfSljsx9XXwk4yKtg615sYSboJN7RBHbDAWTPYA697r7C+n/NONlHIk
	zP0kajLiX/cCegffW/DFDTO/EjSEdNg=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-323-3zjJv41FMSmhr_lSP58mlw-1; Wed, 15 Apr 2026 06:35:07 -0400
X-MC-Unique: 3zjJv41FMSmhr_lSP58mlw-1
X-Mimecast-MFC-AGG-ID: 3zjJv41FMSmhr_lSP58mlw_1776249306
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5a2c0da6fc1so4580747e87.1
        for <linux-raid@vger.kernel.org>; Wed, 15 Apr 2026 03:35:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776249305; cv=none;
        d=google.com; s=arc-20240605;
        b=YAZve7mGQiIpbrjYuAt1WjlFOEylAelHA0MKWEkJu8kE7gepOF44pla0twiBqPL3Yy
         J1gEFrPVJUsDD/sGg6Ef9lm/W8jYcwjZOw7//i5gJT2xpr3hzpsh/4MvVeWV0Hn85brT
         XKc0OPd0qzP94tAUgKYazoxy4E4HaBWDirmIrVbD8U01sUf+G60rV77hQMphET9xP4A6
         mGhFJy6nMcOTnnyRHGh3ETRGUyR8AbbLQpVI7Yy2LpbXupxOU7CRbuR0+AObwXLqYxMy
         hRkt/sUFl1OTBI16AhROLz0r7FInO582hpp+tqEjxH4eyTOT5OpBGR4QesNCeobmGFHk
         kALg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Cm2pf7De6zHEnM2RR5NpdN+rat5/WXiTVV9iej5lJQ4=;
        fh=TWACGSidAuI7eL+hD1976w75hZ91sk4LU3yEBGmW8+c=;
        b=MJxoT7KAxXE9nShJ5AHHRhYqriu2Lgpd4mslOEzxHXHWV/Gc6xoS/g/9bgwS1rBPGq
         233neG+lcjjXt/8mXoJe1YRyN19GgucKuf5+82wB/0au5I/C5ivjIaThV31cEgKxPQQH
         jz91GcV5rkb3OXT535m9SJfFEHi9NE1zZHj/ru/Ls1muB7WH2BoYAQRi1bGylixEW2nB
         RBeSw+x651TTiK2aohdSJlhPKRqL7BeZcMo7GzZoEye94njtYOCQ/kKyanB7w65VuGC/
         VIwS04EglRI2ey/xeg4K5l72OMZr0HkV3saL0kfAbXkz1vHIX1Grr1c0R9pmODK/Ug7V
         aLRw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776249305; x=1776854105; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cm2pf7De6zHEnM2RR5NpdN+rat5/WXiTVV9iej5lJQ4=;
        b=SbxBAmWtLtB247HQIZefPJlpWpiX+7Az3ueY5jBB9Hlq4nxXOZ97GQomfJGVgoFw8L
         VcP12DISGjmhZARR5qw4tyLUTi43GZ+JX9c3xcMAYkAH44DKO7No/h2nQKOzmBgilHh5
         C8WVxaw+i06XwbyBpYXD9Ysw1MgkCBrMjYCba2uB25FdNrPS8LF4kiE/6Ju3cMDKRI6c
         DGeviYmJ5GGwuBF/4Ewo1MKVzDLOexetgx6WYIfl3TT0aex3hjvugOF7x+rkpnPLCkT3
         mzPHKjFnC4zoEK/TqTyRQWFDhFQqbXyAGwGHmNmGTbUvWRcmXDmJCrSWV7mAEsCYO4HG
         BxSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776249305; x=1776854105;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Cm2pf7De6zHEnM2RR5NpdN+rat5/WXiTVV9iej5lJQ4=;
        b=fQl8WDcvXR3LJWLZGXS0dj9yRtB7fKN/3YxFCWEw9hMj8KLKquaheUAwAdJ5duOmI9
         Jf/gxvFLt31Z/oHX7u8Cva5kFYcWznHIojXe6/xuFYY4n6qCNAhnJTqsDxihh1R4Q4k8
         Wq+cGLpm2MdXaxcebg32tCAce+wwUfRgqpuTesSVYppl7zhrmRoFQxMLg1fKi+TxaWp9
         2KQR07HJlUlefAW8oWAg6k8biV4HT8sY5ComjLxyhWgVtejO2+Xx5IyflCQCnQIVK7wI
         Bk7DQGjkIREQg6AXurZoRNIoQC65/mFiv58Cf11Qf0MKf1aCR3zLKuiqo9AuMJRsHoEi
         159g==
X-Gm-Message-State: AOJu0YxHM87YTWgoBFUvm+FnrIYQPhUQ/l6/wpZJDHmCR2/OBne79v3L
	NOvnUTQBiB45SOfcHpYgSfuKv9awHfTwlNnPFYLlBPGAdpTzQmUdCpp96JN54KQZLDtfRi8S675
	hD/0Pl3CtIhU873wOLbaJ94cd77T5xLz6dFyNMf51q2y/fe2lBLC9qBSEmG81tRy8t7isTBGmVq
	hXlj2dv5h0Q8w+/LWrgrLXr0YWA1DG1N67hilmkA==
X-Gm-Gg: AeBDiev2zCyEJbRndJ0v9x2ARgN8UypBVMV2PjFy/RYymCluEVGE/OoSoR2Uad8KQvv
	EHocWeBNXJ4jaXMNoRLMV9btkon4VgOQHHikSFRPUuqFpu9y9wBUQ17XCwF2CbspXU+IZvi0EIf
	JjwmezcGUT8s+SgkYDWxkBTxNR5V0pgrFUACt2DOTyHYTio4yUf20iGDn55ERMaJvsb0Rq2IOjq
	UN9YRqeqLlE2Bhz/B6TBQOqbJ31x4XEB7l4TTj8xcTs3US6h8u2Ib1UBeBqQrQFIqh9YLH8ZH4z
	6F8phA==
X-Received: by 2002:a05:6512:3b0a:b0:5a4:505:f63c with SMTP id 2adb3069b0e04-5a40505f7f7mr1934198e87.11.1776249305369;
        Wed, 15 Apr 2026 03:35:05 -0700 (PDT)
X-Received: by 2002:a05:6512:3b0a:b0:5a4:505:f63c with SMTP id
 2adb3069b0e04-5a40505f7f7mr1934185e87.11.1776249304750; Wed, 15 Apr 2026
 03:35:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260407102625.5686-1-glass.su@suse.com> <20260407102625.5686-2-glass.su@suse.com>
In-Reply-To: <20260407102625.5686-2-glass.su@suse.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 15 Apr 2026 18:34:53 +0800
X-Gm-Features: AQROBzA-nOrJmQPzijbZQJzSZnWl9JkxRHdEkTEULUo2b0GugivduXR743lfQL8
Message-ID: <CALTww28wN=9R2RMApc89M=cRtHmrFYgc8qgakR6LwcyXeQNdDw@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] md/md-bitmap: call md_bitmap_create,destroy in location_store
To: Su Yue <glass.su@suse.com>
Cc: linux-raid@vger.kernel.org, song@kernel.org, linan122@huawei.com, 
	yukuai@fnnas.com, heming.zhao@suse.com, l@damenly.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 7, 2026 at 6:26=E2=80=AFPM Su Yue <glass.su@suse.com> wrote:
>
> If bitmap/location is present, mdadm will call update_array_info()
> while growing bitmap from none to internal via location_store().
> md_bitmap_create() is needed to set mddev->bitmap_ops otherwise
> mddev->bitmap_ops->get_stats() in update_array_info() will trigger
> kernel NULL pointer dereference.


Hi Su Yue

How can bitmap/location be present when bitmap is none? Could you
provide the test commands that reproduce this problem?

mdadm -CR /dev/md0 -l1 -n2 /dev/loop0 /dev/loop1 --bitmap=3Dnone (There
is not bitmap/location, because bitmap directory is not created)
mdadm /dev/md0 --grow --bitmap=3Dinternal
Grow.c md_set_array_info runs
 451             array.state |=3D (1 << MD_SB_BITMAP_PRESENT);
 452             rv =3D md_set_array_info(fd, &array);
In kernel space, it runs
 8125             rv =3D md_bitmap_create(mddev);
 8126             if (!rv)
 8127                 rv =3D mddev->bitmap_ops->load(mddev);

Best Regards
Xiao

>
> Fixes: fb8cc3b0d9db ("md/md-bitmap: delay registration of bitmap_ops unti=
l creating bitmap")
> Signed-off-by: Su Yue <glass.su@suse.com>
> ---
>  drivers/md/md-bitmap.c | 11 ++++++++---
>  drivers/md/md.c        |  4 ++--
>  drivers/md/md.h        |  2 ++
>  3 files changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 83378c033c72..2f24aae05552 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -2618,7 +2618,7 @@ location_store(struct mddev *mddev, const char *buf=
, size_t len)
>                         goto out;
>                 }
>
> -               bitmap_destroy(mddev);
> +               md_bitmap_destroy(mddev);
>                 mddev->bitmap_info.offset =3D 0;
>                 if (mddev->bitmap_info.file) {
>                         struct file *f =3D mddev->bitmap_info.file;
> @@ -2653,15 +2653,20 @@ location_store(struct mddev *mddev, const char *b=
uf, size_t len)
>                                 goto out;
>                         }
>
> +                       /*
> +                        * lockless bitmap shoudle have set bitmap_id
> +                        * using bitmap_type, so always ID_BITMAP.
> +                        */
> +                       mddev->bitmap_id =3D ID_BITMAP;
>                         mddev->bitmap_info.offset =3D offset;
> -                       rv =3D bitmap_create(mddev);
> +                       rv =3D md_bitmap_create(mddev);
>                         if (rv)
>                                 goto out;
>
>                         rv =3D bitmap_load(mddev);
>                         if (rv) {
>                                 mddev->bitmap_info.offset =3D 0;
> -                               bitmap_destroy(mddev);
> +                               md_bitmap_destroy(mddev);
>                                 goto out;
>                         }
>                 }
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 3ce6f9e9d38e..8b1ecc370ad6 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6447,7 +6447,7 @@ static void md_safemode_timeout(struct timer_list *=
t)
>
>  static int start_dirty_degraded;
>
> -static int md_bitmap_create(struct mddev *mddev)
> +int md_bitmap_create(struct mddev *mddev)
>  {
>         if (mddev->bitmap_id =3D=3D ID_BITMAP_NONE)
>                 return -EINVAL;
> @@ -6458,7 +6458,7 @@ static int md_bitmap_create(struct mddev *mddev)
>         return mddev->bitmap_ops->create(mddev);
>  }
>
> -static void md_bitmap_destroy(struct mddev *mddev)
> +void md_bitmap_destroy(struct mddev *mddev)
>  {
>         if (!md_bitmap_registered(mddev))
>                 return;
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index ac84289664cd..ed69244af00d 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -895,6 +895,8 @@ static inline void safe_put_page(struct page *p)
>
>  int register_md_submodule(struct md_submodule_head *msh);
>  void unregister_md_submodule(struct md_submodule_head *msh);
> +int md_bitmap_create(struct mddev *mddev);
> +void md_bitmap_destroy(struct mddev *mddev);
>
>  extern struct md_thread *md_register_thread(
>         void (*run)(struct md_thread *thread),
> --
> 2.53.0
>

