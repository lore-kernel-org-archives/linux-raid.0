Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 468C6C05027
	for <linux-raid@archiver.kernel.org>; Wed,  1 Feb 2023 07:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbjBAHWU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Feb 2023 02:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbjBAHWT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Feb 2023 02:22:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503F549541
        for <linux-raid@vger.kernel.org>; Tue, 31 Jan 2023 23:22:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47C7160ECA
        for <linux-raid@vger.kernel.org>; Wed,  1 Feb 2023 07:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D75C433EF
        for <linux-raid@vger.kernel.org>; Wed,  1 Feb 2023 07:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675236129;
        bh=rsk2fHnaNnRuH9J/L8fJq+PVzm7N/22Z0mGyjLMc410=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=MWwPJHZl8BZxsKfDqeQONowpCYFjjfnrD6URLspPMD2mnRi1wEpjNRcyf0+5n8o7k
         tUfpfAiEd66TuX9E4NnDcN5mr/p8ioeJ09dBydviXJUBdo7DuDEOMnuyunVz3DIagz
         jPNEqXebCGvZwqWsft9eHUP8UXg8HrRzb6IIgXzFW9mw5Gv5xLIlrj3wk1ED8JHpCn
         8sOkeBw7Q5h1Kytz1KkD5HHLE+/rZzTLR7YxRzLE0gUcQpXbPI5ePWRmbhJsOs4YXE
         xAUlL18m28O/tBOZZb+muHvTF96uU2k0fokNiRyd2vOt0k/51yR3/Lq+Lwerm0biIy
         1M6n8984NPXSg==
Received: by mail-lf1-f54.google.com with SMTP id br9so27924899lfb.4
        for <linux-raid@vger.kernel.org>; Tue, 31 Jan 2023 23:22:09 -0800 (PST)
X-Gm-Message-State: AO0yUKWw5tknFhSCW2BnzfKERYstA7y1MuXsA/DoOJ2Gjf8v+GTqI4wq
        RKGi6SOV9OJsx+Ok1+Om5NCGxQnp+ICe5RRMM70=
X-Google-Smtp-Source: AK7set/e5zThjkz0xyRpLVfNEzK0t2NiCOz2IwLpzPFZPRqk3QvODT1rrYgLfzBTmBn/sIUZDe/rHZ2LbAGexmdob3A=
X-Received: by 2002:ac2:547a:0:b0:4b5:c489:8cf7 with SMTP id
 e26-20020ac2547a000000b004b5c4898cf7mr199167lfn.242.1675236127698; Tue, 31
 Jan 2023 23:22:07 -0800 (PST)
MIME-Version: 1.0
References: <20230201010712.97929-1-xni@redhat.com>
In-Reply-To: <20230201010712.97929-1-xni@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 31 Jan 2023 23:21:55 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4w0aXjP8ziW8H7s1LMLEFUWbEABqJNGvdapAAE_VeK3A@mail.gmail.com>
Message-ID: <CAPhsuW4w0aXjP8ziW8H7s1LMLEFUWbEABqJNGvdapAAE_VeK3A@mail.gmail.com>
Subject: Re: [PATCH V2 1/1] md/raid0: Add mddev->io_acct_cnt for raid0_quiesce
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid@vger.kernel.org, ming.lei@redhat.com,
        ncroxon@redhat.com, heinzm@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Jan 31, 2023 at 5:07 PM Xiao Ni <xni@redhat.com> wrote:
>
> It has added io_acct_set for raid0/raid5 io accounting and it needs to
> alloc md_io_acct in the i/o path. They are free when the bios come back
> from member disks. Now we don't have a method to monitor if those bios
> are all come back. In the takeover process, it needs to free the raid0
> memory resource including the memory pool for md_io_acct. But maybe some
> bios are still not returned. When those bios are returned, it can cause
> panic bcause of introducing NULL pointer or invalid address.

Could you please provide more information about the panic?

Thanks,
Song

>
> This patch adds io_acct_cnt. So when stopping raid0, it can use this
> to wait until all bios come back. And I did a simple performance test
> with fio:
>
> -direct=1 -ioengine=libaio -iodepth=128 -bs=64K -rw=write -numjobs=1
> With the patch set: 2676MB/s, without the patch set: 2670MB/s
> -direct=1 -ioengine=libaio -iodepth=128 -bs=64K -rw=read -numjobs=1
> With the patch set: 4676MB/s, without the patch set: 4654MB/s
>
> Reported-by: Fine Fan <ffan@redhat.com>
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
> v2: Fixes a bug. It needs to check if io_acct is dead state when
> resurrecting
>  drivers/md/md.c    | 23 ++++++++++++++++++++++-
>  drivers/md/md.h    |  9 ++++++---
>  drivers/md/raid0.c |  6 ++++++
>  3 files changed, 34 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0eb31bef1f01..66c3639bdbfd 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -683,6 +683,7 @@ void mddev_init(struct mddev *mddev)
>         atomic_set(&mddev->flush_pending, 0);
>         init_waitqueue_head(&mddev->sb_wait);
>         init_waitqueue_head(&mddev->recovery_wait);
> +       init_waitqueue_head(&mddev->wait_io_acct);
>         mddev->reshape_position = MaxSector;
>         mddev->reshape_backwards = 0;
>         mddev->last_sync_action = "none";
> @@ -8604,13 +8605,28 @@ void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
>  }
>  EXPORT_SYMBOL_GPL(md_submit_discard_bio);
>
> +static void io_acct_release(struct percpu_ref *ref)
> +{
> +       struct mddev *mddev = container_of(ref, struct mddev, io_acct_cnt);
> +
> +       wake_up(&mddev->wait_io_acct);
> +}
> +
>  int acct_bioset_init(struct mddev *mddev)
>  {
>         int err = 0;
>
> -       if (!bioset_initialized(&mddev->io_acct_set))
> +       if (!bioset_initialized(&mddev->io_acct_set)) {
> +               err = percpu_ref_init(&mddev->io_acct_cnt, io_acct_release,
> +                       PERCPU_REF_ALLOW_REINIT, GFP_KERNEL);
> +               if (err)
> +                       return err;
> +
>                 err = bioset_init(&mddev->io_acct_set, BIO_POOL_SIZE,
>                         offsetof(struct md_io_acct, bio_clone), 0);
> +               if (err)
> +                       percpu_ref_exit(&mddev->io_acct_cnt);
> +       }
>         return err;
>  }
>  EXPORT_SYMBOL_GPL(acct_bioset_init);
> @@ -8618,6 +8634,7 @@ EXPORT_SYMBOL_GPL(acct_bioset_init);
>  void acct_bioset_exit(struct mddev *mddev)
>  {
>         bioset_exit(&mddev->io_acct_set);
> +       percpu_ref_exit(&mddev->io_acct_cnt);
>  }
>  EXPORT_SYMBOL_GPL(acct_bioset_exit);
>
> @@ -8625,9 +8642,11 @@ static void md_end_io_acct(struct bio *bio)
>  {
>         struct md_io_acct *md_io_acct = bio->bi_private;
>         struct bio *orig_bio = md_io_acct->orig_bio;
> +       struct mddev *mddev = md_io_acct->mddev;
>
>         orig_bio->bi_status = bio->bi_status;
>
> +       percpu_ref_put(&mddev->io_acct_cnt);
>         bio_end_io_acct(orig_bio, md_io_acct->start_time);
>         bio_put(bio);
>         bio_endio(orig_bio);
> @@ -8650,6 +8669,8 @@ void md_account_bio(struct mddev *mddev, struct bio **bio)
>         md_io_acct = container_of(clone, struct md_io_acct, bio_clone);
>         md_io_acct->orig_bio = *bio;
>         md_io_acct->start_time = bio_start_io_acct(*bio);
> +       md_io_acct->mddev = mddev;
> +       percpu_ref_get(&mddev->io_acct_cnt);
>
>         clone->bi_end_io = md_end_io_acct;
>         clone->bi_private = md_io_acct;
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 6335cb86e52e..c0e869bdde42 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -513,6 +513,8 @@ struct mddev {
>                                                    * metadata and bitmap writes
>                                                    */
>         struct bio_set                  io_acct_set; /* for raid0 and raid5 io accounting */
> +       struct percpu_ref               io_acct_cnt;
> +       wait_queue_head_t               wait_io_acct;
>
>         /* Generic flush handling.
>          * The last to finish preflush schedules a worker to submit
> @@ -710,9 +712,10 @@ struct md_thread {
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
> index b536befd8898..f732ca8e2e1f 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -753,6 +753,12 @@ static void *raid0_takeover(struct mddev *mddev)
>
>  static void raid0_quiesce(struct mddev *mddev, int quiesce)
>  {
> +       if (quiesce) {
> +               percpu_ref_kill(&mddev->io_acct_cnt);
> +               wait_event(mddev->wait_io_acct,
> +                       percpu_ref_is_zero(&mddev->io_acct_cnt));
> +       } else if (percpu_ref_is_dying(&mddev->io_acct_cnt))
> +                       percpu_ref_resurrect(&mddev->io_acct_cnt);
>  }
>
>  static struct md_personality raid0_personality=
> --
> 2.32.0 (Apple Git-132)
>
