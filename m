Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C72CECAAD8
	for <linux-raid@archiver.kernel.org>; Wed, 21 Sep 2022 21:26:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbiIUVZh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Sep 2022 17:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiIUVZV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 21 Sep 2022 17:25:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E2852FE3
        for <linux-raid@vger.kernel.org>; Wed, 21 Sep 2022 14:25:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A19EC62CC9
        for <linux-raid@vger.kernel.org>; Wed, 21 Sep 2022 21:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11546C433C1
        for <linux-raid@vger.kernel.org>; Wed, 21 Sep 2022 21:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663795519;
        bh=XnB/c8NEjnEIB+B7lPtKvx9PnVdfij5fdX6wSwnk7/k=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BlMMhxpiq16mHPAc/30DjdxKa/dZWotQQif/Q3ZF5/uxZ7BCP4StgXf1cZkbJkWzr
         LQkdMyLlMexmARA41OeEcQXVLaiSzsQ5giMVbQIAoPLNG4Uh35n5RVu1utWWc+hWgJ
         kwcWrBx4sdoXYoAB4Glj2g7qaVRRh6yqq20YgvLKOrQgPhMCMEc9F3tTNyn1e1jCkq
         81aaiSpqbi4bhoyczm5fPZyrxz+4aU80Vxt5RPplFdYRb2QtNkRqoZ0ostQZZRnJ1F
         YdRQThOb7etZdgyeVImHYuIQC4OC4BO3xISRDzz4garujvdCtsTbEk5NB2MF3S7A+Y
         vp090KSFbV4WA==
Received: by mail-ed1-f52.google.com with SMTP id x21so3627288edd.11
        for <linux-raid@vger.kernel.org>; Wed, 21 Sep 2022 14:25:18 -0700 (PDT)
X-Gm-Message-State: ACrzQf1U0sUGqSrdGqV9f8KgOrU6hcB7rUAHUFaReVVD6dBccR0mIrPr
        WSKcqJfwN/YEIMFtLJi/N4y3WXp+G5O7jsXHOc4=
X-Google-Smtp-Source: AMsMyM4qgdtdi330agjZjk07Jfhxgq3bzNyU1GNX65zXzWJIsSlh5csIlZllU5nG9l1fT72NfaAY/3HmzV9JlYpbwPE=
X-Received: by 2002:a05:6402:2994:b0:453:4c5c:d31c with SMTP id
 eq20-20020a056402299400b004534c5cd31cmr86084edb.412.1663795517182; Wed, 21
 Sep 2022 14:25:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220921133347.29270-1-mateusz.grzonka@intel.com>
In-Reply-To: <20220921133347.29270-1-mateusz.grzonka@intel.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 21 Sep 2022 14:25:05 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4CUiJcRLMYwWV_6wcB-wOEEVjgw6Fn52k-AqJ+D5QfHg@mail.gmail.com>
Message-ID: <CAPhsuW4CUiJcRLMYwWV_6wcB-wOEEVjgw6Fn52k-AqJ+D5QfHg@mail.gmail.com>
Subject: Re: [PATCH v2] md: generate CHANGE uevents for md device
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Sep 21, 2022 at 6:50 AM Mateusz Grzonka
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

Applied to md-next. Thanks!

Song

> ---
>  drivers/md/md.c     | 31 ++++++++++++++++---------------
>  drivers/md/md.h     |  2 +-
>  drivers/md/raid10.c |  2 +-
>  drivers/md/raid5.c  |  2 +-
>  4 files changed, 19 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 9dc0175280b4..47c1cde56783 100644
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
> @@ -2852,7 +2853,7 @@ static int add_bound_rdev(struct md_rdev *rdev)
>         if (mddev->degraded)
>                 set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>         set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> -       md_new_event();
> +       md_new_event(mddev);
>         md_wakeup_thread(mddev->thread);
>         return 0;
>  }
> @@ -2972,7 +2973,7 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
>                                         set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>                                         md_wakeup_thread(mddev->thread);
>                                 }
> -                               md_new_event();
> +                               md_new_event(mddev);
>                         }
>                 }
>         } else if (cmd_match(buf, "writemostly")) {
> @@ -4070,7 +4071,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
>         if (!mddev->thread)
>                 md_update_sb(mddev, 1);
>         sysfs_notify_dirent_safe(mddev->sysfs_level);
> -       md_new_event();
> +       md_new_event(mddev);
>         rv = len;
>  out_unlock:
>         mddev_unlock(mddev);
> @@ -4590,7 +4591,7 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
>                 export_rdev(rdev);
>         mddev_unlock(mddev);
>         if (!err)
> -               md_new_event();
> +               md_new_event(mddev);
>         return err ? err : len;
>  }
>
> @@ -6024,7 +6025,7 @@ int md_run(struct mddev *mddev)
>         if (mddev->sb_flags)
>                 md_update_sb(mddev, 0);
>
> -       md_new_event();
> +       md_new_event(mddev);
>         return 0;
>
>  bitmap_abort:
> @@ -6411,7 +6412,7 @@ static int do_md_stop(struct mddev *mddev, int mode,
>                 if (mddev->hold_active == UNTIL_STOP)
>                         mddev->hold_active = 0;
>         }
> -       md_new_event();
> +       md_new_event(mddev);
>         sysfs_notify_dirent_safe(mddev->sysfs_state);
>         return 0;
>  }
> @@ -6910,7 +6911,7 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
>                 md_wakeup_thread(mddev->thread);
>         else
>                 md_update_sb(mddev, 1);
> -       md_new_event();
> +       md_new_event(mddev);
>
>         return 0;
>  busy:
> @@ -6991,7 +6992,7 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
>          */
>         set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>         md_wakeup_thread(mddev->thread);
> -       md_new_event();
> +       md_new_event(mddev);
>         return 0;
>
>  abort_export:
> @@ -7973,7 +7974,7 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
>         }
>         if (mddev->event_work.func)
>                 queue_work(md_misc_wq, &mddev->event_work);
> -       md_new_event();
> +       md_new_event(mddev);
>  }
>  EXPORT_SYMBOL(md_error);
>
> @@ -8893,7 +8894,7 @@ void md_do_sync(struct md_thread *thread)
>                 mddev->curr_resync = MD_RESYNC_ACTIVE; /* no longer delayed */
>         mddev->curr_resync_completed = j;
>         sysfs_notify_dirent_safe(mddev->sysfs_completed);
> -       md_new_event();
> +       md_new_event(mddev);
>         update_time = jiffies;
>
>         blk_start_plug(&plug);
> @@ -8964,7 +8965,7 @@ void md_do_sync(struct md_thread *thread)
>                         /* this is the earliest that rebuild will be
>                          * visible in /proc/mdstat
>                          */
> -                       md_new_event();
> +                       md_new_event(mddev);
>
>                 if (last_check + window > io_sectors || j == max_sectors)
>                         continue;
> @@ -9188,7 +9189,7 @@ static int remove_and_add_spares(struct mddev *mddev,
>                         sysfs_link_rdev(mddev, rdev);
>                         if (!test_bit(Journal, &rdev->flags))
>                                 spares++;
> -                       md_new_event();
> +                       md_new_event(mddev);
>                         set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>                 }
>         }
> @@ -9222,7 +9223,7 @@ static void md_start_sync(struct work_struct *ws)
>         } else
>                 md_wakeup_thread(mddev->sync_thread);
>         sysfs_notify_dirent_safe(mddev->sysfs_action);
> -       md_new_event();
> +       md_new_event(mddev);
>  }
>
>  /*
> @@ -9483,7 +9484,7 @@ void md_reap_sync_thread(struct mddev *mddev)
>         set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>         sysfs_notify_dirent_safe(mddev->sysfs_completed);
>         sysfs_notify_dirent_safe(mddev->sysfs_action);
> -       md_new_event();
> +       md_new_event(mddev);
>         if (mddev->event_work.func)
>                 queue_work(md_misc_wq, &mddev->event_work);
>  }
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index b4e2d8b87b61..2a25af01ec72 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -757,7 +757,7 @@ extern int md_super_wait(struct mddev *mddev);
>  extern int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
>                 struct page *page, blk_opf_t opf, bool metadata_op);
>  extern void md_do_sync(struct md_thread *thread);
> -extern void md_new_event(void);
> +extern void md_new_event(struct mddev *mddev);
>  extern void md_allow_write(struct mddev *mddev);
>  extern void md_wait_for_blocked_rdev(struct md_rdev *rdev, struct mddev *mddev);
>  extern void md_set_array_sectors(struct mddev *mddev, sector_t array_sectors);
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 58c711912875..5c858e39c162 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -4697,7 +4697,7 @@ static int raid10_start_reshape(struct mddev *mddev)
>         }
>         conf->reshape_checkpoint = jiffies;
>         md_wakeup_thread(mddev->sync_thread);
> -       md_new_event();
> +       md_new_event(mddev);
>         return 0;
>
>  abort:
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 734f92e75f85..ad3eb87f60b7 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -8577,7 +8577,7 @@ static int raid5_start_reshape(struct mddev *mddev)
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
