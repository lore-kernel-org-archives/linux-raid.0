Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B8FC4332F
	for <linux-raid@archiver.kernel.org>; Mon, 31 Jan 2022 08:29:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343932AbiAaI3n (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 31 Jan 2022 03:29:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45593 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343861AbiAaI3l (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 31 Jan 2022 03:29:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643617781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MSGBiX5f85x41zsQ1HchLlF4Pk99BrrfKcKvl+imR+I=;
        b=WPqYh3sYrKs8hm0akHWO3GjLC9XydYZzHsP7vfbYxkhKb0KaXWNwd3aGnq52iYMLpJ9RSJ
        gK2ARg3qYGolzmE8QJ9jYNxw4rZ848sGrrBIa4XSQL8kLmCUwyxN9DHhgcHLIXoU0FaSH1
        Hbp1/nMsyd5WymXuJS4156uieLb9aOM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-216-WRY15thBPCKyisQWtSMm6A-1; Mon, 31 Jan 2022 03:29:39 -0500
X-MC-Unique: WRY15thBPCKyisQWtSMm6A-1
Received: by mail-ed1-f71.google.com with SMTP id i22-20020a0564020f1600b00407b56326a2so6576814eda.18
        for <linux-raid@vger.kernel.org>; Mon, 31 Jan 2022 00:29:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MSGBiX5f85x41zsQ1HchLlF4Pk99BrrfKcKvl+imR+I=;
        b=Cx0sKfkAxe0NC3C7s+mmOYZ7/rYzuprqKUiHzIieqUwom4oESeFiAgKZ6TV0tqGWRk
         GakGcdQawR/NqfirNrtyy5Bm9IiIcB4+u+waVbfFCNzEW5rmk4BoAh9CzhgO5EGdejxl
         WropsStMVI8jf2SU23ds87AgayMLhG3V+BzJJRUhPUJrW1DIDrC+5yKaqMOtY+BLXC+a
         g0p+McztqSC2M9goioE0F0ZiaW/0sALxM3IHIcxunEh0kilKTiYqvMV+PKQLuUP4sfHD
         fg+Khi5skQPM4tZD0GX6jK7/2zUfELCMmJtk6rbXs5DenP6CeN0tmyCM6r7birqO4t1x
         T5FQ==
X-Gm-Message-State: AOAM531rxwVn1tpoAFY+SirYJqcmWfaDc3poxvhucnDSwnpD3pAmrBX4
        44HsSHBTowGTt2MKPf44iVKgmMvwSN95ky3GGv1ATG44Vh7OJq3r0/+ptTBe9eRt6IacPFB2XNo
        jlRnb/FJH3MxeUdVMyMyH97r91207FH3gNXuKLw==
X-Received: by 2002:a05:6402:5110:: with SMTP id m16mr19973448edd.325.1643617778568;
        Mon, 31 Jan 2022 00:29:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwb+PsPtlNL9PuVie9wSfY58eoqC5dDTZXI9CzTqNObVNtyyoe9ROPB+D13pOkQDb2K6XnfW5/LEqQjJAVTdRc=
X-Received: by 2002:a05:6402:5110:: with SMTP id m16mr19973437edd.325.1643617778302;
 Mon, 31 Jan 2022 00:29:38 -0800 (PST)
MIME-Version: 1.0
References: <20220127153912.26856-1-mariusz.tkaczyk@linux.intel.com> <20220127153912.26856-3-mariusz.tkaczyk@linux.intel.com>
In-Reply-To: <20220127153912.26856-3-mariusz.tkaczyk@linux.intel.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Mon, 31 Jan 2022 16:29:27 +0800
Message-ID: <CALTww2_pHsq+=bY4CtimwxvarxQBM0ey7Y3xAfa0dwoJytU9kQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] md: Set MD_BROKEN for RAID1 and RAID10
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Jan 27, 2022 at 11:39 PM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> There is no direct mechanism to determine raid failure outside
> personality. It is done by checking rdev->flags after executing
> md_error(). If "faulty" flag is not set then -EBUSY is returned to
> userspace. -EBUSY means that array will be failed after drive removal.
>
> Mdadm has special routine to handle the array failure and it is executed
> if -EBUSY is returned by md.
>
> There are at least two known reasons to not consider this mechanism
> as correct:
> 1. drive can be removed even if array will be failed[1].
> 2. -EBUSY seems to be wrong status. Array is not busy, but removal
>    process cannot proceed safe.
>
> -EBUSY expectation cannot be removed without breaking compatibility
> with userspace. In this patch first issue is resolved by adding support
> for MD_BROKEN flag for RAID1 and RAID10. Support for RAID456 is added in
> next commit.
>
> The idea is to set the MD_BROKEN if we are sure that raid is in failed
> state now. This is done in each error_handler(). In md_error() MD_BROKEN
> flag is checked. If is set, then -EBUSY is returned to userspace.
>
> As in previous commit, it causes that #mdadm --set-faulty is able to
> fail array. Previously proposed workaround is valid if optional
> functionality[1] is disabled.
>
> [1] commit 9a567843f7ce("md: allow last device to be forcibly removed from
>     RAID1/RAID10.")
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---
>  drivers/md/md.c     | 17 ++++++++-----
>  drivers/md/md.h     | 62 +++++++++++++++++++++++++--------------------
>  drivers/md/raid1.c  | 41 +++++++++++++++++-------------
>  drivers/md/raid10.c | 33 ++++++++++++++++--------
>  4 files changed, 91 insertions(+), 62 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index f888ef197765..fda8473f96b8 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2983,10 +2983,11 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
>
>         if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
>                 md_error(rdev->mddev, rdev);
> -               if (test_bit(Faulty, &rdev->flags))
> -                       err = 0;
> -               else
> +
> +               if (test_bit(MD_BROKEN, &rdev->mddev->flags))
>                         err = -EBUSY;
> +               else
> +                       err = 0;
>         } else if (cmd_match(buf, "remove")) {
>                 if (rdev->mddev->pers) {
>                         clear_bit(Blocked, &rdev->flags);
> @@ -7441,7 +7442,7 @@ static int set_disk_faulty(struct mddev *mddev, dev_t dev)
>                 err =  -ENODEV;
>         else {
>                 md_error(mddev, rdev);
> -               if (!test_bit(Faulty, &rdev->flags))
> +               if (test_bit(MD_BROKEN, &mddev->flags))
>                         err = -EBUSY;
>         }
>         rcu_read_unlock();
> @@ -7987,12 +7988,14 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
>         if (!mddev->pers->sync_request)
>                 return;
>
> -       if (mddev->degraded)
> +       if (mddev->degraded && !test_bit(MD_BROKEN, &mddev->flags))
>                 set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>         sysfs_notify_dirent_safe(rdev->sysfs_state);
>         set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> -       set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> -       md_wakeup_thread(mddev->thread);
> +       if (!test_bit(MD_BROKEN, &mddev->flags)) {
> +               set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> +               md_wakeup_thread(mddev->thread);
> +       }
>         if (mddev->event_work.func)
>                 queue_work(md_misc_wq, &mddev->event_work);
>         md_new_event();
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index bc3f2094d0b6..1eb7d0e88cb2 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -234,34 +234,42 @@ extern int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
>                                 int is_new);
>  struct md_cluster_info;
>
> -/* change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is added */
> +/**
> + * enum mddev_flags - md device flags.
> + * @MD_ARRAY_FIRST_USE: First use of array, needs initialization.
> + * @MD_CLOSING: If set, we are closing the array, do not open it then.
> + * @MD_JOURNAL_CLEAN: A raid with journal is already clean.
> + * @MD_HAS_JOURNAL: The raid array has journal feature set.
> + * @MD_CLUSTER_RESYNC_LOCKED: cluster raid only, which means node, already took
> + *                            resync lock, need to release the lock.
> + * @MD_FAILFAST_SUPPORTED: Using MD_FAILFAST on metadata writes is supported as
> + *                         calls to md_error() will never cause the array to
> + *                         become failed.
> + * @MD_HAS_PPL:  The raid array has PPL feature set.
> + * @MD_HAS_MULTIPLE_PPLS: The raid array has multiple PPLs feature set.
> + * @MD_ALLOW_SB_UPDATE: md_check_recovery is allowed to update the metadata
> + *                      without taking reconfig_mutex.
> + * @MD_UPDATING_SB: md_check_recovery is updating the metadata without
> + *                  explicitly holding reconfig_mutex.
> + * @MD_NOT_READY: do_md_run() is active, so 'array_state', ust not report that
> + *                array is ready yet.
> + * @MD_BROKEN: This is used to stop writes and mark array as failed.
> + *
> + * change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is added
> + */
>  enum mddev_flags {
> -       MD_ARRAY_FIRST_USE,     /* First use of array, needs initialization */
> -       MD_CLOSING,             /* If set, we are closing the array, do not open
> -                                * it then */
> -       MD_JOURNAL_CLEAN,       /* A raid with journal is already clean */
> -       MD_HAS_JOURNAL,         /* The raid array has journal feature set */
> -       MD_CLUSTER_RESYNC_LOCKED, /* cluster raid only, which means node
> -                                  * already took resync lock, need to
> -                                  * release the lock */
> -       MD_FAILFAST_SUPPORTED,  /* Using MD_FAILFAST on metadata writes is
> -                                * supported as calls to md_error() will
> -                                * never cause the array to become failed.
> -                                */
> -       MD_HAS_PPL,             /* The raid array has PPL feature set */
> -       MD_HAS_MULTIPLE_PPLS,   /* The raid array has multiple PPLs feature set */
> -       MD_ALLOW_SB_UPDATE,     /* md_check_recovery is allowed to update
> -                                * the metadata without taking reconfig_mutex.
> -                                */
> -       MD_UPDATING_SB,         /* md_check_recovery is updating the metadata
> -                                * without explicitly holding reconfig_mutex.
> -                                */
> -       MD_NOT_READY,           /* do_md_run() is active, so 'array_state'
> -                                * must not report that array is ready yet
> -                                */
> -       MD_BROKEN,              /* This is used in RAID-0/LINEAR only, to stop
> -                                * I/O in case an array member is gone/failed.
> -                                */
> +       MD_ARRAY_FIRST_USE,
> +       MD_CLOSING,
> +       MD_JOURNAL_CLEAN,
> +       MD_HAS_JOURNAL,
> +       MD_CLUSTER_RESYNC_LOCKED,
> +       MD_FAILFAST_SUPPORTED,
> +       MD_HAS_PPL,
> +       MD_HAS_MULTIPLE_PPLS,
> +       MD_ALLOW_SB_UPDATE,
> +       MD_UPDATING_SB,
> +       MD_NOT_READY,
> +       MD_BROKEN,
>  };
>
>  enum mddev_sb_flags {
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 7dc8026cf6ee..b222bafa1196 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1615,30 +1615,37 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
>         seq_printf(seq, "]");
>  }
>
> +/**
> + * raid1_error() - RAID1 error handler.
> + * @mddev: affected md device.
> + * @rdev: member device to remove.
> + *
> + * Error on @rdev is raised and it is needed to be removed from @mddev.
> + * If there are more than one active member, @rdev is always removed.
> + *
> + * If it is the last active member, it depends on &mddev->fail_last_dev:
> + * - if is on @rdev is removed.
> + * - if is off, @rdev is not removed, but recovery from it is disabled (@rdev is
> + *   very likely to fail).
> + * In both cases, &MD_BROKEN will be set in &mddev->flags.
> + */
>  static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>  {
>         char b[BDEVNAME_SIZE];
>         struct r1conf *conf = mddev->private;
>         unsigned long flags;
>
> -       /*
> -        * If it is not operational, then we have already marked it as dead
> -        * else if it is the last working disks with "fail_last_dev == false",
> -        * ignore the error, let the next level up know.
> -        * else mark the drive as failed
> -        */
>         spin_lock_irqsave(&conf->device_lock, flags);
> -       if (test_bit(In_sync, &rdev->flags) && !mddev->fail_last_dev
> -           && (conf->raid_disks - mddev->degraded) == 1) {
> -               /*
> -                * Don't fail the drive, act as though we were just a
> -                * normal single drive.
> -                * However don't try a recovery from this drive as
> -                * it is very likely to fail.
> -                */

Hi Mariusz

From my view, it's better to keep those comments although you add some comments
before the function. These comments are helpful to understand this function.

> -               conf->recovery_disabled = mddev->recovery_disabled;
> -               spin_unlock_irqrestore(&conf->device_lock, flags);
> -               return;
> +
> +       if (test_bit(In_sync, &rdev->flags) &&
> +           (conf->raid_disks - mddev->degraded) == 1) {
> +               set_bit(MD_BROKEN, &mddev->flags);
> +
> +               if (!mddev->fail_last_dev) {
> +                       conf->recovery_disabled = mddev->recovery_disabled;
> +                       spin_unlock_irqrestore(&conf->device_lock, flags);
> +                       return;
> +               }
>         }
>         set_bit(Blocked, &rdev->flags);
>         if (test_and_clear_bit(In_sync, &rdev->flags))
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index dde98f65bd04..7471e20d7cd6 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1945,26 +1945,37 @@ static int enough(struct r10conf *conf, int ignore)
>                 _enough(conf, 1, ignore);
>  }
>
> +/**
> + * raid10_error() - RAID10 error handler.
> + * @mddev: affected md device.
> + * @rdev: member device to remove.
> + *
> + * Error on @rdev is raised and it is needed to be removed from @mddev.
> + * If there is (excluding @rdev) enough members to operate, @rdev is always
s/is/are/g

> + * removed.
> + *
> + * Otherwise, it depends on &mddev->fail_last_dev:
> + * - if is on @rdev is removed.
> + * - if is off, @rdev is not removed.
> + *
> + * In both cases, &MD_BROKEN will be set in &mddev->flags.
> + */
>  static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
>  {
>         char b[BDEVNAME_SIZE];
>         struct r10conf *conf = mddev->private;
>         unsigned long flags;
>
> -       /*
> -        * If it is not operational, then we have already marked it as dead
> -        * else if it is the last working disks with "fail_last_dev == false",
> -        * ignore the error, let the next level up know.
> -        * else mark the drive as failed
> -        */
>         spin_lock_irqsave(&conf->device_lock, flags);
> +
>         if (test_bit(In_sync, &rdev->flags) && !mddev->fail_last_dev
>             && !enough(conf, rdev->raid_disk)) {

The check of mddev->fail_last_dev should be removed here.

> -               /*
> -                * Don't fail the drive, just return an IO error.
> -                */

It's the same. These comments can directly give people notes. raid10 will return
bio here with an error. Is it better to keep them here?

Best Regards
Xiao

> -               spin_unlock_irqrestore(&conf->device_lock, flags);
> -               return;
> +               set_bit(MD_BROKEN, &mddev->flags);
> +
> +               if (!mddev->fail_last_dev) {
> +                       spin_unlock_irqrestore(&conf->device_lock, flags);
> +                       return;
> +               }
>         }
>         if (test_and_clear_bit(In_sync, &rdev->flags))
>                 mddev->degraded++;
> --
> 2.26.2
>

