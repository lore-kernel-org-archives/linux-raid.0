Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68CFCC38A02
	for <linux-raid@archiver.kernel.org>; Fri, 28 Oct 2022 21:06:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiJ1VGt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Oct 2022 17:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbiJ1VGs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 28 Oct 2022 17:06:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C782E1DA375
        for <linux-raid@vger.kernel.org>; Fri, 28 Oct 2022 14:06:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 622A462A5B
        for <linux-raid@vger.kernel.org>; Fri, 28 Oct 2022 21:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6206C433D6
        for <linux-raid@vger.kernel.org>; Fri, 28 Oct 2022 21:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666991206;
        bh=dqrge/6wSPt2L6e3VfvFj7+GHwe4RqCdysBSm+6dOLY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bKVpx1f49ojuwMZLhiD0D//3Lj4ejA7rjUFjL6yq+QMP4S59m19lxFcnA3CN/IZYI
         AhGZsKROlO5GLMNFzTu93kAmXU2J5GwpFbNdxJZgMPht+YN0H2RwVU/+XDH3igfN7K
         TFPpJ4oB9KmQSKJvkuGs1D7GqIXYdNOlaT+isoMsiGzl3RdXysh2Qtv9Id4vtbl/Mo
         XdZThTxlfDOPrqAOVfGnS2DfiX0p1xVvSvTQMEt8C1lNaLSufYdBfwYZwtKpDNYfyc
         dmLTR/Cc8A2CaHsJHQJra1ovNz55uN3tfi8aNE0fQplLCU41SRtUH9rHnkAM15pKLI
         yA5Qmg08yTXiQ==
Received: by mail-ej1-f44.google.com with SMTP id t25so15806385ejb.8
        for <linux-raid@vger.kernel.org>; Fri, 28 Oct 2022 14:06:46 -0700 (PDT)
X-Gm-Message-State: ACrzQf2HExFpVQErK4tUsR99YGBpuLZXe6/DyIOO9kvdyEM1vlZQPXGa
        DCsmc2MpB1P5HR9xDZwoMtX+w4R+sB9R9qMlu9c=
X-Google-Smtp-Source: AMsMyM6PvWaq0HFjb9xUUOCwWYppgS7b8zmA3RBcMdLnv67feSNxAT7TreEn6m4meiDIzzTKcIHkdJuieqLW4fS6ZEk=
X-Received: by 2002:a17:907:628f:b0:72f:58fc:3815 with SMTP id
 nd15-20020a170907628f00b0072f58fc3815mr1084896ejc.719.1666991204959; Fri, 28
 Oct 2022 14:06:44 -0700 (PDT)
MIME-Version: 1.0
References: <20221024064836.12731-1-xni@redhat.com>
In-Reply-To: <20221024064836.12731-1-xni@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 28 Oct 2022 14:06:33 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4z1vG1QKGMapwttEHRHW3BJ3NubWW-axmhowSUDc4HjQ@mail.gmail.com>
Message-ID: <CAPhsuW4z1vG1QKGMapwttEHRHW3BJ3NubWW-axmhowSUDc4HjQ@mail.gmail.com>
Subject: Re: [PATCH V2 1/1] Add mddev->io_acct_cnt for raid0_quiesce
To:     Xiao Ni <xni@redhat.com>
Cc:     guoqing.jiang@linux.dev, linux-raid@vger.kernel.org,
        ffan@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

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
>
> Reported-by: Fine Fan <ffan@redhat.com>
> Signed-off-by: Xiao Ni <xni@redhat.com>

Applied to md-next. Thanks!
Song


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
