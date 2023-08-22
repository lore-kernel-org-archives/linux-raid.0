Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FAD4EE4996
	for <linux-raid@archiver.kernel.org>; Tue, 22 Aug 2023 10:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234590AbjHVKFL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 22 Aug 2023 06:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234579AbjHVKFK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 22 Aug 2023 06:05:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17AD5CE4
        for <linux-raid@vger.kernel.org>; Tue, 22 Aug 2023 03:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692698658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eunSjqXebVmPJQFHfHymAQbG2gyuuDWNReWk5LCjmQE=;
        b=h2YwcOb+cQTT98aAN5XZ14o2ztTVP0UYCyen3odfj5UFMefpfmdYpyec+eVqLSO9euGsVB
        MuMM4PIAcheB27WMOqfEQhGrQfFlsmDbL0s/ynVn7w4dTlCwk+cgqDaI1jcEaEqyigwqbS
        SvNdWU1aaulx/enj7tyBfWZqoDuIPa0=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-477-IuIEt99BM_-Qx48MRBkRCQ-1; Tue, 22 Aug 2023 06:04:14 -0400
X-MC-Unique: IuIEt99BM_-Qx48MRBkRCQ-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-26cf9b8f209so4505880a91.0
        for <linux-raid@vger.kernel.org>; Tue, 22 Aug 2023 03:04:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692698654; x=1693303454;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eunSjqXebVmPJQFHfHymAQbG2gyuuDWNReWk5LCjmQE=;
        b=MN9PUCKeBA1R2KZDl1k3wUwWH7EeDPrTNsUDk3CmvU9KcBgVz2HPNyG8ndFscxY/ad
         nxoQQBAI88qHmsM2RMMRkrFGfmBhGkLIztQDLqtLECHro9hLx/ES0a6HKFY0BDo9gahN
         YTmHiR1ng+fp+lxCv3ZWWXF39j7c76+RsuhSb24hfTO2kgP3ScNic4IchxzAo3tu0wfY
         Jf7yVRSajoxo08q7D6rPKV8L14xeTS9/vIGHzW8C8fsZ1I00h+9ZfzvxPsrrxb4WU51f
         ld/R4gbAPqs+sa84UJ902b58LyajzKFdST3v32bLnu84eTNsMNbrjBxT9OWG/ICZa0nH
         6fRA==
X-Gm-Message-State: AOJu0YyQRit7UHxRUvyBBrz/OMsz5gCUVzaYdcmBwJd4m5BdLgT4z8jr
        qrkuWS636bUPcyjFLEDjZe2BXd7dqN+XpM3QIKSQ2mfMbT8r/Ag5FtG9dveXjtaGbJjUk3Ftm98
        o9M0LRcc7eJRxR+B40WRUm9snOfXZmh0MTyB9Nw==
X-Received: by 2002:a17:90a:8681:b0:267:fba3:ed96 with SMTP id p1-20020a17090a868100b00267fba3ed96mr5698305pjn.3.1692698653958;
        Tue, 22 Aug 2023 03:04:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQAyUGLu26v0m9FhbT8nXHCmebwasow1EknDEE9+bi+15V6BUlty4S6j9T52Z0FdgUC5Ho6Jjv+/2I19wxkQc=
X-Received: by 2002:a17:90a:8681:b0:267:fba3:ed96 with SMTP id
 p1-20020a17090a868100b00267fba3ed96mr5698287pjn.3.1692698653590; Tue, 22 Aug
 2023 03:04:13 -0700 (PDT)
MIME-Version: 1.0
References: <20230820090949.2874537-1-yukuai1@huaweicloud.com> <20230820090949.2874537-2-yukuai1@huaweicloud.com>
In-Reply-To: <20230820090949.2874537-2-yukuai1@huaweicloud.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Tue, 22 Aug 2023 18:04:02 +0800
Message-ID: <CALTww2_XL7j_OMjNMNdCti8TyOxC_U69v6Dg1UXHfajaWeN4Cg@mail.gmail.com>
Subject: Re: [PATCH -next v3 1/7] md: use separate work_struct for md_start_sync()
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     song@kernel.org, mariusz.tkaczyk@linux.intel.com,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, Aug 20, 2023 at 5:13=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> It's a little weird to borrow 'del_work' for md_start_sync(), declare
> a new work_struct 'sync_work' for md_start_sync().
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md.c | 10 ++++++----
>  drivers/md/md.h |  5 ++++-
>  2 files changed, 10 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 5c3c19b8d509..90815be1e80f 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -631,13 +631,13 @@ void mddev_put(struct mddev *mddev)
>                  * flush_workqueue() after mddev_find will succeed in wai=
ting
>                  * for the work to be done.
>                  */
> -               INIT_WORK(&mddev->del_work, mddev_delayed_delete);
>                 queue_work(md_misc_wq, &mddev->del_work);
>         }
>         spin_unlock(&all_mddevs_lock);
>  }
>
>  static void md_safemode_timeout(struct timer_list *t);
> +static void md_start_sync(struct work_struct *ws);
>
>  void mddev_init(struct mddev *mddev)
>  {
> @@ -662,6 +662,9 @@ void mddev_init(struct mddev *mddev)
>         mddev->resync_min =3D 0;
>         mddev->resync_max =3D MaxSector;
>         mddev->level =3D LEVEL_NONE;
> +
> +       INIT_WORK(&mddev->sync_work, md_start_sync);
> +       INIT_WORK(&mddev->del_work, mddev_delayed_delete);
>  }
>  EXPORT_SYMBOL_GPL(mddev_init);
>
> @@ -9245,7 +9248,7 @@ static int remove_and_add_spares(struct mddev *mdde=
v,
>
>  static void md_start_sync(struct work_struct *ws)
>  {
> -       struct mddev *mddev =3D container_of(ws, struct mddev, del_work);
> +       struct mddev *mddev =3D container_of(ws, struct mddev, sync_work)=
;
>
>         rcu_assign_pointer(mddev->sync_thread,
>                            md_register_thread(md_do_sync, mddev, "resync"=
));
> @@ -9458,8 +9461,7 @@ void md_check_recovery(struct mddev *mddev)
>                                  */
>                                 md_bitmap_write_all(mddev->bitmap);
>                         }
> -                       INIT_WORK(&mddev->del_work, md_start_sync);
> -                       queue_work(md_misc_wq, &mddev->del_work);
> +                       queue_work(md_misc_wq, &mddev->sync_work);
>                         goto unlock;
>                 }
>         not_running:
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 9bcb77bca963..64d05cb65287 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -450,7 +450,10 @@ struct mddev {
>         struct kernfs_node              *sysfs_degraded;        /*handle =
for 'degraded' */
>         struct kernfs_node              *sysfs_level;           /*handle =
for 'level' */
>
> -       struct work_struct del_work;    /* used for delayed sysfs removal=
 */
> +       /* used for delayed sysfs removal */
> +       struct work_struct del_work;
> +       /* used for register new sync thread */
> +       struct work_struct sync_work;
>
>         /* "lock" protects:
>          *   flush_bio transition from NULL to !NULL
> --
> 2.39.2
>

Reviewed-by: Xiao Ni <xni@redhat.com>

