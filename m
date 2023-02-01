Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80982C38142
	for <linux-raid@archiver.kernel.org>; Wed,  1 Feb 2023 07:16:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbjBAHQj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Feb 2023 02:16:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBAHQj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Feb 2023 02:16:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C601BE7
        for <linux-raid@vger.kernel.org>; Tue, 31 Jan 2023 23:16:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72901613CA
        for <linux-raid@vger.kernel.org>; Wed,  1 Feb 2023 07:16:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCDC9C433D2
        for <linux-raid@vger.kernel.org>; Wed,  1 Feb 2023 07:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675235796;
        bh=D6oiEMxnEA+XH6YN8o9uoLbripugTe5bSI/QihOQQCo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ECGX2AgAuqk6ws/Lg5+Q8oR50iGrxYvpjsdP+PYODKO1zElF6dq1/HVvSaxbNuSV8
         xpTEblDH/NZJOACta8t3icM1QKncRotcRUQB2LOgRAmCrFD2EdwN5i57R4MOWOgRC4
         m9naL3r4AnqFlTx6MclNYtQdWZ9iDcYrD6KB1ePnWQ13shi5DTbJfIua+omcSFf0FS
         P0Igdkn7HiLxAJAO/BdqjuO8TIzH4Idg9zs15+Jxs7CEYruhDntZtqm3k6G9CQKWsd
         2N9GjE5Wxw0LXYKnzrFDA7WU0huCVAQiUq5ejImWhxN5Ahwq3CZRU8PXXrpOxY/UVK
         U1zgpcB35SZ5g==
Received: by mail-lj1-f169.google.com with SMTP id t12so18389664lji.13
        for <linux-raid@vger.kernel.org>; Tue, 31 Jan 2023 23:16:36 -0800 (PST)
X-Gm-Message-State: AO0yUKUhDWbH4ZGrnFt7NgAd+IVeKzz2e8SzUpzgAtSW7JS3+xUHYV1K
        s2gd+NYTtUrEMSSHC5MM55+AKvOiRgL2W4XcQNk=
X-Google-Smtp-Source: AK7set8vd3kUNrzofxyk7R8FUgB9yJZFe1gHe/NxcvY2kmb118WWBAmjj4uR6AO8gtSonMp8rPe9KGLtUKV14yrG+/U=
X-Received: by 2002:a2e:22c5:0:b0:290:7fb6:a97d with SMTP id
 i188-20020a2e22c5000000b002907fb6a97dmr206880lji.137.1675235794736; Tue, 31
 Jan 2023 23:16:34 -0800 (PST)
MIME-Version: 1.0
References: <20230131051710.87961-1-xni@redhat.com> <20230131051710.87961-3-xni@redhat.com>
In-Reply-To: <20230131051710.87961-3-xni@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 31 Jan 2023 23:16:22 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5v9tduGHLf9ReBvovUU+X+S_WDzDe_92AymPnQOBd3RA@mail.gmail.com>
Message-ID: <CAPhsuW5v9tduGHLf9ReBvovUU+X+S_WDzDe_92AymPnQOBd3RA@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] md: Change active_io to percpu
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid@vger.kernel.org, ming.lei@redhat.com,
        ncroxon@redhat.com, heinzm@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Jan 30, 2023 at 9:17 PM Xiao Ni <xni@redhat.com> wrote:
>
> Now the type of active_io is atomic. It's used to count how many ios are
> in the submitting process and it's added and decreased very time. But it
> only needs to check if it's zero when suspending the raid. So we can
> switch atomic to percpu to improve the performance.
>
> After switching active_io to percpu type, we use the state of active_io
> to judge if the raid device is suspended. And we don't need to wake up
> ->sb_wait in md_handle_request anymore. It's done in the callback function
> which is registered when initing active_io. The argument mddev->suspended
> is only used to count how many users are trying to set raid to suspend
> state.
>
> Signed-off-by: Xiao Ni <xni@redhat.com>

Applied to md-next.

Thanks,
Song

> ---
> v2: remove all rcu api in md_handle_request
>  drivers/md/md.c | 43 ++++++++++++++++++++++++-------------------
>  drivers/md/md.h |  2 +-
>  2 files changed, 25 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d3627aad981a..0eb31bef1f01 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -382,10 +382,7 @@ static DEFINE_SPINLOCK(all_mddevs_lock);
>
>  static bool is_md_suspended(struct mddev *mddev)
>  {
> -       if (mddev->suspended)
> -               return true;
> -       else
> -               return false;
> +       return percpu_ref_is_dying(&mddev->active_io);
>  }
>  /* Rather than calling directly into the personality make_request function,
>   * IO requests come here first so that we can check if the device is
> @@ -412,12 +409,10 @@ static bool is_suspended(struct mddev *mddev, struct bio *bio)
>  void md_handle_request(struct mddev *mddev, struct bio *bio)
>  {
>  check_suspended:
> -       rcu_read_lock();
>         if (is_suspended(mddev, bio)) {
>                 DEFINE_WAIT(__wait);
>                 /* Bail out if REQ_NOWAIT is set for the bio */
>                 if (bio->bi_opf & REQ_NOWAIT) {
> -                       rcu_read_unlock();
>                         bio_wouldblock_error(bio);
>                         return;
>                 }
> @@ -426,23 +421,19 @@ void md_handle_request(struct mddev *mddev, struct bio *bio)
>                                         TASK_UNINTERRUPTIBLE);
>                         if (!is_suspended(mddev, bio))
>                                 break;
> -                       rcu_read_unlock();
>                         schedule();
> -                       rcu_read_lock();
>                 }
>                 finish_wait(&mddev->sb_wait, &__wait);
>         }
> -       atomic_inc(&mddev->active_io);
> -       rcu_read_unlock();
> +       if (!percpu_ref_tryget_live(&mddev->active_io))
> +               goto check_suspended;
>
>         if (!mddev->pers->make_request(mddev, bio)) {
> -               atomic_dec(&mddev->active_io);
> -               wake_up(&mddev->sb_wait);
> +               percpu_ref_put(&mddev->active_io);
>                 goto check_suspended;
>         }
>
> -       if (atomic_dec_and_test(&mddev->active_io) && is_md_suspended(mddev))
> -               wake_up(&mddev->sb_wait);
> +       percpu_ref_put(&mddev->active_io);
>  }
>  EXPORT_SYMBOL(md_handle_request);
>
> @@ -488,11 +479,10 @@ void mddev_suspend(struct mddev *mddev)
>         lockdep_assert_held(&mddev->reconfig_mutex);
>         if (mddev->suspended++)
>                 return;
> -       synchronize_rcu();
>         wake_up(&mddev->sb_wait);
>         set_bit(MD_ALLOW_SB_UPDATE, &mddev->flags);
> -       smp_mb__after_atomic();
> -       wait_event(mddev->sb_wait, atomic_read(&mddev->active_io) == 0);
> +       percpu_ref_kill(&mddev->active_io);
> +       wait_event(mddev->sb_wait, percpu_ref_is_zero(&mddev->active_io));
>         mddev->pers->quiesce(mddev, 1);
>         clear_bit_unlock(MD_ALLOW_SB_UPDATE, &mddev->flags);
>         wait_event(mddev->sb_wait, !test_bit(MD_UPDATING_SB, &mddev->flags));
> @@ -510,6 +500,7 @@ void mddev_resume(struct mddev *mddev)
>         lockdep_assert_held(&mddev->reconfig_mutex);
>         if (--mddev->suspended)
>                 return;
> +       percpu_ref_resurrect(&mddev->active_io);
>         wake_up(&mddev->sb_wait);
>         mddev->pers->quiesce(mddev, 0);
>
> @@ -688,7 +679,6 @@ void mddev_init(struct mddev *mddev)
>         timer_setup(&mddev->safemode_timer, md_safemode_timeout, 0);
>         atomic_set(&mddev->active, 1);
>         atomic_set(&mddev->openers, 0);
> -       atomic_set(&mddev->active_io, 0);
>         spin_lock_init(&mddev->lock);
>         atomic_set(&mddev->flush_pending, 0);
>         init_waitqueue_head(&mddev->sb_wait);
> @@ -5765,6 +5755,12 @@ static void md_safemode_timeout(struct timer_list *t)
>  }
>
>  static int start_dirty_degraded;
> +static void active_io_release(struct percpu_ref *ref)
> +{
> +       struct mddev *mddev = container_of(ref, struct mddev, active_io);
> +
> +       wake_up(&mddev->sb_wait);
> +}
>
>  int md_run(struct mddev *mddev)
>  {
> @@ -5845,10 +5841,15 @@ int md_run(struct mddev *mddev)
>                 nowait = nowait && bdev_nowait(rdev->bdev);
>         }
>
> +       err = percpu_ref_init(&mddev->active_io, active_io_release,
> +                               PERCPU_REF_ALLOW_REINIT, GFP_KERNEL);
> +       if (err)
> +               return err;
> +
>         if (!bioset_initialized(&mddev->bio_set)) {
>                 err = bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
>                 if (err)
> -                       return err;
> +                       goto exit_active_io;
>         }
>         if (!bioset_initialized(&mddev->sync_set)) {
>                 err = bioset_init(&mddev->sync_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
> @@ -6036,6 +6037,8 @@ int md_run(struct mddev *mddev)
>         bioset_exit(&mddev->sync_set);
>  exit_bio_set:
>         bioset_exit(&mddev->bio_set);
> +exit_active_io:
> +       percpu_ref_exit(&mddev->active_io);
>         return err;
>  }
>  EXPORT_SYMBOL_GPL(md_run);
> @@ -6260,6 +6263,7 @@ void md_stop(struct mddev *mddev)
>          */
>         __md_stop_writes(mddev);
>         __md_stop(mddev);
> +       percpu_ref_exit(&mddev->active_io);
>         bioset_exit(&mddev->bio_set);
>         bioset_exit(&mddev->sync_set);
>  }
> @@ -7833,6 +7837,7 @@ static void md_free_disk(struct gendisk *disk)
>         struct mddev *mddev = disk->private_data;
>
>         percpu_ref_exit(&mddev->writes_pending);
> +       percpu_ref_exit(&mddev->active_io);
>         bioset_exit(&mddev->bio_set);
>         bioset_exit(&mddev->sync_set);
>
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 554a9026669a..6335cb86e52e 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -315,7 +315,7 @@ struct mddev {
>         unsigned long                   sb_flags;
>
>         int                             suspended;
> -       atomic_t                        active_io;
> +       struct percpu_ref               active_io;
>         int                             ro;
>         int                             sysfs_active; /* set when sysfs deletes
>                                                        * are happening, so run/
> --
> 2.32.0 (Apple Git-132)
>
