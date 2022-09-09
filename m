Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22732ECAAA1
	for <linux-raid@archiver.kernel.org>; Fri,  9 Sep 2022 14:49:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbiIIOtz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 9 Sep 2022 10:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbiIIOtx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 9 Sep 2022 10:49:53 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0284660E
        for <linux-raid@vger.kernel.org>; Fri,  9 Sep 2022 07:49:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 530F2CE215C
        for <linux-raid@vger.kernel.org>; Fri,  9 Sep 2022 14:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92867C433C1
        for <linux-raid@vger.kernel.org>; Fri,  9 Sep 2022 14:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662734982;
        bh=+VEqGolzVQaCNu7bfmRTJnRQ/bz7MADET15Ttnhs5Xs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gCddAyyLGdWF9I2tfCfDxhz4MMiY3l5N2SN1iLfvJHzmz6TM9ihX8UFIwDwG/ubwl
         QCwH0qllVBP7ShSMaZnVdPEjt6q1tHQTBIj0fV9Y+dsA3MtBUTIMK5/umltUVN+2Cq
         N+uwiRZ6R+uJTz8hP5d9pgU+QibcXRdvHLKdh7/76jCYoX95I99ApJc3i/PzSBPp4F
         cEOTWOPNQN5GH46+xpwFidYqa843X1n6KAN5Aey2VEypCyTkIMXOWQO261t/xo+PgH
         gI5RKRJVLmTjH04lm2t1tDAhsIFIiyPefRbxgBVPRG1v4otja/p3diX4O5kobX+lEj
         Qt9McD+OVA/mg==
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-11eab59db71so4420882fac.11
        for <linux-raid@vger.kernel.org>; Fri, 09 Sep 2022 07:49:42 -0700 (PDT)
X-Gm-Message-State: ACgBeo0+fmdl7WQOqvFDZB2zTz5hzlQCkEnFR2XS2orDl2yfu/h75b61
        cu38eSj1Fbkn/FbeSGIUJMFDVLXC09wpQpW3Qek=
X-Google-Smtp-Source: AA6agR79HqCJfGZ76Pfa6tXlnBZHfff9dx4AQHgjO8FlDlFUy0QTrhxI81LaxEnnH4bmbBCjCd3QxYBQt/ITAEJsx0o=
X-Received: by 2002:a05:6870:3127:b0:11c:8c2c:9015 with SMTP id
 v39-20020a056870312700b0011c8c2c9015mr4933813oaa.31.1662734980741; Fri, 09
 Sep 2022 07:49:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220907132048.14241-1-mateusz.grzonka@intel.com>
In-Reply-To: <20220907132048.14241-1-mateusz.grzonka@intel.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 9 Sep 2022 15:49:27 +0100
X-Gmail-Original-Message-ID: <CAPhsuW51W3v=62YkES74y3ZfZ8u=pgMm5bXc3b2dcjK5X_sfcA@mail.gmail.com>
Message-ID: <CAPhsuW51W3v=62YkES74y3ZfZ8u=pgMm5bXc3b2dcjK5X_sfcA@mail.gmail.com>
Subject: Re: [PATCH] md: generate CHANGE uevents for md device
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Sep 7, 2022 at 2:38 PM Mateusz Grzonka
<mateusz.grzonka@intel.com> wrote:
>
> Due to changes in mdadm event handling and moving to udev based
> approach [1], more CHANGE uevents need to be added.
>
> Generate CHANGE uevents to give a udev based software (e.g. mdmonitor)
> chance to see changes in case of any array reconfiguration.
> Add emitting a new CHANGE uevent into md_new_event() to keep consistency
> with currently used mdstat based approach.
>
> [1] https://lore.kernel.org/linux-raid/20220907125657.12192-1-mateusz.grzonka@intel.com/
>
> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>

This doesn't apply cleanly on top of md-next. Could you please rebase
and resend?

Thanks,
Song

> ---
>  drivers/md/md.c     | 31 ++++++++++++++++---------------
>  drivers/md/md.h     |  2 +-
>  drivers/md/raid10.c |  2 +-
>  drivers/md/raid5.c  |  2 +-
>  4 files changed, 19 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 8273ac5eef06..50587938fddd 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -354,10 +354,11 @@ static bool create_on_open = true;
>   */
>  static DECLARE_WAIT_QUEUE_HEAD(md_event_waiters);
>  static atomic_t md_event_count;
> -void md_new_event(void)
> +void md_new_event(struct mddev *mddev)
>  {
>         atomic_inc(&md_event_count);
>         wake_up(&md_event_waiters);
> +       kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
>  }
>  EXPORT_SYMBOL_GPL(md_new_event);
>
> @@ -2878,7 +2879,7 @@ static int add_bound_rdev(struct md_rdev *rdev)
>         if (mddev->degraded)
>                 set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>         set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> -       md_new_event();
> +       md_new_event(mddev);
>         md_wakeup_thread(mddev->thread);
>         return 0;
>  }
> @@ -2998,7 +2999,7 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
>                                         set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>                                         md_wakeup_thread(mddev->thread);
>                                 }
> -                               md_new_event();
> +                               md_new_event(mddev);
>                         }
>                 }
>         } else if (cmd_match(buf, "writemostly")) {
> @@ -4100,7 +4101,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
>         if (!mddev->thread)
>                 md_update_sb(mddev, 1);
>         sysfs_notify_dirent_safe(mddev->sysfs_level);
> -       md_new_event();
> +       md_new_event(mddev);
>         rv = len;
>  out_unlock:
>         mddev_unlock(mddev);
> @@ -4620,7 +4621,7 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
>                 export_rdev(rdev);
>         mddev_unlock(mddev);
>         if (!err)
> -               md_new_event();
> +               md_new_event(mddev);
>         return err ? err : len;
>  }
>
> @@ -6031,7 +6032,7 @@ int md_run(struct mddev *mddev)
>         if (mddev->sb_flags)
>                 md_update_sb(mddev, 0);
>
> -       md_new_event();
> +       md_new_event(mddev);
>         return 0;
>
>  bitmap_abort:
> @@ -6417,7 +6418,7 @@ static int do_md_stop(struct mddev *mddev, int mode,
>                 if (mddev->hold_active == UNTIL_STOP)
>                         mddev->hold_active = 0;
>         }
> -       md_new_event();
> +       md_new_event(mddev);
>         sysfs_notify_dirent_safe(mddev->sysfs_state);
>         return 0;
>  }
> @@ -6917,7 +6918,7 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
>                 md_wakeup_thread(mddev->thread);
>         else
>                 md_update_sb(mddev, 1);
> -       md_new_event();
> +       md_new_event(mddev);
>
>         return 0;
>  busy:
> @@ -6998,7 +6999,7 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
>          */
>         set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>         md_wakeup_thread(mddev->thread);
> -       md_new_event();
> +       md_new_event(mddev);
>         return 0;
>
>  abort_export:
> @@ -7980,7 +7981,7 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
>         }
>         if (mddev->event_work.func)
>                 queue_work(md_misc_wq, &mddev->event_work);
> -       md_new_event();
> +       md_new_event(mddev);
>  }
>  EXPORT_SYMBOL(md_error);
>
> @@ -8879,7 +8880,7 @@ void md_do_sync(struct md_thread *thread)
>                 mddev->curr_resync = 3; /* no longer delayed */
>         mddev->curr_resync_completed = j;
>         sysfs_notify_dirent_safe(mddev->sysfs_completed);
> -       md_new_event();
> +       md_new_event(mddev);
>         update_time = jiffies;
>
>         blk_start_plug(&plug);
> @@ -8950,7 +8951,7 @@ void md_do_sync(struct md_thread *thread)
>                         /* this is the earliest that rebuild will be
>                          * visible in /proc/mdstat
>                          */
> -                       md_new_event();
> +                       md_new_event(mddev);
>
>                 if (last_check + window > io_sectors || j == max_sectors)
>                         continue;
> @@ -9174,7 +9175,7 @@ static int remove_and_add_spares(struct mddev *mddev,
>                         sysfs_link_rdev(mddev, rdev);
>                         if (!test_bit(Journal, &rdev->flags))
>                                 spares++;
> -                       md_new_event();
> +                       md_new_event(mddev);
>                         set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>                 }
>         }
> @@ -9208,7 +9209,7 @@ static void md_start_sync(struct work_struct *ws)
>         } else
>                 md_wakeup_thread(mddev->sync_thread);
>         sysfs_notify_dirent_safe(mddev->sysfs_action);
> -       md_new_event();
> +       md_new_event(mddev);
>  }
>
>  /*
> @@ -9471,7 +9472,7 @@ void md_reap_sync_thread(struct mddev *mddev, bool reconfig_mutex_held)
>         /* flag recovery needed just to double check */
>         set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>         sysfs_notify_dirent_safe(mddev->sysfs_action);
> -       md_new_event();
> +       md_new_event(mddev);
>         if (mddev->event_work.func)
>                 queue_work(md_misc_wq, &mddev->event_work);
>  }
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 5f62c46ac2d3..eb401835d29c 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -741,7 +741,7 @@ extern int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
>                         struct page *page, int op, int op_flags,
>                         bool metadata_op);
>  extern void md_do_sync(struct md_thread *thread);
> -extern void md_new_event(void);
> +extern void md_new_event(struct mddev *mddev);
>  extern void md_allow_write(struct mddev *mddev);
>  extern void md_wait_for_blocked_rdev(struct md_rdev *rdev, struct mddev *mddev);
>  extern void md_set_array_sectors(struct mddev *mddev, sector_t array_sectors);
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index d589f823feb1..4dbf1fff8852 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -4653,7 +4653,7 @@ static int raid10_start_reshape(struct mddev *mddev)
>         }
>         conf->reshape_checkpoint = jiffies;
>         md_wakeup_thread(mddev->sync_thread);
> -       md_new_event();
> +       md_new_event(mddev);
>         return 0;
>
>  abort:
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 5d09256d7f81..7fafb5bcf3db 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -8335,7 +8335,7 @@ static int raid5_start_reshape(struct mddev *mddev)
>         }
>         conf->reshape_checkpoint = jiffies;
>         md_wakeup_thread(mddev->sync_thread);
> -       md_new_event();
> +       md_new_event(mddev);
>         return 0;
>  }
>
> --
> 2.26.2
>
