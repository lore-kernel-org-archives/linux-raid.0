Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2088E21D3E8
	for <linux-raid@vger.kernel.org>; Mon,  3 Nov 2025 01:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762133031; cv=none; b=TmmMBU5lyS8FBscTlt0tTQgHpMyyd3WwELGuSC+n8FD0eZQl3KXgCL32mV1zwqZ+4Z/XARDceZzqLy5F0kfokvaIwIG6wceCx7FjcXSRupQsSen0EMlZAu52sNWOa1gy15RqkIxjXHV8CYvf/gOk3xvK3IVAIX1Hlw0m1lGa8i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762133031; c=relaxed/simple;
	bh=Th7XVJ2Qjh7tHojN1+7TKRuwCS9QFJmGLp++xxYFcn8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S3qraotoNBiW5oK4iUUovSwzHCWgiSY9qKFDKw+5aOsWfTg7797vCBroz1uNNa3xWjCTQSQlMz5uJVtxj3dMAEGt/mssRnadlzwJStIG7jpCs0hDpYAuiGt2Y8N2KZEwSxFI5bFtLrMvDroTRgcHOb6w9kcJA2L9WEmJlxh4bNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UHWxN+zg; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=nba5I9U/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UHWxN+zg";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="nba5I9U/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762133027;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pYva0xFFyJLEsXT9lXPl/qxqgmGOEqN3BS7K6bAdCAg=;
	b=UHWxN+zgcfO9rVrrDAAL10qcCMRfASC/UZah+IqN/5kOr87BGaXiaJn7HCjmuSjY4C32dK
	1v6jBKxFRwAvIaiTig3RstAN4AD3LAJcn+khFlovslqzwfEgllweN/boAR8C7bmIuABdeL
	uB+PjgWRwGmFN6y6ifvHWq5DW5DFyxU=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-FF8COoXvOgyji7iTIs2wTQ-1; Sun, 02 Nov 2025 20:23:45 -0500
X-MC-Unique: FF8COoXvOgyji7iTIs2wTQ-1
X-Mimecast-MFC-AGG-ID: FF8COoXvOgyji7iTIs2wTQ_1762133024
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-373a467d39fso45256491fa.0
        for <linux-raid@vger.kernel.org>; Sun, 02 Nov 2025 17:23:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762133024; x=1762737824; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pYva0xFFyJLEsXT9lXPl/qxqgmGOEqN3BS7K6bAdCAg=;
        b=nba5I9U/+0jdGNBCAjdrsyM7kVTkOToSZ0UD6cEYhchO3kULUswlLrtQylSwDGRRK4
         Hcg+WYS7WH0ugb4v5hfspI0tCgXPREWHP+ETWlBdG6tpFiT+SIX6vwxW7KprgAyVHUmh
         7Ry7NeA598bnR2nStgCzj+IGsC/OtlwH6JJCfPKQEErLYzy+yI4KR6PE6EX5uPeVFUjk
         ZTDR4a5H1ktY4QwJITvYhik+g6kGmcW38t3kuHGyTZ+gOVKwamyjhDR5+s04x2RCJHaK
         oWXNKQLpTmiqfWTt6GDcDN7rU9N1dq8m+BTgq9zmfUmkBE1oh31xi1TOVOUtgSbUkctT
         E2FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762133024; x=1762737824;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pYva0xFFyJLEsXT9lXPl/qxqgmGOEqN3BS7K6bAdCAg=;
        b=kn11LYd0fgK5ZF45tqGcB71JppiIuSFHy3QOkRDVFYtYsT5Bft0EocQMVySgFiSogQ
         C/V0UTGrr1pBe2YrJ7rckup9QD5P1jjoEm8kaGelpcfbBZ3Mgv0M7vdEzJzQalpjiZn8
         p8LfgtHkuoYGTWIFBY8GC7IEcEi/MVXd0Jg5U5g9m6pFSFY1KEBQaLV4GIusUZWvmfDn
         yGee5J8grBc+oFzvLdp8b13FUj1hqLG2dUj08ZKFpL8oeIgxAW9TvvCm1JwjcyV6mrQB
         6RUOv4x/hWopS9Uk+w47R7A90vddCd3WEaz5wnEfcWS/L3GkCx6M5azizCde0n/4p/ot
         spGw==
X-Forwarded-Encrypted: i=1; AJvYcCXTmj60vwRK6QVdgY7jP48n+WPcYJKX2GTk7VO9ek/ciVCAtym6ioyJ2mO7+rkoO8QkHCkXpkO2cOhS@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1FwaE+k3Q2XE0nFU2Y8aWBgjNgMWraecnU1NfIfgs3SeeC5yL
	gnU09I2A14vxAixedMQdYpWA4aiYTB8/TGKdNb4ZBLMByrlBjUazTlD+XTeD9hKtfPNHiWzzc18
	2lYWLs43vyJFZbeJcjYsVEbJjOD9QFeT0qE4ZoJA+y7vJDfu5tgON/ncv/r41nyD1SeZyjki+ZS
	zq6NUX1743Gy16Y13z29j2A2LbyDltMbicOTMa8A==
X-Gm-Gg: ASbGncvscYtvUYmL4/1MFH7LVyXMhr5ihpyy6G7G/Qm1GykHFl5Va+SPoTaLZKzH7E4
	NJeH5MU8jtZUy4N6xUxLSfq27jaI0IXZccsb6ujoG7xiFnAT/6rOfTMEXiyMF6hwVvBuvYjDYa0
	/FqRBD4J26KpPG62UOM+VRvQPOgzHtP1V4fWx9WbmHuul9EUWuAlDwheo=
X-Received: by 2002:a05:651c:1a0b:b0:37a:35b5:eeff with SMTP id 38308e7fff4ca-37a35b5f4e8mr9053291fa.23.1762133024209;
        Sun, 02 Nov 2025 17:23:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEPZjEcv11bmRaJCDAnmYXuMgNRnwjz6cfmoHuFiJi+XsYtjqJAhf0XNetfuNdgKQJceKQZfs7+G/MVZRQ6lIk=
X-Received: by 2002:a05:651c:1a0b:b0:37a:35b5:eeff with SMTP id
 38308e7fff4ca-37a35b5f4e8mr9053131fa.23.1762133023644; Sun, 02 Nov 2025
 17:23:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251030062807.1515356-1-linan666@huaweicloud.com> <20251030062807.1515356-3-linan666@huaweicloud.com>
In-Reply-To: <20251030062807.1515356-3-linan666@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 3 Nov 2025 09:23:32 +0800
X-Gm-Features: AWmQ_bnLnCJThdvlzNsn8q3UkhsqL9YQdiBUJHrrHMNwH6kq0-4nzcxackYnp1A
Message-ID: <CALTww28LKk6bH4tuEA4DD3uAJScCVAQUBn0d0JYu3AvVjxetzQ@mail.gmail.com>
Subject: Re: [PATCH v8 2/4] md: init bioset in mddev_init
To: linan666@huaweicloud.com
Cc: corbet@lwn.net, song@kernel.org, yukuai@fnnas.com, linan122@huawei.com, 
	hare@suse.de, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2025 at 2:36=E2=80=AFPM <linan666@huaweicloud.com> wrote:
>
> From: Li Nan <linan122@huawei.com>
>
> IO operations may be needed before md_run(), such as updating metadata
> after writing sysfs. Without bioset, this triggers a NULL pointer
> dereference as below:
>
>  BUG: kernel NULL pointer dereference, address: 0000000000000020
>  Call Trace:
>   md_update_sb+0x658/0xe00
>   new_level_store+0xc5/0x120
>   md_attr_store+0xc9/0x1e0
>   sysfs_kf_write+0x6f/0xa0
>   kernfs_fop_write_iter+0x141/0x2a0
>   vfs_write+0x1fc/0x5a0
>   ksys_write+0x79/0x180
>   __x64_sys_write+0x1d/0x30
>   x64_sys_call+0x2818/0x2880
>   do_syscall_64+0xa9/0x580
>   entry_SYSCALL_64_after_hwframe+0x4b/0x53
>
> Reproducer
> ```
>   mdadm -CR /dev/md0 -l1 -n2 /dev/sd[cd]
>   echo inactive > /sys/block/md0/md/array_state
>   echo 10 > /sys/block/md0/md/new_level
> ```
>

Hi Li Nan

> mddev_init() can only be called once per mddev, no need to test if bioset
> has been initialized anymore.

The patch looks good to me. But I don't understand the message here.
This patch changes the alloc/free bioset positions. What's the meaning
of "no need to test if bioset has been initialized anymore"?

Regards
Xiao
>
> Fixes: d981ed841930 ("md: Add new_level sysfs interface")
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>  drivers/md/md.c | 69 +++++++++++++++++++++++--------------------------
>  1 file changed, 33 insertions(+), 36 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index f6fd55a1637b..dffc6a482181 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -730,6 +730,8 @@ static void mddev_clear_bitmap_ops(struct mddev *mdde=
v)
>
>  int mddev_init(struct mddev *mddev)
>  {
> +       int err =3D 0;
> +
>         if (!IS_ENABLED(CONFIG_MD_BITMAP))
>                 mddev->bitmap_id =3D ID_BITMAP_NONE;
>         else
> @@ -741,10 +743,23 @@ int mddev_init(struct mddev *mddev)
>
>         if (percpu_ref_init(&mddev->writes_pending, no_op,
>                             PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
> -               percpu_ref_exit(&mddev->active_io);
> -               return -ENOMEM;
> +               err =3D -ENOMEM;
> +               goto exit_acitve_io;
>         }
>
> +       err =3D bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0, BIOSET_NEE=
D_BVECS);
> +       if (err)
> +               goto exit_writes_pending;
> +
> +       err =3D bioset_init(&mddev->sync_set, BIO_POOL_SIZE, 0, BIOSET_NE=
ED_BVECS);
> +       if (err)
> +               goto exit_bio_set;
> +
> +       err =3D bioset_init(&mddev->io_clone_set, BIO_POOL_SIZE,
> +                         offsetof(struct md_io_clone, bio_clone), 0);
> +       if (err)
> +               goto exit_sync_set;
> +
>         /* We want to start with the refcount at zero */
>         percpu_ref_put(&mddev->writes_pending);
>
> @@ -773,11 +788,24 @@ int mddev_init(struct mddev *mddev)
>         INIT_WORK(&mddev->del_work, mddev_delayed_delete);
>
>         return 0;
> +
> +exit_sync_set:
> +       bioset_exit(&mddev->sync_set);
> +exit_bio_set:
> +       bioset_exit(&mddev->bio_set);
> +exit_writes_pending:
> +       percpu_ref_exit(&mddev->writes_pending);
> +exit_acitve_io:
> +       percpu_ref_exit(&mddev->active_io);
> +       return err;
>  }
>  EXPORT_SYMBOL_GPL(mddev_init);
>
>  void mddev_destroy(struct mddev *mddev)
>  {
> +       bioset_exit(&mddev->bio_set);
> +       bioset_exit(&mddev->sync_set);
> +       bioset_exit(&mddev->io_clone_set);
>         percpu_ref_exit(&mddev->active_io);
>         percpu_ref_exit(&mddev->writes_pending);
>  }
> @@ -6393,29 +6421,9 @@ int md_run(struct mddev *mddev)
>                 nowait =3D nowait && bdev_nowait(rdev->bdev);
>         }
>
> -       if (!bioset_initialized(&mddev->bio_set)) {
> -               err =3D bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0, BI=
OSET_NEED_BVECS);
> -               if (err)
> -                       return err;
> -       }
> -       if (!bioset_initialized(&mddev->sync_set)) {
> -               err =3D bioset_init(&mddev->sync_set, BIO_POOL_SIZE, 0, B=
IOSET_NEED_BVECS);
> -               if (err)
> -                       goto exit_bio_set;
> -       }
> -
> -       if (!bioset_initialized(&mddev->io_clone_set)) {
> -               err =3D bioset_init(&mddev->io_clone_set, BIO_POOL_SIZE,
> -                                 offsetof(struct md_io_clone, bio_clone)=
, 0);
> -               if (err)
> -                       goto exit_sync_set;
> -       }
> -
>         pers =3D get_pers(mddev->level, mddev->clevel);
> -       if (!pers) {
> -               err =3D -EINVAL;
> -               goto abort;
> -       }
> +       if (!pers)
> +               return -EINVAL;
>         if (mddev->level !=3D pers->head.id) {
>                 mddev->level =3D pers->head.id;
>                 mddev->new_level =3D pers->head.id;
> @@ -6426,8 +6434,7 @@ int md_run(struct mddev *mddev)
>             pers->start_reshape =3D=3D NULL) {
>                 /* This personality cannot handle reshaping... */
>                 put_pers(pers);
> -               err =3D -EINVAL;
> -               goto abort;
> +               return -EINVAL;
>         }
>
>         if (pers->sync_request) {
> @@ -6554,12 +6561,6 @@ int md_run(struct mddev *mddev)
>         mddev->private =3D NULL;
>         put_pers(pers);
>         md_bitmap_destroy(mddev);
> -abort:
> -       bioset_exit(&mddev->io_clone_set);
> -exit_sync_set:
> -       bioset_exit(&mddev->sync_set);
> -exit_bio_set:
> -       bioset_exit(&mddev->bio_set);
>         return err;
>  }
>  EXPORT_SYMBOL_GPL(md_run);
> @@ -6784,10 +6785,6 @@ static void __md_stop(struct mddev *mddev)
>         mddev->private =3D NULL;
>         put_pers(pers);
>         clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> -
> -       bioset_exit(&mddev->bio_set);
> -       bioset_exit(&mddev->sync_set);
> -       bioset_exit(&mddev->io_clone_set);
>  }
>
>  void md_stop(struct mddev *mddev)
> --
> 2.39.2
>

