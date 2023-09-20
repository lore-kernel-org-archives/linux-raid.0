Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D934CE79AC
	for <linux-raid@archiver.kernel.org>; Wed, 20 Sep 2023 08:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233727AbjITIrp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Sep 2023 04:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233638AbjITIro (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 20 Sep 2023 04:47:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC7793
        for <linux-raid@vger.kernel.org>; Wed, 20 Sep 2023 01:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695199617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=14VM4X1q7LDh2tjcesU2z1sSQLPjnF+BKTQYi/I+DZ8=;
        b=G6uRULRGqVre8n3L2DIPph3qXsnAcMBgsdEwaKHK6ptKCsYMBRGCVagEfj2yExeSvbFFQX
        Uqw383BcjvOF+e7rvr2vOKcgc6TuJNavoQ86OSOTV+WMrnKeRYh8PyVPG5suLVgjvjKNZI
        fLqVXpU44MD1i1PHs8DQOjUpFecfzgg=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-187-t-vI5JojPkCkoyAH4LG7qw-1; Wed, 20 Sep 2023 04:46:56 -0400
X-MC-Unique: t-vI5JojPkCkoyAH4LG7qw-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-68fab681787so5721050b3a.3
        for <linux-raid@vger.kernel.org>; Wed, 20 Sep 2023 01:46:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695199615; x=1695804415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=14VM4X1q7LDh2tjcesU2z1sSQLPjnF+BKTQYi/I+DZ8=;
        b=uf78RpKzAi2BD8QW8Y+dwLN8p3xbP0MxDiF4E4wgSa93t+4Q6pyn6IcePebnS0cqTU
         9eIXYLzZggdKrYSRbO82dDuuYx0PxC2ReO90as71GuUMS25V5CJyRcuHFplLMtVKDxlS
         TTabGBxBwRwRVy7cjdmISCQoPgvmQBVMJpWUTdwbV3+jLhbQyWYwJIWbsvZlfyhj2Uia
         Xlj2wdPyeF5hj33tj/8paa3UNde/o0tqfnLwKzANPxpUTa/noAvJzbymkGHBlg8qgFFY
         YskxzRPdOOBbLe0xjXNtzPb/49AyMhi7idEZWjZHeaNWmKOakH7Odqwl3C3fSJzxIIut
         nhvQ==
X-Gm-Message-State: AOJu0YzWaXKVghZDoLGdmTfhKAEqaiG+qBSGTzoJsaTxodjWUbNL6gYR
        VB3T9g4ZzyHUVaZnu000J6Yz/zw95DQGu3X46RWBkoUmwIOFQaVTqq1AwUOYPE8KayeT5GSxKZ3
        d2cmE8TBblReUuY7VGKyV/w4/GK8TYK9rDT+Lmw==
X-Received: by 2002:a05:6a20:7f9d:b0:13d:df16:cf29 with SMTP id d29-20020a056a207f9d00b0013ddf16cf29mr2570687pzj.15.1695199614997;
        Wed, 20 Sep 2023 01:46:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQli6HeenG+HwcwmKNeEDbJ29I1E4luWIpovCpMd3Ahw3uOsfer9qoclzc94KX8UwaBMSafHxbTeav+Z1H7aY=
X-Received: by 2002:a05:6a20:7f9d:b0:13d:df16:cf29 with SMTP id
 d29-20020a056a207f9d00b0013ddf16cf29mr2570673pzj.15.1695199614768; Wed, 20
 Sep 2023 01:46:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230828020021.2489641-1-yukuai1@huaweicloud.com> <20230828020021.2489641-3-yukuai1@huaweicloud.com>
In-Reply-To: <20230828020021.2489641-3-yukuai1@huaweicloud.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Wed, 20 Sep 2023 16:46:42 +0800
Message-ID: <CALTww29iHX_GHogGFEfzdaDjohBr8ycfiz2=E_ru4JYvmrTYdA@mail.gmail.com>
Subject: Re: [PATCH -next v2 02/28] md: use 'mddev->suspended' for is_md_suspended()
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com,
        song@kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, yukuai3@huawei.com,
        yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Aug 28, 2023 at 10:04=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> =
wrote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> 'pers->prepare_suspend' is introduced to prevent a deadlock for raid456,
> this change prepares to clean this up in later patches while refactoring
> mddev_suspend(). Specifically allow reshape to make progress while
> waiting for 'active_io' to be 0.

Hi Kuai

From my side, I can't understand the comments. The change has
relationship with pers->prepare_suspend? And why this change can
affect reshape? If this change indeed can affect these two things, can
you explain more?

>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md.c | 2 +-
>  drivers/md/md.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 9d8dff9d923c..7fa311a14317 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -355,7 +355,7 @@ static DEFINE_SPINLOCK(all_mddevs_lock);
>   */
>  static bool is_suspended(struct mddev *mddev, struct bio *bio)
>  {
> -       if (is_md_suspended(mddev))
> +       if (is_md_suspended(mddev) || percpu_ref_is_dying(&mddev->active_=
io))

If we use mddev->suspended to judge if the raid is suspended, it
should be enough? Because mddev->suspended must be true when active_io
is dying.

Best Regards
Xiao
>                 return true;
>         if (bio_data_dir(bio) !=3D WRITE)
>                 return false;
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index b628c292506e..fb3b123f16dd 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -584,7 +584,7 @@ static inline bool md_is_rdwr(struct mddev *mddev)
>
>  static inline bool is_md_suspended(struct mddev *mddev)
>  {
> -       return percpu_ref_is_dying(&mddev->active_io);
> +       return READ_ONCE(mddev->suspended);
>  }
>
>  static inline int __must_check mddev_lock(struct mddev *mddev)
> --
> 2.39.2
>

