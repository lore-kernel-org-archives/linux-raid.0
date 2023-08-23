Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0578DEE49A5
	for <linux-raid@archiver.kernel.org>; Wed, 23 Aug 2023 02:21:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbjHWCVu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 22 Aug 2023 22:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232212AbjHWCVr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 22 Aug 2023 22:21:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE2CCF8
        for <linux-raid@vger.kernel.org>; Tue, 22 Aug 2023 19:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692757260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6Wd+9HuqUCEfQdvgPE3ApyuJjNlq3+0oy7KtDrGhF4c=;
        b=RdA8CmYZboYxW09IPwva9Yzm+vAMPkKVI5zNjIngQpMffhjAOYfB7zqrZ2BiAnpPQOJcV5
        bKsCDBc6cxiMIxpgrGq8KTrRuJBQTKo8SER5L0FfCcH3WJruYEeK52OX/q+0+5lz/RSzM8
        +0aeOm4R+sKIv5+xdzJV+qMBP7zzlS8=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-HkGat0-eNM6VJrmGTPgEQQ-1; Tue, 22 Aug 2023 22:20:59 -0400
X-MC-Unique: HkGat0-eNM6VJrmGTPgEQQ-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-68a43131e50so4351687b3a.1
        for <linux-raid@vger.kernel.org>; Tue, 22 Aug 2023 19:20:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692757258; x=1693362058;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6Wd+9HuqUCEfQdvgPE3ApyuJjNlq3+0oy7KtDrGhF4c=;
        b=UWAeM/mYnszLh2dru32kvdzxb8nXuJu3DZS5fd8EP74jw8I8LQuvr8pgrTy05A7c+2
         4ONxkkzVqTRexCMLYVldkHtr5ubmfUsEM8vXMrga1IuqErW/Hup3x3zzxl7b0p4bBWRY
         oSsoCRsHd3fD2jE/1mKMX5h75zjJ3NgmEbj9+vIhTVsAqUuXB4+l3pnESnBR7PhFeBeF
         o60E1BmffBFIbEcRvX8/TEnm7heN5UguTjd9alPp18fxzSt5s2BMTHbIPOVOHvtmSCSd
         NHLGxYj3WE8iITFOm/5LNQEd/pmuknLJ/Oln/Nq7JpUCyMJc/up/yLZl6LE/zw+zUSdm
         YASw==
X-Gm-Message-State: AOJu0YzX4+it0uHTXTknotyk4cDkwCCFODL4U5W3n4W8MaeaXEJgsdQq
        pq2h8VQB3ATFLCzVMtGaCH9pwzGdc7owbZOwwNd6+/+Pl+RLnN+cTfvYFMwsXQAdkZa+vVL584R
        8xs4xUYv6hmhH66E2ICGLUU7Sg0UTeclwYUDi4Q==
X-Received: by 2002:a05:6a00:1885:b0:68a:49bc:e091 with SMTP id x5-20020a056a00188500b0068a49bce091mr9363395pfh.2.1692757258210;
        Tue, 22 Aug 2023 19:20:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHF++hi+KyxP6UcT9dWWf/hS/LuaZrmo41F7h8KjG/JktBPtOw7zdl2zwJHAFzQr/fLjbf4F9bjFQae0JSBTQ8=
X-Received: by 2002:a05:6a00:1885:b0:68a:49bc:e091 with SMTP id
 x5-20020a056a00188500b0068a49bce091mr9363379pfh.2.1692757257914; Tue, 22 Aug
 2023 19:20:57 -0700 (PDT)
MIME-Version: 1.0
References: <20230820090949.2874537-1-yukuai1@huaweicloud.com> <20230820090949.2874537-6-yukuai1@huaweicloud.com>
In-Reply-To: <20230820090949.2874537-6-yukuai1@huaweicloud.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Wed, 23 Aug 2023 10:20:46 +0800
Message-ID: <CALTww28fa_LUVfzswTmpascZEYr-PdyjgoU88A+H9Q7CP04VXA@mail.gmail.com>
Subject: Re: [PATCH -next v3 5/7] md: factor out a helper rdev_is_spare() from remove_and_add_spares()
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
> There are no functional changes, just to make the code simpler and
> prepare to delay remove_and_add_spares() to md_start_sync().
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ceace5ffadd6..11d27c934fdd 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9169,6 +9169,14 @@ static bool rdev_removeable(struct md_rdev *rdev)
>         return true;
>  }
>
> +static bool rdev_is_spare(struct md_rdev *rdev)
> +{
> +       return !test_bit(Candidate, &rdev->flags) && rdev->raid_disk >=3D=
 0 &&
> +              !test_bit(In_sync, &rdev->flags) &&
> +              !test_bit(Journal, &rdev->flags) &&
> +              !test_bit(Faulty, &rdev->flags);
> +}
> +
>  static int remove_and_add_spares(struct mddev *mddev,
>                                  struct md_rdev *this)
>  {
> @@ -9217,13 +9225,10 @@ static int remove_and_add_spares(struct mddev *md=
dev,
>         rdev_for_each(rdev, mddev) {
>                 if (this && this !=3D rdev)
>                         continue;
> +               if (rdev_is_spare(rdev))
> +                       spares++;
>                 if (test_bit(Candidate, &rdev->flags))
>                         continue;

Hi Kuai

Why not put rdev_is_spare after testing Candidate?

Best Regards
Xiao

> -               if (rdev->raid_disk >=3D 0 &&
> -                   !test_bit(In_sync, &rdev->flags) &&
> -                   !test_bit(Journal, &rdev->flags) &&
> -                   !test_bit(Faulty, &rdev->flags))
> -                       spares++;
>                 if (rdev->raid_disk >=3D 0)
>                         continue;
>                 if (test_bit(Faulty, &rdev->flags))
> --
> 2.39.2
>

