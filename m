Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 643D9EE0213
	for <linux-raid@archiver.kernel.org>; Thu, 14 Sep 2023 02:54:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233965AbjINCyo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 13 Sep 2023 22:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbjINCyo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 13 Sep 2023 22:54:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C1A7210C3
        for <linux-raid@vger.kernel.org>; Wed, 13 Sep 2023 19:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694660036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=79Pt1h07snqQgLqURn+X2LUbFiUGOvFlgIEpyAPEPwA=;
        b=TiVnzM0Ml+VqBvvEhlxU/LJw0Hf36xnxBwEFSjWEr77l7yUOUGYOFVkN41vYW2hObPBuNU
        LzlwivuhxKEBS8Tm0t/qYRIfrBbYoMDn+vWbL9HJpjQPKDSiaXDitd/NX4R/QT2qr0VTG6
        koN2OV8P7oc7AGeQyQSES786nr9+VRY=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-50-6T0zVK_pPB6olS5MR-QOGg-1; Wed, 13 Sep 2023 22:53:55 -0400
X-MC-Unique: 6T0zVK_pPB6olS5MR-QOGg-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-26b752bc74fso412788a91.2
        for <linux-raid@vger.kernel.org>; Wed, 13 Sep 2023 19:53:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694660034; x=1695264834;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=79Pt1h07snqQgLqURn+X2LUbFiUGOvFlgIEpyAPEPwA=;
        b=kiGyrdiTOgB/+txXBkRoXcX+XWcVw/NXqYkqxNHrJcsAKLv0/GOgWm9Y0FoKRk4L3d
         0rM+OaDAU/5OetT6ErSUyZbG98jA7tTwJu3lPp1Trlc9be6BTjY5qrUnHyva0JZCt6ho
         exXtRKH5NdvuYymOHbKmV2nQFAjEma99g9Uyz0ueRxW7NxokyNjwVgMrax0Y3+FSKIGo
         xtfkbS6cpxP6ifpc08J/enMZoBVZMie8pnBUkzEkDALM5HKw7aTs57rgFf0KR6uyYntv
         dDd4FVctGzZyF8YOsBn8fSWe8pZdTm8PAl6bN/2WvM2zXErJYv4BxAw6//8ZaPMmDLv9
         UQmg==
X-Gm-Message-State: AOJu0Ywy2xTgwuK7yL0Q1auCQvIlApyYYJcvb8szq/7nthMNaFKRFvuk
        Mu4rF0bFCTej5dm2w2+cCWgABnSmU64fTFUoz5eSTLiMhcfEXUgBR39GsctCK9IVStgFjdP8am1
        uEcwJyN73zvTljfQeL1nUPyyZf7KcTkHtkrFqXg==
X-Received: by 2002:a17:90b:e91:b0:268:f987:305d with SMTP id fv17-20020a17090b0e9100b00268f987305dmr4020240pjb.5.1694660034365;
        Wed, 13 Sep 2023 19:53:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHi2VFjCUSN7OBpxQVIme3+SE2HYZ6exMH5klV6ao7jQvDUKQlgbnRiJ1efcAAWy6Z8PoxjrXE7/8b1wykrEIQ=
X-Received: by 2002:a17:90b:e91:b0:268:f987:305d with SMTP id
 fv17-20020a17090b0e9100b00268f987305dmr4020231pjb.5.1694660034080; Wed, 13
 Sep 2023 19:53:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230828020021.2489641-1-yukuai1@huaweicloud.com> <20230828020021.2489641-2-yukuai1@huaweicloud.com>
In-Reply-To: <20230828020021.2489641-2-yukuai1@huaweicloud.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Thu, 14 Sep 2023 10:53:41 +0800
Message-ID: <CALTww28MiiWTOyLYHErAZWTzn8iGif5=adY7yohxmn1OxrpK=w@mail.gmail.com>
Subject: Re: [PATCH -next v2 01/28] md: use READ_ONCE/WRITE_ONCE for
 'suspend_lo' and 'suspend_hi'
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
> Because reading 'suspend_lo' and 'suspend_hi' from md_handle_request()
> is not protected, use READ_ONCE/WRITE_ONCE to prevent reading abnormal
> value.

Hi Kuai

If we don't use READ_ONCE/WRITE_ONCE, What's the risk here? Could you
explain in detail or give an example?

Regards
Xiao
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 46badd13a687..9d8dff9d923c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -359,11 +359,11 @@ static bool is_suspended(struct mddev *mddev, struc=
t bio *bio)
>                 return true;
>         if (bio_data_dir(bio) !=3D WRITE)
>                 return false;
> -       if (mddev->suspend_lo >=3D mddev->suspend_hi)
> +       if (READ_ONCE(mddev->suspend_lo) >=3D READ_ONCE(mddev->suspend_hi=
))
>                 return false;
> -       if (bio->bi_iter.bi_sector >=3D mddev->suspend_hi)
> +       if (bio->bi_iter.bi_sector >=3D READ_ONCE(mddev->suspend_hi))
>                 return false;
> -       if (bio_end_sector(bio) < mddev->suspend_lo)
> +       if (bio_end_sector(bio) < READ_ONCE(mddev->suspend_lo))
>                 return false;
>         return true;
>  }
> @@ -5171,7 +5171,8 @@ __ATTR(sync_max, S_IRUGO|S_IWUSR, max_sync_show, ma=
x_sync_store);
>  static ssize_t
>  suspend_lo_show(struct mddev *mddev, char *page)
>  {
> -       return sprintf(page, "%llu\n", (unsigned long long)mddev->suspend=
_lo);
> +       return sprintf(page, "%llu\n",
> +                      (unsigned long long)READ_ONCE(mddev->suspend_lo));
>  }
>
>  static ssize_t
> @@ -5191,7 +5192,7 @@ suspend_lo_store(struct mddev *mddev, const char *b=
uf, size_t len)
>                 return err;
>
>         mddev_suspend(mddev);
> -       mddev->suspend_lo =3D new;
> +       WRITE_ONCE(mddev->suspend_lo, new);
>         mddev_resume(mddev);
>
>         mddev_unlock(mddev);
> @@ -5203,7 +5204,8 @@ __ATTR(suspend_lo, S_IRUGO|S_IWUSR, suspend_lo_show=
, suspend_lo_store);
>  static ssize_t
>  suspend_hi_show(struct mddev *mddev, char *page)
>  {
> -       return sprintf(page, "%llu\n", (unsigned long long)mddev->suspend=
_hi);
> +       return sprintf(page, "%llu\n",
> +                      (unsigned long long)READ_ONCE(mddev->suspend_hi));
>  }
>
>  static ssize_t
> @@ -5223,7 +5225,7 @@ suspend_hi_store(struct mddev *mddev, const char *b=
uf, size_t len)
>                 return err;
>
>         mddev_suspend(mddev);
> -       mddev->suspend_hi =3D new;
> +       WRITE_ONCE(mddev->suspend_hi, new);
>         mddev_resume(mddev);
>
>         mddev_unlock(mddev);
> --
> 2.39.2
>

