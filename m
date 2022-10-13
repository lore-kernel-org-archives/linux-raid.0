Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8319DC433FE
	for <linux-raid@archiver.kernel.org>; Thu, 13 Oct 2022 01:17:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiJMBRH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 12 Oct 2022 21:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbiJMBQq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 12 Oct 2022 21:16:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8F0D8EC3
        for <linux-raid@vger.kernel.org>; Wed, 12 Oct 2022 18:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665623649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N0Byx2bgYmFLKlhgaK0IR+lobbgzJzqZq2FLRANpW1w=;
        b=MzxGuZhEjbYcB++/fqY1uTWlCCk5LYVv+qB6eT1lLh0jK+etGtsniGL2PJe2Ps88AlDNJ0
        wbUiXsxSfS+H7k4lsHcLSX7/Ze8pj6afWeDRWyHPRK47woToZcoktK+YiJPuHB/AZaHHQn
        8qOwLXwolGk43xsnDwhTKezSVakauIU=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-629-8Y8Ba6mjNEudHrZXXKtZWg-1; Wed, 12 Oct 2022 20:45:20 -0400
X-MC-Unique: 8Y8Ba6mjNEudHrZXXKtZWg-1
Received: by mail-pj1-f71.google.com with SMTP id bx24-20020a17090af49800b0020d9ac4b475so235062pjb.4
        for <linux-raid@vger.kernel.org>; Wed, 12 Oct 2022 17:45:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N0Byx2bgYmFLKlhgaK0IR+lobbgzJzqZq2FLRANpW1w=;
        b=kGyoa6MAbe0ySQXgmskS9boIK48N/Wmn7h+5YX9D3xXzZ8sq0zQjRWZJXD5cd6Bw3i
         YyCwvKiSDKYJw0XX7WEG8umJYlq8QXbqSiXwrH4Pl/LGlAhxM1ilrPeZgZ70P34PwBmH
         m+o/gEC+AmPXEUpPD7DhhtPOLyK28DtA5y5p0pSSYDpUMUbM4tremyYyKYxnh6at8ich
         JhgVN6FY9gWu75d7zqOzbs4i6rMYtmSD+kH5C/idVvxJ3xEcU9FqLEprk3R23UMEzNUF
         /ea8Dd5K9IvOC0eh9iVBq/yRrMufHnY32ON240K1U74Fw+MhpiH0P/qMDhwoHg1NaqY4
         ytQg==
X-Gm-Message-State: ACrzQf1rQYJAyAtK3W9X0Zucb4oZL2cyeZ9eJONnu58HkdGSV7Qh6WJs
        rWXhgFt/JjolkPDUBczn78mmojy9fNULplSiZ6v1IxXKb2zf+aPjzBNvG8BAxKcPZfnWcATCluf
        uY5pU4VWtW42Ekbw/NDudmHIl5ddLLbk8yc2lhQ==
X-Received: by 2002:a17:90a:eb0b:b0:20c:e5fa:db6d with SMTP id j11-20020a17090aeb0b00b0020ce5fadb6dmr8340451pjz.73.1665621919692;
        Wed, 12 Oct 2022 17:45:19 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4LhWsxc9lJ1ly4HYYIKIWQzp1QAaqQAk+ifzYbLjwRkwIR6xrHk5bYuEGvxJYFnTqFRlLHoXnVzmgvalEwYXo=
X-Received: by 2002:a17:90a:eb0b:b0:20c:e5fa:db6d with SMTP id
 j11-20020a17090aeb0b00b0020ce5fadb6dmr8340429pjz.73.1665621919393; Wed, 12
 Oct 2022 17:45:19 -0700 (PDT)
MIME-Version: 1.0
References: <20221012091151.71241-1-xni@redhat.com>
In-Reply-To: <20221012091151.71241-1-xni@redhat.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Thu, 13 Oct 2022 08:45:07 +0800
Message-ID: <CALTww2_adYGMHo6je2-15oK5bN61k-hZccyG+Qdu6LJw_ap_aQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] Add mddev->io_acct_cnt for raid0_quiesce
To:     song@kernel.org
Cc:     ffan@redhat.com, guoqing.jiang@linux.dev,
        linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Please ignore this patch. Now there is no place to wake up raid0_quiesce.
I'll send a new one.

Regards
Xiao

On Wed, Oct 12, 2022 at 5:12 PM Xiao Ni <xni@redhat.com> wrote:
>
> It has added io_acct_set for raid0/raid5 io accounting and it needs to
> alloc md_io_acct in the i/o path. They are free when the bios come back
> from member disks. Now we don't have a method to monitor if those bios
> are all come back. In the takeover process, it needs to free the raid0
> memory resource including the memory pool for md_io_acct. But maybe some
> bios are still not returned. When those bios are returned, it can cause
> panic bcause of introducing NULL pointer or invalid address.
>
> This patch adds io_acct_cnt. So when stopping raid0, it can use this
> to wait until all bios come back.
>
> Reported-by: Fine Fan <ffan@redhat.com>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  drivers/md/md.c    | 10 +++++++++-
>  drivers/md/md.h    |  8 +++++---
>  drivers/md/raid0.c |  8 ++++++++
>  drivers/md/raid0.h |  1 +
>  4 files changed, 23 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 9dc0175280b4..d6e9fa914087 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8600,15 +8600,18 @@ int acct_bioset_init(struct mddev *mddev)
>  {
>         int err = 0;
>
> -       if (!bioset_initialized(&mddev->io_acct_set))
> +       if (!bioset_initialized(&mddev->io_acct_set)) {
> +               atomic_set(&mddev->io_acct_cnt, 0);
>                 err = bioset_init(&mddev->io_acct_set, BIO_POOL_SIZE,
>                         offsetof(struct md_io_acct, bio_clone), 0);
> +       }
>         return err;
>  }
>  EXPORT_SYMBOL_GPL(acct_bioset_init);
>
>  void acct_bioset_exit(struct mddev *mddev)
>  {
> +       WARN_ON(atomic_read(&mddev->io_acct_cnt) != 0);
>         bioset_exit(&mddev->io_acct_set);
>  }
>  EXPORT_SYMBOL_GPL(acct_bioset_exit);
> @@ -8617,12 +8620,15 @@ static void md_end_io_acct(struct bio *bio)
>  {
>         struct md_io_acct *md_io_acct = bio->bi_private;
>         struct bio *orig_bio = md_io_acct->orig_bio;
> +       struct mddev *mddev = md_io_acct->mddev;
>
>         orig_bio->bi_status = bio->bi_status;
>
>         bio_end_io_acct(orig_bio, md_io_acct->start_time);
>         bio_put(bio);
>         bio_endio(orig_bio);
> +
> +       atomic_dec(&mddev->io_acct_cnt);
>  }
>
>  /*
> @@ -8642,6 +8648,8 @@ void md_account_bio(struct mddev *mddev, struct bio **bio)
>         md_io_acct = container_of(clone, struct md_io_acct, bio_clone);
>         md_io_acct->orig_bio = *bio;
>         md_io_acct->start_time = bio_start_io_acct(*bio);
> +       md_io_acct->mddev = mddev;
> +       atomic_inc(&mddev->io_acct_cnt);
>
>         clone->bi_end_io = md_end_io_acct;
>         clone->bi_private = md_io_acct;
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index b4e2d8b87b61..29d30642e13f 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -513,6 +513,7 @@ struct mddev {
>                                                    * metadata and bitmap writes
>                                                    */
>         struct bio_set                  io_acct_set; /* for raid0 and raid5 io accounting */
> +       atomic_t                        io_acct_cnt;
>
>         /* Generic flush handling.
>          * The last to finish preflush schedules a worker to submit
> @@ -710,9 +711,10 @@ struct md_thread {
>  };
>
>  struct md_io_acct {
> -       struct bio *orig_bio;
> -       unsigned long start_time;
> -       struct bio bio_clone;
> +       struct bio      *orig_bio;
> +       unsigned long   start_time;
> +       struct bio      bio_clone;
> +       struct mddev    *mddev;
>  };
>
>  #define THREAD_WAKEUP  0
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 857c49399c28..1d2e098e0d52 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -73,6 +73,8 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
>         *private_conf = ERR_PTR(-ENOMEM);
>         if (!conf)
>                 return -ENOMEM;
> +
> +       init_waitqueue_head(&conf->wait_quiesce);
>         rdev_for_each(rdev1, mddev) {
>                 pr_debug("md/raid0:%s: looking at %pg\n",
>                          mdname(mddev),
> @@ -754,6 +756,12 @@ static void *raid0_takeover(struct mddev *mddev)
>
>  static void raid0_quiesce(struct mddev *mddev, int quiesce)
>  {
> +       struct r0conf *conf = mddev->private;
> +
> +       /* It doesn't use a separate struct to count how many bios are submitted
> +        * to member disks to avoid memory alloc and performance decrease
> +        */
> +       wait_event(conf->wait_quiesce, atomic_read(&mddev->io_acct_cnt) == 0);
>  }
>
>  static struct md_personality raid0_personality=
> diff --git a/drivers/md/raid0.h b/drivers/md/raid0.h
> index 3816e5477db1..560dec93d459 100644
> --- a/drivers/md/raid0.h
> +++ b/drivers/md/raid0.h
> @@ -27,6 +27,7 @@ struct r0conf {
>                                             * by strip_zone->dev */
>         int                     nr_strip_zones;
>         enum r0layout           layout;
> +       wait_queue_head_t       wait_quiesce;
>  };
>
>  #endif
> --
> 2.32.0 (Apple Git-132)
>

