Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18B2BC433FE
	for <linux-raid@archiver.kernel.org>; Mon, 14 Nov 2022 18:16:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237250AbiKNSQX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Nov 2022 13:16:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238343AbiKNSP7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Nov 2022 13:15:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE45450AC
        for <linux-raid@vger.kernel.org>; Mon, 14 Nov 2022 10:14:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A92D61337
        for <linux-raid@vger.kernel.org>; Mon, 14 Nov 2022 18:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BFC7C433D6
        for <linux-raid@vger.kernel.org>; Mon, 14 Nov 2022 18:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668449679;
        bh=HtSxysEANOg5RYBv3JjPVM1H9TxUUKOXcsAI7MgpXWk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JQfMGr3Qd3EGzhkAYkH0K2wZ2lSlWlfYAiGP+nk58ijK09BGCg3JFkGHWPN2QJZJM
         7UW/QRYYZKIkLwh7hQesAqMqizqf+meD0BTmLnGPcl2qTTU93lPFnacCMrRhLLA6OC
         JKXsQ5qBZUtL4ilq2kpnZDOrdo0sXDrvK8O4+OOuK1ME/Lo3R5aEnUtP/2IPOcW5dV
         7UUiw2VEQytACCh64jl0COW+Jdw8/kj6xZNlPJSlDQNkOFNmd9wkK9GJSxsypgtLHp
         uJ2pIpNAhqp0aYc/7Jx3GaZy2VoxDbcZSLyRyox3E3AXzRA1aSreX3L4MQaatXMI83
         AC2Cd+dL61Wsg==
Received: by mail-ej1-f41.google.com with SMTP id t25so30325595ejb.8
        for <linux-raid@vger.kernel.org>; Mon, 14 Nov 2022 10:14:39 -0800 (PST)
X-Gm-Message-State: ANoB5pknaUbwzUDXRuMoGKpybiiXpuuLU0KQAUcmK2ZN8y9qiOen7J8j
        wM5YsmlWp/PtXYeLyjhrActZPkEtaQVOWgbNtbY=
X-Google-Smtp-Source: AA0mqf43NpiCcZXp2+h/zy2g8izYfzRgGFAVyTWnvQ5r6fWPdyc1bFxrCmmPu6NaAN3bLEZ70uJLcwYg6c6/vgzWlnk=
X-Received: by 2002:a17:906:ad98:b0:7a1:e4c2:fb0a with SMTP id
 la24-20020a170906ad9800b007a1e4c2fb0amr11507746ejb.101.1668449677665; Mon, 14
 Nov 2022 10:14:37 -0800 (PST)
MIME-Version: 1.0
References: <20221024064836.12731-1-xni@redhat.com>
In-Reply-To: <20221024064836.12731-1-xni@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 14 Nov 2022 10:14:25 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7-VaWT1SkuT-Tj_2jGgjso3NJ2hN6v8xUgdCHq3NON_g@mail.gmail.com>
Message-ID: <CAPhsuW7-VaWT1SkuT-Tj_2jGgjso3NJ2hN6v8xUgdCHq3NON_g@mail.gmail.com>
Subject: Re: [PATCH V2 1/1] Add mddev->io_acct_cnt for raid0_quiesce
To:     Xiao Ni <xni@redhat.com>
Cc:     guoqing.jiang@linux.dev, linux-raid@vger.kernel.org,
        ffan@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Xiao,

On Sun, Oct 23, 2022 at 11:48 PM Xiao Ni <xni@redhat.com> wrote:
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

I am very sorry to bring this up late. Have you tested the performance
impact of this change? I am afraid this may introduce some visible
performance regression for very high speed arrays.

Thanks,
Song


>
> Reported-by: Fine Fan <ffan@redhat.com>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
> V2: Move struct mddev* to the start of struct mddev_io_acct
>  drivers/md/md.c    | 13 ++++++++++++-
>  drivers/md/md.h    | 11 ++++++++---
>  drivers/md/raid0.c |  6 ++++++
>  3 files changed, 26 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 6f3b2c1cb6cd..208f69849054 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -685,6 +685,7 @@ void mddev_init(struct mddev *mddev)
>         atomic_set(&mddev->flush_pending, 0);
>         init_waitqueue_head(&mddev->sb_wait);
>         init_waitqueue_head(&mddev->recovery_wait);
> +       init_waitqueue_head(&mddev->wait_io_acct);
>         mddev->reshape_position = MaxSector;
>         mddev->reshape_backwards = 0;
>         mddev->last_sync_action = "none";
> @@ -8618,15 +8619,18 @@ int acct_bioset_init(struct mddev *mddev)
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
> @@ -8635,12 +8639,17 @@ static void md_end_io_acct(struct bio *bio)
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
> +       if (atomic_dec_and_test(&mddev->io_acct_cnt))
> +               if (unlikely(test_bit(MD_QUIESCE, &mddev->flags)))
> +                       wake_up(&mddev->wait_io_acct);
>  }
>
>  /*
> @@ -8660,6 +8669,8 @@ void md_account_bio(struct mddev *mddev, struct bio **bio)
>         md_io_acct = container_of(clone, struct md_io_acct, bio_clone);
>         md_io_acct->orig_bio = *bio;
>         md_io_acct->start_time = bio_start_io_acct(*bio);
> +       md_io_acct->mddev = mddev;
> +       atomic_inc(&mddev->io_acct_cnt);
>
>         clone->bi_end_io = md_end_io_acct;
>         clone->bi_private = md_io_acct;
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index b4e2d8b87b61..a7c89ed53be5 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -255,6 +255,7 @@ struct md_cluster_info;
>   *                array is ready yet.
>   * @MD_BROKEN: This is used to stop writes and mark array as failed.
>   * @MD_DELETED: This device is being deleted
> + * @MD_QUIESCE: This device is being quiesced. Now only raid0 use this flag
>   *
>   * change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is added
>   */
> @@ -272,6 +273,7 @@ enum mddev_flags {
>         MD_NOT_READY,
>         MD_BROKEN,
>         MD_DELETED,
> +       MD_QUIESCE,
>  };
>
>  enum mddev_sb_flags {
> @@ -513,6 +515,8 @@ struct mddev {
>                                                    * metadata and bitmap writes
>                                                    */
>         struct bio_set                  io_acct_set; /* for raid0 and raid5 io accounting */
> +       atomic_t                        io_acct_cnt;
> +       wait_queue_head_t               wait_io_acct;
>
>         /* Generic flush handling.
>          * The last to finish preflush schedules a worker to submit
> @@ -710,9 +714,10 @@ struct md_thread {
>  };
>
>  struct md_io_acct {
> -       struct bio *orig_bio;
> -       unsigned long start_time;
> -       struct bio bio_clone;
> +       struct mddev    *mddev;
> +       struct bio      *orig_bio;
> +       unsigned long   start_time;
> +       struct bio      bio_clone;
>  };
>
>  #define THREAD_WAKEUP  0
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 857c49399c28..aced0ad8cdab 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -754,6 +754,12 @@ static void *raid0_takeover(struct mddev *mddev)
>
>  static void raid0_quiesce(struct mddev *mddev, int quiesce)
>  {
> +       /* It doesn't use a separate struct to count how many bios are submitted
> +        * to member disks to avoid memory alloc and performance decrease
> +        */
> +       set_bit(MD_QUIESCE, &mddev->flags);
> +       wait_event(mddev->wait_io_acct, !atomic_read(&mddev->io_acct_cnt));
> +       clear_bit(MD_QUIESCE, &mddev->flags);
>  }
>
>  static struct md_personality raid0_personality=
> --
> 2.32.0 (Apple Git-132)
>
