Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0878C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 22 Dec 2021 07:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242970AbhLVHZJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Dec 2021 02:25:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:22525 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239225AbhLVHZI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 22 Dec 2021 02:25:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640157907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/+F3RmmopjyDZfmud46qsBBLC0JX2c4pdKIsnigeLX8=;
        b=CYSpcs7baTaLxaKsDdZI8O8J81E5uToQWK1kYsLYLe9le2HgcEJUx4t6z6lAfejxzQc6q7
        B3Ej+ovtZWlWtaMulyI+pp4qjPLzeJ6en77TnhJiqBPG4vAz2U6QL0MK62Dg13RgVWZWhG
        32eA7zJaGs39alCrSvOO8oj3fxcXrYA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-275-IugVMJ8LNc6StAwMkHXpCw-1; Wed, 22 Dec 2021 02:25:06 -0500
X-MC-Unique: IugVMJ8LNc6StAwMkHXpCw-1
Received: by mail-ed1-f71.google.com with SMTP id t1-20020a056402524100b003f8500f6e35so1094580edd.8
        for <linux-raid@vger.kernel.org>; Tue, 21 Dec 2021 23:25:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/+F3RmmopjyDZfmud46qsBBLC0JX2c4pdKIsnigeLX8=;
        b=0Xhkx7+rWKfSoZp+NH2bZw31bJ1x3lZv4nP5kostOlfkUCLJ8qCXX4jC8qPdOvX5Qj
         4g9O7IzjQJk++Cr0ADegrRCT5qmwy2Jl94sQUPPXEp9KoXVUEGBHvIeoAxmxqpx75qEf
         rAT2lxT8sne8iQd5YpFi+rZujxWg1/l+dqfkKtzHGH5NIbJdLWm8LTCAUzN+wANM4qB3
         VXRWnJrui/OslNlaPYP6DJAD4x4GId6ml156WlRTPSRsYz4anV7fmFNJOgqpg8+ozv31
         rd+J55UbPokrOyR2Uvk0m9c3VL3pjA7C/S9HJHw/f6giJwB8Fd1e2Oh51GF583LNo0ol
         VB6Q==
X-Gm-Message-State: AOAM533LnINSJ+vnrL3YrOVJljBxrJFntiaH13ZZw3hKMeXGnNbRlfAM
        KFEeJTO25ANlq2MRXOPfCKo/kStZaRfVcdfcAsPa4QS8BjcTUmRW1qsRh4rniopzhfReP/tZOpu
        vN2F07moRqf+GQDDsDvQEhrRIH6fc9Khb8K9Y4A==
X-Received: by 2002:a17:906:b04c:: with SMTP id bj12mr1416918ejb.716.1640157905296;
        Tue, 21 Dec 2021 23:25:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy4eV9LB9gQsDrVBT14QVoWrpa8iMyGij1/fPcUOXjYhKYGJehh4LfVJhgtj1rIDZgcggysuwDaUY6oUQk6Lzw=
X-Received: by 2002:a17:906:b04c:: with SMTP id bj12mr1416899ejb.716.1640157904965;
 Tue, 21 Dec 2021 23:25:04 -0800 (PST)
MIME-Version: 1.0
References: <20211216145222.15370-1-mariusz.tkaczyk@linux.intel.com> <20211216145222.15370-3-mariusz.tkaczyk@linux.intel.com>
In-Reply-To: <20211216145222.15370-3-mariusz.tkaczyk@linux.intel.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Wed, 22 Dec 2021 15:24:54 +0800
Message-ID: <CALTww29eqakZmp4oiDDZOWZtiz7q2yXCPidBoJVfVpodDcYdzw@mail.gmail.com>
Subject: Re: [PATCH 2/3] md: Set MD_BROKEN for RAID1 and RAID10
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Dec 16, 2021 at 10:53 PM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> There was no direct mechanism to determine raid failure outside
> personality. It was done by checking rdev->flags after executing
> md_error(). If "faulty" was not set then -EBUSY was returned to
> userspace. It causes that mdadm expects -EBUSY if the array
> becomes failed. There are some reasons to not consider this mechanism
> as correct:
> - drive can't be failed for different reasons.
> - there are path where -EBUSY is not reported and drive removal leads
> to failed array, without notification for userspace.
> - in the array failure case -EBUSY seems to be wrong status. Array is
> not busy, but removal process cannot proceed safe.
>
> -EBUSY expectation cannot be removed without breaking compatibility
> with userspace, but we can adopt the failed state verification method.
>
> In this patch MD_BROKEN flag support, used to mark non-redundant array
> as dead, is added to RAID1 and RAID10. Support for RAID456 is added in
> next commit.
>
> Now the array failure can be checked, so verify MD_BROKEN flag, however
> still return -EBUSY to userspace.
>
> As in previous commit, it causes that #mdadm --set-faulty is able to
> mark array as failed. Previously proposed workaround is valid if optional
> functionality 9a567843f79("md: allow last device to be forcibly
> removed from RAID1/RAID10.") is disabled.
>
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---
>  drivers/md/md.c     | 17 ++++++++++-------
>  drivers/md/md.h     |  4 ++--
>  drivers/md/raid1.c  |  1 +
>  drivers/md/raid10.c |  1 +
>  4 files changed, 14 insertions(+), 9 deletions(-)
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
> index bc3f2094d0b6..d3a897868695 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -259,8 +259,8 @@ enum mddev_flags {
>         MD_NOT_READY,           /* do_md_run() is active, so 'array_state'
>                                  * must not report that array is ready yet
>                                  */
> -       MD_BROKEN,              /* This is used in RAID-0/LINEAR only, to stop
> -                                * I/O in case an array member is gone/failed.
> +       MD_BROKEN,              /* This is used to stop I/O and mark device as
> +                                * dead in case an array becomes failed.
>                                  */
>  };
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 7dc8026cf6ee..45dc75f90476 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1638,6 +1638,7 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>                  */
>                 conf->recovery_disabled = mddev->recovery_disabled;
>                 spin_unlock_irqrestore(&conf->device_lock, flags);
> +               set_bit(MD_BROKEN, &mddev->flags);
>                 return;
>         }
>         set_bit(Blocked, &rdev->flags);
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index dde98f65bd04..d7cefd212e6b 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1964,6 +1964,7 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
>                  * Don't fail the drive, just return an IO error.
>                  */
>                 spin_unlock_irqrestore(&conf->device_lock, flags);
> +               set_bit(MD_BROKEN, &mddev->flags);
>                 return;
>         }
>         if (test_and_clear_bit(In_sync, &rdev->flags))
> --
> 2.26.2
>

Hi Mariusz

In your first Version, it checks MD_BROKEN in super_written. Does it
need to do this in this version?
From my understanding, it needs to retry the write when failfast is
supported. If it checks MD_BROKEN
in super_written, it can't send re-write anymore. Am I right?

Regards
Xiao

