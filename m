Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 798D9C433FE
	for <linux-raid@archiver.kernel.org>; Thu, 20 Oct 2022 19:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiJTTWO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 Oct 2022 15:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiJTTWN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 20 Oct 2022 15:22:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C241F8101
        for <linux-raid@vger.kernel.org>; Thu, 20 Oct 2022 12:22:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B36F4B828A0
        for <linux-raid@vger.kernel.org>; Thu, 20 Oct 2022 19:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656B0C433C1
        for <linux-raid@vger.kernel.org>; Thu, 20 Oct 2022 19:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666293729;
        bh=tLN/bvwCjD9mskphLI4GLxNf5lXMyGRzn47ZmjUhUfw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Xox6/Op2N+eW6fqOh2rfJWsU2MrVC/0yVkiieJtJMlBkC0VNaxFLdCVnxq1NdvHht
         ae7hV1RYakKkalWw8LYMsalxbpNTtD6wEPawI42CleLI5ihFvi3DAe4oQUnlLIeIhP
         vCcgfa4Qco/A1UOz8uakJ+FwHVBWTnwMhKnOC3bABv8B2q3qQS1v04fo1sboa/CC7y
         D9Q1SagkMch8spIoIDN0dmB7kfdzayVRgyz2kKanPasIBY8GtvvyZ+LG1WpMBnyDn8
         oTttsWKIyajq+O16mIKO7hK6GvS8gVe/fIvlNTRoKNQ5Bm+xRNqkzomIcKD7DlXS/M
         2fFc2l7Zb5bjg==
Received: by mail-ej1-f49.google.com with SMTP id r17so1886595eja.7
        for <linux-raid@vger.kernel.org>; Thu, 20 Oct 2022 12:22:09 -0700 (PDT)
X-Gm-Message-State: ACrzQf1USbv0t1eVbizQ8lDjkMlBhfsa5nb4avc9KDuw6Pjebj46Zy67
        kmTohMwFshpMekAISdzVyiJ4CCSopQoOCVwJGNk=
X-Google-Smtp-Source: AMsMyM4vS5AoNoLidMUKh6W/I+m7JuefJ5kz3qPZJOQRKLLnBDxB8w3EdbdJHmkK8XKebWUP9uX69hPFUsIXfzyO5gc=
X-Received: by 2002:a17:907:970b:b0:78d:8d70:e4e8 with SMTP id
 jg11-20020a170907970b00b0078d8d70e4e8mr11906503ejc.614.1666293727630; Thu, 20
 Oct 2022 12:22:07 -0700 (PDT)
MIME-Version: 1.0
References: <20221014122210.47888-1-jinpu.wang@ionos.com>
In-Reply-To: <20221014122210.47888-1-jinpu.wang@ionos.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 20 Oct 2022 12:21:55 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7hSruJhubAcmwcpTbGPKXq2H3mBkC3FjBt6mWeZXtyRw@mail.gmail.com>
Message-ID: <CAPhsuW7hSruJhubAcmwcpTbGPKXq2H3mBkC3FjBt6mWeZXtyRw@mail.gmail.com>
Subject: Re: [RFC PATCH] md-bitmap: reuse former bitmap chunk size on resizing.
To:     Jack Wang <jinpu.wang@ionos.com>
Cc:     linux-raid@vger.kernel.org,
        Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Oct 14, 2022 at 5:22 AM Jack Wang <jinpu.wang@ionos.com> wrote:
>
> From: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
>
> On bitmap resizing, attempt to reuse the former chunk size (if any)
> in order to preserve the, ev. on purpose set, chunk size resolution.

Could you please explain more on why we would rather keep the chunk size
instead of recalculating it?

Thanks,
Song

>
> Signed-off-by: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
> Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/md/md-cluster.c |  3 ++-
>  drivers/md/raid1.c      |  3 ++-
>  drivers/md/raid10.c     | 12 ++++++++----
>  drivers/md/raid5.c      |  3 ++-
>  4 files changed, 14 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 10e0c5381d01..9929631bdc94 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -604,7 +604,8 @@ static int process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
>         case BITMAP_RESIZE:
>                 if (le64_to_cpu(msg->high) != mddev->pers->size(mddev, 0, 0))
>                         ret = md_bitmap_resize(mddev->bitmap,
> -                                           le64_to_cpu(msg->high), 0, 0);
> +                                           le64_to_cpu(msg->high),
> +                                           mddev->bitmap_info.chunksize, 0);
>                 break;
>         default:
>                 ret = -1;
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 05d8438cfec8..8f1d25064a53 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -3225,7 +3225,8 @@ static int raid1_resize(struct mddev *mddev, sector_t sectors)
>             mddev->array_sectors > newsize)
>                 return -EINVAL;
>         if (mddev->bitmap) {
> -               int ret = md_bitmap_resize(mddev->bitmap, newsize, 0, 0);
> +               int ret = md_bitmap_resize(mddev->bitmap, newsize,
> +                               mddev->bitmap_info.chunksize, 0);
>                 if (ret)
>                         return ret;
>         }
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 3aa8b6e11d58..8f0453b6e0c6 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -4346,7 +4346,8 @@ static int raid10_resize(struct mddev *mddev, sector_t sectors)
>             mddev->array_sectors > size)
>                 return -EINVAL;
>         if (mddev->bitmap) {
> -               int ret = md_bitmap_resize(mddev->bitmap, size, 0, 0);
> +               int ret = md_bitmap_resize(mddev->bitmap, size,
> +                               mddev->bitmap_info.chunksize, 0);
>                 if (ret)
>                         return ret;
>         }
> @@ -4618,7 +4619,8 @@ static int raid10_start_reshape(struct mddev *mddev)
>                 newsize = raid10_size(mddev, 0, conf->geo.raid_disks);
>
>                 if (!mddev_is_clustered(mddev)) {
> -                       ret = md_bitmap_resize(mddev->bitmap, newsize, 0, 0);
> +                       ret = md_bitmap_resize(mddev->bitmap, newsize,
> +                                       mddev->bitmap_info.chunksize, 0);
>                         if (ret)
>                                 goto abort;
>                         else
> @@ -4640,13 +4642,15 @@ static int raid10_start_reshape(struct mddev *mddev)
>                             MD_FEATURE_RESHAPE_ACTIVE)) || (oldsize == newsize))
>                         goto out;
>
> -               ret = md_bitmap_resize(mddev->bitmap, newsize, 0, 0);
> +               ret = md_bitmap_resize(mddev->bitmap, newsize,
> +                               mddev->bitmap_info.chunksize, 0);
>                 if (ret)
>                         goto abort;
>
>                 ret = md_cluster_ops->resize_bitmaps(mddev, newsize, oldsize);
>                 if (ret) {
> -                       md_bitmap_resize(mddev->bitmap, oldsize, 0, 0);
> +                       md_bitmap_resize(mddev->bitmap, oldsize,
> +                                       mddev->bitmap_info.chunksize, 0);
>                         goto abort;
>                 }
>         }
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 7b820b81d8c2..bff7d3d779ae 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -8372,7 +8372,8 @@ static int raid5_resize(struct mddev *mddev, sector_t sectors)
>             mddev->array_sectors > newsize)
>                 return -EINVAL;
>         if (mddev->bitmap) {
> -               int ret = md_bitmap_resize(mddev->bitmap, sectors, 0, 0);
> +               int ret = md_bitmap_resize(mddev->bitmap, sectors,
> +                               mddev->bitmap_info.chunksize, 0);
>                 if (ret)
>                         return ret;
>         }
> --
> 2.34.1
>
