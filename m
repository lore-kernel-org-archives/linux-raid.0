Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8093721FF49
	for <linux-raid@vger.kernel.org>; Tue,  4 Nov 2025 01:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762219240; cv=none; b=EbDFUXLUEKFFe56waA3+6HNe6XRONXjpXfg10niYusfwA+I6/kTMjBjoRNf0647eDKCPrf104r1/3+bSTqtvmXI66WSphueeWYswKWQyUJ+6kAv+1yJvWFQcyDpuuahEZmx+sMJBMMCIvjscYJeSVTu5y1qWMFSIul9jv2eUzfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762219240; c=relaxed/simple;
	bh=vZcU89Ph5WIK8NyzZLUb0r6Ws0ZWMI/lMTt5x0ogLNU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oHqJ0gNWWYpCh9jXaslEscAXiHvq1bmHkCalvA2nkDALfC4U3wVTAoZXlNiQbe48C6xUePxbn50CPpOxOhSfkUYSfJUQLJbS/1r1iL2Q+zCohbe4hx8qK65enXLkeglfkniz8N9qYduU146yU0u1hizHIVYzdSzCMwqbQwetQBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hFTxf9HX; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=uHaSs35H; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hFTxf9HX";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="uHaSs35H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762219237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3OTR7o7jSbm67rMr3BXh2xHsTn33Hf1+NbHtVmrcseM=;
	b=hFTxf9HX2+97ehD4K+it47yZ7xqqnhdaYqDXO0/UjFYv0F89bYgC2ufmiaJb24vPrbPgXg
	LyvNbFHnXGqmcC2b8OQiGXgnZSKLWMz8ed77H78xPkrKVY377Br0KEJ4a3YFf3ACKduqKy
	AuLIfRz1/xpvUODkSYH3LF2ozEdVvZ0=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-17-KBEG37dRPmCX8X2Jd-zZnQ-1; Mon, 03 Nov 2025 20:20:35 -0500
X-MC-Unique: KBEG37dRPmCX8X2Jd-zZnQ-1
X-Mimecast-MFC-AGG-ID: KBEG37dRPmCX8X2Jd-zZnQ_1762219234
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-57893a7d7b6so3551597e87.1
        for <linux-raid@vger.kernel.org>; Mon, 03 Nov 2025 17:20:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762219234; x=1762824034; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3OTR7o7jSbm67rMr3BXh2xHsTn33Hf1+NbHtVmrcseM=;
        b=uHaSs35HdTIYKZ7RCXQf8OL6ULEzFX8cLV8Bq4ritmz7nimOwZs2//nPcqsqUrst8E
         /7nMbYvLHdUhxRP5lUQQU/hK1o9x5Sc5sg9xHhSfKM/MJ2+Xh/JFFxaE8oaJtkvya3tX
         f8k+TT84Mq+pp0m9cdTvcca5a5/gdI4mdAaS/FTgfd7BufC8rmBedC/y36INE4PZ/HC6
         8Wpi8+WSYdZTWmbMxsMJq/jg75ZLpOQDiC0+Czw/MssFzYnjPswrbSxx1qToeM0kmIEZ
         XaGnfjgEh6RKEbgulhT69wuVes1FR1ft7WETbNawTbgeKAcL5O89Eoqz7xYIk89vMfwp
         J12w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762219234; x=1762824034;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3OTR7o7jSbm67rMr3BXh2xHsTn33Hf1+NbHtVmrcseM=;
        b=ZipPB7hFUYCvWkL4BvRxZds1qhDiDHDKHQhjVC+I7Qa2TbzV+WDjabGFcZ9b/z1iBi
         K/AhrT5p/eXCNlyQOViTvwjtW1hZy80VpxOivyp2EQ8Nf2cPyqbuePFyvMkVzvyCkqwY
         +NYFbXYiEwsuCkdQ1hUGiIePeuoA7IilEgxrDj+7vWr2Xl0Lx3LE8EKTxIe5MNeB4qnl
         2IACAgvaTNtTLIcZG8deZu+3xL5eMgI19miQ5zO2BnqelGrD2KbigZAr7Yho9qLXzhwo
         oeuciiYUXmEXbiT32tJP9zBhoe6te20QsuIMkOCSKp6vU1ZqtsXSgzQNGli3vTRetpGw
         QHTw==
X-Forwarded-Encrypted: i=1; AJvYcCVCpsBuCRry4/rukDF4Ev1WAtsalTvoBX4rZ9VLHW7P++SjqOnbjoVg0u+ZKTR5DXRohTVy9g46TJxZ@vger.kernel.org
X-Gm-Message-State: AOJu0YxLBfioNOwpZyqdDCYehElzqio0gc33LYtffomXnbbolZgn93yw
	b+IbwyUrLaebsR8R0BFPe2Zz6PtN5TXQPg59BnPhn6S/BB+8yBTkB3MCsGe2d9l/6+71gblWAt0
	EXeNxhjUYnQ9a+1uUBL7Oi/r1C/aJQLr2uaOAZiAnv0awECMtaD+i5AmrIgHeLjEBoI4JEqhHhN
	4n8QOxF9eHhjbFw11QfG1bahfajfpeqI8JQHx+eQ==
X-Gm-Gg: ASbGncvx4PqcMEGugPSYeLQSIFfS/TDs/d+l2Bd3N2KVpq43YU2GWcLt0GQnWB+BLNv
	hhmcmqyoSqdL3sOife3NeCGRKT/C6yx0HjYEYX1lAk2/MY14RwaoebQDnaSdi+xdqpW6+mGb929
	AYkas7+Tkx5uFjgNBbgiN2lVcDTx1zE38MU55/mX9OQDdPnrCNYh4Ga7mb
X-Received: by 2002:a05:6512:2314:b0:594:3156:da0d with SMTP id 2adb3069b0e04-5943156db98mr1126442e87.6.1762219234151;
        Mon, 03 Nov 2025 17:20:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHuJS+UzXHbigkvy+eJqRqZRZj4eq3d1z8K4UdzuIoCbnv0QfVRbluuM2fW5A1LVvy7COtp2d11vgRT/GQ1E8M=
X-Received: by 2002:a05:6512:2314:b0:594:3156:da0d with SMTP id
 2adb3069b0e04-5943156db98mr1126427e87.6.1762219233666; Mon, 03 Nov 2025
 17:20:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251030062807.1515356-1-linan666@huaweicloud.com>
 <20251030062807.1515356-3-linan666@huaweicloud.com> <CALTww28LKk6bH4tuEA4DD3uAJScCVAQUBn0d0JYu3AvVjxetzQ@mail.gmail.com>
 <2d4c41f5-6886-98a3-8ccc-54d8a4f89fdc@huaweicloud.com>
In-Reply-To: <2d4c41f5-6886-98a3-8ccc-54d8a4f89fdc@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 4 Nov 2025 09:20:20 +0800
X-Gm-Features: AWmQ_bmoDbL70RpPOZvKWQChSZ16xeJk2e7Nxc-XAa16gWeRwp7u6QWv7LJYnKs
Message-ID: <CALTww2-gZr9UqFgPnv-sAZNQsJYxEmabjKvdu2Jn_02+Z=LEkg@mail.gmail.com>
Subject: Re: [PATCH v8 2/4] md: init bioset in mddev_init
To: Li Nan <linan666@huaweicloud.com>
Cc: corbet@lwn.net, song@kernel.org, yukuai@fnnas.com, hare@suse.de, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 3, 2025 at 8:32=E2=80=AFPM Li Nan <linan666@huaweicloud.com> wr=
ote:
>
>
>
> =E5=9C=A8 2025/11/3 9:23, Xiao Ni =E5=86=99=E9=81=93:
> > On Thu, Oct 30, 2025 at 2:36=E2=80=AFPM <linan666@huaweicloud.com> wrot=
e:
> >>
> >> From: Li Nan <linan122@huawei.com>
> >>
> >> IO operations may be needed before md_run(), such as updating metadata
> >> after writing sysfs. Without bioset, this triggers a NULL pointer
> >> dereference as below:
> >>
> >>   BUG: kernel NULL pointer dereference, address: 0000000000000020
> >>   Call Trace:
> >>    md_update_sb+0x658/0xe00
> >>    new_level_store+0xc5/0x120
> >>    md_attr_store+0xc9/0x1e0
> >>    sysfs_kf_write+0x6f/0xa0
> >>    kernfs_fop_write_iter+0x141/0x2a0
> >>    vfs_write+0x1fc/0x5a0
> >>    ksys_write+0x79/0x180
> >>    __x64_sys_write+0x1d/0x30
> >>    x64_sys_call+0x2818/0x2880
> >>    do_syscall_64+0xa9/0x580
> >>    entry_SYSCALL_64_after_hwframe+0x4b/0x53
> >>
> >> Reproducer
> >> ```
> >>    mdadm -CR /dev/md0 -l1 -n2 /dev/sd[cd]
> >>    echo inactive > /sys/block/md0/md/array_state
> >>    echo 10 > /sys/block/md0/md/new_level
> >> ```
> >>
> >
> > Hi Li Nan
> >
> >> mddev_init() can only be called once per mddev, no need to test if bio=
set
> >> has been initialized anymore.
> >
> > The patch looks good to me. But I don't understand the message here.
> > This patch changes the alloc/free bioset positions. What's the meaning
> > of "no need to test if bioset has been initialized anymore"?
> >
> > Regards
> > Xiao
>
> Hi Xiao
>
> Thanks for your review.
>
> Sorry for causing any misunderstanding.
> Old code:
> -       if (!bioset_initialized(&mddev->bio_set)) {
> -               err =3D bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0, BI=
OSET_NEED_BVECS);
>
> New code:
> +       err =3D bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0, BIOSET_NEE=
D_BVECS);
>
> bioset_initialized() is removed. Can I describe it as:
>    mddev_init() can only be called once per mddev, thus bioset_initialize=
d()
> can be removed.

I c, thanks very much for the explanation. The description is good to me.

Thanks
Xiao
>
> >>
> >> Fixes: d981ed841930 ("md: Add new_level sysfs interface")
> >> Signed-off-by: Li Nan <linan122@huawei.com>
> >> ---
> >>   drivers/md/md.c | 69 +++++++++++++++++++++++------------------------=
--
> >>   1 file changed, 33 insertions(+), 36 deletions(-)
> >>
> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> index f6fd55a1637b..dffc6a482181 100644
> >> --- a/drivers/md/md.c
> >> +++ b/drivers/md/md.c
> >> @@ -730,6 +730,8 @@ static void mddev_clear_bitmap_ops(struct mddev *m=
ddev)
> >>
> >>   int mddev_init(struct mddev *mddev)
> >>   {
> >> +       int err =3D 0;
> >> +
> >>          if (!IS_ENABLED(CONFIG_MD_BITMAP))
> >>                  mddev->bitmap_id =3D ID_BITMAP_NONE;
> >>          else
> >> @@ -741,10 +743,23 @@ int mddev_init(struct mddev *mddev)
> >>
> >>          if (percpu_ref_init(&mddev->writes_pending, no_op,
> >>                              PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
> >> -               percpu_ref_exit(&mddev->active_io);
> >> -               return -ENOMEM;
> >> +               err =3D -ENOMEM;
> >> +               goto exit_acitve_io;
> >>          }
> >>
> >> +       err =3D bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0, BIOSET_=
NEED_BVECS);
> >> +       if (err)
> >> +               goto exit_writes_pending;
> >> +
> >> +       err =3D bioset_init(&mddev->sync_set, BIO_POOL_SIZE, 0, BIOSET=
_NEED_BVECS);
> >> +       if (err)
> >> +               goto exit_bio_set;
> >> +
> >> +       err =3D bioset_init(&mddev->io_clone_set, BIO_POOL_SIZE,
> >> +                         offsetof(struct md_io_clone, bio_clone), 0);
> >> +       if (err)
> >> +               goto exit_sync_set;
> >> +
> >>          /* We want to start with the refcount at zero */
> >>          percpu_ref_put(&mddev->writes_pending);
> >>
> >> @@ -773,11 +788,24 @@ int mddev_init(struct mddev *mddev)
> >>          INIT_WORK(&mddev->del_work, mddev_delayed_delete);
> >>
> >>          return 0;
> >> +
> >> +exit_sync_set:
> >> +       bioset_exit(&mddev->sync_set);
> >> +exit_bio_set:
> >> +       bioset_exit(&mddev->bio_set);
> >> +exit_writes_pending:
> >> +       percpu_ref_exit(&mddev->writes_pending);
> >> +exit_acitve_io:
> >> +       percpu_ref_exit(&mddev->active_io);
> >> +       return err;
> >>   }
> >>   EXPORT_SYMBOL_GPL(mddev_init);
> >>
> >>   void mddev_destroy(struct mddev *mddev)
> >>   {
> >> +       bioset_exit(&mddev->bio_set);
> >> +       bioset_exit(&mddev->sync_set);
> >> +       bioset_exit(&mddev->io_clone_set);
> >>          percpu_ref_exit(&mddev->active_io);
> >>          percpu_ref_exit(&mddev->writes_pending);
> >>   }
> >> @@ -6393,29 +6421,9 @@ int md_run(struct mddev *mddev)
> >>                  nowait =3D nowait && bdev_nowait(rdev->bdev);
> >>          }
> >>
> >> -       if (!bioset_initialized(&mddev->bio_set)) {
> >> -               err =3D bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0,=
 BIOSET_NEED_BVECS);
> >> -               if (err)
> >> -                       return err;
> >> -       }
> >> -       if (!bioset_initialized(&mddev->sync_set)) {
> >> -               err =3D bioset_init(&mddev->sync_set, BIO_POOL_SIZE, 0=
, BIOSET_NEED_BVECS);
> >> -               if (err)
> >> -                       goto exit_bio_set;
> >> -       }
> >> -
> >> -       if (!bioset_initialized(&mddev->io_clone_set)) {
> >> -               err =3D bioset_init(&mddev->io_clone_set, BIO_POOL_SIZ=
E,
> >> -                                 offsetof(struct md_io_clone, bio_clo=
ne), 0);
> >> -               if (err)
> >> -                       goto exit_sync_set;
> >> -       }
> >> -
> >>          pers =3D get_pers(mddev->level, mddev->clevel);
> >> -       if (!pers) {
> >> -               err =3D -EINVAL;
> >> -               goto abort;
> >> -       }
> >> +       if (!pers)
> >> +               return -EINVAL;
> >>          if (mddev->level !=3D pers->head.id) {
> >>                  mddev->level =3D pers->head.id;
> >>                  mddev->new_level =3D pers->head.id;
> >> @@ -6426,8 +6434,7 @@ int md_run(struct mddev *mddev)
> >>              pers->start_reshape =3D=3D NULL) {
> >>                  /* This personality cannot handle reshaping... */
> >>                  put_pers(pers);
> >> -               err =3D -EINVAL;
> >> -               goto abort;
> >> +               return -EINVAL;
> >>          }
> >>
> >>          if (pers->sync_request) {
> >> @@ -6554,12 +6561,6 @@ int md_run(struct mddev *mddev)
> >>          mddev->private =3D NULL;
> >>          put_pers(pers);
> >>          md_bitmap_destroy(mddev);
> >> -abort:
> >> -       bioset_exit(&mddev->io_clone_set);
> >> -exit_sync_set:
> >> -       bioset_exit(&mddev->sync_set);
> >> -exit_bio_set:
> >> -       bioset_exit(&mddev->bio_set);
> >>          return err;
> >>   }
> >>   EXPORT_SYMBOL_GPL(md_run);
> >> @@ -6784,10 +6785,6 @@ static void __md_stop(struct mddev *mddev)
> >>          mddev->private =3D NULL;
> >>          put_pers(pers);
> >>          clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> >> -
> >> -       bioset_exit(&mddev->bio_set);
> >> -       bioset_exit(&mddev->sync_set);
> >> -       bioset_exit(&mddev->io_clone_set);
> >>   }
> >>
> >>   void md_stop(struct mddev *mddev)
> >> --
> >> 2.39.2
> >>
> >
> >
> > .
>
> --
> Thanks,
> Nan
>

